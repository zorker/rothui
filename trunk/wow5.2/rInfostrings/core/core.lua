
  --get the addon namespace
  local addon, ns = ...
  --get the config values
  local cfg = ns.cfg
  local dragFrameList = ns.dragFrameList

  ---------------------------------------
  -- FUNCTIONS
  ---------------------------------------

  local memformat = function(number)
    if number > 1024 then
      return string.format("%.2fmb", (number / 1024))
    else
      return string.format("%.1fkb", floor(number))
    end
  end

  --number format func
  local numformat = function(v)
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

  --petbattle handler
  local petbattleHandler = CreateFrame("Frame",nil,UIParent)
  petbattleHandler:RegisterEvent("PET_BATTLE_OPENING_START")
  petbattleHandler:RegisterEvent("PET_BATTLE_CLOSE")
  --event
  petbattleHandler:SetScript("OnEvent", function(...)
    local self, event, arg1 = ...
    if event == "PET_BATTLE_OPENING_START" then
      self:Hide()
    elseif event == "PET_BATTLE_CLOSE" then
      self:Show()
    end
  end)

  local frame = CreateFrame("Frame", "rIS_DragFrame", petbattleHandler)
  frame:SetSize(50,50)
  frame:SetScale(cfg.frame.scale)
  frame:SetPoint(cfg.frame.pos.a1,cfg.frame.pos.af,cfg.frame.pos.a2,cfg.frame.pos.x,cfg.frame.pos.y)
  if cfg.frame.userplaced then
    rCreateDragFrame(frame, dragFrameList, -2 , true) --frame, dragFrameList, inset, clamp
  end

  local f1 = CreateFrame("Frame", "rInfoStringsContainer1", frame)
  local f2 = CreateFrame("Frame", "rInfoStringsContainer2", frame)
  local f3 = CreateFrame("Frame", "rInfoStringsContainer3", frame)

  f1:SetPoint("TOP", frame, 0, 0)
  f2:SetPoint("TOP", f1, "BOTTOM", 0, -3)
  f3:SetPoint("TOP", f2, "BOTTOM", 0, -6)

  local function rsiCreateFontString(f,size)
    local t = f:CreateFontString(nil, "BACKGROUND")
    t:SetFont(STANDARD_TEXT_FONT, size, "THINOUTLINE")
    t:SetPoint("CENTER", f)
    return t
  end

  f1.text = rsiCreateFontString(f1,11)
  f2.text = rsiCreateFontString(f2,11)
  f3.text = rsiCreateFontString(f3,11)

  --garbage function from Lyn
  local function rsiClearGarbage()
    UpdateAddOnMemoryUsage()
    local before = gcinfo()
    collectgarbage()
    UpdateAddOnMemoryUsage()
    local after = gcinfo()
    print("Cleaned: "..memformat(before-after))
  end

  f2:EnableMouse(true)
  f2:SetScript("OnMouseDown", function()
    rsiClearGarbage()
  end)

  local addoncompare = function(a, b)
  	return a.memory > b.memory
  end
  local addonlist = 50

  --tooltip function from Lyn
  local function rsiShowMemTooltip(self)
    local color = { r=156/255, g=144/255, b=125/255 }
    GameTooltip:SetOwner(self, "ANCHOR_NONE")
    GameTooltip:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -90, 90)
    local blizz = collectgarbage("count")
    local addons = {}
    local enry, memory
    local total = 0
    local nr = 0
    UpdateAddOnMemoryUsage()
    GameTooltip:AddLine("Top "..addonlist.." AddOns", color.r, color.g, color.b)
    GameTooltip:AddLine(" ")
    for i=1, GetNumAddOns(), 1 do
      if (GetAddOnMemoryUsage(i) > 0 ) then
        memory = GetAddOnMemoryUsage(i)
        entry = {name = GetAddOnInfo(i), memory = memory}
        table.insert(addons, entry)
        total = total + memory
      end
    end
    table.sort(addons, addoncompare)
    for _, entry in pairs(addons) do
      if nr < addonlist then
        GameTooltip:AddDoubleLine(entry.name, memformat(entry.memory), 1, 1, 1, 1, 1, 1)
        nr = nr+1
      end
    end
    GameTooltip:AddLine(" ")
    GameTooltip:AddDoubleLine("Total", memformat(total), color.r, color.g, color.b, color.r, color.g, color.b)
    GameTooltip:AddDoubleLine("Total incl. Blizzard", memformat(blizz), color.r, color.g, color.b, color.r, color.g, color.b)
    GameTooltip:Show()
  end


  f2:SetScript("OnEnter", function() rsiShowMemTooltip(f2) end)
  f2:SetScript("OnLeave", function() GameTooltip:Hide() end)


  local function rsiExpRep()
    local xp = ""

    if not IsXPUserDisabled() and (UnitLevel("player")<MAX_PLAYER_LEVEL) then
      xp = "|c00FA58F4"..numformat(UnitXP("player")).."/"..numformat(UnitXPMax("player")).." |r|c00ffb400("..numformat(GetXPExhaustion() or 0)..")|r|c00FA58F4 | "..string.format("%.0f", (UnitXP("player")/UnitXPMax("player")*100)).."%|r"
    else
      local _, _, minimum, maximum, value = GetWatchedFactionInfo()
      if ((value-minimum)==999) and ((maximum-minimum)==1000) then
        xp = "|c0000FF00MAXED OUT|r"
      else
        xp = "|c0000FF00"..numformat(value-minimum).."/"..numformat(maximum-minimum).." | "..string.format("%.0f", (value-minimum)/(maximum-minimum)*100).."%|r"
      end
    end
    return xp
  end

  local function rsiFPS()
    return floor(GetFramerate()).."fps"
  end

  local function rsiLatency()
    return select(3, GetNetStats()).."ms"
  end

  local function rsiMemory()
    local t = 0
    UpdateAddOnMemoryUsage()
    for i=1, GetNumAddOns(), 1 do
      t = t + GetAddOnMemoryUsage(i)
    end
    return memformat(t)
  end

  local function rsiZoneCoords()
    local zone = ""
    local x, y = GetPlayerMapPosition("player")
    local coords
    if x and y and x ~= 0 and y ~= 0 then
      coords = format("%.2d/%.2d",x*100,y*100)
    end
    if coords then
      zone = "|c00E8B444"..GetMinimapZoneText().." |c009C907D[|c00C9BCA8"..coords.."|c009C907D]|r"
    else
      zone = "|c00E8B444"..GetMinimapZoneText().."|r"
    end
    return zone
  end

  local function rsiMail()
    local mail = (HasNewMail() or 0)
    local mailtext = ""
    if mail>0 then
      mailtext = "|c00FF78F1(New Mail!)|r"
    end
    return mailtext
  end

  local function rsiUpdateStrings()

    f1.text:SetText(rsiZoneCoords())
    f1:SetHeight(f1.text:GetStringHeight())
    f1:SetWidth(f1.text:GetStringWidth())

    f2.text:SetText("|c009C907D"..rsiLatency().." "..rsiFPS().."|r")
    f2:SetHeight(f2.text:GetStringHeight())
    f2:SetWidth(f2.text:GetStringWidth())

    local f3Text = ""
    if cfg.showMail and cfg.showXpRep then
      f3Text = rsiMail().." "..rsiExpRep()
    elseif cfg.showMail then
      f3Text = rsiMail()
    elseif cfg.showXpRep then
      f3Text = rsiExpRep()
    end
    f3.text:SetText(f3Text or "")
    f3:SetHeight(f3.text:GetStringHeight())
    f3:SetWidth(f3.text:GetStringWidth())

  end



  local startSearch = function(self)
    --timer
    local ag = self:CreateAnimationGroup()
    ag.anim = ag:CreateAnimation()
    ag.anim:SetDuration(1)
    ag:SetLooping("REPEAT")
    ag:SetScript("OnLoop", function(self, event, ...)
      rsiUpdateStrings()
    end)
    ag:Play()
  end

  --init
  local a = CreateFrame("Frame")
  a:RegisterEvent("PLAYER_LOGIN")
  a:SetScript("OnEvent", function(self,event,...)
    if event == "PLAYER_LOGIN" then
      startSearch(self)
    end
  end)
