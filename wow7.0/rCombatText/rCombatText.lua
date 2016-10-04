local size = 18

SystemFont_Shadow_Huge3:SetFont(STANDARD_TEXT_FONT, size, "OUTLINE")
SystemFont_Shadow_Huge3:SetShadowOffset(1,-1)
SystemFont_Shadow_Huge3:SetShadowColor(0,0,0,0.6)

COMBAT_TEXT_HEIGHT = size
COMBAT_TEXT_CRIT_MAXHEIGHT = size*1.8
COMBAT_TEXT_CRIT_MINHEIGHT = size*1.4
COMBAT_TEXT_SCROLLSPEED = 3.5

local function UpdateDisplayMessages()
  if COMBAT_TEXT_FLOAT_MODE == "1" then
    COMBAT_TEXT_LOCATIONS.startY = 350
    COMBAT_TEXT_LOCATIONS.endY = 550
  end
end

hooksecurefunc("CombatText_UpdateDisplayedMessages", UpdateDisplayMessages)