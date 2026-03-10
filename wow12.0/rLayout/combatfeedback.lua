local A, L = ...

--DisableCombatFeedback
local function DisableCombatFeedback()
  PetFrame:UnregisterEvent("UNIT_COMBAT")
  PlayerFrame:UnregisterEvent("UNIT_COMBAT")
end

L.F.DisableCombatFeedback = DisableCombatFeedback