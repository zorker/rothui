  
  --get the addon namespace
  local addon, ns = ...  
  
  --get oUF namespace (just in case needed)
  local oUF = ns.oUF or oUF  
  
  --get the config
  local cfg = ns.cfg
  
  --get the functions
  local func = ns.func
    
  ---------------------------------------------
  -- TAGS
  ---------------------------------------------
  
  --short hp value
  oUF.Tags["diablo_ShortHP"] = function(unit) 
    local v = UnitHealth(unit)
    local string = ""
    if UnitIsDeadOrGhost(unit) == 1 then
      string = "dead"
    elseif UnitIsConnected(unit) == nil then
      string = "off"
    else
      string = func.numFormat(v)
    end  
    return string
  end
  oUF.TagEvents["diablo_ShortHP"] = "UNIT_HEALTH"
  
  oUF.Tags["diablo_MissHP"] = function(unit) 
    local max, min = UnitHealthMax(unit), UnitHealth(unit)
    local v = max-min
    local string = ""
    if UnitIsDeadOrGhost(unit) == 1 then
      string = "dead"
    elseif UnitIsConnected(unit) == nil then
      string = "off"
    elseif v == 0 or v == "0" then
      string = ""
    else
      string = "-"..func.numFormat(v)
    end  
    return string
  end
  oUF.TagEvents["diablo_MissHP"] = "UNIT_HEALTH"
  
  --short power value
  oUF.Tags["diablo_ShortPP"] = function(unit) 
    local string = ""
    local v = UnitMana(unit)
    string = func.numFormat(v)
    return string
  end
  oUF.TagEvents["diablo_ShortPP"] = "UNIT_POWER UNIT_MAXPOWER"
  
