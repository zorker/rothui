  
  local a = CreateFrame("Frame", nil, UIParent)
  local _G = getfenv(0)
  local dummy = function() end    
  
  a:RegisterEvent("PLAYER_LOGIN")
  
  a:SetScript("OnEvent", function (self,event,arg1)
    if(event=="PLAYER_LOGIN") then
      a:dostuff()
      a:rotateme()
    end
  end)
  
  function a:dostuff()
  
    Minimap:SetScale(1)
    Minimap:ClearAllPoints()
    Minimap:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -20, -20)
  
    MinimapBorder:SetTexture()
    MinimapBorderTop:Hide()
    MinimapToggleButton:Hide()
  
    MinimapZoomIn:Hide()
    MinimapZoomOut:Hide()
    Minimap:EnableMouseWheel()
    Minimap:SetScript('OnMouseWheel', function(self, dir)
      if(dir > 0) then
        Minimap_ZoomIn()
      else
        Minimap_ZoomOut()
      end
    end)
  
    MinimapZoneText:Hide()
    MinimapZoneTextButton:Hide()
  
    MiniMapTrackingButtonBorder:SetTexture()
    MiniMapTrackingBackground:Hide()
    MiniMapTrackingIconOverlay:SetAlpha(0)
    MiniMapTrackingIcon:SetTexCoord(0.065, 0.935, 0.065, 0.935)
    MiniMapTracking:SetParent(Minimap)
    MiniMapTracking:ClearAllPoints()
    MiniMapTracking:SetPoint('TOPLEFT', -2, 2)
  
    BattlegroundShine:Hide()
    MiniMapBattlefieldBorder:SetTexture()
    MiniMapBattlefieldFrame:SetParent(Minimap)
    MiniMapBattlefieldFrame:ClearAllPoints()
    MiniMapBattlefieldFrame:SetPoint('TOPRIGHT', -2, -2)
  
    MiniMapMailBorder:SetTexture()
    MiniMapMailIcon:Hide()
    MiniMapMailFrame:SetParent(Minimap)
    MiniMapMailFrame:ClearAllPoints()
    MiniMapMailFrame:SetPoint('TOP')
    MiniMapMailFrame:SetHeight(8)
  
    MiniMapMailText = MiniMapMailFrame:CreateFontString(nil, 'OVERLAY')
    MiniMapMailText:SetFont("FONTS\\ARIALN.TTF", 13, 'OUTLINE')
    MiniMapMailText:SetPoint('BOTTOM', 0, 2)
    MiniMapMailText:SetText('New Mail!')
    MiniMapMailText:SetTextColor(1, 1, 1)
  
    GameTimeFrame:Hide()
    MiniMapWorldMapButton:Hide()
    MiniMapVoiceChatFrame:Hide()
    MiniMapMeetingStoneFrame:Hide()
    MiniMapMeetingStoneFrame:SetAlpha(0)
    MinimapNorthTag:SetAlpha(0)
  
    --Minimap:SetMaskTexture("Interface\\AddOns\\rMinimap\\mask")
    --[[
    local t = Minimap:CreateTexture(nil,"Overlay")
    t:SetTexture("Interface\\AddOns\\rTextures\\minigloss")
    t:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -1, 1)
    t:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 1, -1)
    ]]--
  
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
    --t:SetTexCoord(0.1,0.9,0.1,0.9)
    t:SetAllPoints(f)
    t:SetVertexColor(0.8,0.8,0.8,1)
    
    local f2 = CreateFrame("Frame",nil,f)
    f2:SetPoint("TOPLEFT",f,"TOPLEFT",20,-20)
    f2:SetPoint("BOTTOMRIGHT",f,"BOTTOMRIGHT",-20,20)
    --f2:SetFrameStrata("DIALOG")
    f2:Show()
    
  	t2 = f2:CreateTexture(nil, "OVERLAY")
    --t2:SetTexture("Interface\\AddOns\\oUF_Orbs\\textures\\orb_gloss.tga")
    t2:SetAllPoints(f2)  
    t2:SetAlpha(0.5)
    
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