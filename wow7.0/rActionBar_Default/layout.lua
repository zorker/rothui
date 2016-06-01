
-- rActionBar_Default: layout
-- zork, 2016

-- Default Bar Layout for rActionBar

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Config
-----------------------------

local fader = {
  enable = true,
  fadeInAlpha = 1,
  fadeInDuration = 0.3,
  fadeInSmooth = "OUT",
  fadeOutAlpha = 0.3,
  fadeOutDuration = 0.9,
  fadeOutSmooth = "OUT",
}

local bars = {}

--bag config
bars.bagbar = {
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

--micro menu
bars.micromenubar = {
  framePoint      = { "TOP", UIParent, "TOP", 0, 0 },
  frameScale      = 0.8,
  framePadding    = 5,
  buttonWidth     = 28,
  buttonHeight    = 58,
  buttonMargin    = 0,
  numCols         = 12,
  startPoint      = "BOTTOMLEFT",
  fader           = fader,
}

--bar1
bars.bar1 = {
  framePoint      = { "BOTTOM", UIParent, "BOTTOM", 0, 10 },
  frameScale      = 1,
  framePadding    = 5,
  buttonWidth     = 32,
  buttonHeight    = 32,
  buttonMargin    = 5,
  numCols         = 12,
  startPoint      = "BOTTOMLEFT",
  fader           = nil,
}

--bar2
bars.bar2 = {
  framePoint      = { "BOTTOM", A.."Bar1", "TOP", 0, 0 },
  frameScale      = 1,
  framePadding    = 5,
  buttonWidth     = 32,
  buttonHeight    = 32,
  buttonMargin    = 5,
  numCols         = 12,
  startPoint      = "BOTTOMLEFT",
  fader           = nil,
}

--bar3
bars.bar3 = {
  framePoint      = { "BOTTOM", A.."Bar2", "TOP", 0, 0 },
  frameScale      = 1,
  framePadding    = 5,
  buttonWidth     = 32,
  buttonHeight    = 32,
  buttonMargin    = 5,
  numCols         = 12,
  startPoint      = "BOTTOMLEFT",
  fader           = fader,
}

--bar4
bars.bar4 = {
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

--bar5
bars.bar5 = {
  framePoint      = { "RIGHT", A.."Bar4", "LEFT", 0, 0 },
  frameScale      = 1,
  framePadding    = 5,
  buttonWidth     = 32,
  buttonHeight    = 32,
  buttonMargin    = 5,
  numCols         = 1,
  startPoint      = "TOPRIGHT",
  fader           = fader,
}

--stancebar
bars.stancebar = {
  framePoint      = { "BOTTOM", A.."Bar3", "TOP", 0, 0 },
  frameScale      = 0.8,
  framePadding    = 5,
  buttonWidth     = 32,
  buttonHeight    = 32,
  buttonMargin    = 5,
  numCols         = 12,
  startPoint      = "BOTTOMLEFT",
  fader           = nil,
}

--petbar
bars.petbar = {
  framePoint      = { "BOTTOM", A.."Bar3", "TOP", 0, 0 },
  frameScale      = 0.8,
  framePadding    = 5,
  buttonWidth     = 32,
  buttonHeight    = 32,
  buttonMargin    = 5,
  numCols         = 12,
  startPoint      = "BOTTOMLEFT",
  fader           = nil,
}

--extrabar
bars.extrabar = {
  framePoint      = { "BOTTOMRIGHT", A.."Bar1", "BOTTOMLEFT", -5, 0 },
  frameScale      = 1,
  framePadding    = 5,
  buttonWidth     = 32,
  buttonHeight    = 32,
  buttonMargin    = 5,
  numCols         = 1,
  startPoint      = "BOTTOMLEFT",
  fader           = nil,
}

--vehicleexit
bars.vehicleexitbar = {
  framePoint      = { "BOTTOMLEFT", A.."Bar1", "BOTTOMRIGHT", 5, 0 },
  frameScale      = 1,
  framePadding    = 5,
  buttonWidth     = 32,
  buttonHeight    = 32,
  buttonMargin    = 5,
  numCols         = 1,
  startPoint      = "BOTTOMLEFT",
  fader           = nil,
}

-----------------------------
-- Init
-----------------------------

--create all bars

--BagBar
rActionBar:CreateBagBar(A, bars.bagbar)
--MicroMenuBar
rActionBar:CreateMicroMenuBar(A, bars.micromenubar)
--Bar1
rActionBar:CreateActionBar1(A, bars.bar1)
--Bar2
rActionBar:CreateActionBar2(A, bars.bar2)
--Bar3
rActionBar:CreateActionBar3(A, bars.bar3)
--Bar4
rActionBar:CreateActionBar4(A, bars.bar4)
--Bar5
rActionBar:CreateActionBar5(A, bars.bar5)
--StanceBar
rActionBar:CreateStanceBar(A, bars.stancebar)
--PetBar
rActionBar:CreatePetBar(A, bars.petbar)
--ExtraBar
rActionBar:CreateExtraBar(A, bars.extrabar)
--VehicleExitBar
rActionBar:CreateVehicleExitBar(A, bars.vehicleexitbar)