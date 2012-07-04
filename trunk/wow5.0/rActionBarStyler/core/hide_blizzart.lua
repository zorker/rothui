
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
  local blizzHider = CreateFrame("Frame")
  blizzHider:Hide()
  MainMenuBar:SetParent(blizzHider)
  PossessBarFrame:SetParent(blizzHider)

  --remove the default background texture on the stance bar frame
  StanceBarLeft:SetTexture(nil)
  StanceBarMiddle:SetTexture(nil)
  StanceBarRight:SetTexture(nil)