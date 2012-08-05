
  -- // rInfostrings
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

  cfg.frame = {
    scale           = 0.95,
    pos             = { a1 = "TOP", af = Minimap, a2 = "BOTTOM", x = 0, y = -15 },
    userplaced      = true, --want to place the bar somewhere else?
  }

  cfg.showXpRep     = true --show xp or reputation as string
  cfg.showMail      = true --show mail as text