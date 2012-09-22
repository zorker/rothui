  
  --get the addon namespace
  local addon, ns = ...
  
  --get the config values
  local cfg = ns.cfg
  local barcfg = cfg.bars.bar4
  
  local bar = CreateFrame("Frame","rABS_MultiBarRight",UIParent, "SecureHandlerStateTemplate")
  bar:SetHeight(barcfg.buttonsize*12+barcfg.buttonspacing*11)
  bar:SetWidth(barcfg.buttonsize)
  bar:SetPoint(barcfg.pos.a1,barcfg.pos.af,barcfg.pos.a2,barcfg.pos.x,barcfg.pos.y)
  bar:SetHitRectInsets(-cfg.barinset, -cfg.barinset, -cfg.barinset, -cfg.barinset)
  
  if barcfg.testmode then
    bar:SetBackdrop(cfg.backdrop)
    bar:SetBackdropColor(1,0.8,1,0.6)
  end
  bar:SetScale(barcfg.barscale)

  cfg.applyDragFunctionality(bar,barcfg.userplaced,barcfg.locked)

  MultiBarRight:SetParent(bar)
  
  for i=1, 12 do
    local button = _G["MultiBarRightButton"..i]
    button:ClearAllPoints()
    button:SetSize(barcfg.buttonsize, barcfg.buttonsize)
    if i == 1 then
      button:SetPoint("TOPLEFT", bar, 0,0)
    else
      local previous = _G["MultiBarRightButton"..i-1]
      button:SetPoint("TOP", previous, "BOTTOM", 0, -barcfg.buttonspacing)
    end
  end
  
  if barcfg.showonmouseover then    
    local function lighton(alpha)
      if MultiBarRight:IsShown() then
        for i=1, 12 do
          local pb = _G["MultiBarRightButton"..i]
          pb:SetAlpha(alpha)
        end
      end
    end    
    bar:EnableMouse(true)
    bar:SetScript("OnEnter", function(self) lighton(1) end)
    bar:SetScript("OnLeave", function(self) lighton(0) end)  
    for i=1, 12 do
      local pb = _G["MultiBarRightButton"..i]
      pb:SetAlpha(0)
      pb:HookScript("OnEnter", function(self) lighton(1) end)
      pb:HookScript("OnLeave", function(self) lighton(0) end)
    end    
  end