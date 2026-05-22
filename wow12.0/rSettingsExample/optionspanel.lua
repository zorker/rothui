local A, L = ...

L.previewOrb = nil

-- RegisterOptionsPanel
local function RegisterOptionsPanel()

  ---------------------------------------------------------------------
  -- Register Settings Category
  ---------------------------------------------------------------------

  local category, layout = Settings.RegisterVerticalLayoutCategory(L.name)
  Settings.RegisterAddOnCategory(category)

  ---------------------------------------------------------------------
  -- showDebuffGlowSetting + Checkbox
  ---------------------------------------------------------------------

  local showDebuffGlowSetting = Settings.RegisterAddOnSetting(
      category, 
      L.name.."SettingsShowDebuffGlow", 
      "showDebuffGlow",
      L.DB.settings,
      Settings.VarType.Boolean, 
      "Debuff Type Glow",
      false
  )
  L.S.showDebuffGlowSetting = showDebuffGlowSetting

  showDebuffGlowSetting:SetValueChangedCallback(function(setting, value)
    print("showDebuffGlowSetting", "SetValueChangedCallback", value)
  end)

  Settings.CreateCheckbox(category, showDebuffGlowSetting, "Enable/Disable the orb debuff glow.")

  ---------------------------------------------------------------------
  -- showLowHealthSetting + Checkbox
  ---------------------------------------------------------------------

  local showLowHealthSetting = Settings.RegisterAddOnSetting(
      category, 
      L.name.."SettingsShowLowHealth", 
      "showLowHealth",
      L.DB.settings,
      Settings.VarType.Boolean, 
      "Low Health Warning",
      false
  )
  L.S.showLowHealthSetting = showLowHealthSetting

  showLowHealthSetting:SetValueChangedCallback(function(setting, value)
    print("showLowHealthSetting", "SetValueChangedCallback", value)
  end)

  Settings.CreateCheckbox(category, showLowHealthSetting, "Enable/Disable the low health glow. Will set the filling to 25%.")

  ---------------------------------------------------------------------
  -- Setting Panel End
  ---------------------------------------------------------------------

end
L.F.RegisterOptionsPanel = RegisterOptionsPanel
