
  -- // rFilter3
  -- // zork - 2012

  --get the addon namespace
  local addon, ns = ...

  --object container
  local cfg = CreateFrame("Frame")
  ns.cfg = cfg

  cfg.rf3_BuffList, cfg.rf3_DebuffList, cfg.rf3_CooldownList = {}, {}, {}

  local player_name, _ = UnitName("player")
  local _, player_class = UnitClass("player")

  -----------------------------
  -- CONFIG
  -----------------------------

  cfg.highlightPlayerSpells = true  --player spells will have a blue border
  cfg.updatetime            = 0.3   --how fast should the timer update itself
  cfg.timeFontSize          = 16
  cfg.countFontSize         = 18


  if player_class == "WARRIOR" then
    --Rothars Buff List
    cfg.rf3_BuffList = {
      [1] = {
        spec = nil,
        spellid = 469, --commanding shout
        spelllist = {
          469, 6307, 90364,
        },
        size = 24,
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
    }

    --Rothars Debuff List
    cfg.rf3_DebuffList = {}

  --Rothars Cooldown List
    cfg.rf3_CooldownList = {
      [1] = {
        spec = nil,
        visibility_state = "[stance:2] show; hide",
        spellid = 100, --charge
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 70, y = 107 },
        size = 24,
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
    }

  end
