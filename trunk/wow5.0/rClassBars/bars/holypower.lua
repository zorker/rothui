
  ---------------------------------------------
  -- HOLYPOWER.lua
  ---------------------------------------------

  --check for class
  if select(2, UnitClass("player")) ~= "PALADIN" then return end
  --get the addon namespace
  local addonName, ns = ...
  --check if module is enabled
  local cfg = ns.cfg.modules.holypower
  
  if not cfg or (cfg and not cfg.enable) then return end

  ---------------------------------------------
  -- VARIABLES
  ---------------------------------------------

  cfg.POWER_TYPE_INDEX = SPELL_POWER_HOLY_POWER
  cfg.POWER_TYPE_TOKEN = "HOLY_POWER"
  cfg.REQ_SPEC         = nil
  cfg.REQ_SPELL        = nil
  cfg.MAX_ORBS         = 5
  --cfg.ORB_TEXTURE      = "orb"

  ---------------------------------------------
  -- INIT
  ---------------------------------------------

  --init
  ns.lib.CreateOrbBar(addonName.."HolyPowerBar", cfg)
