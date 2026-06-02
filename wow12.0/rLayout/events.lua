local A, L = ...

--local function OnPlayerLogin(...)
  --L.F.SetStateDriver()
  --L.F.SkinChats()
  --L.F.DisableCombatFeedback()
  --L.F.DisableObjectiveTracker()
  --L.F.InitDarkMode()
--end

--L.eventFrame:RegisterEvent("PLAYER_LOGIN")
--L.eventFrame:RegisterEvent("VIGNETTE_MINIMAP_UPDATED")
--L.eventFrame:RegisterEvent("UNIT_SPELLCAST_START")
--L.eventFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
--L.eventFrame:RegisterEvent("UNIT_SPELLCAST_EMPOWER_START")
L.eventFrame:RegisterEvent("ADDON_LOADED")
L.eventFrame:SetScript("OnEvent", function(_, event, ...)
  if event == "ADDON_LOADED" then
    local name = ...
    if name == L.name then
      L.F.LoadDB() --db data aleardy loaded if ADDON_LOADED fires for the addon
      L.F.RegisterOptionsPanel()
      if L.S.loadModuleChatSetting:GetValue() == true then
        L.F.LoadModuleChat()
      end
    end
  --elseif event == "PLAYER_LOGIN" then
  --  OnPlayerLogin(...)
  --elseif event == "VIGNETTE_MINIMAP_UPDATED" then
  --  L.F.AlertVignette(...)
  --elseif event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_CHANNEL_START" or event ==  "UNIT_SPELLCAST_EMPOWER_START" then
  --  L.F.PlaySpellAlertSound(...)
  --end
end)
