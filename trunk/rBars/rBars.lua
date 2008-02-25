local addon = CreateFrame"Frame"
local _G = getfenv(0)

  local dummy = function() end

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
	
	ShapeshiftBarFrame:Hide()
	ShapeshiftBarFrame.Show = dummy

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
  
  MultiBarBottomLeft:ClearAllPoints()
  MultiBarBottomLeft:SetPoint("BOTTOMLEFT", "MainMenuBar", "TOPLEFT", 8,-6)
  
  MultiBarBottomRight:ClearAllPoints()
  MultiBarBottomRight:SetPoint("BOTTOMLEFT", "MultiBarBottomLeft", "TOPLEFT", 0,15)

  MultiBarRight:ClearAllPoints()
  MultiBarRight:SetPoint("RIGHT",-15, 0)
  
  ShapeshiftBarFrame:ClearAllPoints()
  ShapeshiftBarFrame:SetPoint("BOTTOMLEFT", MultiBarBottomRightButton1, "TOPLEFT", -10, 7)
  
  PetActionBarFrame:ClearAllPoints()
  PetActionBarFrame:SetPoint("BOTTOMLEFT", MultiBarBottomRight, "TOPLEFT", -10, 7)
  
  PossessBarFrame:ClearAllPoints()
  PossessBarFrame:SetPoint("BOTTOMLEFT", MultiBarBottomRight, "TOPLEFT", -10, 7)

  --fix the bug with the frame placement to make the bonusactionbar match the mainbar exactly
  BonusActionBarFrame:SetParent(UIParent)
  BonusActionButton1:ClearAllPoints()
  BonusActionButton1:SetPoint("BOTTOM",UIParent,"BOTTOM",-230,14);

  -------------------------------
  -- Fix petbar look
  --------------------------------
  
  getglobal("PetActionButton1Icon"):SetTexCoord(0.1,0.9,0.1,0.9)
  getglobal("PetActionButton2Icon"):SetTexCoord(0.1,0.9,0.1,0.9)
  getglobal("PetActionButton3Icon"):SetTexCoord(0.1,0.9,0.1,0.9)
  getglobal("PetActionButton4Icon"):SetTexCoord(0.1,0.9,0.1,0.9)
  getglobal("PetActionButton5Icon"):SetTexCoord(0.1,0.9,0.1,0.9)
  getglobal("PetActionButton6Icon"):SetTexCoord(0.1,0.9,0.1,0.9)
  getglobal("PetActionButton7Icon"):SetTexCoord(0.1,0.9,0.1,0.9)
  getglobal("PetActionButton8Icon"):SetTexCoord(0.1,0.9,0.1,0.9)
  getglobal("PetActionButton9Icon"):SetTexCoord(0.1,0.9,0.1,0.9)
  getglobal("PetActionButton10Icon"):SetTexCoord(0.1,0.9,0.1,0.9)

  
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
  
  
  ------------------------------
  -- Change the Buttons
  ------------------------------
  
  local hooks = {};
  local range;
  local pb = MainMenuBarPerformanceBarFrame

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
    
    --do some nice stuff with the barbuttons
    getglobal(this:GetName().."NormalTexture"):SetAlpha(1)
    --width and height fix to make the NT use my 64x64px textures
    getglobal(this:GetName().."NormalTexture"):SetHeight(36)
    getglobal(this:GetName().."NormalTexture"):SetWidth(36)
    getglobal(this:GetName().."NormalTexture"):SetPoint("Center", 0, 0);
    getglobal(this:GetName().."Border"):Hide()
    getglobal(this:GetName().."NormalTexture"):Show()
    getglobal(this:GetName().."NormalTexture"):SetTexture("Interface\\AddOns\\rTextures\\gloss")
    getglobal(this:GetName().."Icon"):SetTexCoord(0.1,0.9,0.1,0.9)
    getglobal(this:GetName().."Icon"):SetPoint("TOPLEFT", getglobal(this:GetName()), "TOPLEFT", 2, -2)
    getglobal(this:GetName().."Icon"):SetPoint("BOTTOMRIGHT", getglobal(this:GetName()), "BOTTOMRIGHT", -2, 2)
    getglobal(this:GetName().."Name"):Hide()
    getglobal(this:GetName().."HotKey"):Hide()
    
    --this must be done because the blizzard ui tries to replace the performance button all the time :/ 
    pb:SetParent(UIParent)
    pb:ClearAllPoints()
    pb:SetPoint("BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -13, 15)

    this.range = range;

  end
  
  
  -------------
  -- BUTTONS --
  -------------
  
  --[[
  
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
    
    bo:Hide()
    ho:Hide()
    na:Hide()

    --local te = bu:CreateTexture(name..i.."Overlay","Overlay")
    --te:SetTexture("Interface\\Buttons\\UI-Quickslot2")
    --te:SetPoint("TOPLEFT", nt, "TOPLEFT", 0, 0)
    --te:SetPoint("BOTTOMRIGHT", nt, "BOTTOMRIGHT", 0, 0)
    
    nt:SetTexture("Interface\\Buttons\\UI-Quickslot2")

    ic:SetTexCoord(0.1,0.9,0.1,0.9)
  
  end
  
  
  ]]--
  
  addon:RegisterEvent"PLAYER_LOGIN"