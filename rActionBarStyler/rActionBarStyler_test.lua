  
  -- Get the player class and the player name.
  local myname, _ = UnitName("player")
  local _, myclass = UnitClass("player")
  
  ---------------------------------------------------
  -- CONFIG START
  ---------------------------------------------------
  
  local myscale = 0.82  
  local petscale = 0.9
    
  local button_system, shapeshift_on_mouseover, petbar_on_mouseover, rightbars_on_mouseover, micromenu_on_mouseover, bags_on_mouseover
  
  -- bar1 and bar2 in 2x6 instead of 1x12
  -- 0 = 1x12
  -- 1 = 2x6
  button_system = 1
  
  -- shapeshift on mouseover on/off
  -- 0 = off
  -- 1 = on
  if myname == "Loral" and myclass == "DRUID" then
    shapeshift_on_mouseover = 1
  else
    shapeshift_on_mouseover = 1
  end
  
  -- petbar on mouseover on/off
  petbar_on_mouseover = 1
  -- rightbars on mouseover on/off
  rightbars_on_mouseover = 1  
  -- micromenu on mouseover on/off
  micromenu_on_mouseover = 1  
  -- bags on mouseover on/off
  bags_on_mouseover = 1
  
  ---------------------------------------------------
  -- CONFIG END
  ---------------------------------------------------
  
  
  ---------------------------------------------------
  -- CREATE ALL THE HOLDER FRAMES
  ---------------------------------------------------
    
  -- Frame to hold the ActionBar1 and the BonusActionBar
  local fbar1 = CreateFrame("Frame","rABS_Bar1Holder",UIParent)
  fbar1:SetWidth(498)
  fbar1:SetHeight(60)
  fbar1:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "Interface/Tooltips/UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 4, right = 4, top = 4, bottom = 4 }});
  fbar1:SetPoint("BOTTOM",0,30)
  fbar1:Show()
  
  -- Frame to hold the MultibarLeft
  local fbar2 = CreateFrame("Frame","rABS_Bar2Holder",UIParent)
  fbar2:SetWidth(498)
  fbar2:SetHeight(60)
  fbar2:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "Interface/Tooltips/UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 4, right = 4, top = 4, bottom = 4 }});
  fbar2:SetPoint("BOTTOM",0,90)
  fbar2:Show()

  -- Frame to hold the MultibarRight
  local fbar3 = CreateFrame("Frame","rABS_Bar3Holder",UIParent)
  fbar3:SetWidth(498)
  fbar3:SetHeight(60)
  fbar3:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "Interface/Tooltips/UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 4, right = 4, top = 4, bottom = 4 }});
  fbar3:SetPoint("BOTTOM",0,150)
  fbar3:Show()
  
  -- Frame to hold the bag buttons
  local fbag = CreateFrame("Frame","rABS_BagButtonHolder",UIParent)
  fbag:SetWidth(220)
  fbag:SetHeight(60)
  fbag:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "Interface/Tooltips/UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 4, right = 4, top = 4, bottom = 4 }});
  fbag:SetPoint("BOTTOMRIGHT",5,-5)
  fbag:Show()
  
  -- Frame to hold the micro menu  
  local fmicro = CreateFrame("Frame","rABS_MicroButtonHolder",UIParent)
  fmicro:SetWidth(263)
  fmicro:SetHeight(60)
  fmicro:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "Interface/Tooltips/UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 4, right = 4, top = 4, bottom = 4 }});
  fmicro:SetPoint("TOP",0,5)
  fmicro:Show()
  
  -- Frame to hold the pet bars  
  local fpet = CreateFrame("Frame","rABS_PetBarHolder",UIParent)
  fpet:SetWidth(355) -- size the width here
  fpet:SetHeight(50) -- size the height here
  fpet:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "Interface/Tooltips/UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 4, right = 4, top = 4, bottom = 4 }});
  fpet:SetPoint("BOTTOM",-78,160) 
  fpet:EnableMouse(true)
  fpet:SetScript("OnEnter", function(self) myshowhidepet(1) end)
  fpet:SetScript("OnLeave", function(self) myshowhidepet(0) end)
  
  -- Frame to hold the pet bars  
  local fshift = CreateFrame("Frame","rABS_PetBarHolder",UIParent)
  fshift:SetWidth(355) -- size the width here
  fshift:SetHeight(50) -- size the height here
  fshift:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "Interface/Tooltips/UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 4, right = 4, top = 4, bottom = 4 }});
  fshift:SetPoint("BOTTOM",-78,160) 
  fshift:EnableMouse(true)
  fshift:SetScript("OnEnter", function(self) myshowhideshift(1) end)
  fshift:SetScript("OnLeave", function(self) myshowhideshift(0) end)
  
  -- Frame to hold the right bars
  local fbar45 = CreateFrame("Frame","rABS_Bar45Holder",UIParent)
  fbar45:SetWidth(130) -- size the width here
  fbar45:SetHeight(500) -- size the height here
  fbar45:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "Interface/Tooltips/UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 4, right = 4, top = 4, bottom = 4 }});
  fbar45:SetPoint("RIGHT",5,-20)  --move it under your petbuttons here
  fbar45:EnableMouse(true)
  fbar45:SetScript("OnEnter", function(self) myshowhiderightbar(1) end)
  fbar45:SetScript("OnLeave", function(self) myshowhiderightbar(0) end)
  
  ---------------------------------------------------
  -- Move stuff into position
  ---------------------------------------------------
  
  local i
  
  --bar1
  local Bar1Buttons = {
    ActionButton,
    BonusActionButton,
  }  
  local function rABS_MoveBar1Buttons()
    for _, f in pairs(Bar1Buttons) do
      for i = 1, 12, 1 do
        f..i:SetParent(fbar1);
      end
    end
    ActionButton1:ClearAllPoints()
    ActionButton1:SetPoint("BOTTOMLEFT",fbar1,"BOTTOMLEFT",0,0);   
    BonusActionButton1:ClearAllPoints()
    BonusActionButton1:SetPoint("BOTTOMLEFT",fbar1,"BOTTOMLEFT",0,0);
  end  
  rABS_MoveBar1Buttons();
  
  --bar2
  local Bar2Buttons = {
    MultiBarBottomLeftButton,
  }  
  local function rABS_MoveBar2Buttons()
    for _, f in pairs(Bar2Buttons) do
      for i = 1, 12, 1 do
        f..i:SetParent(fbar2);
      end
    end
    MultiBarBottomLeftButton1:ClearAllPoints()
    MultiBarBottomLeftButton1:SetPoint("BOTTOMLEFT",fbar2,"BOTTOMLEFT",0,0);   
  end  
  rABS_MoveBar2Buttons();
  
  --bar3
  local Bar3Buttons = {
    MultiBarBottomRightButton,
  }  
  local function rABS_MoveBar3Buttons()
    for _, f in pairs(Bar3Buttons) do
      for i = 1, 12, 1 do
        f..i:SetParent(fbar3);
      end
    end
    MultiBarBottomRightButton1:ClearAllPoints()
    MultiBarBottomRightButton1:SetPoint("BOTTOMLEFT",fbar3,"BOTTOMLEFT",0,0);   
  end  
  rABS_MoveBar3Buttons();
  
  --bags
  local BagButtons = {
    MainMenuBarBackpackButton,
    CharacterBag0Slot,
    CharacterBag1Slot,
    CharacterBag2Slot,
    CharacterBag3Slot,
    KeyRingButton,
  }
  
  local function rABS_MoveBagButtons()
    for _, f in pairs(BagButtons) do
      f:SetParent(fbag);
    end
    MainMenuBarBackpackButton:ClearAllPoints();
    MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", -15, 15);
  end
  
  rABS_MoveBagButtons();  
  
  --mircro menu
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
  
  local function rABS_MoveMicroButtons(skinName)
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
  
  
  
  
  
  
  
  local myscale = myscale*0.75
  
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

  

  
  --------------------
  -- MICRO MENU
  --------------------

  

  
  
  --RIGHT BARS
  MultiBarRightButton1:ClearAllPoints()
  MultiBarRightButton1:SetPoint("RIGHT",UIParent,"RIGHT",-30, 190)
  MultiBarLeftButton1:ClearAllPoints()
  MultiBarLeftButton1:SetPoint("TOPLEFT",MultiBarRightButton1,"TOPLEFT",-43, 0)
  
  --SHAPESHIFT+PET
  
  if hide_shapeshift ~= 1 then
    ShapeshiftBarFrame:SetParent(f)
    ShapeshiftButton1:ClearAllPoints()
    if rf2_player_name == "Loral" then
      ShapeshiftButton1:SetPoint("BOTTOMLEFT",MultiBarBottomRightButton1,"TOPLEFT",3,15);
    else
      ShapeshiftButton1:SetPoint("BOTTOMLEFT",MultiBarBottomRightButton1,"TOPLEFT",3,54);
    end
    ShapeshiftButton1.SetPoint = function() end
  else  
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
    
  local 1 = 1

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
  

  
    for i=1, NUM_PET_ACTION_SLOTS do
      local pb = _G["PetActionButton"..i]
      pb:SetAlpha(0)
      pb:HookScript("OnEnter", function(self) myshowhidepet(1) end)
      pb:HookScript("OnLeave", function(self) myshowhidepet(0) end)
    end;
  
  end
  
  if rightbars_on_mouseover == 1 then
  

    
    for i=1, 12 do
      local pb = _G["MultiBarLeftButton"..i]
      pb:SetAlpha(0)
      pb:HookScript("OnEnter", function(self) myshowhiderightbar(1) end)
      pb:HookScript("OnLeave", function(self) myshowhiderightbar(0) end)
      local pb = _G["MultiBarRightButton"..i]
      pb:SetAlpha(0)
      pb:HookScript("OnEnter", function(self) myshowhiderightbar(1) end)
      pb:HookScript("OnLeave", function(self) myshowhiderightbar(0) end)
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
  

