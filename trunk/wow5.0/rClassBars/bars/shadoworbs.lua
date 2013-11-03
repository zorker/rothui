
  ---------------------------------------------
  -- HOLYPOWER.lua
  ---------------------------------------------

  --check for class
  if select(2, UnitClass("player")) ~= "PRIEST" then return end
  --get the addon namespace
  local addonName, ns = ...
  --check if module is enabled
  local cfg = ns.cfg.modules.shadoworbs
  
  if not cfg or (cfg and not cfg.enable) then return end

  ---------------------------------------------
  -- VARIABLES
  ---------------------------------------------

  cfg.POWER_TYPE_INDEX = SPELL_POWER_SHADOW_ORBS
  cfg.POWER_TYPE_TOKEN = "SHADOW_ORBS"
  cfg.REQ_SPEC         = SPEC_PRIEST_SHADOW
  cfg.REQ_SPELL        = nil
  cfg.MAX_ORBS         = 3
  --cfg.ORB_TEXTURE      = "orb"

  ---------------------------------------------
  -- INIT
  ---------------------------------------------

  --init
  ns.lib.CreateOrbBar(addonName.."ShadowOrbsBar", cfg)
