
-- rActionBar: bar5
-- zork, 2016

-----------------------------
-- Config
-----------------------------

local cfg = {}
cfg.blizzardBar     = MultiBarLeft
cfg.frameName       = "rABS_Bar5"
cfg.frameParent     = UIParent
cfg.frameTemplate   = "SecureHandlerStateTemplate"
cfg.frameVisibility = "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show"
cfg.framePoint      = { "BOTTOM", rABS_Bar4, "TOP", 0, 5 }
cfg.frameScale      = 1
cfg.framePadding    = 5
cfg.buttonWidth     = 32
cfg.buttonHeight    = 32
cfg.buttonMargin    = 5
cfg.buttonName      = "MultiBarLeftButton"
cfg.numButtons      = NUM_ACTIONBAR_BUTTONS
cfg.numCols         = 4
cfg.startPoint      = "BOTTOMLEFT"
cfg.dragInset       = -2
cfg.dragClamp       = true

-----------------------------
-- Variables
-----------------------------

local A, L = ...

--buttonList
local buttonList = L:GetButtonList(cfg.buttonName, cfg.numButtons)

-----------------------------
-- Init
-----------------------------

--create new parent frame
local frame = CreateFrame("Frame", cfg.frameName, cfg.frameParent, cfg.frameTemplate)
frame:SetPoint(unpack(cfg.framePoint))
frame:SetScale(cfg.frameScale)
L:SetupButtonFrame(frame, cfg.framePadding, buttonList, cfg.buttonWidth, cfg.buttonHeight, cfg.buttonMargin, cfg.numCols, cfg.startPoint)

--reparent the Blizzard bar
cfg.blizzardBar:SetParent(frame)
cfg.blizzardBar:EnableMouse(false)

--show/hide the frame on a given state driver
RegisterStateDriver(frame, "visibility", cfg.frameVisibility)

--add drag functions
rLib:CreateDragFrame(frame, L.dragFrames, cfg.inset , cfg.clamp)