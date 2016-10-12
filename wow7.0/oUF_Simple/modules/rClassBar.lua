
local A, L = ...
local oUF = L.oUF or oUF

local _, PlayerClass = UnitClass'player'
local ClassPowerID, ClassPowerType
local RequireSpec, RequireSpell
local unpack = unpack

do
  if(PlayerClass == 'MONK') then
    ClassPowerID = SPELL_POWER_CHI
    ClassPowerType = "CHI"
    RequireSpec = SPEC_MONK_WINDWALKER
  elseif(PlayerClass == 'PALADIN') then
    ClassPowerID = SPELL_POWER_HOLY_POWER
    ClassPowerType = "HOLY_POWER"
    RequireSpec = SPEC_PALADIN_RETRIBUTION
  elseif(PlayerClass == 'WARLOCK') then
    ClassPowerID = SPELL_POWER_SOUL_SHARDS
    ClassPowerType = "SOUL_SHARDS"
  elseif(PlayerClass == 'ROGUE' or PlayerClass == 'DRUID') then
    ClassPowerID = SPELL_POWER_COMBO_POINTS
    ClassPowerType = 'COMBO_POINTS'
    if(PlayerClass == 'DRUID') then
      RequireSpell = 5221 -- Shred
    end
  elseif(PlayerClass == 'MAGE') then
    ClassPowerID = SPELL_POWER_ARCANE_CHARGES
    ClassPowerType = 'ARCANE_CHARGES'
    RequireSpec = SPEC_MAGE_ARCANE
  end
end

local function CreateSplit(self,i)
  local split = self:CreateTexture()
  split:SetTexture("abc")
  split:SetPoint("TOP")
  split:SetPoint("BOTTOM")
  split:SetWidth(math.max(self:GetWidth()*8/360,4))
  local layer, sublayer = self:GetStatusBarTexture():GetDrawLayer()
  split:SetDrawLayer(layer,sublayer+1)
  self.splits[i] = split
  return split
end

local function UpdateSplits(self,maxSegments)
  if not self.useSplits then return end
  if self.maxSegments == maxSegments then return end
  self.maxSegments = maxSegments
  if maxSegements < 2 then
    if not self.splits then return end
    for i=1,7 do
      if self.splits[i] and self.splits[i]:IsShown() then
        self.splits[i]:Hide()
      end
    end
    return
  end
  if maxSemgents > 8 then maxSegments = 5 end --anything above 8 will be split into 5 parts of 20%.
  if not self.splits then self.splits = {} end
  local p = self:GetWidth()/maxSegments
  for i=1,7 do
    if i>maxSemgents-1 then
      if self.splits[i] and self.splits[i]:IsShown() then
        self.splits[i]:Hide()
      end
    else
      local split = self.splits[i] or CreateSplit(self,i)
      split:SetPoint("CENTER",self,"LEFT",p*i,0)
      if not split:IsShown() then split:Show() end
    end
  end
end

local function Update(self, event, unit, powerType)
  if not (unit == 'player' and powerType == ClassPowerType)
    and not (unit == 'vehicle' and powerType == 'COMBO_POINTS') then
    return
  end
  local cb = self.rClassBar
  local ppcur, ppmax
  if unit == 'vehicle' then
    ppcur = GetComboPoints('vehicle', 'target') or 0
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
  self:RegisterEvent('UNIT_DISPLAYPOWER', Path)
  self:RegisterEvent('UNIT_POWER_FREQUENT', Path)
  self:RegisterEvent('UNIT_MAXPOWER', Path)
  if(UnitHasVehicleUI('player')) then
    Path(self, 'ClassPowerEnable', 'vehicle', 'COMBO_POINTS')
  else
    Path(self, 'ClassPowerEnable', 'player', ClassPowerType)
  end
  self.rClassBar.isEnabled = true
end

local function ClassPowerDisable(self)
  self:UnregisterEvent('UNIT_DISPLAYPOWER', Path)
  self:UnregisterEvent('UNIT_POWER_FREQUENT', Path)
  self:UnregisterEvent('UNIT_MAXPOWER', Path)
  Path(self, 'ClassPowerDisable', 'player', ClassPowerType)
  self.rClassBar:Hide()
  self.rClassBar.isEnabled = false
end

local function Visibility(self, event, unit)
  local element = self.rClassBar
  local shouldEnable
  if(UnitHasVehicleUI('player')) then
    shouldEnable = true
  elseif(ClassPowerID) then
    if(not RequireSpec or RequireSpec == GetSpecialization()) then
      if(not RequireSpell or IsPlayerSpell(RequireSpell)) then
        self:UnregisterEvent('SPELLS_CHANGED', Visibility)
        shouldEnable = true
      else
        self:RegisterEvent('SPELLS_CHANGED', Visibility, true)
      end
    end
  end
  local isEnabled = element.isEnabled
  if(shouldEnable and not isEnabled) then
    ClassPowerEnable(self)
  elseif(not shouldEnable and (isEnabled or isEnabled == nil)) then
    ClassPowerDisable(self)
  elseif(shouldEnable and isEnabled) then
    Path(self, event, unit, unit == 'vehicle' and 'COMBO_POINTS' or ClassPowerType)
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
  return true
end

local function Disable(self)
  local element = self.rClassBar
  if(not element) then return end
  ClassPowerDisable(self)
end

oUF:AddElement('rClassBar', VisibilityPath, Enable, Disable)
