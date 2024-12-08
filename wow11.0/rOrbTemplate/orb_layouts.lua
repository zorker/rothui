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
  panAdjustY = 145,
  camScale = 1,
  posAdjustX = 0,
  posAdjustY = 0,
  posAdjustZ = 0
}

L.orbLayouts["chtun-eye"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {.6, 0.3, 0, 1},
  sparkColor = {.6, .3, 0, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 94285,
  panAdjustY = 150,
  camScale = 1.3,
  posAdjustX = 0,
  posAdjustY = 0,
  posAdjustZ = 0
}

L.orbLayouts["magenta-swirly"] = {
  statusBarTexture = mediaFolder .. "orb_filling19",
  statusBarColor = {.6, 0, .6, 1},
  sparkColor = {.8, 0, .8, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 88991,
  panAdjustY = 19,
  camScale = 0.055,
  posAdjustX = 0.1,
  posAdjustY = 0,
  posAdjustZ = -0.1
}

L.orbLayouts["deep-purple-starly"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {.6, 0, .6, 1},
  sparkColor = {.5, 0, 1, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 65947,
  panAdjustY = 126,
  camScale = 0.75,
  posAdjustX = 0,
  posAdjustY = 0,
  posAdjustZ = -0.05
}

L.orbLayouts["purble-wobbly"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {1, 0.3, .5, 1},
  sparkColor = {1, 0.3, .5, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 83176,
  panAdjustY = 82,
  camScale = 0.25,
  posAdjustX = 0.83,
  posAdjustY = 0.15,
  posAdjustZ = 0
}

L.orbLayouts["red-slob-x1"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {.6, 0, 0, 1},
  sparkColor = {.8, 0, 0, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 82009,
  panAdjustY = 82,
  camScale = 1.2,
  posAdjustX = 0,
  posAdjustY = 0,
  posAdjustZ = -2.3
}

L.orbLayouts["red-planet"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {.6, 0, 0, 1},
  sparkColor = {.9, 0, 0, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = .5,
  displayInfoID = 81399,
  panAdjustY = 60,
  camScale = .175,
  posAdjustX = 0,
  posAdjustY = 0,
  posAdjustZ = .8
}

L.orbLayouts["blue-planet"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0, 0.6, 0.8, 1},
  sparkColor = {0, .8, 1, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = .5,
  displayInfoID = 81327,
  panAdjustY = 60,
  camScale = .175,
  posAdjustX = 0,
  posAdjustY = 0,
  posAdjustZ = .8
}

L.orbLayouts["red-slob-x2"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {.6, 0, 0, 1},
  sparkColor = {.8, 0, 0, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 81077,
  panAdjustY = 60,
  camScale = 1,
  posAdjustX = 1,
  posAdjustY = 0,
  posAdjustZ = -1.8
}

L.orbLayouts["deep-purple-magic"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {.1, 0.1, .5, 1},
  sparkColor = {0.2, 0.1, .8, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 80318,
  panAdjustY = 149,
  camScale = 1.3,
  posAdjustX = 0,
  posAdjustY = 0,
  posAdjustZ = 0
}

L.orbLayouts["sandy-blitz"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {1, 0.6, .2, 1},
  sparkColor = {0.8, 0.5, .2, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 76935,
  panAdjustY = 185,
  camScale = 3,
  posAdjustX = 0,
  posAdjustY = 0,
  posAdjustZ = -0.7
}

L.orbLayouts["aqua-swirl"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0.3, 0.4, .6, 1},
  sparkColor = {0.5, 0.8, 1, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 75294,
  panAdjustY = 25,
  camScale = 0.06,
  posAdjustX = 0,
  posAdjustY = -0.025,
  posAdjustZ = 1.1
}

L.orbLayouts["green-buzz"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0.1, 0.6, 0, 1},
  sparkColor = {0.4, 1, 0, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 75298,
  panAdjustY = 56.5,
  camScale = 1,
  posAdjustX = 0,
  posAdjustY = 0,
  posAdjustZ = -0.025
}

L.orbLayouts["orange-marble"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0.7, 0.5, 0, 1},
  sparkColor = {1, 0.75, 0, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 74840,
  panAdjustY = 120,
  camScale = 0.65,
  posAdjustX = 0,
  posAdjustY = -0.05,
  posAdjustZ = 0.3
}

L.orbLayouts["wierd-eye"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0.6, 0.1, 0.1, 1},
  sparkColor = {1, 0.4, 0.4, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 69879,
  panAdjustY = 8.5,
  camScale = .82,
  posAdjustX = 0,
  posAdjustY = 0,
  posAdjustZ = -1.7
}

L.orbLayouts["dark-green-claw"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0.05, 0.3, 0, 1},
  sparkColor = {0, 1, 0, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 66808,
  panAdjustY = 60,
  camScale = 0.16,
  posAdjustX = 0,
  posAdjustY = -0.025,
  posAdjustZ = 0.81
}

L.orbLayouts["pink-portal"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0.6, 0.3, 0.5, 1},
  sparkColor = {1, 0, .8, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 66092,
  panAdjustY = 50,
  camScale = .14,
  posAdjustX = 0,
  posAdjustY = 0,
  posAdjustZ = .67
}

L.orbLayouts["green-portal"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0, 0.6, 0, 1},
  sparkColor = {0, 1, 0, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 66202,
  panAdjustY = 50,
  camScale = .14,
  posAdjustX = 0,
  posAdjustY = 0,
  posAdjustZ = .67
}

L.orbLayouts["blue-portal"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0, 0.4, 0.6, 1},
  sparkColor = {0, .8, 1, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 64697,
  panAdjustY = 50,
  camScale = .14,
  posAdjustX = 0,
  posAdjustY = 0,
  posAdjustZ = .67
}

L.orbLayouts["red-portal"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {1, 0.1, 0.1, 1},
  sparkColor = {1, 0, 0, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 64562,
  panAdjustY = 50,
  camScale = .14,
  posAdjustX = 0,
  posAdjustY = 0,
  posAdjustZ = .67
}

L.orbLayouts["red-slob"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {1, 0.1, 0.1, 1},
  sparkColor = {1, 0, 0, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 60225,
  panAdjustY = 86,
  camScale = .32,
  posAdjustX = 0,
  posAdjustY = 0.1,
  posAdjustZ = 0.1
}

L.orbLayouts["purple-portal"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0.6, 0, 0.6, 1},
  sparkColor = {.8, 0, 1, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 58948,
  panAdjustY = 60,
  camScale = .18,
  posAdjustX = 0,
  posAdjustY = 0,
  posAdjustZ = .585
}

L.orbLayouts["red-orange-blob"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {1, 0.1, 0.1, 1},
  sparkColor = {1, 0, 0, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 56632,
  panAdjustY = 172,
  camScale = 4,
  posAdjustX = 0,
  posAdjustY = -0.525,
  posAdjustZ = -5.4
}

L.orbLayouts["blue-purple-buzz"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0.6, 0, 0.6, 1},
  sparkColor = {.8, 0, 1, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 48109,
  panAdjustY = 56.5,
  camScale = 1,
  posAdjustX = 0,
  posAdjustY = 0,
  posAdjustZ = -0.025
}

L.orbLayouts["purple-blob"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {1, 0.3, .5, 1},
  sparkColor = {1, 0.3, .5, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 48254,
  panAdjustY = 87,
  camScale = .9,
  posAdjustX = 0,
  posAdjustY = -0.025,
  posAdjustZ = -1.62
}

L.orbLayouts["red-orange-wobbly"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {1, 0.1, 0.1, 1},
  sparkColor = {1, 0, 0, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 47882,
  panAdjustY = 88,
  camScale = .9,
  posAdjustX = 0,
  posAdjustY = -0.025,
  posAdjustZ = -1.62
}

L.orbLayouts["azeroth"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {1, 1, 1, 1},
  sparkColor = {0.8, 1, 0.9, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 44652,
  panAdjustY = 110,
  camScale = .54,
  posAdjustX = 0,
  posAdjustY = 0.01,
  posAdjustZ = -0.01
}

L.orbLayouts["white-cloud"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {.4, .4, .4, 1},
  sparkColor = {1, 1, 1, 1},
  glowColor = {0, 1, 0, 0}, -- for low hp or debuffs etc
  modelOpacity = 1,
  displayInfoID = 42938,
  panAdjustY = 33,
  camScale = 0.085,
  posAdjustX = 0,
  posAdjustY = .15,
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
