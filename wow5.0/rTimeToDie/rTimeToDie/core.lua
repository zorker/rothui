
  ---------------------------------------------
  -- rTimeToDie
  ---------------------------------------------

  -- Calculates boss unit death times
  -- zork - 2013

  ---------------------------------------------

  --get the addon namespace
  local addon, ns = ...

  ---------------------------------------------
  -- CONFIG
  ---------------------------------------------

  --config table
  local cfg = {}

  ---------------------------------------------
  -- VARIABLES
  ---------------------------------------------

  --addon frame
  local rTTD = CreateFrame("Frame", "rTimeToDieAddonFrame", UIParent)

  rTTD.units, rTTD.bars = {}, {}

  ---------------------------------------------
  -- FUNCTIONS
  ---------------------------------------------


  --number format func
  function rTTD:ValueFormat = function(v)
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

  --create the corresponding statusbars
  function rTTD:CreateStatusbars()

  end
  --call
  rTTD:CreateStatusbars()

  function rTTD:ClearStatusbar(unit)
    local bar = rTTD.bars[unit]
    if not bar then return end
    --bar:SetMinMaxValues(0,1)
    bar:SetValue(0)
    --bar.name:SetText("")
    --bar.dps:SetText("")
    bar.tdd:SetText("dead")
    --bar.fullTime:SetText("")
  end

  function rTTD:UpdateStatusbar(unit,entry)
    local bar = rTTD.bars[unit]
    if not bar then return end
    bar:SetMinMaxValues(0,entry.fullTime)
    bar:SetValue(entry.ttd)
    local fullTimeString = SecondsToTime(entry.fullTime)
    local tddString = SecondsToTime(entry.ttd)
    local dpsString = rTTD:ValueFormat(entry.dps)
    bar.name:SetText(entry.name)
    bar.dps:SetText(dpsString)
    bar.tdd:SetText(tddString)
    bar.fullTime:SetText(fullTimeString)
  end

  --update health function
  function rTTD:UpdateHealth(...)
    print(...)
    local frame, event, unit = ...
    if not unit or (unit and not UnitExists(unit)) then return end
    if not UnitCanAttack("player", unit) and not UnitIsPlayer(unit) then return end
    local type, id
    if unit:match("(boss)%d?$") == "boss" then
      id = unit:match("boss(%d)")
      type = "boss"
    elseif unit == "target" then
      id = nil
      type = "target"
    elseif unit == "focus" then
      id = nil
      type = "focus"
    else
      return
    end
    local name, guid, hcur, hmax, dead = UnitName(unit), UnitGUID(unit), UnitHealth(unit), UnitHealthMax(unit), UnitIsDead(unit)
    if rTTD.units[guid] and (dead or hcur == 0) then
      --rTTD:ClearStatusbar(unit)
      rTTD.units[guid] = nil
    elseif hcur < hmax and not rTTD.units[guid] and hcur > 0 and not dead then
      local entry = {}
      entry.name = name
      entry.guid = guid
      entry.unit = unit
      entry.firstTime = GetTime()
      entry.firstHealth = hcur
      entry.firstHealthMax = hmax
      entry.firstHealthDiff = (hmax-hcur)
      entry.curHealth = 0
      entry.curHealthMax = 0
      entry.ttd = 0
      entry.dps = 0
      entry.fullTime = 0
      rTTD.units[guid] = entry
    elseif rTTD.units[guid] then
      entry.curHealth = hcur
      entry.curHealthMax = hmax
      local entry = rTTD.units[guid]
      local curTime = GetTime()
      local timeDiff = curTime-entry.firstTime
      local healthDiff = entry.firstHealth-hcur
      if healthDiff == 0 then
        --yada yada
        return
      elseif healthDiff < 0 then
        --unit has healed
        entry.firstHealth = hcur
        entry.firstHealthDiff = (hmax-hcur)
        return
      end
      entry.fullTime = hmax*timeDiff/healthDiff
      local pastTime = entry.firstHealthDiff*timeDiff/healthDiff
      entry.ttd = math.max(entry.firstTime-pastTime+entry.fullTime-curTime,1)
      entry.dps = math.floor(healthDiff/timeDiff)
      rTTD:UpdateStatusbar(unit,entry)
    end
  end

  rTTD:RegisterEvent("UNIT_HEALTH_FREQUENT")
  rTTD:RegisterEvent("UNIT_MAXHEALTH")
  rTTD:SetScript("OnEvent", self.UpdateHealth)
