
  ---------------------------------------------
  -- BURNINGEMBERS.lua
  ---------------------------------------------

  --check for class
  if select(2, UnitClass("player")) ~= "WARLOCK" then return end
  --get the addon namespace
  local addonName, ns = ...
  --check if module is enabled
  local cfg = ns.cfg.modules.burningembers
  
  if not cfg or (cfg and not cfg.enable) then return end

  ---------------------------------------------
  -- VARIABLES
  ---------------------------------------------

  cfg.POWER_TYPE_INDEX = SPELL_POWER_BURNING_EMBERS
  cfg.POWER_TYPE_TOKEN = "BURNING_EMBERS"
  cfg.REQ_SPEC         = SPEC_WARLOCK_DESTRUCTION
  cfg.REQ_SPELL        = nil
  cfg.MAX_ORBS         = 4
  cfg.ORB_TEXTURE      = "pot"
  cfg.ORB_SIZE_FACTOR       = 0.8
  cfg.ORB_FILL_SIZE_FACTOR  = 0.8

  ---------------------------------------------
  -- INIT
  ---------------------------------------------

  --init
  ns.lib.CreateOrbBar(addonName.."BurningEmbersBar", cfg)
