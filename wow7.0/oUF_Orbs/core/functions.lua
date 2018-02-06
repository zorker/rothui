
-- oUF_Orbs: core/functions
-- zork, 2018

-----------------------------
-- Variables
-----------------------------

local A, L = ...

local floor, unpack, mrad = floor, unpack, math.rad

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

--SetPoint
local function SetPoint(self,relativeTo,point)
  --adjut the setpoint function to make it possible to reference a relativeTo object that is set on runtime and it not available on config init
  local a,b,c,d,e = unpack(point)
  if not b then
    self:SetPoint(a)
  elseif b and type(b) == "string" and not _G[b] then
    self:SetPoint(a,relativeTo,b,c,d)
  else
    self:SetPoint(a,b,c,d,e)
  end
end

--SetPoints
local function SetPoints(self,relativeTo,points)
  for i, point in next, points do
    SetPoint(self,relativeTo,point)
  end
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

--StatusBarOnColorChanged
local function StatusBarOnColorChanged(self,r,g,b,a)
  if not self.__fill then return end
  self.__fill:SetVertexColor(r,g,b,a or 1)
end

--StatusBarOnValueChanged
local function StatusBarOnValueChanged(self,value)
  if not self.__fill then return end
  if self:GetStatusBarTexture() and self:GetStatusBarTexture():GetTexture() then
    self.texture = nil
    self:SetStatusBarTexture(nil)
  end
  if not value then value = self:GetValue() end
  if value == 0 then
    self:Hide()
    return
  elseif not self:IsShown() then
    self:Show()
  end
  local minvalue, maxvalue = self:GetMinMaxValues()
  local percvalue, direction = value/maxvalue, -1
  if not self.__fill.clockwise then direction = 1 end
  local arc = 180*percvalue*direction+self.__fill.baseRotation
  self.__fill:SetRotation(mrad(arc))
end

--CreateIcon
local function CreateIcon(self,layer,sublevel,size,point)
  local icon = self:CreateTexture(nil,layer,nil,sublevel)
  icon:SetSize(unpack(size))
  SetPoint(icon,self,point)
  return icon
end

local function ColorHealthbarOnThreat(self,unit)
  if self.colorThreat and self.colorThreatInvers and unit and UnitThreatSituation("player", unit) == 3 then
    self:SetStatusBarColor(unpack(L.C.colors.healthbar.threatInvers))
    self.bg:SetVertexColor(unpack(L.C.colors.healthbar.threatInversBG))
  elseif self.colorThreat and unit and UnitThreatSituation(unit) == 3 then
    self:SetStatusBarColor(unpack(L.C.colors.healthbar.threat))
    self.bg:SetVertexColor(unpack(L.C.colors.healthbar.threatBG))
  end
end

--PostUpdateHealth
local function PostUpdateHealth(self, unit, min, max)
  ColorHealthbarOnThreat(self,unit)
end

--UpdateThreat
local function UpdateThreat(self,event,unit)
  if event == "PLAYER_ENTER_COMBAT" or event == "PLAYER_LEAVE_COMBAT" then
    --do natting
  elseif self.unit ~= unit then
    return
  end
  self.Health:ForceUpdate()
end
L.F.UpdateThreat = UpdateThreat

--CreateText
local function CreateText(self,font,size,outline,align,noshadow)
  local text = self:CreateFontString(nil, "ARTWORK") --"BORDER", "OVERLAY"
  text:SetFont(font or STANDARD_TEXT_FONT, size or 14, outline or "OUTLINE")
  text:SetJustifyH(align or "LEFT")
  if not noshadow then
    text:SetShadowColor(0,0,0,0.6)
    text:SetShadowOffset(1,-1)
  end
  --fix some wierd bug
  text:SetText("Bugfix")
  text:SetMaxLines(1)
  text:SetHeight(text:GetStringHeight())
  return text
end
L.F.CreateText = CreateText

