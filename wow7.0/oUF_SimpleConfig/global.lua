
-- oUF_SimpleConfig: global
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Global Config
-----------------------------

--mediapath
L.C.mediapath = "interface\\addons\\"..A.."\\media\\"

L.C.uiscale = UIParent:GetScale()
print("Your UI scale: "..L.C.uiscale)

--backdrop
L.C.backdrop = {
  bgFile = L.C.mediapath.."backdrop",
  bgColor = {0,0,0,0.8},
  edgeFile = L.C.mediapath.."backdrop_edge",
  edgeColor = {0,0,0,0.8},
  tile = false,
  tileSize = 0,
  inset = 5*L.C.uiscale,
  edgeSize = 5*L.C.uiscale,
  insets = {
    left = 5*L.C.uiscale,
    right = 5*L.C.uiscale,
    top = 5*L.C.uiscale,
    bottom = 5*L.C.uiscale,
  },
}

--textures
L.C.textures = {
  statusbar = L.C.mediapath.."statusbar",
  statusbarBG = L.C.mediapath.."statusbar",
  absorb = L.C.mediapath.."absorb",
  aura = L.C.mediapath.."square",
}

--colors
L.C.colors = {}
--colors bgMultiplier
L.C.colors.bgMultiplier = 0.3
--colors castbar
L.C.colors.castbar = {
  default = {1,0.7,0},
  defaultBG = {1*L.C.colors.bgMultiplier,0.7*L.C.colors.bgMultiplier,0},
  shielded = {0.7,0.7,0.7},
  shieldedBG = {0.7*L.C.colors.bgMultiplier,0.7*L.C.colors.bgMultiplier,0.7*L.C.colors.bgMultiplier},
}
--colors healthbar
L.C.colors.healthbar = {
  threat = {1,0,0},
  threatBG = {1*L.C.colors.bgMultiplier,0,0},
  threatInvers = {0,1,0},
  threatInversBG = {0,1*L.C.colors.bgMultiplier,0},
  absorb = {0.1,1,1,0.7}
}
