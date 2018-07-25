
-- rCompassCastbar
-- zork, 2018

-----------------------------
-- Variables
-----------------------------

--addon tables
local A, L = ...

local mediaPath = "Interface\\AddOns\\"..A.."\\media\\"
local UnitCastingInfo,UnitChannelInfo = UnitCastingInfo,UnitChannelInfo
local GetTime,GetCursorPosition,math = GetTime,GetCursorPosition,math
local uiScale = 1

-----------------------------
-- Config
-----------------------------

--cfg
local ringCfg = {}

--overall scale
local overallScale = 1

--player settings
ringCfg["player"] = {
  enabled         = true,
  size            = {512,512},
  scale           = 0.2 * overallScale,
  --comment this in if you want the position to be fixed, otherwise position at cursor
  --point           = {"CENTER",0,0},
  background = {
    enabled = false,
    color = {0.4,0.3,0,1}, --red,green,blue,alpha
    blendmode = "ADD", --ADD or BLEND
    texture = mediaPath.."compass-rose",
  },
  ring = {
    color = {1,0.8,0,1},
    blendmode = "BLEND",
    texture = mediaPath.."compass-rose-ring",
  },
  spark = {
    enabled = true,
    color = {1,1,1},
    blendmode = "ADD",
    texture = mediaPath.."compass-rose-spark",
  },
}

--gcd settings
ringCfg["gcd"] = {
  enabled         = true,
  size            = {512,512},
  scale           = 0.15 * overallScale,
  background = {
    enabled = false,
    color = {0.5,0.4,0,1}, --red,green,blue,alpha
    blendmode = "ADD", --ADD or BLEND
    texture = mediaPath.."compass-rose",
  },
  ring = {
    color = {0.5,0.5,0.5,1},
    blendmode = "BLEND",
    texture = mediaPath.."compass-rose-ring",
  },
  spark = {
    enabled = true,
    color = {1,1,1},
    blendmode = "ADD",
    texture = mediaPath.."compass-rose-spark",
  },
}

--target settings
ringCfg["target"] = {
  enabled         = false,
  size            = {512,512},
  scale           = 0.11 * overallScale,
  --comment this in if you want the position to be fixed, otherwise position at cursor
  --point           = {"CENTER",0,0},
  background = {
    enabled = false,
    color = {0.4,0.3,0,0.6}, --red,green,blue,alpha
    blendmode = "ADD", --ADD or BLEND
    texture = mediaPath.."compass-rose-bright",
  },
  ring = {
    color = {1,0,0,1},
    blendmode = "ADD",
    texture = mediaPath.."compass-rose-ring-bright",
  },
  spark = {
    enabled = true,
    color = {1,1,1},
    blendmode = "ADD",
    texture = mediaPath.."compass-rose-spark",
  },
}

--focus settings
ringCfg["focus"] = {
  enabled         = false,
  size            = {512,512},
  scale           = 0.08 * overallScale,
  --comment this in if you want the position to be fixed, otherwise position at cursor
  --point           = {"CENTER",0,0},
  background = {
    enabled = false,
    color = {0.4,0.3,0,0.6}, --red,green,blue,alpha
    blendmode = "ADD", --ADD or BLEND
    texture = mediaPath.."compass-rose-bright",
  },
  ring = {
    color = {0,0.5,1,1},
    blendmode = "ADD",
    texture = mediaPath.."compass-rose-ring-bright",
  },
  spark = {
    enabled = true,
    color = {1,1,1},
    blendmode = "ADD",
    texture = mediaPath.."compass-rose-spark",
  },
}

-----------------------------
-- Functions
-----------------------------

--GetUiScale func
local function GetUiScale()
  uiScale = UIParent:GetEffectiveScale()
end

--Disable func
local function Disable(self)
  self:SetScript("OnUpdate",nil)
  self.update, self.isCasting, self.isEnabled = false,false,false
  self.spellName, self.spellText, self.spellTexture, self.startTime, self.endTime = nil,nil,nil,nil,nil,nil
  self.current, self.duration, self.elapsed, self.percent = 0,0,0,0
  self:Hide()
  --self:SetAlpha(0)
end

