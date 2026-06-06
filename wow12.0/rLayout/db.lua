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
    settings = {
      modules = {
        chat = {
          enabled = true,
        },
        darkmode = {
          enabled = true,
        },
        spellalert = {
          enabled = true,
        },
        statedriver = {
          enabled = true,
        },
        tooltip = {
          enabled = true,
        },
        vignette = {
          enabled = true,
        },
      },
    },
    ["DB_VERSION"] = 2,
  }
end

---------------------------------------------------------------------
-- DB_UPDATE
---------------------------------------------------------------------

local DB_UPDATE = {}

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
-- CheckForDBReset
---------------------------------------------------------------------

local function CheckForDBReset()
  local resetDB = false
  if not L.DB["DB_VERSION"] or L.DB["DB_VERSION"] < 2 then
    resetDB = true
  end
  if resetDB then
    L.DB = LoadDBDefaults()
    print(L.name, "error in db structure found, reloading db defaults")
  end
end

---------------------------------------------------------------------
-- LoadDB
---------------------------------------------------------------------

local function LoadDB()
  -- set saved variables
  rLayout_DB = rLayout_DB or LoadDBDefaults()
  L.DB = rLayout_DB
  CheckForDBReset()
  LoadDBUpdates()
  print(L.name, L.version, "loading db version", L.DB["DB_VERSION"])
end

L.F.LoadDB = LoadDB
L.DB_DEFAULTS = LoadDBDefaults()
