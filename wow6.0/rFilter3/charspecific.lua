
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

  if player_name == "Zörk" and player_class == "WARRIOR" then
    --Rothars Buff List
    cfg.rf3_BuffList = {
      {
        spellid = 12880, --enrage
        spec = nil,
        size = 32,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -210, y = 130 },
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
            frame = 0,
            icon = 1,
          },
        },
      },
      {
        spellid = 469, -- +10% STA
        isRaidBuff = true,
        raidBuffIndex = 2,
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
      {
        spellid = 6673, -- +10% AP / RAP
        isRaidBuff = true,
        raidBuffIndex = 3,
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
      {
        spellid = 112048, --shield barrier
        spec = 3,
        size = 28,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -98, y = 110 },
        unit = "player",
        validate_unit   = true,
        ismine          = true,
        desaturate      = true,
        move_ingame     = true,
        --hide_ooc        = true,
        show_value      = 1,
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
      {
        spellid = 132404, --shield block
        spec = 3,
        size = 28,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -136, y = 110 },
        unit = "player",
        validate_unit   = true,
        ismine          = true,
        desaturate      = true,
        move_ingame     = true,
        --hide_ooc        = true,
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
      {
        spellid = 169667, --shield charge
        spec = 3,
        size = 28,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -136, y = 110 },
        unit = "player",
        validate_unit   = true,
        ismine          = true,
        desaturate      = true,
        move_ingame     = true,
        --hide_ooc        = true,
        show_value      = 1,
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
      {
        spellid = 152277, --ravager
        spec = 3,
        size = 28,
        pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = 0, y = 0 },
        unit = "player",
        validate_unit   = true,
        ismine          = true,
        desaturate      = true,
        move_ingame     = true,
        --hide_ooc        = true,
        show_value      = 1,
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
      {
        spellid = 871, --shield wall
        spec = 3,
        size = 28,
        pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = 0, y = 0 },
        unit = "player",
        validate_unit   = true,
        ismine          = true,
        desaturate      = true,
        move_ingame     = true,
        --hide_ooc        = true,
        show_value      = 1,
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
      {
        spellid = 12975, --last stand
        spec = 3,
        size = 28,
        pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = 0, y = 0 },
        unit = "player",
        validate_unit   = true,
        ismine          = true,
        desaturate      = true,
        move_ingame     = true,
        --hide_ooc        = true,
        show_value      = 1,
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
      {
        spellid = 55694, --enraged regen
        spec = 3,
        size = 28,
        pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = 0, y = 0 },
        unit = "player",
        validate_unit   = true,
        ismine          = true,
        desaturate      = true,
        move_ingame     = true,
        --hide_ooc        = true,
        show_value      = 1,
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
      --[[
      {
        spellid = 115767, --deep wounds
        spec = nil,
        size = 22,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 75, y = 110 },
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
      ]]--
      {
        spellid = 132168, --shockwave
        spec = 3,
        size = 28,
        pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = 0, y = 0 },
        unit = "target",
        validate_unit   = true,
        ismine          = true,
        desaturate      = true,
        move_ingame     = true,
        --hide_ooc        = true,
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
      {
        spellid = 1160, --demo shout
        spec = 3,
        size = 28,
        pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = 0, y = 0 },
        unit = "target",
        validate_unit   = true,
        ismine          = true,
        desaturate      = true,
        move_ingame     = true,
        --hide_ooc        = true,
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
  
  if player_name == "Needler" and player_class == "HUNTER" then
    --Needler Buff List
    cfg.rf3_BuffList = {
      {
        spellid = 118455, --beast cleave
        spec = nil,
        size = 32,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -210, y = 130 },
        unit = "pet",
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
            frame = 0,
            icon = 1,
          },
        },
      },
      {
        spellid = 177668, --steady focus
        spec = nil,
        size = 32,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -210, y = 130 },
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
            frame = 0,
            icon = 1,
          },
        },
      },
    }
    
    --Needler Debuff List
    cfg.rf3_DebuffList = {
      {
        spellid = 3674, --black arrow
        spec = nil,
        size = 32,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -210, y = 130 },
        unit = "target",
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
            frame = 0,
            icon = 1,
          },
        },
      },
    }
    

  end
