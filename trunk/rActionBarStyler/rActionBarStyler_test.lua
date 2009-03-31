
  -- roth 2009

  ---------------------------------------------------
  -- GET THE PLAYER CLASS AND THE PLAYER NAME.
  ---------------------------------------------------
  
  local myname, _ = UnitName("player")
  local _, myclass = UnitClass("player")
  
  ---------------------------------------------------
  -- CONFIG START
  ---------------------------------------------------
  
  local myscale = 0.82*0.75
  local petscale = 0.9
    
  local button_system, shapeshift_on_mouseover, petbar_on_mouseover, rightbars_on_mouseover, micromenu_on_mouseover, bags_on_mouseover
  
  -- bar1 and bar2 in 2x6 instead of 1x12
  -- 0 = 1x12
  -- 1 = 2x6
  button_system = 0
  
  -- shapeshift on mouseover on/off
  -- 0 = off
  -- 1 = on
  -- show you how to make the config different for each character
  if myname == "Loral" and myclass == "DRUID" then
    shapeshift_on_mouseover = 0
  else
    shapeshift_on_mouseover = 0
  end
  
  -- petbar on mouseover on/off
  petbar_on_mouseover = 0
  -- rightbars on mouseover on/off
  rightbars_on_mouseover = 0
  -- micromenu on mouseover on/off
  micromenu_on_mouseover = 0
  -- bags on mouseover on/off
  bags_on_mouseover = 0
  
  ---------------------------------------------------
  -- CONFIG END
  ---------------------------------------------------

  -- Only edit stuff below if you _know_ what you are doing.

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
  
  -- Frame to hold the right bars
  local fbar45 = CreateFrame("Frame","rABS_Bar45Holder",UIParent)
  fbar45:SetWidth(130) -- size the width here
  fbar45:SetHeight(500) -- size the height here
  fbar45:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "Interface/Tooltips/UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 4, right = 4, top = 4, bottom = 4 }});
  fbar45:SetPoint("RIGHT",5,-20)  --move it under your petbuttons here
  
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
  
  -- Frame to hold the pet bars  
  local fshift = CreateFrame("Frame","rABS_PetBarHolder",UIParent)
  fshift:SetWidth(355) -- size the width here
  fshift:SetHeight(50) -- size the height here
  fshift:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "Interface/Tooltips/UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 4, right = 4, top = 4, bottom = 4 }});
  fshift:SetPoint("BOTTOM",-78,160) 
 
  ---------------------------------------------------
  -- MOVE STUFF INTO POSITION
  ---------------------------------------------------
  
  local i,f
  
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
    for _, f in pairs(MicroButtons) do
      f:SetParent(fmicro);
    end
    CharacterMicroButton:ClearAllPoints();
    CharacterMicroButton:SetPoint("BOTTOMLEFT", 5, 5);
    SocialsMicroButton:ClearAllPoints();
    SocialsMicroButton:SetPoint("LEFT", QuestLogMicroButton, "RIGHT", -3, 0);
    UpdateTalentButton();
  end
  hooksecurefunc("VehicleMenuBar_MoveMicroButtons", rABS_MoveMicroButtons);  
  rABS_MoveMicroButtons();
  
  --shapeshift
  local ShapeShiftButtons = {
    ShapeshiftButton,
  }  
  local function rABS_MoveShapeShiftButtons()
    for _, f in pairs(MicroButtons) do
      for i=1, NUM_SHAPESHIFT_SLOTS do
        f..i:SetParent(fshift);
      end
      ShapeshiftButton1:ClearAllPoints()
      ShapeshiftButton1:SetPoint("BOTTOMLEFT",fshift,"BOTTOMLEFT",0,0);
    end
    
  end
  rABS_MoveShapeShiftButtons();
  
  --pet
  local PetButtons = {
    PetActionButton,
  }  
  local function rABS_MovePetButtons()
    for _, f in pairs(PetButtons) do
      for i=1, NUM_PET_ACTION_SLOTS do
        f..i:SetParent(fpet);
      end
      PetActionButton1:ClearAllPoints()
      PetActionButton1:SetPoint("BOTTOMLEFT",fpet,"BOTTOMLEFT",0,0);
    end    
  end
  rABS_MovePetButtons();

  --bar4 and bar 5
  local Bar45Buttons = {
    MultiBarRightButton,
    MultiBarLeftButton,
  }  
  local function rABS_MoveBar45Buttons()
    for _, f in pairs(Bar45Buttons) do
      for i = 1, 12, 1 do
        f..i:SetParent(fbar45);
      end
    end
    MultiBarRightButton1:ClearAllPoints()
    MultiBarRightButton1:SetPoint("TOPRIGHT",fbar45,"TOPRIGHT",0,0);   
    MultiBarLeftButton1:ClearAllPoints()
    MultiBarLeftButton1:SetPoint("TOPRIGHT",MultiBarRightButton1,"TOPRIGHT",0,0);
  end  
  rABS_MoveBar45Buttons();  

  ---------------------------------------------------
  -- ACTIONBUTTONS MUST BE HIDDEN
  ---------------------------------------------------
  
  -- hide actionbuttons when the bonusbar is visible (rogue stealth and such)
  local function rABS_showhideactionbuttons(alpha)
    local f = "ActionButton"
    for i = 1, 12, 1 do
      f..i:SetAlpha(alpha)
    end
  end
  BonusActionBarFrame:HookScript("OnShow", function(self) rABS_showhideactionbuttons(0) end)
  BonusActionBarFrame:HookScript("OnHide", function(self) rABS_showhideactionbuttons(1) end)
  

  ---------------------------------------------------
  -- ON MOUSEOVER STUFF
  ---------------------------------------------------

  --functions  
  local function rABS_showhidepet(alpha)
    for i=1, NUM_PET_ACTION_SLOTS do
      local pb = _G["PetActionButton"..i]
      pb:SetAlpha(alpha)
    end;
  end
  
  local function rABS_showhiderightbar(alpha)
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
  
  local function rABS_showhidemicro(alpha)
    for _, frame in pairs(MicroButtons) do
      frame:SetAlpha(alpha)
    end
  end
  
  local function rABS_showhidebags(alpha)
    for _, frame in pairs(BagButtons) do
      frame:SetAlpha(alpha)
    end
  end

  --calls  
  if petbar_on_mouseover == 1 then
    fpet:EnableMouse(true)
    fpet:SetScript("OnEnter", function(self) rABS_showhidepet(1) end)
    fpet:SetScript("OnLeave", function(self) rABS_showhidepet(0) end)  
    for i=1, NUM_PET_ACTION_SLOTS do
      local pb = _G["PetActionButton"..i]
      pb:SetAlpha(0)
      pb:HookScript("OnEnter", function(self) rABS_showhidepet(1) end)
      pb:HookScript("OnLeave", function(self) rABS_showhidepet(0) end)
    end
  end
  
  if rightbars_on_mouseover == 1 then
    fbar45:EnableMouse(true)
    fbar45:SetScript("OnEnter", function(self) rABS_showhiderightbar(1) end)
    fbar45:SetScript("OnLeave", function(self) rABS_showhiderightbar(0) end)  
    for i=1, 12 do
      local pb = _G["MultiBarLeftButton"..i]
      pb:SetAlpha(0)
      pb:HookScript("OnEnter", function(self) rABS_showhiderightbar(1) end)
      pb:HookScript("OnLeave", function(self) rABS_showhiderightbar(0) end)
      local pb = _G["MultiBarRightButton"..i]
      pb:SetAlpha(0)
      pb:HookScript("OnEnter", function(self) rABS_showhiderightbar(1) end)
      pb:HookScript("OnLeave", function(self) rABS_showhiderightbar(0) end)
    end
  end
  
  if micromenu_on_mouseover == 1 then
    fmicro:EnableMouse(true)
    fmicro:SetScript("OnEnter", function(self) rABS_showhidemicro(1) end)
    fmicro:SetScript("OnLeave", function(self) rABS_showhidemicro(0) end)  
    for _, f in pairs(MicroButtons) do
      f:SetAlpha(0)
      f:HookScript("OnEnter", function(self) rABS_showhidemicro(1) end)
      f:HookScript("OnLeave", function(self) rABS_showhidemicro(0) end)
    end
  end
  
  if bags_on_mouseover == 1 then
    fbag:EnableMouse(true)
    fbag:SetScript("OnEnter", function(self) rABS_showhidebags(1) end)
    fbag:SetScript("OnLeave", function(self) rABS_showhidebags(0) end)  
    for _, f in pairs(BagButtons) do
      f:SetAlpha(0)
      f:HookScript("OnEnter", function(self) rABS_showhidebags(1) end)
      f:HookScript("OnLeave", function(self) rABS_showhidebags(0) end)
    end  
  end

  ---------------------------------------------------
  -- MAKE THE DEFAULT BARS UNVISIBLE
  ---------------------------------------------------
  
  local FramesToHide = {
    MainMenuBar,
    VehicleMenuBar,
    BonusActionBarFrame,
    MultiBarBottomLeft,
    MultiBarBottomRight,
    MultiBarRight,
    MultiBarLeft,
    PetActionBarFrame,
    ShapeshiftBarFrame,
  }  
  
  local function rABS_HideDefaultFrames()
    for _, f in pairs(FramesToHide) do
      f:SetScale(0.001)
      f:SetAlpha(0)
    end
  end  
  rABS_HideDefaultFrames(); 
  
  
  ---------------------------------------------------
  -- SCALING
  ---------------------------------------------------

  fbar1:SetScale(myscale)
  fbar2:SetScale(myscale)
  fbar3:SetScale(myscale)
  fbar45:SetScale(myscale)
  
  fpet:SetScale(petscale)
  fshift:SetScale(petscale)
  fmicro:SetScale(petscale)
  fbag:SetScale(petscale)

  

    


  

  

