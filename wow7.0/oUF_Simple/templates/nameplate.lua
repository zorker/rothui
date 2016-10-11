
-- oUF_Simple: templates/nameplate
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- CreateNamePlateStyle
-----------------------------

if not L.C.nameplate or not L.C.nameplate.enabled then return end

local function CreateNamePlateStyle(self)
  --config
  self.cfg = L.C.nameplate
  --settings
  self.settings = {}
  self.settings.template = "nameplate"
  self.settings.setupFrame = true
  self.settings.setupHeader = false
  self.settings.createDrag = false
  --style
  L.F.CreateStyle(self)
end
L.F.CreateNamePlateStyle = CreateNamePlateStyle