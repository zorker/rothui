
-- rNamePlate: core
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
  scale = 0.75
}

-----------------------------
-- Init
-----------------------------

MinimapCluster:SetScale(cfg.scale)

local mediapath = "interface\\addons\\"..A.."\\media\\"
Minimap:SetMaskTexture(mediapath.."mask")
Minimap:ClearAllPoints()
Minimap:SetPoint("CENTER")
Minimap:SetScale(1.35)

MinimapBackdrop:Hide()
MinimapBorder:Hide()
MinimapZoomIn:Hide()
MinimapZoomOut:Hide()
MinimapBorderTop:Hide()
MiniMapWorldMapButton:Hide()
MinimapZoneText:Hide()

--MiniMapTracking
MiniMapTracking:SetParent(Minimap)
MiniMapTracking:SetScale(0.9)
MiniMapTracking:ClearAllPoints()
MiniMapTracking:SetPoint("TOPLEFT",Minimap,3,-3)
MiniMapTrackingButton:SetHighlightTexture (nil)
MiniMapTrackingButton:SetPushedTexture(nil)
MiniMapTrackingButtonBorder:Hide()
--MiniMapNorthTag
MinimapNorthTag:ClearAllPoints()
MinimapNorthTag:SetPoint("TOP",Minimap,0,-3)
MinimapNorthTag:SetAlpha(0)

--Blizzard_TimeManager
LoadAddOn("Blizzard_TimeManager")
if TimeManagerClockButton then
  local region = TimeManagerClockButton:GetRegions()
  region:Hide()
  TimeManagerClockTicker:SetFont(STANDARD_TEXT_FONT,10)
  TimeManagerClockTicker:SetShadowColor(0,0,0,0.9)
  TimeManagerClockTicker:SetShadowOffset(2,-1)
  TimeManagerClockButton:ClearAllPoints()
  TimeManagerClockButton:SetPoint("BOTTOMRIGHT",Minimap,3,-1)
  TimeManagerClockButton:SetAlpha(0.95)
end

--GameTimeFrame
GameTimeFrame:SetParent(Minimap)
GameTimeFrame:SetScale(0.5)
GameTimeFrame:ClearAllPoints()
GameTimeFrame:SetPoint("TOPRIGHT",Minimap,-15,-12)
GameTimeFrame:SetHitRectInsets(0, 0, 0, 0)
GameTimeFrame:GetNormalTexture():SetTexCoord(0,1,0,1)
GameTimeFrame:SetNormalTexture(mediapath.."calendar")
GameTimeFrame:SetPushedTexture(nil)
GameTimeFrame:SetHighlightTexture (nil)
local fs = GameTimeFrame:GetFontString()
fs:ClearAllPoints()
fs:SetPoint("BOTTOM",0,4)
fs:SetFont(STANDARD_TEXT_FONT,18)
fs:SetShadowColor(0,0,0,0.4)
fs:SetShadowOffset(2,2)

--drag frame
rLib:CreateDragFrame(MinimapCluster, L.dragFrames, -2, true)

--create slash commands
rLib:CreateSlashCmd(L.addonName, L.addonShortcut, L.dragFrames, L.addonColor)