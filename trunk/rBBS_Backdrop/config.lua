  ---------------------------------
  -- INIT
  ---------------------------------
  --get the addon namespace
  local addon, ns = ...
  ns.cfg = {}
  local cfg = ns.cfg

  ---------------------------------
  -- CONFIG
  ---------------------------------

  --chatframe background example
  cfg.bottombar = {
    name        = "BottomBar",    --has to be unique per addon
    width       = 2000,
    height      = 200,
    scale       = 1,
    strata      = "BACKGROUND",  --frame strata
    level       = 0, --frame level
    pos         = { a1="BOTTOM", x=0, y=-20, }, --position
    backdrops   = { --you can overlay different backdrops on top of each other
      [1] = {
        padding   = 0,
        bgFile    = "Interface\\AddOns\\rBBS_Backdrop\\media\\background_gradient.tga", -- gradient background
        bgColor   = { r = 0, g = 0, b = 0, a = 0.9 },                                   -- red, green, blue, alpha
        edgeFile  = "Interface\\AddOns\\rBBS_Backdrop\\media\\glow_outer.tga",          -- outer shadow
        edgeColor = { r = 1, g = 0.5, b = 0, a = 1 },                                   -- red, green, blue, alpha
        tile      = false,
        tileSize  = 32,
        edgeSize  = 10,
        inset     = 10,
      },
      [2] = {
        padding   = 8,
        bgFile    = nil,
        bgColor   = { r = 1, g = 1, b = 1, a = 0 },
        edgeFile  = "Interface\\AddOns\\rBBS_Backdrop\\media\\border_diablo.tga",
        edgeColor   = { r = 1, g = 0.5, b = 0, a = 1 },
        tile      = false,
        tileSize  = 16,
        edgeSize  = 16,
        inset     = 3,
      },
    },
  }

  --chatframe background example
  cfg.chatframe = {
    name        = "ChatFrameBackground",    --has to be unique per addon
    width       = 450,
    height      = 230,
    scale       = 1,
    strata      = "LOW",  --frame strata
    level       = 0, --frame level
    pos         = { a1="BOTTOMLEFT", x=20, y=20, }, --position
    backdrops   = { --you can overlay different backdrops on top of each other
      [1] = {
        padding   = 0,
        bgFile    = "Interface\\AddOns\\rBBS_Backdrop\\media\\background_gradient.tga", -- gradient background
        bgColor   = { r = 0.15, g = 0.15, b = 0.15, a = 0.8 },                          -- red, green, blue, alpha
        edgeFile  = "Interface\\AddOns\\rBBS_Backdrop\\media\\glow_outer.tga",          -- outer shadow
        edgeColor = { r = 0, g = 0, b = 0, a = 1 },                                     -- red, green, blue, alpha
        tile      = false,
        tileSize  = 32,
        edgeSize  = 10,
        inset     = 10,
      },
      [2] = {
        padding   = 8,
        bgFile    = nil,
        bgColor   = { r = 1, g = 1, b = 1, a = 0 },
        edgeFile  = "Interface\\AddOns\\rBBS_Backdrop\\media\\border_diablo.tga",
        edgeColor   = { r = 1, g = 1, b = 1, a = 1 },
        tile      = false,
        tileSize  = 16,
        edgeSize  = 16,
        inset     = 3,
      },
    },
  }

  cfg.dpsmeter = {
    name        = "DpsMeterBackground",    --has to be unique per addon
    width       = 180,
    height      = 230,
    scale       = 1,
    strata      = "LOW",  --frame strata
    level       = 0, --frame level
    pos         = { a1="BOTTOMRIGHT", x=-20, y=20, }, --position
    backdrops   = { --you can overlay different backdrops on top of each other
      [1] = {
        padding   = 0,
        bgFile    = "Interface\\AddOns\\rBBS_Backdrop\\media\\background_gradient.tga", -- gradient background
        bgColor   = { r = 0.1, g = 0.1, b = 0.1, a = 0.8 },                             -- red, green, blue, alpha
        edgeFile  = "Interface\\AddOns\\rBBS_Backdrop\\media\\glow_outer.tga",          -- outer shadow
        edgeColor = { r = 0, g = 0, b = 0, a = 0.8 },                                     -- red, green, blue, alpha
        tile      = false,
        tileSize  = 32,
        edgeSize  = 10,
        inset     = 10,
      },
      [2] = {
        padding   = 10,
        bgFile    = nil,
        bgColor   = nil,
        edgeFile  = "Interface\\AddOns\\rBBS_Backdrop\\media\\glow_inner.tga",
        edgeColor   = { r = 0, g = 0, b = 0, a = 0.6 },
        tile      = false,
        tileSize  = 16,
        edgeSize  = 16,
        inset     = 10,
      },
      [3] = {
        padding   = 8,
        bgFile    = nil,
        bgColor   = nil,
        edgeFile  = "Interface\\AddOns\\rBBS_Backdrop\\media\\border_diablo.tga",
        edgeColor   = { r = 1, g = 1, b = 1, a = 1 },
        tile      = false,
        tileSize  = 16,
        edgeSize  = 9,
        inset     = 3,
      },
    },
  }

  cfg.threatmeter = {
    name        = "ThreatMeterBackground",    --has to be unique per addon
    width       = 180,
    height      = 230,
    scale       = 1,
    strata      = "LOW",  --frame strata
    level       = 0, --frame level
    pos         = { a1="BOTTOMRIGHT", x=-200, y=20, }, --position
    backdrops   = { --you can overlay different backdrops on top of each other
      [1] = {
        padding   = 0,
        bgFile    = "Interface\\AddOns\\rBBS_Backdrop\\media\\background_flat.tga",     -- background
        bgColor   = { r = 0.1, g = 0.1, b = 0.1, a = 0.8 },                             -- red, green, blue, alpha
        edgeFile  = "Interface\\AddOns\\rBBS_Backdrop\\media\\glow_outer.tga",          -- outer shadow
        edgeColor = { r = 0, g = 0, b = 0, a = 0.8 },                                   -- red, green, blue, alpha
        tile      = false,
        tileSize  = 32,
        edgeSize  = 10,
        inset     = 10,
      },
      [2] = {
        padding   = 7,
        bgFile    = nil,
        bgColor   = nil,
        edgeFile  = "Interface\\AddOns\\rBBS_Backdrop\\media\\border_1px.tga",           -- 1px border
        edgeColor = { r = 0.8, g = 0.8, b = 0.8, a = 1 },                                -- red, green, blue, alpha
        tile      = false,
        tileSize  = 16,
        edgeSize  = 16,
        inset     = 0,
      },
    },
  }