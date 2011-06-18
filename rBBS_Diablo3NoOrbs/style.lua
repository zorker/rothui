  
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
  
  --spawn actionbar background
  rBBS:spawnFrame(addon, cfg.actionbarbg)
  --spawn angel
  rBBS:spawnFrame(addon, cfg.angel)
  --spawn demon
  rBBS:spawnFrame(addon, cfg.demon)  
