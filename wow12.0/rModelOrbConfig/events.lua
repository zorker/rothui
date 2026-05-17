local A, L = ...

L.eventFrame:RegisterEvent("PLAYER_LOGIN")
L.eventFrame:RegisterEvent("ADDON_LOADED")
L.eventFrame:SetScript("OnEvent", function(_, event, ...)
  if event == "ADDON_LOADED" then
    local name = ...
    if name == L.name then
      L.F.LoadDB() --db data aleardy loaded if ADDON_LOADED fires for the addon
      L.F.RegisterOptionsPanel()
    end
  elseif event == "PLAYER_LOGIN" then
    --L.F.CreateOrbPreview()
  end
end)
