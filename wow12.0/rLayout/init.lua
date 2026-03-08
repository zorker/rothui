local addonName, ns = ...

local function OnPlayerLogin()
  ns.SetStateDriver()
  ns.SkinChats()
  ns.DisableCombatFeedback()
end

local function OnVignetteAdded(...)
  ns.AlertVignette(...)
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("VIGNETTE_MINIMAP_UPDATED")
eventFrame:SetScript("OnEvent", function(_, event, ...)
  if event == "PLAYER_LOGIN" then
    OnPlayerLogin()
  elseif event == "VIGNETTE_MINIMAP_UPDATED" then
    OnVignetteAdded(...)
  end
end)

ns.eventFrame = eventFrame