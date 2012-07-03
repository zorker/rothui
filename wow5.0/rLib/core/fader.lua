
  -- // fader functionality - frame fading
  -- // zork - 2012

  -----------------------------
  -- GLOBAL FUNCTIONS
  -----------------------------

  --add some global functions

  --rButtonBarFader func
  function rButtonBarFader(frame,buttonList,fadeIn,fadeOut)
    if not frame then return end
    if not buttonList then return end
    frame:EnableMouse(true)
    frame:SetScript("OnEnter", function() UIFrameFadeIn( frame, fadeIn.time, frame:GetAlpha(), fadeIn.alpha) end)
    frame:SetScript("OnLeave", function() UIFrameFadeOut(frame, fadeOut.time, frame:GetAlpha(), fadeOut.alpha) end)
    UIFrameFadeOut(frame, fadeOut.time, frame:GetAlpha(), fadeOut.alpha)
    for _, button in pairs(buttonList) do
      if button then
        button:HookScript("OnEnter", function() UIFrameFadeIn( frame, fadeIn.time, frame:GetAlpha(), fadeIn.alpha) end)
        button:HookScript("OnLeave", function() UIFrameFadeOut(frame, fadeOut.time, frame:GetAlpha(), fadeOut.alpha) end)
      end
    end
  end

  --rFrameFader func
  function rFrameFader(frame,fadeIn,fadeOut)
    if not frame then return end
    frame:EnableMouse(true)
    frame:SetScript("OnEnter", function(self) UIFrameFadeIn( frame, fadeIn.time, frame:GetAlpha(), fadeIn.alpha) end)
    frame:SetScript("OnLeave", function(self) UIFrameFadeOut(frame, fadeOut.time, frame:GetAlpha(), fadeOut.alpha) end)
    UIFrameFadeOut(frame, fadeOut.time, frame:GetAlpha(), fadeOut.alpha)
  end