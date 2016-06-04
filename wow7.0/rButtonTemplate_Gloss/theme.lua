
-- rButtonTemplate_Default: theme
-- zork, 2016

-- Default Button Theme for rButtonTemplate

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- mediapath
-----------------------------

local mediapath = "interface\\addons\\"..A.."\\media\\"

-----------------------------
-- actionButtonConfig
-----------------------------

local actionButtonConfig = {}

--backdrop
actionButtonConfig.backdrop = {
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
  file = mediapath.."border",
  points = {
    {"TOPLEFT", -2, 2 },
    {"BOTTOMRIGHT", 2, -2 },
  },
}

--normalTexture
actionButtonConfig.normalTexture = {
  file = mediapath.."normal",
  color = {1,1,1,1},
  points = {
    {"TOPLEFT", 0, 0 },
    {"BOTTOMRIGHT", 0, 0 },
  },
}

--pushedTexture
actionButtonConfig.pushedTexture = {
  file = mediapath.."pushed",
  --color = {1,1,1,1},
  points = {
    {"TOPLEFT", 0, 0 },
    {"BOTTOMRIGHT", 0, 0 },
  },
}

--highlightTexture
actionButtonConfig.highlightTexture = {
  file = mediapath.."highlight",
  --color = {1,1,1,1},
  points = {
    {"TOPLEFT", 0, 0 },
    {"BOTTOMRIGHT", 0, 0 },
  },
}

--checkedTexture
actionButtonConfig.checkedTexture = {
  file = mediapath.."checked",
  --color = {1,1,1,1},
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
  --alpha = 0,
}

--count
actionButtonConfig.count = {
  font = { STANDARD_TEXT_FONT, 11, "OUTLINE"},
  points = {
    {"BOTTOMRIGHT", 0, 0 },
  },
}

-----------------------------
-- rButtonTemplate:StyleAllActionButtons
-----------------------------

rButtonTemplate:StyleAllActionButtons(actionButtonConfig)

-----------------------------
-- itemButtonConfig
-----------------------------

local itemButtonConfig = {}

itemButtonConfig.backdrop = actionButtonConfig.backdrop
itemButtonConfig.icon = actionButtonConfig.icon
itemButtonConfig.count = actionButtonConfig.count
itemButtonConfig.stock = actionButtonConfig.name
itemButtonConfig.border = { file = "" }
itemButtonConfig.normalTexture = actionButtonConfig.normalTexture

-----------------------------
-- rButtonTemplate:StyleItemButton
-----------------------------

local itemButtons = { MainMenuBarBackpackButton, CharacterBag0Slot, CharacterBag1Slot, CharacterBag2Slot, CharacterBag3Slot }
for i, button in next, itemButtons do
  rButtonTemplate:StyleItemButton(button, itemButtonConfig)
end