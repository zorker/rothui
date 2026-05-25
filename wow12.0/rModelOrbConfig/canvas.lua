local A, L = ...

L.canvas = CreateFrame("Frame", nil, UIParent)

local sortedModels = {}

-------------------------------------
-- FUNCTIONS
-------------------------------------

local function CreateButton(parent, text, adjustWidth, adjustHeight)
  local b = CreateFrame("Button", name, parent, "UIPanelButtonTemplate")
  b:SetText(text)
  b:SetWidth(b:GetFontString():GetStringWidth() + (adjustWidth or 20))
  b:SetHeight(b:GetFontString():GetStringHeight() + (adjustHeight or 12))
  return b
end

local function UpdateModelPosition(orb, row, col, size)
  orb.title:SetFont(STANDARD_TEXT_FONT, math.max(size * 8 / 100, 8), "OUTLINE")
  orb:SetSize(size, size)
  orb:SetPoint("TOPLEFT", size * row, size * col * (-1))
end

local function UpdateDisplayIndex(orb, displayIndex)
  if sortedModels[displayIndex] then
    orb:Show()
    --load model into scene with mouse enabled
    orb:LoadModelDataByID(sortedModels[displayIndex].id, true)
    orb.modelID = sortedModels[displayIndex].id
    orb.title:SetText(sortedModels[displayIndex].name)
  else
    orb.templateName = nil
    orb.title:SetText("")
    orb.modelID = nil
  end
end

-- create model func
local function CreateModel(parent, id)

  local orb = CreateFrame("Frame", nil, parent, "rModelOrbTemplate")

  --[[
  orb:SetScript("OnMouseUp", function(self, button)
    if button == "LeftButton" then
      L.S.modelIDSetting:SetValue(orb.modelID)
      parent:Close()
    end
  end)

  orb:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_CURSOR", 0, 5)
    GameTooltip:AddLine("Click to use this model.", 1, 1, 1, 1, 1, 1)
    GameTooltip:Show()
  end)
  orb:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
  end)
  ]]

  orb.frameId = id
  -- model title
  orb.title = orb.OverlayFrame:CreateFontString(nil, "OVERLAY")
  orb.title:SetFont(STANDARD_TEXT_FONT, 16, "OUTLINE")
  orb.title:SetPoint("TOP", 0, -2)
  orb.title:SetAlpha(0.6)
  return orb
end

-- canvas UpdatePage func
function L.canvas:UpdatePage(value)
  if self.canvasPage == 1 and value < 0 then
    return
  end
  self.canvasPage = self.canvasPage + value
  self:UpdateAllModels()
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
  self.canvasHeight = self.canvasHeight - 30 
  self.modelSize = 256
  self.canvasPage = 1
  self.M = {}
  self.initialized = true

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
    L.canvas:Hide()
  end)

  -- canvas close button
  self.closeButton = CreateButton(self, "Close")
  self.closeButton:SetPoint("BOTTOMRIGHT", -10, 10)
  self.closeButton:SetScript("OnClick", function(self)
    L.canvas:Close()
  end)
  self.closeButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT", 0, 5)
    GameTooltip:AddLine("Click to close.", 1, 1, 1, 1, 1, 1)
    GameTooltip:Show()
  end)
  self.closeButton:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
  end)

  -- canvas next page button
  self.nextPageButton = CreateButton(self, "next >")
  self.nextPageButton:SetPoint("BOTTOM", self, "BOTTOM", self.nextPageButton:GetWidth()/2+5, 10)
  self.nextPageButton:SetScript("OnClick", function(self)
    L.canvas:UpdatePage(1)
  end)
  self.nextPageButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 5)
    GameTooltip:AddLine("Click for next page.", 1, 1, 1, 1, 1, 1)
    GameTooltip:Show()
  end)
  self.nextPageButton:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
  end)

  -- canvas previous page button
  self.previousPageButton = CreateButton(self, "< prev")
  self.previousPageButton:SetPoint("RIGHT", self.nextPageButton, "LEFT", -10, 0)
  self.previousPageButton:SetScript("OnClick", function(self)
    L.canvas:UpdatePage(-1)
  end)
  self.previousPageButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 5)
    GameTooltip:AddLine("Click for previous page.", 1, 1, 1, 1, 1, 1)
    GameTooltip:Show()
  end)
  self.previousPageButton:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
  end)

end

-- canvas Open func
function L.canvas:Open()
  if not self.initialized then
    self:Init()
    for id, data in pairs(L.previewOrb:GetAllModelData()) do
      data.id = id
      table.insert(sortedModels, data)
    end
    table.sort(sortedModels, function(a, b)
      return a.name:lower() < b.name:lower()
    end)
  end
  self:Show()
  self:UpdateAllModels()
  self.fadeIn:Play()
end

-- canvas Close func
function L.canvas:Close()
  self.fadeOut:Play()
end
