
  ---------------------------------------------
  --  oUF_Diablo
  ---------------------------------------------

  --  A Diablo themed unitframe layout for oUF 1.6.x
  --  zork - 2012

  ---------------------------------------------

  --get the addon namespace
  local addon, ns = ...

  --object container
  local cfg = {}
  ns.cfg = cfg

  ---------------------------------------------
  -- // CONFIG // --
  ---------------------------------------------

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
  --units
  ----------------------------------------

  cfg.units = {
    -- PLAYER
    player = {
      show = true,
      size = 150,
      scale = 0.82,
      pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -260, y = -9 },
      health = {
        frequentUpdates = false,
        smooth = true,
      },
      power = {
        frequentUpdates = false,
        smooth = true,
      },
      absorb = {
        show = true,
        smooth = true,
      },
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
        hideDefault = true, --if you hide the oUF_Diablo castbar, should the Blizzard castbar be shown?
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
      totalabsorb = {
        show = true,
        texture = "Interface\\AddOns\\oUF_Diablo\\media\\absorb_statusbar_overlay",
        color = {
          bar  = {r = 0.7, g = 1, b = 1, a = 0.9 },
        },
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
        maxoverflow = 1.05,
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
      castbar = {
        show = false,
        hideDefault = true, --if you hide the oUF_Diablo castbar, should the Blizzard castbar be shown?
        texture = "Interface\\AddOns\\oUF_Diablo\\media\\statusbar256_2",
        scale = 1/0.85, --divide 1 by current unit scale if you want to prevent scaling of the castbar based on unit scale
        color = {
          bar = { r = 1, g = 0.7, b = 0, a = 1, },
          bg = { r = 0.1, g = 0.1, b = 0.1, a = 0.7, },
        },
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = 490 },
      },
      totalabsorb = {
        show = true,
        texture = "Interface\\AddOns\\oUF_Diablo\\media\\absorb_statusbar_overlay",
        color = {
          bar  = {r = 0.7, g = 1, b = 1, a = 0.9 },
        },
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
        show = true,
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
      totalabsorb = {
        show = true,
        texture = "Interface\\AddOns\\oUF_Diablo\\media\\absorb_statusbar_overlay",
        color = {
          bar  = {r = 0.7, g = 1, b = 1, a = 0.9 },
        },
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
        show            = false,
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
        show = true,
        texture = "Interface\\AddOns\\oUF_Diablo\\media\\statusbar",
        color = {
          myself  = {r = 0, g = 1, b = 0, a = 1 },
          other   = {r = 0, g = 1, b = 0, a = 0.7 },
        },
        maxoverflow = 1.05,
      },
      totalabsorb = {
        show = true,
        texture = "Interface\\AddOns\\oUF_Diablo\\media\\absorb_statusbar_overlay",
        color = {
          bar  = {r = 0.7, g = 1, b = 1, a = 0.9 },
        },
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
        show            = false,
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
      totalabsorb = {
        show = true,
        texture = "Interface\\AddOns\\oUF_Diablo\\media\\absorb_statusbar_overlay",
        color = {
          bar  = {r = 0.7, g = 1, b = 1, a = 0.9 },
        },
      },
    },

    --BOSSFRAMES
    boss = {
      show = true,
      scale = 1,
      pos = { a1 = "TOP", a2 = "BOTTOM", af = "Minimap", x = 0, y = -80 },
      health = {
        texture = "Interface\\AddOns\\oUF_Diablo\\media\\statusbar128_3",
        tag = "[diablo:bosshp]%",
      },
      power = {
        texture = "Interface\\AddOns\\oUF_Diablo\\media\\statusbar5",
        tag = "[diablo:bosspp]",
      },
    },

  }


  ----------------------------------------
  -- frame movement
  ----------------------------------------

  --setting this to false will use the default frame positions, true allows moving
  cfg.framesUserplaced = true

  --setting this to true will lock the frames in place, false unlocks them
  cfg.framesLocked = true

  ----------------------------------------
  -- player specific data
  ----------------------------------------

  --player stuff
  cfg.playername  = UnitName("player")
  cfg.playerclass = select(2,UnitClass("player"))
  cfg.playercolor = RAID_CLASS_COLORS[cfg.playerclass]

  ----------------------------------------
  -- other
  ----------------------------------------

  cfg.powercolors = PowerBarColor
  cfg.powercolors["MANA"] = { r = 0, g = 0.4, b = 1 }
  --fix the oUF mana color
  oUF.colors.power["MANA"] = {0, 0.4, 1}

  --font
  cfg.font = STANDARD_TEXT_FONT

  --backdrop
  cfg.backdrop = {
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 },
  }
