  
  -- // oUF_Simple2, an oUF tutorial layout
  -- // zork - 2011
  
  --get the addon namespace
  local addon, ns = ...
  
  --get the config values
  local cfg = ns.cfg
  --get the library
  local lib = ns.lib

  -----------------------------
  -- VARIABLES
  -----------------------------
  
  --fix oUF mana color
  oUF.colors.power["MANA"] = {0, 0.4, 0.9}

  -----------------------------
  -- STYLE FUNCTIONS
  -----------------------------
  
  --init func
  local initHeader = function(self)
    self.menu = lib.menu
    self:RegisterForClicks("AnyUp")
    self:SetAttribute("*type2", "menu")
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)
    lib.gen_hpbar(self)
    lib.gen_hpstrings(self)
    lib.gen_ppbar(self)
  end  

  --init func
  local init = function(self)
    self:SetSize(self.width, self.height)
    self:SetPoint("CENTER",UIParent,"CENTER",0,0)
    initHeader(self)
  end

  --the player style
  local function CreatePlayerStyle(self)
    --style specific stuff
    self.width = cfg.player.width
    self.height = cfg.player.height
    self.mystyle = "player"
    init(self)
    self.Health.colorClass = true
    self.Health.colorHealth = true
    self.Health.bg.multiplier = 0.3
    self.Power.colorPower = true
    self.Power.bg.multiplier = 0.3
    lib.gen_castbar(self)
    lib.gen_portrait(self)
  end  
  
  --the target style
  local function CreateTargetStyle(self)
    --style specific stuff
    self.width = cfg.target.width
    self.height = cfg.target.height
    self.mystyle = "target"
    init(self)
    self.Health.colorTapping = true
    self.Health.colorDisconnected = true
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
    self.width = cfg.tot.width
    self.height = cfg.tot.height
    self.mystyle = "tot"
    if cfg.tot.hptag then
      self.hptag = cfg.tot.hptag
    end
    init(self)
    self.Health.colorTapping = true
    self.Health.colorDisconnected = true
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
    self.width = cfg.focus.width
    self.height = cfg.focus.height
    self.mystyle = "focus"
    init(self)
    self.Health.colorDisconnected = true
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
    self.width = cfg.pet.width
    self.height = cfg.pet.height
    self.mystyle = "pet"
    init(self)
    self.Health.colorDisconnected = true
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
  
  --now header units, examples for party, raid10, raid25, raid40
  
  --party frames
  local function CreatePartyStyle(self)
    --style specific stuff
    self.width = cfg.party.width
    self.height = cfg.party.height
    self.mystyle = "party"
    initHeader(self)
    self.Health.colorDisconnected = true
    self.Health.colorClass = true
    self.Health.colorReaction = true
    self.Health.colorHealth = true
    self.Health.bg.multiplier = 0.3
    self.Power.colorPower = true
    self.Power.bg.multiplier = 0.3
    lib.gen_portrait(self)
    lib.createDebuffs(self)
  end  
  
  --party frames
  local function CreateRaidStyle(self)
    --style specific stuff
    self.width = cfg.raid.width
    self.height = cfg.raid.height
    self.mystyle = "raid"
    if cfg.raid.hptag then
      self.hptag = cfg.raid.hptag
    end
    self.hidename = true
    initHeader(self)
    self.Health.colorDisconnected = true
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

  if cfg.player.show then
    oUF:RegisterStyle("oUF_SimplePlayer", CreatePlayerStyle)
    oUF:SetActiveStyle("oUF_SimplePlayer")
    oUF:Spawn("player")  
  end
  
  if cfg.target.show then
    oUF:RegisterStyle("oUF_SimpleTarget", CreateTargetStyle)
    oUF:SetActiveStyle("oUF_SimpleTarget")
    oUF:Spawn("target")  
  end

  if cfg.tot.show then
    oUF:RegisterStyle("oUF_SimpleToT", CreateToTStyle)
    oUF:SetActiveStyle("oUF_SimpleToT")
    oUF:Spawn("targettarget")  
  end
  
  if cfg.focus.show then
    oUF:RegisterStyle("oUF_SimpleFocus", CreateFocusStyle)
    oUF:SetActiveStyle("oUF_SimpleFocus")
    oUF:Spawn("focus")  
  end
  
  if cfg.pet.show then
    oUF:RegisterStyle("oUF_SimplePet", CreatePetStyle)
    oUF:SetActiveStyle("oUF_SimplePet")
    oUF:Spawn("pet")  
  end
  
  -----------------------------
  -- SPAWN HEADER UNITS
  -----------------------------

  if cfg.party.show and not cfg.useRaidLayoutInParty then
    oUF:RegisterStyle("oUF_SimpleParty", CreatePartyStyle)
    oUF:SetActiveStyle("oUF_SimpleParty")
    
    local party = oUF:SpawnHeader(
      "oUF_SimpleParty", 
      nil, 
      "custom [@raid1,exists] hide; [group:party,nogroup:raid] show; hide",
      "showPlayer",         true,
      "showSolo",           false,
      "showParty",          true,
      "showRaid",           false,
      "point",              "TOP",
      "yOffset",            -44,
      "xoffset",            0,
      "oUF-initialConfigFunction", ([[
        self:SetWidth(%d)
        self:SetHeight(%d)
      ]]):format(cfg.party.width, cfg.party.height)
    )
    party:SetPoint("CENTER",UIParent,"CENTER",0,0)    
        
  end
  
  if cfg.party.show and cfg.useRaidLayoutInParty then
    --spawn party but with raid style
    oUF:RegisterStyle("oUF_SimpleRaid5", CreateRaidStyle)
    oUF:SetActiveStyle("oUF_SimpleRaid5")
    
    local raid5 = oUF:SpawnHeader(
      "oUF_SimpleRaid5", 
      nil, 
      "custom [@raid1,exists] hide; [group:party,nogroup:raid] show; hide",
      "showPlayer",         true,
      "showSolo",           false,
      "showParty",          true,
      "showRaid",           false,
      "point",              "LEFT",
      "yOffset",            0,
      "xoffset",            10,
      "oUF-initialConfigFunction", ([[
        self:SetWidth(%d)
        self:SetHeight(%d)
      ]]):format(cfg.raid.width, cfg.raid.height)
    )
    raid5:SetPoint("CENTER",UIParent,"CENTER",0,0)    
        
  end

  if cfg.raid.show then
    
    --die raid panel, die
    CompactRaidFrameManager:UnregisterAllEvents()
    CompactRaidFrameManager.Show = CompactRaidFrameManager.Hide
    CompactRaidFrameManager:Hide()
    
    CompactRaidFrameContainer:UnregisterAllEvents()
    CompactRaidFrameContainer.Show = CompactRaidFrameContainer.Hide
    CompactRaidFrameContainer:Hide()
    
    --setup for 10 man raid    
    oUF:RegisterStyle("oUF_SimpleRaid10", CreateRaidStyle)
    oUF:SetActiveStyle("oUF_SimpleRaid10")
    
    local raid10 = oUF:SpawnHeader(
      "oUF_SimpleRaid10", 
      nil, 
      "custom [@raid11,exists] hide; [@raid1,exists] show; hide",  
      "showPlayer",         false,
      "showSolo",           false,
      "showParty",          false,
      "showRaid",           true,
      "point",              "LEFT",
      "yOffset",            0,
      "xoffset",            10,
      "columnSpacing",      17,
      "columnAnchorPoint",  "TOP",
      "groupFilter",        "1,2,3,4,5,6,7,8",
      "groupBy",            "GROUP",
      "groupingOrder",      "1,2,3,4,5,6,7,8",
      "sortMethod",         "NAME",
      "maxColumns",         8,
      "unitsPerColumn",     5,
      "oUF-initialConfigFunction", ([[
        self:SetWidth(%d)
        self:SetHeight(%d)
      ]]):format(cfg.raid.width, cfg.raid.height)
    )
    raid10:SetPoint("CENTER",UIParent,"CENTER",0,0)
    
    --setup for 25 man raid
    
    oUF:RegisterStyle("oUF_SimpleRaid25", CreateRaidStyle)
    oUF:SetActiveStyle("oUF_SimpleRaid25")
    
    local raid25 = oUF:SpawnHeader(
      "oUF_SimpleRaid25", 
      nil, 
      "custom [@raid26,exists] hide; [@raid11,exists] show; hide",  
      "showPlayer",         false,
      "showSolo",           false,
      "showParty",          false,
      "showRaid",           true,
      "point",              "LEFT",
      "yOffset",            0,
      "xoffset",            10,
      "columnSpacing",      17,
      "columnAnchorPoint",  "TOP",
      "groupFilter",        "1,2,3,4,5,6,7,8",
      "groupBy",            "GROUP",
      "groupingOrder",      "1,2,3,4,5,6,7,8",
      "sortMethod",         "NAME",
      "maxColumns",         8,
      "unitsPerColumn",     5,
      "oUF-initialConfigFunction", ([[
        self:SetWidth(%d)
        self:SetHeight(%d)
      ]]):format(cfg.raid.width, cfg.raid.height)
    )
    raid25:SetPoint("CENTER",UIParent,"CENTER",0,0)
    
    --setup for 40 man raid
    
    oUF:RegisterStyle("oUF_SimpleRaid40", CreateRaidStyle)
    oUF:SetActiveStyle("oUF_SimpleRaid40")
    
    local raid40 = oUF:SpawnHeader(
      "oUF_SimpleRaid40", 
      nil, 
      "custom [@raid26,exists] show; hide",  
      "showPlayer",         false,
      "showSolo",           false,
      "showParty",          false,
      "showRaid",           true,
      "point",              "LEFT",
      "yOffset",            0,
      "xoffset",            10,
      "columnSpacing",      17,
      "columnAnchorPoint",  "TOP",
      "groupFilter",        "1,2,3,4,5,6,7,8",
      "groupBy",            "GROUP",
      "groupingOrder",      "1,2,3,4,5,6,7,8",
      "sortMethod",         "NAME",
      "maxColumns",         8,
      "unitsPerColumn",     5,
      "oUF-initialConfigFunction", ([[
        self:SetWidth(%d)
        self:SetHeight(%d)
      ]]):format(cfg.raid.width, cfg.raid.height)
    )
    raid40:SetPoint("CENTER",UIParent,"CENTER",0,0)
        
  end