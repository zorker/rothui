

local parent, ns = ...
local oUF = ns.oUF or oUF

local function Update(self, event, unit)
  if(self.unit ~= unit) then return end
  local ta = self.TotalAbsorb
  if(ta.PreUpdate) then ta:PreUpdate(unit) end
  local allAbsorbs = UnitGetTotalAbsorbs(unit) or 0
  local maxHealth = UnitHealthMax(unit)
  if allAbsorbs > maxHealth then allAbsorbs = maxHealth end
  ta:SetMinMaxValues(0, maxHealth)
  ta:SetValue(allAbsorbs)
  if(ta.PostUpdate) then return ta:PostUpdate(unit,allAbsorbs,maxHealth) end
end

local function Path(self, ...)
  return (self.TotalAbsorb.Override or Update) (self, ...)
end

local ForceUpdate = function(element)
  return Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local function Enable(self)
  local ta = self.TotalAbsorb
  if(ta) then
    ta.__owner = self
    ta.ForceUpdate = ForceUpdate
    self:RegisterEvent('UNIT_ABSORB_AMOUNT_CHANGED', Path)
    self:RegisterEvent('UNIT_MAXHEALTH', Path)
    return true
  end
end

local function Disable(self)
  local ta = self.TotalAbsorb
  if(ta) then
    self:UnregisterEvent('UNIT_ABSORB_AMOUNT_CHANGED', Path)
    self:UnregisterEvent('UNIT_MAXHEALTH', Path)
  end
end

oUF:AddElement('TotalAbsorb', Path, Enable, Disable)
