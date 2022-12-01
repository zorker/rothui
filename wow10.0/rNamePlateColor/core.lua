
-- rNamePlateColor: core
-- zork, 2022

-----------------------------
-- Variables
-----------------------------

local A, L = ...
local RAID_CLASS_COLORS, FACTION_BAR_COLORS = RAID_CLASS_COLORS, FACTION_BAR_COLORS

-----------------------------
-- Functions
-----------------------------

local function UpdateColor(self)
  local unit = self.unit
  if not unit then return end
  if not unit:match('nameplate%d?$') then return end
  local nameplate = C_NamePlate.GetNamePlateForUnit(unit)
  if not nameplate then return end
  local r,g,b
  if UnitIsUnit(unit.."target", "player") then
    r,g,b = 0,1,0
  elseif UnitIsPlayer(unit) then
    local _, class = UnitClass(unit)
    local color = RAID_CLASS_COLORS[class]
    r, g, b = color.r, color.g, color.b
  elseif CompactUnitFrame_IsTapDenied(self) then
    r, g, b = 0.9, 0.9, 0.9
  else
    local color = FACTION_BAR_COLORS[UnitReaction(unit, "player")]
    r, g, b = color.r, color.g, color.b
  end
  self.healthBar:SetStatusBarColor(r,g,b)
end
hooksecurefunc("CompactUnitFrame_UpdateHealthColor", UpdateColor)
hooksecurefunc("CompactUnitFrame_UpdateAggroFlash", UpdateColor)

--register some variables
local function SetVariables()
  SetCVar('ShowNamePlateLoseAggroFlash', 0)
end

--eventHandler
local eventHandler = CreateFrame('Frame')

--already logged in?
if(IsLoggedIn()) then
  SetVariables()
else
  eventHandler:RegisterEvent('PLAYER_LOGIN')
end

--OnEvent
eventHandler:SetScript('OnEvent', function(_, event, unit)
  if(event == 'PLAYER_LOGIN') then
    SetVariables()
  end
end)