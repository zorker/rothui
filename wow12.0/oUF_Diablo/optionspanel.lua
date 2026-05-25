local A, L = ...

local function InitCap(str)
  return (str:gsub("^%a", string.upper))
end

-- RegisterOptionsPanel
local function RegisterOptionsPanel()

  ---------------------------------------------------------------------
  -- Register Settings Category
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
    L.playerFrame:SetScale(value)
    L.movePlayerFrame:SetScale(value)
    L.movePlayerPowerFrame:SetScale(value)
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
      L.movePlayerFrame:EnableMouse(false)
      L.movePlayerFrame.bg:Hide()
    else
      L.movePlayerFrame:EnableMouse(true)
      L.movePlayerFrame.bg:Show()
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
      L.movePlayerPowerFrame:EnableMouse(false)
      L.movePlayerPowerFrame.bg:Hide()
    else
      L.movePlayerPowerFrame:EnableMouse(true)
      L.movePlayerPowerFrame.bg:Show()
    end
  end)

  Settings.CreateCheckbox(category, lockPlayerPowerFrameSetting, "Lock/Unlock the power orb.")

  ---------------------------------------------------------------------
  -- subCategoryOrbTemplate
  ---------------------------------------------------------------------

  local subCategoryOrbTemplate, subLayoutOrbTemplate = Settings.RegisterVerticalLayoutSubcategory(category, L.name.."OrbTemplates")
  subCategoryOrbTemplate:SetName("Orb templates")

---------------------------------------------------------------------
  -- Dropdowns
  ---------------------------------------------------------------------

  local function AddOrbTemplateDropdown(name, callback, options)
    
    local setting = Settings.RegisterAddOnSetting(
      category, 
      L.name.."SettingsOrbTemplate"..name, 
      name,
      L.DB.settings.orbModelTemplates,
      Settings.VarType.String, 
      name,
      L.DB_DEFAULTS.settings.orbModelTemplates.name or "_OTHER"
    )
    setting:SetValueChangedCallback(function(setting, value)
      callback(name, setting, value)
    end)

    Settings.CreateDropdown(subCategoryOrbTemplate, setting, options, "Pick a orb template for: "..name)

    return setting

  end

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

  L.S.orbModelTemplateDropdowns = {}

  local callback = function(name, setting, value)
    --print("callback", name, setting, value)
    L.playerFrame.Health:ForceUpdate()
    L.playerFrame.Power:ForceUpdate()
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
