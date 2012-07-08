
  -- // oUF_Simple an oUF tutorial layout
  -- // zork - 2012

  --get the addon namespace
  local addon, ns = ...

  --get the config values
  local cfg = ns.cfg
  --get the library
  local lib = ns.lib
  local dragFrameList = ns.dragFrameList

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
    self:SetScale(cfg.unitscale)
    rCreateDragFrame(self, dragFrameList, -2 , true) --frame, dragFrameList, inset, clamp
    initHeader(self)
  end

  --the player style
  local function CreatePlayerStyle(self)
    --style specific stuff
    self.width = 270
    self.height = 25
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
    self.width = 270
    self.height = 25
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
    self.width = 150
    self.height = 25
    self.mystyle = "tot"
    self.hptag = "[simple:hpperc]"
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
    self.width = 180
    self.height = 25
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
    self.width = 180
    self.height = 25
    self.mystyle = "pet"
    --init
    init(self)
    --stuff
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
    self.width = 180
    self.height = 25
    self.mystyle = "party"
    --init
    initHeader(self)
    --stuff
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
    self.width = 100
    self.height = 30
    self.mystyle = "raid"
    self.hptag = "[simple:hpraid]"
    self.hidename = true
    --init
    initHeader(self)
    --stuff
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

  if cfg.showplayer then
    oUF:RegisterStyle("oUF_SimplePlayer", CreatePlayerStyle)
    oUF:SetActiveStyle("oUF_SimplePlayer")
    oUF:Spawn("player","oUF_SimplePlayer")
  end

  if cfg.showtarget then
    oUF:RegisterStyle("oUF_SimpleTarget", CreateTargetStyle)
    oUF:SetActiveStyle("oUF_SimpleTarget")
    oUF:Spawn("target","oUF_SimpleTarget")
  end

  if cfg.showtot then
    oUF:RegisterStyle("oUF_SimpleToT", CreateToTStyle)
    oUF:SetActiveStyle("oUF_SimpleToT")
    oUF:Spawn("targettarget","oUF_SimpleToT")
  end

  if cfg.showfocus then
    oUF:RegisterStyle("oUF_SimpleFocus", CreateFocusStyle)
    oUF:SetActiveStyle("oUF_SimpleFocus")
    oUF:Spawn("focus","oUF_SimpleFocus")
  end

  if cfg.showpet then
    oUF:RegisterStyle("oUF_SimplePet", CreatePetStyle)
    oUF:SetActiveStyle("oUF_SimplePet")
    oUF:Spawn("pet","oUF_SimplePet")
  end