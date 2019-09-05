
-- rNamePlateColor: core
-- zork, 2019

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
hooksecurefunc("CompactUnitFrame_UpdateHealth", UpdateColor)