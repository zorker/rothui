
  ---------------------------------------------
  --  oUF_Diablo
  ---------------------------------------------
  
  --  A unitframe layout for oUF 1.5.x
  --  by zork - 2010
  
  ---------------------------------------------
  
  --get the addon namespace
  local addon, ns = ...
  
  --object container
  local cfg = CreateFrame("Frame") 
  
  ---------------------------------------------
  -- CONFIG
  ---------------------------------------------

  --units
  cfg.units = {
    player = {
      show = true,
    },
    target = {
      show = true,
    },
    targettarget = {
      show = true,
    },
    pet = {
      show = true,
    },
    focus = {
      show = true,
    },
  }

  --player stuff
  local playername, _     = UnitName("player")
  local _, playerclass    = UnitClass("player")
  local playercolor       = RAID_CLASS_COLORS[playerclass]  
  cfg.playername          = playername
  cfg.playerclass         = playerclass
  cfg.playercolor         = playercolor

  --font
  cfg.font = "FONTS\\FRIZQT__.ttf"   

  --backdrop
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
  
  --object container to addon namespace
  ns.cfg = cfg
