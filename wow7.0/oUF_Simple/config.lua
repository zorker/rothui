
-- oUF_Simple: config
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...
local oUF = L.oUF

--configs container
L.C = {}

-----------------------------
-- Config
-----------------------------

L.C.mediapath = "interface\\addons\\"..A.."\\media\\"

L.C.backdrop = {
  bgFile = L.C.mediapath.."backdrop",
  edgeFile = L.C.mediapath.."backdrop_edge",
  tile = false,
  tileSize = 0,
  inset = 4,
  edgeSize = 4,
  insets = {
    left = 4,
    right = 4,
    top = 4,
    bottom = 4,
  },
}

L.C.units = {}

--player
L.C.units.player = {
  enabled = true,
  styleName = A.."PlayerStyle",
  frameName = A.."PlayerFrame",
  size = {225,22},
  point = {"RIGHT",UIParent,"BOTTOM",-100,350},
  scale = 1,
}

--target
L.C.units.target = {
  enabled = true,
  styleName = A.."TargetStyle",
  frameName = A.."TargetFrame",
  size = {225,22},
  point = {"LEFT",UIParent,"BOTTOM",100,350},
  scale = 1,
  buffCfg = {
    point = {"BOTTOMLEFT",A.."TargetFrame","RIGHT",10,5},
    num = 32,
    cols = 8,
    size = 20,
    spacing = 5,
    initialAnchor = "BOTTOMLEFT",
    growthX = "RIGHT",
    growthY = "UP",
    disableCooldown = true,
  },
  debuffCfg = {
    point = {"TOPLEFT",A.."TargetFrame","RIGHT",10,-5},
    num = 40,
    cols = 8,
    size = 20,
    spacing = 5,
    initialAnchor = "TOPLEFT",
    growthX = "RIGHT",
    growthY = "DOWN",
    disableCooldown = true,
  },
}

--targettarget
L.C.units.targettarget = {
  enabled = true,
  styleName = A.."TargetTargetStyle",
  frameName = A.."TargetTargetFrame",
  size = {110,22},
  point = {"TOPLEFT",A.."TargetFrame","BOTTOMLEFT",0,-15},
  scale = 1,
  debuffCfg = {
    point = {"TOPLEFT",A.."TargetTargetFrame","BOTTOMLEFT",0,-5},
    num = 5,
    cols = 5,
    size = 18,
    spacing = 5,
    initialAnchor = "TOPLEFT",
    growthX = "RIGHT",
    growthY = "DOWN",
    disableCooldown = true,
  },
}

--pet
L.C.units.pet = {
  enabled = true,
  styleName = A.."PetStyle",
  frameName = A.."PetFrame",
  size = {110,22},
  point = {"TOPLEFT",A.."PlayerFrame","BOTTOMLEFT",0,-15},
  scale = 1,
  debuffCfg = {
    point = {"TOPLEFT",A.."PetFrame","BOTTOMLEFT",0,-5},
    num = 5,
    cols = 5,
    size = 18,
    spacing = 5,
    initialAnchor = "TOPLEFT",
    growthX = "RIGHT",
    growthY = "DOWN",
    disableCooldown = true,
  },
}

--focus
L.C.units.focus = {
  enabled = true,
  styleName = A.."FocusStyle",
  frameName = A.."FocusFrame",
  size = {110,22},
  point = {"TOPRIGHT",A.."PlayerFrame","BOTTOMRIGHT",0,-15},
  scale = 1,
  debuffCfg = {
    point = {"TOPLEFT",A.."FocusFrame","BOTTOMLEFT",0,-5},
    num = 5,
    cols = 5,
    size = 18,
    spacing = 5,
    initialAnchor = "TOPLEFT",
    growthX = "RIGHT",
    growthY = "DOWN",
    disableCooldown = true,
  },
}

--party
L.C.units.party = {
  enabled = true,
  styleName = A.."PartyStyle",
  frameName = A.."PartyHeaderFrame",
  size = {150,22},
  point = {"TOPLEFT",20,-20}, --party header parent is UIParent
  scale = 1,
  debuffCfg = {
    point = {"LEFT",self,"RIGHT",10,0},
    num = 5,
    cols = 5,
    size = 22,
    spacing = 5,
    initialAnchor = "TOPLEFT",
    growthX = "RIGHT",
    growthY = "DOWN",
    disableCooldown = true,
  },
  setup = {
    template = nil,
    visibility = "custom [group:party,nogroup:raid] show; hide",
    showPlayer = true,
    showSolo = false,
    showParty = true,
    showRaid = false,
    point = "BOTTOM",
    xOffset = 0,
    yOffset = 15,
  },
}

--boss
L.C.units.boss = {
  enabled = false,
}

--nameplates
L.C.units.nameplates = {
  enabled = true,
  styleName = A.."NamePlateStyle",
  framePrefix = A, --will be substituted with NamePlate1..n
  size = {110,22},
  point = {"CENTER"}, --relative to the nameplate base!
  scale = 1*GetCVar("uiscale"), --nameplates are not part of uiparent!
  debuffCfg = {
    point = {"BOTTOMLEFT",self,"TOPLEFT",0,5},
    num = 5,
    cols = 5,
    size = 18,
    spacing = 5,
    initialAnchor = "BOTTOMLEFT",
    growthX = "RIGHT",
    growthY = "UP",
    disableCooldown = true,
    filter = "HARMFUL|INCLUDE_NAME_PLATE_ONLY"
  },
}