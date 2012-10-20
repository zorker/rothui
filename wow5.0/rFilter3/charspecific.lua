
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
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 130, y = 107 },
        unit = "player",
        validate_unit   = true,
        ismine          = true,
        desaturate      = true,
        move_ingame     = true,
        show_value      = 1,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.4,
            icon = 1,
          },
        },
      },
      [2] = {
        spellid = 132365, --vengeance
        spec = 3,
        size = 32,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 130, y = 107 },
        unit = "player",
        validate_unit   = true,
        ismine          = true,
        desaturate      = true,
        move_ingame     = true,
        show_value      = 1,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.4,
            icon = 1,
          },
        },
      },
    }

    --Rothars Debuff List
    cfg.rf3_DebuffList = {
    }

  --Rothars Cooldown List
    cfg.rf3_CooldownList = {
    }

  end
