
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
end
L.F.CreateRaidStyle = CreateRaidStyle