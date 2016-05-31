
-- rActionBar: config
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Config
-----------------------------

L.cfg = {}

--bag config
L.cfg.bags = {
  blizzardBar     = nil,
  frameName       = "rABS_BagBar",
  frameParent     = UIParent,
  frameTemplate   = "SecureHandlerStateTemplate",
  frameVisibility = "[petbattle] hide; show",
  framePoint      = { "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -5, 5 },
  frameScale      = 1,
  framePadding    = 5,
  buttonWidth     = 32,
  buttonHeight    = 32,
  buttonMargin    = 2,
  numCols         = 6,
  startPoint      = "BOTTOMRIGHT",
  dragInset       = -2,
  dragClamp       = true,
  fader = {
    enable = true,
    fadeInAlpha = 1,
    fadeInDuration = 0.3,
    fadeInSmooth = "OUT",
    fadeOutAlpha = 0.3,
    fadeOutDuration = 0.9,
    fadeOutSmooth = "OUT",
  },
}

--micro menu
L.cfg.micromenu = {
  blizzardBar     = nil,
  frameName       = "rABS_MicroMenuBar",
  frameParent     = UIParent,
  frameTemplate   = "SecureHandlerStateTemplate",
  frameVisibility = "[petbattle] hide; show",
  framePoint      = { "TOP", UIParent, "TOP", 0, 0 },
  frameScale      = 0.8,
  framePadding    = 5,
  buttonWidth     = 28,
  buttonHeight    = 58,
  buttonMargin    = 0,
  numCols         = 12,
  startPoint      = "BOTTOMLEFT",
  dragInset       = -2,
  dragClamp       = true,
  fader = {
    enable = true,
    fadeInAlpha = 1,
    fadeInDuration = 0.3,
    fadeInSmooth = "OUT",
    fadeOutAlpha = 0.3,
    fadeOutDuration = 0.9,
    fadeOutSmooth = "OUT",
  },
}

--bar1
L.cfg.bar1 = {
  blizzardBar     = nil, --important, we get rid of MainMenuBarArtFrame
  frameName       = "rABS_ActionBar1",
  frameParent     = UIParent,
  frameTemplate   = "SecureHandlerStateTemplate",
  frameVisibility = "[petbattle] hide; show",
  framePage       = "[vehicleui] 1; [possessbar] 2; [overridebar] 3; [shapeshift] 4; [bar:1] 5; [bar:2] 6; [bar:3] 7; [bar:4] 8; [bar:5] 9; [bar:6] 10; [bonusbar:1] 11; [bonusbar:2] 12; [bonusbar:3] 13; [bonusbar:4] 14; 15",
  framePoint      = { "BOTTOM", UIParent, "BOTTOM", 0, 10 },
  frameScale      = 1,
  framePadding    = 5,
  buttonWidth     = 32,
  buttonHeight    = 32,
  buttonMargin    = 5,
  buttonName      = "ActionButton",
  numButtons      = NUM_ACTIONBAR_BUTTONS,
  numCols         = 12,
  startPoint      = "BOTTOMLEFT",
  dragInset       = -2,
  dragClamp       = true,
}

--bar2
L.cfg.bar2 = {
  blizzardBar     = MultiBarBottomLeft,
  frameName       = "rABS_ActionBar2",
  frameParent     = UIParent,
  frameTemplate   = "SecureHandlerStateTemplate",
  frameVisibility = "[petbattle][overridebar][vehicleui][possessbar][shapeshift] hide; show",
  framePoint      = { "BOTTOM", "rABS_ActionBar1", "TOP", 0, 0 },
  frameScale      = 1,
  framePadding    = 5,
  buttonWidth     = 32,
  buttonHeight    = 32,
  buttonMargin    = 5,
  buttonName      = "MultiBarBottomLeftButton",
  numButtons      = NUM_ACTIONBAR_BUTTONS,
  numCols         = 12,
  startPoint      = "BOTTOMLEFT",
  dragInset       = -2,
  dragClamp       = true,
}

--bar3
L.cfg.bar3 = {
  blizzardBar     = MultiBarBottomRight,
  frameName       = "rABS_ActionBar3",
  frameParent     = UIParent,
  frameTemplate   = "SecureHandlerStateTemplate",
  frameVisibility = "[petbattle][overridebar][vehicleui][possessbar][shapeshift] hide; show",
  framePoint      = { "BOTTOM", "rABS_ActionBar2", "TOP", 0, 0 },
  frameScale      = 1,
  framePadding    = 5,
  buttonWidth     = 32,
  buttonHeight    = 32,
  buttonMargin    = 5,
  buttonName      = "MultiBarBottomRightButton",
  numButtons      = NUM_ACTIONBAR_BUTTONS,
  numCols         = 12,
  startPoint      = "BOTTOMLEFT",
  dragInset       = -2,
  dragClamp       = true,
  fader = {
    enable = false,
    fadeInAlpha = 1,
    fadeInDuration = 0.3,
    fadeInSmooth = "OUT",
    fadeOutAlpha = 0.3,
    fadeOutDuration = 0.9,
    fadeOutSmooth = "OUT",
  },
}

--bar4
L.cfg.bar4 = {
  blizzardBar     = MultiBarRight,
  frameName       = "rABS_ActionBar4",
  frameParent     = UIParent,
  frameTemplate   = "SecureHandlerStateTemplate",
  frameVisibility = "[petbattle][overridebar][vehicleui][possessbar][shapeshift] hide; show",
  framePoint      = { "RIGHT", UIParent, "RIGHT", -5, 0 },
  frameScale      = 1,
  framePadding    = 5,
  buttonWidth     = 32,
  buttonHeight    = 32,
  buttonMargin    = 5,
  buttonName      = "MultiBarRightButton",
  numButtons      = NUM_ACTIONBAR_BUTTONS,
  numCols         = 1,
  startPoint      = "TOPRIGHT",
  dragInset       = -2,
  dragClamp       = true,
  fader = {
    enable = true,
    fadeInAlpha = 1,
    fadeInDuration = 0.3,
    fadeInSmooth = "OUT",
    fadeOutAlpha = 0.3,
    fadeOutDuration = 0.9,
    fadeOutSmooth = "OUT",
  },
}

--bar5
L.cfg.bar5 = {
  blizzardBar     = MultiBarLeft,
  frameName       = "rABS_ActionBar5",
  frameParent     = UIParent,
  frameTemplate   = "SecureHandlerStateTemplate",
  frameVisibility = "[petbattle][overridebar][vehicleui][possessbar][shapeshift] hide; show",
  framePoint      = { "RIGHT", "rABS_ActionBar4", "LEFT", 0, 0 },
  frameScale      = 1,
  framePadding    = 5,
  buttonWidth     = 32,
  buttonHeight    = 32,
  buttonMargin    = 5,
  buttonName      = "MultiBarLeftButton",
  numButtons      = NUM_ACTIONBAR_BUTTONS,
  numCols         = 1,
  startPoint      = "TOPRIGHT",
  dragInset       = -2,
  dragClamp       = true,
  fader = {
    enable = true,
    fadeInAlpha = 1,
    fadeInDuration = 0.3,
    fadeInSmooth = "OUT",
    fadeOutAlpha = 0.3,
    fadeOutDuration = 0.9,
    fadeOutSmooth = "OUT",
  },
}

--stancebar
L.cfg.stancebar = {
  blizzardBar     = StanceBarFrame,
  frameName       = "rABS_StanceBar",
  frameParent     = UIParent,
  frameTemplate   = "SecureHandlerStateTemplate",
  frameVisibility = "[petbattle][overridebar][vehicleui][possessbar][shapeshift] hide; [stance][form] show; hide",
  framePoint      = { "BOTTOM", "rABS_ActionBar3", "TOP", 0, 0 },
  frameScale      = 0.8,
  framePadding    = 5,
  buttonWidth     = 32,
  buttonHeight    = 32,
  buttonMargin    = 5,
  buttonName      = "StanceButton",
  numButtons      = NUM_STANCE_SLOTS,
  numCols         = 12,
  startPoint      = "BOTTOMLEFT",
  dragInset       = -2,
  dragClamp       = true,
}

--petbar
L.cfg.petbar = {
  blizzardBar     = PetActionBarFrame,
  frameName       = "rABS_PetActionBar",
  frameParent     = UIParent,
  frameTemplate   = "SecureHandlerStateTemplate",
  frameVisibility = "[petbattle][overridebar][vehicleui][possessbar][shapeshift] hide; [pet] show; hide",
  framePoint      = { "BOTTOM", "rABS_ActionBar3", "TOP", 0, 0 },
  frameScale      = 0.8,
  framePadding    = 5,
  buttonWidth     = 32,
  buttonHeight    = 32,
  buttonMargin    = 5,
  buttonName      = "PetActionButton",
  numButtons      = NUM_PET_ACTION_SLOTS,
  numCols         = 12,
  startPoint      = "BOTTOMLEFT",
  dragInset       = -2,
  dragClamp       = true,
}

--extrabar
L.cfg.extrabar = {
  blizzardBar     = ExtraActionBarFrame,
  frameName       = "rABS_ExtraActionBar",
  frameParent     = UIParent,
  frameTemplate   = "SecureHandlerStateTemplate",
  frameVisibility = "[extrabar] show; hide",
  framePoint      = { "RIGHT", "rABS_ActionBar1", "LEFT", -5, 0 },
  frameScale      = 1,
  framePadding    = 5,
  buttonWidth     = 32,
  buttonHeight    = 32,
  buttonMargin    = 5,
  buttonName      = "ExtraActionButton",
  numButtons      = 1,
  numCols         = 1,
  startPoint      = "BOTTOMLEFT",
  dragInset       = -2,
  dragClamp       = true,
}

--vehicleexit
L.cfg.vehicleexit = {
  blizzardBar     = nil,
  frameName       = "rABS_VehicleExit",
  frameParent     = UIParent,
  frameTemplate   = "SecureHandlerStateTemplate",
  frameVisibility = "[canexitvehicle] show; hide",
  framePoint      = { "LEFT", "rABS_ActionBar1", "RIGHT", 5, 0 },
  frameScale      = 1,
  framePadding    = 5,
  buttonWidth     = 32,
  buttonHeight    = 32,
  buttonMargin    = 5,
  buttonName      = "OverrideActionBar.LeaveButton",
  numButtons      = 1,
  numCols         = 1,
  startPoint      = "BOTTOMLEFT",
  dragInset       = -2,
  dragClamp       = true,
}