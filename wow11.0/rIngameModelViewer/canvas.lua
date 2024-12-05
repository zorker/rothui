-- rIngameModelViewer - canvas
-- zork 2024
-----------------------------
-- Variables
-----------------------------
local A, L = ...

local GT = GameTooltip
local math = math
local pi, halfpi = math.pi, math.pi / 2

L.canvas = CreateFrame("Frame", nil, UIParent)
L.canvas.overlay = CreateFrame("Frame", nil, L.canvas)

-------------------------------------
-- FUNCTIONS
-------------------------------------

local function SetModelOrientation(model, distance, yaw, pitch)
  if not model:HasCustomCamera() then
    return
  end
  model.distance, model.yaw, model.pitch = distance, yaw, pitch
  local x = distance * math.cos(yaw) * math.cos(pitch)
  local y = distance * math.sin(-yaw) * math.cos(pitch)
  local z = (distance * math.sin(-pitch))
  model:SetCameraPosition(x, y, z)
end

local function CustomCamperaOnUpdate(model, elapsed)
  if not model:HasCustomCamera() then
    return
  end
  if not model.pitch then
    return
  end
  local x, y = GetCursorPosition()
  local pitch = model.pitch + (y - model.cursorY) * pi / 256
  local limit = false
  if pitch > halfpi - 0.05 or pitch < -halfpi + 0.05 then
    limit = true
  end
  if limit then
    local rotation = format("%.0f", math.abs(math.deg(((x - model.cursorX) / 64 + model:GetFacing())) % 360))
    if rotation ~= format("%.0f", math.abs(math.deg(model:GetFacing()) % 360)) then
      model:SetRotation(math.rad(rotation))
      model.rotation = rotation
    end
  else
    local yaw = model.yaw + (x - model.cursorX) * pi / 256
    SetModelOrientation(model, model.distance, yaw, pitch)
  end
  model.cursorX, model.cursorY = x, y
end

local function PositionOnUpdate(model, elapsed)
  local x, y = GetCursorPosition()
  local px, py, pz = model:GetPosition()
  if IsShiftKeyDown() then
    local mx = format("%.2f", (px + (y - model.cursorY) / 100))
    if format("%.2f", px) ~= mx then
      model:SetPosition(mx, py, pz)
      model.posX, model.posY = py, pz
    end
  else
    local my = format("%.2f", (py + (x - model.cursorX) / 84))
    local mz = format("%.2f", (pz + (y - model.cursorY) / 84))
    if format("%.2f", py) ~= my or format("%.2f", pz) ~= mz then
      model:SetPosition(px, my, mz)
      model.posX, model.posY = my, mz
    end
  end
  model.cursorX, model.cursorY = x, y
end

local function RotationOnUpdate(model, elapsed)
  local x, y = GetCursorPosition()
  local rotation = format("%.0f", math.abs(math.deg(((x - model.cursorX) / 84 + model:GetFacing())) % 360))
  if rotation ~= format("%.0f", math.abs(math.deg(model:GetFacing()) % 360)) then
    model:SetRotation(math.rad(rotation))
    model.rotation = rotation
  end
  model.cursorX, model.cursorY = x, y
end

local function ResetModelValues(model)
  model.camDistanceScale = 1
  model.portraitZoom = 0
  model.posX = 0
  model.posY = 0
  model.rotation = 0
  model:SetPortraitZoom(model.portraitZoom)
  model:SetCamDistanceScale(model.camDistanceScale)
  model:SetPosition(0, model.posX, model.posY)
  model:SetRotation(model.rotation)
  model:RefreshCamera()
  model:SetCustomCamera(1)
  if model:HasCustomCamera() then
    local x, y, z = model:GetCameraPosition()
    local tx, ty, tz = model:GetCameraTarget()
    model:SetCameraTarget(0, ty, tz)
    if x == 0 then
      return
    end
    SetModelOrientation(model, math.sqrt(x * x + y * y + z * z), -math.atan(y / x), -math.atan(z / x))
  end
end

