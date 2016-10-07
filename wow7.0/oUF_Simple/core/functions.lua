
-- oUF_Simple: core/functions
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

local floor, unpack = floor, unpack

--functions container
L.F = {}

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
L.F.NumberFormat = NumberFormat

--CalcFrameSize
local function CalcFrameSize(numButtons,numCols,buttonWidth,buttonHeight,buttonMargin,framePadding)
  local numRows = ceil(numButtons/numCols)
  local frameWidth = numCols*buttonWidth + (numCols-1)*buttonMargin + 2*framePadding
  local frameHeight = numRows*buttonHeight + (numRows-1)*buttonMargin + 2*framePadding
  return frameWidth, frameHeight
end

--CreateBackdrop
local function CreateBackdrop(self,relativeTo)
  local backdrop = L.C.backdrop
  local bd = CreateFrame("Frame", nil, self)
  bd:SetFrameLevel(self:GetFrameLevel()-1 or 0)
  bd:SetPoint("TOPLEFT", relativeTo or self, "TOPLEFT", -backdrop.inset, backdrop.inset)
  bd:SetPoint("BOTTOMRIGHT", relativeTo or self, "BOTTOMRIGHT", backdrop.inset, -backdrop.inset)
  bd:SetBackdrop(backdrop)
  bd:SetBackdropColor(unpack(backdrop.bgColor))
  bd:SetBackdropBorderColor(unpack(backdrop.edgeColor))
end

--CreateIcon
local function CreateIcon(self,layer,sublevel,size,point)
  local icon = self:CreateTexture(nil,layer,nil,sublevel)
  icon:SetSize(size,size)
  icon:SetPoint(unpack(point))
  return icon
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
L.F.UpdateThreat = UpdateThreat

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
L.F.CreateText = CreateText

--AltPowerBarOverride
local function AltPowerBarOverride(self, event, unit, powerType)
  if self.unit ~= unit or powerType ~= 'ALTERNATE' then return end
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
  s:SetStatusBarTexture(L.C.mediapath.."statusbar")
  s:SetHeight(self:GetHeight()/5)
  s:SetWidth((self:GetWidth()-5)/2)
  if self.cfg.template == "pet" then
    s:SetPoint("BOTTOMLEFT",_G[A.."PlayerFrame"] or self,"TOPLEFT",0,3)
    if _G[A.."PlayerFrame"].AltPowerBar then
      s:SetWidth(_G[A.."PlayerFrame"].AltPowerBar:GetWidth())
    end
  else
    s:SetPoint("BOTTOMLEFT",self,"TOPLEFT",0,3)
  end
  --bg
  local bg = s:CreateTexture(nil, "BACKGROUND")
  bg:SetTexture(L.C.mediapath.."statusbar")
  bg:SetAllPoints(s)
  bg:SetVertexColor(0.7*0.3,0.7*0.3,0.7*0.3)
  s.bg = bg
  --backdrop
  CreateBackdrop(s)
  --reference
  self.AltPowerBar = s
  self.AltPowerBar.Override = AltPowerBarOverride
end
L.F.CreateAltPowerBar = CreateAltPowerBar

--CreateAbsorbBar
local function CreateAbsorbBar(self)
  local s = CreateFrame("StatusBar", nil, self.Health)
  s:SetAllPoints()
  s:SetStatusBarTexture(L.C.mediapath.."absorb")
  s:SetStatusBarColor(0.1,1,1,0.7)
  s:SetReverseFill(true)
  --reference
  self.rAbsorbBar = s
end
L.F.CreateAbsorbBar = CreateAbsorbBar

--CreateClassBar
local function CreateClassBar(self)
  local s = CreateFrame("StatusBar", nil, self)
  s:SetStatusBarTexture(L.C.mediapath.."statusbar")
  s:SetHeight(self:GetHeight()/5)
  s:SetWidth((self:GetWidth()-5)/2)
  s:SetPoint("BOTTOMRIGHT",self,"TOPRIGHT",0,3)
  --bg
  local bg = s:CreateTexture(nil, "BACKGROUND")
  bg:SetTexture(L.C.mediapath.."statusbar")
  bg:SetAllPoints(s)
  s.bg = bg
  --backdrop
  CreateBackdrop(s)
  --references
  self.rClassBar = s
end
L.F.CreateClassBar = CreateClassBar

--CreateHealthBar
local function CreateHealthBar(self)
  --statusbar
  local s = CreateFrame("StatusBar", nil, self)
  s:SetStatusBarTexture(L.C.mediapath.."statusbar")
  s:SetAllPoints()
  --bg
  local bg = s:CreateTexture(nil, "BACKGROUND")
  bg:SetTexture(L.C.mediapath.."statusbar")
  bg:SetAllPoints(s)
  --backdrop
  CreateBackdrop(s)
  --references
  self.Health = s
  self.Health.bg = bg
  --raid marker
  self.RaidIcon = CreateIcon(self.Health,"OVERLAY",-8,self:GetHeight()/1.2,{"CENTER",self.Health,"TOP",0,0})
  --hooks
  self.Health.PostUpdate = PostUpdateHealth
  --create absorb bar
  if self.cfg.template ~= "targettarget" then
    CreateAbsorbBar(self)
  end
