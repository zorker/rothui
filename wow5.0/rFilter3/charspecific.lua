
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
        spellid = 112048, --shield barrier
        spec = 3,
        size = 32,
        pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -160, y = 0 },
        unit = "player",
        validate_unit   = true,
        ismine          = true,
        desaturate      = true,
        move_ingame     = true,
        hide_ooc        = false,
        show_value      = 1,
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
        spellid = 132365, --vengeance
        spec = 3,
        size = 32,
        pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -160, y = 45 },
        unit = "player",
        validate_unit   = true,
        ismine          = true,
        desaturate      = true,
        move_ingame     = true,
        hide_ooc        = false,
        show_value      = 1,
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
        spellid = 132404, --shield block
        spec = 3,
        size = 32,
        pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -160, y = -45 },
        unit = "player",
        validate_unit   = true,
        ismine          = true,
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
        spellid = 12880, --enrage
        spec = 3,
        size = 32,
        pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -205, y = 0 },
        unit = "player",
        validate_unit   = true,
        ismine          = true,
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
        spellid = 81326, --physical vulnerability
        spec = nil,
        size = 22,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -80, y = 110 },
        unit = "target",
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
    }

  --Rothars Cooldown List
    cfg.rf3_CooldownList = {
    }

  end
