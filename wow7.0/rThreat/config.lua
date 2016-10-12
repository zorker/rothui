
-- rThreat: config
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

--config container
L.C = {}

-----------------------------
-- Config
-----------------------------

-- general settings
L.C.timespan      = 0.1    -- time that has to pass in seconds before a new table will be drawn to prevent spamming in raids
L.C.scale         = 1       -- global scale
L.C.hideOOC       = false   -- true/false hides frame out of combat/without target, otherwise it will be visible all the time
L.C.partyOnly     = false    -- frame will only be available in party/raid (overrides hide setting)
L.C.hideInPVP     = true    -- hide while being in arena / battleground

-- frame position (you can move the frame ingame via "/rthreat")
L.C.frame = {
  pos = { a1 = "LEFT", af = UIParent, a2 = "LEFT", x = 50, y = 0 },
  bg = {
    color = { r = 0, g = 0, b = 0, a = 0.7 },
  },
}

-- backdrop shadow settings
L.C.shadow = {
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

-- threat bar settings
L.C.statusbar = {
  count           = 5,      -- how many statusbars should be created?
  width           = 160,
  height          = 16,
  gap             = 1,      -- gap between bars
  marker          = true,   -- true/false this will mark your statusbar in red color if active
  font = {
    family        = STANDARD_TEXT_FONT,
    size          = 12,
    color         = { r = 1, g = 1, b = 1, a = 1 },
    outline       = "OUTLINE",
  },
  texture         = "Interface\\AddOns\\rThreat\\media\\statusbar",
  color = {
    bar           = { a = 1 },
    bg            = { multiplier = 0.5, a = 0.6 },
    inactive      = { r = 0.5, g = 0.5, b = 0.5, a = 0.1 },
  },
}
