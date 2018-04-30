
-- oUF_Simple: core/style
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...
local oUF = L.oUF or oUF

-----------------------------
-- Style
-----------------------------

--CreateStyle
local function CreateStyle(self)
  --fix mana color
  if L.C.colors.power and L.C.colors.power.mana then
    self.colors.power["MANA"] = L.C.colors.power.mana
  end
  L.F.SetupFrame(self)
  L.F.SetupHeader(self)
  L.F.CreateDragFrame(self)
  self.Health = L.F.CreateHealthBar(self)
  self.rAbsorbBar = L.F.CreateAbsorbBar(self)
  L.F.CreateNameText(self)
  L.F.CreateHealthText(self)
  self.Power = L.F.CreatePowerBar(self)
  L.F.CreatePowerText(self)
  self.Castbar = L.F.CreateCastBar(self)
  self.rClassBar = L.F.CreateClassBar(self)
  self.AlternativePower = L.F.CreateAltPowerBar(self)
  self.AdditionalPower = L.F.CreateAdditionalPowerBar(self)
  self.Debuffs = L.F.CreateDebuffs(self)
  self.Buffs = L.F.CreateBuffs(self)
  self.RaidTargetIndicator = L.F.CreateRaidMark(self)
end
L.F.CreateStyle = CreateStyle