
  -- rIngameModelViewer
  -- zork 2014

  -------------------------------------
  -- ADDON TABLES
  -------------------------------------

  local an, at = ...

  at.G = {} --global (if any)
  at.L = {} --local
  at.C = {} --config
  at.DB = {} --database

  -------------------------------------
  -- VARIABLES
  -------------------------------------

  -- local variables
  local G, L, C = at.G, at.L, at.C

  -- version stuff
  L.name          = an
  L.version       = GetAddOnMetadata(L.name, "Version")
  L.versionNumber = tonumber(L.version) or 0
  L.locale        = GetLocale()
