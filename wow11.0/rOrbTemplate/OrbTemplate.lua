-------------------------------------------------
-- Variables
-------------------------------------------------
local A, L = ...

local math = math
local pi, halfpi = math.pi, math.pi / 2

local ORB_MODELFRAME_DRAG_ROTATION_CONSTANT = 0.010;
local ORB_MODELFRAME_MAX_ZOOM = 0.7;
local ORB_MODELFRAME_MIN_ZOOM = 0.0;
local ORB_MODELFRAME_ZOOM_STEP = 0.15;
local ORB_MODELFRAME_DEFAULT_ROTATION = 0;
local ORB_ROTATIONS_PER_SECOND = .5;
local ORB_MODELFRAME_MAX_PLAYER_ZOOM = 0.8;

local ORB_USE_CAM_SCALE = true;
local ORB_USE_UI_SCALE = true;
local ORB_USE_MODEL_SCALE = true;
local ORB_USE_ORB_SCALE = true;

-- -- print(A, 'OrbTemplate.lua file init')

OrbTemplateMixin = {}
OrbFillingStatusBarMixin = {}
OrbModelFrameMixin = {}
OrbOverlayFrameMixin = {}

-------------------------------------------------
-- Functions
-------------------------------------------------

-- OrbTemplateMixin
function OrbTemplateMixin:OnLoad()
  -- print(A, 'OrbTemplateMixin:OnLoad()')
  self.height = self:GetHeight()
end

function OrbTemplateMixin:OnShow()
  -- print(A, 'OrbTemplateMixin:OnShow()')
end

function OrbTemplateMixin:OnHide()
  -- print(A, 'OrbTemplateMixin:OnHide()')
end

-- OrbFillingStatusBarMixin
function OrbFillingStatusBarMixin:OnLoad()
  -- print(A, 'OrbFillingStatusBarMixin:OnLoad()')
  self:SetOrientation("VERTICAL")
  self:SetReverseFill(false)
  self:SetMinMaxValues(0, 1)
  self.statusBarTexture = self:GetStatusBarTexture()
end

function OrbFillingStatusBarMixin:OnValueChanged(value)
  -- print(A, 'OrbFillingStatusBarMixin:OnValueChanged()')
  local orb = self:GetParent()
  orb.ModelFrame:OrbModelAdjustPositionByValue(value)
  orb.OverlayFrame:UpdateOrbSpark(value)
end

function OrbFillingStatusBarMixin:OnShow()
  -- print(A, 'OrbFillingStatusBarMixin:OnShow()')
end

function OrbFillingStatusBarMixin:OnHide()
  -- print(A, 'OrbFillingStatusBarMixin:OnHide()')
end

-- OrbModelFrameMixin
function OrbModelFrameMixin:OrbModelOnLoad()
  -- print(A, 'OrbModelFrameMixin:OnLoad()')
  -- mix in the blizzard model frame functions
  Mixin(self, ModelFrameMixin)
  -- load the OnLoad from the ModelFrameMixin
  self:OnLoad(ORB_MODELFRAME_MAX_ZOOM, ORB_MODELFRAME_MIN_ZOOM, ORB_MODELFRAME_DEFAULT_ROTATION)
end

function OrbModelFrameMixin:OrbModelOnShow()
  -- print(A, 'OrbModelFrameMixin:OnShow()')
end

function OrbModelFrameMixin:OrbModelOnHide()
  -- print(A, 'OrbModelFrameMixin:OnHide()')
end

function OrbModelFrameMixin:OrbModelUpdate()
  -- print(A, 'OrbModelFrameMixin:Update()')
end

function OrbModelFrameMixin:OrbModelOnEvent(event)
  -- print(A, 'OrbModelFrameMixin:OnEvent()', event)
  self:RefreshCamera()
  -- self:PrintPositionData()
end

-- the filling bar ranges from 0 .. 1
-- calculate the y position offset and apply it to the mode
function OrbModelFrameMixin:OrbModelAdjustPositionByValue(value)
  -- print(A, 'OrbModelFrameMixin:OrbModelAdjustPositionByValue()')
  local orb = self:GetParent()
  local heightDiffPx = orb.height - orb.height * value
  local newPosX = self.origPosX + heightDiffPx * self.orbConfig.panAdjustX / orb.height
  local newPosY = self.origPosY + heightDiffPx * self.orbConfig.panAdjustY / orb.height
  local newPosZ = self.origPosZ + heightDiffPx * self.orbConfig.panAdjustZ / orb.height
  self:SetPosition(newPosX, newPosY, newPosZ)
end

