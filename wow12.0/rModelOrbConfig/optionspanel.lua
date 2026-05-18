local A, L = ...

-- RegisterOptionsPanel
local function RegisterOptionsPanel()

  local category = Settings.RegisterVerticalLayoutCategory(L.name)

  --fillValueSetting
  local fillValueSetting = Settings.RegisterAddOnSetting(
      category, 
      L.name.."SettingsFillValue", 
      "fillValue",
      L.DB.settings,
      Settings.VarType.Number, 
      "Fill Value",
      1
  )
  fillValueSetting:SetValueChangedCallback(function(setting, newValue)
    print(newValue)
  end)
  local fillValueOptions = Settings.CreateSliderOptions(0, 1, 0.01)
  Settings.CreateSlider(category, fillValueSetting, fillValueOptions, "Move the slider to test how the orb will fill.")

  --modelAlphaSetting
  local modelAlphaSetting = Settings.RegisterAddOnSetting(
      category, 
      L.name.."SettingsModelAlhpa", 
      "modelAlpha",
      L.DB.settings,
      Settings.VarType.Number, 
      "Model opacity",
      1
  )
  modelAlphaSetting:SetValueChangedCallback(function(setting, newValue)
    print(newValue)
    if fillValueSetting:GetValue() ~= 1 then
      fillValueSetting:SetValue(1, false)
    end
  end)
  local modelAlphaOptions = Settings.CreateSliderOptions(0, 1, 0.01)
  Settings.CreateSlider(category, modelAlphaSetting, modelAlphaOptions, "Move the slider to change the model opacity.")

  --splitAlphaSetting
  local splitAlphaSetting = Settings.RegisterAddOnSetting(
      category, 
      L.name.."SettingsSplitAlhpa", 
      "splitAlpha",
      L.DB.settings,
      Settings.VarType.Number, 
      "Split opacity",
      1
  )
  splitAlphaSetting:SetValueChangedCallback(function(setting, newValue)
    print(newValue)
    if fillValueSetting:GetValue() ~= 0.5 then
      fillValueSetting:SetValue(0.5, false)
    end
  end)
  local splitAlphaOptions = Settings.CreateSliderOptions(0, 1, 0.01)
  Settings.CreateSlider(category, splitAlphaSetting, splitAlphaOptions, "Move the slider to change the split texture opacity.")

  --fillColorSetting
  local fillColorSetting = Settings.RegisterAddOnSetting(
      category, 
      L.name.."SettingsFillColor", 
      "fillColor",
      L.DB.settings,
      Settings.VarType.String, 
      "Fill color",
      "ffffffff"
  )
  fillColorSetting:SetValueChangedCallback(function(setting, hexColor)
    local color = CreateColorFromHexString(hexColor)
    local r,g,b = color:GetRGB()
    print(r,g,b)
  end)
  Settings.CreateColorSwatch(category, fillColorSetting, "Change the color of filling and split texture.")

  --fillTextureSetting
  local fillTextureSetting = Settings.RegisterAddOnSetting(
      category, 
      L.name.."SettingsFillTexture", 
      "fillTexture",
      L.DB.settings,
      Settings.VarType.String, 
      "Fill Texture",
      "orb_filling16"
  )
  fillTextureSetting:SetValueChangedCallback(function(setting, newValue)
    print(newValue)
  end)
  local fillTextureOptions = function()
    local container = Settings.CreateControlTextContainer()
    container:Add("orb_filling1", "moon")
    container:Add("orb_filling2", "earth")
    container:Add("orb_filling3", "mars")
    container:Add("orb_filling4", "galaxy")
    container:Add("orb_filling5", "jupiter")
    container:Add("orb_filling6", "tube")
    container:Add("orb_filling7", "sun")
    container:Add("orb_filling8", "swirl")
    container:Add("orb_filling9", "ice")
    container:Add("orb_filling10", "plastic")
    container:Add("orb_filling11", "bubbles")
    container:Add("orb_filling12", "wood")
    container:Add("orb_filling13", "golf")
    container:Add("orb_filling14", "mars2")
    container:Add("orb_filling15", "diablo3")
    container:Add("orb_filling16", "cloud")
    container:Add("orb_filling17", "foil")
    container:Add("orb_filling18", "exoplanet1")
    container:Add("orb_filling19", "exoplanet2")
    container:Add("orb_filling20", "skyrim")
    container:Add("orb_filling21", "obsidian")
    return container:GetData()
  end
  Settings.CreateDropdown(category, fillTextureSetting, fillTextureOptions, "Pick a filling texture you like.")

  --showDebuffGlowSetting
  local showDebuffGlowSetting = Settings.RegisterAddOnSetting(
      category, 
      L.name.."SettingsShowDebuffGlow", 
      "showDebuffGlow",
      L.DB.settings,
      Settings.VarType.Boolean, 
      "Show Debuff Glow",
      false
  )
  showDebuffGlowSetting:SetValueChangedCallback(function(setting, newValue)
    print(newValue)
  end)
  Settings.CreateCheckbox(category, showDebuffGlowSetting, "Enable/Disable the orb debuff glow")

  --showLowHealthSetting
  local showLowHealthSetting = Settings.RegisterAddOnSetting(
      category, 
      L.name.."SettingsShowLowHealth", 
      "showLowHealth",
      L.DB.settings,
      Settings.VarType.Boolean, 
      "Show Low Health",
      false
  )
  showLowHealthSetting:SetValueChangedCallback(function(setting, newValue)
    print(newValue)
  end)
  Settings.CreateCheckbox(category, showLowHealthSetting, "Enable/Disable the low health glow")

  Settings.RegisterAddOnCategory(category)

end
L.F.RegisterOptionsPanel = RegisterOptionsPanel
