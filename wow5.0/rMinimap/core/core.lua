
  ---------------------------------------
  -- INIT
  ---------------------------------------

  --get the addon namespace
  local addon, ns = ...
  --get the config values
  local cfg = ns.cfg
  local dragFrameList = ns.dragFrameList

  ---------------------------------------
  -- HIDE STUFF
  ---------------------------------------

  --disable some stuff
  MinimapCluster:EnableMouse(false)

  -- hide border
  MinimapBorder:Hide()
  MinimapBorderTop:Hide()
  -- hide worldmap button
  MiniMapWorldMapButton:Hide()
  -- hide zoom
  MinimapZoomIn:Hide()
  MinimapZoomOut:Hide()
  -- hide voice frame
  MiniMapVoiceChatFrame:Hide()
  -- hide zone text
  MinimapZoneTextButton:Hide()
  -- hide calendar button
  --GameTimeFrame:Hide()

  --the clock button
  LoadAddOn("Blizzard_TimeManager")
  if TimeManagerClockButton then
    local region = TimeManagerClockButton:GetRegions()
    region:Hide()
    TimeManagerClockTicker:SetFont(cfg.clock.font.family, cfg.clock.font.size, cfg.clock.font.outline)
    TimeManagerClockButton:ClearAllPoints()
    TimeManagerClockButton:SetPoint(cfg.clock.pos.a1,cfg.clock.pos.af,cfg.clock.pos.a2,cfg.clock.pos.x,cfg.clock.pos.y)
  end

  ---------------------------------------
  -- SCALE / POSITION
  ---------------------------------------

  --scale minimap
  MinimapCluster:SetScale(cfg.mapcluster.scale)

  --position the minimap cluster
  local frame = CreateFrame("Frame", "rMM_MinimapClusterDragFrame", UIParent)
  frame:SetSize(MinimapCluster:GetWidth(),MinimapCluster:GetHeight())
  frame:SetPoint(cfg.mapcluster.pos.a1,cfg.mapcluster.pos.af,cfg.mapcluster.pos.a2,cfg.mapcluster.pos.x,cfg.mapcluster.pos.y)
  if cfg.mapcluster.userplaced then
    rCreateDragFrame(frame, dragFrameList, -2 , true) --frame, dragFrameList, inset, clamp
  end
  MinimapCluster:SetParent(frame)
  MinimapCluster:ClearAllPoints()
  MinimapCluster:SetPoint("TOP",0,0)

  --minimap position inside the cluster
  Minimap:ClearAllPoints()
  Minimap:SetPoint(cfg.map.pos.a1,cfg.map.pos.x,cfg.map.pos.y)

  --button positions

  ---------------------------------------
  -- TEXTURES
  ---------------------------------------

  --create rotating cogwheel texture
  local t = MinimapCluster:CreateTexture(nil,"ARTWORK",nil,-6)
  t:SetTexture("Interface\\AddOns\\rMinimap\\media\\zahnrad")
  local adjust = 1.22
  t:SetPoint("CENTER", Minimap, 0, 0)
  t:SetWidth(Minimap:GetHeight()*adjust)
  t:SetHeight(Minimap:GetHeight()*adjust)
  t:SetVertexColor(48/255,44/255,35/255,0.95)
  t:SetBlendMode("BLEND")
  --create animation (rotation)
  t.ag = t:CreateAnimationGroup()
  t.ag.a1 = t.ag:CreateAnimation("Rotation")
  t.ag.a1:SetDegrees(-360)
  t.ag.a1:SetDuration(60)
  t.ag:SetLooping("REPEAT")
  t.ag:Play()

  --minimap gloss
  local t = Minimap:CreateTexture(nil,"ARTWORK",nil,-3)
  t:SetTexture("Interface\\AddOns\\rMinimap\\media\\map_gloss")
  local adjust = 1.06
  t:SetPoint("CENTER", 0, 0)
  t:SetWidth(Minimap:GetHeight()*adjust)
  t:SetHeight(Minimap:GetHeight()*adjust)
  t:SetVertexColor(0.9,0.95,1,1)
  t:SetBlendMode("ADD")

  --minimap border texture
  local t = Minimap:CreateTexture(nil,"ARTWORK",nil,-2)
  t:SetTexture("Interface\\AddOns\\rMinimap\\media\\map_overlay")
  local adjust = 1.3
  t:SetPoint("CENTER", 0, 0)
  t:SetWidth(Minimap:GetHeight()*2*adjust)
  t:SetHeight(Minimap:GetHeight()*adjust)

  --create rotating ring texture
  --[[
  local t = Minimap:CreateTexture(nil,"ARTWORK",nil,1)
  t:SetTexture("Interface\\AddOns\\rMinimap\\media\\ring")
  local adjust = 1.10
  t:SetPoint("CENTER", 0, 0)
  t:SetWidth(Minimap:GetHeight()*adjust)
  t:SetHeight(Minimap:GetHeight()*adjust)
  t:SetVertexColor(115,96,63,0.2)
  t:SetBlendMode("BLEND")
  --create animation (rotation)
  t.ag = t:CreateAnimationGroup()
  t.ag.a1 = t.ag:CreateAnimation("Rotation")
  t.ag.a1:SetDegrees(360)
  t.ag.a1:SetDuration(60)
  t.ag:SetLooping("REPEAT")
  t.ag:Play()
  ]]--

  --minimap inner shadow
  local t = Minimap:CreateTexture(nil,"ARTWORK",nil,2)
  t:SetTexture("Interface\\AddOns\\rMinimap\\media\\map_innershadow")
  local adjust = 1.06
  t:SetPoint("CENTER", 0, 0)
  t:SetWidth(Minimap:GetHeight()*adjust)
  t:SetHeight(Minimap:GetHeight()*adjust)
  t:SetVertexColor(0,0,0,1)

  ---------------------------------------
  -- BUTTONS
  ---------------------------------------

  --TRACKING ICON
  MiniMapTracking:SetSize(cfg.tracking.size,cfg.tracking.size)
  MiniMapTracking:ClearAllPoints()
  MiniMapTracking:SetPoint(cfg.tracking.pos.a1,cfg.tracking.pos.af,cfg.tracking.pos.a2,cfg.tracking.pos.x,cfg.tracking.pos.y)
  --minimap tracking button
  MiniMapTrackingButton:SetHighlightTexture(nil)
  MiniMapTrackingButton:SetPushedTexture(nil)
  MiniMapTrackingButton:SetAllPoints(MiniMapTracking)
  --minimap tracking background
  MiniMapTrackingBackground:SetTexture(20/255,15/255,10/255,1)
  MiniMapTrackingBackground:SetAlpha(1)
  MiniMapTrackingBackground:SetAllPoints(MiniMapTracking)
  --minimap tracking border
  MiniMapTrackingButtonBorder:SetTexture("Interface\\AddOns\\rMinimap\\media\\button_overlay")
  MiniMapTrackingButtonBorder:SetPoint("TOPLEFT", MiniMapTracking, "TOPLEFT", -5, 5)
  MiniMapTrackingButtonBorder:SetPoint("BOTTOMRIGHT", MiniMapTracking, "BOTTOMRIGHT", 5, -5)
  --minimap tracking icon
  MiniMapTrackingIcon:ClearAllPoints()
  MiniMapTrackingIcon:SetPoint("TOPLEFT", MiniMapTracking, "TOPLEFT", 1, -1)
  MiniMapTrackingIcon:SetPoint("BOTTOMRIGHT", MiniMapTracking, "BOTTOMRIGHT", -1, 1)
  MiniMapTrackingIcon:SetTexCoord(0.1,0.9,0.1,0.9)
  MiniMapTrackingIcon.SetPoint = function() end
  --icon overlay
  MiniMapTrackingIconOverlay:SetTexture(nil)

  --MAIL ICON
  MiniMapMailFrame:SetSize(cfg.mail.size,cfg.mail.size)
  MiniMapMailFrame:ClearAllPoints()
  MiniMapMailFrame:SetPoint(cfg.mail.pos.a1,cfg.mail.pos.af,cfg.mail.pos.a2,cfg.mail.pos.x,cfg.mail.pos.y)
  --mail icon border
  MiniMapMailBorder:SetTexture("Interface\\AddOns\\rMinimap\\media\\button_overlay")
  --MiniMapMailBorder:SetVertexColor(1,0,1)
  MiniMapMailBorder:SetPoint("TOPLEFT", MiniMapMailFrame, "TOPLEFT", -5, 5)
  MiniMapMailBorder:SetPoint("BOTTOMRIGHT", MiniMapMailFrame, "BOTTOMRIGHT", 5, -5)
  --mail icon
  MiniMapMailIcon:ClearAllPoints()
  MiniMapMailIcon:SetPoint("TOPLEFT", MiniMapMailFrame, "TOPLEFT", 1, -1)
  MiniMapMailIcon:SetPoint("BOTTOMRIGHT", MiniMapMailFrame, "BOTTOMRIGHT", -1, 1)

  --CALENDAR ICON
  GameTimeFrame:SetSize(cfg.calendar.size,cfg.calendar.size)
  GameTimeFrame:ClearAllPoints()
  GameTimeFrame:SetPoint(cfg.calendar.pos.a1,cfg.calendar.pos.af,cfg.calendar.pos.a2,cfg.calendar.pos.x,cfg.calendar.pos.y)
  GameTimeFrame:SetHitRectInsets(0, 0, 0, 0)
  GameTimeFrame:SetNormalTexture(nil)
  GameTimeFrame:SetPushedTexture(nil)
  GameTimeFrame:SetHighlightTexture(nil)
  --background
  local GameTimeFrameBackground = GameTimeFrame:CreateTexture(nil,"BACKGROUND",nil,-6)
  GameTimeFrameBackground:SetTexture(20/255,15/255,10/255,1)
  GameTimeFrameBackground:SetAlpha(1)
  GameTimeFrameBackground:SetAllPoints(GameTimeFrame)
  --text
  local GameTimeFrameText = select(5, GameTimeFrame:GetRegions())
  GameTimeFrameText:SetFont(cfg.calendar.font.family,cfg.calendar.font.size,cfg.calendar.font.outline)
  GameTimeFrameText:SetPoint("CENTER",1,1)
  GameTimeFrameText:SetTextColor(195/255,186/255,140/255)
  --border
  local GameTimeFrameBorder = GameTimeFrame:CreateTexture(nil,"ARTWORK",nil,-6)
  GameTimeFrameBorder:SetTexture("Interface\\AddOns\\rMinimap\\media\\button_overlay")
  GameTimeFrameBorder:SetPoint("TOPLEFT", GameTimeFrame, "TOPLEFT", -5, 5)
  GameTimeFrameBorder:SetPoint("BOTTOMRIGHT", GameTimeFrame, "BOTTOMRIGHT", 5, -5)

  --QUEUE STATUS ICON (LFG)
  QueueStatusMinimapButton:SetSize(cfg.queue.size,cfg.queue.size)
  QueueStatusMinimapButton:ClearAllPoints()
  QueueStatusMinimapButton:SetPoint(cfg.queue.pos.a1,cfg.queue.pos.af,cfg.queue.pos.a2,cfg.queue.pos.x,cfg.queue.pos.y)
  --border
  QueueStatusMinimapButtonBorder:SetTexture("Interface\\AddOns\\rMinimap\\media\\button_overlay")
  QueueStatusMinimapButtonBorder:SetPoint("TOPLEFT", QueueStatusMinimapButton, "TOPLEFT", -5, 5)
  QueueStatusMinimapButtonBorder:SetPoint("BOTTOMRIGHT", QueueStatusMinimapButton, "BOTTOMRIGHT", 5, -5)


  ---------------------------------------
  -- SCRIPTS
  ---------------------------------------

  --minimap mousewheel zoom
  Minimap:EnableMouseWheel()
  Minimap:SetScript("OnMouseWheel", function(self, direction)
    if(direction > 0) then
      Minimap_ZoomIn()
    else
      Minimap_ZoomOut()
    end
  end)


  ---------------------------------------
  -- CALLS // HOOKS
  ---------------------------------------