--OnUpdate func
local function OnUpdate(self,elapsed)
  self.elapsed = self.elapsed + elapsed
  if self.update and self.unit ~= "gcd" then
    self.spellName, self.spellText, self.spellTexture, self.startTime, self.endTime = UnitCastingInfo(self.unit)
    if not self.spellName then
      self.spellName, self.spellText, self.spellTexture, self.startTime, self.endTime = UnitChannelInfo(self.unit)
    end
    if not self.spellName then
      Disable(self)
      return
    end
    self.current = GetTime()-self.startTime/1e3
    self.duration = (self.endTime-self.startTime)/1e3
    self.elapsed = 0
    self.update = false
  end
  if self.update and self.unit == "gcd" then
    --gcd spellid http://www.wowhead.com/spell=61304/global-cooldown
    self.startTime, self.duration = GetSpellCooldown(61304)
    if self.duration == 0 then
      Disable(self)
      return
    end
    self.current = GetTime()-self.startTime
    self.elapsed = 0
    self.update = false
  end
  --if the calculated duration is overdue kill the OnUpdate
  if self.current+self.elapsed-self.duration > 0 then
    Disable(self)
    return
  end
  if self.castbarAtCursor then
    self.x, self.y = GetCursorPosition()
    self.x = (self.x/uiScale/self.scale)-self.w/2
    self.y = (self.y/uiScale/self.scale)-self.h/2
    self:SetPoint("BOTTOMLEFT",self.x,self.y)
  end
  self.percent = math.min(self.current+self.elapsed,self.duration)/self.duration
  if self.percent > 0.5 then
    self.leftRingTexture:SetRotation(math.rad(self.leftRingTexture.baseDeg-180*(self.percent*2-1)))
    self.rightRingTexture:SetRotation(math.rad(self.rightRingTexture.baseDeg-180))
  else
    self.leftRingTexture:SetRotation(math.rad(self.leftRingTexture.baseDeg-0))
    self.rightRingTexture:SetRotation(math.rad(self.rightRingTexture.baseDeg-180*(self.percent*2)))
  end
  if self.rightRingSpark then
    self.rightRingSpark:SetRotation(math.rad(self.rightRingSpark.baseDeg-180*(self.percent*2)))
  end
  if self.leftRingSpark then
    self.leftRingSpark:SetRotation(math.rad(self.leftRingSpark.baseDeg-180*(self.percent*2-1)))
  end
end

--Enable func
local function Enable(self)
  if self.isEnabled then return end
  self:Show()
  --self:SetAlpha(1)
  self:SetScript("OnUpdate",OnUpdate)
  self.isEnabled = true
end

--OnEvent func
local function OnEvent(self,event)
  if self.unit ~= "gcd" and (event == "UNIT_SPELLCAST_CHANNEL_STOP" or event == "UNIT_SPELLCAST_STOP") then
    Disable(self)
    return
  end
  --update on all other events
  self.update = true
  Enable(self)
end

