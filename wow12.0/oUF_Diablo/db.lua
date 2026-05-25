local A, L = ...

-- LoadDBDefaults
local function LoadDBDefaults()
  return {
    playerPosition = {
      point = "BOTTOM", 
      relativePoint  = "BOTTOM", 
      xOfs = -400,
      yOfs = -15,
    },
    playerPowerPosition = {
      point = "BOTTOM", 
      relativePoint  = "BOTTOM", 
      xOfs = 400,
      yOfs = -15,
    },
    settings = {
      player = {
        scale = 1,
        lockPlayerFrame = true,
        lockPlayerPowerFrame = true,
      },
      orbModelTemplates = {
        CLASS_DEATHKNIGHT = "_CLASS_DEATHKNIGHT",
        CLASS_DEMONHUNTER = "_CLASS_DEMONHUNTER",
        CLASS_DRUID = "_CLASS_DRUID",
        CLASS_EVOKER = "_CLASS_EVOKER",
        CLASS_HUNTER = "_CLASS_HUNTER",
        CLASS_MAGE = "_CLASS_MAGE",
        CLASS_MONK = "_CLASS_MONK",
        CLASS_PALADIN = "_CLASS_PALADIN",
        CLASS_PRIEST = "_CLASS_PRIEST",
        CLASS_ROGUE = "_CLASS_ROGUE",
        CLASS_SHAMAN = "_CLASS_SHAMAN",
        CLASS_WARLOCK = "_CLASS_WARLOCK",
        CLASS_WARRIOR = "_CLASS_WARRIOR",
        POWER_ENERGY = "_POWER_ENERGY",
        POWER_FOCUS = "_POWER_FOCUS",
        POWER_FURY = "_POWER_FURY",
        POWER_INSANITY = "_POWER_INSANITY",
        POWER_LUNAR_POWER = "_POWER_LUNAR_POWER",
        POWER_MAELSTROM = "_POWER_MAELSTROM",
        POWER_MANA = "_POWER_MANA",
        POWER_RAGE = "_POWER_RAGE",
        POWER_RUNIC_POWER = "_POWER_RUNIC_POWER",
        REACTION_FRIENDLY = "_REACTION_FRIENDLY",
        REACTION_NEUTRAL = "_REACTION_NEUTRAL",
        REACTION_HOSTILE = "_REACTION_HOSTILE",
        OTHER = "_OTHER",
      },
    },
    ["DB_VERSION"] = L.dbversion,
  }
end

-- LoadDB
local function LoadDB()
  -- set saved variables
  oUF_Diablo_DB = oUF_Diablo_DB or LoadDBDefaults()
  if not oUF_Diablo_DB["DB_VERSION"] or oUF_Diablo_DB["DB_VERSION"] < L.dbversion then
    oUF_Diablo_DB = LoadDBDefaults()
    print(L.name, "loading new db defaults")
  end
  L.DB = oUF_Diablo_DB
  print(L.name, "loading db version", L.DB["DB_VERSION"])
end
L.F.LoadDB = LoadDB

L.DB_DEFAULTS = LoadDBDefaults()

-- load the rModelOrbConfig templates
L.DB_ORB_CONFIG = rModelOrbConfig_DB --load the orb config db