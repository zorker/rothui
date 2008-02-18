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
  MainMenuBar:SetPoint("Bottom",0,10)
  --MainMenuBar:SetPoint("Bottom",0,0)
  
  
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
  MainMenuBarLeftEndCap:Hide()
  MainMenuBarRightEndCap:Hide()  

  --with this you could hide the main_bar_textures
  MainMenuBarTexture0:SetPoint("BOTTOM", "MainMenuBarArtFrame", "BOTTOM", -128, 0)
  MainMenuBarTexture1:SetPoint("BOTTOM", "MainMenuBarArtFrame", "BOTTOM", 128, 0)
  MainMenuBarTexture0:Hide()
  MainMenuBarTexture1:Hide()
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
  MainMenuBar:SetScale(0.8)
  BonusActionBarFrame:SetScale(1)
  MultiBarBottomLeft:SetScale(0.8)
  MultiBarBottomRight:SetScale(0.8)
  MultiBarRight:SetScale(0.8)
  MultiBarLeft:SetScale(0.8)
  
  -------------
  -- BUTTONS --
  -------------
  
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
    na:Hide()
    --cd:Hide()
    --fl:Hide()

    local te = bu:CreateTexture(name..i.."Overlay","Artwork")
    te:SetTexture("Interface\\Buttons\\UI-Quickslot2")
    te:SetPoint("TOPLEFT", nt, "TOPLEFT", 0, 0)
    te:SetPoint("BOTTOMRIGHT", nt, "BOTTOMRIGHT", 0, 0)

    ic:SetTexCoord(0.07,0.93,0.07,0.93)
  
  end
  
  addon:RegisterEvent"PLAYER_LOGIN"