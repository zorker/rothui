
  --rewrite specific global config values based on character data
  --example: use another party layout for healer etc.

  --get the addon namespace
  local addon, ns = ...

 --get the config
  local cfg = ns.cfg

  --example: my healer Loral should use the raidframes for party aswell
  if cfg.playername == "Loral" and cfg.playerclass == "DRUID" then
    --cfg.units.party.show = false
    --cfg.units.raid.pos = { a1 = "TOPLEFT", a2 = "TOPLEFT", af = "UIParent", x = 10, y = -10 },
    --cfg.units.raid.attributes.visibility = "custom [group:party][group:raid] show;hide"
    --cfg.units.raid.attributes.showPlayer = true
    --cfg.units.raid.attributes.showParty = true
    cfg.units.focus.auras.showBuffs = false
  end