function OrbModelFrameMixin:PrintPositionData()
  print("--------")
  print("GetPosition [positionX, positionY, positionZ]:", self:GetPosition())
  -- print("GetCameraDistance [distance]", self:GetCameraDistance())
  -- print("GetCameraFacing [radians]:", self:GetCameraFacing())
  print("GetCameraPosition [positionX, positionY, positionZ]:", self:GetCameraPosition())
  -- print("GetCameraRoll [radians]:", self:GetCameraRoll())
  print("GetCameraTarget [targetX, targetY, targetZ]:", self:GetCameraTarget())
  -- print("GetModelScale [scale]:", self:GetModelScale())
  print("UIParent:GetEffectiveScale [scale]:", UIParent:GetEffectiveScale())
end

function OrbModelFrameMixin:OrbModelOnModelLoaded()
  -- print(A, 'OrbModelFrameMixin:OnModelLoaded()')
  local orb = self:GetParent()
  self:SetPoint("TOP", orb.FillingStatusBar.statusBarTexture)
  -- currently only 2 vectors are known. cameraPosition and cameraTarget.
  -- We can set the model position to the camera target.
  -- Then we can offset the model position if needed with addition posX, posY and posZ
  -- on top we can adjust the distance scale with SetCamDistanceScale
  self:ResetModel()
  local ctx, cty, ctz = self:GetCameraTarget()
  self.origPosX = ctx + self.orbConfig.posAdjustX
  self.origPosY = cty + self.orbConfig.posAdjustY
  self.origPosZ = ctz + self.orbConfig.posAdjustZ
  self:SetPosition(self.origPosX, self.origPosY, self.origPosZ)
  self:SetCamDistanceScale(self.orbConfig.camScale or 1)
end

function OrbModelFrameMixin:SetOrbModel()
  -- print(A, 'OrbModelFrameMixin:CreateOrbModel()')
  self:ClearModel()
  self:SetDisplayInfo(self.orbConfig.displayInfoID)
  self:SetAlpha(self.orbConfig.modelOpacity)
end

function OrbModelFrameMixin:OrbModelOnSizeChanged(event)
  -- print(A, 'OrbModelFrameMixin:OnSizeChanged()')
end

-- OrbOverlayFrameMixin
function OrbOverlayFrameMixin:OnLoad()
  -- print(A, 'OrbOverlayFrameMixin:OnLoad()')
  self.SparkTexture:SetBlendMode("ADD")
  self.GlowTexture:SetBlendMode("BLEND")
  local orb = self:GetParent()
  self:SetFrameLevel(orb.ModelFrame:GetFrameLevel() + 1)
end

-- OrbOverlayFrameMixin
function OrbOverlayFrameMixin:UpdateOrbSpark(value)
  -- print(A, 'OrbOverlayFrameMixin:UpdateOrbSpark()')
  local orb = self:GetParent()
  local multiplier = floor(math.sin(value * pi) * 100) / 100
  if multiplier <= 0.25 then
    self.SparkTexture:Hide()
  else
    self.SparkTexture:SetWidth(256 * orb.height / 256 * multiplier)
    self.SparkTexture:SetHeight(32 * orb.height / 256 * multiplier)
    self.SparkTexture:SetPoint("TOP", orb.FillingStatusBar.statusBarTexture, 0, 16 * orb.height / 256 * multiplier)
    self.SparkTexture:Show()
  end
end

function OrbOverlayFrameMixin:OnShow()
  -- print(A, 'OrbOverlayFrameMixin:OnShow()')
end

function OrbOverlayFrameMixin:OnHide()
  -- print(A, 'OrbOverlayFrameMixin:OnHide()')
end

function OrbTemplateMixin:SetOrbTemplate(templateName)
  -- print(A, 'OrbTemplateMixin:ChangeOrbTemplate()')
  self.orbConfig = L.orbLayouts[templateName]
  self.ModelFrame.orbConfig = self.orbConfig
  self.templateName = templateName
  self.FillingStatusBar:SetStatusBarTexture(self.orbConfig.statusBarTexture)
  self.FillingStatusBar:SetStatusBarColor(unpack(self.orbConfig.statusBarColor))
  self.OverlayFrame.SparkTexture:SetVertexColor(unpack(self.orbConfig.sparkColor))
  self.OverlayFrame.GlowTexture:SetVertexColor(unpack(self.orbConfig.glowColor))
  -- displayInfoID, panAdjustY, camScale, posAdjustX, posAdjustY, posAdjustZ
  self.ModelFrame:SetOrbModel(self.orbConfig)
end
