
-- oUF_OrbsConfig: target
-- zork, 2018

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Target Config
-----------------------------

L.C.target = {
  enabled = true,
  point = {"LEFT",UIParent,"CENTER",250,-150},
  scale = 1*L.C.scale,
  --healthbar
  healthbar = {
    colorTapping = true,
    colorDisconnected = true,
    colorClass = true,
    colorReaction = true,
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
    },
  },
}