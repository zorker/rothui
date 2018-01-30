
-- rButtonAura: db
-- zork, 2018

-----------------------------
-- Variables
-----------------------------

local A, L = ...

--db container
L.DB = {}

-----------------------------
-- Functions
-----------------------------

local function GlobalDefaults()
  return {
    type = "G",
  }
end

local function CharacterDefaults()
  return {
    type = "C",
  }
end

--VariablesLoaded
local function VariablesLoaded(...)
  rButtonAura_DBG = rButtonAura_DBG or GlobalDefaults()
  rButtonAura_DBC = rButtonAura_DBC or CharacterDefaults()
  L.DB.G = rButtonAura_DBG
  L.DB.C = rButtonAura_DBC
  print(A,"VariablesLoaded",L.DB.G.type,L.DB.C.type)
end

--RegisterCallback
rLib:RegisterCallback("VARIABLES_LOADED", VariablesLoaded)

