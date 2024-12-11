-- rOrb - canvas
-- zork 2024
-----------------------------
-- Variables
-----------------------------
local A, L = ...

local GT = GameTooltip
local math = math
local pi, halfpi = math.pi, math.pi / 2

L.canvas = CreateFrame("Frame", nil, UIParent)
L.defaultColorPickerFrameStrata = ColorPickerFrame:GetFrameStrata()

-------------------------------------
-- FUNCTIONS
-------------------------------------

local function UpdateModelPosition(orb, row, col, size)
  orb.title:SetFont(STANDARD_TEXT_FONT, math.max(size * 8 / 100, 8), "OUTLINE")
  orb:SetSize(size, size)
  orb:SetPoint("TOPLEFT", size * row, size * col * (-1))
end

local function UpdateDisplayIndex(orb, displayIndex)
  orb.FillingStatusBar:SetValue(1) -- make sure the bar is filled before reseting the template
  if L.orbTemplates[displayIndex] then
    orb:SetOrbTemplate(L.orbTemplates[displayIndex])
    orb.title:SetText(orb.templateName)
    C_Timer.After(0.1, function()
      orb.FillingStatusBar:SetValue(orb:GetParent().healthSlider:GetValue() / 100)

    end)
    orb:Show()
  else
    orb.templateName = nil
    orb.title:SetText("")
  end
end

-- create model func
local function CreateModel(parent, id)
  local orb = CreateFrame("Frame", nil, parent, "OrbTemplate")
  orb.frameId = id
  -- model title
  orb.title = orb.OverlayFrame:CreateFontString(nil, "OVERLAY")
  orb.title:SetFont(STANDARD_TEXT_FONT, 16, "OUTLINE")
  orb.title:SetPoint("TOP", 0, -2)
  orb.title:SetAlpha(0.6)
  -- m:SetScript("OnEnter", ModelOnEnter)
  -- m:SetScript("OnLeave", ModelOnLeave)
  return orb
end

-- canvas UpdatePage func
function L.canvas:UpdatePage(value)
  if self.canvasPage == 1 and value < 0 then
    return
  end
  self.canvasPage = self.canvasPage + value
  self.pageEditBox:SetText(self.canvasPage)
  self:UpdateAllModels()
end

-- canvas GetPageForDisplayIndex func
function L.canvas:UpdatePageForDisplayIndex(displayIndex)
  self.canvasPage = math.max(math.ceil(displayIndex / self.modelCount), 1)
  self.pageEditBox:SetText(self.canvasPage)
  self:UpdateAllModels()
end

-- canvas GetFirstDisplayIndexOfPage func
function L.canvas:GetFirstDisplayIndexOfPage()
  return ((self.canvasPage * self.modelCount) + 1) - self.modelCount
end

-- canvas UpdateAllGlowColors func
function L.canvas:UpdateAllGlowColors()
  local r, g, b, a = self.glowColorPicker.Center:GetVertexColor()
  for i, orb in pairs(self.M) do
    orb.OverlayFrame.GlowTexture:SetVertexColor(r, g, b, a)
  end
end

function L.canvas:UpdateAllLowHealthColors()
  local r, g, b, a = self.lowHealthColorPicker.Center:GetVertexColor()
  for i, orb in pairs(self.M) do
    orb.OverlayFrame.LowHealthTexture:SetVertexColor(r, g, b, a)
  end
end

function L.canvas:UpdateAllModelOpacities()
  local a = self.modelOpacitySlider:GetValue()/100
  for i, orb in pairs(self.M) do
    orb.ModelFrame:SetAlpha(a)
  end
end

function L.canvas:UpdateAllFillingColors()
  local r, g, b, a = self.fillingColorPicker.Center:GetVertexColor()
  for i, orb in pairs(self.M) do
    if a > 0 then
      orb.FillingStatusBar:SetStatusBarColor(r, g, b, a)
    else
      if orb.templateConfig then
        orb.FillingStatusBar:SetStatusBarColor(unpack(orb.templateConfig.statusBarColor))
      end
    end
  end
end

