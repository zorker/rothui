
  -- // fader functionality - frame fading
  -- // zork - 2012

  -----------------------------
  -- GLOBAL FUNCTIONS
  -----------------------------

  --add some global functions

  --rGetPoint func
  function rFrameFading(frame,tab,fadeIn,fadeOut)
    if not frame then return end
    frame:EnableMouse(true)
    frame:SetScript("OnEnter", function(self) UIFrameFadeIn( frame, fadeIn.time, frame:GetAlpha(), fadeIn.alpha) end)
    frame:SetScript("OnLeave", function(self) UIFrameFadeOut(frame, fadeOut.time, frame:GetAlpha(), fadeOut.alpha) end)
    UIFrameFadeOut(frame, fadeOut.time, frame:GetAlpha(), fadeOut.alpha)
    if tab then
      for _, button in pairs(tab) do
        if button then
          button:HookScript("OnEnter", function(self) UIFrameFadeIn( frame, fadeIn.time, frame:GetAlpha(), fadeIn.alpha) end)
          button:HookScript("OnLeave", function(self) UIFrameFadeOut(frame, fadeOut.time, frame:GetAlpha(), fadeOut.alpha) end)
        end
      end
    end
  end
