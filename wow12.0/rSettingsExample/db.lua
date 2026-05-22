local A, L = ...

-- LoadDBDefaults
local function LoadDBDefaults()
  return {
    settings = {
      showLowHealth = false,
      showDebuffGlow = false,
    },
    ["DB_VERSION"] = L.dbversion,
  }
end

-- LoadDB
local function LoadDB()
  -- set saved variables
  rSettingsExample_DB = rSettingsExample_DB or LoadDBDefaults()
  if not rSettingsExample_DB["DB_VERSION"] or rSettingsExample_DB["DB_VERSION"] < L.dbversion then
    rSettingsExample_DB = LoadDBDefaults()
    print(L.name, "loading new db defaults")
  end
  L.DB = rSettingsExample_DB
  print(L.name, "loading db version", L.DB["DB_VERSION"])
end
L.F.LoadDB = LoadDB
