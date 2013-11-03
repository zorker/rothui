
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
    --soul shards
    soulshards = {
      enable    = true,
      scale     = 0.32,
      color     = {r = 200/255, g = 0/255, b = 255/255, },
      combat          = { --fade the bar in/out in combat/out of combat
        enable          = false,
        fadeIn          = {time = 0.4, alpha = 1},
        fadeOut         = {time = 0.3, alpha = 0.2},
      },
    },
    --holy power
    holypower = {
      enable    = true,
      scale     = 0.32,
      color = {r = 200/255, g = 135/255, b = 190/255, },
      combat          = { --fade the bar in/out in combat/out of combat
        enable          = true,
        fadeIn          = {time = 0.4, alpha = 1},
        fadeOut         = {time = 0.3, alpha = 0.2},
      },
    },
  }