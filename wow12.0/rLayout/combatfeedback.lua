local addonName, ns = ...

--DisableCombatFeedback
local function DisableCombatFeedback()
  PetFrame:UnregisterEvent("UNIT_COMBAT")
  PlayerFrame:UnregisterEvent("UNIT_COMBAT")
end

ns.DisableCombatFeedback = DisableCombatFeedback