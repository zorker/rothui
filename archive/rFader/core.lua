local hide = CreateFrame("Frame", nil, UIParent)

hide:RegisterEvent("PLAYER_REGEN_ENABLED")
hide:RegisterEvent("PLAYER_REGEN_DISABLED")
hide:RegisterEvent("PLAYER_ENTERING_WORLD")
hide:RegisterEvent("PLAYER_LOGIN")

hide:SetScript("OnEvent", function ()

  if(event=="PLAYER_LOGIN") then
    --hide:create_trinketbarframe()
    --hide:create_actionbarframe()

    hide:create_angelframe()
    hide:create_demonframe()
    hide:create_d3mapframe()
    
    --hide:create_topframe()
    hide:create_bottomframe()
    hide:create_d3barframe()

    --hide:create_testrechts()
    --hide:create_testlinks()

  end 

  if event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_ENTERING_WORLD" then

    rUnits_Player:SetAlpha(0.3)
    rUnits_Target:SetAlpha(0.3)
    rUnits_ToT:SetAlpha(0.3)

    --for i = 25, 36 do
    --  _G["BongosActionButton"..i]:Show();
    --end;
    
  elseif event == "PLAYER_REGEN_DISABLED" then

    rUnits_Player:SetAlpha(1)
    rUnits_Target:SetAlpha(1)
    rUnits_ToT:SetAlpha(1)
    
    --for i = 25, 36 do
    --  _G["BongosActionButton"..i]:Hide();
    --end;
    
  end
end)


  function hide:create_actionbarframe()
    local f = CreateFrame("Frame",nil,UIParent)
    f:SetFrameStrata("BACKGROUND")
    f:SetWidth(340)
    f:SetHeight(170)
    
    local t = f:CreateTexture(nil,"BACKGROUND")
    t:SetTexture("Interface\\AddOns\\rTextures\\interface_actionbar_back")
    t:SetTexCoord(0.1,0.9,0.1,0.9)
    t:SetAllPoints(f)
    f.texture = t
    
    f:SetPoint("CENTER",0,-290)
    f:Show()
  end
  
  function hide:create_angelframe()
    local f = CreateFrame("Frame",nil,UIParent)
    f:SetFrameStrata("TOOLTIP")
    f:SetWidth(155)
    f:SetHeight(155)
    
    local t = f:CreateTexture(nil,"BACKGROUND")
    t:SetTexture("Interface\\AddOns\\rTextures\\d3_angel")
    --t:SetTexCoord(0.1,0.9,0.1,0.9)
    t:SetAllPoints(f)
    f.texture = t
    
    f:SetPoint("BOTTOM",275,0)
    f:Show()
  end
  
  function hide:create_demonframe()
    local f = CreateFrame("Frame",nil,UIParent)
    f:SetFrameStrata("TOOLTIP")
    f:SetWidth(155)
    f:SetHeight(155)
    
    local t = f:CreateTexture(nil,"HIGHLIGHT ")
    t:SetTexture("Interface\\AddOns\\rTextures\\d3_demon")
    --t:SetTexCoord(0.1,0.9,0.1,0.9)
    t:SetAllPoints(f)
    f.texture = t
    
    f:SetPoint("BOTTOM",-280,0)
    f:Show()
  end
  
  function hide:create_d3mapframe()
    local f = CreateFrame("Frame",nil,UIParent)
    f:SetFrameStrata("LOW")
    f:SetWidth(360)
    f:SetHeight(180)
    
    local t = f:CreateTexture(nil,"BACKGROUND")
    t:SetTexture("Interface\\AddOns\\rTextures\\d3_map")
    --t:SetTexCoord(0.1,0.9,0.1,0.9)
    t:SetAllPoints(f)
    f.texture = t
    
    f:SetPoint("TOPRIGHT",78,-5)
    f:Show()
  end
  
  function hide:create_topframe()
    local f = CreateFrame("Frame",nil,UIParent)
    f:SetFrameStrata("BACKGROUND")
    f:SetWidth(512)
    f:SetHeight(64)
    
    local t = f:CreateTexture(nil,"BACKGROUND")
    t:SetTexture("Interface\\AddOns\\rTextures\\d3_top")
    --t:SetTexCoord(0.1,0.9,0.1,0.9)
    t:SetAllPoints(f)
    f.texture = t
    
    f:SetPoint("BOTTOM",0,54)
    f:Show()
  end
  
  function hide:create_bottomframe()
    local f = CreateFrame("Frame",nil,UIParent)
    f:SetFrameStrata("TOOLTIP")
    f:SetWidth(450)
    f:SetHeight(112)
    
    local t = f:CreateTexture(nil,"BACKGROUND")
    t:SetTexture("Interface\\AddOns\\rTextures\\d3_bottom")
    --t:SetTexCoord(0.1,0.9,0.1,0.9)
    t:SetAllPoints(f)
    f.texture = t
    
    f:SetPoint("BOTTOM",0,0)
    f:Show()
  end
  
  function hide:create_d3barframe()
    local f = CreateFrame("Frame",nil,UIParent)
    f:SetFrameStrata("BACKGROUND")
    f:SetWidth(512)
    f:SetHeight(256)
    
    local t = f:CreateTexture(nil,"BACKGROUND")
    t:SetTexture("Interface\\AddOns\\rTextures\\d3_bar4")
    --t:SetTexCoord(0.1,0.9,0.1,0.9)
    t:SetAllPoints(f)
    f.texture = t
    
    f:SetPoint("BOTTOM",0,14)
    f:Show()
  end
  
  function hide:create_testrechts()
    local f = CreateFrame("Frame",nil,UIParent)
    f:SetFrameStrata("TOOLTIP")
    f:SetWidth(512)
    f:SetHeight(128)
    
    local t = f:CreateTexture(nil,"BACKGROUND")
    t:SetTexture("Interface\\AddOns\\rTextures\\testrechts")
    --t:SetTexCoord(0.1,0.9,0.1,0.9)
    t:SetAllPoints(f)
    f.texture = t
    
    f:SetPoint("BOTTOM",256,0)
    f:Show()
    f:SetAlpha(0.5)
    
  end
  
  function hide:create_testlinks()
    local f = CreateFrame("Frame",nil,UIParent)
    f:SetFrameStrata("TOOLTIP")
    f:SetWidth(512)
    f:SetHeight(128)
    
    local t = f:CreateTexture(nil,"BACKGROUND")
    t:SetTexture("Interface\\AddOns\\rTextures\\testlinks")
    --t:SetTexCoord(0.1,0.9,0.1,0.9)
    t:SetAllPoints(f)
    f.texture = t
    
    f:SetPoint("BOTTOM",-256,0)
    f:Show()
    f:SetAlpha(0.5)
  end
  
  function hide:create_trinketbarframe()
    local f = CreateFrame("Frame",nil,UIParent)
    f:SetFrameStrata("BACKGROUND")
    f:SetWidth(340)
    f:SetHeight(85)
    
    local t = f:CreateTexture(nil,"BACKGROUND")
    t:SetTexture("Interface\\AddOns\\rTextures\\interface_trinketbar_back")
    t:SetTexCoord(0.1,0.9,0.1,0.9)
    t:SetAllPoints(f)
    f.texture = t

    f:SetPoint("CENTER",0,-360)
    f:Show()
  end