local function ModelOnMouseDown(model, button)
  if button == "LeftButton" then
    if model:GetParent().isCanvas then
      if IsShiftKeyDown() then
        if model:HasCustomCamera() then
          model.cursorX, model.cursorY = GetCursorPosition()
          model:SetScript("OnUpdate", CustomCamperaOnUpdate)
        end
      else
        if not L.canvas.overlay.isOverlay then
          L.canvas.overlay:Init()
        end
        L.F:PlaySound(L.C.sound.click)
        L.canvas.overlay:Enable(model.displayIndex)
      end
    else
      if model:HasCustomCamera() then
        model.cursorX, model.cursorY = GetCursorPosition()
        model:SetScript("OnUpdate", CustomCamperaOnUpdate)
      end
    end
  elseif button == "RightButton" then
    if IsControlKeyDown() then
      ResetModelValues(model)
    else
      model.cursorX, model.cursorY = GetCursorPosition()
      model:SetScript("OnUpdate", RotationOnUpdate)
    end
  elseif button == "MiddleButton" or button == "Button4" or button == "Button5" then
    model.cursorX, model.cursorY = GetCursorPosition()
    model:SetScript("OnUpdate", PositionOnUpdate)
  end
end

local function ModelOnMouseUp(model, button)
  model:SetScript("OnUpdate", nil)
end

local function ModelOnMouseWheel(model, delta)
  if model:HasCustomCamera() then
    local max = 40
    local min = 0.1
    model.distance = math.min(math.max(model.distance - delta * 0.15, min), max)
    SetModelOrientation(model, model.distance, model.yaw, model.pitch)
  else
    if IsShiftKeyDown() then
      local max = 1
      local min = 0
      model.portraitZoom = math.min(math.max(model.portraitZoom + delta * 0.15, min), max)
      model:SetPortraitZoom(model.portraitZoom)
    else
      local max = 10
      local min = 0.1
      model.camDistanceScale = math.min(math.max(model.camDistanceScale - delta * 0.15, min), max)
      model:SetCamDistanceScale(model.camDistanceScale)
    end
  end
end

local function ModelOnEnter(model)
  if not IsAltKeyDown() then
    return
  end
  local pz, px, py = model:GetPosition()
  pz, px, py = L.F:RoundNumber(pz), L.F:RoundNumber(px), L.F:RoundNumber(py)
  GT:SetOwner(model, "ANCHOR_CURSOR")
  -- GT:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -90, 90)
  GT:AddLine("Model Info", 0, 1, 0.5, 1, 1, 1)
  GT:AddLine(" ")
  GT:AddDoubleLine("DisplayID", model:GetDisplayInfo(), 1, 1, 1, 1, 1, 1)
  GT:AddDoubleLine("SetPosition", "(" .. pz .. "," .. px .. "," .. px .. ")", 1, 1, 1, 1, 1, 1)
  GT:AddDoubleLine("SetRotation", model.rotation, 1, 1, 1, 1, 1, 1)
  GT:AddDoubleLine("SetFacing", L.F:RoundNumber(model:GetFacing()), 1, 1, 1, 1, 1, 1)
  GT:AddDoubleLine("DisplayIndex", model.model, 1, 1, 1, 1, 1, 1)
  GT:AddDoubleLine("GetModelFileID", model.modelFileID, 1, 1, 1, 1, 1, 1)
  if model:HasCustomCamera() then
    local x, y, z = model:GetCameraPosition()
    local tx, ty, tz = model:GetCameraTarget()
    x, y, z = L.F:RoundNumber(x), L.F:RoundNumber(y), L.F:RoundNumber(z)
    tx, ty, tz = L.F:RoundNumber(tx), L.F:RoundNumber(ty), L.F:RoundNumber(tz)
    GT:AddDoubleLine("CustomCamera", "true", 1, 1, 1, 1, 1, 1)
    GT:AddDoubleLine("SetCameraPosition", "(" .. x .. "," .. y .. "," .. z .. ")", 1, 1, 1, 1, 1, 1)
    GT:AddDoubleLine("SetCameraTarget", "(" .. tx .. "," .. ty .. "," .. tz .. ")", 1, 1, 1, 1, 1, 1)
  else
    GT:AddDoubleLine("CustomCamera", "false", 1, 1, 1, 1, 1, 1)
    GT:AddDoubleLine("SetCamDistanceScale", model.camDistanceScale, 1, 1, 1, 1, 1, 1)
    GT:AddDoubleLine("SetPortraitZoom", model.portraitZoom, 1, 1, 1, 1, 1, 1)
  end
  GT:AddLine(" ")
  if model.isOverlayModel then
    if model:HasCustomCamera() then
      GT:AddLine("Hold LEFT and drag mouse to move model camera.")
    else
      GT:AddLine("Model has no custom camera, cannot be moved freely with LEFT mouse.")
    end
  else
    GT:AddLine("Click LEFT for big overlay.")
    if model:HasCustomCamera() then
      GT:AddLine("Hold SHIFT + LEFT and drag mouse to move model camera.")
    end
  end
  GT:AddLine("Hold RIGHT and drag mouse to rotate model.")
  GT:AddLine("Hold MIDDLE or MOUSE4 and drag mouse to move model.")
  if model:HasCustomCamera() then
    GT:AddLine("Use MWHEEL to scale camera.")
  else
    GT:AddLine("Use MWHEEL to scale camera.")
    GT:AddLine("Use SHIFT + MWHEEL to zoom to portrait.")
  end
  GT:AddLine("Click CONTROL + RIGHT to reset.")
  GT:Show()
