
-- oUF_Simple: templates/arena
-- zork, 2018

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- CreateArenaStyle
-----------------------------

if not L.C.arena or not L.C.arena.enabled then return end

local function CreateArenaStyle(self)
  --config
  self.cfg = L.C.arena
  --settings
  self.settings = {}
  self.settings.template = "arena"
  self.settings.setupFrame = true
  self.settings.setupHeader = true
  self.settings.createDrag = false
  --style
  L.F.CreateStyle(self)
end
L.F.CreateArenaStyle = CreateArenaStyle