
  -- roth 2009

  ---------------------------------------------------
  -- VARIABLES
  ---------------------------------------------------
  
  -- define most of the variables  
  local myname, _ = UnitName("player")
  local _, myclass = UnitClass("player")
  local button_system, testmode
  local shapeshift_on_mouseover, petbar_on_mouseover, rightbars_on_mouseover, micromenu_on_mouseover
  local bags_on_mouseover, bar3_on_mouseover, bar2_on_mouseover, bar1_on_mouseover
  local move_micro, move_bags, move_rightbars, move_shapeshift, move_bar1, move_bar2, move_bar3
  local lock_micro, lock_bags, lock_rightbars, lock_shapeshift, lock_bar1, lock_bar2, lock_bar3
  local bar1scale, bar2scale, bar3scale, bar45scale, petscale, shapeshiftscale, micromenuscale, bagscale
  
  ---------------------------------------------------
  -- CONFIG START
  ---------------------------------------------------
  
  --this will activate ALL the backdrops. makes it easier to see the dragable bar areas
  testmode = 0
  
  -- bar1 and bar2 in 2x6 instead of 1x12
  -- 0 = 1x12
  -- 1 = 2x6
  button_system = 1
  
  -- bar settings
  -- you can make a bar visible on mouseover, make it movable or lock it from moving
  -- if you make it not movable it will use the default position values of the holder frames
    
  -- bar1
  bar1_on_mouseover = 0
  move_bar1 = 1
  lock_bar1 = 1
  
  -- bar2
  bar2_on_mouseover = 0
  move_bar2 = 0
  lock_bar2 = 1
  
  -- bar3
  if myname == "Loral" then
    bar3_on_mouseover = 0
  else
    bar3_on_mouseover = 0
  end
  move_bar3 = 1
  lock_bar3 = 1
  
  -- rightbars (bar45)
  rightbars_on_mouseover = 1
  move_rightbars = 1
  lock_rightbars = 0
  
  -- shapeshift
  if myname == "Loral" then
    shapeshift_on_mouseover = 0
  elseif myname == "Rothar" then
    shapeshift_on_mouseover = 1
  else
    shapeshift_on_mouseover = 0
  end
  move_shapeshift = 1
  lock_shapeshift = 0
  
  -- petbar
  petbar_on_mouseover = 1
  move_pet = 1
  lock_pet = 1

  -- micromenu
  micromenu_on_mouseover = 1
  move_micro = 1
  lock_micro = 1
  hide_micro = 0

  -- bags
  bags_on_mouseover = 1
  move_bags = 1
  lock_bags = 1
  hide_bags = 0
  
  -- vehicle exit button
  move_veb = 1
  lock_veb = 0
  
  -- scale values
  bar1scale = 0.82*0.75
  bar2scale = 0.82*0.75
  bar3scale = 0.82*0.75
  bar45scale = 0.82*0.75  
  petscale = 0.65
  shapeshiftscale = 0.65
  micromenuscale = 0.8
  bagscale = 0.9
  
  -- position table for the default frame holder positions
  -- those are use if the bar is set to not movable or if there is no value in the layout-cache.txt for that frame yet
  local frame_positions = {
    [1]  =  { a = "BOTTOM",         x = -127, y = 19  },  --fbar1_button_system_1
    [2]  =  { a = "BOTTOM",         x = 0,    y = 19  },  --fbar1_button_system_0
    [3]  =  { a = "BOTTOM",         x = 125,  y = 19  },  --fbar2_button_system_1
    [4]  =  { a = "BOTTOM",         x = 0,    y = 60  },  --fbar2_button_system_0
    [5]  =  { a = "BOTTOM",         x = 0,    y = 112 },  --fbar3
    [6]  =  { a = "RIGHT",          x = -5,   y = 0   },  --fbar45
    [7]  =  { a = "BOTTOMRIGHT",    x = 5,    y = -5  },  --bags
    [8]  =  { a = "TOP",            x = 0,    y = 5   },  --micromenu
    [9]  =  { a = "BOTTOM",         x = 0,    y = 170 },  --petbar
    [10] =  { a = "BOTTOM",         x = 0,    y = 240 },  --shapeshift
    [11] =  { a = "BOTTOM",         x = 0,    y = 290 },  --my own vehicle exit button
  }
  
  ---------------------------------------------------
  -- CONFIG END
  ---------------------------------------------------

  -- Only edit stuff below if you _know_ what you are doing.

  ---------------------------------------------------
  -- CREATE ALL THE HOLDER FRAMES
  ---------------------------------------------------
    
  -- Frame to hold the ActionBar1 and the BonusActionBar
  local fbar1 = CreateFrame("Frame","rABS_Bar1Holder",UIParent)
  if button_system == 1 then
    fbar1:SetWidth(264)
    fbar1:SetHeight(116)
    fbar1:SetPoint(frame_positions[1].a,frame_positions[1].x,frame_positions[1].y)  
  else
    fbar1:SetWidth(518)
    fbar1:SetHeight(58)
    fbar1:SetPoint(frame_positions[2].a,frame_positions[2].x,frame_positions[2].y)  
  end
  if testmode == 1 then
    fbar1:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 0, right = 0, top = 0, bottom = 0 }});
  end
  --fbar1:SetFrameStrata("LOW")
  fbar1:Show()
  
  -- Frame to hold the MultibarLeft
  local fbar2 = CreateFrame("Frame","rABS_Bar2Holder",UIParent)
  if button_system == 1 then
    fbar2:SetWidth(264)
    fbar2:SetHeight(116)
    fbar2:SetPoint(frame_positions[3].a,frame_positions[3].x,frame_positions[3].y)
  else
    fbar2:SetWidth(518)
    fbar2:SetHeight(58)
    fbar2:SetPoint(frame_positions[4].a,frame_positions[4].x,frame_positions[4].y)  
  end
  if testmode == 1 then
    fbar2:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 0, right = 0, top = 0, bottom = 0 }});
  end
  fbar2:Show()

  -- Frame to hold the MultibarRight
  local fbar3 = CreateFrame("Frame","rABS_Bar3Holder",UIParent)
  fbar3:SetWidth(518)
  fbar3:SetHeight(58)
  if testmode == 1 then
    fbar3:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 0, right = 0, top = 0, bottom = 0 }});
  end
  fbar3:SetPoint(frame_positions[5].a,frame_positions[5].x,frame_positions[5].y)
  fbar3:Show()  
  
  -- Frame to hold the right bars
  local fbar45 = CreateFrame("Frame","rABS_Bar45Holder",UIParent)
  fbar45:SetWidth(100) -- size the width here
  fbar45:SetHeight(518) -- size the height here
  if testmode == 1 then
    fbar45:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 0, right = 0, top = 0, bottom = 0 }});
  end
  fbar45:SetPoint(frame_positions[6].a,frame_positions[6].x,frame_positions[6].y) 
  
  -- Frame to hold the bag buttons
  local fbag = CreateFrame("Frame","rABS_BagHolder",UIParent)
  fbag:SetWidth(220)
  fbag:SetHeight(60)
  if testmode == 1 then
    fbag:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 0, right = 0, top = 0, bottom = 0 }});
  end
  fbag:SetPoint(frame_positions[7].a,frame_positions[7].x,frame_positions[7].y)
  fbag:Show()
  
  -- Frame to hold the micro menu  
  local fmicro = CreateFrame("Frame","rABS_MicroMenuHolder",UIParent)
  fmicro:SetWidth(263)
  fmicro:SetHeight(60)
  if testmode == 1 then
    fmicro:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 0, right = 0, top = 0, bottom = 0 }});
  end
  fmicro:SetPoint(frame_positions[8].a,frame_positions[8].x,frame_positions[8].y)
  fmicro:Show()
  
  -- Frame to hold the pet bars  
  local fpet = CreateFrame("Frame","rABS_PetBarHolder",UIParent)
  fpet:SetWidth(400) -- size the width here
  fpet:SetHeight(53) -- size the height here
  if testmode == 1 then
    fpet:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 0, right = 0, top = 0, bottom = 0 }});
  end
  fpet:SetPoint(frame_positions[9].a,frame_positions[9].x,frame_positions[9].y) 
  
  -- Frame to hold the shapeshift bars  
  local fshift = CreateFrame("Frame","rABS_ShapeShiftHolder",UIParent)
  fshift:SetWidth(355) -- size the width here
  fshift:SetHeight(50) -- size the height here
  if testmode == 1 then
    fshift:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 0, right = 0, top = 0, bottom = 0 }});
  end
  fshift:SetPoint(frame_positions[10].a,frame_positions[10].x,frame_positions[10].y) 
  
  
  ---------------------------------------------------
  -- CREATE MY OWN VEHICLE EXIT BUTTON
  ---------------------------------------------------
  
  local fveb = CreateFrame("Frame","rABS_VEBHolder",UIParent)
  fveb:SetWidth(70) -- size the width here
  fveb:SetHeight(70) -- size the height here
  if testmode == 1 then
    fveb:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 0, right = 0, top = 0, bottom = 0 }});
  end
  fveb:SetPoint(frame_positions[11].a,frame_positions[11].x,frame_positions[11].y) 
  
  local veb = CreateFrame("BUTTON", "rABS_VehicleExitButton", fveb, "SecureActionButtonTemplate");
  veb:SetWidth(50)
  veb:SetHeight(50)
  veb:SetPoint("CENTER",0,0)
  veb:RegisterForClicks("AnyUp")
  veb:SetNormalTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Up")
  veb:SetPushedTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Down")
  veb:SetHighlightTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Down")
  veb:SetScript("OnClick", function(self) VehicleExit() end)
  veb:RegisterEvent("UNIT_ENTERING_VEHICLE")
  veb:RegisterEvent("UNIT_ENTERED_VEHICLE")
  veb:RegisterEvent("UNIT_EXITING_VEHICLE")
  veb:RegisterEvent("UNIT_EXITED_VEHICLE")
  veb:SetScript("OnEvent", function(self,event,...)
    local arg1 = ...;
    if(((event=="UNIT_ENTERING_VEHICLE") or (event=="UNIT_ENTERED_VEHICLE")) and arg1 == "player") then
      veb:SetAlpha(1)
    elseif(((event=="UNIT_EXITING_VEHICLE") or (event=="UNIT_EXITED_VEHICLE")) and arg1 == "player") then
      veb:SetAlpha(0)
    end
  end)  
  veb:SetAlpha(0)
 
  ---------------------------------------------------
  -- MOVE STUFF INTO POSITION
  ---------------------------------------------------
  
  local i,f
  
  --bar1
  for i=1, 12 do
    _G["ActionButton"..i]:SetParent(fbar1);
  end
  ActionButton1:ClearAllPoints()
  ActionButton1:SetPoint("BOTTOMLEFT",fbar1,"BOTTOMLEFT",10,10);   

  --bonus bar  
  BonusActionBarFrame:SetParent(fbar1)
  BonusActionBarFrame:SetWidth(0.01)
  BonusActionBarTexture0:Hide()
  BonusActionBarTexture1:Hide()
  BonusActionButton1:ClearAllPoints()
  BonusActionButton1:SetPoint("BOTTOMLEFT", fbar1, "BOTTOMLEFT", 10, 10);
  
  --bar2
  MultiBarBottomLeft:SetParent(fbar2)
  MultiBarBottomLeftButton1:ClearAllPoints()
  MultiBarBottomLeftButton1:SetPoint("BOTTOMLEFT", fbar2, "BOTTOMLEFT", 10, 10);
  
  --bar3
  MultiBarBottomRight:SetParent(fbar3)
  MultiBarBottomRightButton1:ClearAllPoints()
  MultiBarBottomRightButton1:SetPoint("BOTTOMLEFT", fbar3, "BOTTOMLEFT", 10, 10);
  
  if button_system == 1 then
    ActionButton7:ClearAllPoints()  
    ActionButton7:SetPoint("BOTTOMLEFT",ActionButton1,"TOPLEFT",0,5);
    BonusActionButton7:ClearAllPoints()  
    BonusActionButton7:SetPoint("BOTTOMLEFT",BonusActionButton1,"TOPLEFT",0,5);
    MultiBarBottomLeftButton7:ClearAllPoints()  
    MultiBarBottomLeftButton7:SetPoint("BOTTOMLEFT",MultiBarBottomLeftButton1,"TOPLEFT",0,5);
  end
  
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

  --shift
  ShapeshiftBarFrame:SetParent(fshift)
  ShapeshiftBarFrame:SetWidth(0.01)
  ShapeshiftButton1:ClearAllPoints()
  ShapeshiftButton1:SetPoint("BOTTOMLEFT",fshift,"BOTTOMLEFT",10,10)
  local function rABS_MoveShapeshift()
    ShapeshiftButton1:SetPoint("BOTTOMLEFT",fshift,"BOTTOMLEFT",10,10)
  end
  hooksecurefunc("ShapeshiftBar_Update", rABS_MoveShapeshift);  
  
  --possess bar
  PossessBarFrame:SetParent(fshift)
  PossessButton1:ClearAllPoints()
  PossessButton1:SetPoint("BOTTOMLEFT", fshift, "BOTTOMLEFT", 10, 10);
  
  --pet
  PetActionBarFrame:SetParent(fpet)
  PetActionBarFrame:SetWidth(0.01)
  PetActionButton1:ClearAllPoints()
  PetActionButton1:SetPoint("BOTTOMLEFT",fpet,"BOTTOMLEFT",10,10)

  --right bars
  MultiBarRight:SetParent(fbar45);
  MultiBarLeft:SetParent(fbar45);
  MultiBarRight:ClearAllPoints()
  MultiBarRight:SetPoint("TOPRIGHT",-10,-10)
  
  ---------------------------------------------------
  -- ACTIONBUTTONS MUST BE HIDDEN
  ---------------------------------------------------
  
  -- hide actionbuttons when the bonusbar is visible (rogue stealth and such)
  local function rABS_showhideactionbuttons(alpha)
    local f = "ActionButton"
    for i=1, 12 do
      _G[f..i]:SetAlpha(alpha)
    end
  end
  BonusActionBarFrame:HookScript("OnShow", function(self) rABS_showhideactionbuttons(0) end)
  BonusActionBarFrame:HookScript("OnHide", function(self) rABS_showhideactionbuttons(1) end)
  if BonusActionBarFrame:IsShown() then
    rABS_showhideactionbuttons(0)
  end

  ---------------------------------------------------
  -- ON MOUSEOVER STUFF
  ---------------------------------------------------

  --functions  
  local function rABS_showhidebar1(alpha)
    if BonusActionBarFrame:IsShown() then
      for i=1, 12 do
        local pb = _G["BonusActionButton"..i]
        pb:SetAlpha(alpha)
      end
    else
      for i=1, 12 do
        local pb = _G["ActionButton"..i]
        pb:SetAlpha(alpha)
      end
    end
  end
  
  
  local function rABS_showhidebar2(alpha)
    if MultiBarBottomLeft:IsShown() then
      for i=1, 12 do
        local pb = _G["MultiBarBottomLeftButton"..i]
        pb:SetAlpha(alpha)
      end
    end
  end
  
  local function rABS_showhidebar3(alpha)
    if MultiBarBottomRight:IsShown() then
      for i=1, 12 do
        local pb = _G["MultiBarBottomRightButton"..i]
        pb:SetAlpha(alpha)
      end
    end
  end
  
  local function rABS_showhideshapeshift(alpha)
    for i=1, NUM_SHAPESHIFT_SLOTS do
      local pb = _G["ShapeshiftButton"..i]
      pb:SetAlpha(alpha)
    end;
  end
  
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
  if bar1_on_mouseover == 1 then
    fbar1:EnableMouse(true)
    fbar1:SetScript("OnEnter", function(self) rABS_showhidebar1(1) end)
    fbar1:SetScript("OnLeave", function(self) rABS_showhidebar1(0) end)  
    for i=1, 12 do
      local pb = _G["ActionButton"..i]
      pb:SetAlpha(0)
      pb:HookScript("OnEnter", function(self) rABS_showhidebar1(1) end)
      pb:HookScript("OnLeave", function(self) rABS_showhidebar1(0) end)
      local pb = _G["BonusActionButton"..i]
      pb:SetAlpha(0)
      pb:HookScript("OnEnter", function(self) rABS_showhidebar1(1) end)
      pb:HookScript("OnLeave", function(self) rABS_showhidebar1(0) end)
    end
  end
  
  if bar2_on_mouseover == 1 then
    fbar2:EnableMouse(true)
    fbar2:SetScript("OnEnter", function(self) rABS_showhidebar2(1) end)
    fbar2:SetScript("OnLeave", function(self) rABS_showhidebar2(0) end)  
    for i=1, 12 do
      local pb = _G["MultiBarBottomLeftButton"..i]
      pb:SetAlpha(0)
      pb:HookScript("OnEnter", function(self) rABS_showhidebar2(1) end)
      pb:HookScript("OnLeave", function(self) rABS_showhidebar2(0) end)
    end
  end
  
  if bar3_on_mouseover == 1 then
    fbar3:EnableMouse(true)
    fbar3:SetScript("OnEnter", function(self) rABS_showhidebar3(1) end)
    fbar3:SetScript("OnLeave", function(self) rABS_showhidebar3(0) end)  
    for i=1, 12 do
      local pb = _G["MultiBarBottomRightButton"..i]
      pb:SetAlpha(0)
      pb:HookScript("OnEnter", function(self) rABS_showhidebar3(1) end)
      pb:HookScript("OnLeave", function(self) rABS_showhidebar3(0) end)
    end
  end
  
  if shapeshift_on_mouseover == 1 then
    fshift:EnableMouse(true)
    fshift:SetScript("OnEnter", function(self) rABS_showhideshapeshift(1) end)
    fshift:SetScript("OnLeave", function(self) rABS_showhideshapeshift(0) end)  
    for i=1, NUM_SHAPESHIFT_SLOTS do
      local pb = _G["ShapeshiftButton"..i]
      pb:SetAlpha(0)
      pb:HookScript("OnEnter", function(self) rABS_showhideshapeshift(1) end)
      pb:HookScript("OnLeave", function(self) rABS_showhideshapeshift(0) end)
    end
  end
  
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

  fbar1:SetScale(bar1scale)
  fbar2:SetScale(bar2scale)
  fbar3:SetScale(bar3scale)
  fbar45:SetScale(bar45scale)
  
  fpet:SetScale(petscale)
  fshift:SetScale(shapeshiftscale)
  fmicro:SetScale(micromenuscale)
  fbag:SetScale(bagscale)


  ---------------------------------------------------
  -- MOVABLE FRAMES
  ---------------------------------------------------
  
  -- func
  local function rABS_MoveThisFrame(f,moveit,lock)
    if moveit == 1 then
      f:SetMovable(true)
      f:SetUserPlaced(true)
      if lock ~= 1 then
        f:EnableMouse(true)
        f:RegisterForDrag("LeftButton","RightButton")
        f:SetScript("OnDragStart", function(self) if IsShiftKeyDown() then self:StartMoving() end end)
        f:SetScript("OnDragStop", function(self) if IsShiftKeyDown() then self:StopMovingOrSizing() end end)
      end
    else
      f:IsUserPlaced(false)
    end  
  end
  
  -- calls
  rABS_MoveThisFrame(fmicro,move_micro,lock_micro)
  rABS_MoveThisFrame(fbag,move_bags,lock_bags)
  rABS_MoveThisFrame(fbar45,move_rightbars,lock_rightbars)
  rABS_MoveThisFrame(fpet,move_pet,lock_pet)
  rABS_MoveThisFrame(fshift,move_shapeshift,lock_shapeshift)
  rABS_MoveThisFrame(fbar1,move_bar1,lock_bar1)
  rABS_MoveThisFrame(fbar2,move_bar2,lock_bar2)
  rABS_MoveThisFrame(fbar3,move_bar3,lock_bar3)
  rABS_MoveThisFrame(fveb,move_veb,lock_veb)

  if hide_bags == 1 then
    fbag:SetScale(0.001)
    fbag:SetAlpha(0)
  end

  if hide_micro == 1 then
    fmicro:SetScale(0.001)
    fmicro:SetAlpha(0)
  end
   
