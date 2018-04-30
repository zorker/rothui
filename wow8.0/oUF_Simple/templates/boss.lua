
-- oUF_Simple: templates/boss
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- CreateBossStyle
-----------------------------

if not L.C.boss or not L.C.boss.enabled then return end

local function CreateBossStyle(self)
  --config
  self.cfg = L.C.boss
  --settings
  self.settings = {}
  self.settings.template = "boss"
  self.settings.setupFrame = true
  self.settings.setupHeader = true
  self.settings.createDrag = false
  --style
  L.F.CreateStyle(self)
end
L.F.CreateBossStyle = CreateBossStyle