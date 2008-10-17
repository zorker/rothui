  
  local a = CreateFrame("Frame", nil, UIParent)
  local _G = getfenv(0)
  local dummy = function() end    
  
  a:RegisterEvent("PLAYER_LOGIN")
  
  a:SetScript("OnEvent", function (self,event,arg1)
    if(event=="PLAYER_LOGIN") then
      a:dostuff()
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
  
    Minimap:SetMaskTexture("Interface\\AddOns\\rMinimap\\mask")
	
    local t = Minimap:CreateTexture(nil,"Overlay")
    t:SetTexture("Interface\\AddOns\\rTextures\\minigloss")
    t:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -1, 1)
    t:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 1, -1)
  
  end