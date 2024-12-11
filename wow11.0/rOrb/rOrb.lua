-------------------------------------------------
-- Variables
-------------------------------------------------
local A, L = ...

local orbTemplates = {}

local mediaFolder = "Interface\\AddOns\\rOrb\\media\\"

local function AddTemplateToList(templateName)
  table.insert(orbTemplates, templateName)
end

AddTemplateToList("magenta-matrix")
AddTemplateToList("deep-purple-starly")
AddTemplateToList("chtun-eye")
AddTemplateToList("magenta-swirly")
AddTemplateToList("azeroth")
AddTemplateToList("deep-purple-magic")
AddTemplateToList("sandy-blitz")
AddTemplateToList("aqua-swirl")
AddTemplateToList("orange-marble")
AddTemplateToList("wierd-eye")
AddTemplateToList("pink-portal")
AddTemplateToList("green-portal")
AddTemplateToList("blue-portal")
AddTemplateToList("red-portal")
AddTemplateToList("purple-portal")
AddTemplateToList("red-slob")
AddTemplateToList("green-buzz")
AddTemplateToList("purple-buzz")
AddTemplateToList("blue-buzz")
AddTemplateToList("white-cloud")
AddTemplateToList("magic-swirly")
AddTemplateToList("green-beam")
AddTemplateToList("white-heal")
AddTemplateToList("red-heal")
AddTemplateToList("pearl")
AddTemplateToList("white-swirly")
AddTemplateToList("warlock-portal")
AddTemplateToList("purple-hole")
AddTemplateToList("blue-swirly")
AddTemplateToList("sand-storm")
AddTemplateToList("el-machina")
AddTemplateToList("red-blue-knot")
AddTemplateToList("blue-ring-disco")
AddTemplateToList("dwarf-machina")
AddTemplateToList("purple-storm")
AddTemplateToList("white-boulder")
AddTemplateToList("white-snowstorm")
AddTemplateToList("fire-dot")
AddTemplateToList("purple-discoball")
AddTemplateToList("white-tornado")
AddTemplateToList("white-snowglobe")
AddTemplateToList("white-zebra")
AddTemplateToList("white-spark")
AddTemplateToList("aqua-spark")
AddTemplateToList("purple-growup")
AddTemplateToList("aqua-suck-in")
AddTemplateToList("pink-portal-swirl")
AddTemplateToList("purple-earth")
AddTemplateToList("golden-earth")
AddTemplateToList("green-earth")
AddTemplateToList("pink-earth")
AddTemplateToList("golden-tornado")
AddTemplateToList("blue-electric")
AddTemplateToList("blue-splash")
AddTemplateToList("elvish-object")
AddTemplateToList("magic-tornado")
AddTemplateToList("snow-flake")

-------------------------------------------------
-- Function
-------------------------------------------------

local function OnDragStart(self, button)
  self:StartMoving()
end

local function OnDragStop(self)
  self:StopMovingOrSizing()
end

local function EnableDrag(self)
  self:RegisterForDrag("LeftButton")
  self:SetScript("OnDragStart", OnDragStart)
  self:SetScript("OnDragStop", OnDragStop)
  self:EnableMouse(true)
  self:SetClampedToScreen(true)
  self:SetMovable(true)
  self:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 5)
    GameTooltip:AddLine(self:GetName(), 0, 1, 0.5, 1, 1, 1)
    GameTooltip:AddLine("Orb-Template: "..self.templateName)
    GameTooltip:Show()
  end)
  self:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
  end)
end

local function CreateColorPickerButton(parent, name, color)
  -- color picker button frame
  local button = CreateFrame("Button", name, parent)
  button:EnableMouse(true)
  Mixin(button, BackdropTemplateMixin)
  button.backdropInfo = BACKDROP_TOAST_12_12
  button:ApplyBackdrop()
  button.Center:SetColorTexture(1, 1, 1)
  button.Center:SetVertexColor(unpack(color))
  button:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 5)
    GameTooltip:AddLine(self:GetName(), 0, 1, 0.5, 1, 1, 1)
    GameTooltip:Show()
  end)
  button:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
  end)
  -- color picker Callback func
  function button:Callback()
    local r, g, b = ColorPickerFrame:GetColorRGB()
    local a = ColorPickerFrame:GetColorAlpha()
    button.Center:SetVertexColor(r, g, b, a)
    button:UpdateColor(r, g, b, a)
  end
  function button:CallbackCancel()
  end
  -- color picker OnClick func
  button:SetScript("OnClick", function(self)
    local info = {}
    info.r, info.g, info.b, info.opacity = self:GetBackdropColor()
    info.hasOpacity = true
    info.swatchFunc = self.Callback
    info.cancelFunc = self.CallbackCancel
    info.opacityFunc = self.Callback
    ColorPickerFrame:SetupColorPickerAndShow(info)
  end)
  return button
