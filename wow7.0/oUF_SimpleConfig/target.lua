
-- oUF_SimpleConfig: target
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Target Config
-----------------------------

L.C.target = {
  enabled = true,
  size = {265*L.C.uiscale,26*L.C.uiscale},
  point = {"LEFT",UIParent,"CENTER",120*L.C.uiscale,-120*L.C.uiscale},
  scale = 1,
  --healthbar
  healthbar = {
    --health and absorb bar cannot be disabled, they match the size of the frame
    colorTapping = true,
    colorDisconnected = true,
    colorClass = true,
    colorReaction = true,
    colorHealth = true,
    colorThreat = true,
    colorThreatInvers = true,
    name = {
      enabled = true,
      points = {
        {"TOPLEFT",2*L.C.uiscale,10*L.C.uiscale},
        {"TOPRIGHT",-2*L.C.uiscale,10*L.C.uiscale},
      },
      size = 16*L.C.uiscale,
      tag = "[difficulty][name]|r",
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
  buffs = {
    enabled = true,
    point = {"BOTTOMLEFT","RIGHT",10*L.C.uiscale,5*L.C.uiscale},
    num = 32,
    cols = 8,
    size = 22*L.C.uiscale,
    spacing = 5*L.C.uiscale,
    initialAnchor = "BOTTOMLEFT",
    growthX = "RIGHT",
    growthY = "UP",
    disableCooldown = true,
  },
  debuffs = {
    enabled = true,
    point = {"TOPLEFT","RIGHT",10*L.C.uiscale,-5*L.C.uiscale},
    num = 40,
    cols = 8,
    size = 22*L.C.uiscale,
    spacing = 5*L.C.uiscale,
    initialAnchor = "TOPLEFT",
    growthX = "RIGHT",
    growthY = "DOWN",
    disableCooldown = true,
  },
}
