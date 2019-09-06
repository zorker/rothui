
-- rActionBar_Default: layout
-- zork, 2019

-- Zork's Bar Layout for rActionBar

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Fader
-----------------------------

local fader = {
  fadeInAlpha = 1,
  fadeInDuration = 0.3,
  fadeInSmooth = "OUT",
  fadeOutAlpha = 0,
  fadeOutDuration = 0.9,
  fadeOutSmooth = "OUT",
  fadeOutDelay = 0,
}

local faderOnShow = {
  fadeInAlpha = 1,
  fadeInDuration = 0.3,
  fadeInSmooth = "OUT",
  fadeOutAlpha = 0,
  fadeOutDuration = 0.9,
  fadeOutSmooth = "OUT",
  fadeOutDelay = 0,
  trigger = "OnShow",
}

-----------------------------
-- BagBar
-----------------------------

local bagbar = {
  framePoint      = { "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -40, 0 },
  frameScale      = 1,
  framePadding    = 5,
  buttonWidth     = 34,
  buttonHeight    = 34,
  buttonMargin    = 2,
  numCols         = 6, --number of buttons per column
  startPoint      = "BOTTOMRIGHT", --start postion of first button: BOTTOMLEFT, TOPLEFT, TOPRIGHT, BOTTOMRIGHT
  fader           = fader,
}
--create
rActionBar:CreateBagBar(A, bagbar)

-----------------------------
-- MicroMenuBar
-----------------------------

local micromenubar = {
  framePoint      = { "TOP", UIParent, "TOP", 0, 5 },
  frameScale      = 0.8,
  framePadding    = 5,
  buttonWidth     = 28,
  buttonHeight    = 58,
  buttonMargin    = 0,
  numCols         = 12,
  startPoint      = "BOTTOMLEFT",
  fader           = fader,
}
--create
rActionBar:CreateMicroMenuBar(A, micromenubar)

-----------------------------
-- Bar1
-----------------------------

local bar1 = {
  framePoint      = { "BOTTOMRIGHT", UIParent, "BOTTOM", 0, 5 },
  frameScale      = 1,
  framePadding    = 5,
  buttonWidth     = 36,
  buttonHeight    = 36,
  buttonMargin    = 5,
  numCols         = 6,
  startPoint      = "BOTTOMLEFT",
  fader           = faderOnShow,
  frameVisibility = "[combat][mod:shift][@target,exists,nodead][@vehicle,exists][overridebar][shapeshift][vehicleui][possessbar] show; hide"
}
--create
rActionBar:CreateActionBar1(A, bar1)

-----------------------------
-- Bar2
-----------------------------

local bar2 = {
  framePoint      = { "LEFT", A.."Bar1", "RIGHT", 0, 0 },
  frameScale      = 1,
  framePadding    = 5,
  buttonWidth     = 36,
  buttonHeight    = 36,
  buttonMargin    = 5,
  numCols         = 6,
  startPoint      = "BOTTOMLEFT",
  fader           = faderOnShow,
  frameVisibility = "[overridebar][vehicleui][possessbar][shapeshift] hide; [combat][mod:shift][@target,exists,nodead] show; hide"
}
--create
rActionBar:CreateActionBar2(A, bar2)

-----------------------------
-- Bar3
-----------------------------

--note. uses a different fader config object

local bar3 = {
  framePoint      = { "BOTTOMLEFT", A.."Bar1", "TOPLEFT", 26, 0 },
  frameScale      = 1,
  framePadding    = 5,
  buttonWidth     = 32,
  buttonHeight    = 32,
  buttonMargin    = 5,
  numCols         = 12,
  startPoint      = "BOTTOMLEFT",
  fader           = fader,
  --frameVisibility = "[combat][mod][@target,exists,nodead] show; hide"
}
--create
rActionBar:CreateActionBar3(A, bar3)

-----------------------------
-- Bar4
-----------------------------

local bar4 = {
  framePoint      = { "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 40 },
  frameScale      = 1,
  framePadding    = 5,
  buttonWidth     = 34,
  buttonHeight    = 34,
  buttonMargin    = 5,
  numCols         = 1,
  startPoint      = "TOPRIGHT",
  fader           = fader,
}
--create
rActionBar:CreateActionBar4(A, bar4)

-----------------------------
-- Bar5
-----------------------------

local bar5 = {
  framePoint      = { "RIGHT", A.."Bar4", "LEFT", 5, 0 },
  frameScale      = 1,
  framePadding    = 5,
  buttonWidth     = 34,
  buttonHeight    = 34,
  buttonMargin    = 5,
  numCols         = 1,
  startPoint      = "TOPRIGHT",
  fader           = fader,
}
--create
rActionBar:CreateActionBar5(A, bar5)

-----------------------------
-- StanceBar
-----------------------------

local stancebar = {
  framePoint      = { "BOTTOM", A.."Bar3", "TOP", 0, 0 },
  frameScale      = 0.8,
  framePadding    = 5,
  buttonWidth     = 32,
  buttonHeight    = 32,
  buttonMargin    = 5,
  numCols         = 12,
  startPoint      = "BOTTOMLEFT",
  fader           = fader,
  --frameVisibility = "[overridebar][vehicleui][possessbar][shapeshift][nomod] hide; show"
}
--create
rActionBar:CreateStanceBar(A, stancebar)

-----------------------------
-- PetBar
-----------------------------

--petbar
local petbar = {
  framePoint      = { "BOTTOM", A.."Bar3", "TOP", 0, 0 },
  frameScale      = 0.8,
  framePadding    = 5,
  buttonWidth     = 32,
  buttonHeight    = 32,
  buttonMargin    = 5,
  numCols         = 12,
  startPoint      = "BOTTOMLEFT",
  fader           = fader,
  --frameVisibility = "[petbattle][overridebar][vehicleui][possessbar][shapeshift] hide; [pet,mod] show; hide"
}
--create
rActionBar:CreatePetBar(A, petbar)

-----------------------------
-- VehicleExitBar
-----------------------------

local vehicleexitbar = {
  framePoint      = { "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0 },
  frameScale      = 0.95,
  framePadding    = 5,
  buttonWidth     = 36,
  buttonHeight    = 36,
  buttonMargin    = 5,
  numCols         = 1,
  startPoint      = "BOTTOMLEFT",
  fader           = nil,
}
--create
rActionBar:CreateVehicleExitBar(A, vehicleexitbar)
