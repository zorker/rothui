local A, L = ...

-------------------------------------------------
-- var
-------------------------------------------------

local TRANS_SCALE, ZOOM_SCALE, ROT_SCALE = 0.02, 0.02, 0.0174
local mpi, msin, mcos, mdeg = math.pi, math.sin, math.cos, math.deg

rModelOrbTemplateMixin = {}
rModelOrbFillingMixin = {}
rModelOrbClipMixin = {}
rModelOrbSceneMixin = {}
rModelOrbOverlayMixin = {}

-------------------------------------------------
-- func
-------------------------------------------------

function rModelOrbTemplateMixin:OnLoad() end
function rModelOrbTemplateMixin:OnShow() end
function rModelOrbTemplateMixin:OnHide() end

--orb:GetAllModelData()
function rModelOrbTemplateMixin:GetAllModelData()
  return L.DB.modelData
end

function rModelOrbTemplateMixin:GetModelDataByID(id)
  return L.DB.modelData[id]
end

function rModelOrbTemplateMixin:SaveModelDataByID(id, data)
  print(L.name, "Saving data for id: "..id)
  L.DB.modelData[id] = data
end

local function SaveSceneData(scene)

  local orb = scene.orbFrame
  local actor = scene.zorkActor
  local id = scene.modelFileID

  local modelData = orb:GetModelDataByID(id)

  local data = {}

  --camera target will always stay at 0,0,0
  --actor position will always stay at 0,0,0
  data.panX = scene.activeCamera.panningXOffset
  data.panY = scene.activeCamera.panningYOffset
  data.zoomDist = scene.activeCamera:GetZoomDistance()
  data.yaw = scene.activeCamera:GetYaw()
  data.pitch = scene.activeCamera:GetPitch()
  data.roll = scene.activeCamera:GetRoll()

  local r,g,b = orb.FillingStatusBar:GetStatusBarColor()
  local color = CreateColor(r,g,b)
  data.fillColor = color:GenerateHexColor()

  data.name = modelData.name
  data.status = modelData.status
  data.tag = modelData.tag

  orb:SaveModelDataByID(id, data)

  scene:UpdateDebugText()

end

