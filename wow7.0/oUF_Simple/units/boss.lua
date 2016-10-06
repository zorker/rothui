
-- oUF_Simple: units/boss
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- CreateBossStyle
-----------------------------

if not L.C.units.boss.enabled then return end

local function CreateBossStyle(self)
  --frame config
  self.cfg = L.C.units.boss
  self.cfg.template = "boss"
  --setup
  L.F.SetupFrame(self)
  --health
  L.F.CreateHealthBar(self)
  --power
  L.F.CreatePowerBar(self)
  --CreateDebuffs
  L.F.CreateDebuffs(self,self.cfg.debuffCfg)
  --castbar
  L.F.CreateCastBar(self)
  self.Castbar:SetPoint("TOP",self,"BOTTOM",0,-8)
  --altpowerbar
  L.F.CreateAltPowerBar(self)
  --name
  local name = L.F.CreateText(self.rAbsorbBar or self.Health,14,"CENTER")
  self:Tag(name, "[name]")
  --name:SetPoint("CENTER", self.Health)
  name:SetPoint("LEFT", self.Health, "LEFT", 2, 0)
  name:SetPoint("RIGHT", self.Health, "RIGHT", -2, 0)
  --ouf config
  self.Health.colorReaction = true
  self.Health.colorHealth = true
  self.Health.colorThreat = true
  self.Health.bg.multiplier = 0.3
  self.Power.colorPower = true
  self.Power.bg.multiplier = 0.3
  self.AltPowerBar.bg.multiplier = 0.3
  --events
  self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", L.F.UpdateThreat)
end
L.F.CreateBossStyle = CreateBossStyle