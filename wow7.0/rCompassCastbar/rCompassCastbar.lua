
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

  local overallScale = 0.8

  --player settings
  cfg["player"] = {}
  cfg["player"].enable          = true
  cfg["player"].latency         = true
  cfg["player"].scale           = 0.2 * overallScale
  cfg["player"].sparkcolor      = {1,1,1}
  cfg["player"].bgcolor         = {0.5,0.4,0,0.3}
  cfg["player"].ringcolor       = {1,0.8,0,1}
  cfg["player"].latencycolor    = {1,0,0,0.8}
  cfg["player"].bgblendmode     = "ADD" --"ADD" or "BLEND"
  cfg["player"].ringblendmode   = "ADD" --"ADD" or "BLEND"
  cfg["player"].sparkblendmode  = "ADD" --"ADD" or "BLEND"
  cfg["player"].latencyblendmode  = "BLEND" --"ADD" or "BLEND"
  --cfg["player"].point           = {"CENTER",0,0}

  --target settings
  cfg["target"] = {}
  cfg["target"].enable          = true
  cfg["target"].scale           = 0.15 * overallScale
  cfg["target"].sparkcolor      = {1,0.5,0.5}
  cfg["target"].bgcolor         = {0.5,0,0,3}
  cfg["target"].ringcolor       = {1,0,0,1}
  cfg["target"].bgblendmode     = "ADD" --"ADD" or "BLEND"
  cfg["target"].ringblendmode   = "ADD" --"ADD" or "BLEND"
  cfg["target"].sparkblendmode  = "ADD" --"ADD" or "BLEND"

  --focus settings
  cfg["focus"] = {}
  cfg["focus"].enable          = true
  cfg["focus"].scale           = 0.11 * overallScale
  cfg["focus"].sparkcolor      = {0.5,0.5,1}
  cfg["focus"].bgcolor         = {0,0,0.5,3}
  cfg["focus"].ringcolor       = {0,0.5,1,1}
  cfg["focus"].bgblendmode     = "ADD" --"ADD" or "BLEND"
  cfg["focus"].ringblendmode   = "ADD" --"ADD" or "BLEND"
  cfg["focus"].sparkblendmode  = "ADD" --"ADD" or "BLEND"

  --pet settings
  cfg["pet"] = {}
  cfg["pet"].enable          = false
  cfg["pet"].scale           = 0.08 * overallScale
  cfg["pet"].sparkcolor      = {0.8,1,0.5}
  cfg["pet"].bgcolor         = {0,0.5,0,3}
  cfg["pet"].ringcolor       = {0.5,1,0.3,1}
  cfg["pet"].bgblendmode     = "ADD" --"ADD" or "BLEND"
  cfg["pet"].ringblendmode   = "ADD" --"ADD" or "BLEND"
  cfg["pet"].sparkblendmode  = "ADD" --"ADD" or "BLEND"

  -----------------------------
  -- VARIABLES
  -----------------------------

  local UnitCastingInfo,UnitChannelInfo,UIParent = UnitCastingInfo,UnitChannelInfo,UIParent
  local GetTime,GetCursorPosition,GetNetStats = GetTime,GetCursorPosition,GetNetStats
  local math,unpack = math,unpack

  local uiscale = 1

  -----------------------------
  -- FUNCTIONS
  -----------------------------

  --GetUiScale func
  local function GetUiScale()
    uiscale = UIParent:GetEffectiveScale()
  end

  --Disable func
  local function Disable(self)
    self:SetScript("OnUpdate",nil)
    self.update, self.isCasting, self.isEnabled = false,false,false
    self.spellName, self.spellRang, self.spellText, self.spellTexture, self.startTime, self.endTime = nil,nil,nil,nil,nil,nil
    self.current, self.duration, self.elapsed, self.percent = 0,0,0,0
    self:SetAlpha(0)
  end

  --OnUpdate func
  local function OnUpdate(self,elapsed)
    self.elapsed = self.elapsed + elapsed
    if self.update then
      self.spellName, self.spellRang, self.spellText, self.spellTexture, self.startTime, self.endTime = UnitCastingInfo(self.unit)
      if not self.spellName then
        self.spellName, self.spellRang, self.spellText, self.spellTexture, self.startTime, self.endTime = UnitChannelInfo(self.unit)
      end
      if not self.spellName then
        Disable(self)
        return
      end
      self.isCasting = true
      self.current = GetTime()-self.startTime/1e3
      self.duration = (self.endTime-self.startTime)/1e3
      if self.leftRingLatency then
        self.nsDown, self.nsUp, self.nsLagHome, self.nsLagWorld = GetNetStats()
        if self.nsLagWorld and self.nsLagWorld > 0 then
          self.latency = math.max(((self.duration-self.nsLagWorld*2/1e3)/self.duration),0)
          if self.latency < 0.9 then
            self.leftRingLatency:SetRotation(math.rad(self.leftRingLatency.baseDeg-180*self.latency))
            self.leftRingLatency:SetAlpha(cfg["player"].latencycolor[3] or 1)
          else
            --latency is barely visible, hide it
            self.leftRingLatency:SetAlpha(0)
          end
        end
      end
      self.elapsed = 0
      self.update = false
    end
    if not self.isCasting or (self.current+self.elapsed-self.duration > 0.5) then
      --kill the OnUpdate
      Disable(self)
      return
    end
    if self.castbarAtCursor then
      self.x, self.y = GetCursorPosition()
      self.x = (self.x/uiscale/self.scale)-self.w/2
      self.y = (self.y/uiscale/self.scale)-self.h/2
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
    self.rightRingSpark:SetRotation(math.rad(self.rightRingSpark.baseDeg-180*(self.percent*2)))
    self.leftRingSpark:SetRotation(math.rad(self.leftRingSpark.baseDeg-180*(self.percent*2-1)))
  end

  --Enable func
  local function Enable(self)
    if self.isEnabled then return end
    self.isEnabled = true
    self:SetAlpha(1)
    self:SetScript("OnUpdate",OnUpdate)
  end

  --OnEvent func
  local function OnEvent(self,event)
    if event == "UNIT_SPELLCAST_CHANNEL_STOP" or event == "UNIT_SPELLCAST_STOP" then
      Disable(self)
      return
    end
    --update on all other events
    self.update = true
    Enable(self)
  end

  --CreateCompassCastbar func
  local function CreateCompassCastbar(unit,cfg)

    local f = CreateFrame("Frame",nil,UIParent)
    f:SetSize(512,512)
    f:SetScale(cfg.scale)
    f.scale = f:GetScale()
    f.w, f.h = f:GetSize()
    f:SetFrameStrata("DIALOG")

    if cfg.point then
      f.castbarAtCursor = false
      f:SetPoint(unpack(cfg.point))
    else
      f.castbarAtCursor = true
      f:SetPoint("BOTTOMLEFT",0,0)
      f:SetClampedToScreen(1)
    end

    --attributes
    f.unit    = unit

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

    local rs1 = sc1:CreateTexture(nil,"BACKGROUND",nil,-5)
    rs1:SetTexture("Interface\\AddOns\\"..an.."\\media\\compass-rose-spark")
    rs1:SetSize(sqrt(2)*f.w,sqrt(2)*f.h)
    rs1:SetPoint("CENTER")
    rs1:SetVertexColor(unpack(cfg.sparkcolor))
    rs1:SetBlendMode(cfg.sparkblendmode)
    rs1.baseDeg = -180

    --latency
    if unit == "player" and cfg.latency then
      local rl1 = sc1:CreateTexture(nil,"BACKGROUND",nil,-4)
      rl1:SetTexture("Interface\\AddOns\\"..an.."\\media\\compass-rose-ring")
      rl1:SetSize(sqrt(2)*f.w,sqrt(2)*f.h)
      rl1:SetPoint("CENTER")
      rl1:SetVertexColor(unpack(cfg.latencycolor))
      rl1:SetBlendMode(cfg.latencyblendmode)
      rl1.baseDeg = 0
      rl1:SetRotation(math.rad(rl1.baseDeg-180*0.8))
      f.leftRingLatency = rl1
    end

    --right ring
    local sf2 = CreateFrame("ScrollFrame",nil,f)
    sf2:SetSize(f.w/2,f.h)
    sf2:SetPoint("RIGHT")

    local sc2 = CreateFrame("Frame")
    sf2:SetScrollChild(sc2)
    sf2:SetHorizontalScroll(f.w/2)
    sc2:SetSize(f.w,f.h)

    local rt2 = sc2:CreateTexture(nil,"BACKGROUND",nil,-6)
    rt2:SetTexture("Interface\\AddOns\\"..an.."\\media\\compass-rose-ring")
    rt2:SetSize(sqrt(2)*f.w,sqrt(2)*f.h)
    rt2:SetPoint("CENTER")
    rt2:SetVertexColor(unpack(cfg.ringcolor))
    rt2:SetBlendMode(cfg.ringblendmode)
    rt2.baseDeg = 0

    local rs2 = sc2:CreateTexture(nil,"BACKGROUND",nil,-5)
    rs2:SetTexture("Interface\\AddOns\\"..an.."\\media\\compass-rose-spark")
    rs2:SetSize(sqrt(2)*f.w,sqrt(2)*f.h)
    rs2:SetPoint("CENTER")
    rs2:SetVertexColor(unpack(cfg.sparkcolor))
    rs2:SetBlendMode(cfg.sparkblendmode)
    rs2.baseDeg = 0

    f.leftRingTexture = rt1
    f.rightRingTexture = rt2
    f.leftRingSpark = rs1
    f.rightRingSpark = rs2

    f:RegisterUnitEvent("UNIT_SPELLCAST_START", unit)
    f:RegisterUnitEvent("UNIT_SPELLCAST_FAILED", unit)
    f:RegisterUnitEvent("UNIT_SPELLCAST_STOP", unit)
    f:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED", unit)
    --f:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTIBLE", unit)
    --f:RegisterUnitEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE", unit)
    f:RegisterUnitEvent("UNIT_SPELLCAST_DELAYED", unit)
    f:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", unit)
    f:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_UPDATE", unit)
    f:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", unit)

    --add special events that may help triggering important updates
    if unit == "pet" then
      f:RegisterUnitEvent("UNIT_PET","player") --check for pet changes
    end
    if unit == "focus" then
      f:RegisterEvent("PLAYER_FOCUS_CHANGED") --check for focus changes
    end
    if unit == "target" then
      f:RegisterEvent("PLAYER_TARGET_CHANGED") --check for target changes
    end

    Disable(f)

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

  --ui scale change check frame
  local f = CreateFrame("Frame")
  f:RegisterEvent("UI_SCALE_CHANGED")
  f:RegisterEvent("PLAYER_LOGIN")
  f:SetScript("OnEvent",GetUiScale)