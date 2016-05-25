
-- rActionBar: micromenu
-- zork, 2016

-----------------------------
-- Config
-----------------------------

local cfg = {}
--frame settings
cfg.scale     = 0.8
cfg.inset     = -2
cfg.clamp     = true
cfg.pos       = { a1 = "TOP", a2 = "TOP", af = UIParent, x = 0, y = -10 }
--button settings
cfg.width     = CharacterMicroButton:GetWidth()
cfg.height    = CharacterMicroButton:GetHeight()/1.55
cfg.margin    = -4.5

-----------------------------
-- Variables
-----------------------------

local A, L = ...

--button list
local buttonList = {}
for idx, buttonName in next, MICRO_BUTTONS do
  local button = _G[buttonName]
  if button then
    table.insert(buttonList, button)
  end
end
--num_buttons
local num_buttons = # buttonList

-----------------------------
-- Init
-----------------------------

--create new parent frame
local frame = CreateFrame("Frame", "rABS_MicroMenu", UIParent, "SecureHandlerStateTemplate")
frame:SetWidth(num_buttons*cfg.width+(num_buttons-1)*cfg.margin)
frame:SetHeight(cfg.height)
frame:SetPoint(cfg.pos.a1,cfg.pos.af,cfg.pos.a2,cfg.pos.x,cfg.pos.y)
frame:SetScale(cfg.scale)

--reparent all buttons
for idx, button in next, buttonList do
  button:SetParent(frame)
end

--repoint the first button
CharacterMicroButton:ClearAllPoints();
CharacterMicroButton:SetPoint("BOTTOMLEFT")

--disable reanchoring of the micro menu by the petbattle ui
PetBattleFrame.BottomFrame.MicroButtonFrame:SetScript("OnShow", nil) --remove the onshow script

--show/hide the frame on a given state driver
RegisterStateDriver(frame, "visibility", "[petbattle] hide; show")

--add drag functions
rLib:CreateDragFrame(frame, L.dragFrames, cfg.inset , cfg.clamp)
