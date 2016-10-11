
-- oUF_SimpleConfig: tags
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Tags
-----------------------------

local floor = floor

--tag method: oUF_SimpleConfig:health
L.C.tagMethods["oUF_SimpleConfig:health"] = function(unit)
  if not UnitIsConnected(unit) then
    return "|cff999999Offline|r"
  end
  if(UnitIsDead(unit) or UnitIsGhost(unit)) then
    return "|cff999999Dead|r"
  end
  local hpmin, hpmax = UnitHealth(unit), UnitHealthMax(unit)
  local hpper = 0
  if hpmax > 0 then hpper = floor(hpmin/hpmax*100) end
  return hpmin.."|cffcccccc | |r"..hpper.."%"
end
--tag event: oUF_Simple:health
L.C.tagEvents["oUF_SimpleConfig:health"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION"