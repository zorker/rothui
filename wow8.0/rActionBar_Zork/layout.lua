
-- rActionBar_Default: layout
-- zork, 2016

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

-----------------------------
-- BagBar
-----------------------------

local bagbar = {
  framePoint      = { "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -5, 5 },
  frameScale      = 1,
  framePadding    = 5,
  buttonWidth     = 32,
  buttonHeight    = 32,
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
  framePoint      = { "TOP", UIParent, "TOP", 0, 0 },
  frameScale      = 0.8,
  framePadding    = 5,
  buttonWidth     = 28,
  buttonHeight    = 38,
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
  framePoint      = { "BOTTOM", UIParent, "BOTTOM", 0, 230 },
  frameScale      = .9,
  framePadding    = 5,
  buttonWidth     = 32,
  buttonHeight    = 32,
  buttonMargin    = 5,
  numCols         = 6,
  startPoint      = "BOTTOMLEFT",
  fader           = nil,
  frameVisibility = "[petbattle] hide; [combat][mod][@target,exists,nodead][@vehicle,exists][overridebar][shapeshift][vehicleui][possessbar] show; hide"
}
--create
rActionBar:CreateActionBar1(A, bar1)

-----------------------------
-- Bar2
-----------------------------

local bar2 = {
  --framePoint      = { "BOTTOM", _G[A.."Bar1"], "TOP", 0, -5 },
  framePoint      = { "TOP", _G[A.."Bar1"], "BOTTOM", 0, 5 },
  frameScale      = .9,
  framePadding    = 5,
  buttonWidth     = 32,
  buttonHeight    = 32,
  buttonMargin    = 5,
  numCols         = 6,
  startPoint      = "BOTTOMLEFT",
  --fader           = nil,
  frameVisibility = "[petbattle][overridebar][vehicleui][possessbar][shapeshift] hide; [combat][mod][@target,exists,nodead] show; hide"
}
--create
rActionBar:CreateActionBar2(A, bar2)

-----------------------------
-- Bar3
-----------------------------

--note. uses a different fader config object

local bar3 = {
  framePoint      = { "BOTTOM", UIParent, "BOTTOM", 0, 5 },
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
  framePoint      = { "RIGHT", UIParent, "RIGHT", -5, 0 },
  frameScale      = 1,
  framePadding    = 5,
  buttonWidth     = 32,
  buttonHeight    = 32,
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
  framePoint      = { "RIGHT", _G[A.."Bar4"], "LEFT", 5, 0 },
  frameScale      = 1,
  framePadding    = 5,
  buttonWidth     = 32,
  buttonHeight    = 32,
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
  fader           = nil,
  frameVisibility = "[petbattle][overridebar][vehicleui][possessbar][shapeshift][nomod] hide; show"
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
  fader           = nil,
  frameVisibility = "[petbattle][overridebar][vehicleui][possessbar][shapeshift] hide; [pet,mod] show; hide"
}
--create
rActionBar:CreatePetBar(A, petbar)

-----------------------------
-- ExtraBar
-----------------------------

local extrabar = {
  framePoint      = { "RIGHT", A.."Bar1", "LEFT", -5, 0 },
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
rActionBar:CreateExtraBar(A, extrabar)

-----------------------------
-- VehicleExitBar
-----------------------------

local vehicleexitbar = {
  framePoint      = { "LEFT", A.."Bar1", "RIGHT", 5, 0 },
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

-----------------------------
-- PossessExitBar
-----------------------------

local possessexitbar = {
  framePoint      = { "BOTTOMLEFT", A.."Bar1", "BOTTOMRIGHT", 5, 0 },
  frameScale      = 0.95,
  framePadding    = 5,
  buttonWidth     = 32,
  buttonHeight    = 32,
  buttonMargin    = 5,
  numCols         = 1,
  startPoint      = "BOTTOMLEFT",
  fader           = nil,
}
--create
rActionBar:CreatePossessExitBar(A, possessexitbar)