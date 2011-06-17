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
    movable     = true,           --true/false: if this frame should be movable/sizable via /rbbs command in game
    --parent      = "UIParent",
    width       = 512,
    height      = 256,
    --scale       = 1,
    --alpha       = 1,
    --strata      = "BACKGROUND",  --frame strata
    --level       = 0, --frame level
    --pos         = { a1="CENTER", a2="CENTER", af="UIParent", x=0, y=0, },
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
    name        = "HealthOrb",
    movable     = false,
    size        = 130,
    --strata      = "BACKGRROUND",
    --level       = 1,
    --filling        = "Interface\\AddOns\\rBBS_RothUI\\media\\orb_filling15.tga",
  } 

  --bottomline texture  
  cfg.powerorb = {
    name        = "PowerOrb",
    movable     = false,
    size        = 130,
    pos         = { a1="BOTTOM", a2="BOTTOM", af="UIParent", x=300, y=-4, },
  } 
  
  --angel texture  
  cfg.angel = {
    name        = "Angel",
    movable     = true,
    width       = 512,
    height      = 256,
    strata      = "LOW",
    level       = 5,
    texture     = {
                    file        = "Interface\\AddOns\\rBBS_RothUI\\media\\d3_angel2.tga",
                  },
  } 
  
  --demon texture  
  cfg.demon = {
    name        = "Demon",
    movable     = true,
    width       = 512,
    height      = 256,
    strata      = "LOW",
    level       = 5,
    texture     = {
                    file        = "Interface\\AddOns\\rBBS_RothUI\\media\\d3_demon2.tga",
                  },
  }
  
  --bottomline texture  
  cfg.bottom = {
    name        = "BottomLine",
    movable     = true,
    width       = 512,
    height      = 128,
    strata      = "LOW",
    level       = 6,
    texture     = {
                    file        = "Interface\\AddOns\\rBBS_RothUI\\media\\d3_bottom.tga",
                  },
  } 
  
  ---------------------------------
  -- CONFIG
  ---------------------------------
