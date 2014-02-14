
  --addonName and namespace
  local addonName, ns = ...

  --container
  local cfg = {}
  ns.cfg = cfg

  ---------------------------------------------
  -- CONFIG
  ---------------------------------------------

  --player
  cfg.player = {}
  cfg.player.name  = UnitName("player")
  cfg.player.class = select(2,UnitClass("player"))
  cfg.player.color = RAID_CLASS_COLORS[cfg.playerclass]

  --media path
  cfg.mediaPath = "Interface\\AddOns\\"..addonName.."\\media\\"
  
  --font
  cfg.font = cfg.mediaPath.."ExpresswayRg.ttf"