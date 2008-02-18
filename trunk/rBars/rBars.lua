local addon = CreateFrame"Frame"
local _G = getfenv(0)

  local dummy = function() end

  --important or you CANNOT move the bars!!!
  UIPARENT_MANAGED_FRAME_POSITIONS["PetActionBarFrame"] = nil
  UIPARENT_MANAGED_FRAME_POSITIONS["ShapeshiftBarFrame"] = nil
  UIPARENT_MANAGED_FRAME_POSITIONS["PossessBarFrame"] = nil
  UIPARENT_MANAGED_FRAME_POSITIONS["CastingBarFrame"] = nil
  UIPARENT_MANAGED_FRAME_POSITIONS["MultiBarBottomLeft"] = nil
  UIPARENT_MANAGED_FRAME_POSITIONS["MultiBarBottomRight"] = nil
  UIPARENT_MANAGED_FRAME_POSITIONS["MainMenuBar"] = nil
  UIPARENT_MANAGED_FRAME_POSITIONS["BonusActionBarFrame"] = nil
  UIPARENT_MANAGED_FRAME_POSITIONS["MultiBarRight"] = nil
  UIPARENT_MANAGED_FRAME_POSITIONS["MultiBarLeft"] = nil
  
  MainMenuBar:Show()
  MainMenuBar:SetWidth(512)
  MainMenuBar:SetFrameLevel(0)
  MainMenuBar:SetFrameStrata("BACKGROUND")
  --MainMenuBar:SetPoint("Bottom",0,10)
  MainMenuBar:SetPoint("Bottom",0,0)
  
  
  MainMenuBarMaxLevelBar:SetWidth(512)
  
  --MainMenuBarArtFrame:Hide()

  CharacterMicroButton:Hide()
  TalentMicroButton:Hide()
  CharacterMicroButton:Hide()
  SpellbookMicroButton:Hide()
  QuestLogMicroButton:Hide()
  SocialsMicroButton:Hide()
  MainMenuMicroButton:Hide()
  HelpMicroButton:Hide()
  LFGMicroButton:Hide()

  MainMenuBarBackpackButton:Hide()
  CharacterBag0Slot:Hide()
  CharacterBag1Slot:Hide()
  CharacterBag2Slot:Hide()
  CharacterBag3Slot:Hide()

  MainMenuBarPageNumber:Hide()
  ActionBarUpButton:Hide()
  ActionBarDownButton:Hide()
  KeyRingButton:Disable()
  KeyRingButton:DisableDrawLayer()
  KeyRingButton:Hide()
  
  MainMenuBarLeftEndCap:SetPoint("BOTTOM", "MainMenuBarArtFrame", "BOTTOM", -290, 0)
  MainMenuBarRightEndCap:SetPoint("BOTTOM", "MainMenuBarArtFrame", "BOTTOM", 290, 0)
  
  
  --hide gryphons y/n
  --MainMenuBarLeftEndCap:Hide()
  --MainMenuBarRightEndCap:Hide()  

  --with this you could hide the main_bar_textures
  MainMenuBarTexture0:SetPoint("BOTTOM", "MainMenuBarArtFrame", "BOTTOM", -128, 0)
  MainMenuBarTexture1:SetPoint("BOTTOM", "MainMenuBarArtFrame", "BOTTOM", 128, 0)
  --MainMenuBarTexture0:Hide()
  --MainMenuBarTexture1:Hide()
  MainMenuBarTexture2:Hide()
  MainMenuBarTexture3:Hide()  
  
  -- with this you could hide warrior stance textures
  BonusActionBarTexture0:Hide()
  BonusActionBarTexture1:Hide()
  
  MainMenuExpBar:SetWidth(512)
  MainMenuExpBar:SetHeight(1)
  ReputationWatchBar:SetWidth(512)
  ReputationWatchBar:SetHeight(1)
  
  --hide XP BAR y/n
  MainMenuExpBar:Hide()
  MainMenuExpBar.Show = dummy

  --hide REP BAR y/n
  ReputationWatchBar:Hide()
  ReputationWatchBar.Show = dummy
  
  ExhaustionTick:Hide()
  ExhaustionTick.Show = dummy
  
  --Put Performanceframe to the right  
  MainMenuBarPerformanceBarFrame:SetParent(UIParent)
  MainMenuBarPerformanceBarFrame:SetPoint("BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", 0, -5)
  
  --put the multibars to places
  MultiBarBottomLeft:ClearAllPoints()
  MultiBarBottomLeft:SetPoint("BOTTOMLEFT", "MainMenuBar", "TOPLEFT", 8,-6)
  MultiBarBottomRight:ClearAllPoints()
  MultiBarBottomRight:SetPoint("BOTTOMLEFT", "MultiBarBottomLeft", "TOPLEFT", 0,10)
  ShapeshiftBarFrame:ClearAllPoints()
  ShapeshiftBarFrame:SetPoint("BOTTOMLEFT", MultiBarBottomRightButton1, "TOPLEFT", -10, 7)
  PetActionBarFrame:ClearAllPoints()
  PetActionBarFrame:SetPoint("BOTTOMLEFT", MultiBarBottomRightButton1, "TOPLEFT", -10, 7)
  PossessBarFrame:ClearAllPoints()
  PossessBarFrame:SetPoint("BOTTOMLEFT", MultiBarBottomRightButton1, "TOPLEFT", -10, 7)

  MultiBarRight:ClearAllPoints()
  MultiBarRight:SetPoint("RIGHT",-10, 0)

  --bonusactionbarframe ... frame shows warrior stances...
  BonusActionBarFrame:Hide()
  BonusActionBarFrame.Show = dummy
  
  --SCALE
  --MainMenuBar:SetScale(0.8)
  --BonusActionBarFrame:SetScale(1)
  --MultiBarBottomLeft:SetScale(0.8)
  --MultiBarBottomRight:SetScale(0.8)

  --MultiBarRight:SetScale(0.8)
  --MultiBarLeft:SetScale(0.8)
  
  -------------
  -- BUTTONS --
  -------------
  
  --[[
  addon:SetScript("OnEvent", function()
    if(event=="PLAYER_LOGIN") then
      local j
      for j=1,12 do
        addon:makebuttongloss("ActionButton", j)
        addon:makebuttongloss("MultiBarBottomRightButton", j)
        addon:makebuttongloss("MultiBarBottomLeftButton", j)
        addon:makebuttongloss("MultiBarLeftButton", j)
        addon:makebuttongloss("MultiBarRightButton", j)
    	end
    	
    end
  end)
  
  ]]--
  
  local Button = _G["MultiBarBottomRightButton12"]
  
  DEFAULT_CHAT_FRAME:AddMessage("GetButtonState "..Button:GetButtonState())
  --DEFAULT_CHAT_FRAME:AddMessage("GetDisabledFontObject "..Button:GetDisabledFontObject())
  --DEFAULT_CHAT_FRAME:AddMessage("GetDisabledTextColor "..Button:GetDisabledTextColor())
  --DEFAULT_CHAT_FRAME:AddMessage("GetDisabledTexture "..Button:GetDisabledTexture())
  --DEFAULT_CHAT_FRAME:AddMessage("GetFont "..Button:GetFont())
  --DEFAULT_CHAT_FRAME:AddMessage("GetFontString "..Button:GetFontString())
  --DEFAULT_CHAT_FRAME:AddMessage("GetHighlightFontObject "..Button:GetHighlightFontObject())
  --DEFAULT_CHAT_FRAME:AddMessage("GetHighlightTextColor "..Button:GetHighlightTextColor())
  --DEFAULT_CHAT_FRAME:AddMessage("GetHighlightTexture "..Button:GetHighlightTexture())
  --DEFAULT_CHAT_FRAME:AddMessage("GetNormalTexture "..Button:GetNormalTexture())
  DEFAULT_CHAT_FRAME:AddMessage("GetPushedTextOffset "..Button:GetPushedTextOffset())
  --DEFAULT_CHAT_FRAME:AddMessage("GetPushedTexture "..Button:GetPushedTexture())
  --DEFAULT_CHAT_FRAME:AddMessage("GetText "..Button:GetText())
  --DEFAULT_CHAT_FRAME:AddMessage("GetTextColor "..Button:GetTextColor())
  --DEFAULT_CHAT_FRAME:AddMessage("GetTextFontObject "..Button:GetTextFontObject())
  DEFAULT_CHAT_FRAME:AddMessage("GetTextHeight "..Button:GetTextHeight())
  DEFAULT_CHAT_FRAME:AddMessage("GetTextWidth "..Button:GetTextWidth())  
  
  --Button:SetPushedTextOffset(0,0)
  --DEFAULT_CHAT_FRAME:AddMessage("GetPushedTextOffset "..Button:GetPushedTextOffset())
  
  DEFAULT_CHAT_FRAME:AddMessage("GetBottom "..Button:GetBottom())  
  DEFAULT_CHAT_FRAME:AddMessage("GetCenter "..Button:GetCenter())  
  DEFAULT_CHAT_FRAME:AddMessage("GetHeight "..Button:GetHeight())  
  DEFAULT_CHAT_FRAME:AddMessage("GetLeft "..Button:GetLeft())  
  DEFAULT_CHAT_FRAME:AddMessage("GetNumPoints "..Button:GetNumPoints())  
  DEFAULT_CHAT_FRAME:AddMessage("GetPoint "..Button:GetPoint())  
  DEFAULT_CHAT_FRAME:AddMessage("GetRight "..Button:GetRight())  
  DEFAULT_CHAT_FRAME:AddMessage("GetTop "..Button:GetTop())  
  DEFAULT_CHAT_FRAME:AddMessage("GetWidth "..Button:GetWidth())

  DEFAULT_CHAT_FRAME:AddMessage("GetAlpha "..Button:GetAlpha())  
  DEFAULT_CHAT_FRAME:AddMessage("GetName "..Button:GetName())  
  DEFAULT_CHAT_FRAME:AddMessage("GetObjectType "..Button:GetObjectType())
  
  --DEFAULT_CHAT_FRAME:AddMessage("GetAttribute "..Button:GetAttribute("name"))
  --DEFAULT_CHAT_FRAME:AddMessage("GetBackdrop "..Button:GetBackdrop())
  --DEFAULT_CHAT_FRAME:AddMessage("GetBackdropBorderColor "..Button:GetBackdropBorderColor())
  --DEFAULT_CHAT_FRAME:AddMessage("GetBackdropColor "..Button:GetBackdropColor())
  
  DEFAULT_CHAT_FRAME:AddMessage("GetClampRectInsets "..Button:GetClampRectInsets())
  DEFAULT_CHAT_FRAME:AddMessage("GetEffectiveAlpha "..Button:GetEffectiveAlpha())
  DEFAULT_CHAT_FRAME:AddMessage("GetEffectiveScale "..Button:GetEffectiveScale())
  DEFAULT_CHAT_FRAME:AddMessage("GetFrameLevel "..Button:GetFrameLevel())
  DEFAULT_CHAT_FRAME:AddMessage("GetFrameStrata "..Button:GetFrameStrata())
  DEFAULT_CHAT_FRAME:AddMessage("GetFrameType "..Button:GetFrameType())
  DEFAULT_CHAT_FRAME:AddMessage("GetHitRectInsets "..Button:GetHitRectInsets())
  DEFAULT_CHAT_FRAME:AddMessage("GetID "..Button:GetID())
  DEFAULT_CHAT_FRAME:AddMessage("GetMaxResize "..Button:GetMaxResize())
  DEFAULT_CHAT_FRAME:AddMessage("GetMinResize "..Button:GetMinResize())
  DEFAULT_CHAT_FRAME:AddMessage("GetNumChildren "..Button:GetNumChildren())
  DEFAULT_CHAT_FRAME:AddMessage("GetNumRegions "..Button:GetNumRegions())
  DEFAULT_CHAT_FRAME:AddMessage("GetScale "..Button:GetScale())
  --DEFAULT_CHAT_FRAME:AddMessage("GetScript "..Button:GetScript())
  --DEFAULT_CHAT_FRAME:AddMessage("GetTitleRegion "..Button:GetTitleRegion())

  parent1 = Button:GetParent()
  DEFAULT_CHAT_FRAME:AddMessage("parent1 "..parent1:GetName())

  child1 = Button:GetChildren()
  DEFAULT_CHAT_FRAME:AddMessage("child1 "..child1:GetName())

  region1, region2, region3, region4, region5, region6, region7, region8, region9, region10 = Button:GetRegions()
  DEFAULT_CHAT_FRAME:AddMessage("region1 "..region1:GetName())
  DEFAULT_CHAT_FRAME:AddMessage("region2 "..region2:GetName())
  DEFAULT_CHAT_FRAME:AddMessage("region3 "..region3:GetName())
  DEFAULT_CHAT_FRAME:AddMessage("region4 "..region4:GetName())
  DEFAULT_CHAT_FRAME:AddMessage("region5 "..region5:GetName())
  DEFAULT_CHAT_FRAME:AddMessage("region6 "..region6:GetName())
  DEFAULT_CHAT_FRAME:AddMessage("region7 "..region7:GetName())
  if region8:GetName() then DEFAULT_CHAT_FRAME:AddMessage("region8 "..region8:GetName()) end
  if region9:GetName() then DEFAULT_CHAT_FRAME:AddMessage("region9 "..region8:GetName()) end
  if region10:GetName() then DEFAULT_CHAT_FRAME:AddMessage("region10 "..region8:GetName()) end




  function addon:makebuttongloss(name, i)
  
    local bu  = _G[name..i]
    local ic  = _G[name..i.."Icon"]
    local co  = _G[name..i.."Count"]
    local bo  = _G[name..i.."Border"]
    local ho  = _G[name..i.."HotKey"]
    local cd  = _G[name..i.."Cooldown"]
    local na  = _G[name..i.."Name"]
    local fl  = _G[name..i.."Flash"]
    local nt  = _G[name..i.."NormalTexture"]
     
    bo:Hide()
    ho:Hide()
    cd:Hide()
    na:Hide()
    fl:Hide()
    nt:Hide()
    nt:SetAlpha(0)
    nt:SetWidth(1)
    nt:SetHeight(1)
    
    local te = bu:CreateTexture(name..i.."Overlay","Artwork")
    te:SetTexture("Interface\\AddOns\\rTextures\\simpleSquareGloss")
    te:SetPoint("TOPLEFT", bu, "TOPLEFT", -0, 0)
    te:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 0, -0)
    --te:SetVertexColor(0.8, 0.8, 0.8)
    
    bu:SetPushedTexture("Interface\\AddOns\\rTextures\\simpleSquareGloss")
    bu:SetHighlightTexture("Interface\\AddOns\\rTextures\\simpleSquareHighlight")
    
    ic:SetTexCoord(0.07,0.93,0.07,0.93)
    ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 3, -3)
    ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -3, 3)
  
  end
  
  addon:RegisterEvent"PLAYER_LOGIN"