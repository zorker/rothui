
-- rMinimap: core
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

L.addonName       = A
L.dragFrames      = {}
L.addonColor      = "00FFAA00"
L.addonShortcut   = "rmm"

-----------------------------
-- Config
-----------------------------

local cfg = {
  scale = 1,
  point = { "TOPRIGHT", 0, 0},
}

-----------------------------
-- Init
-----------------------------

--MinimapCluster
MinimapCluster:SetScale(cfg.scale)
MinimapCluster:ClearAllPoints()
MinimapCluster:SetPoint(unpack(cfg.point))

--Minimap
local mediapath = "interface\\addons\\"..A.."\\media\\"
Minimap:SetMaskTexture(mediapath.."mask2")
Minimap:ClearAllPoints()
Minimap:SetPoint("CENTER")
Minimap:SetSize(190,190) --correct the cluster offset

--hide regions
MinimapBackdrop:Hide()
MinimapBorder:Hide()
MinimapZoomIn:Hide()
MinimapZoomOut:Hide()
MinimapBorderTop:Hide()
MiniMapWorldMapButton:Hide()
MinimapZoneText:Hide()

--dungeon info
MiniMapInstanceDifficulty:ClearAllPoints()
MiniMapInstanceDifficulty:SetPoint("TOP",Minimap,"TOP",0,-5)
MiniMapInstanceDifficulty:SetScale(0.8)
GuildInstanceDifficulty:ClearAllPoints()
GuildInstanceDifficulty:SetPoint("TOP",Minimap,"TOP",0,-5)
GuildInstanceDifficulty:SetScale(0.7)
MiniMapChallengeMode:ClearAllPoints()
MiniMapChallengeMode:SetPoint("TOP",Minimap,"TOP",0,-10)
MiniMapChallengeMode:SetScale(0.6)

--QueueStatusMinimapButton (lfi)
QueueStatusMinimapButton:SetParent(Minimap)
QueueStatusMinimapButton:SetScale(1)
QueueStatusMinimapButton:ClearAllPoints()
QueueStatusMinimapButton:SetPoint("BOTTOMLEFT",Minimap,0,0)
QueueStatusMinimapButtonBorder:Hide()
QueueStatusMinimapButton:SetHighlightTexture (nil)
QueueStatusMinimapButton:SetPushedTexture(nil)

--garrison (DIEEEEEE!!!)
--GarrisonLandingPageMinimapButton

--mail
MiniMapMailFrame:ClearAllPoints()
MiniMapMailFrame:SetPoint("BOTTOMRIGHT",Minimap,-0,0)
MiniMapMailIcon:SetTexture(mediapath.."mail")
MiniMapMailBorder:SetTexture("Interface\\Calendar\\EventNotificationGlow")
MiniMapMailBorder:SetBlendMode("ADD")
MiniMapMailBorder:ClearAllPoints()
MiniMapMailBorder:SetPoint("CENTER",MiniMapMailFrame,0.5,1.5)
MiniMapMailBorder:SetSize(27,27)
MiniMapMailBorder:SetAlpha(0.5)

--MiniMapTracking
MiniMapTracking:SetParent(Minimap)
MiniMapTracking:SetScale(1)
MiniMapTracking:ClearAllPoints()
MiniMapTracking:SetPoint("TOPLEFT",Minimap,5,-5)
MiniMapTrackingButton:SetHighlightTexture (nil)
MiniMapTrackingButton:SetPushedTexture(nil)
MiniMapTrackingBackground:Hide()
MiniMapTrackingButtonBorder:Hide()

--MiniMapNorthTag
MinimapNorthTag:ClearAllPoints()
MinimapNorthTag:SetPoint("TOP",Minimap,0,-3)
MinimapNorthTag:SetAlpha(0)

--Blizzard_TimeManager
LoadAddOn("Blizzard_TimeManager")
TimeManagerClockButton:GetRegions():Hide()
TimeManagerClockButton:ClearAllPoints()
TimeManagerClockButton:SetPoint("BOTTOM",0,5)
TimeManagerClockTicker:SetFont(STANDARD_TEXT_FONT,12,"OUTLINE")
TimeManagerClockTicker:SetTextColor(0.8,0.8,0.6,1)

--GameTimeFrame
GameTimeFrame:SetParent(Minimap)
GameTimeFrame:SetScale(0.6)
GameTimeFrame:ClearAllPoints()
GameTimeFrame:SetPoint("TOPRIGHT",Minimap,-18,-18)
GameTimeFrame:SetHitRectInsets(0, 0, 0, 0)
GameTimeFrame:GetNormalTexture():SetTexCoord(0,1,0,1)
GameTimeFrame:SetNormalTexture(mediapath.."calendar")
GameTimeFrame:SetPushedTexture(nil)
GameTimeFrame:SetHighlightTexture (nil)
local fs = GameTimeFrame:GetFontString()
fs:ClearAllPoints()
fs:SetPoint("CENTER",0,-5)
fs:SetFont(STANDARD_TEXT_FONT,20)
fs:SetTextColor(0.2,0.2,0.1,0.9)

--zoom
Minimap:EnableMouseWheel()
local function Zoom(self, direction)
  if(direction > 0) then Minimap_ZoomIn()
  else Minimap_ZoomOut() end
end
Minimap:SetScript("OnMouseWheel", Zoom)

--onenter/show
local function Show()
  GameTimeFrame:SetAlpha(0.9)
  TimeManagerClockButton:SetAlpha(0.9)
  MiniMapTracking:SetAlpha(0.9)
  MiniMapChallengeMode:SetAlpha(0.9)
  MiniMapInstanceDifficulty:SetAlpha(0.9)
  GuildInstanceDifficulty:SetAlpha(0.9)
end
Minimap:SetScript("OnEnter", Show)

--onleave/hide
local lasttime = 0
local function Hide()
  if Minimap:IsMouseOver() then return end
  if time() == lasttime then return end
  GameTimeFrame:SetAlpha(0)
  TimeManagerClockButton:SetAlpha(0)
  MiniMapTracking:SetAlpha(0)
  MiniMapChallengeMode:SetAlpha(0)
  MiniMapInstanceDifficulty:SetAlpha(0)
  GuildInstanceDifficulty:SetAlpha(0)
end
local function SetTimer()
  lasttime = time()
  C_Timer.After(1.5, Hide)
end
Minimap:SetScript("OnLeave", SetTimer)
rLib:RegisterCallback("PLAYER_ENTERING_WORLD", Hide)
Hide(Minimap)


--drag frame
rLib:CreateDragFrame(MinimapCluster, L.dragFrames, -2, true)

--create slash commands
rLib:CreateSlashCmd(L.addonName, L.addonShortcut, L.dragFrames, L.addonColor)