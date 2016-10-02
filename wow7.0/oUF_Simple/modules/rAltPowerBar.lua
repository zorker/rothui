
local parent, ns = ...
local oUF = ns.oUF or oUF

local ALTERNATE_POWER_INDEX = ALTERNATE_POWER_INDEX

local Path

local function HideBar(self)
  self:UnregisterEvent('UNIT_POWER', Path)
  self:UnregisterEvent('UNIT_MAXPOWER', Path)
  self.rAltPowerBar:Hide()
  self.rAltPowerBar:SetMinMaxValues(0,1)
  self.rAltPowerBar:SetValue(0)
end

local function Update(self, event, unit, powerType)
  if powerType ~= 'ALTERNATE' then return end
  if unit ~= self.unit then return end
  if not self.rAltPowerBar:IsShown() then return end
  local ppmax = UnitPowerMax(unit, ALTERNATE_POWER_INDEX, true) or 0
  local ppcur = UnitPower(unit, ALTERNATE_POWER_INDEX, true)
  if ppmax == 0 then
    --print("UpdateHide",event,unit,self.unit,self.realunit,ppmin,ppmax,ppcur)
    HideBar(self)
    return
  end
  local _, r, g, b = UnitAlternatePowerTextureInfo(unit, 2)
  local _, ppmin = UnitAlternatePowerInfo(unit)
  --print("Update",event,unit,ppmin,ppmax,ppcur)
  local el = self.rAltPowerBar
  el:SetMinMaxValues(ppmin or 0, ppmax)
  el:SetValue(ppcur)
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

Path = function(self, ...)
  return (self.rAltPowerBar.Override or Update) (self, ...)
end

local function ForceUpdate(el)
  return Path(el.__owner, 'ForceUpdate', el.__owner.unit, 'ALTERNATE')
end

local function Toggle(self, event, unit)
  if unit ~= self.unit then return end
  --print("Toggle",event,unit)
  if event == "UNIT_POWER_BAR_HIDE" then
    HideBar(self)
    return
  end
  local barType, _, _, _, _, hideFromOthers, showOnRaid = UnitAlternatePowerInfo(unit)
  if(barType and (showOnRaid and (UnitInParty(unit) or UnitInRaid(unit)) or not hideFromOthers or unit == 'player' or self.realUnit == 'player')) then
    self.rAltPowerBar:Show()
    ForceUpdate(self.rAltPowerBar) --may fail if owner.unit is vehicle but power unit is player
    self:RegisterEvent('UNIT_POWER', Path)
    self:RegisterEvent('UNIT_MAXPOWER', Path)
  else
    HideBar(self)
  end
end

local function Enable(self,unit)
  local el = self.rAltPowerBar
  if(el) then
    el.__owner = self
    el.ForceUpdate = ForceUpdate
    self:RegisterEvent('UNIT_POWER_BAR_SHOW', Toggle)
    self:RegisterEvent('UNIT_POWER_BAR_HIDE', Toggle)
    HideBar(self)
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
    HideBar(self)
    if(unit == 'player') then
      PlayerPowerBarAlt:RegisterEvent'UNIT_POWER_BAR_SHOW'
      PlayerPowerBarAlt:RegisterEvent'UNIT_POWER_BAR_HIDE'
      PlayerPowerBarAlt:RegisterEvent'PLAYER_ENTERING_WORLD'
    end
  end
end

oUF:AddElement('rAltPowerBar', Path, Enable, Disable)
