
-- oUF_SimpleConfig: boss
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Boss Config
-----------------------------

L.C.boss = {
  enabled = true,
  size = {130*L.C.uiscale,26*L.C.uiscale},
  point = {"TOP",Minimap,"BOTTOM",0,-35*L.C.uiscale}, --point of first boss frame
  scale = 1,
  --healthbar
  healthbar = {
    --health and absorb bar cannot be disabled, they match the size of the frame
    colorReaction = true,
    colorClass = true,
    colorHealth = true,
    frequentUpdates = true,
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
  debuffCfg = {
    point = {"TOPLEFT",0,-32}, --this may seem wierd but party frames are generated on the fly, no other way
    num = 5,
    cols = 5,
    size = 18,
    spacing = 5,
    initialAnchor = "TOPLEFT",
    growthX = "RIGHT",
    growthY = "DOWN",
    disableCooldown = true,
  },
  setup = {
    point = "TOP",
    relativePoint = "BOTTOM", --relativeTo will be the boss frame preceding
    xOffset = 0*L.C.uiscale,
    yOffset = -45*L.C.uiscale,
  },
}
