
-- oUF_OrbsConfig: nameplate
-- zork, 2018

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- NamePlateCVars
-----------------------------

local cvars = {
  nameplateMinScale         = 1,
  nameplateMaxScale         = 1,
  nameplateMinScaleDistance = 0,
  nameplateMaxScaleDistance = 40,
  nameplateGlobalScale      = 1,
  NamePlateHorizontalScale  = 1,
  NamePlateVerticalScale    = 1,
  nameplateSelfScale        = 1,
  nameplateSelectedScale    = 1,
  nameplateLargerScale      = 1.2,
  nameplateShowFriendlyNPCs = 1,
  nameplateMinAlpha         = 0.5,
  nameplateMaxAlpha         = 0.5,
  nameplateMinAlphaDistance = 0,
  nameplateMaxAlphaDistance = 40,
  nameplateSelectedAlpha    = 1
}

L.C.NamePlateCVars = cvars

-----------------------------
-- Nameplate Config
-----------------------------

L.C.nameplate = {
  enabled = true,
  point = {"CENTER"},
  scale = 0.65*UIParent:GetScale()*L.C.scale,
  --healthbar
  healthbar = {
    colorTapping = true,
    colorReaction = true,
    colorClass = true,
    colorHealth = true,
    colorThreat = true,
    colorThreatInvers = true,
    frequentUpdates = true,
  },
  --castbar
  castbar = {
    enabled = true,
    clockwise = true,
    segment = "ring_top",
    icon = {
      enabled = true,
      size = 80,
    },
  },
}