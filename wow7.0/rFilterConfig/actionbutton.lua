
-- rFilterConfig: actionbutton
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Actionbutton Config
-----------------------------

--mediapath
local mediapath = "interface\\addons\\"..A.."\\media\\"

--time between updates
--L.C.tick = 0.1 --default is 0.1

--actionButtonConfig

--backdrop
L.C.actionButtonConfig.backdrop = {
  bgFile = mediapath.."backdrop",
  edgeFile = mediapath.."backdropBorder",
  tile = false,
  tileSize = 32,
  edgeSize = 5,
  insets = {
    left = 5,
    right = 5,
    top = 5,
    bottom = 5,
  },
  backgroundColor = {0.1,0.1,0.1,0.8},
  borderColor = {0,0,0,1},
  points = {
    {"TOPLEFT", -3, 3 },
    {"BOTTOMRIGHT", 3, -3 },
  },
}

--icon
L.C.actionButtonConfig.icon = {
  texCoord = {0.1,0.9,0.1,0.9},
  points = {
    {"TOPLEFT", 1, -1 },
    {"BOTTOMRIGHT", -1, 1 },
  },
}

--border
L.C.actionButtonConfig.border = {
  file = mediapath.."border",
  points = {
    {"TOPLEFT", -2, 2 },
    {"BOTTOMRIGHT", 2, -2 },
  },
}

--normalTexture
L.C.actionButtonConfig.normalTexture = {
  file = mediapath.."normal",
  color = {0.5,0.5,0.5,0.7},
  points = {
    {"TOPLEFT", 0, 0 },
    {"BOTTOMRIGHT", 0, 0 },
  },
}

--cooldown
L.C.actionButtonConfig.cooldown = {
  points = {
    {"TOPLEFT", 0, 0 },
    {"BOTTOMRIGHT", 0, 0 },
  },
}

--name, we use the default actionbutton.name fontstring and use it as our duration fontstring
L.C.actionButtonConfig.name = {
  font = { STANDARD_TEXT_FONT, 13, "OUTLINE"},
  points = {
    {"LEFT", 0, 0 },
    {"RIGHT", 0, 0 },
  },
  halign = "CENTER",
  valign = "MIDDLE",
}

--hotkey, we use the default actionbutton.hotkey fontstring and use it as our extra value fontstring (100k absorb shield etc.)
L.C.actionButtonConfig.hotkey = {
  font = { STANDARD_TEXT_FONT, 11, "OUTLINE"},
  points = {
    {"TOPRIGHT", 0, 0 },
    {"BOTTOMLEFT", 0, 0 },
  },
  halign = "RIGHT",
  valign = "TOP",
}

--count, aura stack count
L.C.actionButtonConfig.count = {
  font = { STANDARD_TEXT_FONT, 11, "OUTLINE"},
  points = {
    {"BOTTOMRIGHT", 0, 0 },
    {"BOTTOMLEFT", 0, 0 },
  },
  halign = "RIGHT",
  valign = "BOTTOM",
}