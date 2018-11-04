local function UpdateThreat(self)
  local unit = self.unit
  if not unit then return end
  if not unit:match('nameplate%d?$') then return end
  local nameplate = C_NamePlate.GetNamePlateForUnit(unit)
  if not nameplate then return end
  local status = UnitThreatSituation("player", unit)
  if status and status == 3 then
    self.healthBar:SetStatusBarColor(0,1,0)
  end
end

hooksecurefunc("CompactUnitFrame_UpdateHealthColor", UpdateThreat)
hooksecurefunc("CompactUnitFrame_UpdateAggroFlash", UpdateThreat)