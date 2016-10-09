
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
  size = {130*L.C.uiscale,26*L.C.uiscale},
  point = {"TOPLEFT","oUF_SimplePlayer","BOTTOMLEFT",0*L.C.uiscale,-14*L.C.uiscale},
  scale = 1,
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
        {"LEFT",2*L.C.uiscale,0*L.C.uiscale},
        {"RIGHT",-2*L.C.uiscale,0*L.C.uiscale},
      },
      size = 16*L.C.uiscale,
      align = "CENTER",
      tag = "[name]",
    },
  },
  --castbar
  castbar = {
    enabled = true,
    size = {130*L.C.uiscale,26*L.C.uiscale},
    point = {"TOP","BOTTOM",0*L.C.uiscale,-5*L.C.uiscale},
    name = {
      enabled = true,
      points = {
        {"LEFT",2*L.C.uiscale,0*L.C.uiscale},
        {"RIGHT",-2*L.C.uiscale,0*L.C.uiscale},
      },
      size = 16*L.C.uiscale,
    },
    icon = {
      enabled = true,
      size = {26*L.C.uiscale,26*L.C.uiscale},
      point = {"RIGHT","LEFT",-6*L.C.uiscale,0*L.C.uiscale},
    },
  },
  --altpowerbar (for vehicles)
  altpowerbar = {
    enabled = true,
    size = {130*L.C.uiscale,5*L.C.uiscale},
    point = {"BOTTOMLEFT","oUF_SimplePlayer","TOPLEFT",0*L.C.uiscale,4*L.C.uiscale},
  },
  --debuffs
  debuffs = {
    enabled = true,
    point = {"TOPLEFT","BOTTOMLEFT",0*L.C.uiscale,-5*L.C.uiscale},
    num = 5,
    cols = 5,
    size = 22*L.C.uiscale,
    spacing = 5*L.C.uiscale,
    initialAnchor = "TOPLEFT",
    growthX = "RIGHT",
    growthY = "DOWN",
    disableCooldown = true,
  },
}