--AltPowerBarOverride
local function AltPowerBarOverride(self, event, unit, powerType)
  if self.unit ~= unit or powerType ~= "ALTERNATE" then return end
  local ppmax = UnitPowerMax(unit, ALTERNATE_POWER_INDEX, true) or 0
  local ppcur = UnitPower(unit, ALTERNATE_POWER_INDEX, true)
  local _, r, g, b = UnitAlternatePowerTextureInfo(unit, 2)
  local _, ppmin = UnitAlternatePowerInfo(unit)
  local el = self.AlternativePower
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
  if not self.cfg.altpowerbar or not self.cfg.altpowerbar.enabled then return end
  --statusbar
  local s = CreateFrame("StatusBar", nil, self)
  s:SetStatusBarTexture(L.C.textures.statusbar)
  s:SetSize(unpack(self.cfg.altpowerbar.size))
  SetPoint(s,self,self.cfg.altpowerbar.point)
  --bg
  local bg = s:CreateTexture(nil, "BACKGROUND")
  bg:SetTexture(L.C.textures.statusbar)
  bg:SetAllPoints()
  s.bg = bg
  --backdrop
  CreateBackdrop(s)
  --attributes
  s.Override = AltPowerBarOverride
  s.bg.multiplier = L.C.colors.bgMultiplier
  return s
end
L.F.CreateAltPowerBar = CreateAltPowerBar

--CreateAbsorbBar
local function CreateAbsorbBar(self)
  if not self.cfg.aborbbar or not self.cfg.aborbbar.enabled then return end
  --statusbar
  local s = CreateFrame("StatusBar", nil, self.Health)
  s:SetAllPoints()
  s:SetStatusBarTexture(L.C.textures.absorb)
  s:SetStatusBarColor(unpack(L.C.colors.healthbar.absorb))
  s:SetReverseFill(true)
  return s
end
L.F.CreateAbsorbBar = CreateAbsorbBar

--CreateClassBar
local function CreateClassBar(self)
  if not self.cfg.classbar or not self.cfg.classbar.enabled then return end
  --statusbar
  local s = CreateFrame("StatusBar", nil, self)
  s:SetStatusBarTexture(L.C.textures.statusbar)
  s:SetSize(unpack(self.cfg.classbar.size))
  SetPoint(s,self,self.cfg.classbar.point)
  --bg
  local bg = s:CreateTexture(nil, "BACKGROUND")
  bg:SetTexture(L.C.textures.statusbar)
  bg:SetAllPoints()
  s.bg = bg
  --backdrop
  CreateBackdrop(s)
  --attributes
  s.bg.multiplier = L.C.colors.bgMultiplier
  return s
end
L.F.CreateClassBar = CreateClassBar

--CreateHealthBar
local function CreateHealthBar(self)
  --orb health statusbar
  local s = CreateFrame("StatusBar", nil, self)
  s:SetStatusBarTexture(L.C.mediapath.."orb_fill")
  s:SetPoint("CENTER")
  s:SetSize(L.C.size*0.63,L.C.size*0.63)
  s:SetOrientation("VERTICAL")
  --default color
  if L.C.colors.healthbar and L.C.colors.healthbar.default then
    s:SetStatusBarColor(unpack(L.C.colors.healthbar.default))
  end
  --orb background
  local bg = s:CreateTexture(nil,"BACKGROUND",nil,-8)
  bg:SetTexture(L.C.mediapath.."orb_bg")
  bg:SetAllPoints(self)
  --make sure the statusbar texture has the correct draw layer
  s:GetStatusBarTexture():SetDrawLayer("BACKGROUND", -6)
  --low health glow
  local lowhp = s:CreateTexture(nil,"BACKGROUND",nil,-4)
  lowhp:SetTexture(L.C.mediapath.."orb_health_glow")
  lowhp:SetPoint("CENTER")
  lowhp:SetSize(L.C.size*0.68,L.C.size*0.68)
  lowhp:SetVertexColor(1,0,0)
  lowhp:SetBlendMode("BLEND")
  lowhp:Hide()
  s.__lowhp = lowhp
  --debuff glow
  local debuff = s:CreateTexture(nil,"BACKGROUND",nil,-3)
  debuff:SetTexture(L.C.mediapath.."orb_debuff_glow")
  debuff:SetPoint("CENTER")
  debuff:SetSize(L.C.size*0.68,L.C.size*0.68)
  debuff:SetVertexColor(1,0,1)
  debuff:SetBlendMode("BLEND")
  debuff:Hide()
  s.__debuff = debuff
  --orb highlight
  local hl = s:CreateTexture(nil,"BACKGROUND",nil,1)
  hl:SetTexture(L.C.mediapath.."orb_hl")
  hl:SetAllPoints(self)
  --attributes
  s.colorTapping = self.cfg.healthbar.colorTapping
  s.colorDisconnected = self.cfg.healthbar.colorDisconnected
  s.colorReaction = self.cfg.healthbar.colorReaction
  s.colorClass = self.cfg.healthbar.colorClass
  s.colorHealth = self.cfg.healthbar.colorHealth
  s.colorThreat = self.cfg.healthbar.colorThreat
  s.colorThreatInvers = self.cfg.healthbar.colorThreatInvers
  s.frequentUpdates = self.cfg.healthbar.frequentUpdates
  return s
