
-- oUF_Boiler: spawn
-- zork, 2018

-----------------------------
-- Variables
-----------------------------

local A, L = ...
local oUF = L.oUF or oUF

-----------------------------
-- Config
-----------------------------

L.C = {}

--player
L.C.player = {
  size = { 256, 32 },
  point = { "CENTER", UIParent, "CENTER", -200, -100 },
  scale = 1,
  healthbar = {
    colorClass = true,
    colorHealth = true,
    colorReaction = true,
  },
}

--target
L.C.target = {
  size = { 256, 32 },
  point = { "CENTER", UIParent, "CENTER", 200, -100 },
  scale = 1,
  healthbar = {
    colorClass = true,
    colorHealth = true,
    colorReaction = true,
  },
}

--party
L.C.party = {
  size = {180,26},
  point = {"TOPLEFT",20,-20},
  scale = 1,
  healthbar = {
    colorClass = true,
    colorHealth = true,
    colorReaction = true,
  },
  header = {
    template = nil,
    visibility = "custom [group:party,nogroup:raid] show; hide",
    showPlayer = true,
    showSolo = false,
    showParty = true,
    showRaid = false,
    point = "TOP",
    xOffset = 0,
    yOffset = -14,
  },
}

-----------------------------
-- Functions
-----------------------------

--SetupEvents
local function SetupEvents(self)
  if not self.settings.setupEvents then return end
  self:RegisterForClicks("AnyDown")
  self:SetScript("OnEnter", UnitFrame_OnEnter)
  self:SetScript("OnLeave", UnitFrame_OnLeave)
end

--SetupFrame
local function SetupFrame(self)
  if not self.settings.setupFrame then return end
  self:SetSize(unpack(self.cfg.size))
  self:SetPoint(unpack(self.cfg.point))
  self:SetScale(self.cfg.scale)
end

--CreateHealthBar
local function CreateHealthBar(self)
  --statusbar
  local s = CreateFrame("StatusBar", nil, self)
  s:SetAllPoints()
  --bg
  local bg = s:CreateTexture(nil, "BACKGROUND")
  bg:SetColorTexture(0,0,0,0.5)
  bg:SetAllPoints()
  --attributes
  s.colorTapping = self.cfg.healthbar.colorTapping
  s.colorDisconnected = self.cfg.healthbar.colorDisconnected
  s.colorReaction = self.cfg.healthbar.colorReaction
  s.colorClass = self.cfg.healthbar.colorClass
  s.colorHealth = self.cfg.healthbar.colorHealth
  s.frequentUpdates = self.cfg.healthbar.frequentUpdates
  return s
end

--CreateStyle
local function CreateStyle(self)
  SetupFrame(self)
  SetupEvents(self)
  self.Health = CreateHealthBar(self)
end

--PlayerStyle
local function PlayerStyle(self)
  --config
  self.cfg = L.C.player
  --settings
  self.settings = {}
  self.settings.template = "player"
  self.settings.setupFrame = true
  self.settings.setupEvents = true
  --style
  CreateStyle(self)
end
--register style function with oUF
oUF:RegisterStyle(A.."PlayerStyle", PlayerStyle)

--TargetStyle
local function TargetStyle(self)
  --config
  self.cfg = L.C.target
  --settings
  self.settings = {}
  self.settings.template = "player"
  self.settings.setupFrame = true
  self.settings.setupEvents = true
  --style
  CreateStyle(self)
end
--register style function with oUF
oUF:RegisterStyle(A.."TargetStyle", TargetStyle)

--CreatePartyStyle
local function CreatePartyStyle(self)
  --config
  self.cfg = L.C.party
  --settings
  self.settings = {}
  self.settings.template = "party"
  self.settings.setupFrame = false
  self.settings.setupEvents = true
  --style
  CreateStyle(self)
end
--register style function with oUF
oUF:RegisterStyle(A.."PartyStyle", CreatePartyStyle)

-----------------------------
-- Spawn
-----------------------------

local function Factory(self)

  local oUF = self

  -- player
  oUF:SetActiveStyle(A.."PlayerStyle")
  local player = oUF:Spawn("player", A.."Player")

  --target
  oUF:SetActiveStyle(A.."TargetStyle")
  local target = oUF:Spawn("target", A.."Target")

  --spawn party header
  oUF:SetActiveStyle(A.."PartyStyle")
  oUF:SpawnHeader(
    A.."PartyHeader",
    L.C.party.header.template,
    L.C.party.header.visibility,
    "showPlayer", L.C.party.header.showPlayer,
    "showSolo",   L.C.party.header.showSolo,
    "showParty",  L.C.party.header.showParty,
    "showRaid",   L.C.party.header.showRaid,
    "point",      L.C.party.header.point,
    "xOffset",    L.C.party.header.xOffset,
    "yOffset",    L.C.party.header.yOffset,
    "oUF-initialConfigFunction", ([[
      self:SetWidth(%d)
      self:SetHeight(%d)
      self:GetParent():SetScale(%f)
    ]]):format(L.C.party.size[1], L.C.party.size[2], L.C.party.scale)
  ):SetPoint(unpack(L.C.party.point))

end

oUF:Factory(Factory)