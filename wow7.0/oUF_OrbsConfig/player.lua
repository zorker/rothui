
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
  point = {"RIGHT",UIParent,"CENTER",-230,0},
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
    colorPower = true,
  },
  --castbar
  castbar = {
    enabled = false,
    icon = {
      enabled = true,
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
