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

function OrbModelFrameMixin:OrbModelAdjustPositionByValue(value)
  -- print(A, 'OrbModelFrameMixin:OrbModelAdjustPositionByValue()')
  local orb = self:GetParent()
  local heightDiffPx = orb.height - orb.height * value
  local newPosX = self.origPosX + heightDiffPx * (self.orbConfig.camScale * ORB_PAN_X_CONSTANT) / orb.height
  local newPosZ = self.origPosZ + heightDiffPx * (self.orbConfig.camScale * ORB_PAN_Z_CONSTANT) / orb.height

  if self.orbConfig.panByPosAdjustZ and self.orbConfig.posAdjustZ then
    newPosX = newPosX + heightDiffPx * (math.abs(self.orbConfig.posAdjustZ) * ORB_PAN_X_CONSTANT) / orb.height
    newPosZ = newPosZ + heightDiffPx * (math.abs(self.orbConfig.posAdjustZ) * ORB_PAN_Z_CONSTANT) / orb.height
  elseif self.orbConfig.posAdjustZ and not self.orbConfig.panAdjustX and self.orbConfig.panAdjustZ then
    newPosZ = newPosZ + heightDiffPx * self.orbConfig.posAdjustZ / orb.height /
                (self.orbConfig.panAdjustZ * 1 / self.orbConfig.camScale)
  elseif self.orbConfig.panAdjustZ and self.orbConfig.panAdjustX then
    newPosX = newPosX + heightDiffPx * self.orbConfig.panAdjustX / orb.height
    newPosZ = newPosZ + heightDiffPx * self.orbConfig.panAdjustZ / orb.height
  end
  self:SetPosition(newPosX, self.origPosY, newPosZ)
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
  if self.orbConfig.posAdjustX then
    ctx = ctx + self.orbConfig.posAdjustX * orb:GetScale()
  end
  if self.orbConfig.posAdjustY then
    cty = cty + self.orbConfig.posAdjustY * orb:GetScale()
  end
  if self.orbConfig.posAdjustZ then
    ctz = ctz + self.orbConfig.posAdjustZ * orb:GetScale()
  end
  self.origPosX = ctx
  self.origPosY = cty
  self.origPosZ = ctz
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
    self.orbConfig = templateConfig
  else
    self.orbConfig = L.orbLayouts[templateName]
  end
  self.ModelFrame.orbConfig = self.orbConfig
  self.templateName = templateName
  self.FillingStatusBar:SetStatusBarTexture(self.orbConfig.statusBarTexture)
  self.FillingStatusBar:SetStatusBarColor(unpack(self.orbConfig.statusBarColor))
  self.OverlayFrame.SparkTexture:SetVertexColor(unpack(self.orbConfig.sparkColor))
  self.OverlayFrame.GlowTexture:SetVertexColor(unpack(self.orbConfig.glowColor))
  self.ModelFrame:SetOrbModel()
end
