
-- oUF_Simple: units/target
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- CreateTargetStyle
-----------------------------

if not L.C.units.target.enabled then return end

local function CreateTargetStyle(self)
  --frame config
  self.cfg = L.C.units.target
  self.cfg.template = "target"
  --setup
  L.F.SetupFrame(self)
  --health
  L.F.CreateHealthBar(self)
  --power
  L.F.CreatePowerBar(self)
  --castbar
  L.F.CreateCastBar(self)
  self.Castbar:SetPoint("BOTTOM",self,"TOP",0,15)
  --CreateBuffs
  L.F.CreateBuffs(self,self.cfg.buffCfg)
  --CreateDebuffs
  L.F.CreateDebuffs(self,self.cfg.debuffCfg)
  --name
  local name = L.F.CreateText(self.rAbsorbBar or self.Health,14,"LEFT")
  self:Tag(name, "[difficulty][name]|r")
  name:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 2, -name:GetStringHeight()/3)
  --health text
  local healthText = L.F.CreateText(self.rAbsorbBar or self.Health,13,"RIGHT")
  self:Tag(healthText, "[oUF_Simple:health]")
  healthText:SetPoint("RIGHT",-2,0)
  name:SetPoint("RIGHT",healthText,"LEFT",-2,0)
  --ouf config
  self.Health.colorTapping = true
  self.Health.colorDisconnected = true
  self.Health.colorClass = true
  self.Health.colorReaction = true
  self.Health.colorHealth = true
  self.Health.colorThreat = true
  self.Health.colorThreatInvers = true
  self.Health.bg.multiplier = 0.3
  self.Power.colorPower = true
  self.Power.bg.multiplier = 0.3
  --events
  self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", L.F.UpdateThreat)
end
L.F.CreateTargetStyle = CreateTargetStyle