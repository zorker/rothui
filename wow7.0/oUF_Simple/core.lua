
-- oUF_Simple: core
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

local floor = floor

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

--number format func
local function NumberFormat(v)
  if v > 1E10 then
    return (floor(v/1E9)).."b"
  elseif v > 1E9 then
    return (floor((v/1E9)*10)/10).."b"
  elseif v > 1E7 then
    return (floor(v/1E6)).."m"
  elseif v > 1E6 then
    return (floor((v/1E6)*10)/10).."m"
  elseif v > 1E4 then
    return (floor(v/1E3)).."k"
  elseif v > 1E3 then
    return (floor((v/1E3)*10)/10).."k"
  else
    return v
  end
end

oUF.Tags.Methods["oUF_Simple:health"] = function(unit)
  if not UnitIsConnected(unit) then
    return "|cff999999Offline|r"
  end
  if(UnitIsDead(unit) or UnitIsGhost(unit)) then
    return "|cff999999Dead|r"
  end
  local hpmin, hpmax = UnitHealth(unit), UnitHealthMax(unit)
  local hpper = 0
  if hpmax > 0 then hpper = floor(hpmin/hpmax*100) end
  local hpval = NumberFormat(hpmin)
  return hpval.."|cffcccccc | |r"..hpper.."%"
end
oUF.Tags.Events["oUF_Simple:health"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION"

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

local function CreateHealthText(self,size,align)
  local text = self:CreateFontString(nil, "OVERLAY")
  text:SetFont(STANDARD_TEXT_FONT, size or 13, "OUTLINE")
  text:SetShadowColor(0,0,0,0.6)
  text:SetShadowOffset(1,-1)
  text:SetText("Fail")
  text:SetMaxLines(1)
  text:SetHeight(text:GetStringHeight()) --fix some wierd bug
  text:SetJustifyH(align or "RIGHT")
  return text
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
  --name
  local name = CreateName(self.Health)
  self:Tag(name, "[name]")
  name:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 2, -name:GetStringHeight()/3)
  name:SetPoint("RIGHT",-2,0)
  --health text
  local healthText = CreateHealthText(self.Health)
  self:Tag(healthText, "[oUF_Simple:health]")
  healthText:SetPoint("RIGHT",-2,0)
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
  --name
  local name = CreateName(self.Health)
  self:Tag(name, "[name]")
  name:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 2, -name:GetStringHeight()/3)
  --health text
  local healthText = CreateHealthText(self.Health)
  self:Tag(healthText, "[oUF_Simple:health]")
  healthText:SetPoint("RIGHT",-2,0)
  name:SetPoint("RIGHT",healthText,"LEFT",-2,0)
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
  --name
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