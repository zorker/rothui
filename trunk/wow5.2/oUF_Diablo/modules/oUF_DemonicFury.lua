if select(2, UnitClass("player")) ~= "WARLOCK" then return end

local parent, ns = ...
local oUF = ns.oUF or oUF

local SPELL_POWER_DEMONIC_FURY    = SPELL_POWER_DEMONIC_FURY
local SPEC_WARLOCK_DEMONOLOGY     = SPEC_WARLOCK_DEMONOLOGY

local Update = function(self, event, unit, powerType)
  if(self.unit ~= unit or (powerType and powerType ~= "DEMONIC_FURY")) then return end
  --other warlock powers will fire even in another spec, double check for spec
  if(GetSpecialization() ~= SPEC_WARLOCK_DEMONOLOGY) then return end
  local bar = self.DemonicFuryPowerBar
  local cur = UnitPower(unit, SPELL_POWER_DEMONIC_FURY)
  local max = UnitPowerMax(unit, SPELL_POWER_DEMONIC_FURY)
  --[[ --do not hide the bar when the value is empty, keep it visible
  if cur < 1 then
    if bar:IsShown() then bar:Hide() end
    return
  else
    if not bar:IsShown() then bar:Show() end
  end
  ]]
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
  if UnitHasVehicleUI("player")
    or ((HasVehicleActionBar() and UnitVehicleSkin("player") and UnitVehicleSkin("player") ~= "")
    or (HasOverrideActionBar() and GetOverrideBarSkin() and GetOverrideBarSkin() ~= ""))
  then
    bar:Hide()
  elseif(GetSpecialization() == SPEC_WARLOCK_DEMONOLOGY) then
    bar:Show()
    element.ForceUpdate(element)
  else
    bar:Hide()
  end
end


local Path = function(self, ...)
  return (self.DemonicFury.Override or Update) (self, ...)
end

local ForceUpdate = function(element)
  return Path(element.__owner, 'ForceUpdate', element.__owner.unit, 'DEMONIC_FURY')
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
    self:RegisterEvent("UPDATE_OVERRIDE_ACTIONBAR", Visibility, true)

    local helper = CreateFrame("Frame") --this is needed...adding player_login to the visivility events doesn't do anything
    helper:RegisterEvent("PLAYER_LOGIN")
    helper:SetScript("OnEvent", function() Visibility(self) end)

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
    self:UnregisterEvent('UPDATE_OVERRIDE_ACTIONBAR', Visibility)
  end
end

oUF:AddElement('DemonicFury', Path, Enable, Disable)
