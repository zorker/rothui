
-- oUF_OrbsConfig: player
-- zork, 2018

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Player Config
-----------------------------

L.C.player = {
  enabled = true,
  point = {"RIGHT",UIParent,"CENTER",-250,-150},
  scale = 1*L.C.scale,
  --healthbar (cannot be disabled)
  healthbar = {
    colorClass = true,
    colorHealth = true,
    colorThreat = true,
  },
  --powerbar
  powerbar = {
    enabled = true,
    clockwise = false,
    segment = "ring_bottom",
    colorPower = true,
  },
  --castbar
  castbar = {
    enabled = true,
    clockwise = true,
    segment = "ring_top",
    icon = {
      enabled = true,
      point = {"CENTER","LEFT",36,0},
      size = 72,
    },
  },
  --classbar
  classbar = {
    enabled = false,
  },
  --altpowerbar
  altpowerbar = {
    enabled = false,
  },
  --absorbbar
  absorbbar = {
    enabled = false,
  },
}
