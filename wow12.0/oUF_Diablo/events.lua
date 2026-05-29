local A, L = ...

--EventUtil.ContinueOnAddOnLoaded(L.name, function()

L.eventFrame:RegisterEvent("ADDON_LOADED")
L.eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
L.eventFrame:SetScript("OnEvent", function(_, event, ...)
  if event == "ADDON_LOADED" then
    local name = ...
    if name == L.name then
      L.F.LoadDB() --db data aleardy loaded if ADDON_LOADED fires for the addon
      L.F.RegisterOptionsPanel()
      L.F.SpawnUnits()
    end
  elseif event == "PLAYER_ENTERING_WORLD" then
    L.O.playerFrame.Health:ForceUpdate()
    L.O.playerFrame.Power:ForceUpdate()
  end
end)
