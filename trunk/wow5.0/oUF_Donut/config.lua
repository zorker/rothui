
  ---------------------------------------------
  --  oUF_Donut
  ---------------------------------------------

  --get the addon namespace
  local addon, ns = ...

  --object container
  local cfg = {}
  ns.cfg = cfg

  ----------------------------------------
  -- config
  ----------------------------------------

  cfg.units = {}

  --player stuff
  cfg.player = {}
  cfg.player.name  = UnitName("player")
  cfg.player.class = select(2,UnitClass("player"))
  cfg.player.color = RAID_CLASS_COLORS[cfg.playerclass]

  ----------------------------------------
  -- other
  ----------------------------------------

  --font
  cfg.font = STANDARD_TEXT_FONT

  --backdrop
  cfg.backdrop = {
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 },
  }
