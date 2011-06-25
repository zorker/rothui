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
    pos         = { a1="BOTTOM", x=0, y=1, },
  }

  --actionbar background
  cfg.actionbarbg = {
    name        = "ActionBar",    --this is needed and has to be unique per addon, if you want to move this frame seperately
    --parent      = "UIParent",
    width       = 512,
    height      = 256,
    scale       = 0.82,
    --alpha       = 1,
    --strata      = "BACKGROUND",  --frame strata
    --level       = 0, --frame level
    pos         = { a1="BOTTOM", x=0, y=1, }, --no anchorframe, we want it to point to the frame parented.
    texture     = {
                    file        = "Interface\\AddOns\\rBBS_RothUI\\media\\bar3.tga",
                    --strata      = "BACKGROUND", --texture strata
                    --level       = -8, --texture level
                    --color       = { r=1, g=0, b=0, a = 1, },
                    --blendmode   = "ADD",
                  },
  }

  --bottomline texture
  cfg.healthorb = {
    name              = "HealthOrb",
    --movable           = true,
    size              = 150,
    scale             = 0.82,
    classcolored      = false,
    animation         = {
                          enable          = true,
                          anim            = 20,
                          decreaseAlpha   = true,
                          multiplier      = 0.13,
                        },
    --color             = { r=1, g=1, b=0, a=1, },
    pos               = { a1="BOTTOM", x=-260, y=-10, },
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
                          multiplier      = 0.13,
                        },
    pos               = { a1="BOTTOM", x=260, y=-10, },
  }

  --angel texture
  cfg.angel = {
    name        = "Angel",
    width       = 512,
    height      = 256,
    strata      = "LOW",
    level       = 5,
    scale       = 0.55,
    pos         = { a1="BOTTOM", x=400, y=-2, },
    texture     = {
                    file        = "Interface\\AddOns\\rBBS_RothUI\\media\\d3_angel2.tga",
                  },
  }

  --demon texture
  cfg.demon = {
    name        = "Demon",
    width       = 512,
    height      = 256,
    strata      = "LOW",
    level       = 5,
    scale       = 0.55,
    pos         = { a1="BOTTOM", x=-405, y=-2, },
    texture     = {
                    file        = "Interface\\AddOns\\rBBS_RothUI\\media\\d3_demon2.tga",
                  },
  }

  --bottomline texture
  cfg.bottom = {
    name        = "BottomLine",
    width       = 512,
    height      = 128,
    strata      = "LOW",
    level       = 6,
    scale       = 0.82,
    pos         = { a1="BOTTOM", x=0, y=-10, },
    texture     = {
                    file        = "Interface\\AddOns\\rBBS_RothUI\\media\\d3_bottom.tga",
                  },
  }

  ---------------------------------
  -- CONFIG
  ---------------------------------
