
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

--CalcFrameSize
local function CalcFrameSize(numButtons,numCols,buttonWidth,buttonHeight,buttonMargin,framePadding)
  local numRows = ceil(numButtons/numCols)
  local frameWidth = numCols*buttonWidth + (numCols-1)*buttonMargin + 2*framePadding
  local frameHeight = numRows*buttonHeight + (numRows-1)*buttonMargin + 2*framePadding
  return frameWidth, frameHeight
end

--CreateBackdrop
local function CreateBackdrop(self,anchorFrame)
  local bd = CreateFrame("Frame", nil, self)
  bd:SetFrameLevel(self:GetFrameLevel()-1 or 0)
  bd:SetPoint("TOPLEFT", anchorFrame or self, "TOPLEFT", -backdrop.inset, backdrop.inset)
  bd:SetPoint("BOTTOMRIGHT", anchorFrame or self, "BOTTOMRIGHT", backdrop.inset, -backdrop.inset)
  bd:SetBackdrop(backdrop);
  bd:SetBackdropColor(0,0,0,0.8)
  bd:SetBackdropBorderColor(0,0,0,0.8)
end

--PostUpdateHealth
local function PostUpdateHealth(self, unit, min, max)
  if self.__owner.cfg.template == "nameplate" and self.colorThreat and unit and UnitThreatSituation("player", unit) and UnitThreatSituation("player", unit) >= 3 then
    --color nameplate units green on full threat
    self:SetStatusBarColor(0,1,0)
    self.bg:SetVertexColor(0,1*self.bg.multiplier,0)
  elseif self.colorThreat and unit and UnitThreatSituation(unit) == 3 then
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

--AltPowerBarOverride
local function AltPowerBarOverride(self, event, unit, powerType)
  if self.unit ~= unit or powerType ~= 'ALTERNATE' then return end
  --if not self.AltPowerBar:IsShown() then return end
  local ppmax = UnitPowerMax(unit, ALTERNATE_POWER_INDEX, true) or 0
  local ppcur = UnitPower(unit, ALTERNATE_POWER_INDEX, true)
  local _, r, g, b = UnitAlternatePowerTextureInfo(unit, 2)
  local _, ppmin = UnitAlternatePowerInfo(unit)
  local el = self.AltPowerBar
  el:SetMinMaxValues(ppmin or 0, ppmax)
  el:SetValue(ppcur)
  if b then
    el:SetStatusBarColor(r, g, b)
    if el.bg then
      local mu = el.bg.multiplier or 0.3
      el.bg:SetVertexColor(r*mu, g*mu, b*mu)
    end
  else
    el:SetStatusBarColor(1, 0, 1)
    if el.bg then
      local mu = el.bg.multiplier or 0.3
      el.bg:SetVertexColor(1*mu, 0*mu, 1*mu)
    end
  end
end

--CreateAltPowerBar
local function CreateAltPowerBar(self)
  local s = CreateFrame("StatusBar", nil, self)
  s:SetStatusBarTexture(mediapath.."statusbar")
  s:SetHeight(self:GetHeight()/5)
  s:SetWidth((self:GetWidth()-5)/2)
  s:SetPoint("BOTTOMLEFT",self,"TOPLEFT",0,5)
  --bg
  local bg = s:CreateTexture(nil, "BACKGROUND")
  bg:SetTexture(mediapath.."statusbar")
  bg:SetAllPoints(s)
  bg:SetVertexColor(0.7*0.3,0.7*0.3,0.7*0.3)
  s.bg = bg
  --backdrop
  CreateBackdrop(s)
  --reference
  self.AltPowerBar = s
  self.AltPowerBar.Override = AltPowerBarOverride
end

--CreateAbsorbBar
local function CreateAbsorbBar(self)
  local s = CreateFrame("StatusBar", nil, self.Health)
  s:SetAllPoints()
  s:SetStatusBarTexture(mediapath.."absorb")
  s:SetStatusBarColor(0.1,1,1,0.7)
  s:SetReverseFill(true)
  --reference
  self.rAbsorbBar = s
end

--CreateClassBar
local function CreateClassBar(self)
  local s = CreateFrame("StatusBar", nil, self)
  s:SetStatusBarTexture(mediapath.."statusbar")
  s:SetHeight(self:GetHeight()/5)
  s:SetWidth((self:GetWidth()-5)/2)
  s:SetPoint("BOTTOMRIGHT",self,"TOPRIGHT",0,5)
  --bg
  local bg = s:CreateTexture(nil, "BACKGROUND")
  bg:SetTexture(mediapath.."statusbar")
  bg:SetAllPoints(s)
  s.bg = bg
  --backdrop
  CreateBackdrop(s)
  --references
  self.rClassBar = s
end

