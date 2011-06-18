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
    height      = 512,
    scale       = 0.6,
    --alpha       = 1,
    --strata      = "BACKGROUND",  --frame strata
    --level       = 0, --frame level
    pos         = { a1="BOTTOM", a2="BOTTOM", af="UIParent", x=0, y=0, },
    texture     = {
                    file        = "Interface\\AddOns\\rBBS_Diablo3NoOrbs\\media\\bar.tga",
                    --strata      = "BACKGROUND", --texture strata
                    --level       = -8, --texture level
                    --color       = { r=1, g=0, b=0, a = 1, },
                    --blendmode   = "ADD",
                  },
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
    pos         = { a1="BOTTOM", a2="BOTTOM", af="UIParent", x=372, y=0, },
    texture     = {
                    file        = "Interface\\AddOns\\rBBS_Diablo3NoOrbs\\media\\figure_right.tga",
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
    pos         = { a1="BOTTOM", a2="BOTTOM", af="UIParent", x=-382, y=0, },
    texture     = {
                    file        = "Interface\\AddOns\\rBBS_Diablo3NoOrbs\\media\\figure_left.tga",
                  },
  }
  
  ---------------------------------
  -- CONFIG
  ---------------------------------
