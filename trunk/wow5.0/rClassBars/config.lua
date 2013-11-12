
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
    --burning embers
    burningembers = {
      enable    = true,
      scale     = 0.32,
      color     = {r = 255/255, g = 133/255, b = 0/255, },
      combat          = { --fade the bar in/out in combat/out of combat
        enable          = false,
        fadeIn          = {time = 0.4, alpha = 1},
        fadeOut         = {time = 0.3, alpha = 0.2},
      },
    },
    --demonic fury
    demonicfury = {
      enable    = true,
      scale     = 0.65,
      color     = { r = 114/255, g = 192/255, b = 48/255, },
      bgColor   = { r = 50/255, g = 40/255, b = 40/255, },
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
        enable          = false,
        fadeIn          = {time = 0.4, alpha = 1},
        fadeOut         = {time = 0.3, alpha = 0.2},
      },
    },
    --chi
    chi = {
      enable    = true,
      scale     = 0.32,
      color     = {r = 41/255, g = 209/255, b = 157/255, },
      combat          = { --fade the bar in/out in combat/out of combat
        enable          = false,
        fadeIn          = {time = 0.4, alpha = 1},
        fadeOut         = {time = 0.3, alpha = 0.2},
      },
    },
    --shadow orbs
    shadoworbs = {
      enable    = true,
      scale     = 0.32,
      color     = {r = 126/255, g = 54/255, b = 180/255, },
      combat          = { --fade the bar in/out in combat/out of combat
        enable          = false,
        fadeIn          = {time = 0.4, alpha = 1},
        fadeOut         = {time = 0.3, alpha = 0.2},
      },
    },
  }