end

local function CreateSliderWithEditbox(parent, name, minValue, maxValue, curValue)
  local slider = CreateFrame("Slider", name, parent, "OptionsSliderTemplate")
  local editbox = CreateFrame("EditBox", "$parentEditBox", slider, "InputBoxTemplate")
  slider.__parent = parent
  slider:SetMinMaxValues(minValue, maxValue)
  slider:SetValue(curValue)
  slider:SetValueStep(1)
  slider.text = _G[slider:GetName() .. "Text"]
  editbox:SetSize(30, 30)
  editbox:ClearAllPoints()
  editbox:SetPoint("LEFT", slider, "RIGHT", 15, 0)
  editbox:SetText(slider:GetValue())
  editbox:SetAutoFocus(false)
  editbox.slider = slider
  slider.editbox = editbox
  return slider
end

local function CreateOrb(templateName)
  local orb = CreateFrame("Frame", "rOrbPlayerHealth", UIParent, "OrbTemplate")
  orb:SetOrbTemplate(templateName)
  orb:SetPoint("CENTER", 0, 100)
  orb:SetScale(1.2)
  EnableDrag(orb)
  local healthSlider = CreateSliderWithEditbox(orb, A .. "HealthSlider", 0, 100, 100)
  healthSlider:ClearAllPoints()
  healthSlider:SetPoint("TOP", orb, "BOTTOM", 0, -30)
  healthSlider.text:SetText("Health")
  healthSlider:SetScript("OnValueChanged", function(self, value)
    value = math.floor(value + 0.5)
    self.editbox:SetText(value)
    local orb = self.__parent
    orb.FillingStatusBar:SetValue(value / 100)
  end)
  healthSlider.editbox:SetScript("OnEnterPressed", function(self)
    self:GetParent():SetValue(self:GetText())
    self:ClearFocus()
  end)

  local glowColorPicker = CreateColorPickerButton(orb, A .. 'glowColorPicker',
    {orb.OverlayFrame.GlowTexture:GetVertexColor()})
  glowColorPicker:SetSize(40, 40)
  glowColorPicker:SetPoint("LEFT", healthSlider, "RIGHT", 70, 0)
  function glowColorPicker:UpdateColor(r, g, b, a)
    orb.OverlayFrame.GlowTexture:SetVertexColor(r, g, b, a)
  end

  local templateSelector = CreateSliderWithEditbox(orb, A .. "TemplateSlider", 1, table.getn(orbTemplates),
    #orbTemplates)
  templateSelector:ClearAllPoints()
  templateSelector:SetPoint("TOP", healthSlider, "BOTTOM", 0, -30)
  templateSelector:SetWidth(600)
  templateSelector.text:SetText("ModelSelector")
  templateSelector:SetScript("OnValueChanged", function(self, value)
    value = math.floor(value + 0.5)
    self.editbox:SetText(value)
    local orb = self.__parent
    orb:SetOrbTemplate(orbTemplates[value])
    healthSlider:SetValue(100)
    orb.OverlayFrame.GlowTexture:SetVertexColor(glowColorPicker.Center:GetVertexColor())
  end)
  templateSelector.editbox:SetScript("OnEnterPressed", function(self)
    self:GetParent():SetValue(self:GetText())
    self:ClearFocus()
  end)

  local orbScaleSlider = CreateSliderWithEditbox(orb, A .. "ScaleSlider", 80, 130, 100)
  orbScaleSlider:ClearAllPoints()
  orbScaleSlider:SetPoint("RIGHT", healthSlider, "LEFT", -70, 0)
  orbScaleSlider.text:SetText("Scale")
  orbScaleSlider:SetScript("OnValueChanged", function(self, value)
    value = math.floor(value + 0.5)
    self.editbox:SetText(value)
    healthSlider:SetValue(100)
    self.__parent:SetScale(value / 100)
    self.__parent.ModelFrame:ResetOrbModel()
  end)
  orbScaleSlider.editbox:SetScript("OnEnterPressed", function(self)
    self:GetParent():SetValue(self:GetText())
    self:ClearFocus()
  end)

  return orb

end

-------------------------------------------------
-- Load
-------------------------------------------------

local orb = CreateOrb(orbTemplates[#orbTemplates])

local function ResetOrbModel()
  orb.ModelFrame:ResetOrbModel()
end

rLib:RegisterCallback("PLAYER_LOGIN", ResetOrbModel)