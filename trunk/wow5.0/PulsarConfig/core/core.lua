
-- // Pulsar GUI config
-- // zork - 2012

--get the addon namespace
local addon, ns = ...

if not Pulsar then
  print("Pulsar not found!")
  return
end

local PulsarConfig = PulsarConfig or CreateFrame("Frame", "PulsarConfig")
PulsarConfig:Hide()

-----------------------------
-- FUNCTIONS
-----------------------------

--do you really want to reset all values?
StaticPopupDialogs["PULSAR_RESET"] = {
  text = "Reset all values for Pulsar?",
  button1 = ACCEPT,
  button2 = CANCEL,
  OnAccept = function() print("reset done") end,
  OnCancel = function() print("reset canceled") end,
  timeout = 0,
  whileDead = 0,
  hideOnEscape = true,
}

--health orb panel
local function createHealthOrbPanel(parent, name)
  local panel = CreateFrame("FRAME")
  panel.name = name
  panel.parent = parent.name
  panel.okay = function (self)
    print(name.." okay")
  end
  panel.cancel = function (self)
    print(name.." cancel")
  end
  --panel.default = function (self)
    --resetAllValues()
    --StaticPopup_Show("PULSAR_RESET")
    --print(name.." default")
  --end
  panel.refresh = function (self)
    print(name.." refresh")
  end

  local text = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
  text:SetPoint("TOPLEFT", 16, -16)
  text:SetText(name)

  local subtext = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
  subtext:SetPoint("TOPLEFT", text, "BOTTOMLEFT", 0, -8)
  subtext:SetPoint("RIGHT", panel, -32, 0)
  subtext:SetNonSpaceWrap(true)
  subtext:SetJustifyH("LEFT")
  subtext:SetJustifyV("TOP")
  subtext:SetText("The following options allow you adjust the Pulsar health orb.")

  --Example:
  local name = "PCSlider_HealthOrbSize"
  local slider = CreateFrame("Slider", name, panel, "OptionsSliderTemplate") --frameType, frameName, frameParent, frameTemplate
  slider:SetPoint("TOPLEFT", subtext, "BOTTOMLEFT", 0, -24)
  slider.textLow = _G[name.."Low"]
  slider.textHigh = _G[name.."High"]
  slider.text = _G[name.."Text"]
  slider:SetMinMaxValues(50, 500)
  slider.minValue, slider.maxValue = slider:GetMinMaxValues()
  slider.textLow:SetText(slider.minValue)
  slider.textHigh:SetText(slider.maxValue)
  slider.text:SetText("Size")
  slider:SetValue(Pulsar.unit.player.health:GetWidth())
  slider:SetValueStep(1)
  slider:SetScript("OnValueChanged", function(self,value)
    --apply value
    Pulsar.unit.player.health.applySize(value)
    --save value in db
    Pulsar.db.char.unit.player.health.size = value
  end)
  InterfaceOptions_AddCategory(panel)
  return panel
end

--power orb panel
local function createPowerOrbPanel(parent, name)
  local panel = CreateFrame("FRAME")
  panel.name = name
  panel.parent = parent.name
  panel.okay = function (self)
    print(name.." okay")
  end
  panel.cancel = function (self)
    print(name.." cancel")
  end
  --panel.default = function (self)
    --resetAllValues()
    --StaticPopup_Show("PULSAR_RESET")
    --print(name.." default")
  --end
  panel.refresh = function (self)
    print(name.." refresh")
  end

  local text = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
  text:SetPoint("TOPLEFT", 16, -16)
  text:SetText(name)

  local subtext = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
  subtext:SetPoint("TOPLEFT", text, "BOTTOMLEFT", 0, -8)
  subtext:SetPoint("RIGHT", panel, -32, 0)
  subtext:SetNonSpaceWrap(true)
  subtext:SetJustifyH("LEFT")
  subtext:SetJustifyV("TOP")
  subtext:SetText("The following options allow you adjust the Pulsar power orb.")

  InterfaceOptions_AddCategory(panel)
  return panel
end

--main panel
local function createMainPanel(name)
  print(addon.." loaded")
  local panel = CreateFrame("FRAME")
  panel.name = name

  local text = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
  text:SetPoint("TOPLEFT", 16, -16)
  text:SetText(name)

  local subtext = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
  subtext:SetPoint("TOPLEFT", text, "BOTTOMLEFT", 0, -8)
  subtext:SetPoint("RIGHT", panel, -32, 0)
  subtext:SetNonSpaceWrap(true)
  subtext:SetJustifyH("LEFT")
  subtext:SetJustifyV("TOP")
  subtext:SetText("This is the Pulsar GUI config. You can set up your Pulsar settings here.")

  InterfaceOptions_AddCategory(panel)
  return panel
end

PulsarConfig.mainpanel = createMainPanel("Pulsar")
PulsarConfig.panel1 = createHealthOrbPanel(PulsarConfig.mainpanel, "PulsarHealthOrb")
PulsarConfig.panel2 = createPowerOrbPanel(PulsarConfig.mainpanel, "PulsarPowerOrb")

