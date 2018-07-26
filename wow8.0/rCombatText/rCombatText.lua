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
COMBAT_TEXT_Y_SCALE = 1.1