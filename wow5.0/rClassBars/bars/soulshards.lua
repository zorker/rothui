
  ---------------------------------------------
  -- SOULSHARDS.lua
  ---------------------------------------------

  --check for class
  if select(2, UnitClass("player")) ~= "WARLOCK" then return end
  --get the addon namespace
  local addonName, ns = ...
  --check if module is enabled
  local cfg = ns.cfg.modules.soulshards
  
  if not cfg or (cfg and not cfg.enable) then return end

  ---------------------------------------------
  -- VARIABLES
  ---------------------------------------------

  cfg.POWER_TYPE_INDEX = SPELL_POWER_SOUL_SHARDS -- 7
  cfg.POWER_TYPE_TOKEN = "SOUL_SHARDS"
  cfg.REQ_SPEC         = SPEC_WARLOCK_AFFLICTION -- 1
  cfg.REQ_SPELL        = WARLOCK_SOULBURN
  cfg.MAX_ORBS         = 4
  cfg.ORB_TEXTURE      = "gem"

  ---------------------------------------------
  -- INIT
  ---------------------------------------------

  --init
  ns.lib.CreateOrbBar(addonName.."SoulShardBar", cfg)
