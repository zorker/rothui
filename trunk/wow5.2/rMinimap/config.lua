
  -- // rMinimap
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

  cfg.mapcluster = {
    pos             = { a1 = "TOPRIGHT", af = UIParent, a2 = "TOPRIGHT", x = 0, y = 0 },
    userplaced      = true, --want to place the bar somewhere else?
    scale           = 0.82,
  }

  cfg.map = {
    pos             = { a1 = "TOP", x = 10, y = -20 }, --set the position of the minimap inside the minimap cluster
  }

  cfg.clock = { --the clock
    pos             = { a1 = "BOTTOM", af = Minimap, a2 = "BOTTOM", x = 0, y = 0 },
    font            = { size = 12, family = STANDARD_TEXT_FONT, outline = "THINOUTLINE", }
  }

  cfg.calendar = { --calendar button
    size            = 16,
    pos             = { a1 = "CENTER", af = Minimap, a2 = "CENTER", x = 52, y = 52 },
    font            = { size = 12, family = STANDARD_TEXT_FONT, outline = "THINOUTLINE", }
  }

  cfg.mail = {
    size            = 16,
    pos             = { a1 = "CENTER", af = Minimap, a2 = "CENTER", x = 75, y = 0 },
  }

  cfg.tracking = {
    size            = 16,
    pos             = { a1 = "CENTER", af = Minimap, a2 = "CENTER", x = 68, y = 28 },
  }

  cfg.queue = { --queue button
    size            = 16,
    pos             = { a1 = "CENTER", af = Minimap, a2 = "CENTER", x = -52, y = -52 },
  }
