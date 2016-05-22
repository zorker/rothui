
-- rScreenSaver: core
-- zork, 2016

-----------------------------
-- Local Variables
-----------------------------

  local A, L = ...
  L.addonName = A

-----------------------------
-- Local Functions
-----------------------------

-- canvas enable func
local function Enable(self)
  self.isActive = true
  self:Show()
  self.fadeIn:Play()
end

-- canvas disable func
local function Disable(self)
  self.isActive = false
  self.fadeOut:Play()
end

local function OnEvent(self,event)
  if event == "PLAYER_LOGIN" then
    self.model:SetUnit("player")
    self.model:SetRotation(math.rad(-110))
    self.model:SetUnit("player")
    self.galaxy:SetDisplayInfo(67918)
    self.galaxy:SetCamDistanceScale(1.75)
    return
  end
  if UnitIsAFK("player") then
    if self.isActive then return end
    Enable(self)
  else
    if not self.isActive then return end
    Disable(self)
  end
end

--canvas frame
local f = CreateFrame("Frame",nil,UIParent)
f:SetFrameStrata("FULLSCREEN")
f:SetAlpha(0)
f:SetAllPoints()
f.h = f:GetHeight()
f:EnableMouse(true)
f:Hide()

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

f.bg = f:CreateTexture(nil,"BACKGROUND",nil,-8)
f.bg:SetTexture(1,1,1)
f.bg:SetVertexColor(0,0,0,1)
f.bg:SetAllPoints()

f.galaxy = CreateFrame("PlayerModel",nil,f)
f.galaxy:SetAllPoints()

--model
f.model = CreateFrame("PlayerModel",nil,f.galaxy)
f.model:SetSize(f.h,f.h*1.5)
f.model:SetPoint("BOTTOMRIGHT",f.h*0.25,-f.h*0.5)

f.gradient = f.model:CreateTexture(nil,"BACKGROUND",nil,-7)
f.gradient:SetTexture(1,1,1)
f.gradient:SetVertexColor(0,0,0,1)
f.gradient:SetGradientAlpha("VERTICAL", 0, 0, 0, 1, 0, 0, 0, 0)
f.gradient:SetPoint("BOTTOMLEFT",f)
f.gradient:SetPoint("BOTTOMRIGHT",f)
f.gradient:SetHeight(100)


f.gradient2 = f.model:CreateTexture(nil,"BACKGROUND",nil,-7)
f.gradient2:SetTexture(1,1,1)
f.gradient2:SetVertexColor(0,0,0,1)
f.gradient2:SetGradientAlpha("VERTICAL", 0, 0, 0, 0, 0, 0, 0, 0.5)
f.gradient2:SetPoint("TOPLEFT",f)
f.gradient2:SetPoint("TOPRIGHT",f)
f.gradient2:SetHeight(50)

f.gradient3 = f.model:CreateTexture(nil,"BACKGROUND",nil,-7)
f.gradient3:SetTexture(1,1,1)
f.gradient3:SetVertexColor(0,0,0,1)
f.gradient3:SetGradientAlpha("HORIZONTAL", 0, 0, 0, 0.5, 0, 0, 0, 0)
f.gradient3:SetPoint("TOPLEFT",f)
f.gradient3:SetPoint("BOTTOMLEFT",f)
f.gradient3:SetWidth(50)

f.gradient4 = f.model:CreateTexture(nil,"BACKGROUND",nil,-7)
f.gradient4:SetTexture(1,1,1)
f.gradient4:SetVertexColor(0,0,0,1)
f.gradient4:SetGradientAlpha("HORIZONTAL", 0, 0, 0, 0, 0, 0, 0, 0.5)
f.gradient4:SetPoint("TOPRIGHT",f)
f.gradient4:SetPoint("BOTTOMRIGHT",f)
f.gradient4:SetWidth(50)
--[[]]--

local button = CreateFrame("Button", A.."Button", f.model, "UIPanelButtonTemplate")
button.text = _G[button:GetName().."Text"]
button.text:SetText("Close")
button:SetWidth(button.text:GetStringWidth()+20)
button:SetHeight(button.text:GetStringHeight()+12)
button:SetPoint("BOTTOMLEFT",f,10,10)
button:HookScript("OnClick", function(self)
  Disable(f)
end)

f:SetScript("OnEvent",OnEvent)

f:RegisterEvent("PLAYER_FLAGS_CHANGED")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_LEAVING_WORLD")
f:RegisterEvent("PLAYER_LOGIN")
