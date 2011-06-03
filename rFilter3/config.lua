
  -- // rFilter3
  -- // zork - 2010

  --get the addon namespace
  local addon, ns = ...
  
  --object container
  local cfg = CreateFrame("Frame") 
  
  cfg.rf3_BuffList, cfg.rf3_DebuffList, cfg.rf3_CooldownList = {}, {}, {}
  
  local player_name, _ = UnitName("player")
  local _, player_class = UnitClass("player")
  
  -----------------------------
  -- CONFIG
  -----------------------------  
  
  cfg.highlightPlayerSpells = true  --player spells will have a blue border
  cfg.updatetime            = 0.2   --how fast should the timer update itself

  if player_name == "Rothar" and player_class == "WARRIOR" then
    --Rothars Buff List  
    cfg.rf3_BuffList = {
      [1] = {
        spec = nil, 
        spellid = 469, --commanding shout
        spelllist = {
          [1] = 469,
          [2] = 79105,
          [3] = 6307,
          [4] = 90364,
        },
        size = 26,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 130, y = 107 },
        unit = "player",
        validate_unit   = true,
        ismine          = false,
        desaturate      = true,
        match_spellid   = false,
        move_ingame     = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.4,
            icon = 0.6,          
          },
        },
      },
      [2] = {
        spec = nil, 
        spellid = 6673, --battle shout
        spelllist = {
          [1] = 6673,
          [2] = 57330,
          [3] = 8076,
          [4] = 93435,
        },
        size = 26,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 100, y = 107 },
        unit            = "player",
        ismine          = false,
        desaturate      = true,
        match_spellid   = false,
        move_ingame     = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.4,
            icon = 0.6,          
          },
        },
      },
      [3] = {
        spec            = 2, 
        spellid         = 2565, --shield block
        size            = 26, 
        pos             = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -130, y = 138 },
        unit            = "player",
        ismine          = true,
        desaturate      = true,
        match_spellid   = false,
        move_ingame     = true,
        alpha           = {
          found = {
            frame       = 1,
            icon        = 1,
          },
          not_found = {
            frame       = 0,
            icon        = 0.6,          
          },
        },
      },
      [4] = {
        spec = 2, 
        spellid = 87096, --thunderclap dps boost
        size = 26, 
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -100, y = 138 },
        unit = "player",
        ismine = true,
        desaturate = true,
        move_ingame     = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0,
            icon = 0.6,          
          },
        },
      },
      [5] = {
        spec = 1, 
        spellid = 60503, --overpower
        size = 36, 
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -65, y = 142 },
        unit = "player",
        ismine = true,
        desaturate = true,
        move_ingame     = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0,
            icon = 0,          
          },
        },
      },
     
      
    }
    
    --Rothars Debuff List
    
    cfg.rf3_DebuffList = {
      [1] = {
        spec = nil, 
        spellid = 58567, --sunder armor
        spelllist = {
          [1] = 58567,
          [2] = 91565,
          [3] = 8647,
          [4] = 95467,
          [5] = 95466,
        },
        size          = 26,
        pos           = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -130, y = 107},
        unit          = "target",
        validate_unit = true,
        hide_ooc      = true,
        ismine        = false,
        desaturate    = true,
        move_ingame     = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.4,
            icon = 0.6,          
          },
        },
      },
      [2] = {
        spec = nil, 
        spellid = 6343, --thunderclap
        spelllist = {
          [1] = 6343,
          [2] = 55095,
          [3] = 58180,
          [4] = 68055,
          [5] = 8042,
          [6] = 90315,
          [7] = 54404,
        },
        size = 26,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -100, y = 107 },
        unit = "target",
        validate_unit = true,
        hide_ooc      = true,
        ismine = false,
        desaturate = true,
        move_ingame     = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.4,
            icon = 0.6,          
          },
        },
      },
      [3] = {
        spec = nil, 
        spellid = 1160, --demo shout
        spelllist = {
          [1] = 1160,
          [2] = 81130,
          [3] = 99,
          [4] = 26017,
          [5] = 702,
          [6] = 50256,
          [7] = 24423,
        },
        size = 26,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -40, y = 107 },
        unit = "target",
        validate_unit = true,
        hide_ooc      = true,
        ismine = false,
        desaturate = true,
        move_ingame     = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.4,
            icon = 0.6,          
          },
        },
      },
      [4] = {
        spec = nil, 
        spellid = 772, --rend
        size = 26,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -70, y = 107 },
        unit = "target",
        validate_unit = true,
        hide_ooc      = true,
        ismine = true,
        desaturate = true,
        move_ingame     = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.4,
            icon = 0.6,          
          },
        },
      },
      [5] = {
        spec            = 1, 
        spellid         = 86346, --colossus smash
        size            = 50, 
        pos             = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -117, y = 142 },
        unit            = "target",
        validate_unit   = true,
        hide_ooc        = true,
        ismine          = true,
        desaturate      = true,
        move_ingame     = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0,
            icon = 0,          
          },
        },
      },

    }
  
  --Rothars Cooldown List
    cfg.rf3_CooldownList = {
      [1] = {
        spec = nil, 
        spellid = 100, --charge
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 70, y = 107 },
        size = 26,
        desaturate = true,
        move_ingame     = true,
        alpha = {
          cooldown = {
            frame = 1,
            icon = 0.6,
          },
          no_cooldown = {
            frame = 1,
            icon = 1,          
          },
        },
      },
      --[[
      [2] = {
        spec = nil, 
        spellid = 20252, --intercept
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 70, y = 107 },
        size = 26,
        desaturate = true,
        move_ingame     = true,
        alpha = {
          cooldown = {
            frame = 1,
            icon = 0.6,
          },
          no_cooldown = {
            frame = 1,
            icon = 1,          
          },
        },
      },
      ]]--
    }
    
  end
  
  if player_name == "Wolowizard" and player_class == "MAGE" then
    cfg.rf3_DebuffList = {
      [1] = {
        spec = nil, 
        spellid = 36032, --arcane blast debuff
        size = 32, 
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -150, y = 173 },
        unit = "player",
        ismine = false,
        desaturate = true,
        move_ingame     = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0,
            icon = 0.6,          
          },
        },
      },
    }
  end
  
  -----------------------------
  -- HANDOVER
  -----------------------------
  
  --object container to addon namespace
  ns.cfg = cfg