
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
  scale = 0.8,
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
Minimap:SetMaskTexture(mediapath.."mask")
Minimap:ClearAllPoints()
Minimap:SetPoint("CENTER")
Minimap:SetScale(1.35) --correct the cluster offset

--hide regions
MinimapBackdrop:Hide()
MinimapBorder:Hide()
MinimapZoomIn:Hide()
MinimapZoomOut:Hide()
MiniMapRecordingButton:Hide()
MinimapBorderTop:Hide()
MiniMapWorldMapButton:Hide()
MinimapZoneText:Hide()

--dungeon info
MiniMapChallengeMode:ClearAllPoints()
MiniMapChallengeMode:SetPoint("TOP",Minimap,"BOTTOM",0,11)
MiniMapInstanceDifficulty:ClearAllPoints()
MiniMapInstanceDifficulty:SetPoint("TOP",Minimap,"BOTTOM",0,16)
GuildInstanceDifficulty:ClearAllPoints()
GuildInstanceDifficulty:SetPoint("TOP",Minimap,"BOTTOM",0,16)

--QueueStatusMinimapButton (lfi)
QueueStatusMinimapButton:SetParent(Minimap)
QueueStatusMinimapButton:SetScale(0.8)
QueueStatusMinimapButton:ClearAllPoints()
QueueStatusMinimapButton:SetPoint("BOTTOMLEFT",Minimap,-1,-1)
QueueStatusMinimapButtonBorder:Hide()
QueueStatusMinimapButton:SetHighlightTexture (nil)
QueueStatusMinimapButton:SetPushedTexture(nil)

--garrison+queue
--GarrisonLandingPageMinimapButton (DIEEEEEE!!!)

--mail
MiniMapMailFrame:ClearAllPoints()
MiniMapMailFrame:SetPoint("BOTTOMRIGHT",Minimap,3,-3)
MiniMapMailIcon:SetTexture(mediapath.."mail")
MiniMapMailBorder:SetTexture("Interface\\Calendar\\EventNotificationGlow")
MiniMapMailBorder:SetBlendMode("ADD")
MiniMapMailBorder:ClearAllPoints()
MiniMapMailBorder:SetPoint("CENTER",MiniMapMailFrame,0.5,1.5)
MiniMapMailBorder:SetSize(27,27)
MiniMapMailBorder:SetAlpha(0.5)

--MiniMapTracking
MiniMapTracking:SetParent(Minimap)
MiniMapTracking:SetScale(0.9)
MiniMapTracking:ClearAllPoints()
MiniMapTracking:SetPoint("TOPLEFT",Minimap,1,-1)
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
TimeManagerClockButton:SetPoint("BOTTOM",-2,0)
TimeManagerClockTicker:SetFont(STANDARD_TEXT_FONT,9,"OUTLINE")
TimeManagerClockTicker:SetTextColor(0.8,0.8,0.6,1)

--GameTimeFrame
local gtfscale = 0.4
GameTimeFrame:SetParent(Minimap)
GameTimeFrame:SetScale(gtfscale)
GameTimeFrame:ClearAllPoints()
GameTimeFrame:SetPoint("TOPRIGHT",Minimap,-7/gtfscale,-6/gtfscale)
GameTimeFrame:SetHitRectInsets(0, 0, 0, 0)
GameTimeFrame:GetNormalTexture():SetTexCoord(0,1,0,1)
GameTimeFrame:SetNormalTexture(mediapath.."calendar")
GameTimeFrame:SetPushedTexture(nil)
GameTimeFrame:SetHighlightTexture (nil)
local fs = GameTimeFrame:GetFontString()
fs:ClearAllPoints()
fs:SetPoint("BOTTOM",0,2.2/gtfscale)
fs:SetFont(STANDARD_TEXT_FONT,7/gtfscale)
fs:SetTextColor(0.2,0.2,0.1,0.9)

--zoom
Minimap:EnableMouseWheel()
local function Zoom(self, direction)
  if(direction > 0) then Minimap_ZoomIn()
  else Minimap_ZoomOut() end
end
Minimap:SetScript("OnMouseWheel", Zoom)

--onenter
local function Show(self)
  GameTimeFrame:SetAlpha(1)
  TimeManagerClockButton:SetAlpha(1)
  MiniMapTracking:SetAlpha(1)
end
Minimap:SetScript("OnEnter", Show)

--onleave
local function Hide(self)
  if self:IsMouseOver() then return end
  GameTimeFrame:SetAlpha(0)
  TimeManagerClockButton:SetAlpha(0)
  MiniMapTracking:SetAlpha(0)
end
Minimap:SetScript("OnLeave", Hide)
Hide(Minimap)


--drag frame
rLib:CreateDragFrame(MinimapCluster, L.dragFrames, -2, true)

--create slash commands
rLib:CreateSlashCmd(L.addonName, L.addonShortcut, L.dragFrames, L.addonColor)