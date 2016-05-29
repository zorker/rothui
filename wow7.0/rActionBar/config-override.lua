
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
  L.cfg.bar2.framePoint = { "LEFT", "rABS_ActionBar1", "TOPRIGHT", 10, 0 }
  L.cfg.bar2.numCols = 6
  L.cfg.bar2.startPoint = "TOPLEFT"
  L.cfg.bar2.fader = {
    enable = true,
    fadeInAlpha = 1,
    fadeInDuration = 0.3,
    fadeInSmooth = "OUT",
    fadeOutAlpha = 0.5,
    fadeOutDuration = 0.9,
    fadeOutSmooth = "OUT",
  }
  L.cfg.bar3.frameScale = 0.8
  L.cfg.bar3.numCols = 6
  L.cfg.bar3.startPoint = "TOPLEFT"

  L.cfg.bar4.frameScale = 0.8
  L.cfg.bar5.frameScale = 0.8

  L.cfg.bags.fader.fadeOutAlpha = 0
  L.cfg.micromenu.fader.fadeOutAlpha = 0

end