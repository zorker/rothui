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
    if L.S.loadModuleChatSetting:GetValue() == true then L.F.LoadModuleChat() end
    --LoadModuleDarkMode
    if L.S.loadModuleDarkModeSetting:GetValue() == true then L.F.LoadModuleDarkMode() end
    --LoadModuleSpellAlert
    if L.S.loadModuleSpellAlertSetting:GetValue() == true then L.F.LoadModuleSpellAlert() end
    --LoadModuleStateDriver
    if L.S.loadModuleStateDriverSetting:GetValue() == true then L.F.LoadModuleStateDriver() end
    --LoadModuleTooltip
    if L.S.loadModuleTooltipSetting:GetValue() == true then L.F.LoadModuleTooltip() end
    --LoadModuleVignette
    if L.S.loadModuleVignetteSetting:GetValue() == true then L.F.LoadModuleVignette() end
  end
end)
