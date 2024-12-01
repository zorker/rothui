-- rLib: framefader
-- zork, 2024

-----------------------------
-- Variables
-----------------------------

local A, L = ...

local SpellFlyout = SpellFlyout

-----------------------------
-- Functions
-----------------------------

local function FaderOnFinished(self)
  self.__owner:SetAlpha(self.finAlpha)
end

local function CreateFaderAnimation(frame)
  if frame.__fader then return end
  frame.__fader = frame:CreateAnimationGroup()
  frame.__fader.__owner = frame
  frame.__fader.direction = nil
  frame.__fader.setToFinalAlpha = false
  frame.__fader.anim = frame.__fader:CreateAnimation("Alpha")
  frame.__fader:HookScript("OnFinished", FaderOnFinished)
end

local function StartFadeIn(frame)
  if not frame.__fader or frame.__fader.direction == "in" then return end
  frame.__fader:Pause()
  frame.__fader.anim:SetFromAlpha(frame.__faderConfig.fadeOutAlpha or 0)
  frame.__fader.anim:SetToAlpha(frame.__faderConfig.fadeInAlpha or 1)
  frame.__fader.anim:SetDuration(frame.__faderConfig.fadeInDuration or 0.3)
  frame.__fader.anim:SetSmoothing(frame.__faderConfig.fadeInSmooth or "OUT")
  --start right away
  frame.__fader.anim:SetStartDelay(frame.__faderConfig.fadeInDelay or 0)
  frame.__fader.finAlpha = frame.__faderConfig.fadeInAlpha
  frame.__fader.direction = "in"
  frame.__fader:Play()
end

local function StartFadeOut(frame)
  if not frame.__fader or frame.__fader.direction == "out" then return end
  frame.__fader:Pause()
  frame.__fader.anim:SetFromAlpha(frame.__faderConfig.fadeInAlpha or 1)
  frame.__fader.anim:SetToAlpha(frame.__faderConfig.fadeOutAlpha or 0)
  frame.__fader.anim:SetDuration(frame.__faderConfig.fadeOutDuration or 0.3)
  frame.__fader.anim:SetSmoothing(frame.__faderConfig.fadeOutSmooth or "OUT")
  --wait for some time before starting the fadeout
  frame.__fader.anim:SetStartDelay(frame.__faderConfig.fadeOutDelay or 0)
  frame.__fader.finAlpha = frame.__faderConfig.fadeOutAlpha
  frame.__fader.direction = "out"
  frame.__fader:Play()
end

local function IsMouseOverFrame(frame)
  if MouseIsOver(frame) then return true end
  if not SpellFlyout:IsShown() then return false end
  if not SpellFlyout.__faderParent then return false end
  if SpellFlyout.__faderParent == frame and MouseIsOver(SpellFlyout) then return true end
  return false
end

local function FrameHandler(frame)
  if IsMouseOverFrame(frame) then
    StartFadeIn(frame)
  else
    StartFadeOut(frame)
  end
end

local function OffFrameHandler(self)
  if not self.__faderParent then return end
  FrameHandler(self.__faderParent)
end

local function SpellFlyoutOnShow(self)
  local frame = self:GetParent():GetParent():GetParent()
  if not frame.__fader then return end
  --set new frame parent
  self.__faderParent = frame
  if not self.__faderHook then
    SpellFlyout:HookScript("OnEnter", OffFrameHandler)
    SpellFlyout:HookScript("OnLeave", OffFrameHandler)
    self.__faderHook = true
  end
  for i=1, NUM_ACTIONBAR_BUTTONS do --hopefully 12 is enough
    local button = _G["SpellFlyoutButton"..i]
    if not button then break end
    button.__faderParent = frame
    if not button.__faderHook then
      button:HookScript("OnEnter", OffFrameHandler)
      button:HookScript("OnLeave", OffFrameHandler)
      button.__faderHook = true
    end
  end
end
SpellFlyout:HookScript("OnShow", SpellFlyoutOnShow)

function rLib:CreateFrameFader(frame, faderConfig)
  if frame.__faderConfig then return end
  frame.__faderConfig = faderConfig
  CreateFaderAnimation(frame)
  frame:EnableMouse(true)
  frame:HookScript("OnEnter", FrameHandler)
  frame:HookScript("OnLeave", FrameHandler)
  FrameHandler(frame)
end

function rLib:CreateButtonFrameFader(frame, buttonList, faderConfig)
  if not frame then return end
  rLib:CreateFrameFader(frame, faderConfig)
  for i, button in next, buttonList do
    if not button.__faderParent then
      button.__faderParent = frame
      button:HookScript("OnEnter", OffFrameHandler)
      button:HookScript("OnLeave", OffFrameHandler)
    end
  end
end
