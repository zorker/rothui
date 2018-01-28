
-- oUF_OrbsConfig: global
-- zork, 2018

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Global Config
-----------------------------

--scale
L.C.scale = 0.6

--colors
L.C.colors = {}
--colors bgMultiplier
L.C.colors.bgMultiplier = 0.3
--colors castbar
L.C.colors.castbar = {
  default = {1,0.7,0},
  shielded = {.8,.8,.8}
}
--colors healthbar
L.C.colors.healthbar = {
  default = {0,1,0},
  threat = {1,0,0},
  threatInvers = {0,1,0},
  absorb = {0,1,1}
}
