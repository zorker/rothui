
  ---------------------------------------------
  -- DEMONICFURY.lua
  ---------------------------------------------

  --check for class
  if select(2, UnitClass("player")) ~= "WARLOCK" then return end
  --get the addon namespace
  local addonName, ns = ...
  --check if module is enabled
  local cfg = ns.cfg.modules.demonicfury
  
  if not cfg or (cfg and not cfg.enable) then return end

  ---------------------------------------------
  -- VARIABLES
  ---------------------------------------------

  cfg.POWER_TYPE_INDEX = SPELL_POWER_DEMONIC_FURY
  cfg.POWER_TYPE_TOKEN = "DEMONIC_FURY"
  cfg.REQ_SPEC         = SPEC_WARLOCK_DEMONOLOGY
  cfg.REQ_SPELL        = nil
  cfg.BAR_TEXTURE      = "demonicfury"

  ---------------------------------------------
  -- INIT
  ---------------------------------------------

  --init
  ns.lib.CreateStatusBar(addonName.."DemonicFuryBar", cfg)
