
-- rActionBar: overridebar
-- zork, 2016

-----------------------------
-- Config
-----------------------------

local cfg = {}
cfg.blizzardBar     = OverrideActionBar
cfg.blizzardBarVisibility = "[overridebar][vehicleui][possessbar,@vehicle,exists] show; hide"
cfg.frameName       = "rABS_OverrideBar"
cfg.frameParent     = UIParent
cfg.frameTemplate   = "SecureHandlerStateTemplate"
cfg.frameVisibility = "[petbattle] hide; [overridebar][vehicleui][possessbar,@vehicle,exists] show; hide"
cfg.framePoint      = { "BOTTOM", UIParent, "BOTTOM", 0, 20 }
cfg.frameScale      = 1
cfg.framePadding    = 5
cfg.buttonWidth     = 32
cfg.buttonHeight    = 32
cfg.buttonMargin    = 5
cfg.buttonName      = "OverrideActionBarButton"
cfg.numButtons      = 6
cfg.numCols         = 12
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
--add the leave button
table.insert(buttonList, OverrideActionBar.LeaveButton)
--create frame
local frame = L:CreateButtonFrame(cfg,buttonList)

--special settings
cfg.blizzardBar:SetScript("OnShow", nil)
RegisterStateDriver(cfg.blizzardBar, "visibility", cfg.blizzardBarVisibility)