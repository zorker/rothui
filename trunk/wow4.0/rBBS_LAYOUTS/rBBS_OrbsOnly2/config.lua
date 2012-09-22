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

  --playerhealthorb
  cfg.playerhealthorb = {
    name              = "PlayerHealthOrb",
    size              = 150,
    scale             = 0.82,
    classcolored      = true,
    animation         = {
                          enable          = true,
                          anim            = 20,
                          decreaseAlpha   = false,
                          multiplier      = 0.3,
                        },
    --color             = { r=1, g=1, b=0, a=1, },
    pos               = { a1="CENTER", x=-260, y=0, },
    --strata      = "BACKGRROUND",
    --level       = 1,
    --filling        = "Interface\\AddOns\\rBBS_RothUI\\media\\orb_filling15.tga",
  }

  --playerpowerorb
  cfg.playerpowerorb = {
    name              = "PlayerPowerOrb",
    size              = 150,
    scale             = 0.82,
    powertypecolored  = true,
    animation         = {
                          enable          = true,
                          anim            = 6,
                          decreaseAlpha   = false,
                          multiplier      = 0.3,
                        },
    pos               = { a1="CENTER", x=260, y=0, },
  }

  --targethealthorb
  cfg.targethealthorb = {
    name              = "TargetHealthOrb",
    unit              = "target",         --default unit is "player" but in this case we want target
    size              = 120,
    scale             = 0.82,
    classcolored      = true,
    animation         = {
                          enable          = true,
                          anim            = 2,
                          decreaseAlpha   = false,
                          multiplier      = 0.3,
                        },
    pos               = { a1="CENTER", x=-130, y=0, },
  }

  --targetpowerorb
  cfg.targetpowerorb = {
    name              = "TargetPowerOrb",
    unit              = "target",         --default unit is "player" but in this case we want target
    size              = 120,
    scale             = 0.82,
    powertypecolored  = true,
    animation         = {
                          enable          = true,
                          anim            = 0,
                          decreaseAlpha   = false,
                          multiplier      = 0.3,
                        },
    pos               = { a1="CENTER", x=130, y=0, },
  }

  ---------------------------------
  -- CONFIG
  ---------------------------------
