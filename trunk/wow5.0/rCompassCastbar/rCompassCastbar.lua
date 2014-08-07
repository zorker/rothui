
  -- // rCompassCastbar
  -- // zork - 2014

  -----------------------------
  -- ADDON TABLES
  -----------------------------

  --addon tables
  local an, at = ...

  -----------------------------
  -- CONFIG
  -----------------------------

  local cfg = {}

  --player settings
  cfg["player"] = {}
  cfg["player"].enable          = true
  cfg["player"].scale           = 0.2
  cfg["player"].sparkcolor      = {1,1,1}
  cfg["player"].bgcolor         = {0.5,0.4,0,1}
  cfg["player"].ringcolor       = {1,0.8,0,1}
  cfg["player"].bgblendmode     = "ADD" --"ADD" or "BLEND"
  cfg["player"].ringblendmode   = "ADD" --"ADD" or "BLEND"
  cfg["player"].sparkblendmode  = "ADD" --"ADD" or "BLEND"

  --target settings
  cfg["target"] = {}
  cfg["target"].enable          = false
  cfg["target"].scale           = 0.15
  cfg["target"].sparkcolor      = {1,0.5,0.5}
  cfg["target"].bgcolor         = {0.5,0,0,1}
  cfg["target"].ringcolor       = {1,0,0,1}
  cfg["target"].bgblendmode     = "ADD" --"ADD" or "BLEND"
  cfg["target"].ringblendmode   = "ADD" --"ADD" or "BLEND"
  cfg["target"].sparkblendmode  = "ADD" --"ADD" or "BLEND"

  --focus settings
  cfg["focus"] = {}
  cfg["focus"].enable          = false
  cfg["focus"].scale           = 0.11
  cfg["focus"].sparkcolor      = {0.5,0.5,1}
  cfg["focus"].bgcolor         = {0,0,0.5,1}
  cfg["focus"].ringcolor       = {0,0.5,1,1}
  cfg["focus"].bgblendmode     = "ADD" --"ADD" or "BLEND"
  cfg["focus"].ringblendmode   = "ADD" --"ADD" or "BLEND"
  cfg["focus"].sparkblendmode  = "ADD" --"ADD" or "BLEND"

  --pet settings
  cfg["pet"] = {}
  cfg["pet"].enable          = false
  cfg["pet"].scale           = 0.08
  cfg["pet"].sparkcolor      = {0.8,1,0.5}
  cfg["pet"].bgcolor         = {0,0.5,0,1}
  cfg["pet"].ringcolor       = {0.5,1,0.3,1}
  cfg["pet"].bgblendmode     = "ADD" --"ADD" or "BLEND"
  cfg["pet"].ringblendmode   = "ADD" --"ADD" or "BLEND"
  cfg["pet"].sparkblendmode  = "ADD" --"ADD" or "BLEND"

  -----------------------------
  -- VARIABLES
  -----------------------------

  local UnitCastingInfo = UnitCastingInfo
  local UnitChannelInfo = UnitChannelInfo
  local GetTime,GetCursorPosition = GetTime,GetCursorPosition
  local math,unpack = math,unpack

  local uipScale = UIParent:GetEffectiveScale()

  -----------------------------
  -- FUNCTIONS
  -----------------------------

  local function Disable(self)
    self:SetScript("OnUpdate",nil)
    self.channel = false
    self.cast = false
    self.update = false
    self.startTime = 0
    self.endTime = 0
    self.duration = 0
    self.elapsed = 0
    self:Hide()
  end

  local x,y,p,UCI

  local function OnUpdate(self,elapsed)
    if self.update == true then
      UCI = UnitCastingInfo
      if self.channel == true then
        UCI = UnitChannelInfo
      end
      local _, _, _, _, startTime, endTime = UCI(self.unit)
      self.startTime = startTime
      self.endTime = endTime
      self.cur = GetTime()-startTime/1e3
      self.duration = (endTime-startTime)/1e3
      self.elapsed = 0
      self.update = false
    end
    x, y = GetCursorPosition()
    x = (x/uipScale/self.scale)-self.w/2
    y = (y/uipScale/self.scale)-self.h/2
    p = math.min(self.cur+self.elapsed,self.duration)/self.duration
    self:Hide() --fix the fps bug when repositioning visible objects multiple times per second, check http://www.wowinterface.com/forums/showthread.php?t=46740
    self:SetPoint("BOTTOMLEFT",x,y)
    if p > 0.5 then
      self.leftRingTexture:SetRotation(math.rad(self.leftRingTexture.baseDeg-180*(p*2-1)))
      self.rightRingTexture:SetRotation(math.rad(self.rightRingTexture.baseDeg-180))
    else
      self.leftRingTexture:SetRotation(math.rad(self.leftRingTexture.baseDeg-0))
      self.rightRingTexture:SetRotation(math.rad(self.rightRingTexture.baseDeg-180*(p*2)))
    end
    self.rightRingSpark:SetRotation(math.rad(self.rightRingSpark.baseDeg-180*(p*2)))
    self.leftRingSpark:SetRotation(math.rad(self.leftRingSpark.baseDeg-180*(p*2-1)))
    self:Show()
    if self.cur+self.elapsed-self.duration > 0.5 then
      --sth really bad happened. there is no stop event firing. kill the onUpdate
      Disable(self)
    end
    self.elapsed = self.elapsed + elapsed
  end

  local function Enable(self)
    uipScale = UIParent:GetEffectiveScale()
    self:Show()
    self:SetScript("OnUpdate",OnUpdate)
  end

  local function OnEvent(self,event)
    if event == "UNIT_SPELLCAST_CHANNEL_STOP" then
      Disable(self)
    end
    if event == "UNIT_SPELLCAST_STOP" then
      Disable(self)
    end
    if event == "UNIT_SPELLCAST_START" then
      self.cast = true
      self.update = true
      Enable(self)
    end
    if event == "UNIT_SPELLCAST_CHANNEL_START" then
      self.channel = true
      self.update = true
      Enable(self)
    end
    if event == "UNIT_SPELLCAST_DELAYED" then
      self.update = true
    end
    if event == "UNIT_SPELLCAST_CHANNEL_UPDATE" then
      self.update = true
    end
  end

  local function CreateCompassCastbar(unit,cfg)

    local f = CreateFrame("Frame",nil,UIParent)
    f:SetSize(512,512)
    f:SetScale(cfg.scale)
    f.scale = f:GetScale()
    f.w, f.h = f:GetSize()
    f:SetPoint("BOTTOMLEFT",0,0)
    f:SetFrameStrata("DIALOG")
    f:SetClampedToScreen(1)

    --attributes
    f.channel = false
    f.cast = false
    f.update = false
    f.startTime = 0
    f.endTime = 0
    f.duration = 0
    f.elapsed = 0
    f.unit = unit

    local t = f:CreateTexture(nil, "BACKGROUND", nil, -8)
    t:SetTexture("Interface\\AddOns\\"..an.."\\media\\compass-rose")
    t:SetAllPoints()
    t:SetAlpha(1)
    t:SetVertexColor(unpack(cfg.bgcolor))
    t:SetBlendMode(cfg.bgblendmode)

    --left ring
    local sf1 = CreateFrame("ScrollFrame",nil,f)
    sf1:SetSize(f.w/2,f.h)
    sf1:SetPoint("LEFT")

    local sc1 = CreateFrame("Frame")
    sf1:SetScrollChild(sc1)
    sc1:SetSize(f.w,f.h)

    local rt1 = sc1:CreateTexture(nil,"BACKGROUND",nil,-6)
    rt1:SetTexture("Interface\\AddOns\\"..an.."\\media\\compass-rose-ring")
    rt1:SetSize(sqrt(2)*f.w,sqrt(2)*f.h)
    rt1:SetPoint("CENTER")
    rt1:SetVertexColor(unpack(cfg.ringcolor))
    rt1:SetBlendMode(cfg.ringblendmode)
    rt1.baseDeg = -180
    rt1:SetRotation(math.rad(rt1.baseDeg-0)) -- etc

    local rs1 = sc1:CreateTexture(nil,"BACKGROUND",nil,-5)
    rs1:SetTexture("Interface\\AddOns\\"..an.."\\media\\compass-rose-spark")
    rs1:SetSize(sqrt(2)*f.w,sqrt(2)*f.h)
    rs1:SetPoint("CENTER")
    rs1:SetVertexColor(unpack(cfg.sparkcolor))
    rs1:SetBlendMode(cfg.sparkblendmode)
    rs1.baseDeg = -180
    rs1:SetRotation(math.rad(rs1.baseDeg-0)) -- etc

    --right ring
    local sf2 = CreateFrame("ScrollFrame",nil,f)
    sf2:SetSize(f.w/2,f.h)
    sf2:SetPoint("RIGHT")

    local sc2 = CreateFrame("Frame")
    sf2:SetScrollChild(sc2)
    sc2:SetSize(f.w,f.h)

    local rt2 = sc2:CreateTexture(nil,"BACKGROUND",nil,-6)
    rt2:SetTexture("Interface\\AddOns\\"..an.."\\media\\compass-rose-ring")
    rt2:SetSize(sqrt(2)*f.w,sqrt(2)*f.h)
    rt2:SetPoint("CENTER",-f.w/2,0)
    rt2:SetVertexColor(unpack(cfg.ringcolor))
    rt2:SetBlendMode(cfg.ringblendmode)
    rt2.baseDeg = 0
    rt2:SetRotation(math.rad(rt2.baseDeg-0)) -- etc

    local rs2 = sc2:CreateTexture(nil,"BACKGROUND",nil,-5)
    rs2:SetTexture("Interface\\AddOns\\"..an.."\\media\\compass-rose-spark")
    rs2:SetSize(sqrt(2)*f.w,sqrt(2)*f.h)
    rs2:SetPoint("CENTER",-f.w/2,0)
    rs2:SetVertexColor(unpack(cfg.sparkcolor))
    rs2:SetBlendMode(cfg.sparkblendmode)
    rs2.baseDeg = 0
    rs2:SetRotation(math.rad(rs2.baseDeg-90)) -- etc

    f.leftRingTexture = rt1
    f.rightRingTexture = rt2
    f.leftRingSpark = rs1
    f.rightRingSpark = rs2

    f:RegisterUnitEvent("UNIT_SPELLCAST_START", unit)
    f:RegisterUnitEvent("UNIT_SPELLCAST_FAILED", unit)
    f:RegisterUnitEvent("UNIT_SPELLCAST_STOP", unit)
    f:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED", unit)
    f:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTIBLE", unit)
    f:RegisterUnitEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE", unit)
    f:RegisterUnitEvent("UNIT_SPELLCAST_DELAYED", unit)
    f:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", unit)
    f:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_UPDATE", unit)
    f:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", unit)

    f:Hide()

    f:SetScript("OnEvent",OnEvent)

  end

  -----------------------------
  -- CALL
  -----------------------------

  for k, v in pairs(cfg) do
    if v.enable then
      CreateCompassCastbar(k,v)
    end
  end