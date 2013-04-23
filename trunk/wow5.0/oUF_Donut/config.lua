
  ---------------------------------------------
  -- oUF_Donut
  -- zork, 2013
  ---------------------------------------------

  --get the addon namespace
  local addon, ns = ...

  --object container
  local cfg = {}
  ns.cfg = cfg

  ----------------------------------------
  -- config
  ----------------------------------------

  cfg.units = {
    --PLAYER
    player = {
      enable = true,
      scale = 0.5,
      template = "default",
    },

    --TARGET
    target = {
      enable = true,
      scale = 0.5,
      template = "default",
    },
  }

  ----------------------------------------
  -- other
  ----------------------------------------

  --font
  cfg.font = STANDARD_TEXT_FONT
  cfg.numberFont = STANDARD_TEXT_FONT

  --player data
  cfg.playerName  = UnitName("player")
  cfg.playerClass = select(2,UnitClass("player"))
  cfg.playerColor = RAID_CLASS_COLORS[cfg.playerclass]

  --backdrop
  cfg.backdrop = {
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 },
  }
