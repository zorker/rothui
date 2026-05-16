-------------------------------------------------
-- Variables
-------------------------------------------------
local A, L = ...

local TRANS_SCALE, ZOOM_SCALE, ROT_SCALE = 0.02, 0.02, 0.0174

rModelOrbTemplateMixin = {}
rModelOrbFillingMixin = {}
rModelOrbClipMixin = {}
rModelOrbSceneMixin = {}
rModelOrbOverlayMixin = {}

-------------------------------------------------
-- Functions
-------------------------------------------------

-- rModelOrbTemplateMixin
function rModelOrbTemplateMixin:OnLoad()
  --print('rModelOrbTemplateMixin:OnLoad()')
  --print(self:GetName(), self:GetParent():GetName())
end

function rModelOrbTemplateMixin:OnShow()
  --print(A, 'rModelOrbTemplateMixin:OnShow()')
end

function rModelOrbTemplateMixin:OnHide()
  --print(A, 'rModelOrbTemplateMixin:OnHide()')
end

function rModelOrbTemplateMixin:LoadModelDataByID(id)

  local modelData = L.modelData[id]

  if not modelData then return end

  local scene = self.ClipFrame.ModelFrame
  local actor = scene:GetActorAtIndex(1) or scene:CreateActor()
  scene:SetFromModelSceneID(290)
  actor:SetModelByFileID(id)

  --fill color
  local r, g, b = (modelData and modelData.fR) or 1, (modelData and modelData.fG) or 0, (modelData and modelData.fB) or 0
  self.FillingStatusBar:SetStatusBarColor(r, g, b)

  local camera = scene:GetActiveCamera()
  if not actor or not camera then return end
  --calculate position and yaw/pitch values from slider
  local slideX        = ((modelData and modelData.sX) or 0) * TRANS_SCALE
  local slideY        = ((modelData and modelData.sY) or 0) * ZOOM_SCALE
  local slideZ        = ((modelData and modelData.sZ) or 0) * TRANS_SCALE
  local slideYaw      = ((modelData and modelData.sYaw) or 0) * ROT_SCALE
  local slidePitch    = ((modelData and modelData.sPitch) or 0) * ROT_SCALE
  local cosYaw, sinYaw = math.cos(slideYaw), math.sin(slideYaw)
  -- x, y, z
  actor:SetPosition((slideY * cosYaw) - (slideX * sinYaw), (slideY * sinYaw) + (slideX * cosYaw), slideZ)
  -- yaw and pitch
  camera:SetYaw(slideYaw)
  camera:SetPitch(slidePitch)
  
end

-- rModelOrbFillingMixin
function rModelOrbFillingMixin:OnLoad()
  --print('rModelOrbFillingMixin:OnLoad()')
  --print(self, self:GetParent():GetName())
  --local orb = self:GetParent()
end

function rModelOrbFillingMixin:OnValueChanged(value)
  --print(A, 'rModelOrbFillingMixin:OnValueChanged()')
end

function rModelOrbFillingMixin:OnShow()
  --print(A, 'rModelOrbFillingMixin:OnShow()')
end

function rModelOrbFillingMixin:OnHide()
  --print(A, 'rModelOrbFillingMixin:OnHide()')
end

-- rModelOrbClipMixin
function rModelOrbClipMixin:OnLoad()
  --print('rModelOrbClipMixin:OnLoad()')
  --print(self, self:GetParent():GetName())
  --print('enabling child clipping')
  self:SetClipsChildren(true)
  --local orb = self:GetParent()
end

function rModelOrbClipMixin:OnShow()
  --print(A, 'rModelOrbClipMixin:OnShow()')
end

function rModelOrbClipMixin:OnHide()
  --print(A, 'rModelOrbClipMixin:OnHide()')
end

-- rModelOrbOverlayMixin
function rModelOrbOverlayMixin:OnLoad()
  --print(A, 'rModelOrbOverlayMixin:OnLoad()')
  --print(self:GetName(), self:GetParent():GetName())
  --local orb = self:GetParent()
end

function rModelOrbOverlayMixin:OnShow()
  --print(A, 'rModelOrbOverlayMixin:OnShow()')
end

function rModelOrbOverlayMixin:OnHide()
  --print(A, 'rModelOrbOverlayMixin:OnHide()')
end
