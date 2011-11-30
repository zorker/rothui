
  -- // rThreat
  -- // zork - 2011

  --get the addon namespace
  local addon, ns = ...

  --object container
  local cfg = CreateFrame("Frame")

  -----------------------------
  -- CONFIG
  -----------------------------

  -- general settings
  cfg.timespan      = 0.1    -- time that has to pass in seconds before a new table will be drawn to prevent spamming in raids
  cfg.scale         = 1       -- global scale
  cfg.hide          = true   -- true/false hides frame out of combat/without target, otherwise it will be visible all the time
  cfg.partyonly     = true    -- frame will only be available in party/raid (overrides hide setting)

  -- frame position (you can move the frame ingame via "/rthreat")
  cfg.position = {
    coord           = { a1 = "LEFT", af = UIParent, a2 = "LEFT", x = 50, y = 0 }, -- default position
    userplaced      = true,   -- want to place the bar somewhere else?
    locked          = true,   -- frame locked, can be unlocked ingame via /rthreat
  }

  -- backdrop shadow settings
  cfg.shadow = {
    show            = true,
    bgFile          = nil,    -- "Interface\\AddOns\\rThreat\\background",
    bgColor         = { r = 0.15, g = 0.8, b = 1, a = 0.2 },
    edgeFile        = "Interface\\AddOns\\rThreat\\media\\shadow",
    edgeColor       = { r = 0, g = 0, b = 0, a = 1 },
    tile            = false,
    tileSize        = 32,
    edgeSize        = 4,
    inset           = 4,
  }

  -- border settings
  cfg.border = {
    show            = true,
    bgFile          = nil,    -- "Interface\\AddOns\\rThreat\\background",
    bgColor         = { r = 0, g = 0, b = 0, a = 0.5 },
    edgeFile        = "Interface\\AddOns\\rThreat\\media\\border",
    edgeColor       = { r = 1, g = 1, b = 1, a = 1 },
    tile            = false,
    tileSize        = 16,
    edgeSize        = 8,
    inset           = 2,
  }

  -- title bar settings
  cfg.title = {
    show            = false,   -- true/false to enable/disable the title frame
    width           = 160,
    height          = 14,
    gap             = 10,     -- gap between title and statusbar container
    font = {
      font          = "Fonts\\FRIZQT__.ttf",
      size          = 12,
      color         = { r = 1, g = 0.8, b = 0, a = 1 },
      outline       = "THINOUTLINE",
    },
    bg = {
      texture       = "Interface\\AddOns\\rThreat\\media\\statusbar",
      color         = { r = 0.2, g = 0.2, b = 0.2, a = 0.8 },
    },
  }

  -- threat bar settings
  cfg.statusbars = {
    count           = 5,      -- how many statusbars should be created?
    width           = 160,
    height          = 14,
    gap             = 1,      -- gap between bars
    marker          = true,   -- true/false this will mark your statusbar in red color if active
    font = {
      font          = "Fonts\\FRIZQT__.ttf",
      size          = 11,
      color         = { r = 1, g = 1, b = 1, a = 1 },
      outline       = "THINOUTLINE",
    },
    bg = {
      texture       = "Interface\\AddOns\\rThreat\\media\\statusbar",
      color         = { r = 0, g = 0, b = 0, a = 0.7 },
    },
    texture = {
      texture       = "Interface\\AddOns\\rThreat\\media\\statusbar",
      multiplier    = 0.5,    -- multiplier allows darker background colors
      alpha         = { background = 0.6, foreground = 1},
    },
    inactive = {
      color         = { r = 0.5, g = 0.5, b = 0.5, a = 0.1 },
    },
  }


  -----------------------------
  -- HANDOVER
  -----------------------------

  --object container to addon namespace
  ns.cfg = cfg