
local A, L = ...
local oUF = L.oUF or oUF

local _, PlayerClass = UnitClass'player'
local ClassPowerID, ClassPowerType
local RequireSpec, RequireSpell, RequirePower
local unpack = unpack

local SPEC_MAGE_ARCANE = SPEC_MAGE_ARCANE or 1
local SPEC_MONK_WINDWALKER = SPEC_MONK_WINDWALKER or 3
local SPEC_PALADIN_RETRIBUTION = SPEC_PALADIN_RETRIBUTION or 3
local SPEC_WARLOCK_DESTRUCTION = SPEC_WARLOCK_DESTRUCTION or 3
local SPELL_POWER_ENERGY = Enum.PowerType.Energy or 3
local SPELL_POWER_COMBO_POINTS = Enum.PowerType.ComboPoints or 4
local SPELL_POWER_SOUL_SHARDS = Enum.PowerType.SoulShards or 7
local SPELL_POWER_HOLY_POWER = Enum.PowerType.HolyPower or 9
local SPELL_POWER_CHI = Enum.PowerType.Chi or 12
local SPELL_POWER_ARCANE_CHARGES = Enum.PowerType.ArcaneCharges or 16

do
  if(PlayerClass == 'MONK') then
    ClassPowerID = SPELL_POWER_CHI
    ClassPowerType = 'CHI'
    RequireSpec = SPEC_MONK_WINDWALKER
  elseif(PlayerClass == 'PALADIN') then
    ClassPowerID = SPELL_POWER_HOLY_POWER
    ClassPowerType = 'HOLY_POWER'
    RequireSpec = SPEC_PALADIN_RETRIBUTION
  elseif(PlayerClass == 'WARLOCK') then
    ClassPowerID = SPELL_POWER_SOUL_SHARDS
    ClassPowerType = 'SOUL_SHARDS'
  elseif(PlayerClass == 'ROGUE' or PlayerClass == 'DRUID') then
    ClassPowerID = SPELL_POWER_COMBO_POINTS
    ClassPowerType = 'COMBO_POINTS'
    if(PlayerClass == 'DRUID') then
      RequirePower = SPELL_POWER_ENERGY
      RequireSpell = 5221 -- Shred
    end
  elseif(PlayerClass == 'MAGE') then
    ClassPowerID = SPELL_POWER_ARCANE_CHARGES
    ClassPowerType = 'ARCANE_CHARGES'
    RequireSpec = SPEC_MAGE_ARCANE
  end
end

local function CreateSplit(self,i)
  local bar = self.rClassBar
  local split = bar:CreateTexture()
  split:SetTexture(self.cfg.classbar.splits.texture)
  split:SetSize(unpack(self.cfg.classbar.splits.size))
  split:SetVertexColor(unpack(self.cfg.classbar.splits.color))
  local layer, sublayer = bar:GetStatusBarTexture():GetDrawLayer()
  split:SetDrawLayer(layer,sublayer+1)
  bar.splits[i] = split
  return split
end

local function UpdateSplits(self,maxSegments)
  if not self.cfg.classbar.splits or not self.cfg.classbar.splits.enabled then return end
  local bar = self.rClassBar
  if bar.maxSegments == maxSegments then return end
  bar.maxSegments = maxSegments
  if not maxSegments or maxSegments < 2 then
    if not bar.splits then return end
    for i=1,8 do
      if bar.splits[i] and bar.splits[i]:IsShown() then
        bar.splits[i]:Hide()
      end
    end
    return
  end
  if maxSegments > 8 then maxSegments = 5 end --anything above 8 will be split into 5 parts of 20%.
  if not bar.splits then bar.splits = {} end
  local p = bar:GetWidth()/maxSegments
  for i=1,8 do
    if i>maxSegments-1 then
      if bar.splits[i] and bar.splits[i]:IsShown() then
        bar.splits[i]:Hide()
      end
    else
      local split = bar.splits[i] or CreateSplit(self,i)
      split:SetPoint("CENTER",bar,"LEFT",p*i,0)
      if not split:IsShown() then split:Show() end
    end
  end
end

