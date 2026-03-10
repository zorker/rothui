local A, L = ...

local function OnPlayerLogin(...)
  L.F.SetStateDriver()
  L.F.SkinChats()
  L.F.DisableCombatFeedback()
  --L.F.DisableObjectiveTracker()
end

local function OnVignetteAdded(...)
  L.F.AlertVignette(...)
end

L.eventFrame:RegisterEvent("PLAYER_LOGIN")
L.eventFrame:RegisterEvent("VIGNETTE_MINIMAP_UPDATED")
L.eventFrame:SetScript("OnEvent", function(_, event, ...)
  if event == "PLAYER_LOGIN" then
    OnPlayerLogin(...)
  elseif event == "VIGNETTE_MINIMAP_UPDATED" then
    OnVignetteAdded(...)
  end
end)
