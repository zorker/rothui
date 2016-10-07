
-- oUF_Simple: core/spawn
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...
local oUF = L.oUF

-----------------------------
-- oUF Tags
-----------------------------

--tag method: oUF_Simple:health
oUF.Tags.Methods["oUF_Simple:health"] = function(unit)
  if not UnitIsConnected(unit) then
    return "|cff999999Offline|r"
  end
  if(UnitIsDead(unit) or UnitIsGhost(unit)) then
    return "|cff999999Dead|r"
  end
  local hpmin, hpmax = UnitHealth(unit), UnitHealthMax(unit)
  local hpper = 0
  if hpmax > 0 then hpper = floor(hpmin/hpmax*100) end
  return L.F.NumberFormat(hpmin).."|cffcccccc | |r"..hpper.."%"
end
--tag event: oUF_Simple:health
oUF.Tags.Events["oUF_Simple:health"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION"
