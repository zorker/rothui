local A, L = ...

local function CreateButton(parent, text, adjustWidth, adjustHeight)
  local b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
  b:SetText(text)
  b:SetWidth(b:GetFontString():GetStringWidth() + (adjustWidth or 20))
  b:SetHeight(b:GetFontString():GetStringHeight() + (adjustHeight or 12))
  return b
end
L.F.CreateButton = CreateButton

local function CreateFontString(parent,layer,font,text)
  local fs = parent:CreateFontString(nil, layer, font)
  fs:SetText(text)
  return fs
end
L.F.CreateFontString = CreateFontString

local function CreateSlider(parent, width, minV, maxV, relativeTo, yOff, text)
  local slider = CreateFrame("Slider", nil, parent, "UISliderTemplate")
  slider:SetSize(width, 20)
  slider:SetPoint("TOPLEFT", relativeTo, "BOTTOMLEFT", 0, yOff)
  slider:SetMinMaxValues(minV, maxV)
  slider:SetValue(maxV)
  slider:SetObeyStepOnDrag(false)
  slider.text = CreateFontString(slider, "OVERLAY", "GameFontNormalSmall", text)
  slider.text:SetPoint("BOTTOM", slider, "TOP", 0, 2)
  return slider
end
L.F.CreateSlider = CreateSlider