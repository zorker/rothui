local A, L = ...

-- LoadDBDefaults
local function LoadDBDefaults()
  return {
    settings = {
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
