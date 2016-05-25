
-- rActionBar: bar1
-- zork, 2016

-----------------------------
-- Config
-----------------------------

local cfg = {}
cfg.blizzardBar     = MainMenuBarArtFrame
cfg.frameName       = "rABS_Bar1"
cfg.frameParent     = UIParent
cfg.frameTemplate   = "SecureHandlerStateTemplate"
cfg.frameVisibility = "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show"
cfg.framePoint      = { "BOTTOM", UIParent, "BOTTOM", 0, 20 }
cfg.frameScale      = 1
cfg.framePadding    = 5
cfg.buttonWidth     = 32
cfg.buttonHeight    = 32
cfg.buttonMargin    = 5
cfg.buttonName      = "ActionButton"
cfg.numButtons      = NUM_ACTIONBAR_BUTTONS
cfg.numCols         = 6
cfg.startPoint      = "BOTTOMLEFT"
cfg.dragInset       = -2
cfg.dragClamp       = true

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Init
-----------------------------

--buttonList
local buttonList = L:GetButtonList(cfg.buttonName, cfg.numButtons)
--create frame
local frame = L:CreateButtonFrame(cfg,buttonList)