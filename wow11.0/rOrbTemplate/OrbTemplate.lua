-------------------------------------------------
-- Variables
-------------------------------------------------
local A, L = ...

local math = math
local pi, halfpi = math.pi, math.pi / 2

local ORB_MODELFRAME_MAX_ZOOM = 0.7
local ORB_MODELFRAME_MIN_ZOOM = 0.0
local ORB_MODELFRAME_DEFAULT_ROTATION = 0

local ORB_PAN_X_CONSTANT = 1.75
local ORB_PAN_Z_CONSTANT = 1.95

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
  if orb.ModelFrame.templateConfig then
    orb.ModelFrame:OrbModelAdjustPositionByValue(value)
  end
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

function OrbModelFrameMixin:OrbModelAdjustPositionByValue(value)
  -- print(A, 'OrbModelFrameMixin:OrbModelAdjustPositionByValue()')
  local orb = self:GetParent()

  local heightDiffPx = orb.height - orb.height * value

  local newPosX = self.origPosX + heightDiffPx * (self.templateConfig.camScale * ORB_PAN_X_CONSTANT) / orb.height
  local newPosY = self.origPosY
  local newPosZ = self.origPosZ + heightDiffPx * (self.templateConfig.camScale * ORB_PAN_Z_CONSTANT) / orb.height

  if self.templateConfig.panByPosAdjustZ and self.templateConfig.posAdjustZ then
    newPosX = newPosX + heightDiffPx * (math.abs(self.templateConfig.posAdjustZ) * ORB_PAN_X_CONSTANT) / orb.height
    newPosZ = newPosZ + heightDiffPx * (math.abs(self.templateConfig.posAdjustZ) * ORB_PAN_Z_CONSTANT) / orb.height
  elseif self.templateConfig.posAdjustZ and not self.templateConfig.panAdjustX and self.templateConfig.panAdjustZ then
    newPosZ = newPosZ + heightDiffPx * self.templateConfig.posAdjustZ / orb.height /
                (self.templateConfig.panAdjustZ * 1 / self.templateConfig.camScale)
  elseif self.templateConfig.panAdjustZ and self.templateConfig.panAdjustX then
    newPosX = newPosX + heightDiffPx * self.templateConfig.panAdjustX / orb.height
    newPosZ = newPosZ + heightDiffPx * self.templateConfig.panAdjustZ / orb.height
  elseif self.templateConfig.panAdjustZ then
    newPosZ = newPosZ + heightDiffPx * self.templateConfig.panAdjustZ / orb.height
  end
  if self.templateConfig.panAdjustY then
    newPosY = newPosY + heightDiffPx * self.templateConfig.panAdjustY / orb.height
  end
  self:SetPosition(newPosX, newPosY, newPosZ)
  if self.templateConfig.adjustRotationByValue then
    self:SetRotation(1 - value)
  end
  -- self:PrintPositionData()
end

function OrbModelFrameMixin:PrintPositionData()
  print("--------")
  print("GetPosition [positionX, positionY, positionZ]:", self:GetPosition())
  -- print("GetCameraDistance [distance]", self:GetCameraDistance())
  -- print("GetCameraFacing [radians]:", self:GetCameraFacing())
  -- print("GetCameraPosition [positionX, positionY, positionZ]:", self:GetCameraPosition())
  -- print("GetCameraRoll [radians]:", self:GetCameraRoll())
  -- print("GetCameraTarget [targetX, targetY, targetZ]:", self:GetCameraTarget())
  -- print("GetModelScale [scale]:", self:GetModelScale())
  -- print("UIParent:GetEffectiveScale [scale]:", UIParent:GetEffectiveScale())
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
  ctx = ctx + (self.templateConfig.posAdjustX or 0) * orb:GetScale()
  cty = cty + (self.templateConfig.posAdjustY or 0) * orb:GetScale()
  ctz = ctz + (self.templateConfig.posAdjustZ or 0) * orb:GetScale()
  self.origPosX = ctx
  self.origPosY = cty
  self.origPosZ = ctz
  self:SetPosition(self.origPosX, self.origPosY, self.origPosZ)
  self:SetCamDistanceScale(self.templateConfig.camScale or 1)
  self:SetRotation(self.templateConfig.rotation or 0)
end

function OrbModelFrameMixin:ResetOrbModel()
  -- print(A, 'OrbModelFrameMixin:CreateOrbModel()')
  self:ClearModel()
  self:SetDisplayInfo(self.templateConfig.displayInfoID)
  self:SetAlpha(self.templateConfig.modelOpacity)
end

function OrbModelFrameMixin:OrbModelOnSizeChanged(event)
  -- print(A, 'OrbModelFrameMixin:OnSizeChanged()')
end

-- OrbOverlayFrameMixin
function OrbOverlayFrameMixin:OnLoad()
  -- print(A, 'OrbOverlayFrameMixin:OnLoad()')
  self.SparkTexture:SetBlendMode("ADD")
  self.GlowTexture:SetBlendMode("BLEND")
  self.LowHealthTexture:SetBlendMode("BLEND")
  self:SetFrameLevel(self:GetParent().ModelFrame:GetFrameLevel() + 1)
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

function OrbTemplateMixin:SetOrbTemplate(templateName, templateConfig)
  -- print(A, 'OrbTemplateMixin:ChangeOrbTemplate()')
  if templateConfig and type(templateConfig) == "table" then
    self.templateConfig = templateConfig
  else
    self.templateConfig = L.orbLayouts[templateName]
  end
  self.ModelFrame.templateConfig = self.templateConfig
  self.templateName = templateName
  self.FillingStatusBar:SetStatusBarTexture(self.templateConfig.statusBarTexture)
  self.FillingStatusBar:SetStatusBarColor(unpack(self.templateConfig.statusBarColor))
  self.OverlayFrame.SparkTexture:SetVertexColor(unpack(self.templateConfig.sparkColor))
  if self.templateConfig.glowColor then
    self.OverlayFrame.GlowTexture:SetVertexColor(unpack(self.templateConfig.glowColor))
  end
  self.ModelFrame:ResetOrbModel()
end