end

local function ModelOnLeave(model)
  GT:Hide()
end

local function UpdateModelPosition(model, row, col, size)
  model.title:SetFont(STANDARD_TEXT_FONT, math.max(size * 10 / 100, 8), "OUTLINE")
  model:SetSize(size, size)
  model:SetPoint("TOPLEFT", size * row, size * col * (-1))
  model:Show()
end

local function UpdateDisplayIndex(model, displayIndex)
  model.displayIndex = displayIndex
  if L.C.canvasMode == 'displayIndexList' then
    if L.DB.displayIndexList and L.DB.displayIndexList[displayIndex] then
      model.displayInfo = L.DB.displayIndexList[displayIndex]
    else
      model.displayInfo = 1
    end
    model.title:SetText(model.displayInfo .. " - " .. model.displayIndex)
  else
    model.displayInfo = displayIndex
    model.title:SetText(model.displayInfo)
  end
  model:ClearModel()
  if model.displayInfo == 74632 then
    -- skip memory leak id
    model.model = model.displayInfo
    model.modelFileID = ""
  else
    model:SetDisplayInfo(model.displayInfo)
    --model:SetModel(model.displayInfo)
    --model:SetUnit(model.displayInfo)
    --model:SetCreature(model.displayIndex)
    -- model.model = model:GetModel()
    model.model = model.displayInfo
    model.modelFileID = model:GetModelFileID() or ""
    -- if model.modelFileID and not DB.GLOB["MODEL_LIST"][model.modelFileID] then
    --  DB.GLOB["MODEL_LIST"][model.modelFileID] = model.displayIndex
    --  print(L.name,'adding new entry to model list for fileID',model.modelFileID,'displayID',model.displayIndex)
    -- end
    -- model:SetModelByFileID(model.modelFileID)
    -- model.modelUnitGUID = model:GetModelUnitGUID() or ""
    -- model.modelPath = model:GetModelPath() or ""
  end
  if not model.modelFileID or model.modelFileID == "" then
    model.e404:Show()
    model:EnableMouse(false)
    model:SetAlpha(0.1)
  else
    model.e404:Hide()
    model:EnableMouse(true)
    model:SetAlpha(1)
  end
end

-- create model func
local function CreateModel(parent, id)
  -- model frame
  local m = CreateFrame("PlayerModel", nil, parent)
  -- model attributes
  m.name = "model" .. id
  m.id = id
  -- model background (border)
  m.bg = m:CreateTexture(nil, "BACKGROUND", nil, -8)
  m.bg:SetColorTexture(1, 1, 1)
  m.bg:SetVertexColor(0, 0, 0, .2)
  m.bg:SetAllPoints()
  -- model background color
  m.color = m:CreateTexture(nil, "BACKGROUND", nil, -7)
  m.color:SetColorTexture(1, 1, 1)
  -- color bugfix
  m.color:SetVertexColor(unpack(L.DB.GLOB["COLOR"]))
  m.color:SetPoint("TOPLEFT", m, "TOPLEFT", 2, -2)
  m.color:SetPoint("BOTTOMRIGHT", m, "BOTTOMRIGHT", -2, 2)
  -- model title
  m.title = m:CreateFontString(nil, "BACKGROUND")
  m.title:SetFont(STANDARD_TEXT_FONT, 32, "OUTLINE")
  m.title:SetPoint("TOP", 0, -2)
  m.title:SetAlpha(.5)
  -- no model found
  m.e404 = m:CreateTexture(nil, "BACKGROUND", nil, -6)
  m.e404:SetAtlas("128-Store-Main")
  m.e404:SetAllPoints()
  m.e404:Hide()
  -- scripts
  m:SetScript("OnMouseWheel", ModelOnMouseWheel)
  m:SetScript("OnMouseDown", ModelOnMouseDown)
  m:SetScript("OnMouseUp", ModelOnMouseUp)
  m:SetScript("OnEnter", ModelOnEnter)
  m:SetScript("OnLeave", ModelOnLeave)
  return m
