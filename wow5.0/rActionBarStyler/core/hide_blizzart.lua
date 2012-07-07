
  -----------------------------
  -- INIT
  -----------------------------

  --get the addon namespace
  local addon, ns = ...
  local gcfg = ns.cfg

  -----------------------------
  -- STUFF
  -----------------------------

  --hide blizzard
  local blizzHider = CreateFrame("Frame","rABS_BizzardHider")
  blizzHider:Hide()
  MainMenuBar:SetParent(rABS_BizzardHider)
  OverrideActionBarExpBar:SetParent(blizzHider)
  OverrideActionBarHealthBar:SetParent(blizzHider)
  OverrideActionBarPowerBar:SetParent(blizzHider)

  --remove the default background texture on the stance bar frame
  StanceBarLeft:SetTexture(nil)
  StanceBarMiddle:SetTexture(nil)
  StanceBarRight:SetTexture(nil)
  SlidingActionBarTexture0:SetTexture(nil)
  SlidingActionBarTexture1:SetTexture(nil)

  --remove OverrideBar textures
  local textureList =  {
    "_BG",
    "EndCapL",
    "EndCapR",
    "_Boader",
    "Divider1",
    "Divider2",
    "Divider3",
    "ExitBG",
    "MicroBGL",
    "MicroBGR",
    "_MicroBGMid",
    "ButtonBGL",
    "ButtonBGR",
    "_ButtonBGMid",
    "PitchOverlay",
    "PitchButtonBG",
    "PitchBG",
    "PitchMarker",
    "PitchUpUp",
    "PitchUpDown",
    "PitchUpHighlight",
    "PitchDownUp",
    "PitchDownDown",
    "PitchDownHighlight",
    --"LeaveUp",
    --"LeaveDown",
    --"LeaveHighlight",
    "HealthBarBG",
    "HealthBarOverlay",
    "PowerBarBG",
    "PowerBarOverlay",
  };
  local xpBarTextureList = {
    "XpMid",
    "XpL",
    "XpR",
  }

  for _,tex in pairs(textureList) do
    OverrideActionBar[tex]:SetAlpha(0)
  end
  for _,tex in pairs(xpBarTextureList) do
    OverrideActionBar.xpBar[tex]:SetAlpha(0)
  end