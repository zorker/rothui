if select(2, UnitClass("player")) ~= "PRIEST" then return end

local parent, ns = ...
local oUF = ns.oUF or oUF

local SPELL_POWER_SHADOW_ORBS = SPELL_POWER_SHADOW_ORBS
local SPEC_PRIEST_SHADOW = SPEC_PRIEST_SHADOW

local Update = function(self, event, unit, powerType)
  if(self.unit ~= unit or (powerType and powerType ~= "SHADOW_ORBS")) then return end
  local bar = self.ShadowOrbPowerBar
  local num = UnitPower(unit, SPELL_POWER_SHADOW_ORBS)
  local max = UnitPowerMax(unit, SPELL_POWER_SHADOW_ORBS)
  --[[ --do not hide the bar when the value is empty, keep it visible
  if num < 1 then
    if bar:IsShown() then bar:Hide() end
    return
  else
    if not bar:IsShown() then bar:Show() end
  end
  ]]
  --adjust the width of the shadow orb power frame
  local w = 64*(max+2)
  bar:SetWidth(w)
  for i = 1, bar.maxOrbs do
    local orb = self.ShadowOrbs[i]
    if i > max then
       if orb:IsShown() then orb:Hide() end
    else
      if not orb:IsShown() then orb:Show() end
    end
  end
  for i = 1, max do
    local orb = self.ShadowOrbs[i]
    local full = num/max
    if(i <= num) then
      if full == 1 then
        orb.fill:SetVertexColor(1,0,0)
        orb.glow:SetVertexColor(1,0,0)
      else
        orb.fill:SetVertexColor(bar.color.r,bar.color.g,bar.color.b)
        orb.glow:SetVertexColor(bar.color.r,bar.color.g,bar.color.b)
      end
      orb.fill:Show()
      orb.glow:Show()
      orb.highlight:Show()
    else
      orb.fill:Hide()
      orb.glow:Hide()
      orb.highlight:Hide()
    end
  end
end

local Visibility = function(self, event, unit)
  local element = self.ShadowOrbs
  local bar = self.ShadowOrbPowerBar
  if UnitHasVehicleUI("player")
    or ((HasVehicleActionBar() and UnitVehicleSkin("player") and UnitVehicleSkin("player") ~= "")
    or (HasOverrideActionBar() and GetOverrideBarSkin() and GetOverrideBarSkin() ~= ""))
  then
    bar:Hide()
  elseif(GetSpecialization() == SPEC_PRIEST_SHADOW) then
    bar:Show()
    element.ForceUpdate(element)
  else
    bar:Hide()
  end
end

local Path = function(self, ...)
  return (self.ShadowOrbs.Override or Update) (self, ...)
end

local ForceUpdate = function(element)
  return Path(element.__owner, 'ForceUpdate', element.__owner.unit, 'SHADOW_ORBS')
end

local Enable = function(self, unit)
  local element = self.ShadowOrbs
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
  local element = self.ShadowOrbs
  if(element) then
    self:UnregisterEvent('UNIT_POWER', Path)
    self:UnregisterEvent('UNIT_DISPLAYPOWER', Path)
    self:UnregisterEvent('PLAYER_TALENT_UPDATE', Visibility)
    self:UnregisterEvent('SPELLS_CHANGED', Visibility)
    self:UnregisterEvent('UPDATE_OVERRIDE_ACTIONBAR', Visibility)
  end
end

oUF:AddElement('ShadowOrbs', Path, Enable, Disable)
