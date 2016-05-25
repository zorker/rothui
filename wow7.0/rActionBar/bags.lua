
-- rActionBar: bags
-- zork, 2016

-----------------------------
-- Config
-----------------------------

local cfg = {}
cfg.blizzardBar     = nil
cfg.frameName       = "rABS_BagFrame"
cfg.frameParent     = UIParent
cfg.frameTemplate   = "SecureHandlerStateTemplate"
cfg.frameVisibility = "[petbattle] hide; show"
cfg.framePoint      = { "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -10, 10 }
cfg.frameScale      = 0.8
cfg.framePadding    = 5
cfg.buttonWidth     = 32
cfg.buttonHeight    = 32
cfg.buttonMargin    = 2
cfg.resetButtonParent = true
cfg.numCols         = 6
cfg.startPoint      = "BOTTOMRIGHT"
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
local buttonList = { MainMenuBarBackpackButton, CharacterBag0Slot, CharacterBag1Slot, CharacterBag2Slot, CharacterBag3Slot }
--create frame
local frame = L:CreateButtonFrame(cfg,buttonList)