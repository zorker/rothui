
  -- // rFilter3
  -- // zork - 2012

  --get the addon namespace
  local addon, ns = ...

  --object container
  local cfg = CreateFrame("Frame")
  ns.cfg = cfg

  cfg.rf3_BuffList, cfg.rf3_DebuffList, cfg.rf3_CooldownList = {}, {}, {}

  --local player_name, _ = UnitName("player")
  local _, player_class = UnitClass("player")

  -----------------------------
  -- DEFAULT CONFIG
  -----------------------------

  cfg.highlightPlayerSpells = true  --player spells will have a blue border
  cfg.updatetime            = 0.1   --how fast should the timer update itself
  cfg.timeFontSize          = 15
  cfg.countFontSize         = 18

  --warrior defaults
  if player_class == "WARRIOR" then
    --default warrior buffs
    cfg.rf3_BuffList = {}
    --default warrior debuffs
    cfg.rf3_DebuffList = {}
    --default warrior cooldowns
    cfg.rf3_CooldownList = {}
  end

  --rogue defaults
  if player_class == "ROGUE" then
    --default rogue buffs
    cfg.rf3_BuffList = {}
    --default rogue debuffs
    cfg.rf3_DebuffList = {}
    --default rogue cooldowns
    cfg.rf3_CooldownList = {}
  end
