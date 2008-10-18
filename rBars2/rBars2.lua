   
  -----------------------------
  -- configure textures here --
  -----------------------------
  
  local rb2_normal_texture    = "Interface\\AddOns\\rTextures\\gloss";
  local rb2_flash_texture     = "Interface\\AddOns\\rTextures\\flash";
  local rb2_hover_texture     = "Interface\\AddOns\\rTextures\\hover";    
  local rb2_pushed_texture    = "Interface\\AddOns\\rTextures\\pushed";
  local rb2_checked_texture   = "Interface\\AddOns\\rTextures\\checked"; 
  local rb2_equipped_texture  = "Interface\\AddOns\\rTextures\\gloss_green";

  --make buttons use this alpha when out of range, out of mana etc. range 0-1.
  local fade_alpha = 0.5;

  -- scale, SCALE your buttons here. range 0-1, 0.7 = 70%
  local myscale = 0.75
  
  --button system for bar 1 and bar 2
  -- 0 = 1x12 layout
  -- 1 = 2x6  layout
  local button_system = 1
  
  -- hide shapeshift frame
  -- 0 = not hidden
  -- 1 = hidden
  -- IMPORTANT, you will need my transparent textures to hide the background stuff
  -- http://code.google.com/p/rothui/source/browse/#svn/trunk/Interface/ShapeshiftBar
  local hide_shapeshift = 1

  -- end config --

  local a = CreateFrame("Frame", nil, UIParent)
  local _G = getfenv(0)
  local dummy = function() end    
  
  UIPARENT_MANAGED_FRAME_POSITIONS["MultiBarRight"] = nil
  UIPARENT_MANAGED_FRAME_POSITIONS["MultiBarLeft"] = nil
  UIPARENT_MANAGED_FRAME_POSITIONS["MultiBarBottomLeft"] = nil
  UIPARENT_MANAGED_FRAME_POSITIONS["MultiBarBottomRight"] = nil
  UIPARENT_MANAGED_FRAME_POSITIONS["MainMenuBar"] = nil

  a:RegisterEvent("PLAYER_ENTERING_WORLD")
  a:RegisterEvent("PLAYER_LOGIN")
  
  --to hide the right bar in combat and show it out of combat
  --a:RegisterEvent("PLAYER_REGEN_ENABLED")
  --a:RegisterEvent("PLAYER_REGEN_DISABLED")
  
  a:SetScript("OnEvent", function (self,event,arg1)
    if(event=="PLAYER_LOGIN") then
      a:cre_actionbarframe1()
    elseif(event=="PLAYER_ENTERING_WORLD") then
      --TEST, will try this later
      MainMenuBar:Hide()
    end 
    
    --to fade the right button bar ooc/ic
    --need to test this later
    --[[
    if event == "PLAYER_REGEN_ENABLED" then
      for i = 1, 12 do
        _G["MultiBarRightButton"..i]:SetAlpha(1);
      end
    elseif event == "PLAYER_REGEN_DISABLED" then
      for i = 1, 12 do
        _G["MultiBarRightButton"..i]:SetAlpha(0);
      end
    end
    ]]--
    
  end)

  function a:cre_actionbarframe1()
  
    RANGE_INDICATOR = "";
    

    
    --creating a helper frame to hold the actionbuttons
    local f = CreateFrame("Frame","rBars2_Button_Holder_Frame",UIParent)
    f:SetWidth(498)
    f:SetHeight(100)
    --f:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "Interface/Tooltips/UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 4, right = 4, top = 4, bottom = 4 }});
    f:SetPoint("BOTTOM",0,30)
    f:Show()
    
    -- hack to fix the bonusactionbar when hiding the mainmenubar
    BonusActionBarFrame:SetParent(f)
    
    -- since I am reanchoring all the buttons I can hide the MainMenuBar
    MainMenuBar:Hide()  
    
    local j
    for j=1,12 do
      a:dostuff("ActionButton", j, f)
      a:setnewparent("ActionButton", j, f)
      a:dostuff("BonusActionButton", j, f)
      a:dostuff("MultiBarBottomRightButton", j, f)
      a:dostuff("MultiBarBottomLeftButton", j, f)
      a:dostuff("MultiBarLeftButton", j, f)
      a:dostuff("MultiBarRightButton", j, f)
    end
    
    local k
    for k=1,10 do
      a:dopeticons("PetActionButton", k)
    end
    
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
  
    MultiBarRightButton1:ClearAllPoints()
    MultiBarRightButton1:SetPoint("RIGHT",UIParent,"RIGHT",-30, 190)
    
    MultiBarLeftButton1:ClearAllPoints()
    MultiBarLeftButton1:SetPoint("TOPLEFT",MultiBarRightButton1,"TOPLEFT",-43, 0)
    
    ShapeshiftButton1:ClearAllPoints()
    ShapeshiftBarFrame:SetParent(f)
    ShapeshiftButton1:SetPoint("BOTTOMLEFT",MultiBarBottomRightButton1,"TOPLEFT",5,15);
    
    -- hide the shapeshift 
    if hide_shapeshift == 1 then
      ShapeshiftBarFrame:Hide()
      ShapeshiftBarFrame.Show = dummy
    end
    
    PetActionButton1:ClearAllPoints()
    PetActionBarFrame:SetParent(f)
    PetActionButton1:SetPoint("BOTTOMLEFT",MultiBarBottomRightButton1,"TOPLEFT",5,15);
  
    -- hmmm I don't know if this does anything since the PossesBar becomes the BonusActionBar upon possessing sth
    PossessButton1:ClearAllPoints()
    PossessBarFrame:SetParent(f)
    PossessButton1:SetPoint("BOTTOMLEFT",MultiBarBottomRightButton1,"TOPLEFT",5,15);
  
    MainMenuBar:SetScale(myscale)
    f:SetScale(myscale)
    BonusActionBarFrame:SetScale(1)
    MultiBarBottomLeft:SetScale(myscale)
    MultiBarBottomRight:SetScale(myscale)
    MultiBarRight:SetScale(myscale)
    MultiBarLeft:SetScale(myscale)
    PetActionBarFrame:SetScale(myscale*1.09)
    
  end
  
  -- some functions  
  
  -- hides the actionbuttons when a bonusactionbar is active (normaly the blizzard background texture would overlap it
  -- but I use no background texture
  local bonushooks = {};
  local i;
  
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
  
  -- rewrite the Blizzard ActionButton_Update function. I kept most of it the same but I changed the normaltexture to my gloss texture
  ActionButton_Update = function(self)
    -- Special case code for bonus bar buttons
    -- Prevents the button from updating if the bonusbar is still in an animation transition
    if ( self.isBonus and self.inTransition ) then
      self.needsUpdate = true;
      ActionButton_UpdateUsable(self);
      return;
    end
    
    local name = self:GetName();
  
    local action = self.action;
    local icon = getglobal(name.."Icon");
    local buttonCooldown = getglobal(name.."Cooldown");
    local texture = GetActionTexture(action);  
    
    if ( HasAction(action) ) then
      if ( not self.eventsRegistered ) then
        self:RegisterEvent("ACTIONBAR_UPDATE_STATE");
        self:RegisterEvent("ACTIONBAR_UPDATE_USABLE");
        self:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN");
        self:RegisterEvent("UPDATE_INVENTORY_ALERTS");
        self:RegisterEvent("PLAYER_TARGET_CHANGED");
        self:RegisterEvent("TRADE_SKILL_SHOW");
        self:RegisterEvent("TRADE_SKILL_CLOSE");
        self:RegisterEvent("PLAYER_ENTER_COMBAT");
        self:RegisterEvent("PLAYER_LEAVE_COMBAT");
        self:RegisterEvent("START_AUTOREPEAT_SPELL");
        self:RegisterEvent("STOP_AUTOREPEAT_SPELL");
        self.eventsRegistered = true;
      end
  
      if ( not self:GetAttribute("statehidden") ) then
        self:Show();
      end
      ActionButton_UpdateState(self);
      ActionButton_UpdateUsable(self);
      ActionButton_UpdateCooldown(self);
      ActionButton_UpdateFlash(self);
    else
      if ( self.eventsRegistered ) then
        self:UnregisterEvent("ACTIONBAR_UPDATE_STATE");
        self:UnregisterEvent("ACTIONBAR_UPDATE_USABLE");
        self:UnregisterEvent("ACTIONBAR_UPDATE_COOLDOWN");
        self:UnregisterEvent("UPDATE_INVENTORY_ALERTS");
        self:UnregisterEvent("PLAYER_TARGET_CHANGED");
        self:UnregisterEvent("TRADE_SKILL_SHOW");
        self:UnregisterEvent("TRADE_SKILL_CLOSE");
        self:UnregisterEvent("PLAYER_ENTER_COMBAT");
        self:UnregisterEvent("PLAYER_LEAVE_COMBAT");
        self:UnregisterEvent("START_AUTOREPEAT_SPELL");
        self:UnregisterEvent("STOP_AUTOREPEAT_SPELL");
        self.eventsRegistered = nil;
      end
  
      if ( self:GetAttribute("showgrid") == 0 ) then
        self:Hide();
      else
        buttonCooldown:Hide();
      end
    end
  
    -- Update Macro Text
    --[[
    local macroName = getglobal(name.."Name");
    if ( not IsConsumableAction(action) and not IsStackableAction(action) ) then
      macroName:SetText(GetActionText(action));
    else
      macroName:SetText("");
    end
    ]]--
  
    -- Update icon and hotkey text
    if ( texture ) then
      icon:SetTexture(texture);
      icon:Show();
      self.rangeTimer = -1;
      self:SetNormalTexture(rb2_normal_texture);
    else
      icon:Hide();
      buttonCooldown:Hide();
      self.rangeTimer = nil;
      self:SetNormalTexture(rb2_normal_texture);
      --[[
      local hotkey = getglobal(name.."HotKey");
      if ( hotkey:GetText() == RANGE_INDICATOR ) then
        hotkey:Hide();
      else
        hotkey:SetVertexColor(0.6, 0.6, 0.6);
      end
      ]]--
    end
    ActionButton_UpdateCount(self);  
    
    local border = getglobal(name.."Border");
    border:Hide();
    
    -- give equipped items a green border texture
    --[[
    if ( IsEquippedAction(action) ) then
      self:SetNormalTexture(rb2_equipped_texture);
    else
      self:SetNormalTexture(rb2_normal_texture);
    end    
    ]]--
    
    -- Update tooltip
    if ( GameTooltip:GetOwner() == self ) then
      ActionButton_SetTooltip(self);
    end
  
    self.feedback_action = action;
  end

  -- update usable to make funky colors
  ActionButton_UpdateUsable = function (self)
    if ( self:GetAttribute("showgrid") == 0 ) then
      local name = self:GetName();
      local icon = getglobal(name.."Icon");
      local normalTexture = getglobal(name.."NormalTexture");
      local isUsable, notEnoughMana = IsUsableAction(self.action);
      local valid = IsActionInRange(self.action);
      if ( valid == 0 ) then
        --red
        icon:SetVertexColor(1.0, 0.1, 0.1,fade_alpha);
        normalTexture:SetAlpha(fade_alpha)
      elseif ( isUsable ) then
        --white
        icon:SetVertexColor(1.0, 1.0, 1.0, 1);
        normalTexture:SetAlpha(1)
      elseif ( notEnoughMana ) then
        --blue
        icon:SetVertexColor(0.25, 0.25, 1.0,fade_alpha);
        normalTexture:SetAlpha(fade_alpha)
      else
        --grey
        icon:SetVertexColor(0.4, 0.4, 0.4,fade_alpha);
        normalTexture:SetAlpha(fade_alpha)
      end
    else
      local name = self:GetName();
      local icon = getglobal(name.."Icon");
      icon:SetVertexColor(1.0, 1.0, 1.0, 1);
    end
  end
  
  -- had to rewrite this to call the ActionButton_UpdateUsable function, this finally makes it possible to
  -- bring range and manacoloring together in one function
  ActionButton_OnUpdate = function (self, elapsed)
    if ( ActionButton_IsFlashing(self) ) then
      local flashtime = self.flashtime;
      flashtime = flashtime - elapsed;
      
      if ( flashtime <= 0 ) then
        local overtime = -flashtime;
        if ( overtime >= ATTACK_BUTTON_FLASH_TIME ) then
          overtime = 0;
        end
        flashtime = ATTACK_BUTTON_FLASH_TIME - overtime;
  
        local flashTexture = getglobal(self:GetName().."Flash");
        if ( flashTexture:IsShown() ) then
          flashTexture:Hide();
        else
          flashTexture:Show();
        end
      end
      
      self.flashtime = flashtime;
    end
    
    -- Handle range indicator
    local rangeTimer = self.rangeTimer;
    if ( rangeTimer ) then
      rangeTimer = rangeTimer - elapsed;  
      if ( rangeTimer <= 0 ) then
        --call UpdateUsable when timer is OK
        ActionButton_UpdateUsable(self);
        rangeTimer = TOOLTIP_UPDATE_TIME;
      end
      
      self.rangeTimer = rangeTimer;
    end
  end
  
  -- hack to fix the grid alpha. by default the NormalTexture gets 0.5 alpha when you move a button and it keeps this alpha
  -- fixes this issue 
  ActionButton_ShowGrid = function (button)
    button:SetAttribute("showgrid", button:GetAttribute("showgrid") + 1);
    getglobal(button:GetName().."NormalTexture"):SetVertexColor(1.0, 1.0, 1.0, 1);
     button:Show();
  end

  -- function to anchor the button to f
  function a:setnewparent(name, i, frame)
    local bu  = _G[name..i]
    bu:SetParent(frame);
  end  

  -- gives the buttons nice new textures....bling bling
  function a:dostuff(name, i, frame)
  
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
    
    fl:SetTexture(rb2_flash_texture)
    bu:SetHighlightTexture(rb2_hover_texture)
    bu:SetPushedTexture(rb2_pushed_texture)
    bu:SetCheckedTexture(rb2_checked_texture)

    nt:SetHeight(36)
    nt:SetWidth(36)
    nt:SetPoint("Center", 0, 0);

    ic:SetTexCoord(0.1,0.9,0.1,0.9)
    ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 2, -2)
    ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -2, 2)
    
    
  end
  
  
  function a:dopeticons(name, i)
    
    local bu  = _G[name..i]
    local ic  = _G[name..i.."Icon"]
    local nt  = _G[name..i.."NormalTexture2"]
    
    ic:SetTexCoord(0.1,0.9,0.1,0.9)
    bu:SetNormalTexture(rb2_normal_texture)
    bu.SetNormalTexture = dummy
    nt:SetPoint("TOPLEFT", bu, "TOPLEFT", -2, 2);
    nt:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 2, -2);  
  end
  