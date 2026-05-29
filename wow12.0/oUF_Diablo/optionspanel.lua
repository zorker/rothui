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
  -- playerScaleSetting + Slider
  ---------------------------------------------------------------------

  local playerScaleSetting = Settings.RegisterAddOnSetting(
    category,
    L.name.."SettingsPlayerScale",
    "scale",
    L.DB.settings.player,
    Settings.VarType.Number,
    "Scale",
    1
  )
  L.S.playerScaleSetting = playerScaleSetting

  playerScaleSetting:SetValueChangedCallback(function(setting, value)
    L.O.playerFrame:SetScale(value)
    L.O.movePlayerFrame:SetScale(value)
    L.O.movePlayerPowerFrame:SetScale(value)
  end)

  local playerScaleOptions = Settings.CreateSliderOptions(0.3, 2, 0.01)

  playerScaleOptions:SetLabelFormatter(
    MinimalSliderWithSteppersMixin.Label.Right,
    function(value)
      return string.format("%.0f%%", value*100)
    end
  )

  Settings.CreateSlider(category, playerScaleSetting, playerScaleOptions, "Scale the health and power orb.")

  ---------------------------------------------------------------------
  -- lockPlayerFrameSetting + Checkbox
  ---------------------------------------------------------------------

  local lockPlayerFrameSetting = Settings.RegisterAddOnSetting(
    category,
    L.name.."SettingsLockPlayerFrame",
    "lockPlayerFrame",
    L.DB.settings.player,
    Settings.VarType.Boolean,
    "Lock health orb",
    true
  )
  L.S.lockPlayerFrameSetting = lockPlayerFrameSetting

  lockPlayerFrameSetting:SetValueChangedCallback(function(setting, value)
    if value == true then
      L.O.movePlayerFrame:EnableMouse(false)
      L.O.movePlayerFrame.bg:Hide()
    else
      L.O.movePlayerFrame:EnableMouse(true)
      L.O.movePlayerFrame.bg:Show()
    end
  end)

  Settings.CreateCheckbox(category, lockPlayerFrameSetting, "Lock/Unlock the health orb.")

  ---------------------------------------------------------------------
  -- lockPlayerPowerFrameSetting + Checkbox
  ---------------------------------------------------------------------

  local lockPlayerPowerFrameSetting = Settings.RegisterAddOnSetting(
    category,
    L.name.."SettingsLockPlayerPowerFrame",
    "lockPlayerPowerFrame",
    L.DB.settings.player,
    Settings.VarType.Boolean,
    "Lock power orb",
    true
  )
  L.S.lockPlayerPowerFrameSetting = lockPlayerPowerFrameSetting

  lockPlayerPowerFrameSetting:SetValueChangedCallback(function(setting, value)
    if value == true then
      L.O.movePlayerPowerFrame:EnableMouse(false)
      L.O.movePlayerPowerFrame.bg:Hide()
    else
      L.O.movePlayerPowerFrame:EnableMouse(true)
      L.O.movePlayerPowerFrame.bg:Show()
    end
  end)

  Settings.CreateCheckbox(category, lockPlayerPowerFrameSetting, "Lock/Unlock the power orb.")

  ---------------------------------------------------------------------
  -- hidePlayerArtSetting + Checkbox
  ---------------------------------------------------------------------

  local hidePlayerArtSetting = Settings.RegisterAddOnSetting(
    category,
    L.name.."SettingsHidePlayerArt",
    "hideArt",
    L.DB.settings.player,
    Settings.VarType.Boolean,
    "Hide art",
    false
  )
  L.S.hidePlayerArtSetting = hidePlayerArtSetting

  hidePlayerArtSetting:SetValueChangedCallback(function(setting, value)
    if value == true then
      L.O.hidePlayerArtTextures.texDemon:Hide()
      L.O.hidePlayerArtTextures.texLeftEdge:Hide()
      L.O.hidePlayerArtTextures.texAngel:Hide()
      L.O.hidePlayerArtTextures.texRightEdge:Hide()
    else
      L.O.hidePlayerArtTextures.texDemon:Show()
      L.O.hidePlayerArtTextures.texLeftEdge:Show()
      L.O.hidePlayerArtTextures.texAngel:Show()
      L.O.hidePlayerArtTextures.texRightEdge:Show()
    end
  end)

  Settings.CreateCheckbox(category, hidePlayerArtSetting, "Hide/Show the orb art.")

  ---------------------------------------------------------------------
  -- subCategoryOrbTemplate
  ---------------------------------------------------------------------

  local subCategoryOrbTemplate, subLayoutOrbTemplate = Settings.RegisterVerticalLayoutSubcategory(category, L.name.."OrbTemplates")
  subCategoryOrbTemplate:SetName("Orb templates")

  ---------------------------------------------------------------------
  -- AddOrbTemplateDropdown(name, callback, options)
  ---------------------------------------------------------------------

  local function AddOrbTemplateDropdown(name, callback, options)

    local defaultString = "_OTHER"
    if L.DB_DEFAULTS.settings.orbModelTemplates and L.DB_DEFAULTS.settings.orbModelTemplates[name] then
      defaultString = tostring(L.DB_DEFAULTS.settings.orbModelTemplates[name])
    end

    local setting = Settings.RegisterAddOnSetting(
      category,
      L.name.."SettingsOrbTemplate"..name,
      name,
      L.DB.settings.orbModelTemplates,
      Settings.VarType.String,
      name,
      defaultString
    )
    setting:SetValueChangedCallback(function(setting, value)
      callback(name, setting, value)
    end)
    Settings.CreateDropdown(subCategoryOrbTemplate, setting, options, "Pick a orb template for: "..name)
    return setting
  end

  ---------------------------------------------------------------------
  -- dropdown options
  ---------------------------------------------------------------------

  local options = function()
    local container = Settings.CreateControlTextContainer()
    local sortedOrbModelConfigTemplateKeys = {}
    for key in pairs(L.DB_ORB_CONFIG.presetTemplates) do
      table.insert(sortedOrbModelConfigTemplateKeys, key)
    end
    for key in pairs(L.DB_ORB_CONFIG.userTemplates) do
      table.insert(sortedOrbModelConfigTemplateKeys, key)
    end
    table.sort(sortedOrbModelConfigTemplateKeys)
    for _, key in ipairs(sortedOrbModelConfigTemplateKeys) do
      container:Add(key, key)
    end
    return container:GetData()
  end

  ---------------------------------------------------------------------
  -- L.S.orbModelTemplateDropdowns
  ---------------------------------------------------------------------

  L.S.orbModelTemplateDropdowns = {}

  local callback = function(name, setting, value)
    L.O.playerFrame.Health:ForceUpdate()
    L.O.playerFrame.Power:ForceUpdate()
  end

  local sortedOrbModelTemplateKeys = {}
  for key in pairs(L.DB.settings.orbModelTemplates) do
    table.insert(sortedOrbModelTemplateKeys, key)
  end
  table.sort(sortedOrbModelTemplateKeys)

  for _, key in pairs(sortedOrbModelTemplateKeys) do
    L.S.orbModelTemplateDropdowns[key] = AddOrbTemplateDropdown(key, callback, options)
  end

  ---------------------------------------------------------------------
  -- force ui refresh on dropdowns
  ---------------------------------------------------------------------

  hooksecurefunc(SettingsPanel, "SelectCategory", function(self, categoryID)
    if (subCategoryOrbTemplate and categoryID == subCategoryOrbTemplate:GetID()) or (category and categoryID == category:GetID()) then
      if SettingsPanel.Layout then
        SettingsPanel:Layout()
      end
    end
  end)

  ---------------------------------------------------------------------
  -- Setting Panel End
  ---------------------------------------------------------------------

end
L.F.RegisterOptionsPanel = RegisterOptionsPanel
