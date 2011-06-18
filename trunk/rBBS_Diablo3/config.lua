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
    width       = 1024,
    height      = 256,
    scale       = 0.6,
    --alpha       = 1,
    --strata      = "BACKGROUND",  --frame strata
    --level       = 0, --frame level
    pos         = { a1="BOTTOM", a2="BOTTOM", af="UIParent", x=0, y=0, },
    texture     = {
                    file        = "Interface\\AddOns\\rBBS_Diablo3\\media\\bar.tga",
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
    size              = 135,
    scale             = 0.82,
    classcolored      = false,
    animation         = {
                          enable          = true,
                          anim            = 20,
                          decreaseAlpha   = false,
                          multiplier      = 0.3,                          
                        },
    --color             = { r=1, g=1, b=0, a=1, },
    pos               = { a1="BOTTOM", a2="BOTTOM", af="UIParent", x=-342, y=4, },
    --strata      = "BACKGRROUND",
    --level       = 1,

  } 

  --bottomline texture  
  cfg.powerorb = {
    name              = "PowerOrb",
    movable           = false,
    size              = 135,
    scale             = 0.82,
    powertypecolored  = false,
    animation         = {
                          enable          = true,
                          anim            = 6,
                          decreaseAlpha   = false,
                          multiplier      = 0.3,                          
                        },
    pos               = { a1="BOTTOM", a2="BOTTOM", af="UIParent", x=343, y=4, },
  } 
  
  --angel texture  
  cfg.angel = {
    name        = "Angel",
    movable     = false,
    width       = 512,
    height      = 256,
    strata      = "LOW",
    level       = 5,
    scale       = 0.6,
    pos         = { a1="BOTTOM", a2="BOTTOM", af="UIParent", x=464, y=0, },
    texture     = {
                    file        = "Interface\\AddOns\\rBBS_Diablo3\\media\\figure_right.tga",
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
    scale       = 0.6,
    pos         = { a1="BOTTOM", a2="BOTTOM", af="UIParent", x=-462, y=0, },
    texture     = {
                    file        = "Interface\\AddOns\\rBBS_Diablo3\\media\\figure_left.tga",
                  },
  }
  
  ---------------------------------
  -- CONFIG
  ---------------------------------
