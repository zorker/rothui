
  -- rLib
  -- zork, 2014

  -------------------------------------
  -- VARIABLES
  -------------------------------------

  -- addon data
  local an, at = ... -- addon name, addon table

  -- global data table
  at.G = {}
  
  -- make global data table available as rLib
  rLib = at.G

  -- local data table
  at.L = {}

  -- config data table
  at.C = {}

  -- local variables
  local G, L, C = at.G, at.L, at.C

  -- version stuff
  L.name = an
  L.version = GetAddOnMetadata(L.name, "Version")
  L.versionNumber = tonumber(L.version)
  L.locale = GetLocale()

