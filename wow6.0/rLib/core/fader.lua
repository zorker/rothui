
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
    if not frame or not buttonList then return end
    if not fadeIn then fadeIn = defaultFadeIn end
    if not fadeOut then fadeOut = defaultFadeOut end
    frame:EnableMouse(true)
    frame:HookScript("OnEnter", function() UIFrameFadeIn( frame, fadeIn.time, frame:GetAlpha(), fadeIn.alpha) end)
    frame:HookScript("OnLeave", function() UIFrameFadeOut(frame, fadeOut.time, frame:GetAlpha(), fadeOut.alpha) end)
    UIFrameFadeOut(frame, fadeOut.time, frame:GetAlpha(), fadeOut.alpha)
    for _, button in pairs(buttonList) do
      if button then
        button:HookScript("OnEnter", function() UIFrameFadeIn( frame, fadeIn.time, frame:GetAlpha(), fadeIn.alpha) end)
        button:HookScript("OnLeave", function() UIFrameFadeOut(frame, fadeOut.time, frame:GetAlpha(), fadeOut.alpha) end)
      end
    end
  end

  --rSpellFlyoutFader func
  --the flyout is special, when hovering the flyout the parented bar must not fade out
  function rSpellFlyoutFader(frame,buttonList,fadeIn,fadeOut)
    if not frame or not buttonList then return end
    if not fadeIn then fadeIn = defaultFadeIn end
    if not fadeOut then fadeOut = defaultFadeOut end
    SpellFlyout:HookScript("OnEnter", function() UIFrameFadeIn( frame, fadeIn.time, frame:GetAlpha(), fadeIn.alpha) end)
    SpellFlyout:HookScript("OnLeave", function() UIFrameFadeOut(frame, fadeOut.time, frame:GetAlpha(), fadeOut.alpha) end)
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
    if not fadeIn then fadeIn = defaultFadeIn end
    if not fadeOut then fadeOut = defaultFadeOut end
    frame:EnableMouse(true)
    frame:HookScript("OnEnter", function(self) UIFrameFadeIn( frame, fadeIn.time, frame:GetAlpha(), fadeIn.alpha) end)
    frame:HookScript("OnLeave", function(self) UIFrameFadeOut(frame, fadeOut.time, frame:GetAlpha(), fadeOut.alpha) end)
    UIFrameFadeOut(frame, fadeOut.time, frame:GetAlpha(), fadeOut.alpha)
  end

  --rCombatFrameFader func
  function rCombatFrameFader(frame,fadeIn,fadeOut)
    if not frame then return end
    if not fadeIn then fadeIn = defaultFadeIn end
    if not fadeOut then fadeOut = defaultFadeOut end
    frame:RegisterEvent("PLAYER_REGEN_ENABLED")
    frame:RegisterEvent("PLAYER_REGEN_DISABLED")
    frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    frame:HookScript("OnEvent", function(self,event,...)
      if event == "PLAYER_REGEN_DISABLED" then
        UIFrameFadeIn( frame, fadeIn.time, frame:GetAlpha(), fadeIn.alpha)
      elseif event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_ENTERING_WORLD" then
        UIFrameFadeOut(frame, fadeOut.time, frame:GetAlpha(), fadeOut.alpha)
      end
    end)
  end

  --rFrameFaderHook func
  --special function where an OnEnter script on that frame already exists that we do not want to destroy, so we hook instead
  --the hookFrame is the frame that we hook the event onto
  --the frame is the frame that we actually want to fade (it can match the hookFrame but it does not have to)
  function rFrameFaderHook(hookFrame,frame,fadeIn,fadeOut)
    if not frame then return end
    if not fadeIn then fadeIn = defaultFadeIn end
    if not fadeOut then fadeOut = defaultFadeOut end
    hookFrame:HookScript("OnEnter", function(self) UIFrameFadeIn( frame, fadeIn.time, frame:GetAlpha(), fadeIn.alpha) end)
    hookFrame:HookScript("OnLeave", function(self) UIFrameFadeOut(frame, fadeOut.time, frame:GetAlpha(), fadeOut.alpha) end)
    UIFrameFadeOut(frame, fadeOut.time, frame:GetAlpha(), fadeOut.alpha)
  end