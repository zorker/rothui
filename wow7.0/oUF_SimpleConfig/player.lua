
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
  size = {265*L.C.uiscale,26*L.C.uiscale},
  point = {"RIGHT",UIParent,"CENTER",-120*L.C.uiscale,-120*L.C.uiscale},
  scale = 1,
  --healthbar
  healthbar = {
    --health and absorb bar cannot be disabled, they match the size of the frame
    colorClass = true,
    colorHealth = true,
    colorThreat = true,
    name = {
      enabled = false,
      points = {
        {"LEFT",2*L.C.uiscale,0*L.C.uiscale},
        {"RIGHT",-135*L.C.uiscale,0*L.C.uiscale},
      },
      size = 18*L.C.uiscale,
      tag = "[name]",
    },
    health = {
      enabled = true,
      point = {"RIGHT",-2*L.C.uiscale,0*L.C.uiscale},
      size = 16*L.C.uiscale,
      tag = "[oUF_Simple:health]",
    },
  },
  --powerbar
  powerbar = {
    enabled = true,
    size = {265*L.C.uiscale,5*L.C.uiscale},
    point = {"TOP","BOTTOM",0*L.C.uiscale,-4*L.C.uiscale}, --if no relativeTo is given the frame base will be the relativeTo reference
    colorPower = true,
    power = {
      enabled = false,
      point = {"RIGHT",-2*L.C.uiscale,0*L.C.uiscale},
      size = 16*L.C.uiscale,
      tag = "[perpp]",
    },
  },
  --raidmark
  raidmark = {
    enabled = true,
    size = {18*L.C.uiscale,18*L.C.uiscale},
    point = {"CENTER","LEFT",0,0},
  },
  --castbar
  castbar = {
    enabled = true,
    size = {265*L.C.uiscale,26*L.C.uiscale},
    point = {"BOTTOM","TOP",0*L.C.uiscale,14*L.C.uiscale},
    name = {
      enabled = true,
      points = {
        {"LEFT",2*L.C.uiscale,0*L.C.uiscale},
        {"RIGHT",-2*L.C.uiscale,0*L.C.uiscale},
      },
      --font = STANDARD_TEXT_FONT,
      size = 16*L.C.uiscale,
      --outline = "",--OUTLINE",
      --align = "CENTER",
      --noshadow = true,
    },
    icon = {
      enabled = true,
      size = {26*L.C.uiscale,26*L.C.uiscale},
      point = {"RIGHT","LEFT",-6*L.C.uiscale,0*L.C.uiscale},
    },
  },
  --classbar
  classbar = {
    enabled = true,
    size = {130*L.C.uiscale,5*L.C.uiscale},
    point = {"BOTTOMRIGHT","TOPRIGHT",0*L.C.uiscale,4*L.C.uiscale},
  },
  --altpowerbar
  altpowerbar = {
    enabled = true,
    size = {130*L.C.uiscale,5*L.C.uiscale},
    point = {"BOTTOMLEFT","TOPLEFT",0*L.C.uiscale,4*L.C.uiscale},
  },
}
