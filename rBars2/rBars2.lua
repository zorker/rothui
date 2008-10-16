
  local a = CreateFrame("Frame", nil, UIParent)
  local _G = getfenv(0)
  local dummy = function() end
  
  RANGE_INDICATOR = "";
  
  UIPARENT_MANAGED_FRAME_POSITIONS["MultiBarRight"] = nil
  UIPARENT_MANAGED_FRAME_POSITIONS["MultiBarLeft"] = nil
  UIPARENT_MANAGED_FRAME_POSITIONS["MultiBarBottomLeft"] = nil
  UIPARENT_MANAGED_FRAME_POSITIONS["MultiBarBottomRight"] = nil
  UIPARENT_MANAGED_FRAME_POSITIONS["MainMenuBar"] = nil

  a:RegisterEvent("PLAYER_LOGIN")
  
  a:SetScript("OnEvent", function (self,event,arg1)
    if(event=="PLAYER_LOGIN") then
      a:cre_actionbarframe1()
    end 
  end)

  function a:cre_actionbarframe1()
    
    --creating a helper frame to hold the actionbuttons
    local f = CreateFrame("Frame",nil,UIParent)
    f:SetWidth(498)
    f:SetHeight(100)
    --f:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "Interface/Tooltips/UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 4, right = 4, top = 4, bottom = 4 }});
    f:SetPoint("BOTTOM",0,20)
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
    
    ActionButton1:ClearAllPoints()
    ActionButton1:SetPoint("BOTTOMLEFT",f,"BOTTOMLEFT",0,0);    

    --need to do this since I reanchored the bonusactionbar to f
    BonusActionBarTexture0:Hide()
    BonusActionBarTexture1:Hide()
    
    BonusActionButton1:ClearAllPoints()
    BonusActionButton1:SetPoint("BOTTOMLEFT",f,"BOTTOMLEFT",0,0);
    
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
    MultiBarRight:SetPoint("RIGHT",UIParent,"RIGHT",-10, 0)
    
    ShapeshiftButton1:ClearAllPoints()
    ShapeshiftBarFrame:SetParent(f)
    ShapeshiftButton1:SetPoint("BOTTOMLEFT",MultiBarBottomRightButton1,"TOPLEFT",5,15);
    
    -- hide the shapeshift 
    ShapeshiftBarFrame:Hide()
    ShapeshiftBarFrame.Show = dummy
    
    PetActionButton1:ClearAllPoints()
    PetActionBarFrame:SetParent(f)
    PetActionButton1:SetPoint("BOTTOMLEFT",MultiBarBottomRightButton1,"TOPLEFT",5,15);
  
    -- hmmm I don't know if this does anything since the PossesBar becomes the BonusActionBar upon possessing sth
    PossessButton1:ClearAllPoints()
    PossessBarFrame:SetParent(f)
    PossessButton1:SetPoint("BOTTOMLEFT",MultiBarBottomRightButton1,"TOPLEFT",5,15);
  
    -- scaling
    local myscale = 0.8
    MainMenuBar:SetScale(myscale)
    f:SetScale(myscale)
    BonusActionBarFrame:SetScale(1)
    MultiBarBottomLeft:SetScale(myscale)
    MultiBarBottomRight:SetScale(myscale)
    MultiBarRight:SetScale(myscale)
    MultiBarLeft:SetScale(myscale)
    PetActionBarFrame:SetScale(0.85)
    
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
  
    -- Add a green border if button is an equipped item
    local border = getglobal(name.."Border");
    
    -- This does not change the normaltexture, I have no clue why, so I commented it out
    if ( IsEquippedAction(action) ) then
      --border:SetVertexColor(0, 1.0, 0, 0.35);
      --border:Show();
      --self:SetNormalTexture("Interface\\AddOns\\rTextures\\gloss_red");
    else
      --border:Hide();
      --self:SetNormalTexture("Interface\\AddOns\\rTextures\\gloss");
    end
  
    -- Update Macro Text
    local macroName = getglobal(name.."Name");
    if ( not IsConsumableAction(action) and not IsStackableAction(action) ) then
      macroName:SetText(GetActionText(action));
    else
      macroName:SetText("");
    end
  
    -- Update icon and hotkey text
    if ( texture ) then
      icon:SetTexture(texture);
      icon:Show();
      self.rangeTimer = -1;
      self:SetNormalTexture("Interface\\AddOns\\rTextures\\gloss");
    else
      icon:Hide();
      buttonCooldown:Hide();
      self.rangeTimer = nil;
      self:SetNormalTexture("Interface\\AddOns\\rTextures\\gloss");
      local hotkey = getglobal(name.."HotKey");
          if ( hotkey:GetText() == RANGE_INDICATOR ) then
        hotkey:Hide();
      else
        hotkey:SetVertexColor(0.6, 0.6, 0.6);
      end
    end
    ActionButton_UpdateCount(self);  
    
    -- Update tooltip
    if ( GameTooltip:GetOwner() == self ) then
      ActionButton_SetTooltip(self);
    end
  
    self.feedback_action = action;
  end


  -- update usable no make funky colors
  ActionButton_UpdateUsable = function()
    local icon = getglobal(this:GetName().."Icon");
    local normalTexture = getglobal(this:GetName().."NormalTexture");
    if ( IsActionInRange(ActionButton_GetPagedID(this)) == 0 ) 
    then
      icon:SetVertexColor(0.7,0.1,0.1);
      normalTexture:SetVertexColor(1,1,1);
    else
      local isUsable, notEnoughMana = IsUsableAction(ActionButton_GetPagedID(this));
      if ( notEnoughMana ) then
        icon:SetVertexColor(0.1,0.1,0.7);
        normalTexture:SetVertexColor(1,1,1);
      elseif ( isUsable ) then
        icon:SetVertexColor(1, 1, 1);
        normalTexture:SetVertexColor(1,1,1);
      else
        icon:SetVertexColor(0.3,0.3,0.3);
        normalTexture:SetVertexColor(1,1,1);
      end
    end
  end
  
  -- hack to fix the grid alpha. by default the NormalTexture gets 0.5 alpha when you move a button and it keeps this alpha
  -- this fixes this issue 
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
    
    fl:SetTexture("Interface\\AddOns\\rTextures\\flash")
    bu:SetHighlightTexture("Interface\\AddOns\\rTextures\\hover")    
    bu:SetPushedTexture("Interface\\AddOns\\rTextures\\pushed")
    bu:SetCheckedTexture("Interface\\AddOns\\rTextures\\checked") 

    nt:SetHeight(36)
    nt:SetWidth(36)
    nt:SetPoint("Center", 0, 0);

    ic:SetTexCoord(0.1,0.9,0.1,0.9)
    ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 2, -2)
    ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -2, 2)
    
    
  end