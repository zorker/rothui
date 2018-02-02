
-- oUF_Simple: templates/mouseover
-- zork, 2018

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- CreateMouseoverStyle
-----------------------------

if not L.C.mouseover or not L.C.mouseover.enabled then return end

local function CreateMouseoverStyle(self)
  --config
  self.cfg = L.C.mouseover
  --settings
  self.settings = {}
  self.settings.template = "mouseover"
  self.settings.setupFrame = true
  self.settings.setupHeader = false
  self.settings.createDrag = false
  --style
  L.F.CreateStyle(self)
end
L.F.CreateMouseoverStyle = CreateMouseoverStyle