--CreateHealthBar
local function CreateHealthBar(self)
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
  --create absorb bar
  if self.cfg.template ~= "targettarget" then
    CreateAbsorbBar(self)
  end
end

--CreatePowerBar
local function CreatePowerBar(self)
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
  s:SetFrameStrata("HIGH")
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
  --icon for player and target only
  if self.cfg.template == "player" or self.cfg.template == "target" or self.cfg.template == "nameplate" then
    --icon
    local i = s:CreateTexture(nil,"BACKGROUND",nil,-8)
    i:SetSize(self:GetHeight(),self:GetHeight())
    i:SetPoint("RIGHT", s, "LEFT", -5, 0)
    i:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    s.Icon = i
    --backdrop (for the icon)
    CreateBackdrop(s,i)
  end
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

--PostCreateAura
local function PostCreateAura(self,button)
  local bg = button:CreateTexture(nil,"BACKGROUND",nil,-8)
  bg:SetTexture(mediapath.."square")
  bg:SetVertexColor(0,0,0)
  bg:SetPoint("TOPLEFT", -self.size/4, self.size/4)
  bg:SetPoint("BOTTOMRIGHT", self.size/4, -self.size/4)
  button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
end

--CreateBuffs
local function CreateBuffs(self,cfg)
  local frame = CreateFrame("Frame", nil, self)
  frame:SetPoint(unpack(cfg.point))
  frame.num = cfg.num
  frame.size = cfg.size
  frame.spacing = cfg.spacing
  frame.initialAnchor = cfg.initialAnchor
  frame['growth-x'] = cfg.growthX
  frame['growth-y'] = cfg.growthY
  frame.disableCooldown = cfg.disableCooldown
  frame.PostCreateIcon = PostCreateAura
  --frame.PostUpdateIcon = PostUpdateBuff
  frame:SetSize(CalcFrameSize(cfg.num,cfg.cols,cfg.size,cfg.size,cfg.spacing,0))
  --local t = frame:CreateTexture(nil,"BACKGROUND",nil,-8)
  --t:SetAllPoints()
  --t:SetColorTexture(0,1,0,0.2)
  self.Buffs = frame
end

