
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
    point = {"LEFT",10+150,0}, --this may seem wierd but party frames are generated on the fly, no other way
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

--nameplate CVARS

local function PrintNamePlateCVARS()
  SetCVar("nameplateShowAll", 1)
  SetCVar("nameplateMaxAlpha", 0.5)
  SetCVar("nameplateShowEnemies", 1)
  SetCVar("ShowClassColorInNameplate", 1)
  SetCVar("nameplateOtherTopInset", 0.08)
  SetCVar("nameplateOtherBottomInset", -1)
  SetCVar("nameplateMinScale", 1)
  SetCVar("namePlateMaxScale", 1)
  SetCVar("nameplateMinScaleDistance", 10)
  SetCVar("nameplateMaxDistance", 40)
  SetCVar("NamePlateHorizontalScale", 1)
  SetCVar("NamePlateVerticalScale", 1)
  print('--------------------------------------')
  print(A..' nameplate CVAR settings')
  print('--------------------------------------')
  print('nameplateShowAll', 'default', GetCVarDefault("nameplateShowAll"), 'saved', GetCVar("nameplateShowAll"))
  print("nameplateMaxAlpha", 'default', GetCVarDefault("nameplateMaxAlpha"), 'saved', GetCVar("nameplateMaxAlpha"))
  print("nameplateShowEnemies", 'default', GetCVarDefault("nameplateShowEnemies"), 'saved', GetCVar("nameplateShowEnemies"))
  print("ShowClassColorInNameplate", 'default', GetCVarDefault("ShowClassColorInNameplate"), 'saved', GetCVar("ShowClassColorInNameplate"))
  print("nameplateOtherTopInset", 'default', GetCVarDefault("nameplateOtherTopInset"), 'saved', GetCVar("nameplateOtherTopInset"))
  print("nameplateOtherBottomInset", 'default', GetCVarDefault("nameplateOtherBottomInset"), 'saved', GetCVar("nameplateOtherBottomInset"))
  print("nameplateMinScale", 'default', GetCVarDefault("nameplateMinScale"), 'saved', GetCVar("nameplateMinScale"))
  print("namePlateMaxScale", 'default', GetCVarDefault("namePlateMaxScale"), 'saved', GetCVar("namePlateMaxScale"))
  print("nameplateMinScaleDistance", 'default', GetCVarDefault("nameplateMinScaleDistance"), 'saved', GetCVar("nameplateMinScaleDistance"))
  print("nameplateMaxDistance", 'default', GetCVarDefault("nameplateMaxDistance"), 'saved', GetCVar("nameplateMaxDistance"))
  print("NamePlateHorizontalScale", 'default', GetCVarDefault("NamePlateHorizontalScale"), 'saved', GetCVar("NamePlateHorizontalScale"))
  print("NamePlateVerticalScale", 'default', GetCVarDefault("NamePlateVerticalScale"), 'saved', GetCVar("NamePlateVerticalScale"))
end
rLib:RegisterCallback("PLAYER_LOGIN",PrintNamePlateCVARS)

--nameplates
L.C.units.nameplates = {
  enabled = true,
  styleName = A.."NamePlateStyle",
  framePrefix = A, --will be substituted with NamePlate1..n
  size = {110,22},
  point = {"CENTER"}, --relative to the nameplate base!
  scale = 1*GetCVar("uiscale"), --nameplates are not part of uiparent!
  debuffCfg = {
    point = {"BOTTOMLEFT",0,5+22}, --this may seem wierd but nameplate frames are generated on the fly, no other way
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