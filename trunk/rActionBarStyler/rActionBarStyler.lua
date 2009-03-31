
  -- roth 2009

  ---------------------------------------------------
  -- GET THE PLAYER CLASS AND THE PLAYER NAME.
  ---------------------------------------------------
  
  local myname, _ = UnitName("player")
  local _, myclass = UnitClass("player")
  
  ---------------------------------------------------
  -- CONFIG START
  ---------------------------------------------------
  
  -- scale values
  local myscale = 0.82*0.75
  local bar2scale = 0.82*0.75
  local bar3scale = 0.82*0.75
  local bar45scale = 0.82*0.75  
  local petscale = 0.65
  local shapeshiftscale = 0.65
  local micromenuscale = 0.8
  local bagscale = 0.9
  
  --this will activate ALL the backdrops. makes it easier to see the dragable bar areas
  local testmode = 0
    
  local button_system
  local shapeshift_on_mouseover, petbar_on_mouseover, rightbars_on_mouseover, micromenu_on_mouseover, bags_on_mouseover, bar3_on_mouseover, bar2_on_mouseover, bar1_on_mouseover
  local move_micro, move_bags, move_rightbars, move_shapeshift, move_bar1, move_bar2, move_bar3
  
  -- bar1 and bar2 in 2x6 instead of 1x12
  -- 0 = 1x12
  -- 1 = 2x6
  button_system = 0
  
  -- make bar 1,2,3 movable on/off
  -- bar1
  move_bar1 = 1
  bar1_on_mouseover = 0
  
  -- bar2
  move_bar2 = 1
  bar2_on_mouseover = 0
  
  -- bar3
  move_bar3 = 1
  bar3_on_mouseover = 0
  
  -- shapeshift on mouseover on/off
  -- 0 = off
  -- 1 = on
  -- show you how to make the config different for each character
  if myname == "Loral" and myclass == "DRUID" then
    shapeshift_on_mouseover = 1
  else
    shapeshift_on_mouseover = 1
  end
  -- shapeshift movable on/off
  move_shapeshift = 1
  
  -- petbar on mouseover on/off
  petbar_on_mouseover = 1
  -- petbar movable on/off
  move_pet = 1

  -- rightbars on mouseover on/off
  rightbars_on_mouseover = 1
  -- rightbars movable on/off
  move_rightbars = 1

  -- micromenu on mouseover on/off
  micromenu_on_mouseover = 1
  -- bags movable on/off
  move_micro = 1

  -- bags on mouseover on/off
  bags_on_mouseover = 1
  -- bags movable on/off
  move_bags = 1
  
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
    fbar1:SetPoint("BOTTOM",-127,20)  
  else
    fbar1:SetWidth(518)
    fbar1:SetHeight(58)
    fbar1:SetPoint("BOTTOM",0,20)  
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
    fbar2:SetPoint("BOTTOM",125,20)
  else
    fbar2:SetWidth(518)
    fbar2:SetHeight(58)
    fbar2:SetPoint("BOTTOM",0,60)  
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
  fbar3:SetPoint("BOTTOM",0,112)
  fbar3:Show()  
  
  -- Frame to hold the right bars
  local fbar45 = CreateFrame("Frame","rABS_Bar45Holder",UIParent)
  fbar45:SetWidth(100) -- size the width here
  fbar45:SetHeight(518) -- size the height here
  if testmode == 1 then
    fbar45:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 0, right = 0, top = 0, bottom = 0 }});
  end
  fbar45:SetPoint("RIGHT",-5,0) 
  
  -- Frame to hold the bag buttons
  local fbag = CreateFrame("Frame","rABS_BagHolder",UIParent)
  fbag:SetWidth(220)
  fbag:SetHeight(60)
  if testmode == 1 then
    fbag:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 0, right = 0, top = 0, bottom = 0 }});
  end
  fbag:SetPoint("BOTTOMRIGHT",5,-5)
  fbag:Show()
  
  -- Frame to hold the micro menu  
  local fmicro = CreateFrame("Frame","rABS_MicroMenuHolder",UIParent)
  fmicro:SetWidth(263)
  fmicro:SetHeight(60)
  if testmode == 1 then
    fmicro:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 0, right = 0, top = 0, bottom = 0 }});
  end
  fmicro:SetPoint("TOP",0,5)
  fmicro:Show()
  
  -- Frame to hold the pet bars  
  local fpet = CreateFrame("Frame","rABS_PetBarHolder",UIParent)
  fpet:SetWidth(400) -- size the width here
  fpet:SetHeight(53) -- size the height here
  if testmode == 1 then
    fpet:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 0, right = 0, top = 0, bottom = 0 }});
  end
  fpet:SetPoint("BOTTOM",0,170) 
  
  -- Frame to hold the shapeshift bars  
  local fshift = CreateFrame("Frame","rABS_ShapeShiftHolder",UIParent)
  fshift:SetWidth(355) -- size the width here
  fshift:SetHeight(50) -- size the height here
  if testmode == 1 then
    fshift:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 0, right = 0, top = 0, bottom = 0 }});
  end
  fshift:SetPoint("BOTTOM",0,240) 
 
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
  
  --possess bar
  --PossessBarFrame:SetParent(fbar1)
  --PossessButton1:ClearAllPoints()
  --PossessButton1:SetPoint("BOTTOMLEFT", fbar1, "BOTTOMLEFT", 10, 10);
  
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

  fbar1:SetScale(myscale)
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
  
  if move_micro == 1 then
    fmicro:EnableMouse(true)
    fmicro:SetMovable(true)
    fmicro:SetUserPlaced(true)
    fmicro:RegisterForDrag("RightButton")
    fmicro:SetScript("OnDragStart", function(self) self:StartMoving() end)
    fmicro:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
  else
    fmicro:IsUserPlaced(false)
  end

  if move_bags == 1 then
    fbag:EnableMouse(true)
    fbag:SetMovable(true)
    fbag:SetUserPlaced(true)
    fbag:RegisterForDrag("RightButton")
    fbag:SetScript("OnDragStart", function(self) self:StartMoving() end)
    fbag:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
  else
    fbag:IsUserPlaced(false)
  end
  
  if move_rightbars == 1 then
    fbar45:EnableMouse(true)
    fbar45:SetMovable(true)
    fbar45:SetUserPlaced(true)
    fbar45:RegisterForDrag("RightButton")
    fbar45:SetScript("OnDragStart", function(self) self:StartMoving() end)
    fbar45:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
  else
    fbar45:IsUserPlaced(false)
  end
  
  if move_pet == 1 then
    fpet:EnableMouse(true)
    fpet:SetMovable(true)
    fpet:SetUserPlaced(true)
    fpet:RegisterForDrag("RightButton")
    fpet:SetScript("OnDragStart", function(self) self:StartMoving() end)
    fpet:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
  else
    fpet:IsUserPlaced(false)
  end
  
  if move_shapeshift == 1 then
    fshift:EnableMouse(true)
    fshift:SetMovable(true)
    fshift:SetUserPlaced(true)
    fshift:RegisterForDrag("RightButton")
    fshift:SetScript("OnDragStart", function(self) self:StartMoving() end)
    fshift:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
  else
    fshift:IsUserPlaced(false)
  end
  
  if move_bar1 == 1 then
    fbar1:EnableMouse(true)
    fbar1:SetMovable(true)
    fbar1:SetUserPlaced(true)
    fbar1:RegisterForDrag("RightButton")
    fbar1:SetScript("OnDragStart", function(self) self:StartMoving() end)
    fbar1:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
  else
    fbar1:IsUserPlaced(false)
  end
  
  if move_bar2 == 1 then
    fbar2:EnableMouse(true)
    fbar2:SetMovable(true)
    fbar2:SetUserPlaced(true)
    fbar2:RegisterForDrag("RightButton")
    fbar2:SetScript("OnDragStart", function(self) self:StartMoving() end)
    fbar2:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
  else
    fbar2:IsUserPlaced(false)
  end
  
  if move_bar3 == 1 then
    fbar3:EnableMouse(true)
    fbar3:SetMovable(true)
    fbar3:SetUserPlaced(true)
    fbar3:RegisterForDrag("RightButton")
    fbar3:SetScript("OnDragStart", function(self) self:StartMoving() end)
    fbar3:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
  else
    fbar3:IsUserPlaced(false)
  end