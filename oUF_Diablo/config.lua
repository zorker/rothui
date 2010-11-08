
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
  -- // CONFIG // --
  ---------------------------------------------

  ----------------------------------------
  -- orb color settings
  ----------------------------------------

  -- healthcolor defines what healthcolor will be used
  -- 0 = class color, 1 = red, 2 = green, 3 = blue, 4 = yellow, 5 = runic
  cfg.healthcolor = 0

  -- manacolor defines what manacolor will be used
  -- 1 = red, 2 = green, 3 = blue, 4 = yellow, 5 = runic
  cfg.manacolor = 1
  
  --automatic mana detection on stance/class (only works with glows active)
  --this will override the manacolor value (obvious)
  cfg.automana = true


  ----------------------------------------
  -- frame movement
  ----------------------------------------
  
  --setting this to false will use the default frame positions, true allows moving
  cfg.framesUserplaced = false 
  
  --setting this to true will lock the frames in place, false unlocks them
  cfg.framesLocked = true
  
  
  ----------------------------------------
  --units
  ----------------------------------------
  
  cfg.units = {
    -- PLAYER
    player = {
      show = true,
      width = 150,
      height = 150,
      scale = 0.82,
      pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -260, y = -9 }, 
      icons = {
        pvp = {
          show = false,
          pos = { a1 = "CENTER", a2 = "CENTER", x = -95, y = 42 }, --position in relation to self object
        },
        combat = {
          show = false,
          pos = { a1 = "CENTER", a2 = "CENTER", x = 0, y = 86 }, --position in relation to self object
        },
        resting = {
          show = true,
          pos = { a1 = "CENTER", a2 = "CENTER", x = -72, y = 60 }, --position in relation to self object
        },
      },
      auras = {
        show = true,
        size = 28,
        onlyShowPlayerBuffs = false,
        onlyShowPlayerDebuffs = false,
      },
      castbar = {
        show = true,
        latency = true,
        classcolored = false,
        texture = "Interface\\AddOns\\rTextures\\statusbar5",
        scale = 1,
        color = {r = 0.9, g = 0.59, b = 0, },
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = 180.5 }, 
      },
      soulshards = { 
        show = true,
        scale = 0.56,
        color = {r = 150/255, g = 135/255, b = 200/255, },
      },
      holypower = { 
        show = true,
        scale = 0.56,
        color = {r = 200/255, g = 135/255, b = 190/255, },
      },
      runes = {
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -55, y = 140 }, 
      },
      expbar = { --experience
        show = true,
          pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = 10 },
          texture = "Interface\\AddOns\\rTextures\\statusbar",
          scale = 1,
      },
      repbar = { --reputation
        show = true,
          pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = 10 },
          texture = "Interface\\AddOns\\rTextures\\statusbar",
          scale = 1,
      },
      art = {
        actionbarbackground = {
          show = true,
          pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 1, y = 0 },
          scale = 1,
        },
        angel = {
          show = true,
          pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 270, y = 0 },
          scale = 1,
        },
        demon = {
          show = true,
          pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -265, y = 0 },
          scale = 1,
        },
        bottomline = {
          show = true,
          pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = -5 },
          scale = 1,
        },
      },      
    },
    
    -- TARGET
    target = {
      show = true,
      scale = 1,
      pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = 250 }, 
      health = {
        texture = "Interface\\AddOns\\rTextures\\statusbar5",
      },
      power = {
        texture = "Interface\\AddOns\\rTextures\\statusbar5",
      },
      auras = {
        show = true,
        size = 22,
        onlyShowPlayerBuffs = false,
        onlyShowPlayerDebuffs = false,
        showDebuffType = false,
      },
      castbar = {
        show = true,
        classcolored = false,
        texture = "Interface\\AddOns\\rTextures\\statusbar5",
        scale = 1,
        color = {r = 0.9, g = 0.59, b = 0, },
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = 350 }, 
      },
      combobar = { 
        show = true,
        scale = 0.5,
        color = {r = 0.9, g = 0.59, b = 0, },
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = 480 }, 
      },
    },
    
    --TARGETTARGET
    targettarget = {
      show = true,
      scale = 1,
      pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -195, y = 250 }, 
      auras = {
        show = true,
        size = 22,
        onlyShowPlayerDebuffs = false,
        showDebuffType = false,
      },
      health = {
        texture = "Interface\\AddOns\\rTextures\\statusbar5",
      },
      power = {
        texture = "Interface\\AddOns\\rTextures\\statusbar5",
      },
    },
    
    --PET
    pet = {
      show = true,
      scale = 0.85,
      pos = { a1 = "LEFT", a2 = "LEFT", af = "UIParent", x = 10, y = -140 }, 
      auras = {
        show = true,
        size = 22,
        onlyShowPlayerDebuffs = false,
        showDebuffType = false,
      },
      health = {
        texture = "Interface\\AddOns\\rTextures\\statusbar5",
      },
      power = {
        texture = "Interface\\AddOns\\rTextures\\statusbar5",
      },
      portrait = {
        show = true,
        use3D = true,
      },
    },
    
    --FOCUS
    focus = {
      show = true,
      scale = 0.85,
      pos = { a1 = "LEFT", a2 = "LEFT", af = "UIParent", x = 10, y = 40 }, 
      auras = {
        show = true,
        size = 22,
        onlyShowPlayerDebuffs = false,
        showDebuffType = false,
      },
      health = {
        texture = "Interface\\AddOns\\rTextures\\statusbar5",
      },
      power = {
        texture = "Interface\\AddOns\\rTextures\\statusbar5",
      },
      portrait = {
        show = true,
        use3D = true,
      },
      castbar = {
        show = false,
        classcolored = false,
        texture = "Interface\\AddOns\\rTextures\\statusbar5",
        scale = 1,
        color = {r = 0.9, g = 0.59, b = 0, },
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = 420 }, 
      },  
    },
    
    --PETTARGET
    pettarget = {
      show = true,
      scale = 0.85,
      pos = { a1 = "LEFT", a2 = "LEFT", af = "UIParent", x = 140, y = -140 }, 
      auras = {
        show = true,
        size = 22,
        onlyShowPlayerDebuffs = false,
        showDebuffType = false,
      },
      health = {
        texture = "Interface\\AddOns\\rTextures\\statusbar5",
      },
      power = {
        texture = "Interface\\AddOns\\rTextures\\statusbar5",
      },
      portrait = {
        show = true,
        use3D = true,
      },
    },
    
    --FOCUSTARGET
    focustarget = {
      show = true,
      scale = 0.85,
      pos = { a1 = "LEFT", a2 = "LEFT", af = "UIParent", x = 140, y = 40 }, 
      auras = {
        show = true,
        size = 22,
        onlyShowPlayerDebuffs = false,
        showDebuffType = false,
      },
      health = {
        texture = "Interface\\AddOns\\rTextures\\statusbar5",
      },
      power = {
        texture = "Interface\\AddOns\\rTextures\\statusbar5",
      },
      portrait = {
        show = true,
        use3D = true,
      },
    },
    
    --PARTY
    party = {
      show = true,
      showsolo = false, --show party when solo
      scale = 0.85,
      pos = { a1 = "TOPLEFT", a2 = "TOPLEFT", af = "UIParent", x = 10, y = -10 }, 
      auras = {
        show = true,
        size = 22,
        onlyShowPlayerDebuffs = false,
        showDebuffType = false,
      },
      health = {
        texture = "Interface\\AddOns\\rTextures\\statusbar5",
      },
      power = {
        texture = "Interface\\AddOns\\rTextures\\statusbar5",
      },
      portrait = {
        show = true,
        use3D = false,
      },
    },
  }

  ----------------------------------------
  -- player specific data
  ----------------------------------------

  --player stuff
  local playername, _     = UnitName("player")
  local _, playerclass    = UnitClass("player")
  local playercolor       = RAID_CLASS_COLORS[playerclass]  
  cfg.playername          = playername
  cfg.playerclass         = playerclass
  cfg.playercolor         = playercolor

  ----------------------------------------
  -- other
  ----------------------------------------

  --galaxy color stuff
  cfg.galaxytab = {
    [0] = {r = playercolor.r, g = playercolor.g, b = playercolor.b, }, -- class color
    [1] = {r = 0.90, g = 0.1, b = 0.1, }, -- red
    [2] = {r = 0.25, g = 0.9, b = 0.25, }, -- green
    [3] = {r = 0, g = 0.35,   b = 0.9, }, -- blue
    [4] = {r = 0.9, g = 0.8, b = 0.35, }, -- yellow
    [5] = {r = 0.35, g = 0.9,   b = 0.9, }, -- runic
  }
  
  cfg.powercolors = {
    ["MANA"] = { r = 0, g = 0.4, b = 1 },
    ["RAGE"] = { r = 1.00, g = 0.00, b = 0.00 },
    ["FOCUS"] = { r = 1.00, g = 0.50, b = 0.25 },
    ["ENERGY"] = { r = 1.00, g = 0.75, b = 0.10 },
    ["HAPPINESS"] = { r = 0.00, g = 1.00, b = 1.00 },
    ["RUNES"] = { r = 0.50, g = 0.50, b = 0.50 },
    ["RUNIC_POWER"] = { r = 0.00, g = 0.82, b = 1.00 },
    ["AMMOSLOT"] = { r = 0.80, g = 0.60, b = 0.00 },
    ["FUEL"] = { r = 0.0, g = 0.55, b = 0.5 },
  }
  
  cfg.happycolors = {
    [0] = {r = 1, g = 1, b = 1},
    [1] = {r = 1, g = 0, b = 0},
    [2] = {r = 1, g = 1, b = 0},
    [3] = {r = 0, g = 1, b = 0},
  }

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
