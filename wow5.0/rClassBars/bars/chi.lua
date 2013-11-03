
  ---------------------------------------------
  -- HOLYPOWER.lua
  ---------------------------------------------

  --check for class
  if select(2, UnitClass("player")) ~= "MONK" then return end
  --get the addon namespace
  local addonName, ns = ...
  --check if module is enabled
  local cfg = ns.cfg.modules.chi
  
  if not cfg or (cfg and not cfg.enable) then return end

  ---------------------------------------------
  -- VARIABLES
  ---------------------------------------------

  cfg.POWER_TYPE_INDEX = SPELL_POWER_CHI
  cfg.POWER_TYPE_TOKEN = "CHI"
  cfg.REQ_SPEC         = nil
  cfg.REQ_SPELL        = nil
  cfg.MAX_ORBS         = 5
  --cfg.ORB_TEXTURE      = "orb"

  ---------------------------------------------
  -- INIT
  ---------------------------------------------

  --init
  ns.lib.CreateOrbBar(addonName.."ChiBar", cfg)
