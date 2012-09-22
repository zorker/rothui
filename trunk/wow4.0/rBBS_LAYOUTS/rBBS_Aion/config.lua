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

  --drag frame (only has strata, level and position)
  cfg.dragframe = {
    strata      = "BACKGROUND",  --frame strata
    level       = 0, --frame level
    pos         = { a1="BOTTOM", x=0, y=0, },
  }

  --actionbar background 1
  cfg.actionbarbg1 = {
    name        = "ActionBarBg1",    --has to be unique per addon
    width       = 1024,
    height      = 128,
    scale       = 0.75,
    pos         = { a1="BOTTOM", x=0, y=0, }, --position
    texture     = {
                    file        = "Interface\\AddOns\\rBBS_Aion\\media\\bar1.tga",
                  },
  }

  --actionbar background 2
  cfg.actionbarbg2 = {
    name        = "ActionBarBg2",    --has to be unique per addon
    width       = 512,
    height      = 128,
    scale       = 0.75,
    pos         = { a1="BOTTOM", x=0, y=80, }, --position
    texture     = {
                    file        = "Interface\\AddOns\\rBBS_Aion\\media\\bar2.tga",
                  },
  }

  --bottomline texture
  cfg.healthorb = {
    name              = "HealthOrb",
    size              = 150,
    scale             = 0.95,
    classcolored      = false,
    animation         = {
                          enable          = true,
                          anim            = 20,
                          decreaseAlpha   = true,
                          multiplier      = 0.13,
                        },
    pos               = { a1="BOTTOM", x=-308, y=35, },
  }

  --bottomline texture
  cfg.powerorb = {
    name              = "PowerOrb",
    size              = 150,
    scale             = 0.95,
    powertypecolored  = false,
    animation         = {
                          enable          = true,
                          anim            = 6,
                          decreaseAlpha   = true,
                          multiplier      = 0.13,
                        },
    pos               = { a1="BOTTOM", x=308, y=35, },
  }

  --angel texture
  cfg.figureleft = {
    name        = "FigureLeft",
    width       = 256,
    height      = 256,
    strata      = "LOW",
    level       = 5,
    scale       = 0.75,
    pos         = { a1="BOTTOM", x=-390, y=10, },
    texture     = {
                    file        = "Interface\\AddOns\\rBBS_Aion\\media\\figure_left.tga",
                  },
  }

  --demon texture
  cfg.figureright = {
    name        = "FigureRight",
    width       = 256,
    height      = 256,
    strata      = "LOW",
    level       = 5,
    scale       = 0.75,
    pos         = { a1="BOTTOM", x=390, y=10, },
    texture     = {
                    file        = "Interface\\AddOns\\rBBS_Aion\\media\\figure_right.tga",
                  },
  }

