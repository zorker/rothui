-------------------------------------------------
-- Variables
-------------------------------------------------
local A, L = ...

local mediaFolder = "Interface\\AddOns\\rOrb\\media\\"

L.orbLayouts = {}

L.orbLayouts["magenta-matrix"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {.6, 0, .6, 1},
  sparkColor = {.8, 0, .8, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 113764,
  camScale = 0.8
}

L.orbLayouts["deep-purple-starly"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {.6, 0, .6, 1},
  sparkColor = {.5, 0, 1, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 65947,
  camScale = 0.9
}

L.orbLayouts["chtun-eye"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {.6, 0.3, 0, 1},
  sparkColor = {.6, .3, 0, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 94285,
  camScale = 0.73
}

L.orbLayouts["magenta-swirly"] = {
  statusBarTexture = mediaFolder .. "orb_filling19",
  statusBarColor = {.6, 0, .6, 1},
  sparkColor = {.8, 0, .8, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 88991,
  camScale = 6
}

L.orbLayouts["azeroth"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {1, 1, 1, 1},
  sparkColor = {0.8, 1, 0.9, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 44652,
  camScale = 1,
  posAdjustY = -0.03
}

L.orbLayouts["deep-purple-magic"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {.1, 0.1, .5, 1},
  sparkColor = {0.2, 0.1, .8, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 80318,
  camScale = 0.8
}

L.orbLayouts["sandy-blitz"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {1, 0.6, .2, 1},
  sparkColor = {0.8, 0.5, .2, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 76935,
  camScale = 0.625,
  posAdjustZ = -0.18,
  panAdjustZ = 1.25
}

L.orbLayouts["aqua-swirl"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0.3, 0.4, .6, 1},
  sparkColor = {0.5, 0.8, 1, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 75294,
  camScale = 5,
  posAdjustZ = -1.5,
  panAdjustZ = 1.5
}

L.orbLayouts["green-buzz"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0.1, 0.6, 0, 1},
  sparkColor = {0.4, 1, 0, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 75298,
  camScale = .6,
  panAdjustX = 1.3,
  panAdjustZ = 1.55
}

L.orbLayouts["orange-marble"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0.7, 0.5, 0, 1},
  sparkColor = {1, 0.75, 0, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 74840,
  camScale = 1
}

L.orbLayouts["wierd-eye"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0.6, 0.1, 0.1, 1},
  sparkColor = {1, 0.4, 0.4, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 69879,
  camScale = 0.69,
  posAdjustZ = -6.9,
  panByPosAdjustZ = true
}

L.orbLayouts["dark-green-claw"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0.05, 0.3, 0, 1},
  sparkColor = {0, 1, 0, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 66808,
  panAdjustX = 0,
  panAdjustY = 0,
  panAdjustZ = 1,
  camScale = 1,
  posAdjustX = 0,
  posAdjustY = 0,
  posAdjustZ = 0
}

L.orbLayouts["pink-portal"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0.6, 0.3, 0.5, 1},
  sparkColor = {1, 0, .8, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 66092,
  panAdjustX = 0,
  panAdjustY = 0,
  panAdjustZ = 1,
  camScale = 1,
  posAdjustX = 0,
  posAdjustY = 0,
  posAdjustZ = 0
}

L.orbLayouts["green-portal"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0, 0.6, 0, 1},
  sparkColor = {0, 1, 0, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 66202,
  panAdjustX = 0,
  panAdjustY = 0,
  panAdjustZ = 1,
  camScale = 1,
  posAdjustX = 0,
  posAdjustY = 0,
  posAdjustZ = 0
}

L.orbLayouts["blue-portal"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0, 0.4, 0.6, 1},
  sparkColor = {0, .8, 1, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 64697,
  panAdjustX = 0,
  panAdjustY = 0,
  panAdjustZ = 1,
  camScale = 1,
  posAdjustX = 0,
  posAdjustY = 0,
  posAdjustZ = 0
}

L.orbLayouts["red-portal"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {1, 0.1, 0.1, 1},
  sparkColor = {1, 0, 0, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 64562,
  panAdjustX = 0,
  panAdjustY = 0,
  panAdjustZ = 1,
  camScale = 1,
  posAdjustX = 0,
  posAdjustY = 0,
  posAdjustZ = 0
}

L.orbLayouts["red-slob"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {1, 0.1, 0.1, 1},
  sparkColor = {1, 0, 0, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 60225,
  panAdjustX = 0,
  panAdjustY = 0,
  panAdjustZ = 1,
  camScale = 1,
  posAdjustX = 0,
  posAdjustY = 0,
  posAdjustZ = 0
}

L.orbLayouts["purple-portal"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0.6, 0, 0.6, 1},
  sparkColor = {.8, 0, 1, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 58948,
  panAdjustX = 0,
  panAdjustY = 0,
  panAdjustZ = 1,
  camScale = 1,
  posAdjustX = 0,
  posAdjustY = 0,
  posAdjustZ = 0
}

L.orbLayouts["red-orange-blob"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {1, 0.1, 0.1, 1},
  sparkColor = {1, 0, 0, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 56632,
  panAdjustX = 0,
  panAdjustY = 0,
  panAdjustZ = 1,
  camScale = 1,
  posAdjustX = 0,
  posAdjustY = 0,
  posAdjustZ = 0
}

L.orbLayouts["blue-purple-buzz"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0.6, 0, 0.6, 1},
  sparkColor = {.8, 0, 1, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 48109,
  panAdjustX = 0,
  panAdjustY = 0,
  panAdjustZ = 1,
  camScale = 1,
  posAdjustX = 0,
  posAdjustY = 0,
  posAdjustZ = 0
}

L.orbLayouts["purple-blob"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {1, 0.3, .5, 1},
  sparkColor = {1, 0.3, .5, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 48254,
  panAdjustX = 0,
  panAdjustY = 0,
  panAdjustZ = 1,
  camScale = 1,
  posAdjustX = 0,
  posAdjustY = 0,
  posAdjustZ = 0
}

L.orbLayouts["red-orange-wobbly"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {1, 0.1, 0.1, 1},
  sparkColor = {1, 0, 0, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 47882,
  panAdjustX = 0,
  panAdjustY = 0,
  panAdjustZ = 1,
  camScale = 1,
  posAdjustX = 0,
  posAdjustY = 0,
  posAdjustZ = 0
}

L.orbLayouts["white-cloud"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {.4, .4, .4, 1},
  sparkColor = {1, 1, 1, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 42938,
  panAdjustX = 0,
  panAdjustY = 0,
  panAdjustZ = 1,
  camScale = 1,
  posAdjustX = 0,
  posAdjustY = 0,
  posAdjustZ = 0
}

-- cool displainfo list for the factory

-- 113764
-- 94285
-- 88991
-- 65947
-- 83176
-- 82009
-- 81399
-- 81327
-- 81077
-- 80318
-- 76935
-- 75294
-- 75298
-- 74840
-- 69879
-- 66808
-- 66092
-- 66202
-- 64697
-- 64562
-- 60225
-- 58948
-- 56632
-- 48109
-- 48254
-- 47882
-- 44652
-- 42938
-- 39581
-- 39316
-- 34404
-- 33853
-- 32368
-- 29286
-- 29074
-- 28460
-- 27393
-- 18877
-- 100018
-- 93977
-- 91994
-- 38699
-- 120816
-- 118264
-- 109622
-- 108191
-- 108172
-- 107088
-- 106201
-- 101968
-- 101672
-- 101272
-- 100007
-- 98573
-- 97296
-- 95410
-- 95935
-- 92626
-- 92612
-- 92613
-- 92614
-- 90499
-- 89106
-- 84936
-- 70769
-- 57012
-- 56959
-- 55752
-- 48106

L.orbLayouts["purble-wobbly-xxx1"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {1, 0.3, .5, 1},
  sparkColor = {1, 0.3, .5, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 83176,
  panAdjustX = 2.4,
  panAdjustY = 0,
  panAdjustZ = 2.9,
  camScale = 1.18,
  posAdjustX = 0,
  posAdjustY = 0.02,
  posAdjustZ = -0.27
}

L.orbLayouts["red-slob-xxx1"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {.6, 0, 0, 1},
  sparkColor = {.8, 0, 0, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 82009,
  panAdjustX = 0,
  panAdjustY = 0,
  panAdjustZ = 1,
  camScale = 1,
  posAdjustX = 0,
  posAdjustY = 0,
  posAdjustZ = 0
}

L.orbLayouts["red-planet-xxx1"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {.6, 0, 0, 1},
  sparkColor = {.9, 0, 0, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = .5,
  displayInfoID = 81399,
  panAdjustX = 0,
  panAdjustY = 0,
  panAdjustZ = 1,
  camScale = 1,
  posAdjustX = 0,
  posAdjustY = 0,
  posAdjustZ = 0
}

L.orbLayouts["blue-planet-xxx1"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0, 0.6, 0.8, 1},
  sparkColor = {0, .8, 1, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = .5,
  displayInfoID = 81327,
  panAdjustX = 0,
  panAdjustY = 0,
  panAdjustZ = 1,
  camScale = 1,
  posAdjustX = 0,
  posAdjustY = 0,
  posAdjustZ = 0
}

L.orbLayouts["red-slob-xxx2"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {.6, 0, 0, 1},
  sparkColor = {.8, 0, 0, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 81077,
  panAdjustX = 0,
  panAdjustY = 0,
  panAdjustZ = 1,
  camScale = 1,
  posAdjustX = 0,
  posAdjustY = 0,
  posAdjustZ = 0
}
