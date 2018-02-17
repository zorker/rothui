
-- rButtonTemplate_Zork: theme
-- zork, 2016

-- Zork's Button Theme for rButtonTemplate

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- mediapath
-----------------------------

local mediapath = "interface\\addons\\"..A.."\\media\\"

-----------------------------
-- copyTable
-----------------------------

local function copyTable(orig)
  local orig_type = type(orig)
  local copy
  if orig_type == 'table' then
    copy = {}
    for orig_key, orig_value in next, orig, nil do
      copy[copyTable(orig_key)] = copyTable(orig_value)
    end
    setmetatable(copy, copyTable(getmetatable(orig)))
  else -- number, string, boolean, etc
    copy = orig
  end
  return copy
end

-----------------------------
-- actionButtonConfig
-----------------------------

local actionButtonConfig = {}
--make it global
rButtonTemplate_Zork_ActionButtonConfig = actionButtonConfig

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
  file = _G["ActionButton1Border"]:GetTexture(),
  blendMode = "ADD",
  sizeFactor = 1.8,
  texCoord = {0,1,0,1},
}

--normalTexture
actionButtonConfig.normalTexture = {
  file = mediapath.."normal",
  color = {0.5,0.5,0.5,0.7},
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
--style rActionBar vehicle exit button
rButtonTemplate:StyleActionButton(_G["rActionBarVehicleExitButton"],actionButtonConfig)

-----------------------------
-- itemButtonConfig
-----------------------------

local itemButtonConfig = {}

itemButtonConfig.backdrop = copyTable(actionButtonConfig.backdrop)
itemButtonConfig.icon = copyTable(actionButtonConfig.icon)
itemButtonConfig.count = copyTable(actionButtonConfig.count)
itemButtonConfig.stock = copyTable(actionButtonConfig.name)
itemButtonConfig.stock.alpha = 1
itemButtonConfig.border = copyTable(actionButtonConfig.border)
itemButtonConfig.normalTexture = copyTable(actionButtonConfig.normalTexture)

--rButtonTemplate:StyleItemButton
local itemButtons = { MainMenuBarBackpackButton, CharacterBag0Slot, CharacterBag1Slot, CharacterBag2Slot, CharacterBag3Slot }
for i, button in next, itemButtons do
  rButtonTemplate:StyleItemButton(button, itemButtonConfig)
end

-----------------------------
-- extraButtonConfig
-----------------------------

local extraButtonConfig = copyTable(actionButtonConfig)
extraButtonConfig.buttonstyle = { file = "" }

--rButtonTemplate:StyleExtraActionButton
rButtonTemplate:StyleExtraActionButton(extraButtonConfig)

-----------------------------
-- auraButtonConfig
-----------------------------

local auraButtonConfig = {}

auraButtonConfig.backdrop = copyTable(actionButtonConfig.backdrop)
auraButtonConfig.icon = copyTable(actionButtonConfig.icon)
auraButtonConfig.border = copyTable(actionButtonConfig.border)
auraButtonConfig.normalTexture = copyTable(actionButtonConfig.normalTexture)
auraButtonConfig.count = copyTable(actionButtonConfig.count)
auraButtonConfig.duration = copyTable(actionButtonConfig.hotkey)
auraButtonConfig.duration.alpha = 1
auraButtonConfig.symbol = copyTable(actionButtonConfig.name)
auraButtonConfig.symbol.alpha = 1

--rButtonTemplate:StyleBuffButtons + rButtonTemplate:StyleTempEnchants
rButtonTemplate:StyleBuffButtons(auraButtonConfig)
rButtonTemplate:StyleTempEnchants(auraButtonConfig)

-----------------------------
-- debuffButtonConfig
-----------------------------

local debuffButtonConfig = copyTable(auraButtonConfig)
--change the font sizes a bit
debuffButtonConfig.count.font = { STANDARD_TEXT_FONT, 12.5, "OUTLINE"}
debuffButtonConfig.duration.font = { STANDARD_TEXT_FONT, 12.5, "OUTLINE"}

--rButtonTemplate:StyleDebuffButtons
rButtonTemplate:StyleDebuffButtons(debuffButtonConfig)
