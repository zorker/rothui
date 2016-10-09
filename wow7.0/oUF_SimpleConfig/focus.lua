
-- oUF_SimpleConfig: focus
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Focus Config
-----------------------------

L.C.focus = {
  enabled = true,
  size = {130*L.C.uiscale,26*L.C.uiscale},
  point = {"TOPRIGHT","oUF_SimplePlayer","BOTTOMRIGHT",0*L.C.uiscale,-14*L.C.uiscale},
  scale = 1,
  --healthbar
  healthbar = {
    --health and absorb bar cannot be disabled, they match the size of the frame
    colorTapping = true,
    colorDisconnected = true,
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
      enabled = false,
      size = {26*L.C.uiscale,26*L.C.uiscale},
      point = {"RIGHT","LEFT",-6*L.C.uiscale,0*L.C.uiscale},
    },
  },
  --debuffs
  debuff = {
    point = {"TOPLEFT","oUF_SimpleFocus","BOTTOMLEFT",0,-5},
    num = 5,
    cols = 5,
    size = 18,
    spacing = 5,
    initialAnchor = "TOPLEFT",
    growthX = "RIGHT",
    growthY = "DOWN",
    disableCooldown = true,
  },
}
