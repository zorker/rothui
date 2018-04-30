local size = 16

CombatTextFont:SetFont(STANDARD_TEXT_FONT, size, "OUTLINE")
CombatTextFont:SetShadowOffset(1,-1)
CombatTextFont:SetShadowColor(0,0,0,0.6)

CombatTextFontOutline:SetFont(STANDARD_TEXT_FONT, size, "OUTLINE")
CombatTextFontOutline:SetShadowOffset(1,-1)
CombatTextFontOutline:SetShadowColor(0,0,0,0.6)

COMBAT_TEXT_HEIGHT = size
COMBAT_TEXT_CRIT_MAXHEIGHT = size*1
COMBAT_TEXT_CRIT_MINHEIGHT = size*1
COMBAT_TEXT_SCROLLSPEED = 2.5

local function UpdateDisplayMessages()
  if COMBAT_TEXT_FLOAT_MODE == "1" then
    COMBAT_TEXT_LOCATIONS.startY = 325
    COMBAT_TEXT_LOCATIONS.endY = 525
  end
end

hooksecurefunc("CombatText_UpdateDisplayedMessages", UpdateDisplayMessages)