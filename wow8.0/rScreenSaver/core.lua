
-- rScreenSaver: core
-- zork, 2016

-----------------------------
-- Local Variables
-----------------------------

  local A, L = ...
  L.addonName = A

-----------------------------
-- Init
-----------------------------

--canvas frame
local f = CreateFrame("Frame",nil,UIParent)
f:SetFrameStrata("FULLSCREEN")
f:SetAllPoints()
f.h = f:GetHeight()
f:EnableMouse(true)
f:SetAlpha(0)
f:Hide()

--enable frame
function f:Enable()
  if self.isActive then return end
  self.isActive = true
  self:Show()
  self.fadeIn:Play()
end

--disable frame
function f:Disable()
  if not self.isActive then return end
  self.isActive = false
  self.fadeOut:Play()
end

--onevent handler
function f:OnEvent(event)
  if event == "PLAYER_LOGIN" then
    self.model:SetUnit("player")
    self.model:SetRotation(math.rad(-110))
    self.galaxy:SetDisplayInfo(67918)
    self.galaxy:SetCamDistanceScale(2.2)
    --self.galaxy:SetRotation(math.rad(180))
    return
  end
  if UnitIsAFK("player") then
    self:Enable()
  else
    self:Disable()
  end
end

--fade in anim
f.fadeIn = f:CreateAnimationGroup()
f.fadeIn.anim = f.fadeIn:CreateAnimation("Alpha")
f.fadeIn.anim:SetDuration(1)
f.fadeIn.anim:SetSmoothing("OUT")
f.fadeIn.anim:SetFromAlpha(0)
f.fadeIn.anim:SetToAlpha(1)
f.fadeIn:HookScript("OnFinished", function(self)
  self:GetParent():SetAlpha(1)
end)

--fade out anim
f.fadeOut = f:CreateAnimationGroup()
f.fadeOut.anim = f.fadeOut:CreateAnimation("Alpha")
f.fadeOut.anim:SetDuration(1)
f.fadeOut.anim:SetSmoothing("OUT")
f.fadeOut.anim:SetFromAlpha(1)
f.fadeOut.anim:SetToAlpha(0)
f.fadeOut:HookScript("OnFinished", function(self)
  self:GetParent():SetAlpha(0)
  self:GetParent():Hide()
end)

--black background
f.bg = f:CreateTexture(nil,"BACKGROUND",nil,-8)
f.bg:SetColorTexture(1,1,1)
f.bg:SetVertexColor(0,0,0,1)
f.bg:SetAllPoints()

--galaxy animation
f.galaxy = CreateFrame("PlayerModel",nil,f)
f.galaxy:SetAllPoints()

--player model
f.model = CreateFrame("PlayerModel",nil,f.galaxy)
f.model:SetSize(f.h,f.h*1.5)
f.model:SetPoint("BOTTOMRIGHT",f.h*0.25,-f.h*0.5)

--inner shadow gradients
f.gradient = f.model:CreateTexture(nil,"BACKGROUND",nil,-7)
f.gradient:SetColorTexture(1,1,1)
f.gradient:SetVertexColor(0,0,0,1)
f.gradient:SetGradientAlpha("VERTICAL", 0, 0, 0, 1, 0, 0, 0, 0)
f.gradient:SetPoint("BOTTOMLEFT",f)
f.gradient:SetPoint("BOTTOMRIGHT",f)
f.gradient:SetHeight(100)

--close button
local button = CreateFrame("Button", A.."Button", f.model, "UIPanelButtonTemplate")
button.text = _G[button:GetName().."Text"]
button.text:SetText("Close")
button:SetWidth(button.text:GetStringWidth()+20)
button:SetHeight(button.text:GetStringHeight()+12)
button:SetPoint("BOTTOMLEFT",f,10,10)
button:SetAlpha(0.5)
button:HookScript("OnClick", function(self)
  f:Disable()
end)

--onevent
f:SetScript("OnEvent",f.OnEvent)

--register events
f:RegisterEvent("PLAYER_FLAGS_CHANGED")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_LEAVING_WORLD")
f:RegisterEvent("PLAYER_LOGIN")
