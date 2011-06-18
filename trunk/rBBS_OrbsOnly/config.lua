  ---------------------------------
  -- INIT
  ---------------------------------
  --get the addon namespace
  local addon, ns = ...
  ns.cfg = {}
  local cfg = ns.cfg
  
  ---------------------------------
  -- CONFIG
  ---------------------------------

  --bottomline texture  
  cfg.healthorb = {
    name              = "HealthOrb",
    movable           = true,
    size              = 150,
    scale             = 0.82,
    classcolored      = false,
    animation         = {
                          enable          = true,
                          anim            = 20,
                          decreaseAlpha   = true,
                          multiplier      = 1,                          
                        },
    --color             = { r=1, g=1, b=0, a=1, },
    pos               = { a1="CENTER", a2="CENTER", af="UIParent", x=-260, y=-10, },
    --strata      = "BACKGRROUND",
    --level       = 1,
    --filling        = "Interface\\AddOns\\rBBS_RothUI\\media\\orb_filling15.tga",
  } 

  --bottomline texture  
  cfg.powerorb = {
    name              = "PowerOrb",
    movable           = true,
    size              = 150,
    scale             = 0.82,
    powertypecolored  = false,
    animation         = {
                          enable          = true,
                          anim            = 6,
                          decreaseAlpha   = true,
                          multiplier      = 1,                          
                        },
    pos               = { a1="CENTER", a2="CENTER", af="UIParent", x=260, y=-10, },
  } 
  
  
  ---------------------------------
  -- CONFIG
  ---------------------------------
