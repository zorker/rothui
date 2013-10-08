
  -----------------------------
  -- INIT
  -----------------------------

  --get the addon namespace
  local addon, ns = ...
  local cfg = ns.cfg

  -----------------------------
  -- CHARSPECIFIC REWRITES
  -----------------------------

  local playername, _ = UnitName("player")
  local _, playerclass = UnitClass("player")

  if playername == "Rothar" or playername == "Zork" or playername == "Loral" then
    cfg.bars.stancebar.enable = false
    cfg.bars.bar2.mouseover.enable = false
    cfg.bars.bar3.mouseover.enable = false
    cfg.bars.bar4.mouseover.fadeOut.alpha = 0
    cfg.bars.bags.mouseover.fadeOut.alpha = 0
    cfg.bars.micromenu.mouseover.fadeOut.alpha = 0
  end

  if playername == "Lishi" then
    cfg.bars.bar1.uselayout2x6 = true
    cfg.bars.bar2.uselayout2x6 = true
    cfg.bars.bar4.mouseover.enable = false
    cfg.bars.bar5.mouseover.enable = false
  end