function L.canvas:UpdateAllFillingStatusBarTextures()
  local value = self.fillingStatusBarTextureSlider:GetValue()
  local textureFile = L.mediaFolder.."orb_filling"..value
  for i, orb in pairs(self.M) do
      if value > 0 then
        orb.FillingStatusBar:SetStatusBarTexture(textureFile)
      else
        if orb.templateConfig then
          orb.FillingStatusBar:SetStatusBarTexture(orb.templateConfig.statusBarTexture)
        end
      end
  end
end

function L.canvas:UpdateAllSplitColors()
  local r, g, b, a = self.splitColorPicker.Center:GetVertexColor()
  for i, orb in pairs(self.M) do
    if a > 0 then
      orb.OverlayFrame.SparkTexture:SetVertexColor(r, g, b, a)
    else
      if orb.templateConfig then
        orb.OverlayFrame.SparkTexture:SetVertexColor(unpack(orb.templateConfig.sparkColor))
      end
    end
  end
end

-- canvas HideAllModels func
function L.canvas:HideAllModels()
  for i, orb in pairs(self.M) do
    orb:ClearAllPoints()
    orb:Hide()
  end
end

-- canvas UpdateAllModels func
function L.canvas:UpdateAllModels()
  self:HideAllModels()
  self.modelRows = math.floor(self.canvasHeight / self.modelSize)
  self.modelCols = math.floor(self.canvasWidth / self.modelSize)
  self.modelCount = self.modelRows * self.modelCols
  self.displayIndexEditBox:SetText(self:GetFirstDisplayIndexOfPage())
  local id = 1
  for i = 1, self.modelRows do
    for k = 1, self.modelCols do
      if not self.M[id] then
        self.M[id] = CreateModel(self, id)
      end
      UpdateModelPosition(self.M[id], k - 1, i - 1, self.modelSize)
      UpdateDisplayIndex(self.M[id], self.M[id].frameId + self.modelCount * (self.canvasPage - 1))
      id = id + 1
    end -- for cols
  end -- for rows
  self:UpdateAllGlowColors()
  self:UpdateAllLowHealthColors()
  self:UpdateAllFillingColors()
  self:UpdateAllSplitColors()
  self:UpdateAllFillingStatusBarTextures()
  self:UpdateAllModelOpacities()
end

