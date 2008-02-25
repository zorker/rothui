local addon = CreateFrame"Frame"
local _G = getfenv(0)

  local dummy = function() end
  
  -- set shaftshift ON/OFF here !!!
  local set_shapeshift = 0

  -------------------------------------------------------
  -- put frames here that are blocked from moving
  --------------------------------------------------------
  UIPARENT_MANAGED_FRAME_POSITIONS["MultiBarRight"] = nil
  UIPARENT_MANAGED_FRAME_POSITIONS["MultiBarLeft"] = nil
  UIPARENT_MANAGED_FRAME_POSITIONS["MultiBarBottomLeft"] = nil
  UIPARENT_MANAGED_FRAME_POSITIONS["MultiBarBottomRight"] = nil
  UIPARENT_MANAGED_FRAME_POSITIONS["MainMenuBar"] = nil
    
  --[[
  UIPARENT_MANAGED_FRAME_POSITIONS["PetActionBarFrame"] = nil
  UIPARENT_MANAGED_FRAME_POSITIONS["ShapeshiftBarFrame"] = nil
  UIPARENT_MANAGED_FRAME_POSITIONS["PossessBarFrame"] = nil
  UIPARENT_MANAGED_FRAME_POSITIONS["CastingBarFrame"] = nil
  UIPARENT_MANAGED_FRAME_POSITIONS["MainMenuBarPerformanceBarFrame"] = nil
  UIPARENT_MANAGED_FRAME_POSITIONS["MainMenuBarPerformanceBarButton"] = nil
  UIPARENT_MANAGED_FRAME_POSITIONS["BonusActionBarFrame"] = nil
  ]]--
  
  
  --------------------------------------
  -- HIDE STUFF
  ---------------------------------------

  --cannot hide art frame it will hide the mainbar too..trying to repoint mainbar though...
  --MainMenuBarArtFrame:Hide()

	ShapeshiftBarLeft:Hide()
	ShapeshiftBarLeft.Show = dummy
	ShapeshiftBarMiddle:Hide()
	ShapeshiftBarMiddle.Show = dummy
	ShapeshiftBarRight:Hide()
	ShapeshiftBarRight.Show = dummy
	
	if set_shapeshift == 0 then
	  ShapeshiftBarFrame:Hide()
	  ShapeshiftBarFrame.Show = dummy
	end

  CharacterMicroButton:Hide()
  TalentMicroButton:Hide()
  TalentMicroButton.Show = dummy
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
  
  MainMenuExpBar:SetWidth(512)
  MainMenuExpBar:SetHeight(1)
  ReputationWatchBar:SetWidth(512)
  ReputationWatchBar:SetHeight(1)
  MainMenuBarMaxLevelBar:SetWidth(512)
  MainMenuBarMaxLevelBar:Hide()
  MainMenuBarMaxLevelBar.Show = dummy
  
  --hide XP BAR y/n
  MainMenuExpBar:Hide()
  MainMenuExpBar.Show = dummy

  --hide REP BAR y/n
  ReputationWatchBar:Hide()
  ReputationWatchBar.Show = dummy
  
  ExhaustionTick:Hide()
  ExhaustionTick.Show = dummy
  
  MainMenuBarPerformanceBarFrame:Hide()
  MainMenuBarPerformanceBarFrame.Show = dummy
  
  --------------------------------------------------
  -- Hide / Change Bar Textures
  -------------------------------------------------
  
  MainMenuBarLeftEndCap:SetPoint("BOTTOM", "MainMenuBarArtFrame", "BOTTOM", -290, 0)
  MainMenuBarRightEndCap:SetPoint("BOTTOM", "MainMenuBarArtFrame", "BOTTOM", 290, 0)
  
  --hide gryphons y/n
  MainMenuBarLeftEndCap:Hide()
  MainMenuBarRightEndCap:Hide()  

  --with this you could hide the main_bar_textures
  --MainMenuBarTexture0:SetPoint("BOTTOM", "MainMenuBarArtFrame", "BOTTOM", -128, 0)
  --MainMenuBarTexture1:SetPoint("BOTTOM", "MainMenuBarArtFrame", "BOTTOM", 128, 0)
  MainMenuBarTexture0:Hide()
  MainMenuBarTexture1:Hide()
  MainMenuBarTexture2:Hide()
  MainMenuBarTexture3:Hide()  
  
  -- with this you could hide warrior stance textures
  BonusActionBarTexture0:Hide()
  BonusActionBarTexture1:Hide()
  
  --hide max lvl texture
  MainMenuMaxLevelBar0:Hide()
  MainMenuMaxLevelBar1:Hide()
  MainMenuMaxLevelBar2:Hide()
  MainMenuMaxLevelBar3:Hide()
  
  -----------------------------------
  -- put bars to places
  -----------------------------------
  
  MainMenuBar:Show()
  MainMenuBar:SetWidth(512)
  MainMenuBar:SetFrameLevel(0)
  MainMenuBar:SetFrameStrata("BACKGROUND")
  MainMenuBar:SetPoint("Bottom",0,10)

  --fix the bug with the frame placement to make the bonusactionbar match the mainbar exactly
  BonusActionBarFrame:SetParent(UIParent)
  BonusActionButton1:ClearAllPoints()
  BonusActionButton1:SetPoint("BOTTOM",UIParent,"BOTTOM",-230,14);

  ActionButton7:ClearAllPoints()  
  ActionButton7:SetPoint("BOTTOMLEFT",ActionButton1,"TOPLEFT",0,5);
  
  BonusActionButton7:ClearAllPoints()  
  BonusActionButton7:SetPoint("BOTTOMLEFT",BonusActionButton1,"TOPLEFT",0,5);

  MultiBarBottomLeftButton1:ClearAllPoints()  
  MultiBarBottomLeftButton1:SetPoint("BOTTOMLEFT",ActionButton6,"BOTTOMRIGHT",5,0);

  MultiBarBottomLeftButton7:ClearAllPoints()  
  MultiBarBottomLeftButton7:SetPoint("BOTTOMLEFT",MultiBarBottomLeftButton1,"TOPLEFT",0,5);

  MultiBarBottomRightButton1:ClearAllPoints()  
  MultiBarBottomRightButton1:SetPoint("BOTTOMLEFT",ActionButton7,"TOPLEFT",0,15);

  MultiBarRight:ClearAllPoints()
  MultiBarRight:SetPoint("RIGHT",-15, 0)
  
  ShapeshiftButton1:ClearAllPoints()
  ShapeshiftButton1:SetPoint("BOTTOMLEFT",MultiBarBottomRightButton1,"TOPLEFT",5,15);

  PetActionButton1:ClearAllPoints()
  PetActionButton1:SetPoint("BOTTOMLEFT",MultiBarBottomRightButton1,"TOPLEFT",7,15);

  PossessButton1:ClearAllPoints()
  PossessButton1:SetPoint("BOTTOMLEFT",MultiBarBottomRightButton1,"TOPLEFT",5,15);
  

  -------------------------------
  -- Fix petbar, shapeshift look
  --------------------------------
  
  local j
  for j=1,10 do
    
    local bu = _G["PetActionButton"..j]
    local ic = _G["PetActionButton"..j.."Icon"]
    local bo = _G["PetActionButton"..j.."Border"]
    local fl = _G["PetActionButton"..j.."Flash"]
    local nt = _G["PetActionButton"..j.."NormalTexture2"]
    
    ic:SetTexCoord(0.1,0.9,0.1,0.9)
    ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 1, -1)
    ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -1, 1)

    nt:SetWidth(36)
    nt:SetHeight(36)
    nt:SetPoint("CENTER",bu,"CENTER",0,0)
    

  end
  
  local j
  for j=1,10 do
    
    local bu = _G["ShapeshiftButton"..j]
    local ic = _G["ShapeshiftButton"..j.."Icon"]
    local nt = _G["ShapeshiftButton"..j.."NormalTexture"]
    
    ic:SetTexCoord(0.1,0.9,0.1,0.9)
    ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 1, -1)
    ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -1, 1)
    nt:SetTexture("Interface\\AddOns\\rTextures\\gloss")
    nt:SetPoint("TOPLEFT", bu, "TOPLEFT", 0, 0)
    nt:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 0, 0)
    
  end
  
  -------------
  -- SCALE
  -------------
  
  local myscale = 0.8
  MainMenuBar:SetScale(myscale)
  BonusActionBarFrame:SetScale(myscale)
  MultiBarBottomLeft:SetScale(myscale)
  MultiBarBottomRight:SetScale(myscale)
  MultiBarRight:SetScale(myscale)
  MultiBarLeft:SetScale(myscale)
  PetActionBarFrame:SetScale(0.85)
  
  
  ------------------------------
  -- Change the Buttons
  ------------------------------
  
  local hooks = {};
  local range;

  hooks["ActionButton_OnUpdate"] = ActionButton_OnUpdate;
  
  ActionButton_OnUpdate = function(elapsed)
  
    if ( IsActionInRange(ActionButton_GetPagedID(this)) == 0) then
      getglobal(this:GetName().."Icon"):SetVertexColor(1,0,0);
      getglobal(this:GetName().."NormalTexture"):SetVertexColor(1,0,0);
      range = 1;
    else
      range = 0;
    end

    hooks["ActionButton_OnUpdate"](elapsed);
              
    if (this.range ~= range and range == 0) then
      ActionButton_UpdateUsable()
    end
    
    --some stuff to fix the hiding of the normaltexture
    getglobal(this:GetName().."NormalTexture"):SetTexture("Interface\\AddOns\\rTextures\\gloss")
    getglobal(this:GetName().."NormalTexture"):SetAlpha(1)
    getglobal(this:GetName().."NormalTexture"):Show()
    getglobal(this:GetName().."Border"):Hide()
    getglobal(this:GetName().."Name"):Hide()
    getglobal(this:GetName().."HotKey"):Hide()
    
    for j=1,10 do
      local nt = _G["PetActionButton"..j.."NormalTexture2"]
      nt:SetTexture("Interface\\AddOns\\rTextures\\gloss")
    end
    
    
    this.range = range;

  end
  

  -------------
  -- BUTTONS --
  -------------
  
  
  addon:SetScript("OnEvent", function()
    if(event=="PLAYER_LOGIN") then
      local j
      for j=1,12 do
        addon:makebuttongloss("ActionButton", j)
        addon:makebuttongloss("BonusActionButton", j)
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

    ho:Hide()
    na:Hide()

    nt:SetHeight(36)
    nt:SetWidth(36)
    nt:SetPoint("Center", 0, 0);

    ic:SetTexCoord(0.1,0.9,0.1,0.9)
    ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 2, -2)
    ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -2, 2)
  
  end
  
  
  
  
  addon:RegisterEvent"PLAYER_LOGIN"