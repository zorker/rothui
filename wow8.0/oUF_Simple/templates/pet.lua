
-- oUF_Simple: templates/pet
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- CreatePetStyle
-----------------------------

if not L.C.pet or not L.C.pet.enabled then return end

local function CreatePetStyle(self)
  --config
  self.cfg = L.C.pet
  --settings
  self.settings = {}
  self.settings.template = "pet"
  self.settings.setupFrame = true
  self.settings.setupHeader = true
  self.settings.createDrag = true
  --style
  L.F.CreateStyle(self)
end
L.F.CreatePetStyle = CreatePetStyle