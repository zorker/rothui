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

  --actionbar background  
  cfg.actionbarbg = {
    name        = "ActionBar",    --this is needed if you want this frame to be movable ingame
    movable     = false,           --true/false: if this frame should be movable/sizable via /rbbs command in game
    --parent      = "UIParent",
    width       = 512,
    height      = 256,
    scale       = 0.82,
    --alpha       = 1,
    --strata      = "BACKGROUND",  --frame strata
    --level       = 0, --frame level
    pos         = { a1="BOTTOM", a2="BOTTOM", af="UIParent", x=0, y=1, },
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
    movable           = false,
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
    pos               = { a1="BOTTOM", a2="BOTTOM", af="UIParent", x=-260, y=-10, },
    --strata      = "BACKGRROUND",
    --level       = 1,
    --filling        = "Interface\\AddOns\\rBBS_RothUI\\media\\orb_filling15.tga",
  } 

  --bottomline texture  
  cfg.powerorb = {
    name              = "PowerOrb",
    movable           = false,
    size              = 150,
    scale             = 0.82,
    powertypecolored  = true,
    animation         = {
                          enable          = true,
                          anim            = 6,
                          decreaseAlpha   = false,
                          multiplier      = 0.3,                          
                        },
    pos               = { a1="BOTTOM", a2="BOTTOM", af="UIParent", x=260, y=-10, },
  } 
  
  --angel texture  
  cfg.angel = {
    name        = "Angel",
    movable     = false,
    width       = 512,
    height      = 256,
    strata      = "LOW",
    level       = 5,
    scale       = 0.55,
    pos         = { a1="BOTTOM", a2="BOTTOM", af="UIParent", x=400, y=0, },
    texture     = {
                    file        = "Interface\\AddOns\\rBBS_RothUI\\media\\d3_angel2.tga",
                  },
  } 
  
  --demon texture  
  cfg.demon = {
    name        = "Demon",
    movable     = false,
    width       = 512,
    height      = 256,
    strata      = "LOW",
    level       = 5,
    scale       = 0.55,
    pos         = { a1="BOTTOM", a2="BOTTOM", af="UIParent", x=-405, y=0, },
    texture     = {
                    file        = "Interface\\AddOns\\rBBS_RothUI\\media\\d3_demon2.tga",
                  },
  }
  
  --bottomline texture  
  cfg.bottom = {
    name        = "BottomLine",
    movable     = false,
    width       = 512,
    height      = 128,
    strata      = "LOW",
    level       = 6,
    scale       = 0.82,
    pos         = { a1="BOTTOM", a2="BOTTOM", af="UIParent", x=0, y=-10, },
    texture     = {
                    file        = "Interface\\AddOns\\rBBS_RothUI\\media\\d3_bottom.tga",
                  },
  } 
  
  ---------------------------------
  -- CONFIG
  ---------------------------------
