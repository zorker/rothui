
-- oUF_Simple: templates/raid
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- CreateRaidStyle
-----------------------------

if not L.C.raid or not L.C.raid.enabled then return end

local function CreateRaidStyle(self)
  --config
  self.cfg = L.C.raid
  --settings
  self.settings = {}
  self.settings.template = "raid"
  self.settings.setupFrame = false
  self.settings.setupHeader = true
  self.settings.createDrag = false
  --style
  L.F.CreateStyle(self)
  --attributes
  --self:SetAttribute("initial-width", self.cfg.size[1])
  --self:SetAttribute("initial-height", self.cfg.size[2])
  --self:SetAttribute("initial-scale", self.cfg.scale)
end
L.F.CreateRaidStyle = CreateRaidStyle