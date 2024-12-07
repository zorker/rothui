-------------------------------------------------
-- Variables
-------------------------------------------------
local A, L = ...

local math

local ORB_MODELFRAME_DRAG_ROTATION_CONSTANT = 0.010;
local ORB_MODELFRAME_MAX_ZOOM = 0.7;
local ORB_MODELFRAME_MIN_ZOOM = 0.0;
local ORB_MODELFRAME_ZOOM_STEP = 0.15;
local ORB_MODELFRAME_DEFAULT_ROTATION = 0;
local ORB_ROTATIONS_PER_SECOND = .5;
local ORB_MODELFRAME_MAX_PLAYER_ZOOM = 0.8;

-- print(A, 'OrbTemplate.lua file init')

OrbTemplateMixin = {}
OrbFillingStatusBarMixin = {}
OrbClipFrameMixin = {}
OrbModelContainerMixin = {}
OrbModelFrameMixin = {}

-------------------------------------------------
-- Functions
-------------------------------------------------

-- OrbTemplateMixin
function OrbTemplateMixin:OnLoad()
  print(A, 'OrbTemplateMixin:OnLoad()')
  self.height = self:GetHeight()
end

function OrbTemplateMixin:OnShow()
  print(A, 'OrbTemplateMixin:OnShow()')
end

function OrbTemplateMixin:OnHide()
  print(A, 'OrbTemplateMixin:OnHide()')
end

-- OrbFillingStatusBarMixin
function OrbFillingStatusBarMixin:OnLoad()
  print(A, 'OrbFillingStatusBarMixin:OnLoad()')
  self:SetOrientation("VERTICAL")
  self:SetReverseFill(false)
  self:SetMinMaxValues(0, 1)
  self.statusBarTexture = self:GetStatusBarTexture()
end

function OrbFillingStatusBarMixin:OnValueChanged(value)
  print(A, 'OrbFillingStatusBarMixin:OnValueChanged()')
  local orb = self:GetParent()
  local clip = orb.ClipFrame
  local container = orb.ClipFrame.ModelContainer
  clip:SetPoint("TOP", 0, -(orb.height - orb.height * value))
  container:SetPoint("BOTTOM", 0, (orb.height - orb.height * value))
end

function OrbFillingStatusBarMixin:OnShow()
  print(A, 'OrbFillingStatusBarMixin:OnShow()')
end

function OrbFillingStatusBarMixin:OnHide()
  print(A, 'OrbFillingStatusBarMixin:OnHide()')
end

-- OrbClipFrameMixin
function OrbClipFrameMixin:OnLoad()
  print(A, 'OrbClipFrameMixin:OnLoad()')
  local orb = self:GetParent()
  self:SetFrameLevel(orb.FillingStatusBar:GetFrameLevel() + 1)
end

function OrbClipFrameMixin:OnShow()
  print(A, 'OrbClipFrameMixin:OnShow()')
end

function OrbClipFrameMixin:OnHide()
  print(A, 'OrbClipFrameMixin:OnHide()')
end

-- OrbModelContainerMixin
function OrbModelContainerMixin:OnLoad()
  print(A, 'OrbModelContainerMixin:OnLoad()')
end

function OrbModelContainerMixin:OnShow()
  print(A, 'OrbModelContainerMixin:OnShow()')
end

function OrbModelContainerMixin:OnHide()
  print(A, 'OrbModelContainerMixin:OnHide()')
end

-- OrbModelFrameMixin
function OrbModelFrameMixin:OrbModelOnLoad()
  print(A, 'OrbModelFrameMixin:OnLoad()')
  -- mix in the blizzard model frame functions
  Mixin(self, ModelFrameMixin)
  -- load the OnLoad from the ModelFrameMixin
  self:OnLoad(ORB_MODELFRAME_MAX_ZOOM, ORB_MODELFRAME_MIN_ZOOM, ORB_MODELFRAME_DEFAULT_ROTATION)
end

function OrbModelFrameMixin:OrbModelOnShow()
  print(A, 'OrbModelFrameMixin:OnShow()')
end

function OrbModelFrameMixin:OrbModelOnHide()
  print(A, 'OrbModelFrameMixin:OnHide()')
end

function OrbModelFrameMixin:OrbModelUpdate()
  print(A, 'OrbModelFrameMixin:Update()')
end

function OrbModelFrameMixin:OrbModelOnEvent(event)
  print(A, 'OrbModelFrameMixin:OnEvent()', event)
  -- self:RefreshCamera()
  -- self:RefreshUnit()
end

function OrbModelFrameMixin:AdjustPosition()
  local px, py, pz = self:GetPosition()
end

function OrbModelFrameMixin:OrbModelOnModelLoaded()
  print(A, 'OrbModelFrameMixin:OnModelLoaded()')

  --reset model
  self:ResetModel()

  --ui scale
  local uiscale = UIParent:GetEffectiveScale()

  --model position
  local px, py, pz = self:GetPosition()
  --model postion but UI scale added on top
  local pxs, pys, pzs = px * uiscale, py * uiscale, pz * uiscale

  --camera position
  local cpx, cpy, cpz = self:GetCameraPosition()
  --camera postion but UI scale added on top
  local cpxs, cpys, cpzs = cpx * uiscale, cpy * uiscale, cpz * uiscale

  --calc diff
  local dcpx, dcpy, dcpz = cpx-cpxs, cpy-cpys, cpz-cpzs
  local dpx, dpy, dpz = px-pxs, py-pys, pz-pzs

  --calc new pos values
  local npx, npy, npz = dcpx-dpx, dcpy-dpy, dcpz-dpz

  self:SetPosition(npx,npy,npz)

  self:SetAlpha(0.5)

  self:RefreshCamera()

end

function OrbModelFrameMixin:OrbModelOnSizeChanged(event)
  print(A, 'OrbModelFrameMixin:OnSizeChanged()')
end
