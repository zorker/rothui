
-- rTooltip: config
-- zork, 2019

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Config
-----------------------------

L.C = {
  textColor = {0.4,0.4,0.4},
  bossColor = {1,0,0},
  eliteColor = {1,0,0.5},
  rareeliteColor = {1,0.5,0},
  rareColor = {1,0.5,0},
  levelColor = {0.8,0.8,0.5},
  deadColor = {0.5,0.5,0.5},
  targetColor = {1,0.5,0.5},
  guildColor = {1,0,1},
  afkColor = {0,1,1},
  scale = 0.95,
  fontFamily = STANDARD_TEXT_FONT,
  backdrop = {
    bgFile = "Interface\\Buttons\\WHITE8x8",
    bgColor = {0.08,0.08,0.1,0.92},
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    borderColor = {0.1,0.1,0.1,0.6},
    itemBorderColorAlpha = 0.9,
    tile = false,
    tileEdge = false,
    tileSize = 16,
    edgeSize = 16,
    insets = {left=3, right=3, top=3, bottom=3}
  },
  --pos can be either a point table or a anchor string
  pos = { "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -86, 45 }
  --pos = "ANCHOR_NONE" --"ANCHOR_CURSOR"
}
