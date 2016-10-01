
local parent, ns = ...
local oUF = ns.oUF or oUF

local ALTERNATE_POWER_INDEX = ALTERNATE_POWER_INDEX

local function Update(self, event, unit, powerType)
  if powerType ~= 'ALTERNATE' then return end
  local el = self.rAltPowerBar
  if self.unit == "vehicle" then
    if unit ~= "player" and unit ~= "vehicle" then
      el:Hide()
      return
    end
  elseif unit ~= self.unit then
    el:Hide()
    return
  end
  print("Update",event,unit,self.unit)
  local ppmax = UnitPowerMax(unit, ALTERNATE_POWER_INDEX, true) or 0
  if ppmax == 0 then el:Hide() return end
  local ppcur = UnitPower(unit, ALTERNATE_POWER_INDEX, true)
  local _, r, g, b = UnitAlternatePowerTextureInfo(unit, 2)
  local _, ppmin = UnitAlternatePowerInfo(unit)
  el:SetMinMaxValues(ppmin or 0, ppmax)
  el:SetValue(ppcur)
  print(ppcur,ppmax)
  if b then
    el:SetStatusBarColor(r, g, b)
    if el.bg then
      local mu = el.bg.multiplier or 0.3
      el.bg:SetVertexColor(r*mu, g*mu, b*mu)
    end
  else
    el:SetStatusBarColor(1, 0, 1)
    if el.bg then
      local mu = el.bg.multiplier or 0.3
      el.bg:SetVertexColor(1*mu, 0*mu, 1*mu)
    end
  end
end

local function Path(self, ...)
  return (self.rAltPowerBar.Override or Update) (self, ...)
end

local function ForceUpdate(el)
  return Path(el.__owner, 'ForceUpdate', el.__owner.unit, 'ALTERNATE')
end

local function Toggle(self, event, unit)
  local el = self.rAltPowerBar
  if unit ~= self.unit then
    el:Hide()
    return
  end
  print("Toggle",unit,event,self.unit)
  local barType, _, _, _, _, hideFromOthers, showOnRaid = UnitAlternatePowerInfo(unit)
  if(barType and (showOnRaid and (UnitInParty(unit) or UnitInRaid(unit)) or not hideFromOthers or unit == 'player' or self.realUnit == 'player')) then
    self:RegisterEvent('UNIT_POWER', Path)
    self:RegisterEvent('UNIT_MAXPOWER', Path)
    ForceUpdate(el)
    el:Show()
  else
    self:UnregisterEvent('UNIT_POWER', Path)
    self:UnregisterEvent('UNIT_MAXPOWER', Path)
    el:Hide()
  end
end

local function Enable(self,unit)
  local el = self.rAltPowerBar
  if(el) then
    el.__owner = self
    el.ForceUpdate = ForceUpdate
    self:RegisterEvent('UNIT_POWER_BAR_SHOW', Toggle)
    self:RegisterEvent('UNIT_POWER_BAR_HIDE', Toggle)
    el:Hide()
    if(unit == 'player') then
      PlayerPowerBarAlt:UnregisterEvent'UNIT_POWER_BAR_SHOW'
      PlayerPowerBarAlt:UnregisterEvent'UNIT_POWER_BAR_HIDE'
      PlayerPowerBarAlt:UnregisterEvent'PLAYER_ENTERING_WORLD'
    end
    return true
  end
end

local function Disable(self, unit)
  local el = self.rAltPowerBar
  if(el) then
    self:UnregisterEvent('UNIT_POWER_BAR_SHOW', Toggle)
    self:UnregisterEvent('UNIT_POWER_BAR_HIDE', Toggle)
    el:Hide()
    if(unit == 'player') then
      PlayerPowerBarAlt:RegisterEvent'UNIT_POWER_BAR_SHOW'
      PlayerPowerBarAlt:RegisterEvent'UNIT_POWER_BAR_HIDE'
      PlayerPowerBarAlt:RegisterEvent'PLAYER_ENTERING_WORLD'
    end
  end
end

oUF:AddElement('rAltPowerBar', Path, Enable, Disable)
