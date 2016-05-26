
-- rLib: framefader
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Functions
-----------------------------

local function FaderOnFinished(self)
  self.__owner:SetAlpha(self.finAlpha)
end

local function CreateFaderAnimation(frame)
  if frame.fader then return end
  --fader
  frame.fader = frame:CreateAnimationGroup()
  frame.fader.__owner = frame
  frame.fader.direction = nil
  frame.fader.anim = frame.fader:CreateAnimation("Alpha")
  frame.fader:HookScript("OnFinished", FaderOnFinished)
end

--enable func
local function StartFadeIn(frame)
  if frame.fader.direction == "in" or not MouseIsOver(frame) then return end
  frame.fader:Pause()
  frame.fader.anim:SetFromAlpha(frame:GetAlpha())
  frame.fader.anim:SetToAlpha(frame.faderConfig.fadeInAlpha)
  frame.fader.anim:SetDuration(frame.faderConfig.fadeInDuration)
  frame.fader.anim:SetSmoothing(frame.faderConfig.fadeInSmooth)
  frame.fader.finAlpha = frame.faderConfig.fadeInAlpha
  frame.fader:Play()
  frame.fader.direction = "in"
end

--disable func
local function StartFadeOut(frame)
  if frame.fader.direction == "out" or MouseIsOver(frame) then return end
  frame.fader:Pause()
  frame.fader.anim:SetFromAlpha(frame:GetAlpha())
  frame.fader.anim:SetToAlpha(frame.faderConfig.fadeOutAlpha)
  frame.fader.anim:SetDuration(frame.faderConfig.fadeOutDuration)
  frame.fader.anim:SetSmoothing(frame.faderConfig.fadeOutSmooth)
  frame.fader.finAlpha = frame.faderConfig.fadeOutAlpha
  frame.fader:Play()
  frame.fader.direction = "out"
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
    StartFadeOut(button:GetParent())
  elseif button:GetParent():GetParent().faderConfig then
    StartFadeOut(button:GetParent():GetParent())
  end
end

function rLib:CreateButtonFrameFader(frame, buttonList, faderConfig)
  frame.faderConfig = faderConfig
  frame:EnableMouse(true)
  CreateFaderAnimation(frame)
  frame:HookScript("OnEnter", StartFadeIn)
  frame:HookScript("OnLeave", StartFadeOut)
  for i, button in next, buttonList do
    button:HookScript("OnEnter", StartFadeInFromButton)
    button:HookScript("OnLeave", StartFadeOutFromButton)
  end
  if not MouseIsOver(frame) then
    StartFadeOut(frame)
  else
    StartFadeIn(frame)
  end
end