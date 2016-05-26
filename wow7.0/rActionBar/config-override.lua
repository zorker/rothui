
-- rActionBar: config
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

local playerName = UnitName("player")

-----------------------------
-- Override
-----------------------------

if playerName == "Rothar" then
  L.cfg.bar1.numCols = 6
  L.cfg.bar2.frameScale = 0.8
  L.cfg.bar2.framePoint = { "LEFT", "rABS_Bar1", "TOPRIGHT", 10, 0 }
  L.cfg.bar2.numCols = 6
  L.cfg.bar2.startPoint = "TOPLEFT"
  L.cfg.bar3.frameScale = 0.8
  L.cfg.bar3.numCols = 6
  L.cfg.bar3.startPoint = "TOPLEFT"
end