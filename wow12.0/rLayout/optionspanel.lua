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
  -- Setting Panel End
  ---------------------------------------------------------------------

end
L.F.RegisterOptionsPanel = RegisterOptionsPanel
