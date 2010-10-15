  
  --get the addon namespace
  local addon, ns = ...
  
  --get the config values
  local cfg = ns.cfg
  local barcfg = cfg.bars.bags
  
  if not barcfg.disable then
  
    local bar = CreateFrame("Frame","rABS_Bags",UIParent, "SecureHandlerStateTemplate")
    bar:SetWidth(200)
    bar:SetHeight(40)
    bar:SetPoint(barcfg.pos.a1,barcfg.pos.af,barcfg.pos.a2,barcfg.pos.x,barcfg.pos.y)
    bar:SetHitRectInsets(-cfg.barinset, -cfg.barinset, -cfg.barinset, -cfg.barinset)
    bar:SetScale(barcfg.barscale)
        
    if barcfg.testmode then
      bar:SetBackdrop(cfg.backdrop)
      bar:SetBackdropColor(1,0.8,1,0.6)
    end
  
    cfg.applyDragFunctionality(bar,barcfg.userplaced,barcfg.locked)
  
    local BagButtons = {
      MainMenuBarBackpackButton,
      CharacterBag0Slot,
      CharacterBag1Slot,
      CharacterBag2Slot,
      CharacterBag3Slot,
      KeyRingButton,
    }  
    for _, f in pairs(BagButtons) do
      f:SetParent(bar);
    end
    MainMenuBarBackpackButton:ClearAllPoints();
    MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", 0, 0);
    
    if barcfg.showonmouseover then    
      local function lighton(alpha)
        for _, f in pairs(BagButtons) do
          f:SetAlpha(alpha)
        end
      end    
      bar:EnableMouse(true)
      bar:SetScript("OnEnter", function(self) lighton(1) end)
      bar:SetScript("OnLeave", function(self) lighton(0) end)  
      for _, f in pairs(BagButtons) do
        f:SetAlpha(0)
        f:HookScript("OnEnter", function(self) lighton(1) end)
        f:HookScript("OnLeave", function(self) lighton(0) end)
      end
  	  bar:SetScript("OnEvent", function(self) lighton(0) end)
  	  bar:RegisterEvent("PLAYER_ENTERING_WORLD")
    end
  

end