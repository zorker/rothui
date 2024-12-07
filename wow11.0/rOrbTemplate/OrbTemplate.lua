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
  -- self:RefreshCamera()
  -- self:RefreshUnit()
end

-- the filling bar ranges from 0 .. 1
-- calculate the y position offset and apply it to the mode
function OrbModelFrameMixin:OrbModelAdjustPositionByValue(value)
  -- print(A, 'OrbModelFrameMixin:OrbModelAdjustPositionByValue()')

  local orb = self:GetParent()
  local orbScale = orb:GetScale()
  local scale = UIParent:GetEffectiveScale()
  local camScale = self.orbSettings.camScale or 1
  scale = scale * 1 / camScale * orbScale
  local orbHeight = orb.height
  local dy = orbHeight - orbHeight * value
  local dys = dy * scale
  local px, py, pz = self.origPosX, self.origPosY, self.origPosZ
  local pay = self.orbSettings.panAdjustY or orbHeight / 2
  local pays = pay * scale
  local nz = (pz + dys / pays)

  self:SetPosition(px, py, nz)

end

function OrbModelFrameMixin:OrbModelOnModelLoaded()
  -- print(A, 'OrbModelFrameMixin:OnModelLoaded()')

  local orb = self:GetParent()
  self:SetPoint("TOP", orb.FillingStatusBar.statusBarTexture)

  -- reset model
  self:ResetModel()

  local orbScale = orb:GetScale()
  local scale = UIParent:GetEffectiveScale()
  local camScale = self.orbSettings.camScale or 1
  scale = scale * 1 / camScale * orbScale
  -- model position
  local px, py, pz = self:GetPosition()
  -- model postion but UI scale added on top
  local pxs, pys, pzs = px * scale, py * scale, pz * scale
  -- camera position
  local cpx, cpy, cpz = self:GetCameraPosition()
  -- camera postion but UI scale added on top
  local cpxs, cpys, cpzs = cpx * scale, cpy * scale, cpz * scale
  -- calc diff
  local dcpx, dcpy, dcpz = cpx - cpxs, cpy - cpys, cpz - cpzs
  local dpx, dpy, dpz = px - pxs, py - pys, pz - pzs
  -- calc new pos values
  local npx, npy, npz = dcpx - dpx, dcpy - dpy, dcpz - dpz

  self.origPosX = npx + self.orbSettings.posAdjustX * scale
  self.origPosY = npy + self.orbSettings.posAdjustY * scale
  self.origPosZ = npz + self.orbSettings.posAdjustZ * scale

  self:SetPosition(self.origPosX, self.origPosY, self.origPosZ)

  self:RefreshCamera()

end

function OrbModelFrameMixin:CreateOrbModel(displayInfoId, panAdjustY, camScale, posAdjustX, posAdjustY, posAdjustZ)
  -- print(A, 'OrbModelFrameMixin:CreateOrbModel()')
  self.orbSettings = {}
  self.orbSettings.camScale = camScale or 1
  self.orbSettings.panAdjustY = panAdjustY or 84
  self.orbSettings.posAdjustX = posAdjustX or 0
  self.orbSettings.posAdjustY = posAdjustY or 0
  self.orbSettings.posAdjustZ = posAdjustZ or 0

  self:SetDisplayInfo(displayInfoId)

end

function OrbModelFrameMixin:OrbModelOnSizeChanged(event)
  -- print(A, 'OrbModelFrameMixin:OnSizeChanged()')
end

-- OrbOverlayFrameMixin
function OrbOverlayFrameMixin:OnLoad()
  -- print(A, 'OrbOverlayFrameMixin:OnLoad()')
  self.SparkTexture:SetBlendMode("BLEND")
  self.GlowTexture:SetBlendMode("BLEND")
  local orb = self:GetParent()
  self:SetFrameLevel(orb.ModelFrame:GetFrameLevel()+1)
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