--CreateDebuffs
local function CreateDebuffs(self,cfg)
  local frame = CreateFrame("Frame", nil, self)
  frame:SetPoint(unpack(cfg.point))
  frame.num = cfg.num
  frame.size = cfg.size
  frame.spacing = cfg.spacing
  frame.initialAnchor = cfg.initialAnchor
  frame['growth-x'] = cfg.growthX
  frame['growth-y'] = cfg.growthY
  frame.disableCooldown = cfg.disableCooldown
  frame.PostCreateIcon = PostCreateAura
  --frame.PostUpdateIcon = PostUpdateDebuff
  frame:SetSize(CalcFrameSize(cfg.num,cfg.cols,cfg.size,cfg.size,cfg.spacing,0))
  --local t = frame:CreateTexture(nil,"BACKGROUND",nil,-8)
  --t:SetAllPoints()
  --t:SetColorTexture(1,0,0,0.2)
  self.Debuffs = frame
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
  if self.cfg.template ~= "nameplate" then
    rLib:CreateDragFrame(self, L.dragFrames, -2, true)
  end
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
  CreateHealthBar(self)
  --power
  CreatePowerBar(self)
  --castbar
  CreateCastBar(self)
  self.Castbar:SetPoint("BOTTOM",self,"TOP",0,15)
  --classbar
  CreateClassBar(self)
  --altpowerbar
  CreateAltPowerBar(self)
  --name
  --local name = CreateText(self.rAbsorbBar or self.Health,14,"LEFT")
  --self:Tag(name, "[name]")
  --name:SetPoint("LEFT", self.Health, "LEFT", 2, 0)
  --name:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 2, -name:GetStringHeight()/3)
  --health text
  local healthText = CreateText(self.rAbsorbBar or self.Health,13,"RIGHT")
  self:Tag(healthText, "[oUF_Simple:health]")
  healthText:SetPoint("RIGHT",-2,0)
  --name:SetPoint("RIGHT",healthText,"LEFT",-2,0)
  --ouf config
  self.Health.colorClass = true
  self.Health.colorHealth = true
  self.Health.colorThreat = true
  self.Health.bg.multiplier = 0.3
  self.Power.colorPower = true
  self.Power.bg.multiplier = 0.3
  self.rClassBar.bg.multiplier = 0.3
  self.AltPowerBar.bg.multiplier = 0.3
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
  CreateHealthBar(self)
  --power
  CreatePowerBar(self)
  --castbar
  CreateCastBar(self)
  self.Castbar:SetPoint("BOTTOM",self,"TOP",0,15)
  --CreateBuffs
  local buffCfg = {
    point = {"BOTTOMLEFT",self,"RIGHT",10,5},
    num = 32,
    cols = 8,
    size = 20,
    spacing = 5,
    initialAnchor = "BOTTOMLEFT",
    growthX = "RIGHT",
    growthY = "UP",
    disableCooldown = true,
  }
  CreateBuffs(self,buffCfg)
  --CreateDebuffs
  local debuffCfg = {
    point = {"TOPLEFT",self,"RIGHT",10,-5},
    num = 40,
    cols = 8,
    size = 20,
    spacing = 5,
    initialAnchor = "TOPLEFT",
    growthX = "RIGHT",
    growthY = "DOWN",
    disableCooldown = true,
  }
  CreateDebuffs(self,debuffCfg)
  --name
  local name = CreateText(self.rAbsorbBar or self.Health,14,"LEFT")
  self:Tag(name, "[name]")
  name:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 2, -name:GetStringHeight()/3)
  --health text
  local healthText = CreateText(self.rAbsorbBar or self.Health,13,"RIGHT")
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
  CreateHealthBar(self)
  --CreateDebuffs
  local debuffCfg = {
    point = {"TOPLEFT",self,"BOTTOMLEFT",0,-5},
    num = 5,
    cols = 5,
    size = 18,
    spacing = 5,
    initialAnchor = "TOPLEFT",
    growthX = "RIGHT",
    growthY = "DOWN",
    disableCooldown = true,
  }
  CreateDebuffs(self,debuffCfg)
  --name
  local name = CreateText(self.Health,14,"CENTER")
  self:Tag(name, "[name]")
  --name:SetPoint("CENTER", self.Health)
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
  CreateHealthBar(self)
  --CreateDebuffs
  local debuffCfg = {
    point = {"TOPLEFT",self,"BOTTOMLEFT",0,-5},
    num = 5,
    cols = 5,
    size = 18,
    spacing = 5,
    initialAnchor = "TOPLEFT",
    growthX = "RIGHT",
    growthY = "DOWN",
    disableCooldown = true,
  }
  CreateDebuffs(self,debuffCfg)
  --castbar
  CreateCastBar(self)
  self.Castbar:SetPoint("TOP",self,"BOTTOM",0,-5)
  --name
  local name = CreateText(self.rAbsorbBar or self.Health,14,"CENTER")
  self:Tag(name, "[name]")
  --name:SetPoint("CENTER", self.Health)
  name:SetPoint("LEFT", self.Health, "LEFT", 2, 0)
  name:SetPoint("RIGHT", self.Health, "RIGHT", -2, 0)
  --ouf config
  self.Health.colorClass = true
  self.Health.colorReaction = true
  self.Health.colorHealth = true
  self.Health.colorThreat = true
  self.Health.bg.multiplier = 0.3
  --events
  self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", UpdateThreat)
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
  CreateHealthBar(self)
  --CreateDebuffs
  local debuffCfg = {
    point = {"TOPLEFT",self,"BOTTOMLEFT",0,-5},
    num = 5,
    cols = 5,
    size = 18,
    spacing = 5,
    initialAnchor = "TOPLEFT",
    growthX = "RIGHT",
    growthY = "DOWN",
    disableCooldown = true,
  }
  CreateDebuffs(self,debuffCfg)
  --castbar
  CreateCastBar(self)
  self.Castbar:SetPoint("TOP",self,"BOTTOM",0,-5)
  --name
  local name = CreateText(self.rAbsorbBar or self.Health,14,"CENTER")
  self:Tag(name, "[name]")
  --name:SetPoint("CENTER", self.Health)
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

local function CreatePartyStyle(self)
  --frame config
  local cfg = {}
  cfg.template = "party"
  self.cfg = cfg
  --setup
  SetupHeader(self)
  --health
  CreateHealthBar(self)
  --power
  CreatePowerBar(self)
  --CreateDebuffs
  local debuffCfg = {
    point = {"LEFT",self,"RIGHT",10,0},
    num = 5,
    cols = 5,
    size = 22,
    spacing = 5,
    initialAnchor = "TOPLEFT",
    growthX = "RIGHT",
    growthY = "DOWN",
    disableCooldown = true,
  }
  CreateDebuffs(self,debuffCfg)
  --name
  local name = CreateText(self.rAbsorbBar or self.Health,14,"LEFT")
  self:Tag(name, "[name]")
  name:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 2, -name:GetStringHeight()/3)
  --health text
  local healthText = CreateText(self.rAbsorbBar or self.Health,13,"RIGHT")
  self:Tag(healthText, "[oUF_Simple:health]")
  healthText:SetPoint("RIGHT",-2,0)
  name:SetPoint("RIGHT",healthText,"LEFT",-2,0)
  --ouf config
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

