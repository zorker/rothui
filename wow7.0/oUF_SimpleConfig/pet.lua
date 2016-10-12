
-- oUF_SimpleConfig: pet
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Pet Config
-----------------------------

L.C.pet = {
  enabled = true,
  size = {130,26},
  point = {"TOPLEFT","oUF_SimplePlayer","BOTTOMLEFT",0,-14},
  scale = 1*L.C.globalscale,
  --healthbar
  healthbar = {
    --health and absorb bar cannot be disabled, they match the size of the frame
    colorReaction = true,
    colorClass = true,
    colorHealth = true,
    colorThreat = true,
    name = {
      enabled = true,
      points = {
        {"LEFT",2,0},
        {"RIGHT",-2,0},
      },
      size = 16,
      align = "CENTER",
      tag = "[name]",
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
    size = {130,26},
    point = {"TOP","BOTTOM",0,-5},
    name = {
      enabled = true,
      points = {
        {"LEFT",2,0},
        {"RIGHT",-2,0},
      },
      size = 16,
    },
    icon = {
      enabled = true,
      size = {26,26},
      point = {"RIGHT","LEFT",-6,0},
    },
  },
  --altpowerbar (for vehicles)
  altpowerbar = {
    enabled = true,
    size = {130,5},
    point = {"BOTTOMLEFT","oUF_SimplePlayer","TOPLEFT",0,4},
  },
  --debuffs
  debuffs = {
    enabled = true,
    point = {"TOPLEFT","BOTTOMLEFT",0,-5},
    num = 5,
    cols = 5,
    size = 22,
    spacing = 5,
    initialAnchor = "TOPLEFT",
    growthX = "RIGHT",
    growthY = "DOWN",
    disableCooldown = true,
  },
}
