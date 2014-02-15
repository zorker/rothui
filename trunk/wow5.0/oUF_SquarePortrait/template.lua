
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
    SetPortraitTexture(p, self.unit)

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
    p2:SetHeight(self:GetHeight())
    p2:SetTexCoord(0.15,0.85,0.15,0.85)
    SetPortraitTexture(p2, self.unit)

    --fake healthbar for oUF
    local health = CreateFrame("StatusBar", nil, self)
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
    local hpval = core:NewFontString(self, cfg.font, 18, "THINOUTLINE")  
    hpval:SetPoint("TOPLEFT")
    self:Tag(hpval, "[square_portrait:health]")
    
    local name = core:NewFontString(self, cfg.font, 14, "THINOUTLINE")
    name:SetPoint("LEFT",-5,0)
    name:SetPoint("RIGHT",5,0)
    name:SetPoint("BOTTOM", self, "TOP", 0, 4)
    self:Tag(name, "[square_portrait:name]")

    --once a new health event fires we update our portrait texture
    self.Health.PostUpdate = function(bar,...)
      local hcur = bar:GetValue()
      local hmin, hmax = bar:GetMinMaxValues()
      local hper = 0
      if hmax > 0 then
        hper = hcur/hmax
      end
      if hper == 0 then p2:Hide() return end
      if not p2:IsShown() then p2:Show() end --i see no dead people
      p2:SetTexCoord(0.15,0.85,0.85-(0.7*hper),0.85)
      p2:SetHeight(self:GetHeight()*hper)
    end

    --update portrait func
    local function UpdatePortrait()
      SetPortraitTexture(p, self.unit)
      SetPortraitTexture(p2, self.unit)
    end

    --onshow func
    local function OnShow(...)
      UpdatePortrait()
    end

    --handle some events
    local eventHandler = CreateFrame("Frame")

    function eventHandler:UNIT_MODEL_CHANGED(...)
      UpdatePortrait()
    end

    function eventHandler:UNIT_PORTRAIT_UPDATE(...)
      UpdatePortrait()
    end

    function eventHandler:PLAYER_TARGET_CHANGED(...)
      OnShow()
    end

    function eventHandler:PLAYER_FOCUS_CHANGED(...)
      OnShow()
    end

    eventHandler:HookScript("OnEvent", function(self, event, ...)
      if not self[event] then print("no event: "..event) return end
      self[event](self,event, ...)
    end)

    eventHandler:RegisterUnitEvent("UNIT_PORTRAIT_UPDATE", self.unit)
    eventHandler:RegisterUnitEvent("UNIT_MODEL_CHANGED", self.unit)
    eventHandler:RegisterEvent("PLAYER_TARGET_CHANGED")
    eventHandler:RegisterEvent("PLAYER_FOCUS_CHANGED")

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