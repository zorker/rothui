
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
    core:CreateDropShadow(self, cfg.mediaPath.."backdrop_outershadow", 5, 5)
    self:SetDropShadowColor(0,0,0,0.7)
    
    --bg
    local bg = self:CreateTexture(nil, "BACKGROUND", nil, -7)
    bg:SetAllPoints()
    bg:SetTexture(1,1,1)
    bg:SetVertexColor(0,0,0,0.7)
    
    local p = self:CreateTexture(nil, "BACKGROUND", nil, -6)
    p:SetAllPoints()
    p:SetTexCoord(0.15,0.85,0.15,0.85)
    p:SetAlpha(1)
    p:SetDesaturated(1)
    p:SetBlendMode("BLEND")
    SetPortraitTexture(p, self.unit)
    
    local red = self:CreateTexture(nil, "BACKGROUND", nil, -5)
    red:SetAllPoints()
    red:SetTexture(1,1,1)
    red:SetVertexColor(1,0,0,1)
    red:SetBlendMode("ADD")
    
    local p2 = self:CreateTexture(nil, "BACKGROUND", nil, -4)
    p2:SetPoint("BOTTOMLEFT")
    p2:SetPoint("BOTTOMRIGHT")
    p2:SetHeight(self:GetHeight())
    p2:SetTexCoord(0.15,0.85,0.15,0.85)
    SetPortraitTexture(p2, self.unit)
    
    local h = CreateFrame("StatusBar", nil, self)
    h.frequentUpdates = true
    self.Health = h
    
    self.Health.PostUpdate = function(bar,...) 
      local hcur = bar:GetValue()
      local hmin, hmax = bar:GetMinMaxValues()
      local hper = 0
      if hmax > 0 then
        hper = hcur/hmax
      end
      local v = 0.7*hper
      p2:SetTexCoord(0.15,0.85,0.85-v,0.85)
      p2:SetHeight(self:GetHeight()*hper)
    end
    
    local eventHandler = CreateFrame("Frame")
    
    local function UpdatePortrait()
      SetPortraitTexture(p, self.unit)
      SetPortraitTexture(p2, self.unit)
    end
    
    local function OnShow(...)
      UpdatePortrait()
    end
    
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
  
  local playerFrame = oUF:Spawn("player", addonName.."Player")
  playerFrame:SetPoint("CENTER",-200,0)
  
  local TargetFrame = oUF:Spawn("target", addonName.."Target")
  TargetFrame:SetPoint("CENTER",200,0)
  
  local TargetTargetFrame = oUF:Spawn("targettarget", addonName.."TargetTarget")
  TargetTargetFrame:SetPoint("CENTER",100,0)
  
  local PetFrame = oUF:Spawn("pet", addonName.."Pet")
  PetFrame:SetPoint("CENTER",-100,0)

  local FocusFrame = oUF:Spawn("focus", addonName.."Focus")
  FocusFrame:SetPoint("CENTER",-300,0)