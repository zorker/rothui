  
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
    self.scale = 0.8
    self.mystyle = "player"
    genStyle(self)
    self.Health.frequentUpdates = true
    self.Health.colorClass = true
    self.Health.bg.multiplier = 0.3
    self.Power.colorPower = true
    self.Power.bg.multiplier = 0.3
    lib.gen_castbar(self)
    lib.gen_portrait(self)
    lib.createBuffs(self)
    lib.createDebuffs(self)
  end  
  
  --the target style
  local function CreateTargetStyle(self)
    --style specific stuff
    self.width = 250
    self.height = 25
    self.scale = 0.8
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
    lib.gen_castbar(self)
    lib.gen_portrait(self)
    lib.createBuffs(self)
    lib.createDebuffs(self)
  end  
  
  --the tot style
  local function CreateToTStyle(self)
    --style specific stuff
    self.width = 150
    self.height = 25
    self.scale = 0.8
    self.mystyle = "tot"
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
    lib.createDebuffs(self)
  end 
  
  --the focus style
  local function CreateFocusStyle(self)
    --style specific stuff
    self.width = 180
    self.height = 25
    self.scale = 0.8
    self.mystyle = "focus"
    genStyle(self)
    self.Health.frequentUpdates = true
    self.Health.colorDisconnected = true
    self.Health.colorHappiness = true
    self.Health.colorClass = true
    self.Health.colorReaction = true
    self.Health.colorHealth = true
    self.Health.bg.multiplier = 0.3
    self.Power.colorPower = true
    self.Power.bg.multiplier = 0.3
    lib.gen_castbar(self)
    lib.gen_portrait(self)
    lib.createDebuffs(self)
  end  
  
  --the pet style
  local function CreatePetStyle(self)
    --style specific stuff
    self.width = 180
    self.height = 25
    self.scale = 0.8
    self.mystyle = "pet"
    genStyle(self)
    self.Health.frequentUpdates = true
    self.Health.colorDisconnected = true
    self.Health.colorHappiness = true
    self.Health.colorClass = true
    self.Health.colorReaction = true
    self.Health.colorHealth = true
    self.Health.bg.multiplier = 0.3
    self.Power.colorPower = true
    self.Power.bg.multiplier = 0.3
    lib.gen_castbar(self)
    lib.gen_portrait(self)
    lib.createDebuffs(self)
  end  

  --the party style
  local function CreatePartyStyle(self)
    --style specific stuff
    self.width = 180
    self.height = 25
    self.scale = 0.8
    self.mystyle = "party"
    genStyle(self)
    self.Health.frequentUpdates = true
    self.Health.colorDisconnected = true
    self.Health.colorHappiness = true
    self.Health.colorClass = true
    self.Health.colorReaction = true
    self.Health.colorHealth = true
    self.Health.bg.multiplier = 0.3
    self.Power.colorPower = true
    self.Power.bg.multiplier = 0.3
    lib.gen_portrait(self)
    lib.createDebuffs(self)
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

  if cfg.showtot then
    oUF:RegisterStyle("oUF_SimpleToT", CreateToTStyle)
    oUF:SetActiveStyle("oUF_SimpleToT")
    oUF:Spawn("targettarget", "oUF_Simple_ToTFrame")  
  end
  
  if cfg.showfocus then
    oUF:RegisterStyle("oUF_SimpleFocus", CreateFocusStyle)
    oUF:SetActiveStyle("oUF_SimpleFocus")
    oUF:Spawn("focus", "oUF_Simple_FocusFrame")  
  end
  
  if cfg.showpet then
    oUF:RegisterStyle("oUF_SimplePet", CreatePetStyle)
    oUF:SetActiveStyle("oUF_SimplePet")
    oUF:Spawn("pet", "oUF_Simple_PetFrame")  
  end
  
  if cfg.showparty then
    oUF:RegisterStyle("oUF_SimpleParty", CreatePartyStyle)
    oUF:SetActiveStyle("oUF_SimpleParty")

   local party = oUF:SpawnHeader("oUF_Party", nil, "raid,party,solo", "showParty", true, "showPlayer", true, "yOffset", -50)
   party:SetPoint("TOPLEFT", 70, -20)
  end