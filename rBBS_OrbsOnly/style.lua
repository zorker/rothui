  
  ---------------------------------
  -- INIT
  ---------------------------------
  
  --get the addon namespace
  local addon, ns = ...
  --get rBBS namespace
  local rBBS = ns.rBBS or rBBS 
  --get the cfg
  local cfg = ns.cfg

  ---------------------------------
  -- SPAWN
  ---------------------------------
  
  
  --spawn health orb
  rBBS:spawnHealthOrb(addon, cfg.healthorb)

  --spawn power orb
  rBBS:spawnPowerOrb(addon, cfg.powerorb)
