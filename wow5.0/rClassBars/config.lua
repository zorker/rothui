
  ---------------------------------------------
  --  rClassBars
  ---------------------------------------------

  --  A classbar mod
  --  zork - 2013

  ---------------------------------------------

  --get the addon namespace
  local addonName, ns = ...
  --setup the config table
  local cfg = {}
  --make the config available in the namespace
  ns.cfg = cfg

  ---------------------------------------------
  --  Config
  ---------------------------------------------

  --modules
  cfg.modules = {
    soulshards = true,
  }