
-- oUF_Simple: templates/targettarget
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- CreateTargetTargetStyle
-----------------------------

if not L.C.targettarget or not L.C.targettarget.enabled then return end

local function CreateTargetTargetStyle(self)
  --config
  self.cfg = L.C.targettarget
  --settings
  self.settings = {}
  self.settings.template = "targettarget"
  self.settings.setupFrame = true
  self.settings.setupHeader = true
  self.settings.createDrag = true
  --style
  L.F.CreateStyle(self)
end
L.F.CreateTargetTargetStyle = CreateTargetTargetStyle