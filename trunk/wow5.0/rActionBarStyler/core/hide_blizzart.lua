
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
  MainMenuBar:SetParent(blizzHider)
  OverrideActionBarExpBar:SetParent(blizzHider)
  OverrideActionBarHealthBar:SetParent(blizzHider)
  OverrideActionBarPowerBar:SetParent(blizzHider)
  OverrideActionBarPitchFrame:SetParent(blizzHider) --maybe we can use that frame later for pitchig and such

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
  }

  for _,tex in pairs(textureList) do
    OverrideActionBar[tex]:SetAlpha(0)
  end
