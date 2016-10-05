
-- oUF_Simple: units/player
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- CreatePlayerStyle
-----------------------------

if not L.C.units.player.enabled then return end

local function CreatePlayerStyle(self)
  --frame config
  self.cfg = L.C.units.player
  self.cfg.template = "player"
  --setup
  L.F.SetupFrame(self)
  --health
  L.F.CreateHealthBar(self)
  --power
  L.F.CreatePowerBar(self)
  --castbar
  L.F.CreateCastBar(self)
  self.Castbar:SetPoint("BOTTOM",self,"TOP",0,15)
  --classbar
  L.F.CreateClassBar(self)
  --altpowerbar
  L.F.CreateAltPowerBar(self)
  --name
  --local name = CreateText(self.rAbsorbBar or self.Health,14,"LEFT")
  --self:Tag(name, "[name]")
  --name:SetPoint("LEFT", self.Health, "LEFT", 2, 0)
  --name:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 2, -name:GetStringHeight()/3)
  --health text
  local healthText = L.F.CreateText(self.rAbsorbBar or self.Health,13,"RIGHT")
  self:Tag(healthText, "[oUF_Simple:health]")
  healthText:SetPoint("RIGHT",-2,0)
  --name:SetPoint("RIGHT",healthText,"LEFT",-2,0)
  --ouf config
  self.Health.colorClass = true
  self.Health.colorHealth = true
  self.Health.colorThreat = true
  self.Health.bg.multiplier = 0.3
  self.Power.colorPower = true
  self.Power.bg.multiplier = 0.3
  self.rClassBar.bg.multiplier = 0.3
  self.AltPowerBar.bg.multiplier = 0.3
  --events
  self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", L.F.UpdateThreat)
end
L.F.CreatePlayerStyle = CreatePlayerStyle