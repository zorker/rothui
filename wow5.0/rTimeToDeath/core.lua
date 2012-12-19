
  -- rTimeToDeath
  -- zork - 2012

  ---------------------------------------------
  -- VARIABLES
  ---------------------------------------------

  local max = max

  local bar = CreateFrame("StatusBar", "rTTD_StatusBar", UIParent)
  bar.data = {}

  ---------------------------------------------
  -- FUNCTIONS
  ---------------------------------------------

  --format time func
  local GetFormattedTime = function(time)
    local hr, m, s, text
    if time <= 0 then text = ""
    elseif(time < 3600 and time > 60) then
      hr = floor(time / 3600)
      m = floor(mod(time, 3600) / 60 + 1)
      text = format("%dm", m)
    elseif time < 60 then
      m = floor(time / 60)
      s = mod(time, 60)
      text = (m == 0 and format("%ds", s))
    else
      hr = floor(time / 3600 + 1)
      text = format("%dh", hr)
    end
    return text
  end

  --number format func
  local numFormat = function(v)
    if v > 1E10 then
      return (floor(v/1E9)).."b"
    elseif v > 1E9 then
      return (floor((v/1E9)*10)/10).."b"
    elseif v > 1E7 then
      return (floor(v/1E6)).."m"
    elseif v > 1E6 then
      return (floor((v/1E6)*10)/10).."m"
    elseif v > 1E4 then
      return (floor(v/1E3)).."k"
    elseif v > 1E3 then
      return (floor((v/1E3)*10)/10).."k"
    else
      return v
    end
  end

  --create entry
  local function CreateEntry(guid)
    bar.data[guid] = {}
    local entry = bar.data[guid]
    entry.name = UnitName("target")
    entry.level = UnitLevel("target")
    entry.unitHealth = UnitHealth("target")
    entry.unitHealthMax = UnitHealthMax("target")
    entry.min = 0
    entry.max = 0
    entry.dps = 0
    entry.ttd = 0
    entry.time = GetTime()
    return bar.data[guid]
  end

  function function printValues()
    bar:SetMinMaxValues(entry.min,entry.max)
    bar:SetValue(entry.ttd)
    bar.value:SetText(GetFormattedTime(entry.ttd)." (total: ".GetFormattedTime(entry.max)." / dps: ".numFormat(entry.dps).")")
  end

  --onloop
  local function OnLoop(self,...)
    if not UnitExists("target") or UnitIsFriend("player", "target") or UnitIsPlayer("target") then return end
    local guid = UnitGUID("target")
    if not guid then return end
    if not bar.guid or bar.guid ~= guid then
      bar.name:SetText(entry.name)
      bar.guid = guid
    end
    local entry = bar.data[bar.guid] or CreateEntry(bar.guid)
    if not entry then return end
    local currentTime = GetTime()
    local currentHealth = UnitHealth("target")
    local healthDiff = entry.unitHealth-currentHealth
    local timeDiff

    printValues() --print values

    if currentHealth == 0 then
      return --target is dead we cannot update any values on that
    end

    if healthDiff < 0 then
      --unit got healed, reset
      entry.unitHealth = currentHealth
      entry.time = currentTime
    end

    if currentHealth == entry.unitHealthMax then
      --unit is still at max health, reset
      entry.unitHealth = currentHealth
      entry.time = currentTime
    end

    healthDiff = entry.unitHealth-currentHealth
    timeDiff = currentTime-entry.time

    if healthDiff == 0 or timeDiff == 0 then
      return
    end

    --calculate the full time that would be needed to bring the unit from 100%-0% based on the watched segment
    local time100p = entry.UnitHealthMax*timeDiff/healthDiff

    --the unit may have not been at 100% at the first time seen, thus we need to calculate that time aswell
    local timeMissing = (entry.UnitHealthMax-entry.unitHealth)*timeDiff/healthDiff

    --now we have 3/4 time segments making it possible to calculate the last time segment
    local timeToDeath = max(entry.time-timeMissing+time100p-timeDiff,0)
    local dps = healthDiff/timeDiff

    entry.min = 0
    entry.max = time100p
    entry.ttd = timeToDeath
    entry.dps = dps

    printValues()

  end

  --onevent
  local function OnEvent(self,event,...)
    if event == "PLAYER_REGEN_ENABLED" then
      table.wipe(bar.data)
    end
    if not InCombatLockdown() or not UnitExists("target") or UnitIsFriend("player", "target") or UnitIsPlayer("target") then
      bar.timer:Stop()
      return
    end
    bar.timer:Play()
  end

  --create timer
  do
    local timer = bar:CreateAnimationGroup()
    local anim = timer:CreateAnimation()
    anim:SetDuration(0.3)
    timer:SetLooping("REPEAT")
    timer:SetScript("OnLoop", OnLoop)
    timer.anim = anim
    bar.timer = timer
  end

  --create statusbar
  do

    bar:SetPoint("CENTER",0,0)
    bar:SetSize(200,30)
    bar:SetMinMaxValues(0,1)
    bar:SetValue(0)

    --drag stuff
    bar:SetHitRectInsets(-15,-15,-15,-15)
    bar:SetClampedToScreen(true)
    bar:SetMovable(true)
    bar:SetUserPlaced(true)
    bar:EnableMouse(true)
    bar:RegisterForDrag("LeftButton")
    bar:SetScript("OnDragStart", function(s) s:StartMoving() end)
    bar:SetScript("OnDragStop", function(s) s:StopMovingOrSizing() end)

    --bar tex
    local fill = bar:CreateTexture(nil, "BACKGROUND",nil,-7)
    bg:SetTexture(0,1,0,1)
    bar:SetStatusbarTexture(fill)

    --bar bg
    local bg = bar:CreateTexture(nil, "BACKGROUND",nil,-8)
    bg:SetAllPoints(bar)
    bg:SetTexture(0,0.2,0,0.6)
    bar.bg = bg

    --bar name
    local name = bar:CreateFontString(nil, "BORDER")
    name:SetPoint("TOPLEFT", 0, 0)
    name:SetPoint("TOPRIGHT", 0, 0)
    name:SetFont(STANDARD_TEXT_FONT, 16, "THINOUTLINE")
    bar.name = name

    --bar value
    local value = bar:CreateFontString(nil, "BORDER")
    value:SetPoint("BOTTOMLEFT", 0, 0)
    value:SetPoint("BOTTOMRIGHT", 0, 0)
    value:SetFont(STANDARD_TEXT_FONT, 16, "THINOUTLINE")
    bar.value = value

    bar:SetScript("OnEvent", OnEvent)

    bar:RegisterEvent("PLAYER_REGEN_ENABLED")
    bar:RegisterEvent("PLAYER_REGEN_DISABLED")
    bar:RegisterEvent("PLAYER_TARGET_CHANGED")
    bar:RegisterEvent("PLAYER_ENTERING_WORLD")

  end