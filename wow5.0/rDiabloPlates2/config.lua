
  -- // rDiabloPlates2
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

  --nameplate frame
  cfg.frame = {
    width       = 130,
    scale       = 0.7,
    adjust_pos  = { x = 0, y = 0, },
  }
  --healthbar
  cfg.healthbar = {
    lowHpWarning = {
      enable = true,
      treshold = 25,
      color   = { r = 1, g = 0, b = 0 },
    },
    tapped = {
      color   = { r = 0.65, g = 0.65, b = 0.65 },
    },
  }
  --castbar
  cfg.castbar = {
    scale       = 0.7,
    adjust_pos  = { x = 0, y = -17, },
    icon = {
      size = 30,
      pos = { a1 = "LEFT", x = -50, y = 8}
    },
    color = {
      default   = { r = 1, g = 0.6, b = 0 },
      shielded  = { r = 0.8, g = 0.8, b = 0.8 },
    },
  }
  --raidmark
  cfg.raidmark = {
    icon = {
      size = 25,
      pos = { a1 = "CENTER", x = 0, y = 35}
    },
  }
  --name
  cfg.name = {
    enable = true,
    font = STANDARD_TEXT_FONT,
    size = 10,
    outline = "THINOUTLINE",
    pos_1 = { a1 = "LEFT", x = -10, y = 0},
    pos_2 = { a1 = "RIGHT", x = 10, y = 0},
    pos_3 = { a1 = "TOP", x = 0, y = 7},
  }
  --health value
  cfg.hpvalue = {
    enable = false,
    font = STANDARD_TEXT_FONT,
    size = 8,
    outline = "THINOUTLINE",
    pos_1 = { a1 = "RIGHT", x = 0, y = 0},
  }
  --textures
  cfg.textures = {
    bg          = "Interface\\Addons\\rDiabloPlates2\\media\\nameplate_bg",
    bar         = "Interface\\Addons\\rDiabloPlates2\\media\\nameplate_bar",
    threat      = "Interface\\Addons\\rDiabloPlates2\\media\\nameplate_threat",
    highlight   = "Interface\\Addons\\rDiabloPlates2\\media\\nameplate_highlight",
    left        = "Interface\\Addons\\rDiabloPlates2\\media\\nameplate_left",
    right       = "Interface\\Addons\\rDiabloPlates2\\media\\nameplate_right",
    icon_border = "Interface\\Addons\\rDiabloPlates2\\media\\icon_border",
  }
