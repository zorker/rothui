
-- rFilter_Zork: theme
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

--check if the button template addon and the action button config theme is available
if not rButtonTemplate or not rButtonTemplate_Zork_ActionButtonConfig then return end

-----------------------------
-- Actionbutton Config
-----------------------------

--load the default button theme
local actionButtonConfig = rLib.CopyTable(rButtonTemplate_Zork_ActionButtonConfig)

--name, we use the default actionbutton.name fontstring and use it as our duration fontstring
actionButtonConfig.name = {
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
actionButtonConfig.hotkey = {
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
actionButtonConfig.count = {
  font = { STANDARD_TEXT_FONT, 11, "OUTLINE"},
  points = {
    {"BOTTOMRIGHT", 0, 0 },
    {"BOTTOMLEFT", 0, 0 },
  },
  halign = "RIGHT",
  valign = "BOTTOM",
  alpha = 1,
}

-----------------------------
-- rButtonTemplate:StyleActionButton
-----------------------------

--Style every single button we created
local numBuffs, numDebuffs, numCooldowns = #L.buffs, #L.debuffs, #L.cooldowns
if numBuffs > 0 then
  for i, button in next, L.buffs do
    rButtonTemplate:StyleActionButton(button,actionButtonConfig)
  end
end
if numDebuffs > 0 then
  for i, button in next, L.debuffs do
    rButtonTemplate:StyleActionButton(button,actionButtonConfig)
  end
end
if numCooldowns > 0 then
  for i, button in next, L.cooldowns do
    rButtonTemplate:StyleActionButton(button,actionButtonConfig)
  end
end