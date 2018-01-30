
-- rButtonAura: db
-- zork, 2018

-----------------------------
-- Variables
-----------------------------

local A, L = ...

--db container
L.DB = {}
--function container
L.F = {}

-----------------------------
-- Functions
-----------------------------

local function LoadGlobalDefaults()
  return {
    type = "G",
  }
end

local function LoadCharacterDefaults()
  return {
    type = "C",
  }
end

--VariablesLoaded
local function VariablesLoaded()
  rButtonAura_DBG = rButtonAura_DBG or LoadGlobalDefaults()
  rButtonAura_DBC = rButtonAura_DBC or LoadCharacterDefaults()
  L.DB.G = rButtonAura_DBG
  L.DB.C = rButtonAura_DBC
  print(A,"VariablesLoaded",L.DB.G.type,L.DB.C.type)
end

--RegisterCallback
rLib:RegisterCallback("VARIABLES_LOADED", VariablesLoaded)

