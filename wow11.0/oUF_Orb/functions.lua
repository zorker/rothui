local A, L = ...

L.F = {}

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