--CreateCompassCastbar func
local function CreateCompassCastbar(unit,cfg)
  if not cfg.enabled then return end
  --frame
  local f = CreateFrame("Frame",nil,UIParent)
  f:SetSize(unpack(cfg.size))
  f:SetScale(cfg.scale)
  f.scale = f:GetScale()
  f.w, f.h = f:GetSize()
  f:SetFrameStrata("DIALOG")
  --unit
  f.unit = unit
  --position
  if cfg.point then
    f.castbarAtCursor = false
    f:SetPoint(unpack(cfg.point))
  else
    f.castbarAtCursor = true
    f:SetPoint("BOTTOMLEFT",0,0)
    f:SetClampedToScreen(1)
  end
  --frame background
  if cfg.background and cfg.background.enabled then
    local t = f:CreateTexture(nil, "BACKGROUND", nil, -8)
    t:SetTexture(cfg.background.texture)
    t:SetAllPoints()
    t:SetVertexColor(unpack(cfg.background.color))
    t:SetBlendMode(cfg.background.blendmode)
    f.bg = t
  end
  --left ring scroll frame
  local sf1 = CreateFrame("ScrollFrame",nil,f)
  sf1:SetSize(f.w/2,f.h)
  sf1:SetPoint("LEFT")
  --left ring scroll child
  local sc1 = CreateFrame("Frame")
  sf1:SetScrollChild(sc1)
  sc1:SetSize(f.w,f.h)
  --left ring texture
  local rt1 = sc1:CreateTexture(nil,"BACKGROUND",nil,-6)
  rt1:SetTexture(cfg.ring.texture)
  rt1:SetSize(f.w,f.h)
  rt1:SetPoint("CENTER")
  rt1:SetVertexColor(unpack(cfg.ring.color))
  rt1:SetBlendMode(cfg.ring.blendmode)
  rt1.baseDeg = -180
  f.leftRingTexture = rt1
  --left ring spark
  if cfg.spark and cfg.spark.enabled then
    local rs1 = sc1:CreateTexture(nil,"BACKGROUND",nil,-5)
    rs1:SetTexture(cfg.spark.texture)
    rs1:SetSize(f.w,f.h)
    rs1:SetPoint("CENTER")
    rs1:SetVertexColor(unpack(cfg.spark.color))
    rs1:SetBlendMode(cfg.spark.blendmode)
    rs1.baseDeg = -180
    f.leftRingSpark = rs1
  end
  --right ring scroll frame
  local sf2 = CreateFrame("ScrollFrame",nil,f)
  sf2:SetSize(f.w/2,f.h)
  sf2:SetPoint("RIGHT")
  --right ring scroll child
  local sc2 = CreateFrame("Frame")
  sf2:SetScrollChild(sc2)
  sf2:SetHorizontalScroll(f.w/2)
  sc2:SetSize(f.w,f.h)
  --right ring texture
  local rt2 = sc2:CreateTexture(nil,"BACKGROUND",nil,-6)
  rt2:SetTexture(cfg.ring.texture)
  rt2:SetSize(f.w,f.h)
  rt2:SetPoint("CENTER")
  rt2:SetVertexColor(unpack(cfg.ring.color))
  rt2:SetBlendMode(cfg.ring.blendmode)
  rt2.baseDeg = 0
  f.rightRingTexture = rt2
  --right ring spark
  if cfg.spark and cfg.spark.enabled then
    local rs2 = sc2:CreateTexture(nil,"BACKGROUND",nil,-5)
    rs2:SetTexture(cfg.spark.texture)
    rs2:SetSize(f.w,f.h)
    rs2:SetPoint("CENTER")
    rs2:SetVertexColor(unpack(cfg.spark.color))
    rs2:SetBlendMode(cfg.spark.blendmode)
    rs2.baseDeg = 0
    f.rightRingSpark = rs2
  end
  --cast events != gcd
  if unit ~= "gcd" then
    f:RegisterUnitEvent("UNIT_SPELLCAST_START", unit)
    f:RegisterUnitEvent("UNIT_SPELLCAST_FAILED", unit)
    f:RegisterUnitEvent("UNIT_SPELLCAST_STOP", unit)
    f:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", unit)
    f:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED", unit)
    f:RegisterUnitEvent("UNIT_SPELLCAST_DELAYED", unit)
    f:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", unit)
    f:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_UPDATE", unit)
    f:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", unit)
  end
  --pet events
  if unit == "pet" then
    f:RegisterUnitEvent("UNIT_PET","player")
  end
  --focus events
  if unit == "focus" then
    f:RegisterEvent("PLAYER_FOCUS_CHANGED")
  end
  --target events
  if unit == "target" then
    f:RegisterEvent("PLAYER_TARGET_CHANGED")
  end
  --gcd events
  if unit == "gcd" then
    --f:RegisterEvent("SPELL_UPDATE_COOLDOWN")
    --f:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")
    --f:RegisterEvent("SPELLS_CHANGED")
    f:RegisterUnitEvent("UNIT_SPELLCAST_START", "player")
    f:RegisterUnitEvent("UNIT_SPELLCAST_FAILED", "player")
    f:RegisterUnitEvent("UNIT_SPELLCAST_STOP", "player")
    f:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
    f:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED", "player")
    f:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", "player")
    f:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_UPDATE", "player")
    f:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", "player")
  end
  Disable(f)
  f:SetScript("OnEvent",OnEvent)
end

-----------------------------
-- Init
-----------------------------

for unit, cfg in next, ringCfg do
  CreateCompassCastbar(unit,cfg)
end

--check for ui scale changes
local f = CreateFrame("Frame")
f:RegisterEvent("UI_SCALE_CHANGED")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent",GetUiScale)