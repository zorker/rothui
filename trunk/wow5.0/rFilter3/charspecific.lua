
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

  if player_name == "Rothar" and player_class == "WARRIOR" then
    --Rothars Buff List
    cfg.rf3_BuffList = {
      [1] = {
        spellid = 469, --commanding shout
        spelllist = {
          469, 6307, 90364, 21562,
        },
        spec = nil,
        size = 22,
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
        spellid = 6673, --battle shout
        spelllist = {
          6673, 57330, 93435,
        },
        spec = nil,
        size = 22,
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
    }

    --Rothars Debuff List
    cfg.rf3_DebuffList = {
      [1] = {
        spellid         = 115767, --deep wound
        spec            = nil,
        --visibility_state = "[stance:2] show; hide",
        pos             = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -130, y = 107 },
        size            = 22,
        unit            = "target",
        desaturate      = true,
        ismine          = true,
        move_ingame     = true,
        hide_ooc        = true,
        validate_unit   = true,
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
        spellid         = 113746, --physical invul
        spec            = nil,
        --visibility_state = "[stance:2] show; hide",
        pos             = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -100, y = 107 },
        size            = 22,
        unit            = "target",
        desaturate      = true,
        ismine          = true,
        move_ingame     = true,
        hide_ooc        = true,
        validate_unit   = true,
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
        spellid         = 115798, --physical invul
        spec            = nil,
        --visibility_state = "[stance:2] show; hide",
        pos             = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -70, y = 107 },
        size            = 22,
        unit            = "target",
        desaturate      = true,
        ismine          = true,
        move_ingame     = true,
        hide_ooc        = true,
        validate_unit   = true,
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
        spellid           = 100, --charge
        spec              = 3,
        visibility_state  = "[stance:2] show; hide",
        pos               = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 70, y = 107 },
        size              = 22,
        desaturate        = true,
        move_ingame       = true,
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
    }

  end

  if player_name == "Lilu" and player_class == "ROGUE" then

    print("Loading rFilter spell config for "..player_name)

    -- Buff List
    cfg.rf3_BuffList = {
      [1] = {
        spec = nil,
        spellid = 73651, -- Recuperate
        size = 20,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -108, y = 485 },
        unit = "player",
        validate_unit   = true,
        ismine          = true,
        hide_ooc        = false,
        desaturate      = true,
        match_spellid   = false,
        move_ingame     = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.0,
            icon = 0.6,
          },
        },
      },
      [2] = {
        spec = nil,
        spellid = 5171, -- SnD
        size = 20,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -138, y = 485 },
        unit            = "player",
        ismine          = false,
        hide_ooc        = false,
        desaturate      = true,
        match_spellid   = false,
        move_ingame     = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.0,
            icon = 0.6,
          },
        },
      },
      [3] = {
        spec            = nil,
        spellid         = 74001, -- CombatReadiness
        size            = 20,
        pos             = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -112, y = 510 },
        unit            = "player",
        ismine          = true,
        hide_ooc        = false,
        desaturate      = true,
        match_spellid   = false,
        move_ingame     = true,
        alpha           = {
          found = {
            frame       = 1,
            icon        = 1,
          },
          not_found = {
            frame       = 0.0,
            icon        = 0.6,
          },
        },
      },
      [4] = {
        spec = nil,
        spellid = 13877, -- Blade Flurry
        size = 24,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -138, y = 570 },
        unit = "player",
        ismine = true,
        hide_ooc = false,
        desaturate = true,
        move_ingame = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.0,
            icon = 0.6,
          },
        },
      },
      [5] = {
        spec = nil,
        spellid = 1966, -- Feint
        size = 24,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -178, y = 570 },
        unit = "player",
        ismine = true,
        hide_ooc = false,
        desaturate = true,
        move_ingame = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.0,
            icon = 0.6,
          },
        },
      },
      [6] = {
        spec = nil,
        spellid = 13750, -- AR/Dance
        spelllist = {
            [1] = 13750,
            [2] = 51713,
                },
        size = 24,
        pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -218, y = 570 },
        unit = "player",
        ismine = true,
        hide_ooc = false,
        desaturate = true,
        move_ingame     = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.0,
            icon = 0.6,
          },
        },
      },
    }

    -- Debuff List
    cfg.rf3_DebuffList = {
      [1] = {
        spec = nil,
        spellid = 1943, -- Rupture
        size = 20,
        pos           = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 108, y = 485 },
        unit          = "target",
        validate_unit = true,
        hide_ooc      = true,
        ismine        = true,
        desaturate    = true,
        move_ingame     = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.0,
            icon = 0.6,
          },
        },
      },
      [2] = {
        spec = nil,
        spellid = 2818, -- DeadlyPoison
        size = 20,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 138, y = 485 },
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
            frame = 0.0,
            icon = 0.6,
          },
        },
      },
      [3] = {
        spec = nil,
        spellid = 56807, -- Glyph of Hemorrhage
        size = 20,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 168, y = 485 },
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
            frame = 0.0,
            icon = 0.6,
          },
        },
      },
    }
  end