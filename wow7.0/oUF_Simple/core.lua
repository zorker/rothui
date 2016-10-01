
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

--NumberFormat
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

--CreateBackdrop
local function CreateBackdrop(self)
  local bd = CreateFrame("Frame", nil, self)
  bd:SetFrameLevel(self:GetFrameLevel()-1 or 0)
  bd:SetPoint("TOPLEFT",-backdrop.inset,backdrop.inset)
  bd:SetPoint("BOTTOMRIGHT",backdrop.inset,-backdrop.inset)
  bd:SetBackdrop(backdrop);
  bd:SetBackdropColor(0,0,0,0.8)
  bd:SetBackdropBorderColor(0,0,0,0.8)
end

--PostUpdateHealth
local function PostUpdateHealth(self, unit, min, max)
  if self.colorThreat and unit and UnitThreatSituation(unit) == 3 then
    self:SetStatusBarColor(1,0,0)
    self.bg:SetVertexColor(1*self.bg.multiplier,0,0)
  end
end

--UpdateThreat
local function UpdateThreat(self,event,unit)
  self.Health:ForceUpdate()
end

--CreateText
local function CreateText(self,size,align)
  local text = self:CreateFontString(nil, "OVERLAY")
  text:SetFont(STANDARD_TEXT_FONT, size or 14, "OUTLINE")
  text:SetJustifyH(align or "LEFT")
  text:SetShadowColor(0,0,0,0.6)
  text:SetShadowOffset(1,-1)
  --fix some wierd bug
  text:SetText("Bugfix")
  text:SetMaxLines(1)
  text:SetHeight(text:GetStringHeight())
  return text
end

--CreateHealth
local function CreateHealth(self)
  --statusbar
  local s = CreateFrame("StatusBar", nil, self)
  s:SetStatusBarTexture(mediapath.."statusbar")
  s:SetAllPoints()
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
end

--CreatePower
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

local function SetColorCastBarGrey(self)
  self.__owner:SetStatusBarColor(0.7,0.7,0.7,1)
  self.__owner.bg:SetVertexColor(0.7*0.3,0.7*0.3,0.7*0.3)
end

local function SetColorCastBarDefault(self)
  self.__owner:SetStatusBarColor(1,0.8,0,1)
  self.__owner.bg:SetVertexColor(1*0.3,0.8*0.3,0)
end

--CreateCastBar
local function CreateCastBar(self)
  --statusbar
  local s = CreateFrame("StatusBar", nil, self)
  s:SetStatusBarTexture(mediapath.."statusbar")
  s:SetHeight(self:GetHeight())
  s:SetWidth(self:GetWidth())
  s:SetStatusBarColor(1,0.8,0,1)
  --bg
  local bg = s:CreateTexture(nil, "BACKGROUND")
  bg:SetTexture(mediapath.."statusbar")
  bg:SetAllPoints(s)
  bg:SetVertexColor(1*0.3,0.8*0.3,0) --bg multiplier
  s.bg = bg
  --backdrop
  CreateBackdrop(s)
  --shield
  local shield = s:CreateTexture(nil,"BACKGROUND",nil,-8)
  shield.__owner = s
  --use a trick here...we use the show/hide on the shield texture to recolor the castbar
  hooksecurefunc(shield,"Show",SetColorCastBarGrey)
  hooksecurefunc(shield,"Hide",SetColorCastBarDefault)
  s.Shield = shield
  --text
  local name = CreateText(s,14,"LEFT")
  name:SetPoint("LEFT", s, "LEFT", 2, 0)
  name:SetPoint("RIGHT", s, "RIGHT", -2, 0)
  s.Text = name
  --references
  self.Castbar = s
end

--SetupHeader
local function SetupHeader(self)
  self:RegisterForClicks("AnyDown")
  self:SetScript("OnEnter", UnitFrame_OnEnter)
  self:SetScript("OnLeave", UnitFrame_OnLeave)
end

--SetupFrame
local function SetupFrame(self)
  self:SetSize(unpack(self.cfg.size))
  self:SetPoint(unpack(self.cfg.point))
  self:SetScale(self.cfg.scale)
  SetupHeader(self)
  rLib:CreateDragFrame(self, L.dragFrames, -2, true)
end

-----------------------------
-- oUF Tags
-----------------------------

--tag method: oUF_Simple:health
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
  return NumberFormat(hpmin).."|cffcccccc | |r"..hpper.."%"
end

