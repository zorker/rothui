-------------------------------------------------
-- Variables
-------------------------------------------------
local A, L = ...

-------------------------------------------------
-- CreateOrb
-------------------------------------------------

local function CreateOrb(templateName)
  local orb = CreateFrame("Frame", "rOrbPlayerHealth", UIParent, "OrbTemplate")
  orb:SetOrbTemplate(templateName)
  orb:SetPoint("CENTER", 0, 100)
  orb:SetScale(1)
  L.F:EnableDrag(orb)
  local healthSlider = L.F:CreateSliderWithEditbox(orb, A .. "HealthSlider", 0, 100, 100)
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

  local glowColorPicker = L.F:CreateColorPickerButton(orb, A .. 'GlowColorPicker',
    {orb.OverlayFrame.GlowTexture:GetVertexColor()})
  glowColorPicker:SetSize(40, 40)
  glowColorPicker:SetPoint("LEFT", healthSlider, "RIGHT", 70, 0)
  function glowColorPicker:UpdateColor(r, g, b, a)
    orb.OverlayFrame.GlowTexture:SetVertexColor(r, g, b, a)
  end

  local lowHealthColorPicker = L.F:CreateColorPickerButton(orb, A .. 'LowHealthColorPicker',
    {orb.OverlayFrame.LowHealthTexture:GetVertexColor()})
  lowHealthColorPicker:SetSize(40, 40)
  lowHealthColorPicker:SetPoint("LEFT", glowColorPicker, "RIGHT", 20, 0)
  function lowHealthColorPicker:UpdateColor(r, g, b, a)
    orb.OverlayFrame.LowHealthTexture:SetVertexColor(r, g, b, a)
  end

  local canvasButton = L.F:CreateButton(orb, A .. "CanvasOpenButton", "Open Canvas")
  canvasButton:SetPoint("LEFT", lowHealthColorPicker, "RIGHT", 20, 0)
  canvasButton:SetScript("OnClick", function(self)
    if not L.canvas.isCanvas then
      L.canvas:Init()
    end
    L.canvas:Enable()
  end)
  canvasButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT", 0, 5)
    GameTooltip:AddLine("Open canvas to view all orb templates at once.")
    GameTooltip:Show()
  end)
  canvasButton:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
  end)

  local templateSelector = L.F:CreateSliderWithEditbox(orb, A .. "TemplateSlider", 1, table.getn(L.orbTemplates), 1)
  templateSelector:ClearAllPoints()
  templateSelector:SetPoint("TOP", healthSlider, "BOTTOM", 0, -30)
  templateSelector:SetWidth(600)
  templateSelector.text:SetText("ModelSelector")
  templateSelector:SetScript("OnValueChanged", function(self, value)
    value = math.floor(value + 0.5)
    self.editbox:SetText(value)
    local orb = self.__parent
    orb:SetOrbTemplate(L.orbTemplates[value])
    healthSlider:SetValue(100)
    orb.OverlayFrame.GlowTexture:SetVertexColor(glowColorPicker.Center:GetVertexColor())
  end)
  templateSelector.editbox:SetScript("OnEnterPressed", function(self)
    self:GetParent():SetValue(self:GetText())
    self:ClearFocus()
  end)

  local orbScaleSlider = L.F:CreateSliderWithEditbox(orb, A .. "ScaleSlider", 80, 130, 100)
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

local orb = CreateOrb(L.orbTemplates[1])

local function ResetOrbModel()
  orb.ModelFrame:ResetOrbModel()
end

rLib:RegisterCallback("PLAYER_LOGIN", ResetOrbModel)
