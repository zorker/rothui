local A, L = ...

---------------------------------------------------------------------
-- deepMerge
---------------------------------------------------------------------

local function deepMerge(target, source)
  if not source then return target end
  if not target then target = {} end
  for key, value in pairs(source) do
    if type(value) == "table" then
      if type(target[key]) ~= "table" then
        target[key] = {}
      end
      deepMerge(target[key], value)
    else
      target[key] = value
    end
  end
  return target
end

---------------------------------------------------------------------
-- LoadDBDefaults
---------------------------------------------------------------------

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
        hideArt = false,
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
    ["DB_VERSION"] = 14,
  }
end

---------------------------------------------------------------------
-- DB_UPDATE
---------------------------------------------------------------------

local DB_UPDATE = {}

DB_UPDATE[14] = {
  settings = {
    player = {
      hideArt = false,
    },
  }
}

---------------------------------------------------------------------
-- LoadDBUpdates
---------------------------------------------------------------------

--check if a db-update is required in the local db
--if there is no new version do nothing
local function LoadDBUpdates()
  --test for new version + 1
  local newVersion = L.DB["DB_VERSION"] + 1
  for i = newVersion, L.dbversion do
    L.DB = deepMerge(L.DB, DB_UPDATE[i])
    print(L.name, L.version, "updating local db  to version", i)
  end
  L.DB["DB_VERSION"] = L.dbversion
end

---------------------------------------------------------------------
-- ResetDB
---------------------------------------------------------------------

--[[
local function ResetDB()
  L.DB = LoadDBDefaults()
end
]]

---------------------------------------------------------------------
-- LoadDB
---------------------------------------------------------------------

local function LoadDB()
  -- set saved variables
  oUF_Diablo_DB = oUF_Diablo_DB or LoadDBDefaults()
  L.DB = oUF_Diablo_DB
  LoadDBUpdates()
  print(L.name, L.version, "loading db version", L.DB["DB_VERSION"])
end

L.F.LoadDB = LoadDB
L.DB_DEFAULTS = LoadDBDefaults()
L.DB_ORB_CONFIG = rModelOrbConfig_DB