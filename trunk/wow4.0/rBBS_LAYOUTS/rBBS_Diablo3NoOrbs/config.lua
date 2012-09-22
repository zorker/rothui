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

  --actionbar background
  cfg.actionbarbg = {
    name        = "ActionBar",    --has to be unique per addon
    width       = 1024,
    height      = 512,
    scale       = 0.6,
    --alpha       = 1,
    --strata      = "BACKGROUND",  --frame strata
    --level       = 0, --frame level
    pos         = { a1="BOTTOM", x=0, y=0, },
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
    width       = 512,
    height      = 256,
    strata      = "LOW",
    level       = 5,
    scale       = 0.6,
    pos         = { a1="BOTTOM", x=372, y=0, },
    texture     = {
                    file        = "Interface\\AddOns\\rBBS_Diablo3NoOrbs\\media\\figure_right.tga",
                  },
  }

  --demon texture
  cfg.demon = {
    name        = "Demon",
    width       = 512,
    height      = 256,
    strata      = "LOW",
    level       = 5,
    scale       = 0.6,
    pos         = { a1="BOTTOM", x=-382, y=0, },
    texture     = {
                    file        = "Interface\\AddOns\\rBBS_Diablo3NoOrbs\\media\\figure_left.tga",
                  },
  }

  ---------------------------------
  -- CONFIG
  ---------------------------------
