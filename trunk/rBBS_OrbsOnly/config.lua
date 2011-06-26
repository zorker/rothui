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
    name              = "HealthOrb",    --has to be unique per addon
    size              = 150,
    scale             = 0.82,
    classcolored      = false,
    animation         = {
                          enable          = true,
                          anim            = 20,
                          decreaseAlpha   = true,
                          multiplier      = 0.2,
                        },
    --color             = { r=1, g=1, b=0, a=1, },
    pos               = { a1="CENTER", x=-260, y=-10, },
    --strata      = "BACKGRROUND",
    --level       = 1,
    --filling        = "Interface\\AddOns\\rBBS_RothUI\\media\\orb_filling15.tga",
  }

  --bottomline texture
  cfg.powerorb = {
    name              = "PowerOrb",
    size              = 150,
    scale             = 0.82,
    powertypecolored  = false,
    animation         = {
                          enable          = true,
                          anim            = 6,
                          decreaseAlpha   = true,
                          multiplier      = 0.2,
                        },
    pos               = { a1="CENTER", x=260, y=-10, },
  }


  ---------------------------------
  -- CONFIG
  ---------------------------------
