
-- oUF_Simple: units/pet
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- CreatePetStyle
-----------------------------

if not L.C.units.pet.enabled then return end

local function CreatePetStyle(self)
  --frame config
  self.cfg = L.C.units.pet
  self.cfg.template = "pet"
  --setup
  L.F.SetupFrame(self)
  --health
  L.F.CreateHealthBar(self)
  --altpowerbar
  L.F.CreateAltPowerBar(self)
  --CreateDebuffs
  L.F.CreateDebuffs(self,self.cfg.debuffCfg)
  --castbar
  L.F.CreateCastBar(self)
  self.Castbar:SetPoint("TOP",self,"BOTTOM",0,-5)
  --name
  local name = L.F.CreateText(self.rAbsorbBar or self.Health,14,"CENTER")
  self:Tag(name, "[name]")
  --name:SetPoint("CENTER", self.Health)
  name:SetPoint("LEFT", self.Health, "LEFT", 2, 0)
  name:SetPoint("RIGHT", self.Health, "RIGHT", -2, 0)
  --ouf config
  self.Health.colorClass = true
  self.Health.colorReaction = true
  self.Health.colorHealth = true
  self.Health.colorThreat = true
  self.Health.bg.multiplier = 0.3
  --events
  self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", L.F.UpdateThreat)
end
L.F.CreatePetStyle = CreatePetStyle