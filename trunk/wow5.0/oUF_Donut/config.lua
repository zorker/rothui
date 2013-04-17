
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
    player = {
      enable = true,
      scale = 0.5,
      castbar = {
        scale = 0.9,
      },
      powerbar = {
        scale = 0.7,
      },
      healthbar = {
        scale = 0.5,
      },
    },
    target = {
      enable = true,
      scale = 1,
      castbar = {
        scale = 0.9,
      },
      powerbar = {
        scale = 0.7,
      },
      healthbar = {
        scale = 0.5,
      },
    },
  }

  ----------------------------------------
  -- other
  ----------------------------------------

  --font
  cfg.font = STANDARD_TEXT_FONT
  cfg.numberFont = "Interface\\AddOns\\UI-Tooltip-Background"

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
