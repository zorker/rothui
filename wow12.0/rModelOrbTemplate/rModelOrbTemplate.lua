local A, L = ...

-------------------------------------------------
-- var
-------------------------------------------------

local TRANS_SCALE, ZOOM_SCALE, ROT_SCALE = 0.02, 0.02, 0.0174
local mpi, msin, mcos = math.pi, math.sin, math.cos

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
  return L.modelData
end

--orb:LoadModelDataByID(id)
function rModelOrbTemplateMixin:LoadModelDataByID(id)
  local modelData = L.modelData[id]
  if not modelData then return end

  --init and load scene and actor
  local scene = self.ClipFrame.ModelFrame
  scene:SetFromModelSceneIDZork(290)
  scene:SetScript("OnUpdate", nil)
  local actor = scene:GetActorAtIndex(1) or scene:CreateActor()
  actor:SetModelByFileID(id)
  scene:EnableMouse(false)
  scene:EnableMouseWheel(false)

  --filling and spark coloring color
  local r, g, b = (modelData and modelData.fR) or 1, (modelData and modelData.fG) or 0, (modelData and modelData.fB) or 0
  self.FillingStatusBar:SetStatusBarColor(r, g, b)
  self.OverlayFrame.SparkTexture:SetVertexColor(r, g, b)

  --setup actor and camera
  local camera = scene:GetActiveCamera()
  
  if not actor or not camera then return end
  --calculate position and yaw/pitch values from slider
  local slideX        = ((modelData and modelData.sX) or 0) * TRANS_SCALE
  local slideY        = ((modelData and modelData.sY) or 0) * ZOOM_SCALE
  local slideZ        = ((modelData and modelData.sZ) or 0) * TRANS_SCALE
  local slideYaw      = ((modelData and modelData.sYaw) or 0) * ROT_SCALE
  local slidePitch    = ((modelData and modelData.sPitch) or 0) * ROT_SCALE
  local cosYaw, sinYaw = mcos(slideYaw), msin(slideYaw)
  -- x, y, z
  actor:SetPosition((slideY * cosYaw) - (slideX * sinYaw), (slideY * sinYaw) + (slideX * cosYaw), slideZ)
  -- yaw and pitch
  camera:SetYaw(slideYaw)
  camera:SetPitch(slidePitch)

  camera:UpdateCameraOrientationAndPositionZork()
  
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
