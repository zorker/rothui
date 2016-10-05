
-- oUF_Simple: units/targettarget
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- CreateTargetTargetStyle
-----------------------------

if not L.C.units.targettarget.enabled then return end

local function CreateTargetTargetStyle(self)
  --frame config
  self.cfg = L.C.units.targettarget
  self.cfg.template = "targettarget"
  --setup
  L.F.SetupFrame(self)
  --health
  L.F.CreateHealthBar(self)
  --CreateDebuffs

  L.F.CreateDebuffs(self,self.cfg.debuffCfg)
  --name
  local name = L.F.CreateText(self.Health,14,"CENTER")
  self:Tag(name, "[name]")
  --name:SetPoint("CENTER", self.Health)
  name:SetPoint("LEFT", self.Health, "LEFT", 2, 0)
  name:SetPoint("RIGHT", self.Health, "RIGHT", -2, 0)
  --ouf config
  self.Health.colorTapping = true
  self.Health.colorDisconnected = true
  self.Health.colorClass = true
  self.Health.colorReaction = true
  self.Health.colorHealth = true
  self.Health.bg.multiplier = 0.3
end
L.F.CreateTargetTargetStyle = CreateTargetTargetStyle