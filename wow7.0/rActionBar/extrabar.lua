
-- rActionBar: bar1
-- zork, 2016

-----------------------------
-- Config
-----------------------------

local cfg = {}
--frame settings
cfg.scale     = 1
cfg.padding   = 0
cfg.inset     = -2
cfg.clamp     = true
cfg.pos       = { a1 = "RIGHT", a2 = "LEFT", af = rABS_MainMenuBar, x = -5, y = 0 }
--button settings
cfg.width     = 32
cfg.height    = 32
cfg.margin    = 5

-----------------------------
-- Local Variables
-----------------------------

local A, L = ...

--num_buttons
local num_buttons = 1
--button list
local buttonList = {}
local buttonName = "ExtraActionButton"

-----------------------------
-- Init
-----------------------------

--create new parent frame
local frame = CreateFrame("Frame", "rABS_ExtraBar", UIParent, "SecureHandlerStateTemplate")
frame:SetWidth(num_buttons*cfg.width+(num_buttons-1)*cfg.margin+2*cfg.padding)
frame:SetHeight(cfg.height+2*cfg.padding)
frame:SetPoint(cfg.pos.a1,cfg.pos.af,cfg.pos.a2,cfg.pos.x,cfg.pos.y)
frame:SetScale(cfg.scale)

--reparent the bar
ExtraActionBarFrame:SetParent(frame)
ExtraActionBarFrame:EnableMouse(false)
ExtraActionBarFrame:ClearAllPoints()
ExtraActionBarFrame:SetPoint("CENTER")
ExtraActionBarFrame.ignoreFramePositionManager = true

--repoint all buttons
table.insert(buttonList, ExtraActionButton1) --add the button object to the list
ExtraActionButton1:SetSize(cfg.width,cfg.height)

--show/hide the frame on a given state driver
RegisterStateDriver(frame, "visibility", "[extrabar] show; hide")

--add drag functions
rLib:CreateDragFrame(frame, L.dragFrames, cfg.inset , cfg.clamp)