
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
    p:SetTexCoord(0.15,0.85,0.15,0.85)
    p:SetAlpha(1)
    p:SetDesaturated(1)
    p:SetBlendMode("ADD")
    self.Portrait = p

    --red overlay
    local red = self:CreateTexture(nil, "BACKGROUND", nil, -5)
    red:SetAllPoints()
    red:SetTexture(1,1,1)
    red:SetVertexColor(1,0,0,1)
    red:SetBlendMode("ADD")

    --a second portrait that will be used as a healthbar
    local p2 = self:CreateTexture(nil, "BACKGROUND", nil, -4)
    p2:SetPoint("BOTTOMLEFT")
    p2:SetPoint("BOTTOMRIGHT")
    p2.height = self:GetHeight()
    p2:SetHeight(p2.height)
    p2:SetTexCoord(0.15,0.85,0.15,0.85)
    self.HealthPortrait = p2

    --fake healthbar for use of the oUF health module
    local health = CreateFrame("StatusBar", nil, self)
    health.frequentUpdates = true
    self.Health = health

    --power bar
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
    local hpval = core:NewFontString(self, cfg.font, 18, "THINOUTLINE")
    hpval:SetPoint("TOPLEFT")
    self:Tag(hpval, "[square_portrait:health]")

    local name = core:NewFontString(self, cfg.font, 14, "THINOUTLINE")
    name:SetPoint("LEFT",-5,0)
    name:SetPoint("RIGHT",5,0)
    name:SetPoint("BOTTOM", self, "TOP", 0, 4)
    self:Tag(name, "[square_portrait:name]")

    --once a new health event fires we update our portrait texture coords
    self.Health.PostUpdate = function(bar,...)
      local hcur = bar:GetValue()
      local p2 = bar.__owner.HealthPortrait
      local hmin, hmax = bar:GetMinMaxValues()
      local hper = 0
      if hmax > 0 then
        hper = hcur/hmax
      end
      if hper == 0 then p2:Hide() return end
      if not p2:IsShown() then p2:Show() end --i see no dead people
      p2:SetTexCoord(0.15,0.85,0.85-(0.7*hper),0.85)
      p2:SetHeight(p2.height*hper)
    end

    --track the portrait update and apply a new portrait texture p2 aswell
    self.Portrait.PostUpdate = function(portait,...)
      SetPortraitTexture(portait.__owner.HealthPortrait, portrait.__owner.unit)
      --portait.__owner.Health:ForceUpdate(portait.__owner.Health)
    end

  end

  ---------------------------------------------
  -- STYLE
  ---------------------------------------------

  oUF:RegisterStyle("SquareStyle", SetSquareStyle)
  oUF:SetActiveStyle("SquareStyle")

  ---------------------------------------------
  -- SPAWN
  ---------------------------------------------

  --local playerFrame = oUF:Spawn("player", addonName.."Player")
  --playerFrame:SetPoint("CENTER",-200,0)

  local TargetFrame = oUF:Spawn("target", addonName.."Target")
  TargetFrame:SetPoint("CENTER",200,0)

  local TargetTargetFrame = oUF:Spawn("targettarget", addonName.."TargetTarget")
  TargetTargetFrame:SetPoint("CENTER",100,0)

  local PetFrame = oUF:Spawn("pet", addonName.."Pet")
  PetFrame:SetPoint("CENTER",-100,0)

  --local FocusFrame = oUF:Spawn("focus", addonName.."Focus")
  --FocusFrame:SetPoint("CENTER",-300,0)