end
L.F.CreateHealthBar = CreateHealthBar

local function CreateRingBar(self,segment,clockwise)
  --statusbar
  local s = CreateFrame("StatusBar", nil, self)
  s:SetAllPoints(self)
  s:HookScript("OnValueChanged",StatusBarOnValueChanged)
  hooksecurefunc(s,"SetStatusBarColor",StatusBarOnColorChanged)
  --ring background
  local bg = s:CreateTexture(nil,"BACKGROUND",nil,-8)
  bg:SetTexture(L.C.mediapath..segment.."_bg")
  bg:SetAllPoints(self)
  --ring background 2 (based on the mask for additional shadow)
  local bg2 = s:CreateTexture(nil,"BACKGROUND",nil,-7)
  bg2:SetTexture(L.C.mediapath..segment.."_mask")
  bg2:SetAllPoints(self)
  bg2:SetVertexColor(0,0,0,0.6)
  --ring mask
  local mask = s:CreateMaskTexture()
  mask:SetTexture(L.C.mediapath..segment.."_mask")
  mask:SetAllPoints(self)
  --fill
  local fill = s:CreateTexture(nil,"BACKGROUND",nil,-6)
  s.__fill = fill
  fill:AddMaskTexture(mask)
  fill:SetTexture(L.C.mediapath..segment.."_fill")
  fill:SetPoint("CENTER")
  --fill:SetBlendMode("BLEND")
  --size is kind of wonky because of math mult with sqrt(2) (Blizzards intention was it make the texture fit to square on rotation)
  local w,h = self:GetSize()
  fill:SetSize(sqrt(2)*w,sqrt(2)*h)
  fill.baseRotation = -180
  fill.clockwise = clockwise
  fill:SetRotation(mrad(fill.baseRotation))
  --highlight
  local hl = s:CreateTexture(nil,"BACKGROUND",nil,1)
  hl:SetTexture(L.C.mediapath..segment.."_hl")
  hl:SetAllPoints(self)
  return s
end

--CreatePowerBar
local function CreatePowerBar(self)
  if not self.cfg.powerbar or not self.cfg.powerbar.enabled then return end
  local s = CreateRingBar(self,self.cfg.powerbar.segment,self.cfg.powerbar.clockwise)
  --attributes
  s.colorPower = self.cfg.powerbar.colorPower
  return s
end
L.F.CreatePowerBar = CreatePowerBar

local function CastBarShieldOnShow(self)
  self.__fill:SetVertexColor(unpack(L.C.colors.castbar.shielded))
end

local function CastBarShieldOnHide(self)
  self.__fill:SetVertexColor(unpack(L.C.colors.castbar.default))
end