end

-- canvas UpdateModelSize func
function L.canvas:UpdateModelSize(value)
  if (self.modelSize + value) < 50 and value < 0 then
    return
  end
  if (self.modelSize + value) > 400 and value > 0 then
    return
  end
  self.modelSize = self.modelSize + value
  L.DB.GLOB["MODELSIZE"] = self.modelSize
  self:UpdateAllModels()
end

-- canvas UpdatePage func
function L.canvas:UpdatePage(value)
  if self.canvasPage == 1 and value < 0 then
    return
  end
  self.canvasPage = self.canvasPage + value
  L.DB.GLOB["PAGE"] = self.canvasPage
  self.pageEditBox:SetText(self.canvasPage)
  self:UpdateAllModels()
end

-- canvas GetPageForDisplayID func
function L.canvas:UpdatePageForDisplayID(displayId)
  self.canvasPage = math.max(math.ceil(displayId / self.modelCount), 1)
  L.DB.GLOB["PAGE"] = self.canvasPage
  self.pageEditBox:SetText(self.canvasPage)
  self:UpdateAllModels()
end

-- canvas GetFirstDisplayIdOfPage func
function L.canvas:GetFirstDisplayIdOfPage()
  return ((self.canvasPage * self.modelCount) + 1) - self.modelCount
end

-- canvas UpdateAllColors func
function L.canvas:UpdateAllColors(r, g, b)
  for i, model in pairs(self.M) do
    model.color:SetVertexColor(r, g, b)
  end
  if self.overlay and self.overlay.isOverlay then
    self.overlay.model.color:SetVertexColor(r, g, b)
    self.overlay.colorPickerButton.bg:SetVertexColor(r, g, b)
  end
  self.colorPickerButton.bg:SetVertexColor(r, g, b)
  -- model.bg:SetVertexColor(r*0.1,g*0.1,b*0.1)
end

-- canvas HideAllModels func
function L.canvas:HideAllModels()
  for i, model in pairs(self.M) do
    model:ClearAllPoints()
    model:Hide()
  end
end

