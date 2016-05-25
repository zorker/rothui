
-- rActionBar: extrabar
-- zork, 2016

-----------------------------
-- Config
-----------------------------

local cfg = {}
cfg.blizzardBar     = ExtraActionBarFrame
cfg.frameName       = "rABS_ExtraBar"
cfg.frameParent     = UIParent
cfg.frameTemplate   = "SecureHandlerStateTemplate"
cfg.frameVisibility = "[extrabar] show; hide"
cfg.framePoint      = { "BOTTOMRIGHT", rABS_Bar1, "BOTTOMLEFT", -5, 0 }
cfg.frameScale      = 1
cfg.framePadding    = 5
cfg.buttonWidth     = 32
cfg.buttonHeight    = 32
cfg.buttonMargin    = 5
cfg.buttonName      = "ExtraActionButton"
cfg.numButtons      = 1
cfg.numCols         = 1
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

--special settings
cfg.blizzardBar:ClearAllPoints()
cfg.blizzardBar:SetPoint("CENTER")
cfg.blizzardBar.ignoreFramePositionManager = true