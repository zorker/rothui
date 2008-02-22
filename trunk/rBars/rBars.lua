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
  
	ShapeshiftBarLeft:Hide()
	ShapeshiftBarLeft.Show = dummy
	ShapeshiftBarMiddle:Hide()
	ShapeshiftBarMiddle.Show = dummy
	ShapeshiftBarRight:Hide()
	ShapeshiftBarRight.Show = dummy
	
	ShapeshiftBarFrame:Hide()
	ShapeshiftBarFrame.Show = dummy
  
  MainMenuBarMaxLevelBar:SetWidth(512)
  MainMenuBarMaxLevelBar:Hide()
  MainMenuBarMaxLevelBar.Show = dummy
  
  --MainMenuBarArtFrame:Hide()

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
  
  --hide max lvl texture
  MainMenuMaxLevelBar0:Hide()
  MainMenuMaxLevelBar1:Hide()
  MainMenuMaxLevelBar2:Hide()
  MainMenuMaxLevelBar3:Hide()
  
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
  --MainMenuBarPerformanceBarFrame:SetParent(UIParent)
  --MainMenuBarPerformanceBarFrame:SetPoint("BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", 0, -5)
  MainMenuBarPerformanceBarFrame:Hide()
  MainMenuBarPerformanceBarFrame.Show = dummy
  
  --MainMenuBarPerformanceBarFrameButton
  
  MultiBarBottomLeft:Show()
  MultiBarBottomRight:Show()
  MultiBarRight:Show()
  MultiBarLeft:Show()
  
  --put the multibars to places
  MultiBarBottomLeft:ClearAllPoints()
  MultiBarBottomLeft:SetPoint("BOTTOMLEFT", "MainMenuBar", "TOPLEFT", 8,-3)
  MultiBarBottomRight:ClearAllPoints()
  MultiBarBottomRight:SetPoint("BOTTOMLEFT", "MultiBarBottomLeft", "TOPLEFT", 0,8)
  ShapeshiftBarFrame:ClearAllPoints()
  ShapeshiftBarFrame:SetPoint("BOTTOMLEFT", MultiBarBottomRight, "TOPLEFT", -10, 7)
  PetActionBarFrame:ClearAllPoints()
  PetActionBarFrame:SetPoint("BOTTOMLEFT", MultiBarBottomRight, "TOPLEFT", -10, 7)
  PossessBarFrame:ClearAllPoints()
  PossessBarFrame:SetPoint("BOTTOMLEFT", MultiBarBottomRight, "TOPLEFT", -10, 7)

  MultiBarRight:ClearAllPoints()
  MultiBarRight:SetPoint("RIGHT",-10, 0)

  --bonusactionbarframe ... frame shows warrior stances...
  --BonusActionBarFrame:Hide()
  --BonusActionBarFrame.Show = dummy

  BonusActionBarFrame:SetParent(UIParent)
  
  BonusActionButton1:ClearAllPoints()
  BonusActionButton1:SetPoint("BOTTOM",UIParent,"BOTTOM",-230,14);
  
  --SCALE
  local myscale = 0.8
  MainMenuBar:SetScale(myscale)
  BonusActionBarFrame:SetScale(myscale)
  MultiBarBottomLeft:SetScale(myscale)
  MultiBarBottomRight:SetScale(myscale)
  MultiBarRight:SetScale(myscale)
  MultiBarLeft:SetScale(myscale)
  
  --RAAAAANGE
  
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
    
    getglobal(this:GetName().."NormalTexture"):SetAlpha(1)
    getglobal(this:GetName().."NormalTexture"):SetHeight(36)
    getglobal(this:GetName().."NormalTexture"):SetWidth(36)
    getglobal(this:GetName().."NormalTexture"):SetPoint("Center", 0, 0);
    
    --getglobal(this:GetName()):SetBackdropColor(0,0,0,1);
    
    getglobal(this:GetName().."NormalTexture"):Show()
    getglobal(this:GetName().."NormalTexture"):SetTexture("Interface\\AddOns\\rTextures\\gloss")
    getglobal(this:GetName().."Icon"):SetTexCoord(0.1,0.9,0.1,0.9)
    getglobal(this:GetName().."Icon"):SetPoint("TOPLEFT", getglobal(this:GetName()), "TOPLEFT", 2, -2)
    getglobal(this:GetName().."Icon"):SetPoint("BOTTOMRIGHT", getglobal(this:GetName()), "BOTTOMRIGHT", -2, 2)
    getglobal(this:GetName().."Name"):Hide()
    getglobal(this:GetName().."HotKey"):Hide()
    --DEFAULT_CHAT_FRAME:AddMessage("GetPushedTextOffset "..getglobal(this:GetName()):GetPushedTexture())

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
    
    
    if name == "MultiBarRightButton" then
      bu:ClearAllPoints();
      if ( i > 1 ) then
        bu:SetPoint("LEFT",_G["MultiBarRightButton"..(i-1)],"RIGHT",5,0);
      else
        bu:SetPoint("CENTER",UIParent,"CENTER",-290,0);
      end
    end
    
     
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