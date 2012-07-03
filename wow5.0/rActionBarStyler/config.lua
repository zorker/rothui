
  -- // rActionBarStyler
  -- // zork - 2012

  -----------------------------
  -- INIT
  -----------------------------

  --get the addon namespace
  local cfg = CreateFrame("Frame")
  local addon, ns = ...
  ns.cfg = cfg

  -----------------------------
  -- CONFIG
  -----------------------------

  --use "/rabs" to see the command list

  cfg.bars = {
    micromenu = {
      enable          = true,
      scale           = 0.82,
      padding         = 10, --frame padding
      pos             = { a1 = "TOP", a2 = "TOP", af = "UIParent", x = 0, y = 10 },
      mouseover = {
        enable        = true,
        fadeIn        = {time = 0.4, alpha = 1},
        fadeOut       = {time = 0.3, alpha = 0},
      },
    },
  }
