
-- oUF_Simple: core/spawn
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...
local oUF = L.oUF or oUF

-----------------------------
-- oUF Tags
-----------------------------

--add player regen to the unitless event tags
oUF.Tags.SharedEvents["PLAYER_REGEN_DISABLED"] = true
oUF.Tags.SharedEvents["PLAYER_REGEN_ENABLED"] = true

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

--tag method: oUF_Simple:role
oUF.Tags.Methods["oUF_Simple:role"] = function(unit)
  local role = UnitGroupRolesAssigned(unit)
  if role == "TANK" then
    return "|TInterface\\LFGFrame\\LFGRole:14:14:0:0:64:16:32:48:0:16|t"
  elseif role == "HEALER" then
    return "|TInterface\\LFGFrame\\LFGRole:14:14:0:0:64:16:48:64:0:16|t"
  --elseif role == "DAMAGER" then
    --return "|TInterface\\LFGFrame\\LFGRole:14:14:0:0:64:16:16:32:0:16|t"
  end
end
--tag event: oUF_Simple:role
oUF.Tags.Events["oUF_Simple:role"] = "PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE"

--tag method: oUF_Simple:leader
oUF.Tags.Methods["oUF_Simple:leader"] = function(unit)
  if UnitIsGroupLeader(unit) then
    return "|TInterface\\GroupFrame\\UI-Group-LeaderIcon:14:14:0:0|t"
  end
end
--tag event: oUF_Simple:leader
oUF.Tags.Events["oUF_Simple:leader"] = "PARTY_LEADER_CHANGED GROUP_ROSTER_UPDATE"

--load tags from the config
if L.C.tagMethods and type(L.C.tagMethods) == "table" and
   L.C.tagEvents  and type(L.C.tagEvents) == "table" then
  for key, value in next, L.C.tagMethods do
    if L.C.tagMethods[key] and L.C.tagEvents[key] then
      oUF.Tags.Methods[key] = L.C.tagMethods[key]
      oUF.Tags.Events[key] = L.C.tagEvents[key]
    end
  end
end