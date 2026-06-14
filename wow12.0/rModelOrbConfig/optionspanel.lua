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
  -- rModelOrbConfigTemplateMixin
  ---------------------------------------------------------------------

  rModelOrbConfigTemplateMixin = {}

  function rModelOrbConfigTemplateMixin:OnLoad()
    if not self.OrbFrame then return end
    self:SetClipsChildren(true)
    --save frame reference
    L.previewOrb = self.OrbFrame
    --fix the framelevels on the options panel
    L.previewOrb.FillingStatusBar:SetFrameLevel(L.previewOrb:GetFrameLevel()+1)
    L.previewOrb.ClipFrame:SetFrameLevel(L.previewOrb:GetFrameLevel()+2)
    L.previewOrb.OverlayFrame:SetFrameLevel(L.previewOrb:GetFrameLevel()+3)
    self.CanvasButton:SetFrameLevel(L.previewOrb:GetFrameLevel()+4)
    self.CanvasButton:SetText("Show all models")
    self.CanvasButton:SetScript("OnClick", function(self)
      L.canvas:Open()
    end)
  end

  function rModelOrbConfigTemplateMixin:OnShow()
    L.F.UpdateTemplateList()
    L.templateManager:SetHeight(SettingsPanel:GetHeight())
    L.templateManager:SetPoint("LEFT", SettingsPanel, "RIGHT", 0, 0)
    L.templateManager:Show()
  end

  function rModelOrbConfigTemplateMixin:OnHide()
    L.templateManager:Hide()
  end

  function rModelOrbConfigTemplateMixin:Init(initializer)
    --get initializer data object
    local data = initializer:GetData()
    --scale the orb
    L.previewOrb:SetScale(L.S.scaleValueSetting:GetValue())
    -- load model into scene with mouse enabled
    L.previewOrb:LoadModelDataByID(data.setting:GetValue(), true)
    --set statusbar texture
    L.previewOrb.FillingStatusBar:SetStatusBarTexture(L.mediaFolder..L.S.fillTextureSetting:GetValue())
    --set fill value
    L.previewOrb.FillingStatusBar:SetValue(L.S.fillValueSetting:GetValue())
    --set statusbar and split texture colors + split texture opacity
    local color = CreateColorFromHexString(L.S.fillColorSetting:GetValue() or "ff0000ff")
    local r,g,b = color:GetRGB()
    L.previewOrb.FillingStatusBar:SetStatusBarColor(r,g,b)
    L.previewOrb.OverlayFrame.SparkTexture:SetVertexColor(r,g,b,L.S.splitAlphaSetting:GetValue())
    --set model opacity
    L.previewOrb.ClipFrame:SetAlpha(L.S.modelAlphaSetting:GetValue())
    --reset some settings
    L.S.showLowHealthSetting:SetValue(false)
    L.S.showDebuffGlowSetting:SetValue(false)
    L.S.fillValueSetting:SetValue(1)
  end

  ---------------------------------------------------------------------
  -- modelIDSetting + ElementInitializer
  ---------------------------------------------------------------------

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
    -- load model into scene with mouse enabled
    L.previewOrb:LoadModelDataByID(value, true)
    --change the fillColorSetting to the filling color that is preset by model id
    local r,g,b = L.previewOrb.FillingStatusBar:GetStatusBarColor()
    local color = CreateColor(r,g,b)
    L.S.fillColorSetting:SetValue(color:GenerateHexColor())
  end)

  --modelOrbData
  local modelOrbData = {
    setting = modelIDSetting,
    hello = "world",
    tooltip = "My tooltip here"
  }

  local initializer = Settings.CreateElementInitializer("rModelOrbConfigTemplate", modelOrbData)

  layout:AddInitializer(initializer)

  ---------------------------------------------------------------------
  -- fillValueSetting + Slider
  ---------------------------------------------------------------------

  local fillValueSetting = Settings.RegisterAddOnSetting(
      category,
      L.name.."SettingsFillValue",
      "fillValue",
      L.DB.settings,
      Settings.VarType.Number,
      "Fill Percent",
      1
  )
  L.S.fillValueSetting = fillValueSetting

  fillValueSetting:SetValueChangedCallback(function(setting, value)
    L.previewOrb.FillingStatusBar:SetValue(value)
  end)

  local fillValueOptions = Settings.CreateSliderOptions(0, 1, 0.01)

  fillValueOptions:SetLabelFormatter(
    MinimalSliderWithSteppersMixin.Label.Right,
    function(value)
      return string.format("%.0f%%", value*100)
    end
  )

  Settings.CreateSlider(category, fillValueSetting, fillValueOptions, "Move the slider to test how the orb will fill.")

  ---------------------------------------------------------------------
  -- modelAlphaSetting + Slider
  ---------------------------------------------------------------------

  local modelAlphaSetting = Settings.RegisterAddOnSetting(
      category,
      L.name.."SettingsModelAlhpa",
      "modelAlpha",
      L.DB.settings,
      Settings.VarType.Number,
      "Model Opacity",
      1
  )
  L.S.modelAlphaSetting = modelAlphaSetting

  modelAlphaSetting:SetValueChangedCallback(function(setting, value)
    L.previewOrb.ClipFrame:SetAlpha(value)
    if L.S.fillValueSetting:GetValue() ~= 1 then
      L.S.fillValueSetting:SetValue(1, false)
    end
  end)

  local modelAlphaOptions = Settings.CreateSliderOptions(0, 1, 0.01)

  modelAlphaOptions:SetLabelFormatter(
    MinimalSliderWithSteppersMixin.Label.Right,
    function(value)
      return string.format("%.0f%%", value*100)
    end
  )

  Settings.CreateSlider(category, modelAlphaSetting, modelAlphaOptions, "Move the slider to change the model opacity. Will set the filling to full.")

  ---------------------------------------------------------------------
  -- splitAlphaSetting + Slider
  ---------------------------------------------------------------------

  local splitAlphaSetting = Settings.RegisterAddOnSetting(
      category,
      L.name.."SettingsSplitAlhpa",
      "splitAlpha",
      L.DB.settings,
      Settings.VarType.Number,
      "Split Opacity",
      1
  )
  L.S.splitAlphaSetting = splitAlphaSetting

  splitAlphaSetting:SetValueChangedCallback(function(setting, value)
    local r,g,b,a = L.previewOrb.OverlayFrame.SparkTexture:GetVertexColor()
    L.previewOrb.OverlayFrame.SparkTexture:SetVertexColor(r,g,b,value)
    if L.S.fillValueSetting:GetValue() ~= 0.5 then
      L.S.fillValueSetting:SetValue(0.5, false)
    end
  end)

  local splitAlphaOptions = Settings.CreateSliderOptions(0, 1, 0.01)

  splitAlphaOptions:SetLabelFormatter(
    MinimalSliderWithSteppersMixin.Label.Right,
    function(value)
      return string.format("%.0f%%", value*100)
    end
  )

  Settings.CreateSlider(category, splitAlphaSetting, splitAlphaOptions, "Move the slider to change the split texture opacity. Will set the filling to 50%.")

  ---------------------------------------------------------------------
  -- fillColorSetting + ColorSwatch
  ---------------------------------------------------------------------

  local fillColorSetting = Settings.RegisterAddOnSetting(
      category,
      L.name.."SettingsFillColor",
      "fillColor",
      L.DB.settings,
      Settings.VarType.String,
      "Fill Color",
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

  ---------------------------------------------------------------------
  -- fillTextureSetting + Drowndown
  ---------------------------------------------------------------------

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
    container:Add("orb_filling22", "mum1")
    container:Add("orb_filling23", "mum2")
    container:Add("orb_filling24", "mum3")
    container:Add("orb_filling25", "mum4")
    container:Add("orb_filling26", "mum5")
    container:Add("orb_filling27", "mum6")
    container:Add("orb_filling28", "roots")
    container:Add("orb_filling29", "bowl")
    return container:GetData()
  end

  Settings.CreateDropdown(category, fillTextureSetting, fillTextureOptions, "Pick a filling texture you like.")

  ---------------------------------------------------------------------
  -- fillValueSetting + Slider
  ---------------------------------------------------------------------

  local scaleValueSetting = Settings.RegisterAddOnSetting(
      category,
      L.name.."SettingsScaleValue",
      "scaleValue",
      L.DB.settings,
      Settings.VarType.Number,
      "Orb Scale",
      1
  )
  L.S.scaleValueSetting = scaleValueSetting

  scaleValueSetting:SetValueChangedCallback(function(setting, value)
    L.previewOrb:SetScale(value)
  end)

  local scaleValueOptions = Settings.CreateSliderOptions(0.3, 2, 0.01)

  scaleValueOptions:SetLabelFormatter(
    MinimalSliderWithSteppersMixin.Label.Right,
    function(value)
      return string.format("%.0f%%", value*100)
    end
  )

  Settings.CreateSlider(category, scaleValueSetting, scaleValueOptions, "Move the slider to scale the orb.")

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
    if value == true then
      L.previewOrb.OverlayFrame.GlowTexture:SetVertexColor(1,0,1,0.7)
    else
      L.previewOrb.OverlayFrame.GlowTexture:SetVertexColor(0,1,0,0)
    end
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
    if value == true then
      L.S.fillValueSetting:SetValue(0.25, false)
      L.previewOrb.OverlayFrame.LowHealthTexture:SetVertexColor(1,0,0,0.7)
    else
      L.previewOrb.OverlayFrame.LowHealthTexture:SetVertexColor(1,0,0,0)
    end
  end)

  Settings.CreateCheckbox(category, showLowHealthSetting, "Enable/Disable the low health glow. Will set the filling to 25%.")

  ---------------------------------------------------------------------
  -- Setting Panel End
  ---------------------------------------------------------------------

end
L.F.RegisterOptionsPanel = RegisterOptionsPanel