local function InitScene(scene, enableMouse)

  if scene.isInitialized then return end

  scene.isInitialized = true

  -- make sure the active OnUpdate gets removed asap. we change that to OnMouseDown -> OnUpdate which gets removed again OnMouseUp
  if scene:HasScript("OnUpdate") then
    scene:SetScript("OnUpdate", nil)
  end

  function scene:UpdateDebugText()
    if not self.debugText then return end
    local yt = string.format("Y %.1f°", mdeg(self.activeCamera:GetYaw() or 0))
    local pt = string.format("P %.1f°", mdeg(self.activeCamera:GetPitch() or 0))
    local rt = string.format("R %.1f°", mdeg(self.activeCamera:GetRoll() or 0))
    local zt = string.format("Z %.2f", self.activeCamera:GetZoomDistance() or 15)
    local x = string.format("x %.1f", self.activeCamera.panningXOffset or 0)
    local y = string.format("y %.1f", self.activeCamera.panningYOffset or 0)
    self.debugText:SetText(yt.." "..pt.." "..rt.." "..zt.." "..x.." "..y)
  end

  -- overload scene OnUpdate
  function scene:OnUpdate(elapsed)
    if self.activeCamera then
      -- calls ZorkCameraMixin:OnUpdate
      self.activeCamera:OnUpdate(elapsed)
    end
    self:UpdateDebugText()
  end

  function scene:IsLeftMouseButtonDown()
    return self.isLeftButtonDown
  end

  function scene:IsRightMouseButtonDown()
    return self.isRightButtonDown
  end

  --NEW: m4
  function scene:IsMouse4ButtonDown()
    return self.isButton4Down
  end

  --NEW: m5
  function scene:IsMouse5ButtonDown()
    return self.isButton5Down
  end

  -- overload scene OnMouseDown
  function scene:OnMouseDown(button)
    if button == "LeftButton" then
      self.isLeftButtonDown = true
    elseif button == "RightButton" then
      self.isRightButtonDown = true
    elseif button == "Button4" then
      self.isButton4Down = true
    elseif button == "Button5" then
      self.isButton5Down = true
    end
    if self.activeCamera then
      --current no overload on ZorkCameraMixin for OnMouseDown
      --will trigger CameraBaseMixin:OnMouseDown
      self.activeCamera:OnMouseDown(button)
      self:SetScript("OnUpdate", self.OnUpdate)
    end
  end

  -- overload scene OnMouseUp
  function scene:OnMouseUp(button)
    --remove the OnUpdate asap
    self:SetScript("OnUpdate", nil)
    if button == "LeftButton" then
      self.isLeftButtonDown = false
    elseif button == "RightButton" then
      self.isRightButtonDown = false
    elseif button == "Button4" then
      self.isButton4Down = false
    elseif button == "Button5" then
      self.isButton5Down = false
    end
    if self.activeCamera then
      --current no overload on ZorkCameraMixin for OnMouseUp
      --will trigger CameraBaseMixin:OnMouseUp
      --will reset model values if CTRL key is down while OnMouseUp
      if IsControlKeyDown() then
        self.activeCamera:SetAndRefreshValues()
        print(L.name, "Reseting data for id: "..self.modelFileID)
      end
    end
    SaveSceneData(scene)
  end

  -- overload scene OnMouseWheel
  function scene:OnMouseWheel(delta)
    if self.activeCamera then
      --calls ZorkCameraMixin:OnMouseWheel
      self.activeCamera:OnMouseWheel(delta)
    end
    SaveSceneData(scene)
  end

  -- by default do not activate mouse handling
  if enableMouse == true then
    scene.debugText = scene.orbFrame:CreateFontString(nil, "OVERLAY", "SystemFont_Tiny")
    scene.debugText:SetPoint("TOP")
    scene.debugText:SetAlpha(0.5)

    scene.modelInfoText = scene.orbFrame:CreateFontString(nil, "OVERLAY", "SystemFont_Tiny")
    scene.modelInfoText:SetPoint("BOTTOM")
    scene.modelInfoText:SetAlpha(0.5)

    scene:EnableMouse(true)
    scene:EnableMouseWheel(true)
    scene:SetScript("OnMouseDown", scene.OnMouseDown)
    scene:SetScript("OnMouseUp", scene.OnMouseUp)
    scene:SetScript("OnMouseWheel", scene.OnMouseWheel)
    --OnEnter
    scene:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_BOTTOM", 0, 5)
      GameTooltip:AddLine("Model adjustments.", 1, 1, 0, 1, 1, 1)
      GameTooltip:AddLine(" ")
      GameTooltip:AddLine("CTRL + any mousebutton to reset to model db defaults.", 1, 1, 1, 1, 1, 1)
      GameTooltip:AddLine(" ")
      GameTooltip:AddLine("CTRL+SHIFT+ALT + any mousebutton to reset to camera zero defaults.", 1, 1, 1, 1, 1, 1)
      GameTooltip:AddLine(" ")
      GameTooltip:AddLine("Left Mouse and drag x-axis for camera yaw -180° to 180°.", 1, 1, 1, 1, 1, 1)
      GameTooltip:AddLine("Left Mouse and drag y-axis for camera pitch -90° to 90°.", 1, 1, 1, 1, 1, 1)
      GameTooltip:AddLine("+ SHIFT to only use x-axis values.", 1, 1, 1, 1, 1, 1)
      GameTooltip:AddLine("+ ALT to only use y-axis values.", 1, 1, 1, 1, 1, 1)
      GameTooltip:AddLine(" ")
      GameTooltip:AddLine("Right Mouse and drag to move target.", 1, 1, 1, 1, 1, 1)
      GameTooltip:AddLine("+ SHIFT to only use x-axis values.", 1, 1, 1, 1, 1, 1)
      GameTooltip:AddLine("+ ALT to only use y-axis values.", 1, 1, 1, 1, 1, 1)
      GameTooltip:AddLine(" ")
      GameTooltip:AddLine("Mouse 4 or Mouse 5 and drag for camera roll.", 1, 1, 1, 1, 1, 1)
      GameTooltip:AddLine(" ")
      GameTooltip:AddLine("Mousewheel for zoom.", 1, 1, 1, 1, 1, 1)
      GameTooltip:AddLine("+ SHIFT to increase zoom speed.", 1, 1, 1, 1, 1, 1)
      GameTooltip:AddLine("+ ALT to decrease zoom speed.", 1, 1, 1, 1, 1, 1)
      GameTooltip:Show()
    end)
    --OnLeave
    scene:SetScript("OnLeave", function(self)
      GameTooltip:Hide()
    end)
  else
    scene:EnableMouse(false)
    scene:EnableMouseWheel(false)
    scene:SetScript("OnMouseDown", nil)
    scene:SetScript("OnMouseUp", nil)
    scene:SetScript("OnMouseWheel", nil)
  end

  --actor
  scene.zorkActor = scene:CreateActor()
  scene.zorkActor:SetPosition(0,0,0)

  --camera
  scene.zorkCamera = CameraRegistry:CreateCameraByType("ZorkCamera")
  --calls CameraBaseMixin:SetOwningScene -> ZorkCameraMixin:OnAdded
  --calls scene:SetActivCamera -> CameraBaseMixin:OnActivated
  --initializes the camera and positions it to look at taget 0,0,0
  scene:AddCamera(scene.zorkCamera) 

