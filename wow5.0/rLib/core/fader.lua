
  -- // fader functionality - frame fading
  -- // zork - 2012

  -----------------------------
  -- GLOBAL FUNCTIONS
  -----------------------------

  --add some global functions
  local defaultFadeIn   = {time = 0.4, alpha = 1}
  local defaultFadeOut  = {time = 0.3, alpha = 0}

  local frameFadeManager = CreateFrame("FRAME");

  -- Generic fade function
  local function UIFrameFade(frame, fadeInfo)
    if (not frame) then
      return;
    end
    if ( not fadeInfo.mode ) then
      fadeInfo.mode = "IN";
    end
    local alpha;
    if ( fadeInfo.mode == "IN" ) then
      if ( not fadeInfo.startAlpha ) then
        fadeInfo.startAlpha = 0;
      end
      if ( not fadeInfo.endAlpha ) then
        fadeInfo.endAlpha = 1.0;
      end
      alpha = 0;
    elseif ( fadeInfo.mode == "OUT" ) then
      if ( not fadeInfo.startAlpha ) then
        fadeInfo.startAlpha = 1.0;
      end
      if ( not fadeInfo.endAlpha ) then
        fadeInfo.endAlpha = 0;
      end
      alpha = 1.0;
    end
    frame:SetAlpha(fadeInfo.startAlpha);

    frame.fadeInfo = fadeInfo;

    local index = 1;
    while FADEFRAMES[index] do
      -- If frame is already set to fade then return
      if ( FADEFRAMES[index] == frame ) then
        return;
      end
      index = index + 1;
    end
    tinsert(FADEFRAMES, frame);
    frameFadeManager:SetScript("OnUpdate", UIFrameFade_OnUpdate);
  end

  -- Convenience function to do a simple fade in
  local function UIFrameFadeIn(frame, timeToFade, startAlpha, endAlpha)
    local fadeInfo = {};
    fadeInfo.mode = "IN";
    fadeInfo.timeToFade = timeToFade;
    fadeInfo.startAlpha = startAlpha;
    fadeInfo.endAlpha = endAlpha;
    UIFrameFade(frame, fadeInfo);
  end

  -- Convenience function to do a simple fade out
  local function UIFrameFadeOut(frame, timeToFade, startAlpha, endAlpha)
    local fadeInfo = {};
    fadeInfo.mode = "OUT";
    fadeInfo.timeToFade = timeToFade;
    fadeInfo.startAlpha = startAlpha;
    fadeInfo.endAlpha = endAlpha;
    UIFrameFade(frame, fadeInfo);
  end


  --rButtonBarFader func
  function rButtonBarFader(frame,buttonList,fadeIn,fadeOut)
    --if 1 == 1 then return end
    if not frame or not buttonList then return end
    if not fadeIn then fadeIn = defaultFadeIn end
    if not fadeOut then fadeOut = defaultFadeOut end
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
    --if 1 == 1 then return end
    if not frame then return end
    if not fadeIn then fadeIn = defaultFadeIn end
    if not fadeOut then fadeOut = defaultFadeOut end
    frame:EnableMouse(true)
    frame:SetScript("OnEnter", function(self) UIFrameFadeIn( frame, fadeIn.time, frame:GetAlpha(), fadeIn.alpha) end)
    frame:SetScript("OnLeave", function(self) UIFrameFadeOut(frame, fadeOut.time, frame:GetAlpha(), fadeOut.alpha) end)
    UIFrameFadeOut(frame, fadeOut.time, frame:GetAlpha(), fadeOut.alpha)
  end