local function Update(self, event, unit, powerType)
  if(not (self.unit == unit and (unit == 'player' and powerType == ClassPowerType
    or unit == 'vehicle' and powerType == 'COMBO_POINTS'))) then
    return
  end
  if event == 'ClassPowerDisable' then return end
  local cb = self.rClassBar
  local ppcur, ppmax
  if unit == 'vehicle' then
    ppcur = GetComboPoints(unit) or 0
    ppmax = MAX_COMBO_POINTS
    UpdateSplits(self,ppmax)
  else
    ppcur = UnitPower('player', ClassPowerID, true) or 0
    ppmax = UnitPowerMax('player', ClassPowerID, true)
    UpdateSplits(self,UnitPowerMax('player', ClassPowerID))
  end
  if ppcur == 0 then
    cb:Hide()
  else
    local color = oUF.colors.power[powerType] or {1,1,1}
    local r,g,b = unpack(color)
    cb:SetStatusBarColor(r,g,b)
    if cb.bg then
      local mu = cb.bg.multiplier or 0.3
      cb.bg:SetVertexColor(r*mu, g*mu, b*mu)
    end
    cb:SetMinMaxValues(0, ppmax)
    cb:SetValue(ppcur)
    cb:Show()
  end
end

local function Path(self, ...)
  return (self.rClassBar.Override or Update) (self, ...)
end

local function ClassPowerEnable(self)
  self:RegisterEvent('UNIT_POWER_FREQUENT', Path)
  self:RegisterEvent('UNIT_MAXPOWER', Path)
  self.rClassBar.isEnabled = true
  if(UnitHasVehicleUI('player')) then
    Path(self, 'ClassPowerEnable', 'vehicle', 'COMBO_POINTS')
  else
    Path(self, 'ClassPowerEnable', 'player', ClassPowerType)
  end
end

local function ClassPowerDisable(self)
  self:UnregisterEvent('UNIT_POWER_FREQUENT', Path)
  self:UnregisterEvent('UNIT_MAXPOWER', Path)
  self.rClassBar:Hide()
  self.rClassBar.isEnabled = false
  Path(self, 'ClassPowerDisable', 'player', ClassPowerType)
end

local function Visibility(self, event, unit)
  local element = self.rClassBar
  local shouldEnable
  if(UnitHasVehicleUI('player')) then
    shouldEnable = true
    unit = 'vehicle'
  elseif(ClassPowerID) then
    if(not RequireSpec or RequireSpec == GetSpecialization()) then
      -- use 'player' instead of unit because 'SPELLS_CHANGED' is a unitless event
      if(not RequirePower or RequirePower == UnitPowerType('player')) then
        if(not RequireSpell or IsPlayerSpell(RequireSpell)) then
          self:UnregisterEvent('SPELLS_CHANGED', Visibility)
          shouldEnable = true
          unit = 'player'
        else
          self:RegisterEvent('SPELLS_CHANGED', Visibility, true)
        end
      end
    end
  end
  local isEnabled = element.isEnabled
  local powerType = unit == 'vehicle' and 'COMBO_POINTS' or ClassPowerType
  if(shouldEnable and not isEnabled) then
    ClassPowerEnable(self)
  elseif(not shouldEnable and (isEnabled or isEnabled == nil)) then
    ClassPowerDisable(self)
  elseif(shouldEnable and isEnabled) then
    Path(self, event, unit, powerType)
  end
end

local function VisibilityPath(self, ...)
  return (self.rClassBar.OverrideVisibility or Visibility) (self, ...)
end

local function ForceUpdate(element)
  return VisibilityPath(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local function Enable(self, unit)
  if(unit ~= 'player') then return end
  local element = self.rClassBar
  if(not element) then return end
  element.__owner = self
  element.ForceUpdate = ForceUpdate
  if(RequireSpec or RequireSpell) then
    self:RegisterEvent('PLAYER_TALENT_UPDATE', VisibilityPath, true)
  end
  if(RequirePower) then
    self:RegisterEvent('UNIT_DISPLAYPOWER', VisibilityPath)
  end
  return true
end

local function Disable(self)
  if self.rClassBar then
    ClassPowerDisable(self)
    self:UnregisterEvent('PLAYER_TALENT_UPDATE', VisibilityPath)
    self:UnregisterEvent('UNIT_DISPLAYPOWER', VisibilityPath)
    self:UnregisterEvent('SPELLS_CHANGED', Visibility)
  end
end

oUF:AddElement('rClassBar', VisibilityPath, Enable, Disable)
