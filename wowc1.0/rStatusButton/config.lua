
-- rStatusButton: config
-- zork, 2019

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Config
-----------------------------

L.C = {
  scale = 0.9,
  point = { "TOP", 0, -150 },
  size = { 32, 32 },
  frameVisibility = "[petbattle][overridebar][vehicleui][possessbar][shapeshift][combat] hide; [mod:shift] show; hide",
  frameVisibilityFunc = nil,
  --fader via OnShow trigger
  fader = {
    fadeInAlpha = 1,
    fadeInDuration = 0.3,
    fadeInSmooth = "OUT",
    fadeOutAlpha = 0,
    fadeOutDuration = 0.9,
    fadeOutSmooth = "OUT",
    fadeOutDelay = 0,
    trigger = "OnShow",
  },
}
