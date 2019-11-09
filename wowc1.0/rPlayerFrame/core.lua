
-- rPlayerFrame: core
-- zork, 2019

-----------------------------
-- Variables
-----------------------------

local A, L = ...

local RAID_CLASS_COLORS,FACTION_BAR_COLORS = RAID_CLASS_COLORS,FACTION_BAR_COLORS

-----------------------------
-- Init
-----------------------------

--using code from Semlar (https://www.wowinterface.com/forums/showthread.php?t=48971)
local frame = CreateFrame("Frame", nil, nil, "SecureHandlerStateTemplate")
frame:SetFrameRef("PlayerFrame", PlayerFrame)
frame:SetAttribute("_onstate-display", [[
  if newstate == "show" then
    self:GetFrameRef("PlayerFrame"):Show()
  else
    self:GetFrameRef("PlayerFrame"):Hide()
  end
]])
RegisterStateDriver(frame, "display", L.C.frameVisibility)

--player, target, tot texture color
PlayerFrameTexture:SetVertexColor(unpack(L.C.textureColor))
TargetFrameTextureFrameTexture:SetVertexColor(unpack(L.C.textureColor))
TargetFrameToTTextureFrameTexture:SetVertexColor(unpack(L.C.textureColor))
PlayerFrameGroupIndicator:SetAlpha(0)
PlayerPVPIcon:SetAlpha(0)
TargetFrameTextureFramePVPIcon:SetAlpha(0)

--add a bar texture to the player frame
local playerColor = RAID_CLASS_COLORS[select(2, UnitClass("player"))]
local playerFrameNameBackground = PlayerFrame:CreateTexture()
playerFrameNameBackground:SetPoint("TOPLEFT",PlayerFrameBackground)
playerFrameNameBackground:SetPoint("BOTTOMRIGHT",PlayerFrameBackground,0,22)
playerFrameNameBackground:SetTexture(TargetFrameNameBackground:GetTexture())
playerFrameNameBackground:SetVertexColor(playerColor.r,playerColor.g,playerColor.b,1)
local function UpdateStatus()
  if PlayerFrame.inCombat then
    playerFrameNameBackground:SetVertexColor(1,0,0,1)
  else
    playerFrameNameBackground:SetVertexColor(playerColor.r,playerColor.g,playerColor.b,1)
  end
end
hooksecurefunc("PlayerFrame_UpdateStatus",UpdateStatus)

PlayerName:SetTextColor(1,1,1)

--check for target events to listen for
local function CanEventPass(event,unit)
  if event == "PLAYER_TARGET_CHANGED" then
    return true
  --elseif event == "UNIT_HEALTH_FREQUENT" and unit == "target" then
    --return true
  elseif event == "UNIT_HEALTH" and unit == "target" then
    return true
  end
  return false
end

--change the bar texture of target frame
local function OnEvent(self,event,unit)
  if not CanEventPass(event,unit) then return end
  if not UnitExists("target") then return end
  if not unit then unit = "target" end
  local r,g,b
  if UnitIsDeadOrGhost(unit) then
    r,g,b = 0.4,0.4,0.4
  elseif UnitIsUnit(unit.."target", "player") then
    r,g,b = 1,0,0 --reverse threat color, red if I am the target
  elseif UnitIsPlayer(unit) then
    local _, class = UnitClass(unit)
    local color = RAID_CLASS_COLORS[class]
    r,g,b = color.r,color.g,color.b
  elseif UnitIsTapDenied(unit) then
    r,g,b = 0.9,0.9,0.9
  else
    local color = FACTION_BAR_COLORS[UnitReaction(unit, "player")]
    r,g,b = color.r,color.g,color.b
  end
  TargetFrameNameBackground:SetVertexColor(r,g,b,1)
end
TargetFrame:HookScript("OnEvent", OnEvent)
TargetFrameTextureFrameName:SetTextColor(1,1,1)
TargetFrameTextureFrameDeadText:SetTextColor(0.4,0.4,0.4)

local function HideTexture(self)
  self:Hide()
end
hooksecurefunc(PlayerStatusTexture, "Show", HideTexture)
hooksecurefunc(PlayerStatusGlow, "Show", HideTexture)

--make the compact raidframe manager border more appealing
CompactRaidFrameManagerBorderTopRight:SetVertexColor(unpack(L.C.textureColor))
CompactRaidFrameManagerBorderBottomRight:SetVertexColor(unpack(L.C.textureColor))
CompactRaidFrameManagerBorderBottomLeft:SetVertexColor(unpack(L.C.textureColor))
CompactRaidFrameManagerBorderTopLeft:SetVertexColor(unpack(L.C.textureColor))
CompactRaidFrameManagerBorderRight:SetVertexColor(unpack(L.C.textureColor))
CompactRaidFrameManagerBorderBottom:SetVertexColor(unpack(L.C.textureColor))
CompactRaidFrameManagerBorderTop:SetVertexColor(unpack(L.C.textureColor))
CompactRaidFrameManagerToggleButton:SetAlpha(0.7)
CompactRaidFrameManagerToggleButton:ClearAllPoints()
CompactRaidFrameManagerToggleButton:SetPoint("RIGHT",-8,0)

--OnShow fader
if L.C.fader then
  rLib:CreateFrameFader(PlayerFrame, L.C.fader)
end
