
  -- // rFilter3
  -- // zork - 2010

  --get the addon namespace
  local addon, ns = ...
  
  --object container
  local cfg = CreateFrame("Frame") 
  
  cfg.rf3_BuffList, cfg.rf3_DebuffList, cfg.rf3_CooldownList = {}, {}, {}
  
  local player_name, _ = UnitName("player")
  local _, player_class = UnitClass("player")
  
  local spec = GetActiveTalentGroup()
  
  cfg.spec = spec
  
  -----------------------------
  -- CONFIG
  -----------------------------  
  
  cfg.highlightPlayerSpells = true

  --now with spec possible.
  -- 1 is your first spec
  -- 2 is your second spec
  
  if player_name == "Rothar" and player_class == "WARRIOR" and (spec == 1 or spec == 2) then
  
    --Rothars Buff List
  
    cfg.rf3_BuffList = {
      [1] = {
        spellid = 469, --commanding shout
        spelllist = { --check a list instead because other classes can do the same
          [1] = 469,
          [2] = 79105,
          [3] = 6307,
          [4] = 90364,
        },
        size = 26,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 130, y = 107 },
        unit = "player",
        ismine = false,
        desaturate = true,
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
        spellid = 6673, --battle shout
        spelllist = { --check a list instead because other classes can do the same
          [1] = 6673,
          [2] = 57330,
          [3] = 8076,
          [4] = 93435,
        },
        size = 26,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 100, y = 107 },
        unit = "player",
        ismine = false,
        desaturate = true,
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
        spellid = 18499, --berserker rage
        size = 26,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 130, y = 138 },
        unit = "player",
        ismine = true,
        desaturate = true,
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
      [4] = {
        spellid = 2565, --shield block
        size = 26, 
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -130, y = 138 },
        unit = "player",
        ismine = true,
        desaturate = true,
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
        spellid = 87096, --thunderclap dps boost
        size = 26, 
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -100, y = 138 },
        unit = "player",
        ismine = true,
        desaturate = true,
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
    
    --Rothars Debuff List
    
    cfg.rf3_DebuffList = {
      [1] = {
        spellid = 58567, --sunder armor
        spelllist = { --check a list instead because other classes can do the same
          [1] = 58567,
          [2] = 91565,
          [3] = 8647,
          [4] = 95467,
          [5] = 95466,
        },
        size = 26,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -130, y = 107},
        unit = "target",
        ismine = false,
        desaturate = true,
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
        spellid = 6343, --thunderclap
        spelllist = { --check a list instead because other classes can do the same
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
        ismine = false,
        desaturate = true,
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
        spellid = 1160, --demo shout
        spelllist = { --check a list instead because other classes can do the same
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
        ismine = false,
        desaturate = true,
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
        spellid = 772, --rend
        size = 26,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -70, y = 107 },
        unit = "target",
        ismine = true,
        desaturate = true,
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
    }
  
  --Rothars Cooldown List
    cfg.rf3_CooldownList = {
      [1] = {
        spellid = 100, --charge
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 70, y = 107 },
        size = 26,
        unit = "target",
        desaturate = true,
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
        spellid = 20252, --intercept
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 70, y = 107 },
        size = 26,
        unit = "target",
        desaturate = true,
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
  
  -----------------------------
  -- HANDOVER
  -----------------------------
  
  --object container to addon namespace
  ns.cfg = cfg