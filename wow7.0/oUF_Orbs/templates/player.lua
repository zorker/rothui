
-- oUF_Orbs: templates/player
-- zork, 2018

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- CreatePlayerStyle
-----------------------------

if not L.C.player or not L.C.player.enabled then return end

local function CreatePlayerStyle(self)
  --config
  self.cfg = L.C.player
  --settings
  self.settings = {}
  self.settings.template = "player"
  self.settings.setupFrame = true
  self.settings.setupHeader = true
  self.settings.createDrag = true
  --style
  L.F.CreateStyle(self)
end
L.F.CreatePlayerStyle = CreatePlayerStyle