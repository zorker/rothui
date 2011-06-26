
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
  --spawn actionbar bg 1
  rBBS:spawnFrame(addon, cfg.actionbarbg1, dragframe)
  --spawn actionbar bg 2
  rBBS:spawnFrame(addon, cfg.actionbarbg2, dragframe)
  --spawn health orb
  rBBS:spawnHealthOrb(addon, cfg.healthorb, dragframe)
  --spawn power orb
  rBBS:spawnPowerOrb(addon, cfg.powerorb, dragframe)
  --spawn figureleft
  rBBS:spawnFrame(addon, cfg.figureleft, dragframe)
  --spawn figureright
  rBBS:spawnFrame(addon, cfg.figureright, dragframe)
