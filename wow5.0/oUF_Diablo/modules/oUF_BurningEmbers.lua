if select(2, UnitClass("player")) ~= "WARLOCK" then return end

local parent, ns = ...
local oUF = ns.oUF or oUF

local MAX_POWER_PER_EMBER = 10
local SPELL_POWER_DEMONIC_FURY    = SPELL_POWER_DEMONIC_FURY
local SPELL_POWER_BURNING_EMBERS  = SPELL_POWER_BURNING_EMBERS
local SPELL_POWER_SOUL_SHARDS     = SPELL_POWER_SOUL_SHARDS
local SPEC_WARLOCK_DESTRUCTION    = SPEC_WARLOCK_DESTRUCTION
local SPEC_WARLOCK_AFFLICTION     = SPEC_WARLOCK_AFFLICTION
local SPEC_WARLOCK_DEMONOLOGY     = SPEC_WARLOCK_DEMONOLOGY

local Update = function(self, event, unit, powerType)
  if(self.unit ~= unit or (powerType and powerType ~= 'BURNING_EMBERS')) then return end
  if(GetSpecialization() ~= SPEC_WARLOCK_DESTRUCTION) then return end
  local bar = self.BurningEmberPowerBar
  local cur = UnitPower(unit, SPELL_POWER_BURNING_EMBERS)
  local max = UnitPowerMax(unit, SPELL_POWER_BURNING_EMBERS)

  local cur2 = UnitPower(unit, SPELL_POWER_BURNING_EMBERS, true)
  local max2 = UnitPowerMax(unit, SPELL_POWER_BURNING_EMBERS, true)
  local val = cur2-cur*MAX_POWER_PER_EMBER

  if cur2 < 1 then
    if bar:IsShown() then bar:Hide() end
    return
  else
    if not bar:IsShown() then bar:Show() end
  end

  --adjust the width of the harmony power frame
  local w = 64*(max+2)
  bar:SetWidth(w)
  for i = 1, bar.maxOrbs do
    local orb = self.BurningEmbers[i]
    if i > max then
       if orb:IsShown() then orb:Hide() end
    else
      if not orb:IsShown() then orb:Show() end
    end
  end
  local valueApplied = false
  for i = 1, max do
    local orb = self.BurningEmbers[i]
    local full = cur/max
    if(i <= cur) then
      if full == 1 then
        orb:SetStatusBarColor(1,0,0)
        orb.glow:SetVertexColor(1,0,0)
      else
        orb:SetStatusBarColor(bar.color.r,bar.color.g,bar.color.b)
        orb.glow:SetVertexColor(bar.color.r,bar.color.g,bar.color.b)
      end
      orb.glow:Show()
      orb:SetValue(MAX_POWER_PER_EMBER)
    else
      if not valueApplied then
        orb:SetStatusBarColor(bar.color.r,bar.color.g,bar.color.b)
        orb:SetValue(val)
        valueApplied = true
      else
        orb:SetValue(0)
      end
      orb.glow:Hide()
    end
  end

end

local Visibility = function(self, event, unit)
  local element = self.BurningEmbers
  local bar = self.BurningEmberPowerBar
  if(GetSpecialization() == SPEC_WARLOCK_DESTRUCTION) then
    bar:Show()
    element.ForceUpdate(element)
  else
    --bar:Hide()
  end
end

local Path = function(self, ...)
  return (self.BurningEmbers.Override or Update) (self, ...)
end

local ForceUpdate = function(element)
  return Path(element.__owner, 'ForceUpdate', element.__owner.unit, 'BURNING_EMBERS')
end

local function Enable(self)
  local element = self.BurningEmbers
  if(element) then
    element.__owner = self
    element.ForceUpdate = ForceUpdate

    self:RegisterEvent('UNIT_POWER', Path, true)
    self:RegisterEvent('UNIT_DISPLAYPOWER', Path, true)
    self:RegisterEvent('PLAYER_TALENT_UPDATE', Visibility, true)
    self:RegisterEvent("SPELLS_CHANGED", Visibility, true)

    return true
  end
end

local function Disable(self)
  local element = self.BurningEmbers
  if(element) then
    self:UnregisterEvent('UNIT_POWER', Path)
    self:UnregisterEvent('UNIT_DISPLAYPOWER', Path)
    self:UnregisterEvent('PLAYER_TALENT_UPDATE', Visibility)
    self:UnregisterEvent('PLAYER_LOGIN', Visibility)
    self:UnregisterEvent('SPELLS_CHANGED', Visibility)
  end
end

oUF:AddElement('BurningEmbers', Path, Enable, Disable)
