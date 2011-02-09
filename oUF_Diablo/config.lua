
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
  -- orb texture settings
  ----------------------------------------

  --the texture of the health orb. you can choose between 11 different textures.
  --0 = random, 1 = moon, 2 = earth, 3 = mars, 4 = galaxy, 5 = jupiter, 6 = fraktal_circle, 7 = sun, 8 = icecream, 9 = marble, 10 = gradient, 11 = bubbles, 12 = woodpepples, 13 = golf, 14 = city
  cfg.healthtexture = 1
  
  --the texture of the mana orb. you can choose between 11 different textures.
  --0 = random, 1 = moon, 2 = earth, 3 = mars, 4 = galaxy, 5 = jupiter, 6 = fraktal_circle, 7 = sun, 8 = icecream, 9 = marble, 10 = gradient, 11 = bubbles, 12 = woodpepples, 13 = golf, 14 = city
  cfg.manatexture = 3

  ----------------------------------------
  -- colorswitcher define your color for healthbars here
  ----------------------------------------
  
  --color is in RGB (red (r), green (g), blue (b), alpha (a)), values are from 0 (dark color) to 1 (bright color). 1,1,1 = white / 0,0,0 = black / 1,0,0 = red etc
  cfg.colorswitcher = {
    bright              = { r = 1, g = 0, b = 0, a = 0.9, },          -- the bright color
    dark                = { r = 0.15, g = 0.15, b = 0.15, a = 1, },   -- the dark color
    classcolored        = false,   -- true   -> override the bright color with the unit specific color (class, faction, happiness)
    useBrightForeground = false,  -- true   -> use bright color in foreground and dark color in background
                                  -- false  -> use dark color in foreground and bright color in background
  }

  ----------------------------------------
  -- frame movement
  ----------------------------------------
  
  --setting this to false will use the default frame positions, true allows moving
  cfg.framesUserplaced = true 
  
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
      power = {
        frequentUpdates = false,
      },
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
      castbar = {
        show = true,
        latency = true,
        texture = "Interface\\AddOns\\rTextures\\statusbar5",
        scale = 1/0.82, --divide 1 by current unit scale if you want to prevent scaling of the castbar based on unit scale
        color = {
          bar = { r = 0.15, g = 0.15, b = 0.15, a = 1, },
          bg = { r = 0.96, g = 0.7, b = 0, a = 1, },
        },
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = 180.5 }, 
      },
      soulshards = { 
        show = true,
        scale = 0.58,
        color = {r = 150/255, g = 135/255, b = 200/255, },
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = 280 }, 
        alpha = {
          ooc = 0.5, --alpha value out of combat
          ic = 1, --alpha value in comat
        },
      },
      holypower = { 
        show = true,
        scale = 0.58,
        color = {r = 200/255, g = 135/255, b = 190/255, },
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = 280 }, 
        alpha = {
          ooc = 0.5, --alpha value out of combat
          ic = 1, --alpha value in comat
        },
      },
      eclipsebar = { 
        show = true,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = 280 }, 
        scale = 1,
      },
      runes = {
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = 170 }, 
      },
      expbar = { --experience
        show = true,
          pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = 10 },
          texture = "Interface\\AddOns\\rTextures\\statusbar",
          scale = 1,
          color = {r = 0.8, g = 0, b = 0.8, },
          rested = {
            color = {r = 1, g = 0.7, b = 0, },
          },
      },
      repbar = { --reputation
        show = true,
          pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = 10 },
          texture = "Interface\\AddOns\\rTextures\\statusbar",
          scale = 1,
      },
      art = {
        minimapdifficulty = {
          scale = 0.8,
        },
        actionbarbackground = {
          show = true,
          pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 1, y = 0 },
          scale = 1,
          style = 0, --0 = automatic bar detection, 1 = 12 button texture fixed, 2 = 24 button texture fixed, 3 = 36 button texture fixed
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
      portrait = {
        pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -100, y = 0 },
        size = 150,
        show = false,
        use3D = true,
      },
    },
    
    -- TARGET
    target = {
      show = true,
      scale = 1,
      pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = 250 }, 
      health = {
        texture = "Interface\\AddOns\\rTextures\\statusbar5",
        tag = "[diablo:hpval]",
      },
      power = {
        texture = "Interface\\AddOns\\rTextures\\statusbar5",
        tag = "", --more tags see oUF/elements/tags.lua | example: "[curpp] / [perpp]%" or "[diablo:ppval]"
      },
      auras = {
        show = true,
        size = 20,
        onlyShowPlayerBuffs = false,
        onlyShowPlayerDebuffs = false,
        showDebuffType = false,
        buffs = {
          pos = { a1 = "BOTTOMLEFT", a2 = "TOPRIGHT", x = 0, y = -15 }, 
          initialAnchor = "BOTTOMLEFT",
          growthx = "RIGHT",
          growthy = "UP",
        },        
        debuffs = {
          pos = { a1 = "TOPLEFT", a2 = "BOTTOMRIGHT", x = 0, y = 15 }, 
          initialAnchor = "TOPLEFT",
          growthx = "RIGHT",
          growthy = "DOWN",
        },
      },
      castbar = {
        show = true,
        texture = "Interface\\AddOns\\rTextures\\statusbar5",
        scale = 1/1, --divide 1 by current unit scale if you want to prevent scaling of the castbar based on unit scale
        color = {
          bar = { r = 0.15, g = 0.15, b = 0.15, a = 1, },
          bg = { r = 0.96, g = 0.7, b = 0, a = 1, },
        },
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = 350 }, 
      },
      combobar = { 
        show = true,
        scale = 0.5,
        color = {r = 0.9, g = 0.59, b = 0, },
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = 480 }, 
      },
      portrait = {
        pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = 100, y = 0 },
        size = 150,
        show = false,
        use3D = true,
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
        tag = "[diablo:misshp]",
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
        tag = "[diablo:misshp]",
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
        tag = "[diablo:misshp]",
      },
      power = {
        texture = "Interface\\AddOns\\rTextures\\statusbar5",
      },
      portrait = {
        show = true,
        use3D = true,
      },
      castbar = {
        show = true,
        texture = "Interface\\AddOns\\rTextures\\statusbar5",
        scale = 1/0.85, --divide 1 by current unit scale if you want to prevent scaling of the castbar based on unit scale
        color = {
          bar = { r = 0.15, g = 0.15, b = 0.15, a = 1, },
          bg = { r = 0.96, g = 0.7, b = 0, a = 1, },
        },
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = 420 }, 
      },  
    },
    
    --PETTARGET
    pettarget = {
      show = false,
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
        tag = "[diablo:misshp]",
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
      show = false,
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
        tag = "[diablo:misshp]",
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
      alpha = {
        notinrange = 0.5,
      },
      scale = 0.85,
      pos = { a1 = "TOPLEFT", a2 = "TOPLEFT", af = "UIParent", x = 10, y = -80 }, 
      auras = {
        show = true,
        size = 22,
        onlyShowPlayerDebuffs = false,
        showDebuffType = false,
      },
      health = {
        texture = "Interface\\AddOns\\rTextures\\statusbar5",
        tag = "[diablo:misshp]",
      },
      power = {
        texture = "Interface\\AddOns\\rTextures\\statusbar5",
      },
      portrait = {
        show = true,
        use3D = true,
      },
      attributes = {
        visibility          = "party",  --show this header in party
        showPlayer          = true,     --make this true to show player in party
        showSolo            = false,    --make this true to show while solo (only works if solo is in visiblity aswell
        showParty           = true,     --make this true to show headerin party
        showRaid            = false,    --show in raid
        point               = "LEFT",
      },
    },
    
    --RAID
    raid = {
      show = true,
      alpha = {
        notinrange = 0.5,
      },
      scale = 1.05,
      pos = { a1 = "TOPLEFT", a2 = "TOPLEFT", af = "UIParent", x = 10, y = -10 }, 
      health = {
        texture = "Interface\\AddOns\\rTextures\\statusbar5",
        tag1 = "[diablo:name]",     --tag for the first line
        tag2 = "[diablo:misshp]",   --tag for the second line
        classcoloroverride = false, --even if you set the colorswitcher to no classcolor this value can be used to make the raid class colored
      },
      auras = {
        --put every single spellid here that you want to be tracked, be it buff or debuff doesn't matter
        --maximum number of icons displayed at a time = 1
        --this is for important boss mechanics only, this is not for tracking healing HOTs etc
        spelllist = {
          
          --test
          32407, 
                    
          --CATACLYSM RAIDS          
          
          --maloriak
          92980, --ice bomb
          77786, --red phase consuming flames
          
          --chimaeron
          89084 , --skull icon chimaeron <10k life
          
        },
        show            = true,
        disableCooldown = true,
        showBuffType    = false,
        showDebuffType  = false,
        size            = 20,
      },
      attributes = {
        visibility          = "raid", --use "party,raid" to show this in party aswell
        showPlayer          = false,  --make this true to show player in party
        showSolo            = false,  --make this true to show while solo (only works if solo is in visiblity aswell
        showParty           = false,  --make this true to show raid in party
        showRaid            = true,   --show in raid
        point               = "TOP",
        yOffset             = 20,
        xoffset             = 0,
        maxColumns          = 8,
        unitsPerColumn      = 5,
        columnSpacing       = -20,
        columnAnchorPoint   = "LEFT",        
      },
    },
    
    --BOSSFRAMES
    boss = {
      show = true,
      scale = 1,
      pos = { a1 = "TOP", a2 = "BOTTOM", af = "Minimap", x = 0, y = -80 }, 
      health = {
        texture = "Interface\\AddOns\\rTextures\\statusbar5",
        tag = "[perhp]%",
      },
      power = {
        texture = "Interface\\AddOns\\rTextures\\statusbar5",
        tag = "[perpp]%",
      },
    },
    
  }

  ----------------------------------------
  -- player specific data
  ----------------------------------------

  --player stuff
  local playername, _     = UnitName("player")
  local _, playerclass    = UnitClass("player")
  local playercolor       = rRAID_CLASS_COLORS[playerclass] or RAID_CLASS_COLORS[playerclass]
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
