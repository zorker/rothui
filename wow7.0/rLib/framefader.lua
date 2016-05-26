
-- rLib: framefader
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Functions
-----------------------------

local function FadeInOnFinished(self)
  local frame = self.__owner
  frame:SetAlpha(frame.faderConfig.fadeInAlpha)
end

local function FadeOutOnFinished(self)
  local frame = self.__owner
  frame:SetAlpha(frame.faderConfig.fadeOutAlpha)
end

local function CreateFaderAnimations(frame)
  if frame.fadeIn then return end
  --fade in anim
  frame.fadeIn = frame:CreateAnimationGroup()
  frame.fadeIn.__owner = frame
  frame.fadeIn.anim = frame.fadeIn:CreateAnimation("Alpha")
  frame.fadeIn.anim:SetDuration(frame.faderConfig.fadeInDuration)
  frame.fadeIn.anim:SetSmoothing(frame.faderConfig.fadeInSmooth)
  frame.fadeIn.anim:SetFromAlpha(frame.faderConfig.fadeOutAlpha)
  frame.fadeIn.anim:SetToAlpha(frame.faderConfig.fadeInAlpha)
  frame.fadeIn:HookScript("OnFinished", FadeInOnFinished)
  --fade out anim
  frame.fadeOut = frame:CreateAnimationGroup()
  frame.fadeOut.__owner = frame
  frame.fadeOut.anim = frame.fadeOut:CreateAnimation("Alpha")
  frame.fadeOut.anim:SetDuration(frame.faderConfig.fadeOutDuration)
  frame.fadeOut.anim:SetSmoothing(frame.faderConfig.fadeOutSmooth)
  frame.fadeOut.anim:SetFromAlpha(frame.faderConfig.fadeInAlpha)
  frame.fadeOut.anim:SetToAlpha(frame.faderConfig.fadeOutAlpha)
  frame.fadeOut:HookScript("OnFinished", FadeOutOnFinished)
end

--enable func
local function StartFadeIn(frame)
  frame.fadeIn.anim:SetFromAlpha(frame:GetAlpha())
  frame.fadeOut:Stop()
  frame.fadeIn:Play()
end

--disable func
local function StartFadeOut(frame)
  frame.fadeOut.anim:SetFromAlpha(frame:GetAlpha())
  frame.fadeIn:Stop()
  frame.fadeOut:Play()
end

local function StartFadeInFromButton(button)
  if button:GetParent().faderConfig then
    StartFadeIn(button:GetParent())
  elseif button:GetParent():GetParent().faderConfig then
    StartFadeIn(button:GetParent():GetParent())
  end
end

local function StartFadeOutFromButton(button)
  if button:GetParent().faderConfig then
    StartFadeIn(button:GetParent())
  elseif button:GetParent():GetParent().faderConfig then
    StartFadeIn(button:GetParent():GetParent())
  end
end

function rLib:CreateButtonFrameFader(frame, buttonList, faderConfig)
  frame.faderConfig = faderConfig
  frame:EnableMouse(true)
  CreateFaderAnimations(frame)
  frame:HookScript("OnEnter", StartFadeIn)
  frame:HookScript("OnLeave", StartFadeOut)
  if not MouseIsOver(frame) then
    StartFadeOut(frame)
  end
  for i, button in next, buttonList do
    button:HookScript("OnEnter", StartFadeInFromButton)
    button:HookScript("OnLeave", StartFadeOutFromButton)
  end
end