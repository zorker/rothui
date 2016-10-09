
-- oUF_SimpleConfig: targettarget
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- TargetTarget Config
-----------------------------

L.C.targettarget = {
  enabled = true,
  size = {130*L.C.uiscale,26*L.C.uiscale},
  point = {"TOPLEFT","oUF_SimpleTarget","BOTTOMLEFT",0*L.C.uiscale,-14*L.C.uiscale},
  scale = 1,
  --healthbar
  healthbar = {
    --health and absorb bar cannot be disabled, they match the size of the frame
    colorTapping = true,
    colorDisconnected = true,
    colorReaction = true,
    colorClass = true,
    colorHealth = true,
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