
-- oUF_Simple: core/style
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...
local oUF = L.oUF

-----------------------------
-- Style
-----------------------------

--CreateStyle
local function CreateStyle(self)
  L.F.SetupFrame(self)
  L.F.SetupHeader(self)
  L.F.CreateDragFrame(self)
  self.Health = L.F.CreateHealthBar(self)
  self.rAbsorbBar = L.F.CreateAbsorbBar(self)
  L.F.CreateNameText(self)
  L.F.CreateHealthText(self)
  self.Power = L.F.CreatePowerBar(self)
  self.Castbar = L.F.CreateCastBar(self)
  self.rClassBar = L.F.CreateClassBar(self)
  self.AltPowerBar = L.F.CreateAltPowerBar(self)
  self.Debuffs = L.F.CreateDebuffs(self)
  self.Buffs = L.F.CreateBuffs(self)
  --raid marker
  --self.RaidIcon = CreateIcon(self.Health,"OVERLAY",-8,self:GetHeight()/1.2,{"CENTER",self.Health,"TOP",0,0})
end
L.F.CreateStyle = CreateStyle