end
L.F.CreateHealthBar = CreateHealthBar

--CreatePowerBar
local function CreatePowerBar(self)
  --statusbar
  local s = CreateFrame("StatusBar", nil, self)
  s:SetStatusBarTexture(L.C.mediapath.."statusbar")
  s:SetHeight(self:GetHeight()/5)
  s:SetWidth(self:GetWidth())
  s:SetPoint("TOP",self,"BOTTOM",0,-3)
  --bg
  local bg = s:CreateTexture(nil, "BACKGROUND")
  bg:SetTexture(L.C.mediapath.."statusbar")
  bg:SetAllPoints(s)
  --backdrop
  CreateBackdrop(s)
  --references
  self.Power = s
  self.Power.bg = bg
end
L.F.CreatePowerBar = CreatePowerBar

local function SetCastBarColorShielded(self)
  self.__owner:SetStatusBarColor(unpack(L.C.castbar.colors.shielded))
  self.__owner.bg:SetVertexColor(unpack(L.C.castbar.colors.shieldedBG))
end

local function SetCastBarColorDefault(self)
  self.__owner:SetStatusBarColor(unpack(L.C.castbar.colors.default))
  self.__owner.bg:SetVertexColor(unpack(L.C.castbar.colors.defaultBG))
end

--CreateCastBar
local function CreateCastBar(self)
  --statusbar
  local s = CreateFrame("StatusBar", nil, self)
  s:SetStatusBarTexture(L.C.mediapath.."statusbar")
  s:SetFrameStrata("MEDIUM")
  s:SetHeight(self:GetHeight())
  s:SetWidth(self:GetWidth())
  s:SetStatusBarColor(unpack(L.C.castbar.colors.default))
  --bg
  local bg = s:CreateTexture(nil, "BACKGROUND")
  bg:SetTexture(L.C.mediapath.."statusbar")
  bg:SetAllPoints(s)
  bg:SetVertexColor(unpack(L.C.castbar.colors.defaultBG)) --bg multiplier
  s.bg = bg
  --backdrop
  CreateBackdrop(s)
  --icon for player and target only
  if self.cfg.castbar.showIcon then
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
  hooksecurefunc(shield,"Show",SetCastBarColorShielded)
  hooksecurefunc(shield,"Hide",SetCastBarColorDefault)
  s.Shield = shield
  --text
  local name = CreateText(s,14,"LEFT")
  name:SetPoint("LEFT", s, "LEFT", 2, 0)
  name:SetPoint("RIGHT", s, "RIGHT", -2, 0)
  s.Text = name
  --references
  self.Castbar = s
end
L.F.CreateCastBar = CreateCastBar

--PostCreateAura
local function PostCreateAura(self,button)
  local bg = button:CreateTexture(nil,"BACKGROUND",nil,-8)
  bg:SetTexture(L.C.mediapath.."square")
  bg:SetVertexColor(0,0,0)
  bg:SetPoint("TOPLEFT", -self.size/4, self.size/4)
  bg:SetPoint("BOTTOMRIGHT", self.size/4, -self.size/4)
  button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
  button.count:SetFont(STANDARD_TEXT_FONT, self.size/1.6, "OUTLINE")
  button.count:SetShadowColor(0,0,0,0.6)
  button.count:SetShadowOffset(1,-1)
  button.count:ClearAllPoints()
  button.count:SetPoint("BOTTOMRIGHT", self.size/10, -self.size/10)
  button:SetFrameStrata("LOW")
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
L.F.CreateBuffs = CreateBuffs

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
  frame.filter = cfg.filter
  frame.PostCreateIcon = PostCreateAura
  --frame.PostUpdateIcon = PostUpdateDebuff
  frame:SetSize(CalcFrameSize(cfg.num,cfg.cols,cfg.size,cfg.size,cfg.spacing,0))
  --local t = frame:CreateTexture(nil,"BACKGROUND",nil,-8)
  --t:SetAllPoints()
  --t:SetColorTexture(1,0,0,0.2)
  self.Debuffs = frame
end
L.F.CreateDebuffs = CreateDebuffs

--SetupHeader
local function SetupHeader(self)
  self:RegisterForClicks("AnyDown")
  self:SetScript("OnEnter", UnitFrame_OnEnter)
  self:SetScript("OnLeave", UnitFrame_OnLeave)
end
L.F.SetupHeader = SetupHeader

--SetupFrame
local function SetupFrame(self)
  self:SetSize(unpack(self.cfg.size))
  self:SetPoint(unpack(self.cfg.point))
  self:SetScale(self.cfg.scale)
  if self.cfg.template ~= "nameplate" then
    SetupHeader(self)
    rLib:CreateDragFrame(self, L.dragFrames, -2, true)
  end
end
L.F.SetupFrame = SetupFrame