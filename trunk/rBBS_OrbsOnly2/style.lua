  
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
  
  
  --spawn player health orb
  rBBS:spawnHealthOrb(addon, cfg.playerhealthorb)
  --spawn player power orb
  rBBS:spawnPowerOrb(addon, cfg.playerpowerorb)

  --spawn target health orb
  rBBS:spawnHealthOrb(addon, cfg.targethealthorb)  
  --spawn target power orb
  rBBS:spawnPowerOrb(addon, cfg.targetpowerorb)