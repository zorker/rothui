
  -----------------------------
  -- INIT
  -----------------------------

  --get the addon namespace
  local addon, ns = ...
  local cfg = ns.cfg

  -----------------------------
  -- CHARSPECIFIC REWRITES
  -----------------------------

  local player_name, _ = UnitName("player")
  local _, player_class = UnitClass("player")

  -- this file allows you to override default class settings with special settings for your own character
  -- ATTENTION: if you character name contains UTF-8 characters like âôû and such. Make sure this files is saved in UTF-8 file format

  if player_name == "Zork" and player_class == "WARRIOR" then
    --Rothars Buff List
    cfg.rf3_BuffList = {
      [1] = {
        spellid = 12880, --enrage
        spec = nil,
        size = 22,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 80, y = 110 },
        unit = "player",
        validate_unit   = true,
        ismine          = true,
        desaturate      = true,
        move_ingame     = true,
        hide_ooc        = true,
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
        spellid = 469, -- +10% STA
        spelllist = { 469, 90364, 6307, 21562, 103127, },
        spec = nil,
        size = 22,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 140, y = 110 },
        unit = "player",
        validate_unit   = true,
        ismine          = false,
        desaturate      = true,
        move_ingame     = true,
        hide_ooc        = false,
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
        spellid = 6673, -- +10% AP / RAP
        spelllist = { 6673, 57330, 19506, },
        spec = nil,
        size = 22,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 110, y = 110 },
        unit = "player",
        validate_unit   = true,
        ismine          = false,
        desaturate      = true,
        move_ingame     = true,
        hide_ooc        = false,
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
        spellid = 112048, --shield barrier
        spec = 3,
        size = 30,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 44, y = 150 },
        unit = "player",
        validate_unit   = true,
        ismine          = true,
        desaturate      = true,
        move_ingame     = true,
        hide_ooc        = true,
        show_value      = 1,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.2,
            icon = 0.6,
          },
        },
      },
      [5] = {
        spellid = 132365, --vengeance
        spec = 3,
        size = 30,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -44, y = 150 },
        unit = "player",
        validate_unit   = true,
        ismine          = true,
        desaturate      = true,
        move_ingame     = true,
        hide_ooc        = true,
        show_value      = 1,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.2,
            icon = 0.6,
          },
        },
      },
      [6] = {
        spellid = 132404, --shield block
        spec = 3,
        size = 36,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = 147 },
        unit = "player",
        validate_unit   = true,
        ismine          = true,
        desaturate      = true,
        move_ingame     = true,
        hide_ooc        = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.2,
            icon = 0.6,
          },
        },
      },
      --[[
      [7] = {
        spellid = 1126, -- +5% STR, AGI, INT
        spelllist = { 1126, 115921, 20217, 90363, },
        spec = nil,
        size = 22,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 80, y = 110 },
        unit = "player",
        validate_unit   = true,
        ismine          = false,
        desaturate      = true,
        move_ingame     = true,
        hide_ooc        = false,
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
      [8] = {
        spellid = 19740, -- +3000 MASTERY
        spelllist = { 19740, 116956, 93435, 128997, },
        spec = nil,
        size = 22,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 50, y = 110 },
        unit = "player",
        validate_unit   = true,
        ismine          = false,
        desaturate      = true,
        move_ingame     = true,
        hide_ooc        = false,
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
      [9] = {
        spellid = 1459, -- +5% crit
        spelllist = { 1459, 17007, 61316, 116781, 97229, 24604, 90309, 126373, 126309, },
        spec = nil,
        size = 22,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 20, y = 110 },
        unit = "player",
        validate_unit   = true,
        ismine          = false,
        desaturate      = true,
        move_ingame     = true,
        hide_ooc        = false,
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
        spellid = 131116, --raging blow stack
        spec = 2,
        size = 40,
        framestrata = "BACKGROUND",
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -60, y = 150 },
        unit = "player",
        validate_unit   = true,
        ismine          = true,
        desaturate      = true,
        move_ingame     = true,
        hide_ooc        = true,
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
        spellid = 85739, --metzger
        spec = 2,
        size = 40,
        framestrata = "BACKGROUND",
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 60, y = 150 },
        unit = "player",
        validate_unit   = true,
        ismine          = true,
        desaturate      = true,
        move_ingame     = true,
        hide_ooc        = true,
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
      ]]--
      --[[
      [6] = {
        spellid = 125831, --taste for blood
        spec = 1,
        size = 50,
        framestrata = "BACKGROUND",
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -80, y = 150 },
        unit = "player",
        validate_unit   = true,
        ismine          = true,
        desaturate      = true,
        move_ingame     = true,
        hide_ooc        = true,
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
      [7] = {
        spellid = 85730, --deadly calm
        spec = nil,
        size = 40,
        framestrata = "BACKGROUND",
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -90, y = 145 },
        unit = "player",
        validate_unit   = true,
        ismine          = true,
        desaturate      = true,
        move_ingame     = true,
        hide_ooc        = true,
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
      ]]--
    }

    --Rothars Debuff List
    cfg.rf3_DebuffList = {
      [1] = {
        spellid = 115798, --weakened blows
        spec = nil,
        size = 22,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -140, y = 110 },
        unit = "target",
        validate_unit   = true,
        ismine          = false,
        desaturate      = true,
        move_ingame     = true,
        hide_ooc        = true,
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
        spellid = 113746, --weakened armor
        spec = nil,
        size = 22,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -110, y = 110 },
        unit = "target",
        validate_unit   = true,
        ismine          = false,
        desaturate      = true,
        move_ingame     = true,
        hide_ooc        = true,
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
        spellid = 81326, --physical vulnerability
        spec = nil,
        size = 22,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -80, y = 110 },
        unit = "target",
        validate_unit   = true,
        ismine          = false,
        desaturate      = true,
        move_ingame     = true,
        hide_ooc        = true,
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
        spellid = 115767, --deep wounds
        spec = nil,
        size = 22,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -50, y = 110 },
        unit = "target",
        validate_unit   = true,
        ismine          = true,
        desaturate      = true,
        move_ingame     = true,
        hide_ooc        = true,
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
        spellid = 86346, --colossus
        spec = 1,
        size = 50,
        framestrata = "BACKGROUND",
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = 150 },
        unit = "target",
        validate_unit   = true,
        ismine          = true,
        desaturate      = true,
        move_ingame     = true,
        hide_ooc        = true,
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

  --Rothars Cooldown List
    cfg.rf3_CooldownList = {
      [1] = {
        spellid = 118000, --dragon roar
        spelllist = { 118000, 46968, 46924, },
        --spec = 1,
        size = 50,
        framestrata = "LOW",
        pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = 0, y = 0 },
        desaturate      = true,
        move_ingame     = true,
        hide_ooc        = false,
        alpha = {
          cooldown = {
            frame = 0.5,
            icon = 0.6,
          },
          no_cooldown = {
            frame = 1,
            icon = 1,
          },
        },
      },
      --[[[2] = {
        spellid = 6544, --leap
        spec = 2,
        size = 50,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -35, y = 150 },
        desaturate      = true,
        move_ingame     = true,
        hide_ooc        = true,
        alpha = {
          cooldown = {
            frame = 0,
            icon = 0.6,
          },
          no_cooldown = {
            frame = 1,
            icon = 1,
          },
        },
      },]]--
    }

  end
