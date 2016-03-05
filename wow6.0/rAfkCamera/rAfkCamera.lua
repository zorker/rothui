
  -- // rAfkCamera
  -- // zork - 2016

  -----------------------------
  -- VARIABLES
  -----------------------------

  local an, at = ...

  -----------------------------
  -- FUNCTIONS
  -----------------------------
    
  -- canvas enable func
  local function Enable(self)
    self.isActive = true
    self.title:SetText(UnitName("player").."-"..GetRealmName())
    self.server:SetText("<"..(GetGuildInfo("player") or "No Guild")..">")
    local alpha = self:GetAlpha()
    self.fadeOut:Stop()
    self:SetAlpha(alpha)
    self:Show()
    self.fadeIn:Play()
    self.model:SetUnit("player")
    self.model:SetRotation(math.rad(-30))
    UIParent:Hide()
    SetUIVisibility(false)
    MoveViewRightStart(0.025)
  end

  -- canvas disable func
  local function Disable(self)
    self.isActive = false
    local alpha = self:GetAlpha()
    self.fadeIn:Stop()
    self:SetAlpha(alpha)
    self.fadeOut:Play()
    UIParent:Show()
    SetUIVisibility(true)
    MoveViewRightStop()
  end

  local function OnEvent(self)
    if UnitIsAFK("player") then
      if self.isActive then return end
      Enable(self)
    else
      if not self.isActive then return end
      Disable(self)
    end    
  end

  --canvas frame
  local f = CreateFrame("Frame",nil,WorldFrame)
  f:SetAllPoints()
  f:Hide()
  f:SetAlpha(0)
  f.isActive = false
  f.w,f.h = f:GetSize()
  
  --print(GetGameTime())

  --canvas background
  f.bg = f:CreateTexture(nil,"BACKGROUND",nil,-8)
  f.bg:SetTexture(1,1,1)
  f.bg:SetVertexColor(0,0,0,1)
  f.bg:SetGradientAlpha("HORIZONTAL", 0, 0, 0, 0.5, 0, 0, 0, 95)
  f.bg:SetPoint("BOTTOMLEFT")
  f.bg:SetPoint("BOTTOMRIGHT")
  f.bg:SetHeight(100)

  --canvas background
  f.bgTop = f:CreateTexture(nil,"BACKGROUND",nil,-8)
  f.bgTop:SetTexture(1,1,1)
  f.bgTop:SetVertexColor(0,0,0,1)
  f.bgTop:SetGradientAlpha("HORIZONTAL", 0, 0, 0, 0.4, 0, 0, 0, 0.8)
  f.bgTop:SetPoint("TOPLEFT")
  f.bgTop:SetPoint("TOPRIGHT")
  f.bgTop:SetHeight(f.h*0.05)
  
  --fade in anim
  f.fadeIn = f:CreateAnimationGroup()
  f.fadeIn.anim = f.fadeIn:CreateAnimation("Alpha")
  f.fadeIn.anim:SetDuration(1)
  f.fadeIn.anim:SetSmoothing("OUT")
  f.fadeIn.anim:SetChange(1)
  f.fadeIn:HookScript("OnFinished", function(self)
    self:GetParent():SetAlpha(1)
  end)

  --fade out anim
  f.fadeOut = f:CreateAnimationGroup()
  f.fadeOut.anim = f.fadeOut:CreateAnimation("Alpha")
  f.fadeOut.anim:SetDuration(1)
  f.fadeOut.anim:SetSmoothing("OUT")
  f.fadeOut.anim:SetChange(-1)
  f.fadeOut:HookScript("OnFinished", function(self)
    self:GetParent():SetAlpha(0)
    self:GetParent():Hide()
  end)
  
  --model
  f.model = CreateFrame("PlayerModel",nil,f)
  f.model:SetSize(f.h*0.75,f.h*1.5)
  f.model:SetPoint("BOTTOMRIGHT",0,-f.h*0.5)
  
  f.server = f:CreateFontString(nil, "BACKGROUND")
  f.server:SetFont(STANDARD_TEXT_FONT, 18, "OUTLINE")
  f.server:SetPoint("BOTTOMLEFT", 25, 25)  
  f.server:SetTextColor(0.6,0.6,0.6)
  
  f.title = f:CreateFontString(nil, "BACKGROUND")
  f.title:SetFont(STANDARD_TEXT_FONT, 32, "OUTLINE")
  f.title:SetPoint("BOTTOMLEFT", f.server, "TOPLEFT", 0, 5)
  
  f:SetScript("OnEvent",OnEvent)

  f:RegisterEvent("PLAYER_FLAGS_CHANGED")
  f:RegisterEvent("PLAYER_ENTERING_WORLD")
  f:RegisterEvent("PLAYER_LEAVING_WORLD")
  