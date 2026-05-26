local A, L = ...

-- LoadDBDefaults
local function LoadDBDefaults()
  return {
    mediaFolder = L.mediaFolder,
    settings = {
      modelID = 2030216,
      scaleValue = 1,
      fillValue = 1,
      modelAlpha = 1,
      splitAlpha = 1,
      fillTexture = "orb_filling16",
      fillColor = "ff0000ff",
      showLowHealth = false,
      showDebuffGlow = false,
    },
    presetTemplates = {
      ["_OTHER"] = {
      ["modelID"] = 4544400,
      ["modelAlpha"] = 1,
      ["splitAlpha"] = 1,
      ["fillColor"] = "ffd74200",
      ["fillTexture"] = "orb_filling16",
      },
      ["_CLASS_WARRIOR"] = {
      ["modelID"] = 524767,
      ["modelAlpha"] = 1,
      ["splitAlpha"] = 1,
      ["fillColor"] = "ffa73300",
      ["fillTexture"] = "orb_filling15",
      },
      ["_CLASS_MAGE"] = {
      ["modelID"] = 3579915,
      ["modelAlpha"] = 1,
      ["splitAlpha"] = 1,
      ["fillTexture"] = "orb_filling15",
      ["fillColor"] = "ff00deff",
      },
      ["_POWER_MANA"] = {
      ["modelID"] = 234780,
      ["modelAlpha"] = 1,
      ["splitAlpha"] = 1,
      ["fillTexture"] = "orb_filling15",
      ["fillColor"] = "ff0900da",
      },
      ["_REACTION_HOSTILE"] = {
      ["modelID"] = 450902,
      ["modelAlpha"] = 1,
      ["splitAlpha"] = 1,
      ["fillColor"] = "ffa50000",
      ["fillTexture"] = "orb_filling16",
      },
      ["_POWER_INSANITY"] = {
      ["modelID"] = 647733,
      ["modelAlpha"] = 1,
      ["splitAlpha"] = 1,
      ["fillTexture"] = "orb_filling16",
      ["fillColor"] = "ff6a00ab",
      },
      ["_CLASS_DRUID"] = {
      ["modelID"] = 1368931,
      ["modelAlpha"] = 1,
      ["splitAlpha"] = 1,
      ["fillColor"] = "fffd6500",
      ["fillTexture"] = "orb_filling16",
      },
      ["_POWER_MAELSTROM"] = {
      ["modelID"] = 191085,
      ["modelAlpha"] = 1,
      ["splitAlpha"] = 1,
      ["fillTexture"] = "orb_filling15",
      ["fillColor"] = "ff132f41",
      },
      ["_REACTION_NEUTRAL"] = {
      ["modelID"] = 5705388,
      ["modelAlpha"] = 1,
      ["splitAlpha"] = 1,
      ["fillColor"] = "ffab903d",
      ["fillTexture"] = "orb_filling16",
      },
      ["_CLASS_EVOKER"] = {
      ["modelID"] = 1496489,
      ["modelAlpha"] = 1,
      ["splitAlpha"] = 1,
      ["fillColor"] = "ff265132",
      ["fillTexture"] = "orb_filling16",
      },
      ["_CLASS_MONK"] = {
      ["modelID"] = 2576967,
      ["modelAlpha"] = 1,
      ["splitAlpha"] = 1,
      ["fillColor"] = "ff0d8c54",
      ["fillTexture"] = "orb_filling16",
      },
      ["_CLASS_PRIEST"] = {
      ["modelID"] = 378601,
      ["modelAlpha"] = 1,
      ["splitAlpha"] = 1,
      ["fillColor"] = "ffcfffff",
      ["fillTexture"] = "orb_filling16",
      },
      ["_REACTION_FRIENDLY"] = {
      ["modelID"] = 521284,
      ["modelAlpha"] = 1,
      ["splitAlpha"] = 1,
      ["fillColor"] = "ff56865e",
      ["fillTexture"] = "orb_filling16",
      },
      ["_CLASS_ROGUE"] = {
      ["modelID"] = 4556625,
      ["modelAlpha"] = 1,
      ["splitAlpha"] = 1,
      ["fillColor"] = "ffffae00",
      ["fillTexture"] = "orb_filling16",
      },
      ["_POWER_RAGE"] = {
      ["modelID"] = 1733375,
      ["modelAlpha"] = 1,
      ["splitAlpha"] = 1,
      ["fillTexture"] = "orb_filling16",
      ["fillColor"] = "ff760000",
      },
      ["_POWER_ENERGY"] = {
      ["modelID"] = 244276,
      ["modelAlpha"] = 1,
      ["splitAlpha"] = 1,
      ["fillTexture"] = "orb_filling6",
      ["fillColor"] = "ffffdc00",
      },
      ["_CLASS_DEMONHUNTER"] = {
      ["modelID"] = 1713776,
      ["modelAlpha"] = 1,
      ["splitAlpha"] = 1,
      ["fillTexture"] = "orb_filling16",
      ["fillColor"] = "ff2e5300",
      },
      ["_POWER_FOCUS"] = {
      ["modelID"] = 959518,
      ["modelAlpha"] = 0.5799999833106995,
      ["splitAlpha"] = 1,
      ["fillTexture"] = "orb_filling16",
      ["fillColor"] = "ff793e00",
      },
      ["_CLASS_SHAMAN"] = {
      ["modelID"] = 2030216,
      ["modelAlpha"] = 1,
      ["splitAlpha"] = 1,
      ["fillTexture"] = "orb_filling16",
      ["fillColor"] = "ff0000ff",
      },
      ["_CLASS_PALADIN"] = {
      ["modelID"] = 4703525,
      ["modelAlpha"] = 1,
      ["splitAlpha"] = 1,
      ["fillTexture"] = "orb_filling15",
      ["fillColor"] = "ffff5a98",
      },
      ["_POWER_LUNAR_POWER"] = {
      ["modelID"] = 3008538,
      ["modelAlpha"] = 1,
      ["splitAlpha"] = 1,
      ["fillTexture"] = "orb_filling15",
      ["fillColor"] = "ff6500b6",
      },
      ["_CLASS_DEATHKNIGHT"] = {
      ["modelID"] = 1041899,
      ["modelAlpha"] = 0.7299999594688416,
      ["splitAlpha"] = 1,
      ["fillColor"] = "ff99211b",
      ["fillTexture"] = "orb_filling15",
      },
      ["_CLASS_WARLOCK"] = {
      ["modelID"] = 1696965,
      ["modelAlpha"] = 1,
      ["splitAlpha"] = 1,
      ["fillColor"] = "ff6f009c",
      ["fillTexture"] = "orb_filling21",
      },
      ["_POWER_FURY"] = {
      ["modelID"] = 293986,
      ["modelAlpha"] = 1,
      ["splitAlpha"] = 1,
      ["fillTexture"] = "orb_filling16",
      ["fillColor"] = "ffc300ff",
      },
      ["_POWER_RUNIC_POWER"] = {
      ["modelID"] = 6020263,
      ["modelAlpha"] = 1,
      ["splitAlpha"] = 1,
      ["fillTexture"] = "orb_filling15",
      ["fillColor"] = "ff00fff8",
      },
      ["_CLASS_HUNTER"] = {
      ["modelID"] = 241040,
      ["modelAlpha"] = 1,
      ["splitAlpha"] = 1,
      ["fillTexture"] = "orb_filling15",
      ["fillColor"] = "ff66c500",
      },
    },
    userTemplates = {},
    ["DB_VERSION"] = L.dbversion,
  }
end

-- LoadDB
local function LoadDB()
  -- set saved variables
  rModelOrbConfig_DB = rModelOrbConfig_DB or LoadDBDefaults()
  if not rModelOrbConfig_DB["DB_VERSION"] or rModelOrbConfig_DB["DB_VERSION"] < L.dbversion then
    rModelOrbConfig_DB = LoadDBDefaults()
    print(L.name, "loading new db defaults")
  end
  L.DB = rModelOrbConfig_DB
  print(L.name, L.version, "loading db version", L.DB["DB_VERSION"])
end
L.F.LoadDB = LoadDB
