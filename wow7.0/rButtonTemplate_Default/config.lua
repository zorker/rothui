
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

-----------------------------
-- actionButtonConfig
-----------------------------

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

--border
actionButtonConfig.border = {
  file = mediapath.."border.tga",
  points = {
    {"TOPLEFT", -2, 2 },
    {"BOTTOMRIGHT", 2, -2 },
  },
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

--cooldown
actionButtonConfig.cooldown = {
  points = {
    {"TOPLEFT", 0, 0 },
    {"BOTTOMRIGHT", 0, 0 },
  },
}

--name (macro name fontstring)
actionButtonConfig.name = {
  font = { STANDARD_TEXT_FONT, 10, "OUTLINE"},
  points = {
    {"BOTTOMLEFT", 0, 0 },
    {"BOTTOMRIGHT", 0, 0 },
  },
}

--hotkey
actionButtonConfig.hotkey = {
  font = { STANDARD_TEXT_FONT, 11, "OUTLINE"},
  points = {
    {"TOPRIGHT", 0, 0 },
    {"TOPLEFT", 0, 0 },
  },
}

--count
actionButtonConfig.count = {
  font = { STANDARD_TEXT_FONT, 11, "OUTLINE"},
  points = {
    {"BOTTOMRIGHT", 0, 0 },
  },
}

-----------------------------
-- itemButtonConfig
-----------------------------

local itemButtonConfig = {}

itemButtonConfig.backdrop = actionButtonConfig.backdrop
itemButtonConfig.icon = actionButtonConfig.icon
itemButtonConfig.count = actionButtonConfig.count
itemButtonConfig.stock = actionButtonConfig.name
itemButtonConfig.border = actionButtonConfig.border
itemButtonConfig.border.file = ""
itemButtonConfig.normalTexture = actionButtonConfig.normalTexture

-----------------------------
-- Init
-----------------------------

--use L:StyleAllActionButtons to style all action buttons
L:StyleAllActionButtons(actionButtonConfig)

--use L:StyleItemButton to style specific item buttons
local itemButtons = { MainMenuBarBackpackButton, CharacterBag0Slot, CharacterBag1Slot, CharacterBag2Slot, CharacterBag3Slot }
for i, button in next, itemButtons do
  L:StyleItemButton(button, itemButtonConfig)
end