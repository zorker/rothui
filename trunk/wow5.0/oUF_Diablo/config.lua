
  ---------------------------------------------
  --  oUF_Diablo
  ---------------------------------------------

  --  A Diablo themed unitframe layout for oUF 1.6.x
  --  zork - 2012

  ---------------------------------------------

  --get the addon namespace
  local addon, ns = ...

  --object container
  local cfg = CreateFrame("Frame")
  ns.cfg = cfg

  ---------------------------------------------
  -- // CONFIG // --
  ---------------------------------------------

  ----------------------------------------
  -- orb animation system
  ----------------------------------------

  --make this value true to enable the animation system
  --animations use preset colors, so class and stance coloring is not possible, but you may change the animation based on class in the charspecific.lua
  cfg.useAnimationSystem = true --true/false

  -- defines the animation used in the orbs, following animations are available
  -- 0  red fog           1  purple fog           2  green fog            3  yellow fog         4  turquoise fog
  -- 5  red portal        6  blue rune portal     7  red ghost            8  purple ghost       9  water planet
  -- 10 swirling cloud    11 white fog            12 red glowing eye      13 sandy swirl        14 green fire
  -- 15 purple swirl      16 white tornado        17 blue swirly          18 orange fog         19 pearl
  -- 20 red magnet        21 blue portal          22 purple portal        23 dwarf artifact     24 burning blob
  -- 25 fire              26 rolling purple       27 magic swirl          28 poison bubbles     29 cthun eye
  -- 30 soulshard purple  31 the planet

  --health animation
  cfg.animhealth = 20 --default 7
  --power animation
  cfg.animmana = 21 --default 8

  --set your class specific settings here, you can even activate automatic class and powertype coloring
  --BEWARE enabling class or powertype coloring will disable the selected animation, instead always the pearl animation is used internally
  --it is the only animation that can be colored in some kind of fashion
  --muliplier: is a setting that will be multiplied with the alpha value of the animation (to make it a bit less attracting)
  --decrease alpha on value: by default the alpha of an animation is multiplied with the value (to make it fade once you loose hp or mana) but in some cases you don't want that, so that value can disable that
  cfg.animClassOverride = {
    ["DEATHKNIGHT"]   = { enable = true, animhealth = 13, animmana = 4,   classcolored = true,  powertypecolored = true,  healthmultiplier = 0.5,  manamultiplier = 1,  healthdecreasealpha = true, manadecreasealpha = true, },
    ["DRUID"]         = { enable = true, animhealth = 18, animmana = 9,   classcolored = true,  powertypecolored = true,  healthmultiplier = 0.4,  manamultiplier = 0.4,  healthdecreasealpha = false, manadecreasealpha = false, },
    ["HUNTER"]        = { enable = true, animhealth = 20,  animmana = 6,  classcolored = false, powertypecolored = false, healthmultiplier = 0.13,    manamultiplier = 0.13,    healthdecreasealpha = true,  manadecreasealpha = true,  },
    ["MAGE"]          = { enable = true, animhealth = 4,  animmana = 6,   classcolored = true,  powertypecolored = true, healthmultiplier = 0.4,  manamultiplier = 0.4,    healthdecreasealpha = true, manadecreasealpha = true,  },
    ["MONK"]          = { enable = true, animhealth = 4,  animmana = 6,   classcolored = true,  powertypecolored = true, healthmultiplier = 0.4,  manamultiplier = 0.4,    healthdecreasealpha = true, manadecreasealpha = true,  },
    ["ROGUE"]         = { enable = true, animhealth = 3,  animmana = 22,  classcolored = false, powertypecolored = true,  healthmultiplier = 1,    manamultiplier = 0.3,  healthdecreasealpha = true,  manadecreasealpha = false, },
    ["PRIEST"]        = { enable = true, animhealth = 19, animmana = 11,  classcolored = false, powertypecolored = false, healthmultiplier = 1,    manamultiplier = 1,    healthdecreasealpha = true,  manadecreasealpha = true,  },
    ["PALADIN"]       = { enable = true, animhealth = 1,  animmana = 17,  classcolored = false, powertypecolored = false, healthmultiplier = 1,    manamultiplier = 1,    healthdecreasealpha = true,  manadecreasealpha = true,  },
    ["SHAMAN"]        = { enable = true, animhealth = 16, animmana = 15,  classcolored = false, powertypecolored = false, healthmultiplier = 1,    manamultiplier = 1,    healthdecreasealpha = true,  manadecreasealpha = true,  },
    --["WARRIOR"]       = { enable = true, animhealth = 2,  animmana = 0,  classcolored = true, powertypecolored = true, healthmultiplier = 0.4,    manamultiplier = 0.4,  healthdecreasealpha = true,  manadecreasealpha = true,  },
    ["WARRIOR"]       = { enable = true, animhealth = 23,  animmana = 20,  classcolored = false, powertypecolored = false, healthmultiplier = 1,    manamultiplier = 1,  healthdecreasealpha = true,  manadecreasealpha = true,  },
    ["WARLOCK"]       = { enable = true, animhealth = 26, animmana = 9,  classcolored = false, powertypecolored = false, healthmultiplier = 1,    manamultiplier = 1,    healthdecreasealpha = true,  manadecreasealpha = true,  },
  }

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
  --0 = random, 1 = moon, 2 = earth, 3 = mars, 4 = galaxy, 5 = jupiter, 6 = fraktal_circle, 7 = sun, 8 = icecream, 9 = marble, 10 = gradient, 11 = bubbles, 12 = woodpepples, 13 = golf, 14 = dmars, 15 = diablo3
  cfg.healthtexture = 16 --default 15

  --the texture of the mana orb. you can choose between 11 different textures.
  --0 = random, 1 = moon, 2 = earth, 3 = mars, 4 = galaxy, 5 = jupiter, 6 = fraktal_circle, 7 = sun, 8 = icecream, 9 = marble, 10 = gradient, 11 = bubbles, 12 = woodpepples, 13 = golf, 14 = dmars, 15 = diablo3
  cfg.manatexture = 16 --default 15

  if cfg.useAnimationSystem == true then
    --rewrite to a more plain texture (better for animation models)
    cfg.healthtexture = 14
    cfg.manatexture = 14
  end

  ----------------------------------------
  -- colorswitcher define your color for healthbars here
  ----------------------------------------

  --color is in RGB (red (r), green (g), blue (b), alpha (a)), values are from 0 (dark color) to 1 (bright color). 1,1,1 = white / 0,0,0 = black / 1,0,0 = red etc
  cfg.colorswitcher = {
    bright              = { r = 1, g = 0, b = 0, a = 0.9, },          -- the bright color
    dark                = { r = 0.1, g = 0.1, b = 0.1, a = 0.7, },   -- the dark color
    classcolored        = true,  -- true   -> override the bright color with the unit specific color (class, faction, happiness, threat), if false uses the predefined color
    useBrightForeground = true,  -- true   -> use bright color in foreground and dark color in background
                                 -- false  -> use dark color in foreground and bright color in background
    threatColored       = true,  -- true/false -> enable threat coloring of the health plate for raidframes
  }

  --frames have a new highlight that fades on hp loss, if that is still not enough you can adjust a multiplier here
  cfg.highlightMultiplier = 0 --range 0-1

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
        texture = "Interface\\AddOns\\oUF_Diablo\\media\\statusbar256_2",
        scale = 1/0.82, --divide 1 by current unit scale if you want to prevent scaling of the castbar based on unit scale
        color = {
          bar = { r = 1, g = 0.7, b = 0, a = 1, },
          bg = { r = 0.1, g = 0.1, b = 0.1, a = 0.7, },
        },
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = 180.5 },
      },
      demonicfury = { --class bar WARLOCK / DEMONOLOGY
        show = true,
        scale = 0.7,
        color = {
          bar = { r = 114/255, g = 192/255, b = 48/255, },
          bg  = { r = 50/255, g = 40/255, b = 40/255, },
        },
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = 400 },
        combat          = { --fade the bar in/out in combat/out of combat
          enable          = false,
          fadeIn          = {time = 0.4, alpha = 1},
          fadeOut         = {time = 0.3, alpha = 0.2},
        },
      },
      soulshards = { --class bar WARLOCK / AFFLICTION
        show = true,
        scale = 0.40,
        color = {r = 200/255, g = 0/255, b = 255/255, },
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = 650 },
        combat          = { --fade the bar in/out in combat/out of combat
          enable          = false,
          fadeIn          = {time = 0.4, alpha = 1},
          fadeOut         = {time = 0.3, alpha = 0.2},
        },
      },
      burningembers = { --class bar WARLOCK / DESTRUCTION
        show = true,
        scale = 0.40,
        color = {r = 255/255, g = 133/255, b = 0/255, },
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = 650 },
        combat          = { --fade the bar in/out in combat/out of combat
          enable          = false,
          fadeIn          = {time = 0.4, alpha = 1},
          fadeOut         = {time = 0.3, alpha = 0.2},
        },
      },
      holypower = { --class bar PALADIN
        show = true,
        scale = 0.40,
        color = {r = 200/255, g = 135/255, b = 190/255, },
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = 650 },
        combat          = { --fade the bar in/out in combat/out of combat
          enable          = false,
          fadeIn          = {time = 0.4, alpha = 1},
          fadeOut         = {time = 0.3, alpha = 0.2},
        },
      },
      shadoworbs = { --class bar SHADOW PRIEST
        show = true,
        scale = 0.40,
        color = {r = 80/255, g = 20/255, b = 130/255, },
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = 650 },
        combat          = { --fade the bar in/out in combat/out of combat
          enable          = false,
          fadeIn          = {time = 0.4, alpha = 1},
          fadeOut         = {time = 0.3, alpha = 0.2},
        },
      },
      harmony = { --class bar MONK
        show = true,
        scale = 0.40,
        color = {r = 41/255, g = 209/255, b = 157/255, },
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = 650 },
        combat          = { --fade the bar in/out in combat/out of combat
          enable          = false,
          fadeIn          = {time = 0.4, alpha = 1},
          fadeOut         = {time = 0.3, alpha = 0.2},
        },
      },
      eclipse = { --class bar DRUID
        show = true,
        scale = 0.7,
        color = {
          solar = { r = 255/255, g = 200/255, b = 0/255, },
          lunar = { r = 0/255, g = 255/255, b = 255/255, },
          bg  = { r = 50/255, g = 40/255, b = 40/255, },
        },
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = 400 },
        combat          = { --fade the bar in/out in combat/out of combat
          enable          = false,
          fadeIn          = {time = 0.4, alpha = 1},
          fadeOut         = {time = 0.3, alpha = 0.2},
        },
      },
      runes = { --class bar DK
        show = true,
        scale = 0.40,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = 650 },
        combat          = { --fade the bar in/out in combat/out of combat
          enable          = false,
          fadeIn          = {time = 0.4, alpha = 1},
          fadeOut         = {time = 0.3, alpha = 0.2},
        },
      },
      altpower = {
        show = true,
        scale = 0.5,
        color = {r = 1, g = 0, b = 1, },
        texture = "Interface\\AddOns\\oUF_Diablo\\media\\statusbar",
        pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = 0, y = 0 },
      },
      vengeance = {
        show = false,
        scale = 0.7,
        color = {r = 1, g = 0, b = 0, },
        texture = "Interface\\AddOns\\oUF_Diablo\\media\\statusbar5",
        pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = 0, y = 0 },
      },
      expbar = { --experience
        show = true,
          pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = 10 },
          texture = "Interface\\AddOns\\oUF_Diablo\\media\\statusbar",
          scale = 1,
          color = {r = 0.8, g = 0, b = 0.8, },
          rested = {
            color = {r = 1, g = 0.7, b = 0, },
          },
      },
      repbar = { --reputation
        show = true,
          pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = 10 },
          texture = "Interface\\AddOns\\oUF_Diablo\\media\\statusbar",
          scale = 1,
      },
      art = {
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
        texture = "Interface\\AddOns\\oUF_Diablo\\media\\statusbar256_3",
        tag = "[diablo:hpval]",
      },
      power = {
        texture = "Interface\\AddOns\\oUF_Diablo\\media\\statusbar",
        tag = "", --more tags see oUF/elements/tags.lua | example: "[curpp] / [perpp]%" or "[diablo:ppval]"
      },
      auras = {
        show = true,
        size = 20,
        onlyShowPlayerBuffs = false,
        onlyShowPlayerDebuffs = false,
        showDebuffType = false,
        desaturateDebuffs = false,
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
        texture = "Interface\\AddOns\\oUF_Diablo\\media\\statusbar256_2",
        scale = 1/1, --divide 1 by current unit scale if you want to prevent scaling of the castbar based on unit scale
        color = {
          bar = { r = 1, g = 0.7, b = 0, a = 1, },
          bg = { r = 0.1, g = 0.1, b = 0.1, a = 0.7, },
          shieldbar = { r = 0.5, g = 0.5, b = 0.5, a = 1, }, --the castbar color while target casting a shielded spell
          shieldbg = { r = 0.1, g = 0.1, b = 0.1, a = 0.7, },  --the castbar background color while target casting a shielded spell
        },
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = 350 },
      },
      combobar = {
        show = true,
        scale = 0.35,
        color = {r = 0.9, g = 0.59, b = 0, },
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = 650 },
      },
      portrait = {
        pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = 100, y = 0 },
        size = 150,
        show = false,
        use3D = true,
      },
      healprediction = {
        show = false,
        texture = "Interface\\AddOns\\oUF_Diablo\\media\\statusbar",
        color = {
          myself  = {r = 0, g = 1, b = 0, a = 1 },
          other   = {r = 0, g = 1, b = 0, a = 0.7 },
        },
        maxoverflow = 1.05,
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
        texture = "Interface\\AddOns\\oUF_Diablo\\media\\statusbar128_3",
        tag = "[diablo:misshp]",
      },
      power = {
        texture = "Interface\\AddOns\\oUF_Diablo\\media\\statusbar5",
      },
      healprediction = {
        show = false,
        texture = "Interface\\AddOns\\oUF_Diablo\\media\\statusbar",
        color = {
          myself  = {r = 0, g = 1, b = 0, a = 1 },
          other   = {r = 0, g = 1, b = 0, a = 0.7 },
        },
        maxoverflow = 1.00,
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
        texture = "Interface\\AddOns\\oUF_Diablo\\media\\statusbar128_3",
        tag = "[diablo:misshp]",
      },
      power = {
        texture = "Interface\\AddOns\\oUF_Diablo\\media\\statusbar5",
      },
      altpower = {
        show = true,
        scale = 0.5,
        color = {r = 1, g = 0, b = 1, },
        texture = "Interface\\AddOns\\oUF_Diablo\\media\\statusbar",
        pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = 0, y = 0 },
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
      aurawatch = {
        show            = true,
        size            = 20,
      },
      auras = {
        show = false,
        size = 22,
        onlyShowPlayerDebuffs = false,
        showDebuffType = false,
        showBuffs = true,
        onlyShowPlayerBuffs = false,
        showBuffType = false,
      },
      health = {
        texture = "Interface\\AddOns\\oUF_Diablo\\media\\statusbar128_3",
        tag = "[diablo:misshp]",
      },
      power = {
        texture = "Interface\\AddOns\\oUF_Diablo\\media\\statusbar5",
      },
      portrait = {
        show = true,
        use3D = true,
      },
      castbar = {
        show = true,
        texture = "Interface\\AddOns\\oUF_Diablo\\media\\statusbar256_2",
        scale = 1/0.85, --divide 1 by current unit scale if you want to prevent scaling of the castbar based on unit scale
        color = {
          bar = { r = 1, g = 0.7, b = 0, a = 1, },
          bg = { r = 0.1, g = 0.1, b = 0.1, a = 0.7, },
        },
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = 420 },
      },
      healprediction = {
        show = false,
        texture = "Interface\\AddOns\\oUF_Diablo\\media\\statusbar",
        color = {
          myself  = {r = 0, g = 1, b = 0, a = 1 },
          other   = {r = 0, g = 1, b = 0, a = 0.7 },
        },
        maxoverflow = 1.05,
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
        texture = "Interface\\AddOns\\oUF_Diablo\\media\\statusbar128_3",
        tag = "[diablo:misshp]",
      },
      power = {
        texture = "Interface\\AddOns\\oUF_Diablo\\media\\statusbar5",
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
        texture = "Interface\\AddOns\\oUF_Diablo\\media\\statusbar128_3",
        tag = "[diablo:misshp]",
      },
      power = {
        texture = "Interface\\AddOns\\oUF_Diablo\\media\\statusbar5",
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
      scale = 0.82,
      pos = { a1 = "TOPLEFT", a2 = "TOPLEFT", af = "UIParent", x = 5, y = -77 },
      aurawatch = {
        show            = true,
        size            = 20.1,
      },
      auras = {
        show = true,
        size = 22,
        onlyShowPlayerDebuffs = false,
        showDebuffType = false,
      },
      health = {
        texture = "Interface\\AddOns\\oUF_Diablo\\media\\statusbar128_3",
        tag = "[diablo:misshp]",
      },
      power = {
        texture = "Interface\\AddOns\\oUF_Diablo\\media\\statusbar5",
      },
      portrait = {
        show = true,
        use3D = true,
      },
      attributes = {
        visibility          = "custom [group:party,nogroup:raid] show;hide",  --show this header in party
        showPlayer          = true,     --make this true to show player in party
        showSolo            = false,    --make this true to show while solo (only works if solo is in visiblity aswell
        showParty           = true,     --make this true to show headerin party
        showRaid            = false,    --show in raid
        point               = "LEFT",
      },
      healprediction = {
        show = false,
        texture = "Interface\\AddOns\\oUF_Diablo\\media\\statusbar",
        color = {
          myself  = {r = 0, g = 1, b = 0, a = 1 },
          other   = {r = 0, g = 1, b = 0, a = 0.7 },
        },
        maxoverflow = 1.05,
      },
    },

    --RAID
    raid = {
      show = true,
      special = {
        chains = true, --should the raidframe include the chain textures?
      },
      alpha = {
        notinrange = 0.4,
      },
      scale = 0.95,
      pos = { a1 = "TOPLEFT", a2 = "TOPLEFT", af = "UIParent", x = 5, y = -5 },
      health = {
        texture = "Interface\\AddOns\\oUF_Diablo\\media\\statusbar128_3",
        tag = "[diablo:misshp]",   --tag for the second line
      },
      aurawatch = {
        show            = true,
      },
      auras = {
        --put every single spellid here that you want to be tracked, be it buff or debuff doesn't matter
        --maximum number of icons displayed at a time = 1
        --this is for important boss mechanics only, this is not for tracking healing HOTs etc
        whitelist = {
          --test
          --6673,--test1, battle shout
          --72968,--test2
          --93805,--test3
          32407,
          --CATACLYSM RAIDS
          86622,
          --maloriak
          92980, --ice bomb
          77786, --red phase consuming flames
          --chimaeron
          89084 , --skull icon chimaeron <10k life
        },
        show            = false,
        disableCooldown = true,
        showBuffType    = false,
        showDebuffType  = false,
        size            = 12,
        num             = 5,
        spacing         = 3,
        pos = { a1 = "CENTER", x = 0, y = -9},
      },
      attributes = {
        visibility1         = "custom [@raid11,exists] hide;[group:raid] show; hide", --use "party,raid" to show this in party aswell
        visibility2         = "custom [@raid26,exists] hide; [@raid11,exists] show; hide", --special display for raid > 20 players (lower scale)
        visibility3         = "custom [@raid26,exists] show; hide", --special display for raid > 30 players (lower scale)
        showPlayer          = false,  --make this true to show player in party
        showSolo            = false,  --make this true to show while solo (only works if solo is in visiblity aswell
        showParty           = false,  --make this true to show raid in party
        showRaid            = true,   --show in raid
        point               = "TOP",
        yOffset             = 15,
        xoffset             = 0,
        maxColumns          = 8,
        unitsPerColumn      = 5,
        columnSpacing       = -20,
        columnAnchorPoint   = "LEFT",
      },
      healprediction = {
        show = false,
        texture = "Interface\\AddOns\\oUF_Diablo\\media\\statusbar",
        color = {
          myself  = {r = 0, g = 1, b = 0, a = 1 },
          other   = {r = 0, g = 1, b = 0, a = 0.7 },
        },
        maxoverflow = 1.05,
      },
    },

    --BOSSFRAMES
    boss = {
      show = true,
      scale = 1,
      pos = { a1 = "TOP", a2 = "BOTTOM", af = "Minimap", x = 0, y = -80 },
      health = {
        texture = "Interface\\AddOns\\oUF_Diablo\\media\\statusbar128_3",
        tag = "[perhp]%",
      },
      power = {
        texture = "Interface\\AddOns\\oUF_Diablo\\media\\statusbar5",
        tag = "[diablo:bosspp]",
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
    [1] = {r = 0.9, g = 0.3, b = 0.1, }, -- red
    [2] = {r = 0.25, g = 0.9, b = 0.25, }, -- green
    [3] = {r = 0, g = 0.35,   b = 0.9, }, -- blue
    [4] = {r = 0.9, g = 0.8, b = 0.35, }, -- yellow
    [5] = {r = 0.35, g = 0.9,   b = 0.9, }, -- runic
  }

  --orb animation table
  cfg.animtab = {
    [0] = {displayid = 17010, r = 255/255, g = 0/255, b = 0/255, camdistancescale = 1.1, portraitzoom = 1, x = 0, y = -0.6, rotation = 0, },          -- red fog
    [1] = {displayid = 17054, r = 1, g = 0.4, b = 1, camdistancescale = 1.1, portraitzoom = 1, x = 0, y = -0.6, rotation = 0, },      -- purple fog
    [2] = {displayid = 17055, r = 0/255, g = 150/255, b = 0/255, camdistancescale = 1.1, portraitzoom = 1, x = 0, y = -0.6, rotation = 0, },        -- green fog
    [3] = {displayid = 17286, r = 1, g = 0.9, b = 0, camdistancescale = 1.1, portraitzoom = 1, x = 0, y = -0.6, rotation = 0, },        -- yellow fog
    [4] = {displayid = 18075, r = 0, g = 0.8, b = 1, camdistancescale = 1.1, portraitzoom = 1, x = 0, y = -0.6, rotation = 0, },        -- turquoise fog
    [5] = {displayid = 23422, r = 0.4, g = 0, b = 0, camdistancescale = 2.8, portraitzoom = 1, x = 0, y = 0.1, rotation = 0, },         -- red portal
    [6] = {displayid = 27393, r = 0, g = 0.4, b = 1, camdistancescale = 3, portraitzoom = 1, x = 0, y = 0.6, rotation = 0, },           -- blue rune portal
    [7] = {displayid = 20894, r = 0.6, g = 0, b = 0, camdistancescale = 6, portraitzoom = 1, x = -0.3, y = 0.4, rotation = 0, },        -- red ghost
    [8] = {displayid = 15438, r = 0, g = 0.3, b = 0.6, camdistancescale = 6, portraitzoom = 1, x = -0.3, y = 0.4, rotation = 0, },        -- purple ghost
    [9] = {displayid = 20782, r = 0, g = 0.7, b = 1, camdistancescale = 1.2, portraitzoom = 1, x = -0.22, y = 0.18, rotation = 0, },    -- water planet
    [10] = {displayid = 23310, r = 1, g = 1, b = 1, camdistancescale = 3.5, portraitzoom = 1, x = 0, y = 3, rotation = 0, },          -- swirling cloud
    [11] = {displayid = 23343, r = 0.8, g = 0.8, b = 0.8, camdistancescale = 1.6, portraitzoom = 1, x = -0.2, y = 0, rotation = 0, },      -- white fog
    [12] = {displayid = 24813, r = 0.4, g = 0, b = 0, camdistancescale = 2.4, portraitzoom = 1.1, x = 0, y = -0.3, rotation = 0, },     -- red glowing eye
    [13] = {displayid = 25392, r = 0.4, g = 0.6, b = 0, camdistancescale = 2.6, portraitzoom = 1, x = 0, y = -0.5, rotation = 0, },     -- sandy swirl
    [14] = {displayid = 27625, r = 0.4, g = 0.6, b = 0, camdistancescale = 0.8, portraitzoom = 1, x = 0, y = 0, rotation = 0, },        -- green fire
    [15] = {displayid = 28460, r = 0.5, g = 0, b = 1, camdistancescale = 0.56, portraitzoom = 1, x = -0.4, y = 0, rotation = 0, },    -- purple swirl
    [16] = {displayid = 29286, r = 1, g = 1, b = 1, camdistancescale = 0.6, portraitzoom = 1, x = -0.6, y = -0.2, rotation = 0, },      -- white tornado
    [17] = {displayid = 29561, r = 0, g = 0.6, b = 1, camdistancescale = 2.5, portraitzoom = 1, x = 0, y = 0, rotation = -3.9, },     -- blue swirly
    [18] = {displayid = 30660, r = 1, g = 0.5, b = 0, camdistancescale = 0.12, portraitzoom = 1, x = -0.04, y = -0.08, rotation = 0, }, -- orange fog
    [19] = {displayid = 32368, r = 1, g = 1, b = 1, camdistancescale = 1.15, portraitzoom = 1, x = 0, y = 0.4, rotation = 0, },        -- pearl
    [20] = {displayid = 33853, r = 1, g = 0, b = 0, camdistancescale = 0.83, portraitzoom = 1, x = 0, y = -0.05, rotation = 0, },       -- red magnet
    [21] = {displayid = 34319, r = 0, g = 0, b = 0.4, camdistancescale = 1.55, portraitzoom = 1, x = 0, y = 0.8, rotation = 0, },       -- blue portal
    [22] = {displayid = 34645, r = 0.3, g = 0, b = 0.3, camdistancescale = 1.7, portraitzoom = 1, x = 0, y = 0.8, rotation = 0, },      -- purple portal
    [23] = {displayid = 38699, r = 253/255, g = 58/255, b = 12/255, camdistancescale = 0.28, portraitzoom = 0, x = 0, y = 0, rotation = 0, },         -- dwarf floarting artifact (red glow)
    [24] = {displayid = 38548, r = 253/255, g = 58/255, b = 12/255, camdistancescale = 0.8, portraitzoom = 0, x = -0.1, y = -0.1, rotation = 0, },    -- burning blob from hell
    [25] = {displayid = 38327, r = 253/255, g = 58/255, b = 12/255, camdistancescale = 3.35, portraitzoom = 0, x = -0.3, y = -7, rotation = -9.4, },  -- fire
    [26] = {displayid = 39108, r = 106/255, g = 48/255, b = 158/255, camdistancescale = 0.8, portraitzoom = 0, x = 0, y = 0, rotation = 0, },         -- top down rotation purple (warlock color)
    [27] = {displayid = 39581, r = 76/255, g = 141/255, b = 195/255, camdistancescale = 3.5, portraitzoom = 0, x = 0, y = 2, rotation = 0, },         -- magic swirl
    [28] = {displayid = 37939, r = 86/255, g = 129/255, b = 49/255, camdistancescale = 1, portraitzoom = 0, x = 0, y = 2, rotation = 0, },            -- poison bubbles
    [29] = {displayid = 37867, r = 93/255, g = 52/255,  b = 92/255, camdistancescale = 0.75, portraitzoom = 0, x = 0, y = 0.8, rotation = 0, },       -- cthun eye
    [30] = {displayid = 45414, r = 0.85, g = 0.28,  b = 1, camdistancescale = 0.25, portraitzoom = 0, x = 0, y = -0.22, rotation = 0, },       -- soulshard purple portal
    [31] = {displayid = 44652, r = 0.7, g = 1,  b = 0.85, camdistancescale = 0.65, portraitzoom = 0, x = 0.05, y = 0.01, rotation = 0, },       -- the planet
  }

  cfg.powercolors = PowerBarColor
  cfg.powercolors["MANA"] = { r = 0, g = 0.4, b = 1 }

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
