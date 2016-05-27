
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

local actionButtonConfig = {
  iconTexCoord = {0.1,0.9,0.1,0.9},
  iconPoints = {
    {"TOPLEFT", 1, -1 },
    {"BOTTOMRIGHT", -1, 1 },
  },
  normalTextureFile = mediapath.."normal.tga",
  backdropColor = {0.1,0.1,0.1,1},
  backdropBorderColor = {0,0,0,1},
  backdropPoints = {
    {"TOPLEFT", -3, 3 },
    {"BOTTOMRIGHT", 3, -3 },
  },
}

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
}

-----------------------------
-- Init
-----------------------------

L:StyleAllActionButtons(actionButtonConfig)