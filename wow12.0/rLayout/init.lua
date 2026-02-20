local addonName, ns = ...

local function OnPlayerLogin()
  ns.SetStateDriver()
  ns.SkinChat()
  ns.DisableCombatFeedback()
end

local function OnPlayerEnteringWorld()
  ns.MoveChat()
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:SetScript("OnEvent", function(_, eventName)
  if eventName == "PLAYER_LOGIN" then
    OnPlayerLogin()
  end
  if eventName == "PLAYER_ENTERING_WORLD" then
    OnPlayerEnteringWorld()
  end
end)

ns.eventFrame = eventFrame