-- init canvas
function L.canvas:Init()

  -- canvas frame
  self:SetFrameStrata("FULLSCREEN")
  self:SetAlpha(0)
  self:SetAllPoints()
  self:EnableMouse(true)

  -- canvas attributes
  self.canvasWidth, self.canvasHeight = self:GetSize()
  self.canvasHeight = self.canvasHeight - 60 -- remove 70px for the bottom bar
  self.modelSize = 256
  self.canvasPage = 1
  self.M = {}
  self.isCanvas = true

  -- canvas background
  self.bg = self:CreateTexture(nil, "BACKGROUND", nil, -8)
  self.bg:SetAllPoints()
  self.bg:SetColorTexture(1, 1, 1)
  self.bg:SetVertexColor(0.15, 0.15, 0.15, 1)

  -- fade in anim
  self.fadeIn = self:CreateAnimationGroup()
  self.fadeIn.anim = self.fadeIn:CreateAnimation("Alpha")
  self.fadeIn.anim:SetDuration(0.8)
  self.fadeIn.anim:SetSmoothing("IN")
  self.fadeIn.anim:SetFromAlpha(0)
  self.fadeIn.anim:SetToAlpha(1)
  self.fadeIn:SetScript("OnFinished", function(self)
    L.canvas:SetAlpha(1)
    ColorPickerFrame:SetFrameStrata("FULLSCREEN_DIALOG")
  end)

  -- fade out anim
  self.fadeOut = self:CreateAnimationGroup()
  self.fadeOut.anim = self.fadeOut:CreateAnimation("Alpha")
  self.fadeOut.anim:SetDuration(0.8)
  self.fadeOut.anim:SetSmoothing("OUT")
  self.fadeOut.anim:SetFromAlpha(1)
  self.fadeOut.anim:SetToAlpha(0)
  self.fadeOut:SetScript("OnFinished", function(self)
    L.canvas:SetAlpha(0)
    -- hide canvas
    L.canvas:Hide()
    -- reset the color picker frame strata to the default value
    if ColorPickerFrame:GetFrameStrata() ~= L.defaultColorPickerFrameStrata then
      ColorPickerFrame:SetFrameStrata(L.defaultColorPickerFrameStrata)
    end
  end)

  -- canvas close button
  self.closeButton = L.F:CreateButton(self, L.name .. "CanvasCloseButton", "Close")
  self.closeButton:SetPoint("BOTTOMRIGHT", -10, 10)
  self.closeButton:SetScript("OnClick", function(self)
    L.canvas:Disable()
  end)
  self.closeButton:SetScript("OnEnter", function(self)
    GT:SetOwner(self, "ANCHOR_TOPRIGHT", 0, 5)
    GT:AddLine("Click to close.", 1, 1, 1, 1, 1, 1)
    GT:Show()
  end)
  self.closeButton:SetScript("OnLeave", function(self)
    GT:Hide()
  end)

  -- canvas page editbox
  self.pageEditBox = L.F:CreateEditBox(self, L.name .. "CanvasPageEditbox", "Page", self.canvasPage)
  self.pageEditBox:SetPoint("BOTTOM", self, "BOTTOM", 0, 10)
  self.pageEditBox:SetScript("OnEnterPressed", function(self)
    local value = math.max(math.floor(self:GetNumber()), 1)
    self:SetText(value)
    L.canvas.canvasPage = value
    L.canvas:UpdateAllModels()
  end)

  -- canvas next page button
  self.nextPageButton = L.F:CreateButton(self, L.name .. "CanvasNextPageButton", "next >")
  self.nextPageButton:SetPoint("LEFT", self.pageEditBox, "RIGHT", 5, 0)
  self.nextPageButton:SetScript("OnClick", function(self)
    L.canvas:UpdatePage(1)
  end)
  self.nextPageButton:SetScript("OnEnter", function(self)
    GT:SetOwner(self, "ANCHOR_TOP", 0, 5)
    GT:AddLine("Click for next page.", 1, 1, 1, 1, 1, 1)
    GT:Show()
  end)
  self.nextPageButton:SetScript("OnLeave", function(self)
    GT:Hide()
  end)

  -- canvas previous page button
  self.previousPageButton = L.F:CreateButton(self, L.name .. "CanvasPreviousPageButton", "< prev")
  self.previousPageButton:SetPoint("RIGHT", self.pageEditBox, "LEFT", -10, 0)
  self.previousPageButton:SetScript("OnClick", function(self)
    L.canvas:UpdatePage(-1)
  end)
  self.previousPageButton:SetScript("OnEnter", function(self)
    GT:SetOwner(self, "ANCHOR_TOP", 0, 5)
    GT:AddLine("Click for previous page.", 1, 1, 1, 1, 1, 1)
    GT:Show()
  end)
  self.previousPageButton:SetScript("OnLeave", function(self)
    GT:Hide()
  end)

  -- canvas displayIndex editbox
  self.displayIndexEditBox = L.F:CreateEditBox(self, L.name .. "CanvasDisplayIndexEditbox", "Index", 1)
  self.displayIndexEditBox:SetPoint("BOTTOMLEFT", 10, 10)
  self.displayIndexEditBox:SetScript("OnEnterPressed", function(self)
    local value = math.max(math.floor(self:GetNumber()), 1)
    self:SetText(value)
    L.canvas:UpdatePageForDisplayIndex(value)
  end)

  self.healthSlider = L.F:CreateSliderWithEditbox(self, L.name .. "CanvasHealthSlider", 0, 100, 100)
  self.healthSlider:ClearAllPoints()
  self.healthSlider:SetPoint("LEFT", self.displayIndexEditBox, "RIGHT", 20, 0)
  self.healthSlider.text:SetText("Health")
  self.healthSlider:SetScript("OnValueChanged", function(self, value)
    value = math.floor(value + 0.5)
    self.editbox:SetText(value)
    L.canvas:UpdateAllModels()
  end)
  self.healthSlider.editbox:SetScript("OnEnterPressed", function(self)
    self:GetParent():SetValue(self:GetText())
    self:ClearFocus()
  end)

  self.fillingStatusBarTextureSlider = L.F:CreateSliderWithEditbox(self, L.name .. "CanvasFillingStatusBarTextureSlider", 0, 21, 0)
  self.fillingStatusBarTextureSlider:ClearAllPoints()
  self.fillingStatusBarTextureSlider:SetPoint("BOTTOM", self.healthSlider, "TOP", 0, 30)
  self.fillingStatusBarTextureSlider.text:SetText("FillingStatusBarTexture")
  self.fillingStatusBarTextureSlider:SetScript("OnValueChanged", function(self, value)
    value = math.floor(value + 0.5)
    self.editbox:SetText(value)
    L.canvas:UpdateAllFillingStatusBarTextures()
  end)
  self.fillingStatusBarTextureSlider.editbox:SetScript("OnEnterPressed", function(self)
    self:GetParent():SetValue(self:GetText())
    self:ClearFocus()
  end)

  self.modelOpacitySlider = L.F:CreateSliderWithEditbox(self, L.name .. "CanvasModelOpacitySlider", 0, 100, 100)
  self.modelOpacitySlider:ClearAllPoints()
  self.modelOpacitySlider:SetPoint("LEFT", self.fillingStatusBarTextureSlider, "RIGHT", 70, 0)
  self.modelOpacitySlider.text:SetText("ModelOpacity")
  self.modelOpacitySlider:SetScript("OnValueChanged", function(self, value)
    value = math.floor(value + 0.5)
    self.editbox:SetText(value)
    L.canvas:UpdateAllModelOpacities()
  end)
  self.modelOpacitySlider.editbox:SetScript("OnEnterPressed", function(self)
    self:GetParent():SetValue(self:GetText())
    self:ClearFocus()
  end)

  self.glowColorPicker = L.F:CreateColorPickerButton(self, A .. 'CanvasGlowColorPicker', {0, 1, 0, 0}, "Change the color of the debuff glow")
  self.glowColorPicker:SetSize(40, 40)
  self.glowColorPicker:SetPoint("LEFT", self.healthSlider, "RIGHT", 70, 0)
  function self.glowColorPicker:UpdateColor(r, g, b, a)
    L.canvas:UpdateAllGlowColors()
  end

  self.lowHealthColorPicker = L.F:CreateColorPickerButton(self, A .. 'CanvasLowHealthColorPicker', {1, 0, 0, 0},"Change the color of the low health warning")
  self.lowHealthColorPicker:SetSize(40, 40)
  self.lowHealthColorPicker:SetPoint("LEFT", self.glowColorPicker, "RIGHT", 20, 0)
  function self.lowHealthColorPicker:UpdateColor(r, g, b, a)
    L.canvas:UpdateAllLowHealthColors()
  end

  self.fillingColorPicker = L.F:CreateColorPickerButton(self, A .. 'CanvasFillingColorPicker', {1, 0, 0, 0},"When the alpha value is zero the original template filling colors will be used")
  self.fillingColorPicker:SetSize(40, 40)
  self.fillingColorPicker:SetPoint("LEFT", self.lowHealthColorPicker, "RIGHT", 20, 0)
  function self.fillingColorPicker:UpdateColor(r, g, b, a)
    L.canvas:UpdateAllFillingColors()
  end

  self.splitColorPicker = L.F:CreateColorPickerButton(self, A .. 'CanvasSplitColorPicker', {0, 1, 1, 0},"When the alpha value is zero the original template split colors will be used. For the split you want a very light color. Do not pick darker colors.")
  self.splitColorPicker:SetSize(40, 40)
  self.splitColorPicker:SetPoint("LEFT", self.fillingColorPicker, "RIGHT", 20, 0)
  function self.splitColorPicker:UpdateColor(r, g, b, a)
    L.canvas:UpdateAllSplitColors()
  end

  self.canvasBgColorPicker = L.F:CreateColorPickerButton(self, A .. 'CanvasBackgroundColorPicker', {self.bg:GetVertexColor()})
  self.canvasBgColorPicker:SetSize(40, 40)
  self.canvasBgColorPicker:SetPoint("LEFT", self.splitColorPicker, "RIGHT", 20, 0)
  function self.canvasBgColorPicker:UpdateColor(r, g, b, a)
    L.canvas.bg:SetVertexColor(r,g,b,a)
  end

end

-- canvas enable func
function L.canvas:Enable()
  self:Show()
  self:UpdateAllModels()
  self.fadeIn:Play()
end

-- canvas disable func
function L.canvas:Disable()
  self.fadeOut:Play()
end
