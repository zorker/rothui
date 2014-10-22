LoadAddOn("Blizzard_CombatText")

DAMAGE_TEXT_FONT = "Fonts\\DAMAGE.ttf"

SystemFont_Shadow_Huge3:SetFont(STANDARD_TEXT_FONT, 16, "OUTLINE")
SystemFont_Shadow_Huge3:SetShadowOffset(1,-1)
SystemFont_Shadow_Huge3:SetShadowColor(0,0,0,0.6)

COMBAT_TEXT_HEIGHT = 16
COMBAT_TEXT_CRIT_MAXHEIGHT = 24
COMBAT_TEXT_CRIT_MINHEIGHT = 16
COMBAT_TEXT_SCROLLSPEED = 3

hooksecurefunc("CombatText_UpdateDisplayedMessages", function() 
  if COMBAT_TEXT_FLOAT_MODE == "1" then
    COMBAT_TEXT_LOCATIONS.startY = 484
    COMBAT_TEXT_LOCATIONS.endY = 709
  end
end)


