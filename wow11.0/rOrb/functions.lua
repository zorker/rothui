-------------------------------------------------
-- Variables
-------------------------------------------------
local A, L = ...

L.F = {}
L.name = A

-------------------------------------------------
-- Function
-------------------------------------------------

local function OnDragStart(self, button)
  self:StartMoving()
end

local function OnDragStop(self)
  self:StopMovingOrSizing()
end

function L.F:EnableDrag(parent)
  parent:RegisterForDrag("LeftButton")
  parent:SetScript("OnDragStart", OnDragStart)
  parent:SetScript("OnDragStop", OnDragStop)
  parent:EnableMouse(true)
  parent:SetClampedToScreen(true)
  parent:SetMovable(true)
  parent:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 5)
    GameTooltip:AddLine(self:GetName(), 0, 1, 0.5, 1, 1, 1)
    GameTooltip:AddLine("Orb-Template: " .. self.templateName)
    GameTooltip:AddLine("Drag me!", 1, 1, 1, 1, 1, 1)
    GameTooltip:Show()
  end)
  parent:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
  end)
end

function L.F:CreateColorPickerButton(parent, name, color, tooltipText)
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
    if tooltipText then
      GameTooltip:AddLine(tooltipText)
    end
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

function L.F:CreateSliderWithEditbox(parent, name, minValue, maxValue, curValue)
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

function L.F:CreateButton(parent, name, text, adjustWidth, adjustHeight)
  local b = CreateFrame("Button", name, parent, "UIPanelButtonTemplate")
  b.text = _G[b:GetName() .. "Text"]
  b.text:SetText(text)
  b:SetWidth(b.text:GetStringWidth() + (adjustWidth or 20))
  b:SetHeight(b.text:GetStringHeight() + (adjustHeight or 12))
  return b
end

function L.F:CreateEditBox(parent, name, title, value)
  local e = CreateFrame("EditBox", name, parent, "InputBoxTemplate")
  e:SetSize(80, 30)
  e:SetAutoFocus(false)
  e:SetText(value)
  e:SetJustifyH("CENTER")
  if title then
    e.title = e:CreateFontString(nil, "BACKGROUND")
    e.title:SetPoint("BOTTOM", e, "TOP", 0, 0)
    e.title:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
    e.title:SetText(title)
    e.title:SetAlpha(0.5)
  end
  return e
end