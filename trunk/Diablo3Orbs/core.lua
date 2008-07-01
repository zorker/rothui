
function initDiabloHealth()
 diabloOrbHealth = diabloOrbHealth or CreateFrame("Frame", "diabloOrbHealth", UIParent)
 diabloOrbHealthBackground = diabloOrbHealthBackground or diabloOrbHealth:CreateTexture("diabloOrbHealthBackground", "BACKGROUND")
 diabloOrbHealthFilling = diabloOrbHealthFilling or diabloOrbHealth:CreateTexture("diabloOrbHealthFilling", "ARTWORK")
 diabloOrbHealthGloss = diabloOrbHealthGloss or diabloOrbHealth:CreateTexture("diabloOrbHealthGloss", "OVERLAY")
 diabloOrbHealth:SetWidth(180)
 diabloOrbHealth:SetHeight(180)

 
 diabloOrbHealthBackground:SetAllPoints(diabloOrbHealth)
 diabloOrbHealthFilling:SetPoint("BOTTOM", diabloOrbHealth, "BOTTOM", 0,0)
 diabloOrbHealthFilling:SetWidth(180)
 diabloOrbHealthFilling:SetHeight(180)
 diabloOrbHealthGloss:SetAllPoints(diabloOrbHealth)
 
 diabloOrbHealthBackground:SetTexture("Interface\\AddOns\\Diablo3Orbs\\Background.tga")
 diabloOrbHealthFilling:SetTexture("Interface\\AddOns\\Diablo3Orbs\\Filling.tga")
 diabloOrbHealthGloss:SetTexture("Interface\\AddOns\\Diablo3Orbs\\Gloss.tga")
 
 
 diabloOrbHealth:SetScript("OnEvent", function(frame, event, unit)
  if event == "UNIT_HEALTH" and unit == "player" then
   diabloOrbHealthFilling:SetHeight((UnitHealth("player") / UnitHealthMax("player")) * 180) -- the maximal height
   diabloOrbHealthFilling:SetTexCoord(0,1,  math.abs(UnitHealth("player") / UnitHealthMax("player") - 1),1)
  end
 end)
 diabloOrbHealth:RegisterEvent("UNIT_HEALTH")
 
 diabloOrbHealth:ClearAllPoints()
 diabloOrbHealth:SetPoint("BOTTOM",-280,-10)
end

 initDiabloHealth()