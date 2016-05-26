
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
  frame.fader = frame:CreateAnimationGroup()
  frame.fader.__owner = frame
  frame.fader.direction = nil
  frame.fader.anim = frame.fader:CreateAnimation("Alpha")
  frame.fader:HookScript("OnFinished", FaderOnFinished)
end

local function IsMouseOverFlyout(frame)
  if not SpellFlyout:IsShown() then return false end
  if SpellFlyout:GetParent():GetParent():GetParent() == frame and MouseIsOver(SpellFlyout) then return true end
  return false
end

local function StartFadeIn(frame)
  if frame.fader.direction == "in" then return end
  if MouseIsOver(frame) or IsMouseOverFlyout(frame) then
    frame.fader:Pause()
    frame.fader.anim:SetFromAlpha(frame:GetAlpha())
    frame.fader.anim:SetToAlpha(frame.faderConfig.fadeInAlpha)
    frame.fader.anim:SetDuration(frame.faderConfig.fadeInDuration)
    frame.fader.anim:SetSmoothing(frame.faderConfig.fadeInSmooth)
    frame.fader.finAlpha = frame.faderConfig.fadeInAlpha
    frame.fader.direction = "in"
    frame.fader:Play()
  end
end

local function StartFadeOut(frame)
  if frame.fader.direction == "out" or MouseIsOver(frame) or IsMouseOverFlyout(frame) then return end
  frame.fader:Pause()
  frame.fader.anim:SetFromAlpha(frame:GetAlpha())
  frame.fader.anim:SetToAlpha(frame.faderConfig.fadeOutAlpha)
  frame.fader.anim:SetDuration(frame.faderConfig.fadeOutDuration)
  frame.fader.anim:SetSmoothing(frame.faderConfig.fadeOutSmooth)
  frame.fader.finAlpha = frame.faderConfig.fadeOutAlpha
  frame.fader.direction = "out"
  frame.fader:Play()
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

function rLib:CreateFrameFader(frame, faderConfig)
  frame.faderConfig = faderConfig
  frame:EnableMouse(true)
  CreateFaderAnimation(frame)
  frame:HookScript("OnEnter", StartFadeIn)
  frame:HookScript("OnLeave", StartFadeOut)
  if not MouseIsOver(frame) then
    StartFadeOut(frame)
  else
    StartFadeIn(frame)
  end
end

function rLib:CreateButtonFrameFader(frame, buttonList, faderConfig)
  rLib:CreateFrameFader(frame, faderConfig)
  for i, button in next, buttonList do
    button:HookScript("OnEnter", StartFadeInFromButton)
    button:HookScript("OnLeave", StartFadeOutFromButton)
  end
end
