
-- rPlayerFrame: config
-- zork, 2019

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Config
-----------------------------

L.C = {
  textureColor = {0.2,0.2,0.2,0.5},
  frameVisibility = "[mod:shift][combat][@target,exists] show; hide",
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
