  
  -- // oUF tutorial layout
  -- // zork - 2010
  
  --get the addon namespace
  local addon, ns = ...
  
  --get the config values
  local cfg = ns.cfg
  --get the library
  local lib = ns.lib

  -----------------------------
  -- STYLE FUNCTIONS
  -----------------------------

  local function genStyle(self)
    lib.init(self)
    lib.moveme(self)
    lib.gen_hpbar(self)
    lib.gen_hpstrings(self)
    lib.gen_ppbar(self)
  end

  --the player style
  local function CreatePlayerStyle(self)
    --style specific stuff
    self.width = 250
    self.height = 25
    self.scale = 1
    self.mystyle = "player"
    genStyle(self)
    self.Health.frequentUpdates = true
    self.Health.colorClass = true
    self.Health.bg.multiplier = 0.3
    self.Power.colorPower = true
    self.Power.bg.multiplier = 0.3
  end  
  
  --the target style
  local function CreateTargetStyle(self)
    --style specific stuff
    self.width = 250
    self.height = 25
    self.scale = 1
    self.mystyle = "target"
    genStyle(self)
    self.Health.frequentUpdates = true
    self.Health.colorTapping = true
    self.Health.colorDisconnected = true
    self.Health.colorHappiness = true
    self.Health.colorClass = true
    self.Health.colorReaction = true
    self.Health.colorHealth = true
    self.Health.bg.multiplier = 0.3
    self.Power.colorPower = true
    self.Power.bg.multiplier = 0.3
  end  

  -----------------------------
  -- SPAWN UNITS
  -----------------------------

  if cfg.showplayer then
    oUF:RegisterStyle("oUF_SimplePlayer", CreatePlayerStyle)
    oUF:SetActiveStyle("oUF_SimplePlayer")
    oUF:Spawn("player", "oUF_Simple_PlayerFrame")  
  end
  
  if cfg.showtarget then
    oUF:RegisterStyle("oUF_SimpleTarget", CreateTargetStyle)
    oUF:SetActiveStyle("oUF_SimpleTarget")
    oUF:Spawn("target", "oUF_Simple_TargetFrame")  
  end