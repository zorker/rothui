
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

  --spawn bottombar backdrop
  rBBS:spawnBackdropFrame(addon, cfg.bottombar)
  --spawn chatframe backdrop
  rBBS:spawnBackdropFrame(addon, cfg.chatframe)
  --spawn dpsmeter backdrop
  rBBS:spawnBackdropFrame(addon, cfg.dpsmeter)
  --spawn threatmeter backdrop
  rBBS:spawnBackdropFrame(addon, cfg.threatmeter)