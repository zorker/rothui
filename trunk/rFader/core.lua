local hide = CreateFrame("Frame", nil, UIParent)

hide:RegisterEvent("PLAYER_REGEN_ENABLED")
hide:RegisterEvent("PLAYER_REGEN_DISABLED")
hide:RegisterEvent("PLAYER_ENTERING_WORLD")

hide:SetScript("OnEvent", function ()
  if event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_ENTERING_WORLD" then

    ShapeshiftBarFrame:SetAlpha(0)
    MultiBarRight:SetAlpha(0.5)
    MultiBarLeft:SetAlpha(0.5)
    MultiBarBottomLeft:SetAlpha(1)
    MultiBarBottomRight:SetAlpha(1)
    MainMenuBar:SetAlpha(1)
    BonusActionBarFrame:SetAlpha(1)
    rUnits_Player:SetAlpha(1)
    rUnits_Target:SetAlpha(1)
    rUnits_ToT:SetAlpha(1)

  elseif event == "PLAYER_REGEN_DISABLED" then

    ShapeshiftBarFrame:SetAlpha(0)
    MultiBarRight:SetAlpha(0)
    MultiBarLeft:SetAlpha(0)
    MultiBarBottomLeft:SetAlpha(1)
    MultiBarBottomRight:SetAlpha(1)
    MainMenuBar:SetAlpha(1)
    BonusActionBarFrame:SetAlpha(1)
    rUnits_Player:SetAlpha(1)
    rUnits_Target:SetAlpha(1)
    rUnits_ToT:SetAlpha(1)
    
  end
end)