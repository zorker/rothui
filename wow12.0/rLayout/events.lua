local A, L = ...

local function OnPlayerLogin(...)
  L.F.SetStateDriver()
  L.F.SkinChats()
  L.F.DisableCombatFeedback()
  --L.F.DisableObjectiveTracker()
end

L.eventFrame:RegisterEvent("PLAYER_LOGIN")
L.eventFrame:RegisterEvent("VIGNETTE_MINIMAP_UPDATED")
L.eventFrame:RegisterEvent("UNIT_SPELLCAST_START")
L.eventFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
L.eventFrame:RegisterEvent("UNIT_SPELLCAST_EMPOWER_START")
L.eventFrame:SetScript("OnEvent", function(_, event, ...)
  if event == "PLAYER_LOGIN" then
    OnPlayerLogin(...)
  elseif event == "VIGNETTE_MINIMAP_UPDATED" then
    L.F.AlertVignette(...)
  elseif event == "UNIT_SPELLCAST_START" then
    local unit, _, spellID = ...
    if unit ~= "focus" then return end
    L.F.PlaySpellAlertSound(unit, spellID, false)
  elseif event == "UNIT_SPELLCAST_CHANNEL_START" or event ==  "UNIT_SPELLCAST_EMPOWER_START" then
    local unit, _, spellID = ...
    if unit ~= "focus" then return end
    L.F.PlaySpellAlertSound(unit, spellID, true)
  end
end)
