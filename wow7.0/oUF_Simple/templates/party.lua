
-- oUF_Simple: templates/party
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- CreatePartyStyle
-----------------------------

if not L.C.party or not L.C.party.enabled then return end

local function CreatePartyStyle(self)
  --config
  self.cfg = L.C.party
  --settings
  self.settings = {}
  self.settings.template = "party"
  self.settings.setupFrame = false
  self.settings.setupHeader = true
  self.settings.createDrag = false
  --style
  L.F.CreateStyle(self)
  --attributes
  --self:SetAttribute("initial-width", self.cfg.size[1])
  --self:SetAttribute("initial-height", self.cfg.size[2])
  --self:SetAttribute("initial-scale", self.cfg.scale)
end
L.F.CreatePartyStyle = CreatePartyStyle