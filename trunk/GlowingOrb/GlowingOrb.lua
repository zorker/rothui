  
  local addon = CreateFrame("Frame", nil, UIParent)
  
  addon:RegisterEvent("PLAYER_LOGIN")
  
  addon:SetScript("OnEvent", function ()
    if(event=="PLAYER_LOGIN") then
      
      --UNIQUE_FRAME_NAME, ANCHOR_FRAME, FRAME_STRATA_FILLING, FRAME_STRATA_GLOSS, SIZE, POSITIONANCHOR, POSX, POSY, FONTSIZE1, FONTSIZE2, FONTPADDING, UNITID
      
      addon:create_redorb("redorb1","UIParent","BACKGROUND","LOW",120,"CENTER",-200,0,18,12,10,"player")
      addon:create_blueorb("blueorb1","redorb1","LOW","MEDIUM",70,"CENTER",60,-30,14,12,7,"player")
      
      addon:create_redorb("redorb2","UIParent","BACKGROUND","LOW",120,"CENTER",200,0,18,12,10,"target")
      addon:create_blueorb("blueorb2","redorb2","LOW","MEDIUM",70,"CENTER",-60,-30,14,12,7,"target")
      
    end 
  end)

  function addon:create_redorb(idtag,anchorframe,strata,strata2,width,posanchor,posx,posy,fontsize1,fontsize2,fontpadding,unitid)

    local f = CreateFrame("Frame",idtag,_G[anchorframe])
    f:SetFrameStrata(strata)
    f:SetWidth(width)
    f:SetHeight(width)
    f:SetPoint(posanchor,posx,posy)
   
    local t1 = f:CreateTexture(nil, "BACKGROUND")
    t1:SetTexture("Interface\\AddOns\\GlowingOrb\\orb_back.tga")
    t1:SetAllPoints(f)
    
    local t2 = f:CreateTexture(nil,"ARTWORK")
    t2:SetTexture("Interface\\AddOns\\GlowingOrb\\orb_life.tga")
    t2:SetPoint("BOTTOMLEFT",0,0)
    t2:SetWidth(width)
    t2:SetHeight(width)
    t2:SetVertexColor(0.5,0.5,0.5)
        
    local pm1 = CreateFrame("PlayerModel", nil,f)
    pm1:SetFrameStrata(strata)
    pm1:SetAllPoints(f)
    
    pm1:SetModelScale(1)
    pm1:SetPosition(0, 0, 0) 
    pm1:SetRotation(0)
    pm1:ClearModel()
    pm1:SetModel("SPELLS\\RedRadiationFog.m2")
    pm1:SetModelScale(-.75)
    pm1:SetPosition(-12, 1.5, -1) 
    pm1:SetRotation(0)    
    pm1:SetAlpha(0.8)
    
    pm1:SetScript("OnShow",function() 
      pm1:SetModelScale(1)
      pm1:SetPosition(0, 0, 0) 
      pm1:SetRotation(0)
      pm1:ClearModel()
      pm1:SetModel("SPELLS\\RedRadiationFog.m2")
      pm1:SetModelScale(.75)
      pm1:SetPosition(-12, 1.5, -1) 
      pm1:SetRotation(0)    
      pm1:SetAlpha(0.8)
    end)
    
    local pm2 = CreateFrame("PlayerModel", nil,f)
    pm2:SetFrameStrata(strata)
    pm2:SetAllPoints(f)
    
    pm2:SetModelScale(1)
    pm2:SetPosition(0, 0, 0) 
    pm2:SetRotation(0)
    pm2:ClearModel()
    pm2:SetModel("SPELLS\\RedRadiationFog.m2")
    pm2:SetModelScale(-.75)
    pm2:SetPosition(-12, 1.5, 0.5) 
    pm2:SetRotation(0)    
    pm2:SetAlpha(0.8)
    
    pm2:SetScript("OnShow",function() 
      pm2:SetModelScale(1)
      pm2:SetPosition(0, 0, 0) 
      pm2:SetRotation(0)
      pm2:ClearModel()
      pm2:SetModel("SPELLS\\RedRadiationFog.m2")
      pm2:SetModelScale(.75)
      pm2:SetPosition(-12, 1.5, 0.5) 
      pm2:SetRotation(0)    
      pm2:SetAlpha(0.8)
    end)

    local f3 = CreateFrame("Frame",nil,UIParent)
    f3:SetFrameStrata(strata2)
    f3:SetAllPoints(f) 
    f3:Show()

    local t3 = f3:CreateTexture(nil, "OVERLAY")
    t3:SetTexture("Interface\\AddOns\\GlowingOrb\\orb_gloss.tga")
    t3:SetAllPoints(f3)   
    
    local tex1,tex2
    
    tex1 = f3:CreateFontString(nil, "OVERLAY")
    tex1:SetPoint("CENTER",0,fontpadding)
    tex1:SetFont(NAMEPLATE_FONT, fontsize1, "OUTLINE")
    tex1:SetTextColor(1, 1, 1)
    tex1:SetText(floor((UnitHealth(unitid) / UnitHealthMax(unitid))*100).."%")
    tex1:SetAlpha(0.3)
    --tex1:Hide()
    tex2 = f3:CreateFontString(nil, "OVERLAY")
    tex2:SetPoint("CENTER",0,-fontpadding)
    tex2:SetFont(NAMEPLATE_FONT, fontsize2, "OUTLINE")
    tex2:SetTextColor(1, 1, 1)
    tex2:SetText(UnitHealth(unitid).."/"..UnitHealthMax(unitid))
    tex2:SetAlpha(0.3) 
    
    if(UnitExists(unitid)) then
      f:Show()
      f3:Show()
      DEFAULT_CHAT_FRAME:AddMessage("1 "..unitid)
    else
      f:Hide()
      f3:Hide()
      DEFAULT_CHAT_FRAME:AddMessage("2 "..unitid)
    end    
    
    
    f:SetScript("OnEvent", function(frame, event, unit)
      if event == "UNIT_HEALTH" and unit == unitid then
        t2:SetHeight((UnitHealth(unitid) / UnitHealthMax(unitid)) * width)
        t2:SetTexCoord(0,1,  math.abs(UnitHealth(unitid) / UnitHealthMax(unitid) - 1),1)
        tex1:SetText(floor((UnitHealth(unitid) / UnitHealthMax(unitid))*100).."%")
        tex2:SetText(UnitHealth(unitid).."/"..UnitHealthMax(unitid))
        pm1:SetAlpha(UnitHealth(unitid) / UnitHealthMax(unitid))
        pm2:SetAlpha(UnitHealth(unitid) / UnitHealthMax(unitid))
      elseif event == "PLAYER_ENTERING_WORLD" then
        t2:SetHeight((UnitHealth(unitid) / UnitHealthMax(unitid)) * width)
        t2:SetTexCoord(0,1,  math.abs(UnitHealth(unitid) / UnitHealthMax(unitid) - 1),1)      
        tex1:SetText(floor((UnitHealth(unitid) / UnitHealthMax(unitid))*100).."%")
        tex2:SetText(UnitHealth(unitid).."/"..UnitHealthMax(unitid))
        pm1:SetAlpha(UnitHealth(unitid) / UnitHealthMax(unitid))
        pm2:SetAlpha(UnitHealth(unitid) / UnitHealthMax(unitid))
      elseif event == "PLAYER_LOGIN" then
        t2:SetHeight((UnitHealth(unitid) / UnitHealthMax(unitid)) * width)
        t2:SetTexCoord(0,1,  math.abs(UnitHealth(unitid) / UnitHealthMax(unitid) - 1),1)      
        tex1:SetText(floor((UnitHealth(unitid) / UnitHealthMax(unitid))*100).."%")
        tex2:SetText(UnitHealth(unitid).."/"..UnitHealthMax(unitid))
        pm1:SetAlpha(UnitHealth(unitid) / UnitHealthMax(unitid))
        pm2:SetAlpha(UnitHealth(unitid) / UnitHealthMax(unitid))
      elseif event == "PLAYER_TARGET_CHANGED" and unitid == "target" then
        if(UnitExists(unitid)) then
          f:Show()
          f3:Show()
          t2:SetHeight((UnitHealth(unitid) / UnitHealthMax(unitid)) * width)
          t2:SetTexCoord(0,1,  math.abs(UnitHealth(unitid) / UnitHealthMax(unitid) - 1),1)      
          tex1:SetText(floor((UnitHealth(unitid) / UnitHealthMax(unitid))*100).."%")
          tex2:SetText(UnitHealth(unitid).."/"..UnitHealthMax(unitid))
          pm1:SetAlpha(UnitHealth(unitid) / UnitHealthMax(unitid))
          pm2:SetAlpha(UnitHealth(unitid) / UnitHealthMax(unitid))
          --DEFAULT_CHAT_FRAME:AddMessage("1 "..unitid)
        else
          f:Hide()
          f3:Hide()
          --DEFAULT_CHAT_FRAME:AddMessage("2 "..unitid)
        end   
      end    
    end)
    f:RegisterEvent("UNIT_HEALTH")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("PLAYER_LOGIN")
    f:RegisterEvent("PLAYER_TARGET_CHANGED")
    
  end

  function addon:create_blueorb(idtag,anchorframe,strata,strata2,width,posanchor,posx,posy,fontsize1,fontsize2,fontpadding,unitid)
    
    local f = CreateFrame("Frame",idtag,_G[anchorframe])
    f:SetFrameStrata(strata)
    f:SetWidth(width)
    f:SetHeight(width)
    f:SetPoint(posanchor,posx,posy)
    f:Show()
    
    local t1 = f:CreateTexture(nil, "BACKGROUND")
    t1:SetTexture("Interface\\AddOns\\GlowingOrb\\orb_back.tga")
    t1:SetAllPoints(f)
    
    local t2 = f:CreateTexture(nil,"ARTWORK")
    t2:SetTexture("Interface\\AddOns\\GlowingOrb\\orb_mana.tga")
    t2:SetPoint("BOTTOMLEFT",0,0)
    t2:SetWidth(width)
    t2:SetHeight(width)
    t2:SetVertexColor(0.5,0.5,0.5)
        
    local pm1 = CreateFrame("PlayerModel", nil,f)
    pm1:SetFrameStrata(strata)
    pm1:SetAllPoints(f)
    
    pm1:SetModelScale(1)
    pm1:SetPosition(0, 0, 0) 
    pm1:SetRotation(0)
    pm1:ClearModel()
    pm1:SetModel("SPELLS\\BlueRadiationFog.m2")
    pm1:SetModelScale(.75)
    pm1:SetPosition(-12, 1.5, -1) 
    pm1:SetRotation(0)    
    pm1:SetAlpha(0.8)
    
    pm1:SetScript("OnShow",function() 
      pm1:SetModelScale(1)
      pm1:SetPosition(0, 0, 0) 
      pm1:SetRotation(0)
      pm1:ClearModel()
      pm1:SetModel("SPELLS\\BlueRadiationFog.m2")
      pm1:SetModelScale(.75)
      pm1:SetPosition(-12, 1.5, -1) 
      pm1:SetRotation(0)    
      pm1:SetAlpha(0.8)
    end)
    
    local pm2 = CreateFrame("PlayerModel", nil,f)
    pm2:SetFrameStrata(strata)
    pm2:SetAllPoints(f)
    
    pm2:SetModelScale(1)
    pm2:SetPosition(0, 0, 0) 
    pm2:SetRotation(0)
    pm2:ClearModel()
    pm2:SetModel("SPELLS\\BlueRadiationFog.m2")
    pm2:SetModelScale(.75)
    pm2:SetPosition(-12, 1.5, 0.5) 
    pm2:SetRotation(0)    
    pm2:SetAlpha(0.8)
    
    pm2:SetScript("OnShow",function() 
      pm2:SetModelScale(1)
      pm2:SetPosition(0, 0, 0) 
      pm2:SetRotation(0)
      pm2:ClearModel()
      pm2:SetModel("SPELLS\\BlueRadiationFog.m2")
      pm2:SetModelScale(.75)
      pm2:SetPosition(-12, 1.5, 0.5) 
      pm2:SetRotation(0)    
      pm2:SetAlpha(0.8)
    end)

    local f3 = CreateFrame("Frame",nil,UIParent)
    f3:SetFrameStrata(strata2)
    f3:SetAllPoints(f) 
    f3:Show()

    local t3 = f3:CreateTexture(nil, "OVERLAY")
    t3:SetTexture("Interface\\AddOns\\GlowingOrb\\orb_gloss.tga")
    t3:SetAllPoints(f3)    
    
    local tex1,tex2
    
    tex1 = f3:CreateFontString(nil, "OVERLAY")
    tex1:SetPoint("CENTER",0,fontpadding)
    tex1:SetFont(NAMEPLATE_FONT, fontsize1, "OUTLINE")
    tex1:SetTextColor(1, 1, 1)
    tex1:SetText(floor((UnitMana(unitid) / UnitManaMax(unitid))*100).."%")
    tex1:SetAlpha(0.3)
    --tex1:Hide()
    tex2 = f3:CreateFontString(nil, "OVERLAY")
    tex2:SetPoint("CENTER",0,-fontpadding)
    tex2:SetFont(NAMEPLATE_FONT, fontsize2, "OUTLINE")
    tex2:SetTextColor(1, 1, 1)
    tex2:SetText(UnitMana(unitid).."/"..UnitManaMax(unitid))
    tex2:SetAlpha(0.3) 

    if(UnitExists(unitid)) then
      f:Show()
      f3:Show()
      DEFAULT_CHAT_FRAME:AddMessage("1 "..unitid)
    else
      f:Hide()
      f3:Hide()
      DEFAULT_CHAT_FRAME:AddMessage("2 "..unitid)
    end   
    
    f:SetScript("OnEvent", function(frame, event, unit)
      if (event == "UNIT_MANA" or event == "UNIT_RAGE" or event == "UNIT_ENERGY") and unit == unitid then
        t2:SetHeight((UnitMana(unitid) / UnitManaMax(unitid)) * width)
        t2:SetTexCoord(0,1,  math.abs(UnitMana(unitid) / UnitManaMax(unitid) - 1),1)
        tex1:SetText(floor((UnitMana(unitid) / UnitManaMax(unitid))*100).."%")
        tex2:SetText(UnitMana(unitid).."/"..UnitManaMax(unitid))
        pm1:SetAlpha(UnitMana(unitid) / UnitManaMax(unitid))
        pm2:SetAlpha(UnitMana(unitid) / UnitManaMax(unitid))
      elseif event == "PLAYER_ENTERING_WORLD" then
        t2:SetHeight((UnitMana(unitid) / UnitManaMax(unitid)) * width)
        t2:SetTexCoord(0,1,  math.abs(UnitMana(unitid) / UnitManaMax(unitid) - 1),1)    
        tex1:SetText(floor((UnitMana(unitid) / UnitManaMax(unitid))*100).."%")
        tex2:SetText(UnitMana(unitid).."/"..UnitManaMax(unitid))
        pm1:SetAlpha(UnitMana(unitid) / UnitManaMax(unitid))
        pm2:SetAlpha(UnitMana(unitid) / UnitManaMax(unitid))
      elseif event == "PLAYER_LOGIN" then
        t2:SetHeight((UnitMana(unitid) / UnitManaMax(unitid)) * width)
        t2:SetTexCoord(0,1,  math.abs(UnitMana(unitid) / UnitManaMax(unitid) - 1),1)    
        tex1:SetText(floor((UnitMana(unitid) / UnitManaMax(unitid))*100).."%")
        tex2:SetText(UnitMana(unitid).."/"..UnitManaMax(unitid))
        pm1:SetAlpha(UnitMana(unitid) / UnitManaMax(unitid))
        pm2:SetAlpha(UnitMana(unitid) / UnitManaMax(unitid))
      elseif event == "PLAYER_TARGET_CHANGED" and unitid == "target" then
        if(UnitExists(unitid)) then
          f:Show()
          f3:Show()
          t2:SetHeight((UnitMana(unitid) / UnitManaMax(unitid)) * width)
          t2:SetTexCoord(0,1,  math.abs(UnitMana(unitid) / UnitManaMax(unitid) - 1),1)    
          if (UnitManaMax(unitid) == 0) then
            tex1:SetText("0%")
            tex2:SetText("0/0")
            pm1:SetAlpha(0)
            pm2:SetAlpha(0)            
          else
          tex1:SetText(floor((UnitMana(unitid) / UnitManaMax(unitid))*100).."%")
          tex2:SetText(UnitMana(unitid).."/"..UnitManaMax(unitid))
          pm1:SetAlpha(UnitMana(unitid) / UnitManaMax(unitid))
          pm2:SetAlpha(UnitMana(unitid) / UnitManaMax(unitid))            
          end
          --DEFAULT_CHAT_FRAME:AddMessage("1 "..(UnitMana(unitid) / UnitManaMax(unitid)))
        else
          f:Hide()
          f3:Hide()
          --DEFAULT_CHAT_FRAME:AddMessage("2 "..unitid)
        end   
      end  
    end)
    f:RegisterEvent("UNIT_MANA")
    f:RegisterEvent("UNIT_RAGE")
    f:RegisterEvent("UNIT_ENERGY")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("PLAYER_LOGIN")
    f:RegisterEvent("PLAYER_TARGET_CHANGED")
    
  end