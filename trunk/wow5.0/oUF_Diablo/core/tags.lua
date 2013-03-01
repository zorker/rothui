
  --get the addon namespace
  local addon, ns = ...

  --get oUF namespace (just in case needed)
  local oUF = ns.oUF or oUF

  --get the config
  local cfg = ns.cfg
  --get the database
  local db = ns.db
  --get the functions
  local func = ns.func

  local format, floor = format, floor

  ---------------------------------------------
  -- TAGS
  ---------------------------------------------

  --rgb to hex func
  local function RGBPercToHex(r, g, b)
    r = r <= 1 and r >= 0 and r or 1
    g = g <= 1 and g >= 0 and g or 1
    b = b <= 1 and b >= 0 and b or 1
    return format("%02x%02x%02x", r*255, g*255, b*255)
  end

  ---------------------------------------------

  --color tag
  oUF.Tags.Methods["diablo:color"] = function(unit)
    local color = { r=1, g=1, b=1, }
    if UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit) then
      color = {r = 0.5, g = 0.5, b = 0.5}
    elseif UnitIsPlayer(unit) then
      color = RAID_CLASS_COLORS[select(2, UnitClass(unit))]
    --happiness removed in 4.1
    --elseif UnitIsUnit(unit, "pet") and GetPetHappiness() then
      --color = cfg.happycolors[GetPetHappiness()]
    elseif UnitIsUnit(unit, "target") and UnitIsTapped("target") and not UnitIsTappedByPlayer("target") then
      color = {r = 0.5, g = 0.5, b = 0.5}
    else
      color = FACTION_BAR_COLORS[UnitReaction(unit, "player")]
    end
    if color then
      return RGBPercToHex(color.r,color.g,color.b)
    else
      return "ffffff"
    end
  end

  ---------------------------------------------

  --colorsimple tag
  oUF.Tags.Methods["diablo:colorsimple"] = function(unit)
    local color = { r=1, g=1, b=1, }
    if UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit) then
      color = {r = 0.5, g = 0.5, b = 0.5}
    end
    if color then
      return RGBPercToHex(color.r,color.g,color.b)
    else
      return "ffffff"
    end
  end

  ---------------------------------------------

  --name tag
  oUF.Tags.Methods["diablo:name"] = function(unit, rolf)
    local color = oUF.Tags.Methods["diablo:color"](unit)
    local name = UnitName(rolf or unit)
    return "|cff"..color..(name or "").."|r"
  end
  oUF.Tags.Events["diablo:name"] = "UNIT_NAME_UPDATE UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION"

  ---------------------------------------------

  --hp value
  oUF.Tags.Methods["diablo:hpval"] = function(unit)
    local color = oUF.Tags.Methods["diablo:colorsimple"](unit)
    local hpval
    if UnitIsDeadOrGhost(unit) then
      hpval = "Dead"
    elseif not UnitIsConnected(unit) then
      hpval = "Offline"
    else
      hpval = func.numFormat(UnitHealth(unit) or 0).." / "..oUF.Tags.Methods["perhp"](unit).."%"
    end
    return "|cff"..color..(hpval or "").."|r"
  end
  oUF.Tags.Events["diablo:hpval"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION"

  ---------------------------------------------

  --power value
  oUF.Tags.Methods["diablo:ppval"] = function(unit)
    local ppval = func.numFormat(UnitPower(unit) or 0).." / "..oUF.Tags.Methods["perpp"](unit).."%"
    return ppval or ""
  end
  oUF.Tags.Events["diablo:ppval"] = "UNIT_POWER UNIT_MAXPOWER"

  ---------------------------------------------

  oUF.Tags.Methods["diablo:misshp"] = function(unit)
    local color = oUF.Tags.Methods["diablo:colorsimple"](unit)
    local hpval
    if UnitIsDeadOrGhost(unit) then
      hpval = "Dead"
    elseif not UnitIsConnected(unit) then
      hpval = "Offline"
    else
      local max, min = UnitHealthMax(unit), UnitHealth(unit)
      if max-min > 0 then
        hpval = "-"..func.numFormat(max-min)
      end
    end
    return "|cff"..color..(hpval or "").."|r"
  end
  oUF.Tags.Events["diablo:misshp"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION"

  ---------------------------------------------

  oUF.Tags.Methods["diablo:raidhp"] = function(unit, rolf)
    local color = oUF.Tags.Methods["diablo:color"](unit)
    local hpval
    if UnitIsDeadOrGhost(unit) then
      --hpval = "Dead"
      hpval = UnitName(rolf or unit)
    elseif not UnitIsConnected(unit) then
      hpval = UnitName(rolf or unit)
      --hpval = "Offline"
    else
      local max, min = UnitHealthMax(unit), UnitHealth(unit)
      if max-min > 0 then
        hpval = "-"..func.numFormat(max-min)
        --rewrite color to white
        color = "ffffff"
      else
        hpval = UnitName(rolf or unit)
      end
    end
    return "|cff"..color..(hpval or "").."|r"
  end
  oUF.Tags.Events["diablo:raidhp"] = "UNIT_NAME_UPDATE UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION"

  ---------------------------------------------

  oUF.Tags.Methods["diablo:altbosspower"] = function(unit)
    local cur = UnitPower(unit, ALTERNATE_POWER_INDEX)
    local max = UnitPowerMax(unit, ALTERNATE_POWER_INDEX)
    local color = "0099ff"
    if(max > 0 and not UnitIsDeadOrGhost(unit)) then
      return "|cff"..color..("%s%%"):format(floor(cur/max*100)).."|cff666666 / |r"
    --else
      --return "|cff"..color.."97%".."|cff666666 / |r"
    end
  end
  oUF.Tags.Events["diablo:altbosspower"] = "UNIT_POWER"

  ---------------------------------------------

  oUF.Tags.Methods["diablo:altpower"] = function(unit)
    local cur = UnitPower(unit, ALTERNATE_POWER_INDEX)
    local max = UnitPowerMax(unit, ALTERNATE_POWER_INDEX)
    if cur and cur > 0 and max and max > 0 then
      --return floor(cur).."/"..floor(max).." - "..floor(cur/max*100).."%"
      return floor(cur).." / "..floor(max)
    end
  end
  oUF.Tags.Events["diablo:altpower"] = "UNIT_POWER"

  ---------------------------------------------

  --boss power value
  oUF.Tags.Methods["diablo:bosspp"] = function(unit)
    if UnitIsDeadOrGhost(unit) then return "" end
    local str = ""
    --power value tracking (show percentage if max power > 0)
    local pp_max = UnitPowerMax(unit)
    if pp_max > 0 then
      str = str..oUF.Tags.Methods["perpp"](unit).."%"
    end
    --additional altpower tracking
    local ap_max = UnitPowerMax(unit, ALTERNATE_POWER_INDEX)
    local color = "0099ff"
    if pp_max > 0 and ap_max > 0 then
      str = str.." ("
    end
    if ap_max > 0 then
      local ap_cur = UnitPower(unit, ALTERNATE_POWER_INDEX)
      str = str.."|cff"..color..("%s%%"):format(floor(ap_cur/ap_max*100)).."|r"
    end
    if pp_max > 0 and ap_max > 0 then
      str = str..")"
    end
    --return "93% (|cff"..color..("%s%%"):format(30).."|r)" --debug
    return str or ""
  end
  oUF.Tags.Events["diablo:bosspp"] = "UNIT_POWER UNIT_MAXPOWER"

  ---------------------------------------------

  --topdefhp - the top healthorb value
  oUF.Tags.Methods["topdefhp"] = function(unit)
    local val = oUF.Tags.Methods["perhp"](unit)
    return val or ""
  end
  oUF.Tags.Events["topdefhp"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION"


  ---------------------------------------------

  --botdefhp - the bottom healthorb value
  oUF.Tags.Methods["botdefhp"] = function(unit)
    if UnitIsDeadOrGhost(unit) then
      return  "Dead"
    elseif not UnitIsConnected(unit) then
      return "Offline"
    end
    local val = oUF.Tags.Methods["curhp"](unit)
    val = func.numFormat(val)
    return val or ""
  end
  oUF.Tags.Events["botdefhp"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION"

  ---------------------------------------------

  --topdefpp - the top powerorb value
  oUF.Tags.Methods["topdefpp"] = function(unit)
    --we change power display based on power type
    --for mana users the top display is power percentage for all others it is current power value
    local powertype = select(2, UnitPowerType(unit))
    local val
    if powertype ~= "MANA" then
      val = oUF.Tags.Methods["curpp"](unit)
      val = func.numFormat(val)
    else
      val = oUF.Tags.Methods["perpp"](unit)
    end
    return val or ""
  end
  oUF.Tags.Events["topdefpp"] = "UNIT_DISPLAYPOWER UNIT_POWER UNIT_MAXPOWER UNIT_CONNECTION"

  ---------------------------------------------

  --botdefpp - the bottom powerorb value
  oUF.Tags.Methods["botdefpp"] = function(unit)
    --we change power display based on power type
    --for non-mana users the bottom display is power percentage for mana users it is current power value
    local powertype = select(2, UnitPowerType(unit))
    local val
    if powertype ~= "MANA" then
      val = oUF.Tags.Methods["perpp"](unit)
    else
      val = oUF.Tags.Methods["curpp"](unit)
      val = func.numFormat(val)
    end
    return val or ""
  end
  oUF.Tags.Events["botdefpp"] = "UNIT_DISPLAYPOWER UNIT_POWER UNIT_MAXPOWER UNIT_CONNECTION"

  ---------------------------------------------

  --curshp - curhp short
  oUF.Tags.Methods["curshp"] = function(unit)
    local val = oUF.Tags.Methods["curhp"](unit)
    val = func.numFormat(val)
    return val or ""
  end
  oUF.Tags.Events["curshp"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION"

  ---------------------------------------------

  --maxshp - maxhp short
  oUF.Tags.Methods["maxshp"] = function(unit)
    local val = oUF.Tags.Methods["maxhp"](unit)
    val = func.numFormat(val)
    return val or ""
  end
  oUF.Tags.Events["maxshp"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION"

  ---------------------------------------------

  --cmaxhp - curhp / maxhp
  oUF.Tags.Methods["cmaxhp"] = function(unit)
    local cur = oUF.Tags.Methods["curhp"](unit)
    local max = oUF.Tags.Methods["maxhp"](unit)
    local val = cur.."/"..max
    return val or ""
  end
  oUF.Tags.Events["cmaxhp"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION"

  ---------------------------------------------

  --cmaxshp - curhp / maxhp short
  oUF.Tags.Methods["cmaxshp"] = function(unit)
    local cur = oUF.Tags.Methods["curhp"](unit)
    local max = oUF.Tags.Methods["maxhp"](unit)
    local val = func.numFormat(cur).."/"..func.numFormat(max)
    return val or ""
  end
  oUF.Tags.Events["cmaxshp"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION"

  ---------------------------------------------

  --curspp - curpp short
  oUF.Tags.Methods["curspp"] = function(unit)
    local val = oUF.Tags.Methods["curpp"](unit)
    val = func.numFormat(val)
    return val or ""
  end
  oUF.Tags.Events["curspp"] = "UNIT_DISPLAYPOWER UNIT_POWER UNIT_MAXPOWER UNIT_CONNECTION"

  ---------------------------------------------

  --maxspp - maxpp short
  oUF.Tags.Methods["maxspp"] = function(unit)
    local val = oUF.Tags.Methods["maxpp"](unit)
    val = func.numFormat(val)
    return val or ""
  end
  oUF.Tags.Events["maxspp"] = "UNIT_DISPLAYPOWER UNIT_POWER UNIT_MAXPOWER UNIT_CONNECTION"

  ---------------------------------------------

  --cmaxpp - curpp / maxpp
  oUF.Tags.Methods["cmaxpp"] = function(unit)
    local cur = oUF.Tags.Methods["curpp"](unit)
    local max = oUF.Tags.Methods["maxpp"](unit)
    local val = cur.."/"..max
    return val or ""
  end
  oUF.Tags.Events["cmaxpp"] = "UNIT_DISPLAYPOWER UNIT_POWER UNIT_MAXPOWER UNIT_CONNECTION"

  ---------------------------------------------

  --cmaxspp - curpp / maxpp short
  oUF.Tags.Methods["cmaxspp"] = function(unit)
    local cur = oUF.Tags.Methods["curpp"](unit)
    local max = oUF.Tags.Methods["maxpp"](unit)
    local val = func.numFormat(cur).."/"..func.numFormat(max)
    return val or ""
  end
  oUF.Tags.Events["cmaxspp"] = "UNIT_DISPLAYPOWER UNIT_POWER UNIT_MAXPOWER UNIT_CONNECTION"

  ---------------------------------------------

  --perphp - hp percent with %
  oUF.Tags.Methods["perphp"] = function(unit)
    local val = oUF.Tags.Methods["perhp"](unit).."%"
    return val or ""
  end
  oUF.Tags.Events["perphp"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION"

  ---------------------------------------------

  --perppp - pp percent with %
  oUF.Tags.Methods["perppp"] = function(unit)
    local val = oUF.Tags.Methods["perpp"](unit).."%"
    return val or ""
  end
  oUF.Tags.Events["perppp"] = "UNIT_DISPLAYPOWER UNIT_POWER UNIT_MAXPOWER UNIT_CONNECTION"

  ---------------------------------------------

  --HealthOrbTop
  oUF.Tags.Methods["diablo:HealthOrbTop"] = function(unit)
    if db.char["HEALTH"].value.top.tag == "null" then return "" end
    local methodName = db.char["HEALTH"].value.top.tag.."hp"
    return oUF.Tags.Methods[methodName](unit) or ""
  end
  oUF.Tags.Events["diablo:HealthOrbTop"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION"

  ---------------------------------------------

  --HealthOrbBottom
  oUF.Tags.Methods["diablo:HealthOrbBottom"] = function(unit)
    if db.char["HEALTH"].value.bottom.tag == "null" then return "" end
    local methodName = db.char["HEALTH"].value.bottom.tag.."hp"
    return oUF.Tags.Methods[methodName](unit) or ""
  end
  oUF.Tags.Events["diablo:HealthOrbBottom"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION"

  ---------------------------------------------

  --PowerOrbTop
  oUF.Tags.Methods["diablo:PowerOrbTop"] = function(unit)
    if db.char["HEALTH"].value.top.tag == "null" then return "" end
    local methodName = db.char["POWER"].value.top.tag.."pp"
    return oUF.Tags.Methods[methodName](unit) or ""
  end
  oUF.Tags.Events["diablo:PowerOrbTop"] = "UNIT_DISPLAYPOWER UNIT_POWER UNIT_MAXPOWER UNIT_CONNECTION"


  ---------------------------------------------

  --PowerOrbBottom
  oUF.Tags.Methods["diablo:PowerOrbBottom"] = function(unit)
    if db.char["POWER"].value.bottom.tag == "null" then return "" end
    local methodName = db.char["POWER"].value.bottom.tag.."pp"
    return oUF.Tags.Methods[methodName](unit) or ""
  end
  oUF.Tags.Events["diablo:PowerOrbBottom"] = "UNIT_DISPLAYPOWER UNIT_POWER UNIT_MAXPOWER UNIT_CONNECTION"

  ---------------------------------------------