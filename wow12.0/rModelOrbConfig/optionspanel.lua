local A, L = ...

L.previewOrb = nil

-- RegisterOptionsPanel
local function RegisterOptionsPanel()

  local category, layout = Settings.RegisterVerticalLayoutCategory(L.name)
  Settings.RegisterAddOnCategory(category)

	rModelOrbConfigTemplateMixin = {}
	
  function rModelOrbConfigTemplateMixin:OnLoad()
    if self.OrbFrame then
      L.previewOrb = self.OrbFrame
      --fix the framelevels on the options panel
      self.OrbFrame.FillingStatusBar:SetFrameLevel(self.OrbFrame:GetFrameLevel()+1)
      self.OrbFrame.ClipFrame:SetFrameLevel(self.OrbFrame:GetFrameLevel()+2)
      self.OrbFrame.OverlayFrame:SetFrameLevel(self.OrbFrame:GetFrameLevel()+3)
    end
  end

  function rModelOrbConfigTemplateMixin:OnShow() 
  end

  function rModelOrbConfigTemplateMixin:OnHide() 
  end
  
  function rModelOrbConfigTemplateMixin:Init(initializer)
		local data = initializer:GetData()
    --LoadModelDataByID
    L.previewOrb:LoadModelDataByID(data.setting:GetValue())
    --filling texture
    L.previewOrb.FillingStatusBar:SetStatusBarTexture(L.mediaFolder..L.S.fillTextureSetting:GetValue())
    --set fill value
    L.previewOrb.FillingStatusBar:SetValue(L.S.fillValueSetting:GetValue())
    --load the setting colors into the orb
    local color = CreateColorFromHexString(L.S.fillColorSetting:GetValue())
    local r,g,b = color:GetRGB()
    L.previewOrb.FillingStatusBar:SetStatusBarColor(r,g,b)
    L.previewOrb.OverlayFrame.SparkTexture:SetVertexColor(r,g,b,L.S.splitAlphaSetting:GetValue())
    --set clip frame alpha
    L.previewOrb.ClipFrame:SetAlpha(L.S.modelAlphaSetting:GetValue())
    --
    L.S.showLowHealthSetting:SetValue(false)
    L.S.showDebuffGlowSetting:SetValue(false)
    L.S.fillValueSetting:SetValue(1)
	end

  function rModelOrbConfigTemplateMixin:GetExtent()
		return 256
	end

  --modelIDSetting
  local modelIDSetting = Settings.RegisterAddOnSetting(
      category, 
      L.name.."SettingsModelID", 
      "modelID",
      L.DB.settings,
      Settings.VarType.Number, 
      "Model ID",
      2030216
  )
  L.S.modelIDSetting = modelIDSetting

  modelIDSetting:SetValueChangedCallback(function(setting, value)
    L.previewOrb:LoadModelDataByID(value)
  end)

  --modelOrbData
  local modelOrbData = {
    setting = modelIDSetting,
    hello = "world",
    tooltip = "My tooltip here"
  }

  local initializer = Settings.CreateElementInitializer("rModelOrbConfigTemplate", modelOrbData)
	layout:AddInitializer(initializer)

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
  L.S.fillValueSetting = fillValueSetting

  fillValueSetting:SetValueChangedCallback(function(setting, value)
    L.previewOrb.FillingStatusBar:SetValue(value)
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
  L.S.modelAlphaSetting = modelAlphaSetting

  modelAlphaSetting:SetValueChangedCallback(function(setting, value)
    L.previewOrb.ClipFrame:SetAlpha(value)
    if fillValueSetting:GetValue() ~= 1 then
      fillValueSetting:SetValue(1, false)
    end
  end)
  local modelAlphaOptions = Settings.CreateSliderOptions(0, 1, 0.01)
  Settings.CreateSlider(category, modelAlphaSetting, modelAlphaOptions, "Move the slider to change the model opacity. Will set the filling to full.")

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
  L.S.splitAlphaSetting = splitAlphaSetting

  splitAlphaSetting:SetValueChangedCallback(function(setting, value)
    local r,g,b,a = L.previewOrb.OverlayFrame.SparkTexture:GetVertexColor()
    L.previewOrb.OverlayFrame.SparkTexture:SetVertexColor(r,g,b,value)
    if fillValueSetting:GetValue() ~= 0.5 then
      fillValueSetting:SetValue(0.5, false)
    end
  end)
  local splitAlphaOptions = Settings.CreateSliderOptions(0, 1, 0.01)
  Settings.CreateSlider(category, splitAlphaSetting, splitAlphaOptions, "Move the slider to change the split texture opacity. Will set the filling to 50%.")

  --fillColorSetting
  local fillColorSetting = Settings.RegisterAddOnSetting(
      category, 
      L.name.."SettingsFillColor", 
      "fillColor",
      L.DB.settings,
      Settings.VarType.String, 
      "Fill color",
      "ff0000ff"
  )
  L.S.fillColorSetting = fillColorSetting

  fillColorSetting:SetValueChangedCallback(function(setting, hexColor)
    local color = CreateColorFromHexString(hexColor)
    local r,g,b = color:GetRGB()
    L.previewOrb.FillingStatusBar:SetStatusBarColor(r,g,b)
    L.previewOrb.OverlayFrame.SparkTexture:SetVertexColor(r,g,b,L.S.splitAlphaSetting:GetValue())
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
  L.S.fillTextureSetting = fillTextureSetting

  fillTextureSetting:SetValueChangedCallback(function(setting, value)
    L.previewOrb.FillingStatusBar:SetStatusBarTexture(L.mediaFolder..value)
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
      "Debuff Type Glow",
      false
  )
  L.S.showDebuffGlowSetting = showDebuffGlowSetting

  showDebuffGlowSetting:SetValueChangedCallback(function(setting, value)
    if value == true then
      L.previewOrb.OverlayFrame.GlowTexture:SetVertexColor(0,1,0,0.7)
    else
      L.previewOrb.OverlayFrame.GlowTexture:SetVertexColor(0,1,0,0)
    end
  end)
  Settings.CreateCheckbox(category, showDebuffGlowSetting, "Enable/Disable the orb debuff glow.")

  --showLowHealthSetting
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
    if value == true then
      fillValueSetting:SetValue(0.25, false)
      L.previewOrb.OverlayFrame.LowHealthTexture:SetVertexColor(1,0,0,0.7)
    else
      L.previewOrb.OverlayFrame.LowHealthTexture:SetVertexColor(1,0,0,0)
    end
  end)
  Settings.CreateCheckbox(category, showLowHealthSetting, "Enable/Disable the low health glow. Will set the filling to 25%.")

end
L.F.RegisterOptionsPanel = RegisterOptionsPanel
