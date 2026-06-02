local A, L = ...

L.eventFrame:RegisterEvent("ADDON_LOADED")
L.eventFrame:SetScript("OnEvent", function(_, event, ...)
  if event == "ADDON_LOADED" then
    local name = ...
    if name ~= L.name then return end
    --LoadDB
    --db data aleardy loaded if ADDON_LOADED fires for the addon
    L.F.LoadDB()
    --RegisterOptionsPanel
    L.F.RegisterOptionsPanel()
    --LoadModuleChat
    if L.DB.settings.modules.chat == true then L.F.LoadModuleChat() end
    --LoadModuleDarkMode
    if L.DB.settings.modules.darkmode == true then L.F.LoadModuleDarkMode() end
    --LoadModuleSpellAlert
    if L.DB.settings.modules.spellalert == true then L.F.LoadModuleSpellAlert() end
    --LoadModuleStateDriver
    if L.DB.settings.modules.statedriver == true then L.F.LoadModuleStateDriver() end
    --LoadModuleTooltip
    if L.DB.settings.modules.tooltip == true then L.F.LoadModuleTooltip() end
    --LoadModuleVignette
    if L.DB.settings.modules.vignette == true then L.F.LoadModuleVignette() end
  end
end)