local function CreateNamePlateStyle(self)
  --frame config
  local cfg = {}
  cfg.size = {110,22}
  cfg.point = {"CENTER"}
  cfg.scale = 1*GetCVar("uiScale") --nameplates are not part of uiparent!
  cfg.template = "nameplate"
  self.cfg = cfg
  --setup
  SetupFrame(self)
  --health
  CreateHealthBar(self)
  --CreateDebuffs
  local debuffCfg = {
    point = {"BOTTOMLEFT",self,"TOPLEFT",0,5},
    num = 5,
    cols = 5,
    size = 18,
    spacing = 5,
    initialAnchor = "BOTTOMLEFT",
    growthX = "RIGHT",
    growthY = "UP",
    disableCooldown = true,
    filter = "HARMFUL|INCLUDE_NAME_PLATE_ONLY"
  }
  CreateDebuffs(self,debuffCfg)
  --castbar
  CreateCastBar(self)
  self.Castbar:SetPoint("TOP",self,"BOTTOM",0,-5)
  --name
  local name = CreateText(self.rAbsorbBar or self.Health,14,"CENTER")
  self:Tag(name, "[name]")
  --name:SetPoint("CENTER", self.Health)
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
  self.Health.frequentUpdates = true
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
-- Party
-----------------------------

oUF:RegisterStyle(A.."PartyStyle", CreatePartyStyle)
oUF:SetActiveStyle(A.."PartyStyle")

local party = oUF:SpawnHeader(
  A.."PartyHeader",
  nil,
  "custom [group:party,nogroup:raid] show; hide",
  "showPlayer", true,
  "showSolo",   false,
  "showParty",  true,
  "showRaid",   false,
  "point",      "BOTTOM",
  "xOffset",    0,
  "yOffset",    15,
  "oUF-initialConfigFunction", ([[
    self:SetWidth(%d)
    self:SetHeight(%d)
    self:SetScale(%f)
  ]]):format(150, 22, 1)
)
party:SetPoint("TOPLEFT",20,-20)

-----------------------------
-- Nameplates
-----------------------------

--register focus
oUF:RegisterStyle(A.."NamePlateStyle", CreateNamePlateStyle)
oUF:SetActiveStyle(A.."NamePlateStyle")

local W = CreateFrame("Frame") --worker
local UFM = {} --unit frame mixin
local C_NamePlate = C_NamePlate

-----------------------------
-- Hide Blizzard
-----------------------------

function W:UpdateNamePlateOptions(...)
  --print("UpdateNamePlateOptions",...)
end

--disable blizzard nameplates
NamePlateDriverFrame:UnregisterAllEvents()
NamePlateDriverFrame:Hide()
NamePlateDriverFrame.UpdateNamePlateOptions = W.UpdateNamePlateOptions

-----------------------------
-- Worker
-----------------------------

function W:NAME_PLATE_UNIT_ADDED(unit)
  local nameplate = C_NamePlate.GetNamePlateForUnit(unit)
  if not nameplate.unitFrame then
    local unitFrame = oUF:SpawnNamePlate(unit, A..nameplate:GetName(),nameplate)
    unitFrame:EnableMouse(false)
    nameplate.unitFrame = unitFrame
    Mixin(unitFrame, UFM)
  end
  nameplate.unitFrame:UnitAdded(nameplate,unit)
end

function W:NAME_PLATE_UNIT_REMOVED(unit)
  local nameplate = C_NamePlate.GetNamePlateForUnit(unit)
  nameplate.unitFrame:UnitRemoved(nameplate,unit)
end

function W:PLAYER_TARGET_CHANGED()
  local nameplate = C_NamePlate.GetNamePlateForUnit("target")
  if nameplate then
    nameplate.unitFrame:PlayerTargetChanged(nameplate,"target")
  end
end

function W:OnEvent(event,...)
  self[event](event,...)
end

W:SetScript("OnEvent", W.OnEvent)

W:RegisterEvent("NAME_PLATE_UNIT_ADDED")
W:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
W:RegisterEvent("PLAYER_TARGET_CHANGED")

-----------------------------
-- Unit Frame Mixin
-----------------------------

function UFM:UnitAdded(nameplate,unit)
  self:SetAttribute("unit", unit)
  self:UpdateAllElements("NAME_PLATE_UNIT_ADDED")
end

function UFM:PlayerTargetChanged(nameplate,unit)
  self:UpdateAllElements("PLAYER_TARGET_CHANGED")
end

function UFM:UnitRemoved(nameplate,unit)
  self:SetAttribute("unit", nil)
  self:UpdateAllElements("NAME_PLATE_UNIT_REMOVED")
end

-----------------------------
-- rLib slash command
-----------------------------

--create slash commands
rLib:CreateSlashCmd(L.addonName, L.addonShortcut, L.dragFrames, L.addonColor)