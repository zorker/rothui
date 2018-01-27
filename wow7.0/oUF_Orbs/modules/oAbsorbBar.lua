
local A, L = ...
local oUF = L.oUF or oUF

local function Update(self, event, unit)
  if(self.unit ~= unit) then return end
  local ta = self.oAbsorbBar
  local allAbsorbs = UnitGetTotalAbsorbs(unit) or 0
  local maxHealth = UnitHealthMax(unit)
  if allAbsorbs > maxHealth then allAbsorbs = maxHealth end
  ta:SetMinMaxValues(0, maxHealth)
  ta:SetValue(allAbsorbs)
end

local function Path(self, ...)
  return (self.oAbsorbBar.Override or Update) (self, ...)
end

local function ForceUpdate(element)
  return Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local function Enable(self)
  local ta = self.oAbsorbBar
  if(ta) then
    ta.__owner = self
    ta.ForceUpdate = ForceUpdate
    self:RegisterEvent('UNIT_ABSORB_AMOUNT_CHANGED', Path)
    self:RegisterEvent('UNIT_MAXHEALTH', Path)
    return true
  end
end

local function Disable(self)
  local ta = self.oAbsorbBar
  if(ta) then
    self:UnregisterEvent('UNIT_ABSORB_AMOUNT_CHANGED', Path)
    self:UnregisterEvent('UNIT_MAXHEALTH', Path)
  end
end

oUF:AddElement('oAbsorbBar', Path, Enable, Disable)
