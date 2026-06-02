local A, L = ...

---------------------------------------------------------------------
-- InitCap(str)
---------------------------------------------------------------------

local function InitCap(str)
  return (str:gsub("^%a", string.upper))
end

---------------------------------------------------------------------
-- RegisterOptionsPanel
---------------------------------------------------------------------

local function RegisterOptionsPanel()

  ---------------------------------------------------------------------
  -- Settings.RegisterVerticalLayoutCategory(L.name)
  ---------------------------------------------------------------------

  local category, layout = Settings.RegisterVerticalLayoutCategory(L.name)
  Settings.RegisterAddOnCategory(category)

  ---------------------------------------------------------------------
  -- loadModuleChatSetting + Checkbox
  ---------------------------------------------------------------------

  local loadModuleChatSetting = Settings.RegisterAddOnSetting(
    category,
    L.name.."SettingsLoadModuleChat",
    "chat",
    L.DB.settings.modules,
    Settings.VarType.Boolean,
    "Enable chat module",
    true
  )
  L.S.loadModuleChatSetting = loadModuleChatSetting

  loadModuleChatSetting:SetValueChangedCallback(function(setting, value)
    if value == true then
      print(L.name, "chat module enabled, please reload")
    else
      print(L.name, "chat module disabled, please reload")
    end
  end)

  Settings.CreateCheckbox(category, loadModuleChatSetting, "Enable/Disable the chat module")

    ---------------------------------------------------------------------
  -- loadModuleDarkModeSetting + Checkbox
  ---------------------------------------------------------------------

  local loadModuleDarkModeSetting = Settings.RegisterAddOnSetting(
    category,
    L.name.."SettingsLoadModuleDarkMode",
    "darkmode",
    L.DB.settings.modules,
    Settings.VarType.Boolean,
    "Enable darkmode module",
    true
  )
  L.S.loadModuleDarkModeSetting = loadModuleDarkModeSetting

  loadModuleDarkModeSetting:SetValueChangedCallback(function(setting, value)
    if value == true then
      print(L.name, "darkmode module enabled, please reload")
    else
      print(L.name, "darkmode module disabled, please reload")
    end
  end)

  Settings.CreateCheckbox(category, loadModuleDarkModeSetting, "Enable/Disable the darkmode module")

  ---------------------------------------------------------------------
  -- loadModuleSpellAlertSetting + Checkbox
  ---------------------------------------------------------------------

  local loadModuleSpellAlertSetting = Settings.RegisterAddOnSetting(
    category,
    L.name.."SettingsLoadModuleSpellAlert",
    "spellalert",
    L.DB.settings.modules,
    Settings.VarType.Boolean,
    "Enable spellalert module",
    true
  )
  L.S.loadModuleSpellAlertSetting = loadModuleSpellAlertSetting

  loadModuleSpellAlertSetting:SetValueChangedCallback(function(setting, value)
    if value == true then
      print(L.name, "spellalert module enabled, please reload")
    else
      print(L.name, "spellalert module disabled, please reload")
    end
  end)

  Settings.CreateCheckbox(category, loadModuleSpellAlertSetting, "Enable/Disable the spellalert module")

  ---------------------------------------------------------------------
  -- loadModuleStateDriverSetting + Checkbox
  ---------------------------------------------------------------------

  local loadModuleStateDriverSetting = Settings.RegisterAddOnSetting(
    category,
    L.name.."SettingsLoadModuleStateDriver",
    "statedriver",
    L.DB.settings.modules,
    Settings.VarType.Boolean,
    "Enable statedriver module",
    true
  )
  L.S.loadModuleStateDriverSetting = loadModuleStateDriverSetting

  loadModuleStateDriverSetting:SetValueChangedCallback(function(setting, value)
    if value == true then
      print(L.name, "statedriver module enabled, please reload")
    else
      print(L.name, "statedriver module disabled, please reload")
    end
  end)

  Settings.CreateCheckbox(category, loadModuleStateDriverSetting, "Enable/Disable the statedriver module")

  ---------------------------------------------------------------------
  -- loadModuleTooltipSetting + Checkbox
  ---------------------------------------------------------------------

  local loadModuleTooltipSetting = Settings.RegisterAddOnSetting(
    category,
    L.name.."SettingsLoadModuleTooltip",
    "tooltip",
    L.DB.settings.modules,
    Settings.VarType.Boolean,
    "Enable tooltip module",
    true
  )
  L.S.loadModuleTooltipSetting = loadModuleTooltipSetting

  loadModuleTooltipSetting:SetValueChangedCallback(function(setting, value)
    if value == true then
      print(L.name, "tooltip module enabled, please reload")
    else
      print(L.name, "tooltip module disabled, please reload")
    end
  end)

  Settings.CreateCheckbox(category, loadModuleTooltipSetting, "Enable/Disable the tooltip module")

  ---------------------------------------------------------------------
  -- loadModuleVignetteSetting + Checkbox
  ---------------------------------------------------------------------

  local loadModuleVignetteSetting = Settings.RegisterAddOnSetting(
    category,
    L.name.."SettingsLoadModuleVignette",
    "vignette",
    L.DB.settings.modules,
    Settings.VarType.Boolean,
    "Enable vignette module",
    true
  )
  L.S.loadModuleVignetteSetting = loadModuleVignetteSetting

  loadModuleVignetteSetting:SetValueChangedCallback(function(setting, value)
    if value == true then
      print(L.name, "vignette module enabled, please reload")
    else
      print(L.name, "vignette module disabled, please reload")
    end
  end)

  Settings.CreateCheckbox(category, loadModuleVignetteSetting, "Enable/Disable the vignette module")

  ---------------------------------------------------------------------
  -- Setting Panel End
  ---------------------------------------------------------------------

end
L.F.RegisterOptionsPanel = RegisterOptionsPanel
