  
  -- // oUF D3Orbs 4.0
  -- // zork - 2010
  
  -----------------------------
  -- INIT
  -----------------------------
  
  --get the addon namespace
  local addon, ns = ...
  
  --get the config values
  local cfg = ns.cfg
  
  --get the functions
  local lib = ns.lib
    
  -----------------------------
  -- TAGS
  -----------------------------
  
  oUF.Tags["d3oShortHP"] = function(unit) 
    local v = UnitHealth(unit)
    local string = ""
    if UnitIsDeadOrGhost(unit) == 1 then
      string = "dead"
    elseif UnitIsConnected(unit) == nil then
      string = "off"
    else
      string = lib.numFormat(v)
    end  
    return string
  end
  oUF.TagEvents["d3oShortHP"] = "UNIT_HEALTH"
  
  
  oUF.Tags["d3oShortPP"] = function(unit) 
    local string = ""
    local v = UnitMana(unit)
    string = lib.numFormat(v)
    return string
  end
  oUF.TagEvents["d3oShortPP"] = "UNIT_POWER UNIT_MAXPOWER"