local addonName, ns = ...

local function OnPlayerLogin()
  ns.SetStateDriver()
  ns.SkinChat()
  ns.DisableCombatFeedback()
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:SetScript("OnEvent", function(_, eventName)
  if eventName == "PLAYER_LOGIN" then
    OnPlayerLogin()
  end
end)
