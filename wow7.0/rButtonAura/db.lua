
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

--GetDBGDefaults
local function GetDBGDefault()
  return {
    type = "G",
  }
end

--GetDBCDefaults
local function GetDBCDefault()
  return {
    type = "C",
  }
end

--ResetDBG
local function ResetDBG()
  print(A,"reseting rButtonAura_DBG")
  rButtonAura_DBG = GetDBGDefault()
  L.DB.G = rButtonAura_DBG
end
L.F.ResetDBG = ResetDBG

--ResetDBC
local function ResetDBC()
  print(A,"reseting rButtonAura_DBC")
  rButtonAura_DBC = GetDBCDefault()
  L.DB.C = rButtonAura_DBC
end
L.F.ResetDBC = ResetDBC

--VariablesLoaded
local function VariablesLoaded()
  rButtonAura_DBG = rButtonAura_DBG or GetDBGDefault()
  rButtonAura_DBC = rButtonAura_DBC or GetDBCDefault()
  L.DB.G = rButtonAura_DBG
  L.DB.C = rButtonAura_DBC
  print(A,"VariablesLoaded",L.DB.G.type,L.DB.C.type)
end

--RegisterCallback
rLib:RegisterCallback("VARIABLES_LOADED", VariablesLoaded)

