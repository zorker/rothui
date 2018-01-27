
-- oUF_Orbs: templates/target
-- zork, 2018

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- CreateTargetStyle
-----------------------------

if not L.C.target or not L.C.target.enabled then return end

local function CreateTargetStyle(self)
  --config
  self.cfg = L.C.target
  --settings
  self.settings = {}
  self.settings.template = "target"
  self.settings.setupFrame = true
  self.settings.setupHeader = true
  self.settings.createDrag = true
  --style
  L.F.CreateStyle(self)
end
L.F.CreateTargetStyle = CreateTargetStyle