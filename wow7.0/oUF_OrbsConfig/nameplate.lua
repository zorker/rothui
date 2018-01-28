
-- oUF_OrbsConfig: nameplate
-- zork, 2018

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Nameplate Config
-----------------------------

L.C.nameplate = {
  enabled = true,
  point = {"CENTER"},
  scale = 0.7*UIParent:GetScale()*L.C.scale,
  --healthbar
  healthbar = {
    colorTapping = true,
    colorReaction = true,
    colorClass = true,
    colorHealth = true,
    colorThreat = true,
    colorThreatInvers = true,
    frequentUpdates = true,
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