
-- rActionBar: themes/default/config
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Config
-----------------------------

local mediapath = "interface\\addons\\"..A.."\\themes\\default\\media\\"

local actionButtonConfig = {}

--backdrop
actionButtonConfig.backdrop = {
  bgFile = mediapath.."backdrop.tga",
  edgeFile = mediapath.."backdropBorder.tga",
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
actionButtonConfig.icon = {
  texCoord = {0.1,0.9,0.1,0.9},
  points = {
    {"TOPLEFT", 1, -1 },
    {"BOTTOMRIGHT", -1, 1 },
  },
}

--flyoutBorder
actionButtonConfig.flyoutBorder = {
  file = ""
}

--flyoutBorderShadow
actionButtonConfig.flyoutBorderShadow = {
  file = ""
}

--normalTexture
actionButtonConfig.normalTexture = {
  file = mediapath.."normal.tga",
  color = {0.5,0.5,0.5,0.6},
  points = {
    {"TOPLEFT", 0, 0 },
    {"BOTTOMRIGHT", 0, 0 },
  },
}

-----------------------------
-- Init
-----------------------------

L:StyleAllActionButtons(actionButtonConfig)