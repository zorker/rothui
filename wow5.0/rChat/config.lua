
  -- // rChat
  -- // zork - 2012

  -----------------------------
  -- INIT
  -----------------------------

  --get the addon namespace
  local addon, ns = ...
  local cfg = CreateFrame("Frame")
  ns.cfg = cfg

  -----------------------------
  -- CONFIG
  -----------------------------

  cfg.hideChatTabBackgrounds  = true
  cfg.selectedTabColor        = {1,0.75,0}
  cfg.selectedTabAlpha        = 1
  cfg.notSelectedTabColor     = {0.5,0.5,0.5}
  cfg.notSelectedTabAlpha     = 0.3
