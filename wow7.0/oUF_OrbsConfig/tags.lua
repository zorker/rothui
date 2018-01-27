
-- oUF_OrbsConfig: tags
-- zork, 2018

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Tags
-----------------------------

--tag method: oUF_Orbs:status
L.C.tagMethods["oUF_Orbs:status"] = function(unit)
  if UnitAffectingCombat(unit) then
    return "|TInterface\\CharacterFrame\\UI-StateIcon:20:20:0:0:64:64:33:64:0:31|t"
  elseif unit == "player" and IsResting() then
    return "|TInterface\\CharacterFrame\\UI-StateIcon:20:20:0:0:64:64:0:31:0:31|t"
  end
end
--tag event: oUF_Orbs:status
L.C.tagEvents["oUF_Orbs:status"] = "PLAYER_REGEN_DISABLED PLAYER_REGEN_ENABLED PLAYER_UPDATE_RESTING"