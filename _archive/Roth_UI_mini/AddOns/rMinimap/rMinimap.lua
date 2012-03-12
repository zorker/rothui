  
  local rm_player_name, _ = UnitName("player")
  local _, rm_player_class = UnitClass("player")
   
  -----------------------------
  -- configure map style here --
  -----------------------------

  -- map_style
  -- 0 = diablo3
  -- 1 = futuristic orb rotating
  -- 2 = square runits style
  local map_style = 2

  -- map scale
  local mapscale = 0.82
  
  -- size of icons (tracking icon for example)
  local iconsize = 20

  -- position map and symbols here
  local map_positions = {
      position = {
        [1] = { frame = "Minimap",                  anchor1 = "TOPRIGHT",     anchor2 = "TOPRIGHT",     anchorframe = "UIParent",   posx = -30,   posy = -20 },
        [2] = { frame = "MiniMapTracking",          anchor1 = "TOPLEFT",      anchor2 = "TOPLEFT",      anchorframe = "Minimap",    posx = -0,     posy = 0 },
        [3] = { frame = "MiniMapMailFrame",         anchor1 = "BOTTOMRIGHT",  anchor2 = "BOTTOMRIGHT",  anchorframe = "Minimap",    posx = 0,    posy = -0 },
        [4] = { frame = "MiniMapBattlefieldFrame",  anchor1 = "BOTTOMLEFT",   anchor2 = "BOTTOMLEFT",   anchorframe = "Minimap",    posx = -0,     posy = 0 },
        [5] = { frame = "GameTimeFrame",            anchor1 = "TOPRIGHT",     anchor2 = "TOPRIGHT",     anchorframe = "Minimap",    posx = 0,    posy = 0 },
        [6] = { frame = "TimeManagerClockButton",   anchor1 = "BOTTOM",       anchor2 = "BOTTOM",       anchorframe = "Minimap",    posx = 0,    posy = -2 },
      },
    }

  ----------------
  -- end config --
  ----------------
  
  local a = CreateFrame("Frame", nil, UIParent)
  local _G = getfenv(0)
  local dummy = function() end    
  
  a:RegisterEvent("PLAYER_LOGIN")
  
  a:SetScript("OnEvent", function (self,event,arg1)
    if(event=="PLAYER_LOGIN") then
      LoadAddOn("Blizzard_TimeManager")
      a:showhidestuff()
      a:dostuff2()
      --zoomscript taken from pminimap by p3lim
      --http://www.wowinterface.com/downloads/info8389-pMinimap.html
      a:zoomscript()
      for index,value in ipairs(map_positions.position) do 
        local var = map_positions.position[index]
        a:positionme(var.frame,var.anchor1,var.anchorframe,var.anchor2,var.posx,var.posy)
      end
      Minimap:SetScale(mapscale)
    end
  end)  

  local function kiss_set_me_a_backdrop(f)
    local castcol = { r = 0.9, g = 0.6, b = 0.4, }
    local bdc = { r = castcol.r*0.2, g = castcol.g*0.2, b = castcol.b*0.2, a = 0.93, }
    f:SetBackdrop( { 
      bgFile = "Interface\\AddOns\\oUF_Simple\\flat", 
      edgeFile = "", tile = false, tileSize = 0, edgeSize = 32, 
      insets = { left = -2, right = -2, top = -2, bottom = -2 }
    })
    f:SetBackdropColor(bdc.r,bdc.g,bdc.b,bdc.a)
  end
  
  function a:dostuff2()
    Minimap:SetMaskTexture("Interface\\AddOns\\rMinimap\\mask")
    kiss_set_me_a_backdrop(Minimap)
  end
  
  function a:showhidestuff()    
    if TimeManagerClockButton then
      local timerframe = _G["TimeManagerClockButton"]
      local region1 = timerframe:GetRegions()
      region1:Hide()
      TimeManagerClockTicker:SetFont(NAMEPLATE_FONT, 14, "THINOUTLINE")
    end
  
    MiniMapWorldMapButton:Hide()    
    MiniMapTrackingBackground:Hide()
    MiniMapTrackingButtonBorder:Hide()
    MiniMapTrackingButton:SetHighlightTexture("")    
    MiniMapTracking:SetWidth(iconsize)
    MiniMapTracking:SetHeight(iconsize)    
    MiniMapTrackingButton:SetAllPoints(MiniMapTracking)
    MiniMapTrackingButton:SetHighlightTexture("")
    MiniMapTrackingButton:SetPushedTexture("")
    local tftb = MiniMapTracking:CreateTexture(nil,"BACKGROUND")
    tftb:SetTexture("Interface\\AddOns\\rMinimap\\mask")
    tftb:SetVertexColor(0,0,0,1)
    tftb:SetPoint("TOPLEFT", MiniMapTracking, "TOPLEFT", 2, -2)
    tftb:SetPoint("BOTTOMRIGHT", MiniMapTracking, "BOTTOMRIGHT", -2, 2)
    MiniMapTrackingIcon:ClearAllPoints()
    MiniMapTrackingIcon:SetPoint("TOPLEFT", MiniMapTracking, "TOPLEFT", 2, -2)
    MiniMapTrackingIcon:SetPoint("BOTTOMRIGHT", MiniMapTracking, "BOTTOMRIGHT", -2, 2)
    MiniMapTrackingIcon.SetPoint = dummy
    MiniMapTrackingIcon:SetTexCoord(0.1,0.9,0.1,0.9)
    local tft = MiniMapTracking:CreateTexture(nil,"OVERLAY")
    tft:SetTexture("Interface\\AddOns\\rTextures\\minimap_button2")
    tft:SetPoint("TOPLEFT", MiniMapTracking, "TOPLEFT", -2, 2)
    tft:SetPoint("BOTTOMRIGHT", MiniMapTracking, "BOTTOMRIGHT", 2, -2)
    MinimapZoomOut:Hide()
    MinimapZoomIn:Hide()
    MiniMapMailBorder:Hide()
    MiniMapMailFrame:SetWidth(iconsize)
    MiniMapMailFrame:SetHeight(iconsize)    
    MiniMapMailIcon:ClearAllPoints()
    MiniMapMailIcon:SetPoint("TOPLEFT", MiniMapMailFrame, "TOPLEFT", 1, -1)
    MiniMapMailIcon:SetPoint("BOTTOMRIGHT", MiniMapMailFrame, "BOTTOMRIGHT", -1, 1)
    MiniMapMailIcon:SetTexCoord(0.07,0.93,0.07,0.93)    
    local mft = MiniMapMailFrame:CreateTexture(nil,"OVERLAY")
    mft:SetTexture("Interface\\AddOns\\rTextures\\minimap_button2")
    mft:SetPoint("TOPLEFT", MiniMapMailFrame, "TOPLEFT", -2, 2)
    mft:SetPoint("BOTTOMRIGHT", MiniMapMailFrame, "BOTTOMRIGHT", 2, -2)
    MiniMapBattlefieldFrame:SetWidth(iconsize)
    MiniMapBattlefieldFrame:SetHeight(iconsize)    
    MiniMapBattlefieldBorder:Hide()    
    local bft = MiniMapBattlefieldFrame:CreateTexture(nil,"ARTWORK")
    bft:SetTexture("Interface\\AddOns\\rTextures\\minimap_button2")
    bft:SetPoint("TOPLEFT", MiniMapBattlefieldFrame, "TOPLEFT", -2, 2)
    bft:SetPoint("BOTTOMRIGHT", MiniMapBattlefieldFrame, "BOTTOMRIGHT", 2, -2)
    MinimapToggleButton:Hide()
    MinimapZoneTextButton:Hide()
    MinimapBorderTop:Hide()
    MinimapBorder:Hide()
    MinimapNorthTag:Hide()

    -- hack for the calendartime frame
    local bu = _G["GameTimeFrame"]
    bu:SetWidth(iconsize)
    bu:SetHeight(iconsize)
    bu:SetHitRectInsets(0, 0, 0, 0)
    
    select(5, GameTimeFrame:GetRegions()):SetTextColor(1, 1, 1)
    select(5, GameTimeFrame:GetRegions()):SetFont(NAMEPLATE_FONT,14,"THINOUTLINE")
    select(5, GameTimeFrame:GetRegions()):ClearAllPoints()
    select(5, GameTimeFrame:GetRegions()):SetPoint("CENTER",bu,"CENTER",0,1)
    
    local gtftb = bu:CreateTexture(nil,"BACKGROUND")
    gtftb:SetTexture("Interface\\AddOns\\rMinimap\\mask")
    gtftb:SetVertexColor(0,0,0,1)
    gtftb:SetPoint("TOPLEFT", bu, "TOPLEFT", 2, -2)
    gtftb:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -2, 2)
    
    local gtft = bu:CreateTexture(nil,"ARTWORK")
    gtft:SetTexture("Interface\\AddOns\\rTextures\\minimap_button2")
    gtft:SetPoint("TOPLEFT", bu, "TOPLEFT", -2, 2)
    gtft:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 2, -2)
   
    nt = bu:GetNormalTexture()
    nt:SetTexCoord(0,1,0,1)
    nt:SetAllPoints(bu)
    
    pu = bu:GetPushedTexture()
    pu:SetTexCoord(0,1,0,1)
    pu:SetAllPoints(bu)
    
    bu:SetNormalTexture("")
    bu:SetPushedTexture("")
    bu:SetHighlightTexture("")
    
    MiniMapMeetingStoneFrame:Hide()

  end
  
  function a:positionme(f,a1,af,a2,px,py)
    f = _G[f]
    af = _G[af]
    f:ClearAllPoints()
    f:SetPoint(a1,af,a2,px,py)
    f.SetPoint = dummy
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