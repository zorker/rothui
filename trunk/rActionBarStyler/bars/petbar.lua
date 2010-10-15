  
  --get the addon namespace
  local addon, ns = ...
  
  --get the config values
  local cfg = ns.cfg
  local barcfg = cfg.bars.petbar
  
  if not barcfg.disable then
  
    local num = NUM_PET_ACTION_SLOTS
    
    local bar = CreateFrame("Frame","rABS_PetBar",UIParent, "SecureHandlerStateTemplate")
    bar:SetWidth(barcfg.buttonsize*num+barcfg.buttonspacing*(num-1))
    bar:SetHeight(barcfg.buttonsize)
    bar:SetPoint(barcfg.pos.a1,barcfg.pos.af,barcfg.pos.a2,barcfg.pos.x,barcfg.pos.y)
    bar:SetHitRectInsets(-cfg.barinset, -cfg.barinset, -cfg.barinset, -cfg.barinset)
    
    if barcfg.testmode then
      bar:SetBackdrop(cfg.backdrop)
      bar:SetBackdropColor(1,0.8,1,0.6)
    end
    bar:SetScale(barcfg.barscale)
  
    cfg.applyDragFunctionality(bar,barcfg.userplaced,barcfg.locked)
  
    PetActionBarFrame:SetParent(bar)
    
    for i=1, num do
      local button = _G["PetActionButton"..i]
      button:SetSize(barcfg.buttonsize, barcfg.buttonsize)
      button:ClearAllPoints()
      if i == 1 then
        button:SetPoint("BOTTOMLEFT", bar, 0,0)
      else
        local previous = _G["PetActionButton"..i-1]      
        button:SetPoint("LEFT", previous, "RIGHT", barcfg.buttonspacing, 0)
      end
    end
    
    if barcfg.showonmouseover then    
      local function lighton(alpha)
        if PetActionBarFrame:IsShown() then
          for i=1, num do
            local pb = _G["PetActionButton"..i]
            pb:SetAlpha(alpha)
          end
        end
      end    
      bar:EnableMouse(true)
      bar:SetScript("OnEnter", function(self) lighton(1) end)
      bar:SetScript("OnLeave", function(self) lighton(0) end)  
      for i=1, num do
        local pb = _G["PetActionButton"..i]
        pb:SetAlpha(0)
        pb:HookScript("OnEnter", function(self) lighton(1) end)
        pb:HookScript("OnLeave", function(self) lighton(0) end)
      end    
    end

  end --disable