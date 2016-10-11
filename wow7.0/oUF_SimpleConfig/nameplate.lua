
-- oUF_SimpleConfig: nameplate
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- NamePlateConfig
-----------------------------

--custom filter for nameplate debuffs
local function CustomFilter(...)
  local _, _, _, name, _, _, _, _, _, _, caster, _, nameplateShowPersonal, _, _, _, _, nameplateShowAll = ...
  return nameplateShowAll or (nameplateShowPersonal and (caster == "player" or caster == "pet" or caster == "vehicle"))
end

L.C.nameplate = {
  enabled = true,
  size = {130*L.C.uiscale,26*L.C.uiscale},
  point = {"CENTER"}, --relative to the nameplate base!
  scale = 1*L.C.uiscale,--nameplates are not part of uiparent!
  --healthbar
  healthbar = {
    --health and absorb bar cannot be disabled, they match the size of the frame
    colorTapping = true,
    colorReaction = true,
    colorClass = true,
    colorHealth = true,
    colorThreat = true,
    colorThreatInvers = true,
    frequentUpdates = true,
    name = {
      enabled = true,
      points = {
        {"LEFT",2*L.C.uiscale,0*L.C.uiscale},
        {"RIGHT",-2*L.C.uiscale,0*L.C.uiscale},
      },
      size = 16*L.C.uiscale,
      align = "CENTER",
      tag = "[difficulty][name]|r",
    },
  },
  --raidmark
  raidmark = {
    enabled = true,
    size = {18*L.C.uiscale,18*L.C.uiscale},
    point = {"CENTER","TOP",0,0},
  },
  --castbar
  castbar = {
    enabled = true,
    size = {130*L.C.uiscale,26*L.C.uiscale},
    point = {"TOP","BOTTOM",0*L.C.uiscale,-5*L.C.uiscale},
    name = {
      enabled = true,
      points = {
        {"LEFT",2*L.C.uiscale,0*L.C.uiscale},
        {"RIGHT",-2*L.C.uiscale,0*L.C.uiscale},
      },
      size = 16*L.C.uiscale,
    },
    icon = {
      enabled = true,
      size = {26*L.C.uiscale,26*L.C.uiscale},
      point = {"RIGHT","LEFT",-6*L.C.uiscale,0*L.C.uiscale},
    },
  },
  --debuffs
  debuffs = {
    enabled = true,
    point = {"BOTTOMLEFT","TOPLEFT",0*L.C.uiscale,5*L.C.uiscale},
    num = 5,
    cols = 5,
    size = 22*L.C.uiscale,
    spacing = 5*L.C.uiscale,
    initialAnchor = "TOPLEFT",
    growthX = "RIGHT",
    growthY = "UP",
    disableCooldown = true,
    filter = "HARMFUL|INCLUDE_NAME_PLATE_ONLY",
    CustomFilter = CustomFilter
  },
}