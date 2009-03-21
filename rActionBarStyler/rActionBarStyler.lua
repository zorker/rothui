  
  -- CONFIG
  
  local myscale = 0.82*0.75
  local petscale = 0.9
  
  -- bar1 and bar2 in 2x6 instead of 1x12
  -- 1 = 2x6
  -- 0 = 1x12
  local button_system = 1
  
  -- on/off
  local hide_shapeshift = 1
  
  -- on/off
  local petbar_on_mouseover = 1
  -- range 0 - 1
  local petbar_off_alpha = 0
  
  -- on/off
  local rightbars_on_mouseover = 1
  -- range 0 - 1
  local rightbars_off_alpha = 0
  
  -- on/off
  local micromenu_on_mouseover = 1
  
  -- on/off
  local bags_on_mouseover = 1
  
  -- CONFIG END
  
  
  local f = CreateFrame("Frame","rBars_Button_Holder_Frame",UIParent)
  f:SetWidth(498)
  f:SetHeight(100)
  --f:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "Interface/Tooltips/UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 4, right = 4, top = 4, bottom = 4 }});
  f:SetPoint("BOTTOM",0,30)
  f:Show()
  
  local bonushooks = {};
  local i;
  
  BonusActionBarFrame:SetParent(f)

  for i = 1, 12, 1 do
    _G["ActionButton"..i]:SetParent(f);
  end;

  ActionButton1:ClearAllPoints()
  ActionButton1:SetPoint("BOTTOMLEFT",f,"BOTTOMLEFT",0,0);    

  --need to do this since I reanchored the bonusactionbar to f
  BonusActionBarTexture0:Hide()
  BonusActionBarTexture1:Hide()
  
  BonusActionButton1:ClearAllPoints()
  BonusActionButton1:SetPoint("BOTTOMLEFT",f,"BOTTOMLEFT",0,0);
  
  if button_system == 0 then

    MultiBarBottomLeftButton1:ClearAllPoints()  
    MultiBarBottomLeftButton1:SetPoint("BOTTOMLEFT",ActionButton1,"TOPLEFT",0,5);

    MultiBarBottomRightButton1:ClearAllPoints()  
    MultiBarBottomRightButton1:SetPoint("BOTTOMLEFT",MultiBarBottomLeftButton1,"TOPLEFT",0,15);
  
  else

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
  
  end

  --------------------
  -- BagButtons
  --------------------
  local fb = CreateFrame("Frame","rABS_BagButtonHolder",UIParent)
  fb:SetWidth(220)
  fb:SetHeight(60)
  --fb:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "Interface/Tooltips/UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 4, right = 4, top = 4, bottom = 4 }});
  fb:SetPoint("BOTTOMRIGHT",5,-5)
  fb:Show()
  
  local BagButtons = {
    MainMenuBarBackpackButton,
    CharacterBag0Slot,
    CharacterBag1Slot,
    CharacterBag2Slot,
    CharacterBag3Slot,
    KeyRingButton,
  }
  
  function rABS_MoveBagButtons()
		for _, frame in pairs(BagButtons) do
			frame:SetParent("rABS_BagButtonHolder");
		end
		MainMenuBarBackpackButton:ClearAllPoints();
		MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", -15, 15);
  end
  
  rABS_MoveBagButtons();
  
  --------------------
  -- MICRO MENU
  --------------------
  local fm = CreateFrame("Frame","rABS_MicroButtonHolder",UIParent)
  fm:SetWidth(263)
  fm:SetHeight(60)
  --fm:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "Interface/Tooltips/UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 4, right = 4, top = 4, bottom = 4 }});
  fm:SetPoint("TOP",0,5)
  fm:Show()
  
  local MicroButtons = {
    CharacterMicroButton,
    SpellbookMicroButton,
    TalentMicroButton,
    AchievementMicroButton,
    QuestLogMicroButton,
    SocialsMicroButton,
    PVPMicroButton,
    LFGMicroButton,
    MainMenuMicroButton,
    HelpMicroButton,
  }
  
  function rABS_MoveMicroButtons(skinName)
		for _, frame in pairs(MicroButtons) do
			frame:SetParent("rABS_MicroButtonHolder");
		end
 		CharacterMicroButton:ClearAllPoints();
		CharacterMicroButton:SetPoint("BOTTOMLEFT", 5, 5);
		SocialsMicroButton:ClearAllPoints();
		SocialsMicroButton:SetPoint("LEFT", QuestLogMicroButton, "RIGHT", -3, 0);
 		UpdateTalentButton();
  end

  hooksecurefunc("VehicleMenuBar_MoveMicroButtons", rABS_MoveMicroButtons);
  
  rABS_MoveMicroButtons();
  
  
  

  MultiBarRightButton1:ClearAllPoints()
  MultiBarRightButton1:SetPoint("RIGHT",UIParent,"RIGHT",-30, 190)

  MultiBarLeftButton1:ClearAllPoints()
  MultiBarLeftButton1:SetPoint("TOPLEFT",MultiBarRightButton1,"TOPLEFT",-43, 0)
  
  ShapeshiftBarFrame:SetParent(f)

  local myclass, myengclass = UnitClass("player")
  
  if myengclass == "DEATHKNIGHT" then
    ShapeshiftButton1:ClearAllPoints()
    ShapeshiftButton1:SetPoint("BOTTOMLEFT",MultiBarBottomRightButton10,"TOPLEFT",-5,15);
    ShapeshiftButton1.SetPoint = function() end
  else
    ShapeshiftButton1:ClearAllPoints()
    ShapeshiftButton1:SetPoint("BOTTOMLEFT",MultiBarBottomRightButton1,"TOPLEFT",5,15);
    ShapeshiftButton1.SetPoint = function() end
  end
  
  -- hide the shapeshift 
  if hide_shapeshift == 1 then
    ShapeshiftBarFrame:SetScale(0.001)
    ShapeshiftBarFrame:SetAlpha(0)
  end
  
  PetActionButton1:ClearAllPoints()
  PetActionBarFrame:SetParent(f)
  PetActionButton1:SetPoint("BOTTOMLEFT",MultiBarBottomRightButton1,"TOPLEFT",5,15);

  -- hmmm I don't know if this does anything since the PossesBar becomes the BonusActionBar upon possessing sth
  PossessButton1:ClearAllPoints()
  PossessBarFrame:SetParent(f)
  PossessButton1:SetPoint("BOTTOMLEFT",MultiBarBottomRightButton1,"TOPLEFT",5,15);
  
  --hack to make the mainbar unvisible >_<
  MainMenuBar:SetScale(0.001)
  MainMenuBar:SetAlpha(0)
  VehicleMenuBar:SetScale(0.001)
  VehicleMenuBar:SetAlpha(0)
  
  f:SetScale(myscale)
  fm:SetScale(0.9)
  fb:SetScale(0.9)
  BonusActionBarFrame:SetScale(1)
  MultiBarBottomLeft:SetScale(myscale)
  MultiBarBottomRight:SetScale(myscale)
  MultiBarRight:SetScale(myscale)
  MultiBarLeft:SetScale(myscale)
  PetActionBarFrame:SetScale(petscale)
  
  bonushooks["onshow"] = BonusActionBarFrame:GetScript("OnShow");
  bonushooks["onshide"] = BonusActionBarFrame:GetScript("OnHide");
  
  BonusActionBarFrame:SetScript("OnShow", function(self,...)
    if ( bonushooks["onshow"] ) then bonushooks["onshow"](self,...); end;
    for i = 1, 12, 1 do
      _G["ActionButton"..i]:SetAlpha(0);
    end;
  end);
  
  BonusActionBarFrame:SetScript("OnHide", function(self,...)
    if ( bonushooks["onhide"] ) then bonushooks["onhide"](self,...); end;
    for i = 1, 12, 1 do
      _G["ActionButton"..i]:SetAlpha(1);
    end;
  end); 
    
  local alphahigh = 1

  local function myshowhidepet(alpha)
    for i=1, NUM_PET_ACTION_SLOTS do
      local pb = _G["PetActionButton"..i]
      pb:SetAlpha(alpha)
    end;
  end
  
  local function myshowhiderightbar(alpha)
    if MultiBarLeft:IsShown() then
      for i=1, 12 do
        local pb = _G["MultiBarLeftButton"..i]
        pb:SetAlpha(alpha)
      end
    end
    if MultiBarRight:IsShown() then
      for i=1, 12 do
        local pb = _G["MultiBarRightButton"..i]
        pb:SetAlpha(alpha)
      end
    end
  end
  
  local function myshowhidemicro(alpha)
		for _, frame in pairs(MicroButtons) do
      frame:SetAlpha(alpha)
		end
  end
  
  local function myshowhidebags(alpha)
		for _, frame in pairs(BagButtons) do
      frame:SetAlpha(alpha)
		end
  end
  
  if petbar_on_mouseover == 1 then
  
    local f2 = CreateFrame("Frame","myPetBarHolderFrame",UIParent)
    --comment this in to see the frame
    --f2:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "Interface/Tooltips/UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 4, right = 4, top = 4, bottom = 4 }});
    f2:SetWidth(355) -- size the width here
    f2:SetHeight(50) -- size the height here
    f2:SetPoint("BOTTOM",-78,160)  --move it under your petbuttons here
    f2:SetScale(myscale)
    f2:EnableMouse(true)
    f2:SetScript("OnEnter", function(self) myshowhidepet(alphahigh) end)
    f2:SetScript("OnLeave", function(self) myshowhidepet(petbar_off_alpha) end)
  
    for i=1, NUM_PET_ACTION_SLOTS do
      local pb = _G["PetActionButton"..i]
      pb:SetAlpha(petbar_off_alpha)
      pb:HookScript("OnEnter", function(self) myshowhidepet(alphahigh) end)
      pb:HookScript("OnLeave", function(self) myshowhidepet(petbar_off_alpha) end)
    end;
  
  end
  
  if rightbars_on_mouseover == 1 then
  
    local f3 = CreateFrame("Frame","myRightBarHolderFrame",UIParent)
    --comment this in to see the frame
    --f3:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "Interface/Tooltips/UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 4, right = 4, top = 4, bottom = 4 }});
    f3:SetWidth(130) -- size the width here
    f3:SetHeight(500) -- size the height here
    f3:SetPoint("RIGHT",5,-20)  --move it under your petbuttons here
    f3:SetScale(myscale)
    f3:EnableMouse(true)
    f3:SetScript("OnEnter", function(self) myshowhiderightbar(alphahigh) end)
    f3:SetScript("OnLeave", function(self) myshowhiderightbar(rightbars_off_alpha) end)
    
    for i=1, 12 do
      local pb = _G["MultiBarLeftButton"..i]
      pb:SetAlpha(rightbars_off_alpha)
      pb:HookScript("OnEnter", function(self) myshowhiderightbar(alphahigh) end)
      pb:HookScript("OnLeave", function(self) myshowhiderightbar(rightbars_off_alpha) end)
      local pb = _G["MultiBarRightButton"..i]
      pb:SetAlpha(rightbars_off_alpha)
      pb:HookScript("OnEnter", function(self) myshowhiderightbar(alphahigh) end)
      pb:HookScript("OnLeave", function(self) myshowhiderightbar(rightbars_off_alpha) end)
    end;
  
  end
  
  if micromenu_on_mouseover == 1 then
    fm:EnableMouse(true)
    fm:SetScript("OnEnter", function(self) myshowhidemicro(1) end)
    fm:SetScript("OnLeave", function(self) myshowhidemicro(0) end)
  
		for _, frame in pairs(MicroButtons) do
      frame:SetAlpha(0)
      frame:HookScript("OnEnter", function(self) myshowhidemicro(1) end)
      frame:HookScript("OnLeave", function(self) myshowhidemicro(0) end)
		end
  
  end
  
  if bags_on_mouseover == 1 then
    fb:EnableMouse(true)
    fb:SetScript("OnEnter", function(self) myshowhidebags(1) end)
    fb:SetScript("OnLeave", function(self) myshowhidebags(0) end)
  
		for _, frame in pairs(BagButtons) do
      frame:SetAlpha(0)
      frame:HookScript("OnEnter", function(self) myshowhidebags(1) end)
      frame:HookScript("OnLeave", function(self) myshowhidebags(0) end)
		end
  
  end