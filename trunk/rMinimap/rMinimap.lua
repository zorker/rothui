   
  -----------------------------
  -- configure map style here --
  -----------------------------
  
  -- anchor1
  local anchor1 = "TOPRIGHT"
  
  -- anchor2
  local anchor2 = "TOPRIGHT"
  
  -- anchorframe
  local anchorframe = UIParent
  
  -- pos_x
  local pos_x = -20
  
  -- pos y
  local pos_y = -20
  
  -- map_style
  -- 0 = diablo3
  -- 1 = futuristic orb rotating
  -- 2 = square runits style
  local map_style = 0

  -- end config --
  
  
  local a = CreateFrame("Frame", nil, UIParent)
  local _G = getfenv(0)
  local dummy = function() end    
  
  a:RegisterEvent("PLAYER_LOGIN")
  
  a:SetScript("OnEvent", function (self,event,arg1)
    if(event=="PLAYER_LOGIN") then
      a:showhidestuff()
      if map_style == 0 then
        a:dostuff0()
      elseif map_style == 1 then
        a:dostuff1()
        a:rotateme()
      elseif map_style == 2 then
        a:dostuff2()
      end
      --zoomscript taken from pminimap by p3lim
      --http://www.wowinterface.com/downloads/info8389-pMinimap.html
      a:zoomscript()
    end
  end)  
  
  function a:dostuff0()
    --MiniMapTracking:SetPoint("BOTTOMRIGHT", 24, -10)
    local t = Minimap:CreateTexture(nil,"Overlay")
    t:SetTexture("Interface\\AddOns\\rTextures\\d3_map2")
    local d3mapscale = 1.3
    t:SetPoint("CENTER", Minimap, "CENTER", 0, -10*d3mapscale)
    --t:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 1, -1)
    t:SetWidth(Minimap:GetHeight()*2*d3mapscale)
    t:SetHeight(Minimap:GetHeight()*d3mapscale)
  end
  
  function a:dostuff2()
    --MiniMapTracking:SetPoint("TOPLEFT", 0, 0)
    Minimap:SetMaskTexture("Interface\\AddOns\\rMinimap\\mask")
    local t = Minimap:CreateTexture(nil,"Overlay")
    t:SetTexture("Interface\\AddOns\\rTextures\\minigloss")
    t:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -1, 1)
    t:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 1, -1)
  end
  
  function a:dostuff1()
    --MiniMapTracking:SetPoint("TOPRIGHT", 30, 30)  
  end
  
  function a:rotateme()
    --DEFAULT_CHAT_FRAME:AddMessage("ping")
    local r2, r42, realUpdate, colorTable = math.sqrt(0.5^2+0.5^2), math.sqrt(42), true, {[4]=0.9};
    
    local f = CreateFrame("Frame",nil,Minimap)
    f:SetWidth(194)
    f:SetHeight(194)
    f:SetPoint("CENTER",0,0)
    f:Show()
    
    local t = f:CreateTexture(nil,"BACKGROUND")
    t:SetTexture("Interface\\AddOns\\rTextures\\map_texture.tga")
    t:SetAllPoints(f)
    t:SetVertexColor(0.8,0.8,0.8,1)
    
    local totalElapsed = 0
    local degrees = 0
    
    local function OnUpdateFunc(self, elapsed)
      totalElapsed = totalElapsed + elapsed
      local update_timer = 1
      if (totalElapsed < update_timer) then 
        return 
      else
        totalElapsed = totalElapsed - floor(totalElapsed)
        
        t:SetTexCoord(
        0.5+r2*cos(degrees+135), 0.5+r2*sin(degrees+135),
        0.5+r2*cos(degrees-135), 0.5+r2*sin(degrees-135),
        0.5+r2*cos(degrees+45), 0.5+r2*sin(degrees+45),
        0.5+r2*cos(degrees-45), 0.5+r2*sin(degrees-45)
        )
        
        degrees = degrees+1
        
        if degrees > 360 then
          degrees = 0
        end

      end
    end
    
    f:SetScript("OnUpdate", OnUpdateFunc)
    
  end
  
  function a:showhidestuff()
  
  local move_y
  
    if map_style == 1 then
      move_y = 30
    else
      lmove_y = 10
    end
    
    MiniMapWorldMapButton:Hide()
    
    MiniMapTrackingBackground:Hide()
    MiniMapTrackingButtonBorder:Hide()
    MiniMapTrackingButton:SetHighlightTexture("")
    
    MiniMapTracking:SetWidth(20)
    MiniMapTracking:SetHeight(20)
    
    MiniMapTrackingButton:ClearAllPoints()
    MiniMapTrackingButton:SetFrameLevel(1)
    MiniMapTrackingButton:SetAllPoints(MiniMapTracking)
    --MiniMapTrackingButton:SetWidth(20)
    --MiniMapTrackingButton:SetHeight(20)
    
    MiniMapTracking:ClearAllPoints()
    MiniMapTracking:SetPoint("TOP",Minimap,"BOTTOM",0,-move_y)
    
    local tftb = MiniMapTrackingButton:CreateTexture(nil,"BACKGROUND")
    tftb:SetTexture("Interface\\AddOns\\rMinimap\\mask")
    tftb:SetVertexColor(0,0,0,1)
    tftb:SetPoint("TOPLEFT", MiniMapTrackingButton, "TOPLEFT", 1, -1)
    tftb:SetPoint("BOTTOMRIGHT", MiniMapTrackingButton, "BOTTOMRIGHT", -1, 1)
        
    local tft = MiniMapTrackingButton:CreateTexture(nil,"ARTWORK")
    tft:SetTexture("Interface\\AddOns\\rTextures\\gloss")
    tft:SetPoint("TOPLEFT", MiniMapTrackingButton, "TOPLEFT", -0, 0)
    tft:SetPoint("BOTTOMRIGHT", MiniMapTrackingButton, "BOTTOMRIGHT", 0, -0)
    
    MiniMapTrackingIcon:ClearAllPoints()
    MiniMapTrackingIcon:SetPoint("TOPLEFT", MiniMapTrackingButton, "TOPLEFT", 1, -1)
    MiniMapTrackingIcon:SetPoint("BOTTOMRIGHT", MiniMapTrackingButton, "BOTTOMRIGHT", -1, 1)
    MiniMapTrackingIcon.SetPoint = dummy
    MiniMapTrackingIcon:SetTexCoord(0.07,0.93,0.07,0.93)
    
    MinimapZoomOut:Hide()
    MinimapZoomIn:Hide()

    MiniMapMailBorder:Hide()
    MiniMapMailFrame:SetWidth(20)
    MiniMapMailFrame:SetHeight(20)
    
    local mft = MiniMapMailFrame:CreateTexture(nil,"ARTWORK")
    mft:SetTexture("Interface\\AddOns\\rTextures\\gloss")
    mft:SetPoint("TOPLEFT", MiniMapMailFrame, "TOPLEFT", -0, 0)
    mft:SetPoint("BOTTOMRIGHT", MiniMapMailFrame, "BOTTOMRIGHT", 0, -0)
    
    MiniMapMailIcon:ClearAllPoints()
    MiniMapMailIcon:SetPoint("TOPLEFT", MiniMapMailFrame, "TOPLEFT", 1, -1)
    MiniMapMailIcon:SetPoint("BOTTOMRIGHT", MiniMapMailFrame, "BOTTOMRIGHT", -1, 1)
    MiniMapMailIcon:SetTexCoord(0.07,0.93,0.07,0.93)
    
    MiniMapMailFrame:ClearAllPoints()
    MiniMapMailFrame:SetPoint("TOP",Minimap,"BOTTOM",50,-move_y)

    MiniMapBattlefieldFrame:ClearAllPoints()
    MiniMapBattlefieldFrame:SetPoint("TOP",Minimap,"BOTTOM",25,-move_y)
    MiniMapBattlefieldFrame:SetWidth(20)
    MiniMapBattlefieldFrame:SetHeight(20)
    
    MiniMapBattlefieldBorder:Hide()
    
    local bftb = MiniMapBattlefieldFrame:CreateTexture(nil,"BACKGROUND")
    bftb:SetTexture("Interface\\AddOns\\rMinimap\\mask")
    bftb:SetVertexColor(0,0,0,1)
    bftb:SetPoint("TOPLEFT", MiniMapBattlefieldFrame, "TOPLEFT", 1, -1)
    bftb:SetPoint("BOTTOMRIGHT", MiniMapBattlefieldFrame, "BOTTOMRIGHT", -1, 1)
    
    local bft = MiniMapBattlefieldFrame:CreateTexture(nil,"ARTWORK")
    bft:SetTexture("Interface\\AddOns\\rTextures\\gloss")
    bft:SetPoint("TOPLEFT", MiniMapBattlefieldFrame, "TOPLEFT", -0, 0)
    bft:SetPoint("BOTTOMRIGHT", MiniMapBattlefieldFrame, "BOTTOMRIGHT", 0, -0)
    
    MiniMapBattlefieldIcon:ClearAllPoints()
    MiniMapBattlefieldIcon:SetAllPoints(MiniMapBattlefieldFrame)    
    MiniMapBattlefieldIcon:SetTexCoord(0.07,0.93,0.07,0.93)

    
    MinimapToggleButton:Hide()
    MinimapZoneTextButton:Hide()
    MinimapBorderTop:Hide()
    MinimapBorder:Hide()
    MinimapNorthTag:Hide()
    
    --movie recording >_<
    --doesn't work on pc
    --MiniMapRecordingButton:Show()
    --MiniMapRecordingButton.hide = dummy
    
    -- hack for the calendartime frame
    local bu = _G["GameTimeFrame"]
    bu:SetWidth(20)
    bu:SetHeight(20)
    bu:ClearAllPoints()
    bu:SetPoint("TOP",Minimap,"BOTTOM",-25,-move_y)
    bu:SetHitRectInsets(0, 0, 0, 0)
    
    local gtftb = bu:CreateTexture(nil,"BACKGROUND")
    gtftb:SetTexture("Interface\\AddOns\\rMinimap\\mask")
    gtftb:SetVertexColor(1,1,1,1)
    gtftb:SetPoint("TOPLEFT", bu, "TOPLEFT", 1, -1)
    gtftb:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -1, 1)
    
    local gtft = bu:CreateTexture(nil,"ARTWORK")
    gtft:SetTexture("Interface\\AddOns\\rTextures\\gloss")
    gtft:SetPoint("TOPLEFT", bu, "TOPLEFT", -0, 0)
    gtft:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 0, -0)
   
    --the is no name for this texture so we need to workaround this
    nt = bu:GetNormalTexture()
    nt:SetTexCoord(0,1,0,1)
    nt:SetAllPoints(bu)
    
    pu = bu:GetPushedTexture()
    pu:SetTexCoord(0,1,0,1)
    pu:SetAllPoints(bu)
    
    bu:SetNormalTexture("Interface\\AddOns\\rTextures\\gloss")
    bu:SetPushedTexture("Interface\\AddOns\\rTextures\\gloss")
    bu:SetHighlightTexture("Interface\\AddOns\\rTextures\\hover")
    
    MiniMapMeetingStoneFrame:Hide()

  end
  
  function a:zoomscript()
    Minimap:EnableMouseWheel()
    Minimap:SetScript("OnMouseWheel", function(self, direction)
      if(direction > 0) then
        Minimap_ZoomIn()
      else
        Minimap_ZoomOut()
      end
    end)
  end