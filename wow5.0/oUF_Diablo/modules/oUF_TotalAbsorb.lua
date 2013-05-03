
  local parent, ns = ...
  local oUF = ns.oUF or oUF
   
  local function Update(self, event, unit)
    if(self.unit ~= unit) then return end
    
    local ta = self.TotalAbsorb
    if(ta.PreUpdate) then ta:PreUpdate(unit) end
   
    local allAbsorbs = UnitGetTotalAbsorbs(unit) or 0
    local health, maxHealth = UnitHealth(unit), UnitHealthMax(unit)
   
    if(health + allAbsorbs > maxHealth * ta.maxOverflow) then
      allAbsorbs = maxHealth * ta.maxOverflow - health
    end
   
    ta:SetMinMaxValues(0, maxHealth)
    ta:SetValue(allAbsorbs)
    ta:Show()
   
    if(ta.PostUpdate) then
      return ta:PostUpdate(unit)
    end
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
      self:RegisterEvent('UNIT_HEALTH', Path)
   
      if(not ta.maxOverflow) then
        ta.maxOverflow = 1.05
      end
   
      if(ta and ta:IsObjectType'StatusBar' and not ta:GetStatusBarTexture()) then
        ta:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
      end
   
      return true
    end
  end
   
  local function Disable(self)
    local ta = self.TotalAbsorb
    if(ta) then
      self:UnregisterEvent('UNIT_ABSORB_AMOUNT_CHANGED', Path)
      self:UnregisterEvent('UNIT_MAXHEALTH', Path)
      self:UnregisterEvent('UNIT_HEALTH', Path)
    end
  end
   
  oUF:AddElement('TotalAbsorb', Path, Enable, Disable)
