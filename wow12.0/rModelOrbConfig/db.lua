local A, L = ...

-- LoadDBDefaults
local function LoadDBDefaults()
  return {
    ["DB_VERSION"] = L.dbversion
  }
end

-- LoadDB
local function LoadDB()
  -- set saved variables
  rModelOrbConfig_DB = rModelOrbConfig_DB or LoadDBDefaults()
  if not rModelOrbConfig_DB["DB_VERSION"] or rModelOrbConfig_DB["DB_VERSION"] < L.dbversion then
    rModelOrbConfig_DB = LoadDBDefaults()
    print(L.name, 'loading new db defaults')
  end
  L.DB = rModelOrbConfig_DB
  print(L.name, 'loading db version', L.DB["DB_VERSION"])
end
L.F.LoadDB = LoadDB
