
  --addonName and namespace
  local addonName, ns = ...

  --reference config and core
  local core = ns.core
  local cfg = ns.cfg

  ---------------------------------------------
  -- FUNCTIONS
  ---------------------------------------------

  local function SetSquareStyle(self)
    --style specific stuff
    self.size = 64
    self:SetSize(self.size, self.size)
    self:SetScale(1)
    
    --later this has do by a tad more dynamic, for now male draenei shaman for all of them :p
    local portraitTexture = cfg.mediaPath.."male-draenei-shaman"

    print(self.unit)

    --menu, tooltip
    self:RegisterForClicks("AnyDown")
    self:HookScript("OnEnter", UnitFrame_OnEnter)
    self:HookScript("OnLeave", UnitFrame_OnLeave)

    --dropshadow
    core:CreateDropShadow(self, cfg.mediaPath.."backdrop_outershadow", 4, 4)
    self:SetDropShadowColor(0,0,0,1)

    --bg
    local bg = self:CreateTexture(nil, "BACKGROUND", nil, -7)
    bg:SetAllPoints()
    bg:SetTexture(1,1,1)
    bg:SetVertexColor(0,0,0,0.7)

    --desaturated portait
    local p = self:CreateTexture(nil, "BACKGROUND", nil, -6)
    p:SetAllPoints()
    p:SetAlpha(1)
    p:SetDesaturated(1)
    p:SetBlendMode("ADD")
    p:SetTexture(portraitTexture)

    --red overlay
    local red = self:CreateTexture(nil, "BACKGROUND", nil, -5)
    red:SetAllPoints()
    red:SetTexture(1,1,1)
    red:SetVertexColor(1,0,0,1)
    red:SetBlendMode("ADD")

    --healthbar
    local health = CreateFrame("StatusBar", nil, self)
    health:SetAllPoints()
    health:SetStatusBarTexture(portraitTexture)
    health:SetOrientation("VERTICAL")
    health.frequentUpdates = true
    self.Health = health

    local power = CreateFrame("StatusBar", nil, self)
    power:SetStatusBarTexture("Interface\\Buttons\\WHITE8x8")
    power:SetPoint("TOP",self,"BOTTOM",0, -4)
    power:SetSize(64,4)
    core:CreateDropShadow(power, cfg.mediaPath.."backdrop_outershadow", 4, 4)
    power:SetDropShadowColor(0,0,0,1)
    local bg = power:CreateTexture(nil, "BACKGROUND", nil, -7)
    bg:SetAllPoints()
    bg:SetTexture(1,1,1)
    bg.multiplier = 0.4
    power.bg = bg
    power.frequentUpdates = true
    power.colorClass = true
    power.colorClassPet = true
    --power.colorClassNPC = true
    self.Power = power
    
    --strings
    local hpval = core:NewFontString(self.Health, cfg.font, 18, "THINOUTLINE")  
    hpval:SetPoint("TOPLEFT")
    self:Tag(hpval, "[square_portrait:health]")
    
    local name = core:NewFontString(self, cfg.font, 14, "THINOUTLINE")
    name:SetPoint("LEFT",-5,0)
    name:SetPoint("RIGHT",5,0)
    name:SetPoint("BOTTOM", self, "TOP", 0, 4)
    self:Tag(name, "[square_portrait:name]")

  end

  ---------------------------------------------
  -- STYLE
  ---------------------------------------------

  oUF:RegisterStyle("SquareStyleStatic", SetSquareStyle)
  oUF:SetActiveStyle("SquareStyleStatic")

  ---------------------------------------------
  -- SPAWN
  ---------------------------------------------

  local playerFrame = oUF:Spawn("player", addonName.."Player")
  playerFrame:SetPoint("CENTER",-200,0)

  --local TargetFrame = oUF:Spawn("target", addonName.."Target")
  --TargetFrame:SetPoint("CENTER",200,0)

  --local TargetTargetFrame = oUF:Spawn("targettarget", addonName.."TargetTarget")
  --TargetTargetFrame:SetPoint("CENTER",100,0)

  --local PetFrame = oUF:Spawn("pet", addonName.."Pet")
  --PetFrame:SetPoint("CENTER",-100,0)

  local FocusFrame = oUF:Spawn("focus", addonName.."Focus")
  FocusFrame:SetPoint("CENTER",-300,0)