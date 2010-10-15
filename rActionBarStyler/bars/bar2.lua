  
  --get the addon namespace
  local addon, ns = ...
  
  --get the config values
  local cfg = ns.cfg
  local barcfg = cfg.bars.bar2
  
  local bar = CreateFrame("Frame","rABS_MultiBarBottomLeft",UIParent, "SecureHandlerStateTemplate")
  if barcfg.uselayout2x6 then
    bar:SetWidth(barcfg.buttonsize*6+barcfg.buttonspacing*5)
    bar:SetHeight(barcfg.buttonsize*2+barcfg.buttonspacing)
  else  
    bar:SetWidth(barcfg.buttonsize*12+barcfg.buttonspacing*11)
    bar:SetHeight(barcfg.buttonsize)
  end
  if barcfg.uselayout2x6 then
    bar:SetPoint(barcfg.pos.a1,barcfg.pos.af,barcfg.pos.a2,barcfg.pos.x+((barcfg.buttonsize*6+barcfg.buttonspacing*6)/2),barcfg.pos.y-(barcfg.buttonsize*1+barcfg.buttonspacing*1)+0.5)
  else 
    bar:SetPoint(barcfg.pos.a1,barcfg.pos.af,barcfg.pos.a2,barcfg.pos.x,barcfg.pos.y)
  end
  bar:SetHitRectInsets(-cfg.barinset, -cfg.barinset, -cfg.barinset, -cfg.barinset)
  
  if barcfg.testmode then
    bar:SetBackdrop(cfg.backdrop)
    bar:SetBackdropColor(1,0.8,1,0.6)
  end
  bar:SetScale(barcfg.barscale)

  cfg.applyDragFunctionality(bar,barcfg.userplaced,barcfg.locked)

  MultiBarBottomLeft:SetParent(bar)
  
  for i=1, 12 do
  	local button = _G["MultiBarBottomLeftButton"..i]
  	button:SetSize(barcfg.buttonsize, barcfg.buttonsize)
  	button:ClearAllPoints()
  	if i == 1 then
  		button:SetPoint("BOTTOMLEFT", bar, 0,0)
  	else
  	  local previous = _G["MultiBarBottomLeftButton"..i-1]  		
			if barcfg.uselayout2x6 and i == 7 then
			  previous = _G["MultiBarBottomLeftButton1"]
        button:SetPoint("BOTTOMLEFT", previous, "TOPLEFT", 0, barcfg.buttonspacing)
			else
			  button:SetPoint("LEFT", previous, "RIGHT", barcfg.buttonspacing, 0)
		  end
  		
  	end
  end
  
  if barcfg.showonmouseover then    
    local function lighton(alpha)
      if MultiBarBottomLeft:IsShown() then
        for i=1, 12 do
          local pb = _G["MultiBarBottomLeftButton"..i]
          pb:SetAlpha(alpha)
        end
      end
    end    
    bar:EnableMouse(true)
    bar:SetScript("OnEnter", function(self) lighton(1) end)
    bar:SetScript("OnLeave", function(self) lighton(0) end)  
    for i=1, 12 do
      local pb = _G["MultiBarBottomLeftButton"..i]
      pb:SetAlpha(0)
      pb:HookScript("OnEnter", function(self) lighton(1) end)
      pb:HookScript("OnLeave", function(self) lighton(0) end)
    end    
  end