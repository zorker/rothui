
  -- // rThreat
  -- // zork - 2011

  --get the addon namespace
  local addon, ns = ...
  
  --object container
  local cfg = CreateFrame("Frame") 
  
  -----------------------------
  -- CONFIG
  -----------------------------  

  cfg.timespan = 0.25 -- time that has to pass in seconds before a new table will be drawn to prevent spamming in raids  
  cfg.scale = 1       -- global scale  
  cfg.hide = false    -- true/false should the frame be hidden out of combat/without target etc
  cfg.partyonly = true --frame will only be available in party/raid
  
  cfg.position {
    coord           = { a1 = "CENTER", af = UIParent, a2 = "CENTER", x = 0, y = 0 }, --default position
    userplaced      = true, --want to place the bar somewhere else?
    locked          = true, --frame locked, can be unlocked ingame via /rthreat
  }

  cfg.shadow = {
    show      = true,
    bgFile    = nil, --"Interface\\AddOns\\rThreat\\background",
    bgColor   = { r = 0.15, g = 0.8, b = 1, a = 0.2 },
    edgeFile  = "Interface\\AddOns\\rThreat\\media\\shadow",
    edgeColor = { r = 0, g = 0, b = 0, a = 1 },
    tile      = false,
    tileSize  = 32, 
    edgeSize  = 4, 
    inset     = 4,  
  }

  cfg.border = {
    show      = true,
    bgFile    = nil, --"Interface\\AddOns\\rThreat\\background",
    bgColor   = { r = 0, g = 0, b = 0, a = 0.5 },
    edgeFile  = "Interface\\AddOns\\rThreat\\media\\border",
    edgeColor = { r = 1, g = 1, b = 1, a = 1 },
    tile      = false,
    tileSize  = 16, 
    edgeSize  = 8, 
    inset     = 2, 
  }

  cfg.title = {
    show      = true, --true/false to enable/disable the title frame
    width     = 200,
    height    = 16,
    gap       = 10, --gap between title and statusbar container
    font =  {
      font      = "Fonts\\FRIZQT__.ttf",
      size      = 14,
      color     = { r = 1, g = 0.8, b = 0, a = 1 },
      outline   = "THINOUTLINE",
    },
    bg = {
      texture   = "Interface\\AddOns\\rThreat\\media\\statusbar",
      color     = { r = 0.2, g = 0.2, b = 0.2, a = 0.8 },
    },    
  }

  cfg.statusbars = {
    count     = 6, --how many statusbars should be created?
    width     = 200,
    height    = 16,
    gap       = 1, --gap between bars
    marker    = true, --true/false this will mark your statusbar in red color if active
    font =  {
      font      = "Fonts\\FRIZQT__.ttf",
      size      = 12,
      color     = { r = 1, g = 1, b = 1, a = 1 },
      outline   = "THINOUTLINE",
    },
    bg = {
      texture   = "Interface\\AddOns\\rThreat\\media\\statusbar",
      color     = { r = 0, g = 0, b = 0, a = 0.7 },
    }, 
    texture = {
      texture   = "Interface\\AddOns\\rThreat\\media\\statusbar",
      multiplier = 0.2,  --multiplier allows darker background colors
      alpha     = { background = 0.9, foreground = 1},
    },
    inactive = {
      color     = { r = 0.5, g = 0.5, b = 0.5, a = 0.1 },
    },    
  }

  
  -----------------------------
  -- HANDOVER
  -----------------------------
  
  --object container to addon namespace
  ns.cfg = cfg