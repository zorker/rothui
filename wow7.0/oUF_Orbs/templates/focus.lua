
-- oUF_Orbs: templates/focus
-- zork, 2018

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- CreateFocusStyle
-----------------------------

if not L.C.focus or not L.C.focus.enabled then return end

local function CreateFocusStyle(self)
  --config
  self.cfg = L.C.focus
  --settings
  self.settings = {}
  self.settings.template = "focus"
  self.settings.setupFrame = true
  self.settings.setupHeader = true
  self.settings.createDrag = true
  --style
  L.F.CreateStyle(self)
end
L.F.CreateFocusStyle = CreateFocusStyle