end

--orb:LoadModelDataByID(id)
function rModelOrbTemplateMixin:LoadModelDataByID(id, enableMouse)

  -- load the model view settings
  local modelData = self:GetModelDataByID(id)
  if not modelData then return end

  -- set reference
  local scene = self.ClipFrame.ModelFrame
  scene.orbFrame = self

  InitScene(scene, enableMouse)

  scene.zorkActor:SetModelByFileID(id)
  scene.modelFileID = id

  --print("loading", scene.modelFileID, modelData.name, string.format("%.3f", modelData.panX), string.format("%.3f", modelData.panY), string.format("%.3f", modelData.zoomDist), string.format("%.3f", modelData.yaw), string.format("%.3f", modelData.pitch), string.format("%.3f", modelData.roll))

  scene.activeCamera:SetAndRefreshValues(modelData.panX, modelData.panY, modelData.zoomDist, modelData.yaw, modelData.pitch, modelData.roll)
  scene:UpdateDebugText()
  if scene.modelInfoText then
    scene.modelInfoText:SetText("model-id: "..scene.modelFileID.." | name: "..modelData.name)
  end

  --filling and spark coloring color
  local r,g,b = 1,0,0
  if modelData.fillColor then    
    local color = CreateColorFromHexString(modelData.fillColor)
    r,g,b = color:GetRGB()
  else
    r,g,b = modelData.fR or 1, modelData.fG or 0, modelData.fB or 0
  end
  self.FillingStatusBar:SetStatusBarColor(r, g, b)
  self.OverlayFrame.SparkTexture:SetVertexColor(r, g, b)

end

-- rModelOrbFillingMixin:OnLoad
function rModelOrbFillingMixin:OnLoad()
  self:SetOrientation("VERTICAL")
  self:SetRotatesTexture(false)
  self:SetMinMaxValues(0, 1)
end

-- rModelOrbFillingMixin:OnValueChanged
function rModelOrbFillingMixin:OnValueChanged(value) end
function rModelOrbFillingMixin:OnShow() end
function rModelOrbFillingMixin:OnHide() end

-- rModelOrbClipMixin:OnLoad
function rModelOrbClipMixin:OnLoad()
  self:SetClipsChildren(true)
end

function rModelOrbClipMixin:OnShow() end
function rModelOrbClipMixin:OnHide() end

-- rModelOrbOverlayMixin:OnLoad
function rModelOrbOverlayMixin:OnLoad()
  self.SparkTexture:SetBlendMode("ADD")
  self.GlowTexture:SetBlendMode("BLEND")
  self.LowHealthTexture:SetBlendMode("ADD")
  local mask = self:CreateMaskTexture()
  mask:SetAllPoints()
  mask:SetTexture("Interface\\AddOns\\"..A.."\\media\\orb_spark_mask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
  self.SparkTexture:AddMaskTexture(mask)
  local orb = self:GetParent()
  orb.ClipFrame:SetPoint("TOPRIGHT", orb.FillingStatusBar:GetStatusBarTexture(), "TOPRIGHT")
  self.SparkTexture:SetPoint("TOP", orb.FillingStatusBar:GetStatusBarTexture(), 0, 16)
end

function rModelOrbOverlayMixin:OnShow() end
function rModelOrbOverlayMixin:OnHide() end
