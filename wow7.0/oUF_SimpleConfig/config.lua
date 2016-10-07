
-- oUF_SimpleConfig: config
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

--configs container
L.C = {}
--units container
L.C.units = {}

local B = "oUF_Simple" --name of the addon that is creating all the frames

--make the config global
oUF_SimpleConfig = L.C

-----------------------------
-- Config
-----------------------------

--mediapath
L.C.mediapath = "interface\\addons\\"..A.."\\media\\"

--backdrop
L.C.backdrop = {
  bgFile = L.C.mediapath.."backdrop",
  bgColor = {0,0,0,0.8},
  edgeFile = L.C.mediapath.."backdrop_edge",
  edgeColor = {0,0,0,0.8},
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

--castbar
L.C.castbar = {
  colors = {
    default = {1,0.7,0},
    defaultBG = {1*0.3,0.7*0.3,0},
    shielded = {0.7,0.7,0.7},
    shieldedBG = {0.7*0.3,0.7*0.3,0.7*0.3},
  },
}

--player
L.C.units.player = {
  enabled = true,
  styleName = B.."PlayerStyle",
  frameName = B.."PlayerFrame",
  size = {225,22},
  point = {"RIGHT",UIParent,"BOTTOM",-100,350},
  scale = 1,
  castbar = {
    showIcon = true,
  },
}

--target
L.C.units.target = {
  enabled = true,
  styleName = B.."TargetStyle",
  frameName = B.."TargetFrame",
  size = {225,22},
  point = {"LEFT",UIParent,"BOTTOM",100,350},
  scale = 1,
  buffCfg = {
    point = {"BOTTOMLEFT",B.."TargetFrame","RIGHT",10,5},
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
    point = {"TOPLEFT",B.."TargetFrame","RIGHT",10,-5},
    num = 40,
    cols = 8,
    size = 20,
    spacing = 5,
    initialAnchor = "TOPLEFT",
    growthX = "RIGHT",
    growthY = "DOWN",
    disableCooldown = true,
  },
  castbar = {
    showIcon = true,
  },
}

--targettarget
L.C.units.targettarget = {
  enabled = true,
  styleName = B.."TargetTargetStyle",
  frameName = B.."TargetTargetFrame",
  size = {110,22},
  point = {"TOPLEFT",B.."TargetFrame","BOTTOMLEFT",0,-15},
  scale = 1,
  debuffCfg = {
    point = {"TOPLEFT",B.."TargetTargetFrame","BOTTOMLEFT",0,-5},
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
  styleName = B.."PetStyle",
  frameName = B.."PetFrame",
  size = {110,22},
  point = {"TOPLEFT",B.."PlayerFrame","BOTTOMLEFT",0,-15},
  scale = 1,
  debuffCfg = {
    point = {"TOPLEFT",B.."PetFrame","BOTTOMLEFT",0,-5},
    num = 5,
    cols = 5,
    size = 18,
    spacing = 5,
    initialAnchor = "TOPLEFT",
    growthX = "RIGHT",
    growthY = "DOWN",
    disableCooldown = true,
  },
  castbar = {
    showIcon = true,
  },
}

--focus
L.C.units.focus = {
  enabled = true,
  styleName = B.."FocusStyle",
  frameName = B.."FocusFrame",
  size = {110,22},
  point = {"TOPRIGHT",B.."PlayerFrame","BOTTOMRIGHT",0,-15},
  scale = 1,
  debuffCfg = {
    point = {"TOPLEFT",B.."FocusFrame","BOTTOMLEFT",0,-5},
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
  styleName = B.."PartyStyle",
  frameName = B.."PartyHeaderFrame",
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
  enabled = true,
  styleName = B.."BossStyle",
  framePrefix = A, --will be substituted with BossFrame1..n
  size = {110,22},
  point = {"TOP",Minimap,"BOTTOM",0,-30}, --point of first boss frame
  scale = 1,
  debuffCfg = {
    point = {"TOPLEFT",0,-32}, --this may seem wierd but party frames are generated on the fly, no other way
    num = 5,
    cols = 5,
    size = 18,
    spacing = 5,
    initialAnchor = "TOPLEFT",
    growthX = "RIGHT",
    growthY = "DOWN",
    disableCooldown = true,
  },
  setup = {
    point = "TOP",
    relativePoint = "BOTTOM", --relativeTo will be the boss frame preceding
    xOffset = 0,
    yOffset = -45,
  },
  castbar = {
    showIcon = true,
  },
}

--nameplate CVARS

local function SetNamePlateCVARS()
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
  --[[
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
  ]]
end
rLib:RegisterCallback("PLAYER_LOGIN",SetNamePlateCVARS)

--nameplates
L.C.units.nameplates = {
  enabled = true,
  styleName = B.."NamePlateStyle",
  framePrefix = A, --will be substituted with NamePlate1..n
  size = {110,22},
  point = {"CENTER"}, --relative to the nameplate base!
  scale = 1*UIParent:GetScale(), --nameplates are not part of uiparent!
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
  castbar = {
    showIcon = true,
  },
}