
-- oUF_SimpleConfig: player
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Player Config
-----------------------------

L.C.player = {
  enabled = true,
  size = {265,26},
  point = {"RIGHT",UIParent,"CENTER",-120,-120},
  scale = 1*L.C.globalscale,
  --healthbar
  healthbar = {
    --health and absorb bar cannot be disabled, they match the size of the frame
    colorClass = true,
    colorHealth = true,
    colorThreat = true,
    name = {
      enabled = true,
      points = {
        {"TOPLEFT",2,10},
        {"TOPRIGHT",-2,10},
      },
      size = 17,
      tag = "[resting]",
    },
    health = {
      enabled = true,
      point = {"RIGHT",-2,0},
      size = 16,
      tag = "[oUF_Simple:health]",
    },
  },
  --powerbar
  powerbar = {
    enabled = true,
    size = {265,5},
    point = {"TOP","BOTTOM",0,-4}, --if no relativeTo is given the frame base will be the relativeTo reference
    colorPower = true,
    power = {
      enabled = false,
      point = {"RIGHT",-2,0},
      size = 16,
      tag = "[perpp]",
    },
  },
  --raidmark
  raidmark = {
    enabled = true,
    size = {18,18},
    point = {"CENTER","LEFT",0,0},
  },
  --castbar
  castbar = {
    enabled = true,
    size = {265,26},
    point = {"BOTTOM","TOP",0,14},
    name = {
      enabled = true,
      points = {
        {"LEFT",2,0},
        {"RIGHT",-2,0},
      },
      --font = STANDARD_TEXT_FONT,
      size = 16,
      --outline = "",--OUTLINE",
      --align = "CENTER",
      --noshadow = true,
    },
    icon = {
      enabled = true,
      size = {26,26},
      point = {"RIGHT","LEFT",-6,0},
    },
  },
  --classbar
  classbar = {
    enabled = true,
    size = {130,5},
    point = {"BOTTOMRIGHT","TOPRIGHT",0,4},
    splits = {
      enabled = true,
      texture = L.C.textures.split,
      size = {5,5},
      color = {0,0,0,1}
    },
  },
  --altpowerbar
  altpowerbar = {
    enabled = true,
    size = {130,5},
    point = {"BOTTOMLEFT","TOPLEFT",0,4},
  },
}
