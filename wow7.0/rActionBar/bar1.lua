
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
cfg.pos       = { a1 = "BOTTOM", a2 = "BOTTOM", af = UIParent, x = 0, y = 30 }
--button settings
cfg.width     = 32
cfg.height    = 32
cfg.margin    = 5

-----------------------------
-- Local Variables
-----------------------------

local A, L = ...

--num_buttons
local num_buttons = NUM_ACTIONBAR_BUTTONS
--button list
local buttonList = {}
local buttonName = "ActionButton"

-----------------------------
-- Init
-----------------------------

--create new parent frame
local frame = CreateFrame("Frame", "rABS_MainMenuBar", UIParent, "SecureHandlerStateTemplate")
frame:SetWidth(num_buttons*cfg.width+(num_buttons-1)*cfg.margin+2*cfg.padding)
frame:SetHeight(cfg.height+2*cfg.padding)
frame:SetPoint(cfg.pos.a1,cfg.pos.af,cfg.pos.a2,cfg.pos.x,cfg.pos.y)
frame:SetScale(cfg.scale)

--reparent the MainMenuBarArtFrame frame
MainMenuBarArtFrame:SetParent(frame)
MainMenuBarArtFrame:EnableMouse(false)

--repoint all buttons
for i=1, num_buttons do
  local button = _G[buttonName..i]
  table.insert(buttonList, button)
  button:SetSize(cfg.width, cfg.height)
  button:ClearAllPoints()
  if i == 1 then
    button:SetPoint("BOTTOMLEFT", frame, cfg.padding, cfg.padding)
  else
    button:SetPoint("LEFT", _G[buttonName..i-1], "RIGHT", cfg.margin, 0)
  end
end

--show/hide the frame on a given state driver
RegisterStateDriver(frame, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show")

--add drag functions
rLib:CreateDragFrame(frame, L.dragFrames, cfg.inset , cfg.clamp)