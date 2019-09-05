
-- rLib: framefader
-- zork, 2019

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

local function FaderOnUpdate(self)
  self.__owner:SetAlpha(self.__animFrame:GetAlpha())
end

local function CreateFaderAnimation(frame)
  if frame.fader then return end
  local animFrame = CreateFrame("Frame",nil,frame)
  animFrame.__owner = frame
  frame.fader = animFrame:CreateAnimationGroup()
  frame.fader.__owner = frame
  frame.fader.__animFrame = animFrame
  frame.fader.direction = nil
  frame.fader.setToFinalAlpha = false
  frame.fader.anim = frame.fader:CreateAnimation("Alpha")
  frame.fader:HookScript("OnFinished", FaderOnFinished)
  frame.fader:HookScript("OnUpdate", FaderOnUpdate)
end

function L:StartFadeIn(frame)
  if frame.fader.direction == "in" then return end
  frame.fader:Pause()
  frame.fader.anim:SetFromAlpha(frame.faderConfig.fadeOutAlpha or 0)
  frame.fader.anim:SetToAlpha(frame.faderConfig.fadeInAlpha or 1)
  frame.fader.anim:SetDuration(frame.faderConfig.fadeInDuration or 0.3)
  frame.fader.anim:SetSmoothing(frame.faderConfig.fadeInSmooth or "OUT")
  frame.fader.anim:SetStartDelay(frame.faderConfig.fadeInDelay or 0)
  frame.fader.finAlpha = frame.faderConfig.fadeInAlpha
  frame.fader.direction = "in"
  frame.fader:Play()
end

function L:StartFadeOut(frame)
  if frame.fader.direction == "out" then return end
  frame.fader:Pause()
  frame.fader.anim:SetFromAlpha(frame.faderConfig.fadeInAlpha or 1)
  frame.fader.anim:SetToAlpha(frame.faderConfig.fadeOutAlpha or 0)
  frame.fader.anim:SetDuration(frame.faderConfig.fadeOutDuration or 0.3)
  frame.fader.anim:SetSmoothing(frame.faderConfig.fadeOutSmooth or "OUT")
  frame.fader.anim:SetStartDelay(frame.faderConfig.fadeOutDelay or 0)
  frame.fader.finAlpha = frame.faderConfig.fadeOutAlpha
  frame.fader.direction = "out"
  frame.fader:Play()
end

local function FrameHandler(frame)
  if MouseIsOver(frame) then
    L:StartFadeIn(frame)
  else
    L:StartFadeOut(frame)
  end
end

local function OffFrameHandler(self)
  if not self.__faderParent then return end
  FrameHandler(self.__faderParent)
end

local function OnShow(self)
  if self.fader then
    L:StartFadeIn(self)
  end
end

local function OnHide(self)
  if self.fader then
    L:StartFadeOut(self)
  end
end

function rLib:CreateFrameFader(frame, faderConfig)
  if frame.faderConfig then return end
  frame.faderConfig = faderConfig
  CreateFaderAnimation(frame)
  if faderConfig.trigger and faderConfig.trigger == "OnShow" then
    frame:HookScript("OnShow", OnShow)
    --I know setting the alpha on a hidden frame does not really make sense but we need to set the fader to "out"
    --sadly a delay on the OnHide is impossible. we get the benefit of the fadeIn though.
    frame:HookScript("OnHide", OnHide)
  else
    frame:EnableMouse(true)
    frame:HookScript("OnEnter", FrameHandler)
    frame:HookScript("OnLeave", FrameHandler)
    FrameHandler(frame)
  end
end

function rLib:CreateButtonFrameFader(frame, buttonList, faderConfig)
  rLib:CreateFrameFader(frame, faderConfig)
  if faderConfig.trigger and faderConfig.trigger == "OnShow" then
    return
  end
  for i, button in next, buttonList do
    if not button.__faderParent then
      button.__faderParent = frame
      button:HookScript("OnEnter", OffFrameHandler)
      button:HookScript("OnLeave", OffFrameHandler)
    end
  end
end