--CreateCastBar
local function CreateCastBar(self)
  if not self.cfg.castbar or not self.cfg.castbar.enabled then return end
  local s = CreateRingBar(self,self.cfg.castbar.segment,self.cfg.castbar.clockwise)
  --icon
  if self.cfg.castbar.icon and self.cfg.castbar.icon.enabled then
    local size = self.cfg.castbar.icon.size or 72
    local point = self.cfg.castbar.icon.point or {"CENTER","LEFT",36,0}
    --bg
    local bg = s:CreateTexture(nil,"BACKGROUND",nil,2)
    bg:SetTexture(L.C.mediapath.."icon_bg")
    --icon
    local i = s:CreateTexture(nil,"BACKGROUND",nil,3)
    i:SetSize(size,size)
    SetPoint(i,s,point)
    --highlight
    local hl = s:CreateTexture(nil,"BACKGROUND",nil,4)
    hl:SetTexture(L.C.mediapath.."icon_hl")
    --portrait mask
    local mask = s:CreateMaskTexture()
    mask:SetTexture(L.C.mediapath.."icon_mask")
    --points
    bg:SetAllPoints(i)
    hl:SetAllPoints(i)
    mask:SetAllPoints(i)
    i:AddMaskTexture(mask)
    s.Icon = i
  end
  --shield
  local shield = s:CreateTexture(nil,"BACKGROUND",nil,-8)
  shield.__fill = s.__fill
  s.Shield = shield
  --use a trick here...we use the show/hide on the shield texture to recolor the castbar
  hooksecurefunc(shield,"Show",CastBarShieldOnShow)
  hooksecurefunc(shield,"Hide",CastBarShieldOnHide)
  return s
end
L.F.CreateCastBar = CreateCastBar

local function CreateRaidMark(self)
  if not self.cfg.raidmark or not self.cfg.raidmark.enabled then return end
  return CreateIcon(self.Health,"OVERLAY",-8,self.cfg.raidmark.size,self.cfg.raidmark.point)
end
L.F.CreateRaidMark = CreateRaidMark

--CreateNameText
local function CreateNameText(self)
  if not self.cfg.healthbar or not self.cfg.healthbar.name or not self.cfg.healthbar.name.enabled then return end
  local cfg = self.cfg.healthbar.name
  local text = CreateText(self.rAbsorbBar or self.Health,cfg.font,cfg.size,cfg.outline,cfg.align,cfg.noshadow)
  if cfg.points then
    SetPoints(text,self.rAbsorbBar or self.Health,cfg.points)
  else
    SetPoint(text,self.rAbsorbBar or self.Health,cfg.point)
  end
  self:Tag(text, cfg.tag)
end
L.F.CreateNameText = CreateNameText

--CreateHealthText
local function CreateHealthText(self)
  if not self.cfg.healthbar or not self.cfg.healthbar.health or not self.cfg.healthbar.health.enabled then return end
  local cfg = self.cfg.healthbar.health
  local text = CreateText(self.rAbsorbBar or self.Health,cfg.font,cfg.size,cfg.outline,cfg.align,cfg.noshadow)
  if cfg.points then
    SetPoints(text,self.rAbsorbBar or self.Health,cfg.points)
  else
    SetPoint(text,self.rAbsorbBar or self.Health,cfg.point)
  end
  self:Tag(text, cfg.tag)
end
L.F.CreateHealthText = CreateHealthText

--CreatePowerText
local function CreatePowerText(self)
  if not self.cfg.powerbar or not self.cfg.powerbar.power or not self.cfg.powerbar.power.enabled then return end
  local cfg = self.cfg.powerbar.power
  local text = CreateText(self.Power,cfg.font,cfg.size,cfg.outline,cfg.align,cfg.noshadow)
  if cfg.points then
    SetPoints(text,self.Power,cfg.points)
  else
    SetPoint(text,self.Power,cfg.point)
  end
  self:Tag(text, cfg.tag)
end
L.F.CreatePowerText = CreatePowerText

