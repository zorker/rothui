
-- rButtonTemplate_Zork: theme
-- zork, 2019

-- Zork's Button Theme for rButtonTemplate

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- mediapath
-----------------------------

local mediapath = "interface\\addons\\"..A.."\\media\\"
local CopyTable = rLib.CopyTable

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
  backgroundColor = {0.1,0.1,0.1,0.7},
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
  file = _G["ActionButton1Border"]:GetTexture(),
  blendMode = "ADD",
  sizeFactor = 1.8,
  texCoord = {0,1,0,1},
}

--normalTexture
actionButtonConfig.normalTexture = {
  file = mediapath.."normal",
  color = {0.4,0.4,0.4,0.25},
  points = {
    {"TOPLEFT", 0, 0 },
    {"BOTTOMRIGHT", 0, 0 },
  },
}

--[[
--pushedTexture
actionButtonConfig.pushedTexture = {
  file = mediapath.."pushed",
  points = {
    {"TOPLEFT", 0, 0 },
    {"BOTTOMRIGHT", 0, 0 },
  },
}
--highlightTexture
actionButtonConfig.highlightTexture = {
  file = mediapath.."highlight",
  points = {
    {"TOPLEFT", 0, 0 },
    {"BOTTOMRIGHT", 0, 0 },
  },
}
--checkedTexture
actionButtonConfig.checkedTexture = {
  file = mediapath.."checked",
  points = {
    {"TOPLEFT", 0, 0 },
    {"BOTTOMRIGHT", 0, 0 },
  },
}
]]--

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
  alpha = 0,
}

--hotkey
actionButtonConfig.hotkey = {
  font = { STANDARD_TEXT_FONT, 11, "OUTLINE"},
  points = {
    {"TOPRIGHT", 0, 0 },
    {"TOPLEFT", 0, 0 },
  },
  alpha = 0,
}

--count
actionButtonConfig.count = {
  font = { STANDARD_TEXT_FONT, 11, "OUTLINE"},
  points = {
    {"BOTTOMRIGHT", 0, 0 },
  },
}

--rButtonTemplate:StyleAllActionButtons
rButtonTemplate:StyleAllActionButtons(actionButtonConfig)
rButtonTemplate:StyleActionButton("rActionBarVehicleExitButton",actionButtonConfig)

-----------------------------
-- itemButtonConfig
-----------------------------

local itemButtonConfig = {}

itemButtonConfig.backdrop = CopyTable(actionButtonConfig.backdrop)
itemButtonConfig.icon = CopyTable(actionButtonConfig.icon)
itemButtonConfig.count = CopyTable(actionButtonConfig.count)
itemButtonConfig.stock = CopyTable(actionButtonConfig.name)
itemButtonConfig.stock.alpha = 1
itemButtonConfig.border = CopyTable(actionButtonConfig.border)
itemButtonConfig.normalTexture = CopyTable(actionButtonConfig.normalTexture)

--rButtonTemplate:StyleItemButton
local itemButtons = { "MainMenuBarBackpackButton", "CharacterBag0Slot", "CharacterBag1Slot", "CharacterBag2Slot", "CharacterBag3Slot" }
for i, buttonName in next, itemButtons do
  rButtonTemplate:StyleItemButton(buttonName, itemButtonConfig)
end

-----------------------------
-- auraButtonConfig
-----------------------------

local auraButtonConfig = {}

auraButtonConfig.backdrop = CopyTable(actionButtonConfig.backdrop)
auraButtonConfig.icon = CopyTable(actionButtonConfig.icon)
auraButtonConfig.border = CopyTable(actionButtonConfig.border)
auraButtonConfig.normalTexture = CopyTable(actionButtonConfig.normalTexture)
auraButtonConfig.count = CopyTable(actionButtonConfig.count)
auraButtonConfig.duration = CopyTable(actionButtonConfig.hotkey)
auraButtonConfig.duration.alpha = 1
auraButtonConfig.symbol = CopyTable(actionButtonConfig.name)
auraButtonConfig.symbol.alpha = 1

--rButtonTemplate:StyleBuffButtons + rButtonTemplate:StyleTempEnchants
rButtonTemplate:StyleBuffButtons(auraButtonConfig)
rButtonTemplate:StyleTempEnchants(auraButtonConfig)

-----------------------------
-- debuffButtonConfig
-----------------------------

local debuffButtonConfig = CopyTable(auraButtonConfig)
--change the font sizes a bit
debuffButtonConfig.count.font = { STANDARD_TEXT_FONT, 12.5, "OUTLINE"}
debuffButtonConfig.duration.font = { STANDARD_TEXT_FONT, 12.5, "OUTLINE"}

--rButtonTemplate:StyleDebuffButtons
rButtonTemplate:StyleDebuffButtons(debuffButtonConfig)
