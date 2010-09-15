  
  -- // oUF D3Orbs 4.0
  -- // zork - 2010
  
  -----------------------------
  -- INIT
  -----------------------------
  
  --get the addon namespace
  local addon, ns = ...
  
  --generate a holder for the config data
  local cfg = CreateFrame("Frame")
  
  -----------------------------
  -- CONFIG
  -----------------------------
  
  -----------------------------
  --GLOBAL VARIABLES
  -----------------------------
  
  -- healthcolor defines what healthcolor will be used
  -- 0 = class color, 1 = red, 2 = green, 3 = blue, 4 = yellow, 5 = runic
  cfg.healthcolor = 0

  -- manacolor defines what manacolor will be used
  -- 1 = red, 2 = green, 3 = blue, 4 = yellow, 5 = runic
  cfg.manacolor = 3
  
  --automatic mana detection on stance/class (only works with glows active)
  --this will override the manacolor value (obvious)
  cfg.automana = true

  --setting this to false will RESET all the frame positions
  cfg.framesUserplaced = false
  --set this to false to UNLOCK the frames, to true otherwise
  cfg.framesLocked = true
 
  
  -----------------------------
  --PLAYER
  -----------------------------
  
  cfg.units = {
    player = {
      show = true,
      width = 150,
      height = 150,
      style = "player",
      scale = 0.82,
      pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -260, y = -9 }, 
    },    
  }
  
  -----------------------------
  --ACTION BAR BACKGROUND
  -----------------------------
  
  -- usebar defines what actionbarbackground texture will be used. 
  -- usebar = 0 -> choose actionbarbackground texture automatically
  -- usebar = 12 -> 12 actionbarbackground texture always
  -- usebar = 24 -> 24 actionbarbackground texture always
  -- usebar = 36 -> 36 actionbarbackground texture always
  
  cfg.actionbarbackground = {
    show = true,
    pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 1, y = 0 },
    usebar = 0,
    scale = 1,
  }

  -----------------------------
  --ANGEL
  -----------------------------

  cfg.angel = {
    show = true,
    pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 270, y = 0 },
    scale = 1,
  }
  
  -----------------------------
  --DEMON
  -----------------------------

  cfg.demon = {
    show = true,
    pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -265, y = 0 },
    scale = 1,
  }
  
  -----------------------------
  --BOTTOMLINE
  -----------------------------

  cfg.bottomline = {
    show = true,
    pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = -5 },
    scale = 1,
  }

  -----------------------------
  --STUFF
  -----------------------------

  local playername, _ = UnitName("player")
  local _, playerclass = UnitClass("player")
  local playercolor = rRAID_CLASS_COLORS[playerclass]
  
  cfg.galaxytab = {
    [0] = {r = playercolor.r, g = playercolor.g, b = playercolor.b, }, -- class color
    [1] = {r = 0.90, g = 0.1, b = 0.1, }, -- red
    [2] = {r = 0.25, g = 0.9, b = 0.25, }, -- green
    [3] = {r = 0, g = 0.35,   b = 0.9, }, -- blue
    [4] = {r = 0.9, g = 0.8, b = 0.35, }, -- yellow
    [5] = {r = 0.35, g = 0.9,   b = 0.9, }, -- runic
  }
  
  cfg.playername = playername
  cfg.playerclass = playerclass
  cfg.playercolor = playercolor

  --font
  cfg.font = "FONTS\\FRIZQT__.ttf"   

  --backdrop settings
  cfg.backdrop = { 
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", 
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = false,
    tileSize = 0, 
    edgeSize = 5, 
    insets = { 
      left = 5, 
      right = 5, 
      top = 5, 
      bottom = 5,
    },
  }
  
  -----------------------------
  -- HANDOVER
  -----------------------------
  
  --hand the config to the namespace for usage in other lua files (remember: those lua files must be called after the cfg.lua)
  ns.cfg = cfg