--tag event: oUF_Simple:health
oUF.Tags.Events["oUF_Simple:health"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION"

-----------------------------
-- Templates
-----------------------------

local function CreatePlayerStyle(self)
  --frame config
  local cfg = {}
  cfg.size = {225,22}
  cfg.point = {"RIGHT",UIParent,"BOTTOM",-100,350}
  cfg.scale = 1
  cfg.template = "player"
  self.cfg = cfg
  --setup
  SetupFrame(self)
  --health
  CreateHealth(self)
  --power
  CreatePower(self)
  --castbar
  CreateCastBar(self)
  self.Castbar:SetPoint("BOTTOM",self,"TOP",0,15)
  --name
  local name = CreateText(self.Health,16,"LEFT")
  self:Tag(name, "[name]")
  name:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 2, -name:GetStringHeight()/3)
  --health text
  local healthText = CreateText(self.Health,13,"RIGHT")
  self:Tag(healthText, "[oUF_Simple:health]")
  healthText:SetPoint("RIGHT",-2,0)
  name:SetPoint("RIGHT",healthText,"LEFT",-2,0)
  --ouf config
  self.Health.colorClass = true
  self.Health.colorHealth = true
  self.Health.colorThreat = true
  self.Health.bg.multiplier = 0.3
  self.Power.colorPower = true
  self.Power.bg.multiplier = 0.3
  --events
    self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", UpdateThreat)
end

local function CreateTargetStyle(self)
  --frame config
  local cfg = {}
  cfg.size = {225,22}
  cfg.point = {"LEFT",UIParent,"BOTTOM",100,350}
  cfg.scale = 1
  cfg.template = "target"
  self.cfg = cfg
  --setup
  SetupFrame(self)
  --health
  CreateHealth(self)
  --power
  CreatePower(self)
  --castbar
  CreateCastBar(self)
  self.Castbar:SetPoint("BOTTOM",self,"TOP",0,15)
  --name
  local name = CreateText(self.Health,14,"LEFT")
  self:Tag(name, "[name]")
  name:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 2, -name:GetStringHeight()/3)
  --health text
  local healthText = CreateText(self.Health,13,"RIGHT")
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
  --events
  self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", UpdateThreat)
end

local function CreateTargetTargetStyle(self)
  --frame config
  local cfg = {}
  cfg.size = {110,22}
  cfg.point = {"TOPLEFT",_G[A.."TargetFrame"],"BOTTOMLEFT",0,-15}
  cfg.scale = 1
  cfg.template = "targettarget"
  self.cfg = cfg
  --setup
  SetupFrame(self)
  --health
  CreateHealth(self)
  --name
  local name = CreateText(self.Health,14,"CENTER")
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

local function CreatePetStyle(self)
  --frame config
  local cfg = {}
  cfg.size = {110,22}
  cfg.point = {"TOPLEFT",_G[A.."PlayerFrame"],"BOTTOMLEFT",0,-15}
  cfg.scale = 1
  cfg.template = "pet"
  self.cfg = cfg
  --setup
  SetupFrame(self)
  --health
  CreateHealth(self)
  --castbar
  CreateCastBar(self)
  self.Castbar:SetPoint("TOP",self,"BOTTOM",0,-5)
  --name
  local name = CreateText(self.Health,14,"CENTER")
  self:Tag(name, "[name]")
  name:SetPoint("CENTER", self.Health)
  name:SetPoint("LEFT", self.Health, "LEFT", 2, 0)
  name:SetPoint("RIGHT", self.Health, "RIGHT", -2, 0)
  --ouf config
  self.Health.colorClass = true
  self.Health.colorReaction = true
  self.Health.colorHealth = true
  self.Health.bg.multiplier = 0.3
end

local function CreateFocusStyle(self)
  --frame config
  local cfg = {}
  cfg.size = {110,22}
  cfg.point = {"TOPRIGHT",_G[A.."PlayerFrame"],"BOTTOMRIGHT",0,-15}
  cfg.scale = 1
  cfg.template = "focus"
  self.cfg = cfg
  --setup
  SetupFrame(self)
  --health
  CreateHealth(self)
  --castbar
  CreateCastBar(self)
  self.Castbar:SetPoint("TOP",self,"BOTTOM",0,-5)
  --name
  local name = CreateText(self.Health,14,"CENTER")
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
  self.Health.colorThreat = true
  self.Health.bg.multiplier = 0.3
  --events
  self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", UpdateThreat)
end

-----------------------------
-- Register Styles
-----------------------------

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

--register pet
oUF:RegisterStyle(A.."PetStyle", CreatePetStyle)
oUF:SetActiveStyle(A.."PetStyle")
local petFrame = oUF:Spawn("pet", A.."PetFrame")

--register focus
oUF:RegisterStyle(A.."FocusStyle", CreateFocusStyle)
oUF:SetActiveStyle(A.."FocusStyle")
local focusFrame = oUF:Spawn("focus", A.."FocusFrame")

-----------------------------
-- rLib slash command
-----------------------------

--create slash commands
rLib:CreateSlashCmd(L.addonName, L.addonShortcut, L.dragFrames, L.addonColor)