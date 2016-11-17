
-- rFilterConfig: actionbutton
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Actionbutton Config
-----------------------------

--mediapath
local mediapath = "interface\\addons\\"..A.."\\media\\"

--time between updates
--L.C.tick = 0.1 --default is 0.1

--Load the default button theme
L.C.actionButtonConfig = rLib.CopyTable(rButtonTemplate_Zork_ActionButtonConfig)

--name, we use the default actionbutton.name fontstring and use it as our duration fontstring
L.C.actionButtonConfig.name = {
  font = { STANDARD_TEXT_FONT, 13, "OUTLINE"},
  points = {
    {"LEFT", 0, 0 },
    {"RIGHT", 0, 0 },
  },
  halign = "CENTER",
  valign = "MIDDLE",
  alpha = 1,
}

--hotkey, we use the default actionbutton.hotkey fontstring and use it as our extra value fontstring (100k absorb shield etc.)
L.C.actionButtonConfig.hotkey = {
  font = { STANDARD_TEXT_FONT, 11, "OUTLINE"},
  points = {
    {"TOPRIGHT", 0, 0 },
    {"BOTTOMLEFT", 0, 0 },
  },
  halign = "RIGHT",
  valign = "TOP",
  alpha = 1,
}

--count, aura stack count
L.C.actionButtonConfig.count = {
  font = { STANDARD_TEXT_FONT, 11, "OUTLINE"},
  points = {
    {"BOTTOMRIGHT", 0, 0 },
    {"BOTTOMLEFT", 0, 0 },
  },
  halign = "RIGHT",
  valign = "BOTTOM",
  alpha = 1,
}