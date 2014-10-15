
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
    cfg.units.target.healprediction.show = true
    cfg.units.focus.healprediction.show = true
  end

  --cfg.units.party.show                  = false
  --cfg.units.raid.attributes.visibility  = "custom [group] show; hide"
  --cfg.units.raid.attributes.showPlayer  = true
  --cfg.units.raid.attributes.showSolo    = false
  --cfg.units.raid.attributes.showParty   = true

  --[[ ORBS ONLY EXAMPLE
  -- PLAYER
  cfg.units.player.show                           = true
  cfg.units.player.icons.pvp.show                 = false
  cfg.units.player.icons.combat.show              = false
  cfg.units.player.icons.resting.show             = false
  cfg.units.player.castbar.show                   = false
  cfg.units.player.demonicfury.show               = false
  cfg.units.player.soulshards.show                = false
  cfg.units.player.burningembers.show             = false
  cfg.units.player.holypower.show                 = false
  cfg.units.player.shadoworbs.show                = false
  cfg.units.player.harmony.show                   = false
  cfg.units.player.eclipse.show                   = false
  cfg.units.player.runes.show                     = false
  cfg.units.player.altpower.show                  = false
  cfg.units.player.vengeance.show                 = false
  cfg.units.player.expbar.show                    = false
  cfg.units.player.repbar.show                    = false
  cfg.units.player.art.actionbarbackground.show   = false
  cfg.units.player.art.angel.show                 = false
  cfg.units.player.art.demon.show                 = false
  cfg.units.player.art.bottomline.show            = false
  cfg.units.player.portrait.show                  = false
  --OTHER UNITS
  cfg.units.target.show                           = false
  cfg.units.targettarget.show                     = false
  cfg.units.pet.show                              = false
  cfg.units.focus.show                            = false
  cfg.units.pettarget.show                        = false
  cfg.units.focustarget.show                      = false
  cfg.units.party.show                            = false
  cfg.units.raid.show                             = false
  cfg.units.boss.show                             = false
  ]]--