-- canvas UpdateAllModels func
function L.canvas:UpdateAllModels()
  self:HideAllModels()
  self.modelRows = math.floor(self.canvasHeight / self.modelSize)
  self.modelCols = math.floor(self.canvasWidth / self.modelSize)
  self.modelCount = self.modelRows * self.modelCols
  self.displayIdEditBox:SetText(self:GetFirstDisplayIdOfPage())
  local id = 1
  for i = 1, self.modelRows do
    for k = 1, self.modelCols do
      if not self.M[id] then
        self.M[id] = CreateModel(self, id)
      end
      UpdateModelPosition(self.M[id], k - 1, i - 1, self.modelSize)
      UpdateDisplayIndex(self.M[id], self.M[id].id + self.modelCount * (self.canvasPage - 1))
      ResetModelValues(self.M[id])
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
  self.canvasHeight = self.canvasHeight - 60 -- remove 70px for the bottom bar
  self.modelSize = L.DB.GLOB["MODELSIZE"]
  self.canvasPage = L.DB.GLOB["PAGE"]
  self.M = {}
  self.isCanvas = true

  -- canvas background
  self.bg = self:CreateTexture(nil, "BACKGROUND", nil, -8)
  self.bg:SetAllPoints()
  self.bg:SetColorTexture(1, 1, 1)
  self.bg:SetVertexColor(0.15, 0.15, 0.15)

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
    L.F:PlaySound(L.C.sound.select)
    L.canvas:Disable()
  end)
  self.closeButton:SetScript("OnEnter", function(self)
    -- L.F:PlaySound(L.C.sound.select)
    GT:SetOwner(self, "ANCHOR_TOPRIGHT", 0, 5)
    GT:AddLine("Click to close.", 1, 1, 1, 1, 1, 1)
    GT:Show()
  end)
  self.closeButton:SetScript("OnLeave", function(self)
    -- L.F:PlaySound(L.C.sound.swap)
    GT:Hide()
  end)

  -- canvas page editbox
  self.pageEditBox = L.F:CreateEditBox(self, L.name .. "CanvasPageEditbox", "Page", self.canvasPage)
  self.pageEditBox:SetPoint("BOTTOM", self, "BOTTOM", 0, 10)
  self.pageEditBox:SetScript("OnEnterPressed", function(self)
    L.F:PlaySound(L.C.sound.swap)
    local value = math.max(math.floor(self:GetNumber()), 1)
    self:SetText(value)
    L.canvas.canvasPage = value
    L.DB.GLOB["PAGE"] = L.canvas.canvasPage
    L.canvas:UpdateAllModels()
  end)

  -- canvas next page button
  self.nextPageButton = L.F:CreateButton(self, L.name .. "CanvasNextPageButton", "next >")
  self.nextPageButton:SetPoint("LEFT", self.pageEditBox, "RIGHT", 5, 0)
  self.nextPageButton:SetScript("OnClick", function(self)
    L.F:PlaySound(L.C.sound.swap)
    L.canvas:UpdatePage(1)
  end)
  self.nextPageButton:SetScript("OnEnter", function(self)
    -- L.F:PlaySound(L.C.sound.select)
    GT:SetOwner(self, "ANCHOR_TOP", 0, 5)
    GT:AddLine("Click for next page.", 1, 1, 1, 1, 1, 1)
    GT:Show()
  end)
  self.nextPageButton:SetScript("OnLeave", function(self)
    -- L.F:PlaySound(L.C.sound.swap)
    GT:Hide()
  end)

  -- canvas previous page button
  self.previousPageButton = L.F:CreateButton(self, L.name .. "CanvasPreviousPageButton", "< prev")
  self.previousPageButton:SetPoint("RIGHT", self.pageEditBox, "LEFT", -10, 0)
  self.previousPageButton:SetScript("OnClick", function(self)
    L.F:PlaySound(L.C.sound.swap)
    L.canvas:UpdatePage(-1)
  end)
  self.previousPageButton:SetScript("OnEnter", function(self)
    -- L.F:PlaySound(L.C.sound.select)
    GT:SetOwner(self, "ANCHOR_TOP", 0, 5)
    GT:AddLine("Click for previous page.", 1, 1, 1, 1, 1, 1)
    GT:Show()
  end)
  self.previousPageButton:SetScript("OnLeave", function(self)
    -- L.F:PlaySound(L.C.sound.swap)
    GT:Hide()
  end)

  -- canvas color picker button
  self.colorPickerButton = L.F:CreateColorPickerButton(self, L.name .. "CanvasColorPickerButton")
  self.colorPickerButton:SetPoint("BOTTOMLEFT", 10, 10)
  self.colorPickerButton:SetScript("OnEnter", function(self)
    -- L.F:PlaySound(L.C.sound.select)
    GT:SetOwner(self, "ANCHOR_TOPLEFT", 0, 5)
    GT:AddLine("Click for color picker.", 1, 1, 1, 1, 1, 1)
    GT:Show()
  end)
  self.colorPickerButton:SetScript("OnLeave", function(self)
    -- L.F:PlaySound(L.C.sound.swap)
    GT:Hide()
  end)
  -- canvas color picker button update color func
  function self.colorPickerButton:UpdateColor(r, g, b)
    L.DB.GLOB["COLOR"] = {r, g, b}
    L.canvas:UpdateAllColors(r, g, b)
  end

  -- canvas minus size button
  self.minusSizeButton = L.F:CreateButton(self, L.name .. "CanvasMinusSizeButton", "- size")
  self.minusSizeButton:SetPoint("LEFT", self.colorPickerButton, "RIGHT", 10, 0)
  self.minusSizeButton:SetScript("OnClick", function(self)
    L.F:PlaySound(L.C.sound.click)
    L.canvas:UpdateModelSize(-20)
  end)
  self.minusSizeButton:SetScript("OnEnter", function(self)
    -- L.F:PlaySound(L.C.sound.select)
    GT:SetOwner(self, "ANCHOR_TOP", 0, 5)
    GT:AddLine("Click for decreased model size.", 1, 1, 1, 1, 1, 1)
    GT:Show()
  end)
  self.minusSizeButton:SetScript("OnLeave", function(self)
    -- L.F:PlaySound(L.C.sound.swap)
    GT:Hide()
  end)

  -- canvas plus size button
  self.plusSizeButton = L.F:CreateButton(self, L.name .. "CanvasPlusSizeButton", "+ size")
  self.plusSizeButton:SetPoint("LEFT", self.minusSizeButton, "RIGHT", 5, 0)
  self.plusSizeButton:SetScript("OnClick", function(self)
    L.F:PlaySound(L.C.sound.click)
    L.canvas:UpdateModelSize(20)
  end)
  self.plusSizeButton:SetScript("OnEnter", function(self)
    -- L.F:PlaySound(L.C.sound.select)
    GT:SetOwner(self, "ANCHOR_TOP", 0, 5)
    GT:AddLine("Click for increased model size.", 1, 1, 1, 1, 1, 1)
    GT:Show()
  end)
  self.plusSizeButton:SetScript("OnLeave", function(self)
    -- L.F:PlaySound(L.C.sound.swap)
    GT:Hide()
  end)

  -- canvas displayid editbox
  self.displayIdEditBox = L.F:CreateEditBox(self, L.name .. "CanvasDisplayIdEditbox", "DisplayId", 1)
  self.displayIdEditBox:SetPoint("LEFT", self.plusSizeButton, "RIGHT", 20, 0)
  self.displayIdEditBox:SetScript("OnEnterPressed", function(self)
    L.F:PlaySound(L.C.sound.swap)
    local value = math.max(math.floor(self:GetNumber()), 1)
    self:SetText(value)
    L.canvas:UpdatePageForDisplayID(value)
  end)

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

