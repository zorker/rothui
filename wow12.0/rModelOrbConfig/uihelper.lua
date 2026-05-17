local A, L = ...

local function CreateButton(parent, name, text, adjustWidth, adjustHeight)
  local b = CreateFrame("Button", name, parent, "UIPanelButtonTemplate")
  b.text = _G[b:GetName() .. "Text"]
  b.text:SetText(text)
  b:SetWidth(b.text:GetStringWidth() + (adjustWidth or 20))
  b:SetHeight(b.text:GetStringHeight() + (adjustHeight or 12))
  return b
end
L.F.CreateButton = CreateButton

local function CreateFontString(parent,layer,font,text)
  local fs = parent:CreateFontString(nil, layer, font)
  fs:SetText(text)
  return fs
end
L.F.CreateFontString = CreateFontString