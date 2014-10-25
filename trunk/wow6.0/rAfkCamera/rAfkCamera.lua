
  -- // rAfkCamera
  -- // zork - 2014

  -----------------------------
  -- VARIABLES
  -----------------------------

  local an, at = ...

  -----------------------------
  -- FUNCTIONS
  -----------------------------

  local function OnEvent(self)
    self.title:SetText(UnitName("player").."-"..GetRealmName())
    self.server:SetText("<"..GetGuildInfo("player")..">")
    if UIParent:IsShown() and self:IsShown() then
      self:Disable()
      return
    end
    if UnitIsAFK("player") then
      self:Enable()
    end
  end

  --canvas frame
  local f = CreateFrame("Frame",nil,WorldFrame)
  f:SetAllPoints()
  f:EnableMouse(true)
  f:SetAlpha(0)
  --f:Hide()
  f.w,f.h = f:GetSize()

  --canvas background
  f.bg = f:CreateTexture(nil,"BACKGROUND",nil,-8)
  f.bg:SetTexture(1,1,1)
  f.bg:SetVertexColor(0.15,0.15,0.15,0.7)
  f.bg:SetPoint("BOTTOMLEFT")
  f.bg:SetPoint("BOTTOMRIGHT")
  f.bg:SetHeight(f.h*0.13)

  --canvas background
  f.bg2 = f:CreateTexture(nil,"BACKGROUND",nil,-8)
  f.bg2:SetTexture(1,1,1)
  f.bg2:SetVertexColor(0.15,0.15,0.15,0.7)
  f.bg2:SetPoint("TOPLEFT")
  f.bg2:SetPoint("TOPRIGHT")
  f.bg2:SetHeight(f.h*0.065)
  
  --model
  f.model = CreateFrame("PlayerModel",nil,f)
  f.model:SetSize(f.h*0.75,f.h*1.5)
  f.model:SetPoint("BOTTOMRIGHT",0,-f.h*0.5)

  function f:UpdateModel()
    self.model:SetUnit("player")
    self.model:SetRotation(math.rad(-30))
  end
  
  f.server = f:CreateFontString(nil, "BACKGROUND")
  f.server:SetFont(STANDARD_TEXT_FONT, 18, "OUTLINE")
  f.server:SetPoint("BOTTOMLEFT", 20, 20)  
  f.server:SetTextColor(0.6,0.6,0.6)
  
  f.title = f:CreateFontString(nil, "BACKGROUND")
  f.title:SetFont(STANDARD_TEXT_FONT, 32, "OUTLINE")
  f.title:SetPoint("BOTTOMLEFT", f.server, "TOPLEFT", 0, 0)
  

  --fade in anim
  f.fadeIn = f:CreateAnimationGroup()
  f.fadeIn.anim = f.fadeIn:CreateAnimation("Alpha")
  f.fadeIn.anim:SetDuration(0.8)
  f.fadeIn.anim:SetSmoothing("IN")
  f.fadeIn.anim:SetChange(1)
  f.fadeIn:HookScript("OnFinished", function(self)
    self:GetParent():SetAlpha(1)
  end)

  --fade out anim
  f.fadeOut = f:CreateAnimationGroup()
  f.fadeOut.anim = f.fadeOut:CreateAnimation("Alpha")
  f.fadeOut.anim:SetDuration(0.8)
  f.fadeOut.anim:SetSmoothing("OUT")
  f.fadeOut.anim:SetChange(-1)
  f.fadeOut:HookScript("OnFinished", function(self)
    self:GetParent():SetAlpha(0)
    self:GetParent():Hide()
  end)

  -- canvas enable func
  function f:Enable()
    self:Show()
    self:UpdateModel()
    UIParent:Hide()
    MoveViewRightStart(0.1)
    self.fadeIn:Play()
  end

  -- canvas disable func
  function f:Disable()
    UIParent:Show()
    MoveViewRightStop()
    self.fadeOut:Play()
  end

  f:SetScript("OnEvent",OnEvent)

  f:RegisterEvent("PLAYER_FLAGS_CHANGED")
  f:RegisterEvent("PLAYER_ENTERING_WORLD")
  f:RegisterEvent("PLAYER_LEAVING_WORLD")
  
  UIParent:HookScript("OnShow", function() OnEvent(f) end)