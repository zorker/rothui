
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

  --spawn the drag frame
  local dragframe = rBBS:spawnDragFrame(addon, cfg.dragframe)
  --spawn actionbar background
  rBBS:spawnFrame(addon, cfg.actionbarbg, dragframe)
  --spawn angel
  rBBS:spawnFrame(addon, cfg.angel, dragframe)
  --spawn demon
  rBBS:spawnFrame(addon, cfg.demon, dragframe)
