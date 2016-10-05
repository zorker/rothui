
-- oUF_Simple: units/party
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- CreatePartyStyle
-----------------------------

if not L.C.units.party.enabled then return end

local function CreatePartyStyle(self)
  --frame config
  self.cfg = L.C.units.party
  self.cfg.template = "party"
  --setup
  L.F.SetupHeader(self)
  --health
  L.F.CreateHealthBar(self)
  --power
  L.F.CreatePowerBar(self)
  --CreateDebuffs
  L.F.CreateDebuffs(self,self.cfg.debuffCfg)
  --name
  local name = L.F.CreateText(self.rAbsorbBar or self.Health,14,"LEFT")
  self:Tag(name, "[name]")
  name:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 2, -name:GetStringHeight()/3)
  --health text
  local healthText = L.F.CreateText(self.rAbsorbBar or self.Health,13,"RIGHT")
  self:Tag(healthText, "[oUF_Simple:health]")
  healthText:SetPoint("RIGHT",-2,0)
  name:SetPoint("RIGHT",healthText,"LEFT",-2,0)
  --ouf config
  self.Health.colorDisconnected = true
  self.Health.colorClass = true
  self.Health.colorReaction = true
  self.Health.colorHealth = true
  self.Health.colorThreat = true
  self.Health.bg.multiplier = 0.3
  self.Power.colorPower = true
  self.Power.bg.multiplier = 0.3
  --events
  self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", L.F.UpdateThreat)
end
L.F.CreatePartyStyle = CreatePartyStyle