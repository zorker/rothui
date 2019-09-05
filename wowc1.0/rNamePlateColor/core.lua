
-- rNamePlateColor: core
-- zork, 2019

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Functions
-----------------------------

local function UpdateThreat(self)
  local unit = self.unit
  if not unit then return end
  if not unit:match('nameplate%d?$') then return end
  local nameplate = C_NamePlate.GetNamePlateForUnit(unit)
  if not nameplate then return end
  if UnitIsUnit(unit.."target", "player") then
    self.healthBar:SetStatusBarColor(0,1,0)
  else
    self.healthBar:SetStatusBarColor(1,0,0)
  end
end
hooksecurefunc("CompactUnitFrame_UpdateHealthColor", UpdateThreat)
hooksecurefunc("CompactUnitFrame_UpdateHealth", UpdateThreat)