if select(2, UnitClass("player")) ~= "WARLOCK" then return end

local parent, ns = ...
local oUF = ns.oUF or oUF

local SPELL_POWER_DEMONIC_FURY    = SPELL_POWER_DEMONIC_FURY
local SPELL_POWER_BURNING_EMBERS  = SPELL_POWER_BURNING_EMBERS
local SPELL_POWER_SOUL_SHARDS     = SPELL_POWER_SOUL_SHARDS
local SPEC_WARLOCK_DESTRUCTION    = SPEC_WARLOCK_DESTRUCTION
local SPEC_WARLOCK_AFFLICTION     = SPEC_WARLOCK_AFFLICTION
local SPEC_WARLOCK_DEMONOLOGY     = SPEC_WARLOCK_DEMONOLOGY

local Update = function(self, event, unit, powerType)
  if(self.unit ~= unit or (powerType and powerType ~= "DEMONIC_FURY")) then return end
  local cur = UnitPower(unit, SPELL_POWER_DEMONIC_FURY)
  local max = UnitPowerMax(unit, SPELL_POWER_DEMONIC_FURY)
  local sb = self.DemonicFury[1]
  sb:SetMinMaxValues(0, max)
  sb:SetValue(cur)
  if cur/max == 1 then
    sb.glow:Show()
  else
    sb.glow:Hide()
  end
end

local Visibility = function(self, event, unit)
	local element = self.DemonicFury
  local bar = self.DemonicFuryPowerBar
	if(GetSpecialization() == SPEC_WARLOCK_DEMONOLOGY) then
    bar:Show()
	else
		bar:Hide()
	end
end

local Path = function(self, ...)
	return (self.DemonicFury.Override or Update) (self, ...)
end

local ForceUpdate = function(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local Enable = function(self, unit)
	local element = self.DemonicFury
	if(element and unit == 'player') then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		self:RegisterEvent('UNIT_POWER', Path, true)
		self:RegisterEvent('UNIT_DISPLAYPOWER', Path, true)
		self:RegisterEvent('PLAYER_TALENT_UPDATE', Visibility, true)
    self:RegisterEvent("SPELLS_CHANGED", Visibility, true)

		return true
	end
end

local Disable = function(self)
	local element = self.DemonicFury
	if(element) then
		self:UnregisterEvent('UNIT_POWER', Path)
		self:UnregisterEvent('UNIT_DISPLAYPOWER', Path)
		self:UnregisterEvent('PLAYER_TALENT_UPDATE', Visibility)
    self:UnregisterEvent('SPELLS_CHANGED', Visibility)
	end
end

oUF:AddElement('DemonicFury', Path, Enable, Disable)