--PostCreateAura
local function PostCreateAura(self,button)
  local bg = button:CreateTexture(nil,"BACKGROUND",nil,-8)
  bg:SetTexture(L.C.textures.aura)
  bg:SetVertexColor(0,0,0)
  bg:SetPoint("TOPLEFT", -self.size/4, self.size/4)
  bg:SetPoint("BOTTOMRIGHT", self.size/4, -self.size/4)
  button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
  button.count:SetFont(STANDARD_TEXT_FONT, self.size/1.65, "OUTLINE")
  button.count:SetShadowColor(0,0,0,0.6)
  button.count:SetShadowOffset(1,-1)
  button.count:ClearAllPoints()
  button.count:SetPoint("BOTTOMRIGHT", self.size/10, -self.size/10)
  button:SetFrameStrata("LOW")
end

--CreateBuffs
local function CreateBuffs(self)
  if not self.cfg.buffs or not self.cfg.buffs.enabled then return end
  local cfg = self.cfg.buffs
  local frame = CreateFrame("Frame", nil, self)
  SetPoint(frame,self,cfg.point)
  frame.num = cfg.num
  frame.size = cfg.size
  frame.spacing = cfg.spacing
  frame.initialAnchor = cfg.initialAnchor
  frame["growth-x"] = cfg.growthX
  frame["growth-y"] = cfg.growthY
  frame.disableCooldown = cfg.disableCooldown
  frame.filter = cfg.filter
  frame.CustomFilter = cfg.CustomFilter
  frame.PostCreateIcon = cfg.PostCreateAura or PostCreateAura
  --frame.PostUpdateIcon = PostUpdateBuff
  frame:SetSize(CalcFrameSize(cfg.num,cfg.cols,cfg.size,cfg.size,cfg.spacing,0))
  --local t = frame:CreateTexture(nil,"BACKGROUND",nil,-8)
  --t:SetAllPoints()
  --t:SetColorTexture(0,1,0,0.2)
  return frame
end
L.F.CreateBuffs = CreateBuffs

--CreateDebuffs
local function CreateDebuffs(self)
  if not self.cfg.debuffs or not self.cfg.debuffs.enabled then return end
  local cfg = self.cfg.debuffs
  local frame = CreateFrame("Frame", nil, self)
  SetPoint(frame,self,cfg.point)
  frame.num = cfg.num
  frame.size = cfg.size
  frame.spacing = cfg.spacing
  frame.initialAnchor = cfg.initialAnchor
  frame["growth-x"] = cfg.growthX
  frame["growth-y"] = cfg.growthY
  frame.disableCooldown = cfg.disableCooldown
  frame.filter = cfg.filter
  frame.CustomFilter = cfg.CustomFilter
  frame.PostCreateIcon = cfg.PostCreateAura or PostCreateAura
  --frame.PostUpdateIcon = PostUpdateDebuff
  frame:SetSize(CalcFrameSize(cfg.num,cfg.cols,cfg.size,cfg.size,cfg.spacing,0))
  --local t = frame:CreateTexture(nil,"BACKGROUND",nil,-8)
  --t:SetAllPoints()
  --t:SetColorTexture(1,0,0,0.2)
  return frame
end
L.F.CreateDebuffs = CreateDebuffs

--SetupHeader
local function SetupHeader(self)
  if not self.settings.setupHeader then return end
  self:RegisterForClicks("AnyDown")
  self:SetScript("OnEnter", UnitFrame_OnEnter)
  self:SetScript("OnLeave", UnitFrame_OnLeave)
end
L.F.SetupHeader = SetupHeader

--SetupFrame
local function SetupFrame(self)
  if not self.settings.setupFrame then return end
  self:SetSize(L.C.size,L.C.size)
  SetPoint(self,nil,self.cfg.point)
  self:SetScale(self.cfg.scale)
end
L.F.SetupFrame = SetupFrame

--CreateDragFrame
local function CreateDragFrame(self)
  if not self.settings.createDrag then return end
  rLib:CreateDragFrame(self, L.dragFrames, -2, true)
end
L.F.CreateDragFrame = CreateDragFrame