-- create overlay
function L.canvas.overlay:Init()

  self.isOverlay = true

  self:SetFrameStrata("FULLSCREEN_DIALOG")
  self:SetAllPoints()
  self:EnableMouse(true)
  self:SetAlpha(0)

  self.bg = self:CreateTexture(nil, "BACKGROUND", nil, -8)
  self.bg:SetColorTexture(1, 1, 1)
  self.bg:SetVertexColor(0.15, 0.15, 0.15)
  self.bg:SetAllPoints()

  -- overlay model
  self.model = CreateModel(self, 1)
  self.model:SetPoint("TOPLEFT", 100, -10)
  self.model:SetPoint("BOTTOMLEFT", 100, 10)
  self.model:SetPoint("TOPRIGHT", -100, -10)
  self.model:SetPoint("BOTTOMRIGHT", -100, 10)
  self.model.isOverlayModel = true

  -- overlay color picker button
  self.colorPickerButton = L.F:CreateColorPickerButton(self, L.name .. "CanvasOverlayColorPickerButton")
  self.colorPickerButton:SetPoint("BOTTOMLEFT", 10, 10)
  self.colorPickerButton:SetScript("OnEnter", function(self)
    -- L.F:PlaySound(L.C.sound.select)
    GT:SetOwner(self, "ANCHOR_TOPLEFT", 0, 5)
    GT:AddLine("Click for color picker.", 1, 1, 1, 1, 1, 1)
    GT:Show()
  end)
  self.colorPickerButton:SetScript("OnLeave", function(self)
    -- L.F:PlaySound(L.C.sound.swap)
    GT:Hide()
  end)
  -- canvas color picker button update color func
  function self.colorPickerButton:UpdateColor(r, g, b)
    L.DB.GLOB["COLOR"] = {r, g, b}
    L.canvas:UpdateAllColors(r, g, b)
  end

  -- canvas next button
  self.nextButton = L.F:CreateButton(self, L.name .. "CanvasOverlayNextButton", "next >")
  self.nextButton:SetPoint("LEFT", self.model, "RIGHT", 10, 0)
  self.nextButton.text:SetFont(STANDARD_TEXT_FONT, 20, "OUTLINE")
  self.nextButton:SetHeight(50)
  self.nextButton:SetWidth(self.nextButton.text:GetStringWidth() + 20)
  self.nextButton:SetScript("OnClick", function(self)
    L.F:PlaySound(L.C.sound.swap)
    L.canvas.overlay:Next()
  end)
  self.nextButton:SetScript("OnEnter", function(self)
    -- L.F:PlaySound(L.C.sound.select)
    GT:SetOwner(self, "ANCHOR_TOP", 0, 5)
    GT:AddLine("Click for next model.", 1, 1, 1, 1, 1, 1)
    GT:Show()
  end)
  self.nextButton:SetScript("OnLeave", function(self)
    -- L.F:PlaySound(L.C.sound.swap)
    GT:Hide()
  end)

  -- canvas previous button
  self.previousButton = L.F:CreateButton(self, L.name .. "CanvasOverlayPreviousButton", "< prev")
  self.previousButton:SetPoint("RIGHT", self.model, "LEFT", -10, 0)
  self.previousButton.text:SetFont(STANDARD_TEXT_FONT, 20, "OUTLINE")
  self.previousButton:SetHeight(50)
  self.previousButton:SetWidth(self.previousButton.text:GetStringWidth() + 20)
  self.previousButton:SetScript("OnClick", function(self)
    L.F:PlaySound(L.C.sound.swap)
    L.canvas.overlay:Previous()
  end)
  self.previousButton:SetScript("OnEnter", function(self)
    -- L.F:PlaySound(L.C.sound.select)
    GT:SetOwner(self, "ANCHOR_TOP", 0, 5)
    GT:AddLine("Click for previous model.", 1, 1, 1, 1, 1, 1)
    GT:Show()
  end)
  self.previousButton:SetScript("OnLeave", function(self)
    -- L.F:PlaySound(L.C.sound.swap)
    GT:Hide()
  end)

  -- fade in anim
  self.fadeIn = self:CreateAnimationGroup()
  self.fadeIn.anim = self.fadeIn:CreateAnimation("Alpha")
  self.fadeIn.anim:SetDuration(0.8)
  self.fadeIn.anim:SetSmoothing("IN")
  self.fadeIn.anim:SetFromAlpha(0)
  self.fadeIn.anim:SetToAlpha(1)
  self.fadeIn:SetScript("OnFinished", function(self)
    L.canvas.overlay:SetAlpha(1)
  end)

  -- fade out anim
  self.fadeOut = self:CreateAnimationGroup()
  self.fadeOut.anim = self.fadeOut:CreateAnimation("Alpha")
  self.fadeOut.anim:SetDuration(0.8)
  self.fadeOut.anim:SetSmoothing("OUT")
  self.fadeOut.anim:SetFromAlpha(1)
  self.fadeOut.anim:SetToAlpha(0)
  self.fadeOut:SetScript("OnFinished", function(self)
    L.canvas.overlay:SetAlpha(0)
    L.canvas.overlay:Hide()
  end)

end

-- previous model
function L.canvas.overlay:Previous()
  UpdateDisplayIndex(self.model, math.max(self.model.displayIndex - 1, 1))
  ResetModelValues(self.model)
end

-- next model
function L.canvas.overlay:Next()
  UpdateDisplayIndex(self.model, self.model.displayIndex + 1)
  ResetModelValues(self.model)
end

-- canvas enable func
function L.canvas.overlay:Enable(displayIndex)
  self:Show()
  UpdateDisplayIndex(self.model, displayIndex)
  ResetModelValues(self.model)
  self.fadeIn:Play()
end

-- canvas disable func
function L.canvas.overlay:Disable()
  self.fadeOut:Play()
end

L.canvas.overlay:SetScript("OnMouseDown", function(self)
  L.F:PlaySound(L.C.sound.click)
  self:Disable()
end)

L.canvas.overlay:SetScript("OnEnter", function(self)
  GT:SetOwner(self, "ANCHOR_CURSOR")
  GT:AddLine("Click for close the overlay.", 1, 1, 1, 1, 1, 1)
  GT:Show()
end)

L.canvas.overlay:SetScript("OnLeave", function(self)
  GT:Hide()
end)
