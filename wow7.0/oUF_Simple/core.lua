
-- oUF_Simple: core
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

L.addonName       = A
L.dragFrames      = {}
L.addonColor      = "00FF3300"
L.addonShortcut   = "rsim"

local mediapath = "interface\\addons\\"..A.."\\media\\"

local backdrop = {
  bgFile = mediapath.."backdrop",
  edgeFile = mediapath.."backdrop_edge",
  tile = false,
  tileSize = 0,
  inset = 4,
  edgeSize = 4,
  insets = {
    left = 4,
    right = 4,
    top = 4,
    bottom = 4,
  },
}

-----------------------------
-- Functions
-----------------------------


local function CreateBackdrop(self)
  --helper
  local h = CreateFrame("Frame", nil, self)
  h:SetFrameLevel(self:GetFrameLevel()-1 or 0)
  h:SetPoint("TOPLEFT",-backdrop.inset,backdrop.inset)
  h:SetPoint("BOTTOMRIGHT",backdrop.inset,-backdrop.inset)
  h:SetBackdrop(backdrop);
  h:SetBackdropColor(0,0,0,0.8)
  h:SetBackdropBorderColor(0,0,0,0.8)
end

local function PostUpdateHealth(self, unit, min, max)
  if self.colorThreat and unit and UnitThreatSituation(unit) == 3 then
    self:SetStatusBarColor(1,0,0)
    self.bg:SetVertexColor(1*self.bg.multiplier,0,0)
  end
end

local function UpdateThreat(self,event,unit)
  self.Health:ForceUpdate()
end

local function CreateHealth(self)
  --statusbar
  local s = CreateFrame("StatusBar", nil, self)
  s:SetStatusBarTexture(mediapath.."statusbar")
  s:SetAllPoints()
  s.__owner = self
  --bg
  local bg = s:CreateTexture(nil, "BACKGROUND")
  bg:SetTexture(mediapath.."statusbar")
  bg:SetAllPoints(s)
  --backdrop
  CreateBackdrop(s)
  --references
  self.Health = s
  self.Health.bg = bg
  --hooks
  self.Health.PostUpdate = PostUpdateHealth
  self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", UpdateThreat)
end

local function CreatePower(self)
  --statusbar
  local s = CreateFrame("StatusBar", nil, self)
  s:SetStatusBarTexture(mediapath.."statusbar")
  s:SetHeight(self:GetHeight()/5)
  s:SetWidth(self:GetWidth())
  s:SetPoint("TOP",self,"BOTTOM",0,-3)
  --bg
  local bg = s:CreateTexture(nil, "BACKGROUND")
  bg:SetTexture(mediapath.."statusbar")
  bg:SetAllPoints(s)
  --backdrop
  CreateBackdrop(s)
  --references
  self.Power = s
  self.Power.bg = bg
end

local function CreateName(self,size,align)
  local name = self:CreateFontString(nil, "OVERLAY")
  name:SetFont(STANDARD_TEXT_FONT, size or 16, "OUTLINE")
  name:SetShadowColor(0,0,0,0.6)
  name:SetShadowOffset(1,-1)
  name:SetText("Fail")
  name:SetMaxLines(1)
  name:SetHeight(name:GetStringHeight()) --fix some wierd bug
  name:SetJustifyH(align or "LEFT")
  return name
end

local function SetupHeader(self)
  self:RegisterForClicks("AnyDown")
  self:SetScript("OnEnter", UnitFrame_OnEnter)
  self:SetScript("OnLeave", UnitFrame_OnLeave)
end

local function SetupFrame(self)
  self:SetSize(unpack(self.cfg.size))
  self:SetPoint(unpack(self.cfg.point))
  self:SetScale(self.cfg.scale)
  SetupHeader(self)
  rLib:CreateDragFrame(self, L.dragFrames, -2, true)
end

local function CreatePlayerStyle(self)
  --frame config
  local cfg = {}
  cfg.size = {220,25}
  cfg.point = {"RIGHT",UIParent,"BOTTOM",-100,350}
  cfg.scale = 1
  cfg.template = "player"
  self.cfg = cfg
  --setup
  SetupFrame(self)
  CreateHealth(self)
  CreatePower(self)
  local name = CreateName(self.Health)
  self:Tag(name, "[name]")
  name:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 2, -name:GetStringHeight()/2)
  name:SetPoint("RIGHT",-2,0)
  --ouf config
  self.Health.colorClass = true
  self.Health.colorHealth = true
  self.Health.colorThreat = true
  self.Health.bg.multiplier = 0.3
  self.Power.colorPower = true
  self.Power.bg.multiplier = 0.3
end

local function CreateTargetStyle(self)
  --frame config
  local cfg = {}
  cfg.size = {220,25}
  cfg.point = {"LEFT",UIParent,"BOTTOM",100,350}
  cfg.scale = 1
  cfg.template = "target"
  self.cfg = cfg
  --setup
  SetupFrame(self)
  CreateHealth(self)
  CreatePower(self)
  local name = CreateName(self.Health)
  self:Tag(name, "[name]")
  name:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 2, -name:GetStringHeight()/2)
  name:SetPoint("RIGHT",-2,0)
  --ouf config
  self.Health.colorTapping = true
  self.Health.colorDisconnected = true
  self.Health.colorClass = true
  self.Health.colorReaction = true
  self.Health.colorHealth = true
  self.Health.colorThreat = true
  self.Health.bg.multiplier = 0.3
  self.Power.colorPower = true
  self.Power.bg.multiplier = 0.3
end

local function CreateTargetTargetStyle(self)
  --frame config
  local cfg = {}
  cfg.size = {110,22}
  cfg.point = {"TOPLEFT",_G[A.."TargetFrame"],"BOTTOMLEFT",0,-20}
  cfg.scale = 1
  cfg.template = "targettarget"
  self.cfg = cfg
  --setup
  SetupFrame(self)
  CreateHealth(self)
  local name = CreateName(self.Health,14,"CENTER")
  self:Tag(name, "[name]")
  name:SetPoint("CENTER", self.Health)
  name:SetPoint("LEFT", self.Health, "LEFT", 2, 0)
  name:SetPoint("RIGHT", self.Health, "RIGHT", -2, 0)
  --ouf config
  self.Health.colorTapping = true
  self.Health.colorDisconnected = true
  self.Health.colorClass = true
  self.Health.colorReaction = true
  self.Health.colorHealth = true
  self.Health.bg.multiplier = 0.3
end

--register player
oUF:RegisterStyle(A.."PlayerStyle", CreatePlayerStyle)
oUF:SetActiveStyle(A.."PlayerStyle")
local playerFrame = oUF:Spawn("player", A.."PlayerFrame")

--register target
oUF:RegisterStyle(A.."TargetStyle", CreateTargetStyle)
oUF:SetActiveStyle(A.."TargetStyle")
local targetFrame = oUF:Spawn("target", A.."TargetFrame")

--register targettarget
oUF:RegisterStyle(A.."TargetTargetStyle", CreateTargetTargetStyle)
oUF:SetActiveStyle(A.."TargetTargetStyle")
local targettargetFrame = oUF:Spawn("targettarget", A.."TargetTargetFrame")

--create slash commands
rLib:CreateSlashCmd(L.addonName, L.addonShortcut, L.dragFrames, L.addonColor)