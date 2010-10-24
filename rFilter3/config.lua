
  -- // rFilter3
  -- // zork - 2010

  --get the addon namespace
  local addon, ns = ...
  
  --object container
  local cfg = CreateFrame("Frame") 
  
  cfg.rf3_BuffList, cfg.rf3_DebuffList = {}, {}
  
  local player_name, _ = UnitName("player")
  local _, player_class = UnitClass("player")
  
  -----------------------------
  -- CONFIG
  -----------------------------  
  
  if player_name == "Rothar" and player_class == "WARRIOR" then
  
    --Rothars Buff List
  
    cfg.rf3_BuffList = {
      [1] = {
        spellid = 469, --commanding shout
        size = 36,
        unit = "player",
        desaturate = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.5,
            icon = 0.6,          
          },
        },
      },
      [2] = {
        spellid = 6673, --battle shout
        size = 36,
        unit = "player",
        desaturate = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.5,
            icon = 0.6,          
          },
        },
      },
      [3] = {
        spellid = 18499, --berserker rage
        size = 36,
        unit = "player",
        desaturate = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.5,
            icon = 0.6,          
          },
        },
      },
      [4] = {
        spellid = 2565, --shield block
        size = 36,
        unit = "player",
        desaturate = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.5,
            icon = 0.6,          
          },
        },
      },
    }
    
    --Rothars Debuff List
    
    cfg.rf3_DebuffList = {
      [1] = {
        spellid = 58567, --sunder armor
        size = 36,
        unit = "target",
        desaturate = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.5,
            icon = 0.6,          
          },
        },
      },
      [2] = {
        spellid = 6343, --thunderclap
        size = 36,
        unit = "target",
        desaturate = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.5,
            icon = 0.6,          
          },
        },
      },
      [3] = {
        spellid = 1160, --demo shout
        size = 36,
        unit = "target",
        desaturate = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.5,
            icon = 0.6,          
          },
        },
      },
      [4] = {
        spellid = 772, --rend
        size = 36,
        unit = "target",
        desaturate = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.5,
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