
-- rActionBar: bags
-- zork, 2016

-----------------------------
-- Config
-----------------------------

local cfg = {}
--frame settings
cfg.scale     = 1
cfg.inset     = -2
cfg.clamp     = true
cfg.pos       = { a1 = "BOTTOMRIGHT", a2 = "BOTTOMRIGHT", af = UIParent, x = -10, y = 10 }
--button settings
cfg.width     = MainMenuBarBackpackButton:GetWidth()
cfg.height    = MainMenuBarBackpackButton:GetHeight()
cfg.margin    = 2

-----------------------------
-- Local Variables
-----------------------------

local A, L = ...

--button list
local buttonList = {
  MainMenuBarBackpackButton,
  CharacterBag0Slot,
  CharacterBag1Slot,
  CharacterBag2Slot,
  CharacterBag3Slot
}
--num_buttons
local num_buttons = # buttonList

-----------------------------
-- Init
-----------------------------

--create new parent frame
local frame = CreateFrame("Frame", "rABS_BagFrame", UIParent, "SecureHandlerStateTemplate")
frame:SetWidth(num_buttons*cfg.width+(num_buttons-1)*cfg.margin)
frame:SetHeight(cfg.height)
frame:SetPoint(cfg.pos.a1,cfg.pos.af,cfg.pos.a2,cfg.pos.x,cfg.pos.y)
frame:SetScale(cfg.scale)

--reparent all buttons
for idx, button in next, buttonList do
  button:SetParent(frame)
end

--repoint the first button
MainMenuBarBackpackButton:ClearAllPoints();
MainMenuBarBackpackButton:SetPoint("RIGHT")

--show/hide the frame on a given state driver
RegisterStateDriver(frame, "visibility", "[petbattle] hide; show")

--add drag functions
rLib:CreateDragFrame(frame, L.dragFrames, cfg.inset , cfg.clamp)
