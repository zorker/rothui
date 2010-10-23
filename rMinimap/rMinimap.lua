
  -- // rMinimap
  -- // zork - 2010

  -----------------------------
  -- CONFIG
  -----------------------------

  -- map scale
  local mapscale = 0.82
  
  -- size of icons (tracking icon for example)
  local iconsize = 20

  --position data
  local map_positions = {
    position = {
      [1] = { frame = "Minimap",                  anchor1 = "TOPRIGHT",     anchor2 = "TOPRIGHT",   anchorframe = "UIParent",   posx = -30,   posy = -15 },
      [2] = { frame = "MiniMapTracking",          anchor1 = "CENTER",       anchor2 = "CENTER",     anchorframe = "Minimap",    posx = 68,     posy = 28 },
      [3] = { frame = "MiniMapMailFrame",         anchor1 = "CENTER",          anchor2 = "CENTER",     anchorframe = "Minimap",    posx = 75,    posy = 0 },
      [4] = { frame = "MiniMapBattlefieldFrame",  anchor1 = "CENTER",          anchor2 = "CENTER",     anchorframe = "Minimap",    posx = -75,   posy = 0 },
      [5] = { frame = "GameTimeFrame",            anchor1 = "CENTER",          anchor2 = "CENTER",     anchorframe = "Minimap",    posx = 52,    posy = 52 },
      [6] = { frame = "TimeManagerClockButton",   anchor1 = "BOTTOM",       anchor2 = "BOTTOM",     anchorframe = "Minimap",    posx = 0,    posy = 0 },
    },
  }
  
  --rotation data
  local frames_to_rotate = {
    [1] = { 
      texture = "ring", --texturename under media folder
      width = 190, 
      height = 190,
      scale = 0.82,
      anchorframe = Minimap,
      framelevel = "3", --defines the framelevel to overlay or underlay other stuff
      color_red = 0/255,
      color_green = 0/255,
      color_blue = 0/255,
      alpha = 0.4,
      duration = 60, --how long should the rotation need to finish 360°
      direction = 1, --0 = counter-clockwise, 1 = clockwise
      blendmode = "BLEND", --ADD or BLEND
      setpoint = "CENTER",
      setpointx = 0,
      setpointy = 0,
    },
    
    [2] = { 
      texture = "zahnrad", --texturename under media folder
      width = 210, 
      height = 210,
      scale = 0.82,
      anchorframe = Minimap,
      framelevel = "0",
      color_red = 48/255,
      color_green = 44/255,
      color_blue = 35/255,
      alpha = 1,
      duration = 60, --how long should the rotation need to finish 360°
      direction = 1, --0 = counter-clockwise, 1 = clockwise
      blendmode = "BLEND", --ADD or BLEND
      setpoint = "CENTER",
      setpointx = 0,
      setpointy = 0,
    },

  }

  -----------------------------
  -- FUNCTIONS
  -----------------------------

  local _G = _G
  local dummy = function() end
  
  local rotateme = function(texture,width,height,scale,anchorframe,framelevel,texr,texg,texb,alpha,duration,side,blendmode,point,pointx,pointy)

    local h = CreateFrame("Frame",nil,anchorframe)
    h:SetHeight(height)
    h:SetWidth(width)		  
    h:SetPoint(point,pointx,pointy)
    h:SetScale(scale)
    h:SetFrameLevel(framelevel)
  
    local t = h:CreateTexture()
    t:SetAllPoints(h)
    t:SetTexture("Interface\\AddOns\\rTextures\\"..texture)
    t:SetBlendMode(blendmode)
    t:SetVertexColor(texr,texg,texb,alpha)
    h.t = t
    
    local ag = h:CreateAnimationGroup()
    h.ag = ag
    
    local a1 = h.ag:CreateAnimation("Rotation")
    if side == 0 then
      a1:SetDegrees(360)
    else
      a1:SetDegrees(-360)
    end
    a1:SetDuration(duration)
    h.ag.a1 = a1
    
    h.ag:Play()
    h.ag:SetLooping("REPEAT")  

  end
  
  local positionme = function(f,a1,af,a2,px,py)
    f = _G[f]
    af = _G[af]
    f:ClearAllPoints()
    f:SetPoint(a1,af,a2,px,py)
    f.SetPoint = dummy
  end
  
  local zoomer = function()
    Minimap:EnableMouseWheel()
    Minimap:SetScript("OnMouseWheel", function(self, direction)
      if(direction > 0) then
        Minimap_ZoomIn()
      else
        Minimap_ZoomOut()
      end
    end)
  end
  
  local createMapOverlay = function()
    local t = Minimap:CreateTexture(nil,"ARTWORK")
    t:SetTexture("Interface\\AddOns\\rTextures\\d3_map2")
    local d3mapscale = 1.3
    t:SetPoint("CENTER", Minimap, "CENTER", -2*d3mapscale, -11*d3mapscale)
    t:SetWidth(Minimap:GetHeight()*2*d3mapscale)
    t:SetHeight(Minimap:GetHeight()*d3mapscale)
    
    local t2 = Minimap:CreateTexture(nil,"BORDER")
    t2:SetTexture("Interface\\AddOns\\rTextures\\orb_gloss")
    t2:SetPoint("CENTER",0,0)
    t2:SetWidth(Minimap:GetHeight()*1.06)
    t2:SetHeight(Minimap:GetHeight()*1.06)
    t2:SetAlpha(1)
  end
  
  local adjustBlizzard = function()
    
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
    tftb:SetTexture(0,0,0,1)
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
    MinimapZoneTextButton:Hide()
    MinimapBorderTop:Hide()
    MinimapBorder:Hide()
    MinimapNorthTag:Hide()

    local bu = _G["GameTimeFrame"]
    bu:SetWidth(iconsize)
    bu:SetHeight(iconsize)
    bu:SetHitRectInsets(0, 0, 0, 0)
    
    select(5, GameTimeFrame:GetRegions()):SetTextColor(1, 1, 1)
    select(5, GameTimeFrame:GetRegions()):SetFont(NAMEPLATE_FONT,14,"THINOUTLINE")
    select(5, GameTimeFrame:GetRegions()):ClearAllPoints()
    select(5, GameTimeFrame:GetRegions()):SetPoint("CENTER",bu,"CENTER",0,1)
    
    local gtftb = bu:CreateTexture(nil,"BACKGROUND")
    gtftb:SetTexture(0,0,0,1)
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

  end
  
  
  local init = function()    
    LoadAddOn("Blizzard_TimeManager")
    adjustBlizzard()
    createMapOverlay()
    zoomer() --zoomer taken from pminimap by p3lim      
    for index,value in ipairs(map_positions.position) do 
      local var = map_positions.position[index]
      positionme(var.frame,var.anchor1,var.anchorframe,var.anchor2,var.posx,var.posy)
    end
    for index,value in ipairs(frames_to_rotate) do 
      local ftr = frames_to_rotate[index]
      rotateme(ftr.texture, ftr.width, ftr.height, ftr.scale, ftr.anchorframe, ftr.framelevel, ftr.color_red, ftr.color_green, ftr.color_blue, ftr.alpha, ftr.duration, ftr.direction, ftr.blendmode, ftr.setpoint, ftr.setpointx, ftr.setpointy)
    end    
    Minimap:SetScale(mapscale)  
  end
  
  local a = CreateFrame("Frame")
  a:SetScript("OnEvent", function(self, event)
    if(event=="PLAYER_LOGIN") then
      init()
    end
  end)
  
  a:RegisterEvent("PLAYER_LOGIN")