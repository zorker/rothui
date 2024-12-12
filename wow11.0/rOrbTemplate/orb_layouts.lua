-------------------------------------------------
-- Variables
-------------------------------------------------
local A, L = ...

local mediaFolder = "Interface\\AddOns\\rOrbTemplate\\media\\"

L.orbLayouts = {}

L.orbLayouts["magenta-matrix"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {.6, 0, .6, 1},
  sparkColor = {.8, 0, .8, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 113764,
  camScale = 0.8
}

L.orbLayouts["deep-purple-starly"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {.6, 0, .6, 1},
  sparkColor = {.5, 0, 1, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 65947,
  camScale = 0.9
}

L.orbLayouts["art-chtun-eye"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {.6, 0.3, 0, 1},
  sparkColor = {0.7, .2, 0, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 94285,
  camScale = 0.73
}

L.orbLayouts["magenta-swirly"] = {
  statusBarTexture = mediaFolder .. "orb_filling21",
  statusBarColor = {.6, 0, .6, 1},
  sparkColor = {.8, 0, .8, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 88991,
  camScale = 6
}

L.orbLayouts["art-azeroth"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {1, 1, 1, 1},
  sparkColor = {0.8, 1, 0.9, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 44652,
  camScale = 1,
  posAdjustY = -0.03
}

L.orbLayouts["deep-purple-magic"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {.1, 0.1, .5, 1},
  sparkColor = {0.2, 0.1, .8, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 80318,
  camScale = 0.8
}

L.orbLayouts["sandy-blitz"] = {
  statusBarTexture = mediaFolder .. "orb_filling4",
  statusBarColor = {0.4, 0, .6, 1},
  sparkColor = {0.5, 0, 1, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 76935,
  camScale = 0.625,
  posAdjustZ = -0.18,
  panAdjustZ = 1.25
}

L.orbLayouts["blue-aqua-swirly"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0.2, 0, 1, 1},
  sparkColor = {0, 0.4, 1, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 75294,
  camScale = 5,
  posAdjustZ = -1.5,
  panAdjustZ = 1.5
}

L.orbLayouts["golden-marble"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0.7, 0.5, 0, 1},
  sparkColor = {1, 0.75, 0, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 74840,
  camScale = 1
}

L.orbLayouts["art-wierd-eye"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0.6, 0.1, 0.1, 1},
  sparkColor = {1, 0.4, 0.4, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 69879,
  camScale = 0.69,
  posAdjustZ = -6.9,
  panByPosAdjustZ = true
}

L.orbLayouts["pink-portal"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0.4, 0, 0.6, 1},
  sparkColor = {0.7, 0, 1, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 66092,
  camScale = 2.4,
  posAdjustZ = -1.05,
  panAdjustZ = 1.25
}

L.orbLayouts["green-portal"] = {
  statusBarTexture = mediaFolder .. "orb_filling10",
  statusBarColor = {0, 0.6, 0, 1},
  sparkColor = {0.8, 1, 0, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 66202,
  camScale = 2.4,
  posAdjustZ = -1.05,
  panAdjustZ = 1.25
}

L.orbLayouts["blue-portal"] = {
  statusBarTexture = mediaFolder .. "orb_filling6",
  statusBarColor = {0, 0.4, 0.6, 1},
  sparkColor = {0, .8, 1, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 64697,
  camScale = 2.4,
  posAdjustZ = -1.05,
  panAdjustZ = 1.25
}

L.orbLayouts["red-portal"] = {
  statusBarTexture = mediaFolder .. "orb_filling6",
  statusBarColor = {1, 0.1, 0.1, 1},
  sparkColor = {1, 0, 0, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 64562,
  camScale = 2.4,
  posAdjustZ = -1.05,
  panAdjustZ = 1.25
}

L.orbLayouts["purple-portal"] = {
  statusBarTexture = mediaFolder .. "orb_filling10",
  statusBarColor = {0.6, 0, 0.6, 1},
  sparkColor = {.8, 0, 1, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 58948,
  camScale = 2.1,
  posAdjustZ = -1.05,
  panAdjustZ = 1.25
}

L.orbLayouts["red-slob"] = {
  statusBarTexture = mediaFolder .. "orb_filling12",
  statusBarColor = {1, 0.1, 0.1, 1},
  sparkColor = {1, 0, 0, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 60225,
  camScale = 1.4
}

L.orbLayouts["green-buzz"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0.1, 0.6, 0, 1},
  sparkColor = {0.4, 1, 0, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 75298,
  camScale = .6,
  panAdjustX = 1.3,
  panAdjustZ = 1.55
}

L.orbLayouts["purple-buzz"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0.6, 0, 0.6, 1},
  sparkColor = {.8, 0, 1, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 48109,
  camScale = .6,
  panAdjustX = 1.3,
  panAdjustZ = 1.55
}

L.orbLayouts["blue-buzz"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0, 0, 0.6, 1},
  sparkColor = {0, 0, 1, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 48106,
  camScale = .6,
  panAdjustX = 1.3,
  panAdjustZ = 1.55
}

L.orbLayouts["white-cloud"] = {
  statusBarTexture = mediaFolder .. "orb_filling4",
  statusBarColor = {.4, .4, .4, 1},
  sparkColor = {1, 1, 1, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 42938,
  camScale = 3.5,
  posAdjustY = -0.2
}

L.orbLayouts["blue-magic-swirly"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0.3, 0.4, .6, 1},
  sparkColor = {0.5, 0.8, 1, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 39581,
  camScale = 4,
  posAdjustX = -5.5,
  panByPosAdjustZ = true
}

L.orbLayouts["green-beam"] = {
  statusBarTexture = mediaFolder .. "orb_filling10",
  statusBarColor = {0.3, 0.7, 0, 1},
  sparkColor = {0.8, 1, 0, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 0.8,
  displayInfoID = 39316,
  camScale = 4
}

L.orbLayouts["white-heal"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0.1, 0.1, 0.1, 1},
  sparkColor = {0.8, 1, 1, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 34404,
  camScale = 1
}

L.orbLayouts["red-heal"] = {
  statusBarTexture = mediaFolder .. "orb_filling1",
  statusBarColor = {0.6, 0.1, 0.1, 1},
  sparkColor = {1, 0, 0, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 33853,
  camScale = 1
}

L.orbLayouts["white-pearl"] = {
  statusBarTexture = mediaFolder .. "orb_filling15",
  statusBarColor = {1, 1, 1, 1},
  sparkColor = {1, 1, 1, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 32368,
  camScale = 0.9,
  panAdjustX = 1.5,
  panAdjustZ = 0.7
}

L.orbLayouts["white-swirly"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0.1, 0.1, 0.1, 1},
  sparkColor = {1, 1, 1, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 29286,
  camScale = 3.8,
  posAdjustZ = -1.5,
  panAdjustZ = 1.5
}

L.orbLayouts["purple-warlock-portal"] = {
  statusBarTexture = mediaFolder .. "orb_filling6",
  statusBarColor = {0.5, 0.5, 1, 1},
  sparkColor = {0.5, 0.5, 1, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 29074,
  camScale = 2.1,
  posAdjustZ = -1.05,
  panAdjustZ = 1.25
}

L.orbLayouts["purple-hole"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0.4, 0, 0.6, 1},
  sparkColor = {0.7, 0, 1, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 28460,
  camScale = 3.8,
  posAdjustZ = -1.7,
  panAdjustZ = 1.5
}

L.orbLayouts["blue-swirly"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0, 0, 0.4, 1},
  sparkColor = {0.2, 0.8, 1, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 27393,
  camScale = 4.5,
  posAdjustZ = -1.5,
  panAdjustZ = 1.5
}

L.orbLayouts["sand-storm"] = {
  statusBarTexture = mediaFolder .. "orb_filling6",
  statusBarColor = {0.6, 0.5, 0, 1},
  sparkColor = {1, 0.9, 0, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 18877,
  camScale = 2.7,
  posAdjustZ = -1.6,
  panAdjustZ = 1.5
}

L.orbLayouts["art-el-machina"] = {
  statusBarTexture = mediaFolder .. "orb_filling17",
  statusBarColor = {0.6, 0.3, 0, 1},
  sparkColor = {0.7, 0.3, 0, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 100018,
  camScale = 2.5
}

L.orbLayouts["red-blue-knot"] = {
  statusBarTexture = mediaFolder .. "orb_filling21",
  statusBarColor = {.7, 0, 0, 1},
  sparkColor = {1, 0.1, 0, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 93977,
  camScale = 2.2,
  posAdjustZ = -1.7,
  panAdjustZ = 2
}

L.orbLayouts["blue-ring-disco"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0, 0, 0.6, 1},
  sparkColor = {0, 0.1, 1, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 91994,
  camScale = .9
}

L.orbLayouts["art-dwarf-machina"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0.6, 0.2, 0, 1},
  sparkColor = {1, 0.5, 0, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 38699,
  camScale = 0.45
}

L.orbLayouts["circle-rune"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0.4, 0.2, .6, 1},
  sparkColor = {0.8, 0.5, 1, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 120816,
  camScale = .48
}

L.orbLayouts["purple-storm"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0.5, 0.15, 1, 1},
  sparkColor = {0.5, 0.15, 1, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 118264,
  camScale = 4.4
}

L.orbLayouts["white-boulder"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0.6, 0.6, 0.6, 1},
  sparkColor = {1, 1, 1, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 0.7,
  displayInfoID = 109622,
  camScale = 1.05,
  posAdjustZ = -0.5,
  panAdjustZ = 1.5
}

L.orbLayouts["white-snowstorm"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0.6, 0.6, 0.6, 1},
  sparkColor = {1, 1, 1, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 108191,
  camScale = 1.1
}

L.orbLayouts["fire-dot"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0.6, 0.2, 0, 1},
  sparkColor = {1, 0.5, 0, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 108172,
  camScale = 1,
  posAdjustZ = -1.5,
  panAdjustZ = 1.5
}

L.orbLayouts["purple-discoball"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0.6, 0, 0.6, 1},
  sparkColor = {.8, 0, 1, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 107088,
  camScale = 10.6
}

L.orbLayouts["white-tornado"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0.1, 0.1, 0.1, 1},
  sparkColor = {.5, 1, 1, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 106201,
  camScale = 7,
  posAdjustZ = -6
}

L.orbLayouts["white-snowglobe"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0.5, 0.5, 0.5, 1},
  sparkColor = {1, 1, 1, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 101968,
  camScale = 1
}

L.orbLayouts["white-zebra"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0.5, 0.5, 0.5, 1},
  sparkColor = {1, 1, 1, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 101272,
  camScale = 1,
  posAdjustZ = -0.1
}

L.orbLayouts["white-spark"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0, 0, 0, 1},
  sparkColor = {1, 1, 1, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 100007,
  camScale = 1
}

L.orbLayouts["blue-aqua-spark"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0, 0.1, 0.2, 1},
  sparkColor = {0.3, 0.9, 1, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 98573,
  camScale = 1
}

L.orbLayouts["purple-growup"] = {
  statusBarTexture = mediaFolder .. "orb_filling6",
  statusBarColor = {0.5, 0.2, 0.6, 1},
  sparkColor = {.8, 0.3, 1, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 95410,
  camScale = 7
}

L.orbLayouts["blue-aqua-sink"] = {
  statusBarTexture = mediaFolder .. "orb_filling15",
  statusBarColor = {0, 0.1, 0.2, 1},
  sparkColor = {0.3, 0.9, 1, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 95935,
  camScale = 6
}

L.orbLayouts["pink-portal-swirl"] = {
  statusBarTexture = mediaFolder .. "orb_filling21",
  statusBarColor = {0.3, 0.1, 0.6, 1},
  sparkColor = {1, 0.4, 1, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 92626,
  camScale = 2,
  posAdjustZ = -1.15,
  panAdjustZ = 1.5
}

L.orbLayouts["purple-earth"] = {
  statusBarTexture = mediaFolder .. "orb_filling21",
  statusBarColor = {0.3, 0.1, 0.6, 1},
  sparkColor = {1, 0.4, 1, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 0.8,
  displayInfoID = 92612,
  camScale = 1.05,
  posAdjustZ = -0.06
}

L.orbLayouts["golden-earth"] = {
  statusBarTexture = mediaFolder .. "orb_filling21",
  statusBarColor = {0.7, 0.5, 0, 1},
  sparkColor = {1, 0.75, 0, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 0.8,
  displayInfoID = 92613,
  camScale = 1.05,
  posAdjustZ = -0.06
}

L.orbLayouts["green-earth"] = {
  statusBarTexture = mediaFolder .. "orb_filling21",
  statusBarColor = {0.3, 0.7, 0, 1},
  sparkColor = {0.8, 1, 0, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 0.8,
  displayInfoID = 92614,
  camScale = 1.05,
  posAdjustZ = -0.06
}

L.orbLayouts["pink-earth"] = {
  statusBarTexture = mediaFolder .. "orb_filling21",
  statusBarColor = {0.3, 0.1, 0.6, 1},
  sparkColor = {1, 0.4, 1, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 0.8,
  displayInfoID = 90499,
  camScale = 1.05,
  posAdjustZ = -0.06
}

L.orbLayouts["golden-tornado"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0.6, 0.2, 0, 1},
  sparkColor = {1, 0.5, 0, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 89106,
  camScale = 4.5,
  rotation = 1.9,
  posAdjustY = 0.8,
  posAdjustZ = -1.6,
  panAdjustY = 1.5,
  panAdjustZ = 1.5
}

L.orbLayouts["blue-electric"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0.4, 1, 1, 1},
  sparkColor = {0.4, 1, 1, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 90127,
  camScale = 0.7
}

L.orbLayouts["blue-splash"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0.3, 0.5, .8, 1},
  sparkColor = {0.3, 0.5, 1, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 84936,
  camScale = 0.6
}

L.orbLayouts["art-elvish-object"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0.3, 0.5, .8, 1},
  sparkColor = {0.3, 0.5, 1, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 70769,
  camScale = 0.41,
  adjustRotationByValue = true
}

L.orbLayouts["blue-magic-tornado"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0.2, 0, 1, 1},
  sparkColor = {0, 0.4, 1, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 56959,
  camScale = 4,
  posAdjustZ = -0.5,
  posAdjustY = 0.25,
  panAdjustY = -0.5,
  panAdjustZ = -1
}

-----------------------------------------------------------
-- 501
-- the following templates work but would need adjustments if the base frame changes scale
-----------------------------------------------------------

L.orbLayouts["501-red-orange-wobbler"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {1, 0.1, 0.1, 1},
  sparkColor = {1, 0, 0, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 56632,
  camScale = 0.6,
  posAdjustY = -0.1,
  posAdjustZ = -0.6
}

L.orbLayouts["501-red-planet"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {.6, 0, 0, 1},
  sparkColor = {.9, 0, 0, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = .5,
  displayInfoID = 81399,
  camScale = 2,
  posAdjustZ = 0.3
}

L.orbLayouts["501-blue-planet"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {.6, 0, 0, 1},
  sparkColor = {.9, 0, 0, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = .5,
  displayInfoID = 81327,
  camScale = 2,
  posAdjustZ = 0.3
}

L.orbLayouts["501-purple-wobbler"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {1, 0.3, .5, 1},
  sparkColor = {1, 0.3, .5, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 83176,
  camScale = 1.2,
  posAdjustY = 0.05,
  posAdjustZ = -0.2
}

L.orbLayouts["501-red-wobbler"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {.6, 0, 0, 1},
  sparkColor = {.8, 0, 0, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 82009,
  camScale = 0.45,
  posAdjustZ = -2.25
}

L.orbLayouts["501-snow-flake"] = {
  statusBarTexture = mediaFolder .. "orb_filling16",
  statusBarColor = {0.5, 0.6, 0.6, 1},
  sparkColor = {0.6, 1, 1, 1},
  glowColor = {0, 1, 0, 0},
  modelOpacity = 1,
  displayInfoID = 55752,
  camScale = 0.65,
  posAdjustZ = -0.15
}