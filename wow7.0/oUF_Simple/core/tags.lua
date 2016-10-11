
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
  return L.F.NumberFormat(hpmin).."|ccccccccc | |r"..hpper.."%"
end
--tag event: oUF_Simple:health
oUF.Tags.Events["oUF_Simple:health"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION"

--load tags from the config
if not L.C.tagMethods and type(L.C.tagMethods) ~= "table" then return end
if not L.C.tagEvents and type(L.C.tagEvents) ~= "table" then return end
for key, value in next, L.C.tagMethods do
  if L.C.tagMethods[key] and L.C.tagEvents[key] then
    oUF.Tags.Methods[key] = L.C.tagMethods[key]
    oUF.Tags.Events[key] = L.C.tagEvents[key]
  end
end
