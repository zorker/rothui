
function initDiabloHealth()
 diabloOrbHealth = diabloOrbHealth or CreateFrame("Frame", "diabloOrbHealth", UIParent)
 diabloOrbHealthBackground = diabloOrbHealthBackground or diabloOrbHealth:CreateTexture("diabloOrbHealthBackground", "BACKGROUND")
 diabloOrbHealthFilling = diabloOrbHealthFilling or diabloOrbHealth:CreateTexture("diabloOrbHealthFilling", "ARTWORK")
 diabloOrbHealthGloss = diabloOrbHealthGloss or diabloOrbHealth:CreateTexture("diabloOrbHealthGloss", "OVERLAY")
 diabloOrbHealth:SetWidth(120)
 diabloOrbHealth:SetHeight(120)

 
 diabloOrbHealthBackground:SetAllPoints(diabloOrbHealth)
 diabloOrbHealthFilling:SetPoint("BOTTOM", diabloOrbHealth, "BOTTOM", 0,0)
 diabloOrbHealthFilling:SetWidth(120)
 diabloOrbHealthFilling:SetHeight(120)
 diabloOrbHealthGloss:SetAllPoints(diabloOrbHealth)
 
 diabloOrbHealthBackground:SetTexture("Interface\\AddOns\\Diablo3Orbs\\Background.tga")
 --diabloOrbHealthFilling:SetTexture("Interface\\AddOns\\Diablo3Orbs\\Filling.tga")
 diabloOrbHealthGloss:SetTexture("Interface\\AddOns\\Diablo3Orbs\\Gloss.tga")

  diabloOrbHealthFilling:SetVertexColor(1,0,0)
 
  local totalElapsed = 0
  local counter = 0
  local modifier = 100
  
  --update_timer = TIME IN SEC before update. BE CAREFUL HERE!
  local update_timer = 2
  
  local function OnUpdateFunc(self, elapsed)
    totalElapsed = totalElapsed + elapsed * modifier
    local update_me = update_timer * modifier
    if (totalElapsed < update_me) then 
      return 
    else
      totalElapsed = totalElapsed - floor(totalElapsed)
      --totalElapsed = 0
      diabloOrbHealthFilling:SetTexture("Interface\\AddOns\\Diablo3Orbs\\d3orbanimation\\d3_orb_ani_frame"..counter..".tga")
      counter = counter+1
      if counter > 24 then
        counter = 0
      end
    end
  end
  diabloOrbHealth:SetScript("OnUpdate", OnUpdateFunc)
 
 diabloOrbHealth:SetScript("OnEvent", function(frame, event, unit)
  if event == "UNIT_HEALTH" and unit == "player" then
   diabloOrbHealthFilling:SetHeight((UnitHealth("player") / UnitHealthMax("player")) * 120) -- the maximal height
   diabloOrbHealthFilling:SetTexCoord(0,1,  math.abs(UnitHealth("player") / UnitHealthMax("player") - 1),1)
  end
 end)
 diabloOrbHealth:RegisterEvent("UNIT_HEALTH")
 
 diabloOrbHealth:ClearAllPoints()
 diabloOrbHealth:SetPoint("BOTTOM",-218,-2)
 --diabloOrbHealth:SetAlpha(0.8)
end

 initDiabloHealth()
 
function initDiabloMana()
 diabloOrbMana = diabloOrbMana or CreateFrame("Frame", "diabloOrbMana", UIParent)
 diabloOrbManaBackground = diabloOrbManaBackground or diabloOrbMana:CreateTexture("diabloOrbManaBackground", "BACKGROUND")
 diabloOrbManaFilling = diabloOrbManaFilling or diabloOrbMana:CreateTexture("diabloOrbManaFilling", "ARTWORK")
 diabloOrbManaGloss = diabloOrbManaGloss or diabloOrbMana:CreateTexture("diabloOrbManaGloss", "OVERLAY")
 diabloOrbMana:SetWidth(120)
 diabloOrbMana:SetHeight(120)

 
 diabloOrbManaBackground:SetAllPoints(diabloOrbMana)
 diabloOrbManaFilling:SetPoint("BOTTOM", diabloOrbMana, "BOTTOM", 0,0)
 diabloOrbManaFilling:SetWidth(120)
 diabloOrbManaFilling:SetHeight(120)
 diabloOrbManaGloss:SetAllPoints(diabloOrbMana)
 
 diabloOrbManaBackground:SetTexture("Interface\\AddOns\\Diablo3Orbs\\Background.tga")
 --diabloOrbManaFilling:SetTexture("Interface\\AddOns\\Diablo3Orbs\\FillingMana.tga")
 diabloOrbManaGloss:SetTexture("Interface\\AddOns\\Diablo3Orbs\\Gloss.tga")
 
  diabloOrbManaFilling:SetVertexColor(0,0.7,1)
 
  local totalElapsed = 0
  local counter = 13
  local modifier = 100
  local modifier = 100
  
  --update_timer = TIME IN SEC before update. BE CAREFUL HERE!
  local update_timer = 2
  
  local function OnUpdateFunc(self, elapsed)
    totalElapsed = totalElapsed + elapsed*modifier
    local update_me = update_timer * modifier
    if (totalElapsed < update_me) then 
      return 
    else
      totalElapsed = totalElapsed - floor(totalElapsed)
      --totalElapsed = 0
      diabloOrbManaFilling:SetTexture("Interface\\AddOns\\Diablo3Orbs\\d3orbanimation\\d3_orb_ani_frame"..counter..".tga")
      counter = counter+1
      if counter > 24 then
        counter = 0
      end
    end
  end
  diabloOrbMana:SetScript("OnUpdate", OnUpdateFunc)
 
 diabloOrbMana:SetScript("OnEvent", function(frame, event, unit)
  if (event == "UNIT_MANA" or event == "UNIT_RAGE" or event == "UNIT_ENERGY") and unit == "player" then
   --DEFAULT_CHAT_FRAME:AddMessage("found "..rf2_player_name.." : "..rf2_player_class)
   diabloOrbManaFilling:SetHeight((UnitMana("player") / UnitManaMax("player")) * 120) -- the maximal height
   diabloOrbManaFilling:SetTexCoord(0,1,  math.abs(UnitMana("player") / UnitManaMax("player") - 1),1)
  end
 end)
 diabloOrbMana:RegisterEvent("UNIT_MANA")
 diabloOrbMana:RegisterEvent("UNIT_RAGE")
 diabloOrbMana:RegisterEvent("UNIT_ENERGY")
 
 diabloOrbMana:ClearAllPoints()
 diabloOrbMana:SetPoint("BOTTOM",218,-2)
 --diabloOrbMana:SetAlpha(0.8)
end

 initDiabloMana()