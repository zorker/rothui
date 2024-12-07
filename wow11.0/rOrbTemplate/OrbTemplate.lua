local A, L = ...

print(A, 'OrbTemplate.lua file init')

OrbTemplateMixin = {}
OrbFillingStatusBarMixin = {}
OrbClipFrameMixin = {}
OrbModelContainerMixin = {}
OrbModelFrameMixin = {}

--OrbTemplateMixin
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

--OrbFillingStatusBarMixin
function OrbFillingStatusBarMixin:OnLoad()
  print(A, 'OrbFillingStatusBarMixin:OnLoad()')
  self:SetOrientation("VERTICAL")
  self:SetReverseFill(false)
  self:SetMinMaxValues(0,1)
  self.statusBarTexture = self:GetStatusBarTexture()
end

function OrbFillingStatusBarMixin:OnValueChanged(value)
  print(A, 'OrbFillingStatusBarMixin:OnValueChanged()')
  local orb = self:GetParent()
  local clip = orb.ClipFrame
  local container = orb.ClipFrame.ModelContainer
  clip:SetPoint("TOP",0,-orb.height*value)
  container:SetPoint("BOTTOM",0,orb.height*value)
end

function OrbFillingStatusBarMixin:OnShow()
  print(A, 'OrbFillingStatusBarMixin:OnShow()')
end

function OrbFillingStatusBarMixin:OnHide()
  print(A, 'OrbFillingStatusBarMixin:OnHide()')
end

--OrbClipFrameMixin
function OrbClipFrameMixin:OnLoad()
  print(A, 'OrbClipFrameMixin:OnLoad()')
  local orb = self:GetParent()
  self:SetFrameLevel(orb.FillingStatusBar:GetFrameLevel()+1)
end

function OrbClipFrameMixin:OnShow()
  print(A, 'OrbClipFrameMixin:OnShow()')
end

function OrbClipFrameMixin:OnHide()
  print(A, 'OrbClipFrameMixin:OnHide()')
end

--OrbModelContainerMixin
function OrbModelContainerMixin:OnLoad()
  print(A, 'OrbModelContainerMixin:OnLoad()')
end

function OrbModelContainerMixin:OnShow()
  print(A, 'OrbModelContainerMixin:OnShow()')
end

function OrbModelContainerMixin:OnHide()
  print(A, 'OrbModelContainerMixin:OnHide()')
end

--OrbModelFrameMixin
function OrbModelFrameMixin:OrbModelOnLoad()
  print(A, 'OrbModelFrameMixin:OnLoad()')
  --mix in the blizzard model frame functions
  Mixin(self, ModelFrameMixin)
  self:RegisterEvent("UI_SCALE_CHANGED")
  self:RegisterEvent("DISPLAY_SIZE_CHANGED")
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
  print(A, 'OrbModelFrameMixin:OnEvent()',event)
  --self:RefreshCamera()
  --self:RefreshUnit()
end

function OrbModelFrameMixin:OrbModelOnModelLoaded()
  print(A, 'OrbModelFrameMixin:OnModelLoaded()')
end

function OrbModelFrameMixin:OrbModelOnSizeChanged(event)
  print(A, 'OrbModelFrameMixin:OnSizeChanged()')
end