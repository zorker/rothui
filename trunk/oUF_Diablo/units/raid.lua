  
  --get the addon namespace
  local addon, ns = ...  
  
  --get oUF namespace (just in case needed)
  local oUF = ns.oUF or oUF  
  
  --get the config
  local cfg = ns.cfg  

  --get the functions
  local func = ns.func

  --get the unit container
  local unit = ns.unit

  ---------------------------------------------
  -- UNIT SPECIFIC FUNCTIONS
  ---------------------------------------------
  
  --init parameters
  local initUnitParameters = function(self)
    self:SetFrameStrata("BACKGROUND")
    self:SetFrameLevel(1)
    self:SetSize(self.cfg.width, self.cfg.height)
    --self:SetScale(self.cfg.scale)
    --self:SetPoint(self.cfg.pos.a1,self.cfg.pos.af,self.cfg.pos.a2,self.cfg.pos.x,self.cfg.pos.y)
    self.menu = func.menu
    self:RegisterForClicks("AnyDown")
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)
    --func.createBackdrop(self)
    --func.applyDragFunctionality(self)
    self:SetHitRectInsets(15,15,15,15)
  end

  --actionbar background
  local createArtwork = function(self)

    local chain1 = self:CreateTexture(nil,"BACKGROUND",nil,-8)
    chain1:SetSize(15,30)
    chain1:SetTexture("Interface\\AddOns\\rTextures\\chain")
    chain1:SetPoint("TOP",-23,7)
    
    local chain2 = self:CreateTexture(nil,"BACKGROUND",nil,-8)
    chain2:SetSize(15,30)
    chain2:SetTexture("Interface\\AddOns\\rTextures\\chain")
    chain2:SetPoint("TOP",23,7)

    local t = self:CreateTexture(nil,"BACKGROUND",nil,-7)
    t:SetAllPoints(self)
    t:SetTexture("Interface\\AddOns\\rTextures\\raid")

    local threat = self:CreateTexture(nil,"BACKGROUND",nil,-6)
    threat:SetAllPoints(self)
    threat:SetTexture("Interface\\AddOns\\rTextures\\raid_threat")
    self.Threat = threat

  end
  
  --create health frames
  local createHealthFrame = function(self)
    
    --health
    local h = CreateFrame("StatusBar", nil, self)
    h:SetPoint("TOP",0,-25)
    h:SetPoint("LEFT",29,0)
    h:SetPoint("RIGHT",-29,0)
    h:SetPoint("BOTTOM",0,25)
    
    h:SetStatusBarTexture(self.cfg.health.texture)
    h.bg = h:CreateTexture(nil,"BACKGROUND",nil,-6)
    h.bg:SetTexture(self.cfg.health.texture)
    h.bg:SetAllPoints(h)

    h.glow = h:CreateTexture(nil,"OVERLAY",nil,-5)
    h.glow:SetTexture("Interface\\AddOns\\rTextures\\raid_hpglow")
    h.glow:SetAllPoints(self)
    
    self.Health = h

    local name = func.createFontString(self.Health, cfg.font, 11, "THINOUTLINE")
    name:SetPoint("LEFT", self.Health, 10, 0)
    name:SetPoint("RIGHT", self.Health, -10, 0)
  
    self:Tag(name, self.cfg.health.tag or "[name]")
  
    h.Name = name
    
  end
  
  --update health func
  local updateHealth = function(bar, unit, min, max)
    local d = floor(min/max*100)
    local color
    local dead
    if UnitIsDeadOrGhost(unit) == 1 or UnitIsConnected(unit) == nil then
      color = {r = 0.4, g = 0.4, b = 0.4}
      dead = 1
    elseif min < max then
      color = {r = 1, g = 1, b = 1}
    elseif UnitIsPlayer(unit) then
      color = rRAID_CLASS_COLORS[select(2, UnitClass(unit))] or RAID_CLASS_COLORS[select(2, UnitClass(unit))]
    elseif unit == "pet" and UnitExists("pet") and GetPetHappiness() then
      local happiness = GetPetHappiness()
      color = cfg.happycolors[happiness]
    else
      color = FACTION_BAR_COLORS[UnitReaction(unit, "player")]
    end

    if color then
      bar.Name:SetTextColor(color.r, color.g, color.b,1)
    end

    if dead == 1 then
      bar:SetStatusBarColor(0,0,0,0)
      bar.bg:SetVertexColor(0,0,0,0)
    else
      bar:SetStatusBarColor(cfg.colorswitcher.healthbar.r,cfg.colorswitcher.healthbar.g,cfg.colorswitcher.healthbar.b,cfg.colorswitcher.healthbar.a)
      bar.bg:SetVertexColor(cfg.colorswitcher.bg.r,cfg.colorswitcher.bg.g,cfg.colorswitcher.bg.b,cfg.colorswitcher.bg.a)
    end

    if d <= 25 and min > 1 and dead ~= 1 then
      bar.glow:SetVertexColor(1,0,0,1)
    else
      bar.glow:SetVertexColor(0,0,0,0.7)
    end

  end


  ---------------------------------------------
  -- RAID STYLE FUNC
  ---------------------------------------------

  local function createStyle(self)
  
    --apply config to self
    self.cfg = cfg.units.raid
    self.cfg.style = "raid"
    
    self.cfg.width = 128
    self.cfg.height = 64
    
    --init
    initUnitParameters(self)

    --create the art    
    createArtwork(self)
    
    --createhealth
    createHealthFrame(self)
    
    --health update
    self.Health.PostUpdate = updateHealth
    
    --debuffglow
    func.createDebuffGlow(self)
    
    --range
    self.Range = {
      insideAlpha = 1, 
      outsideAlpha = self.cfg.alpha.notinrange
    }
    
  end  

  ---------------------------------------------
  -- SPAWN RAID UNIT
  ---------------------------------------------

  if cfg.units.raid.show then
    
    CompactRaidFrameManager:UnregisterAllEvents()
    CompactRaidFrameManager:HookScript("OnShow", function(s) s:Hide() end)
    CompactRaidFrameManager:Hide()
    
    CompactRaidFrameContainer:UnregisterAllEvents()
    CompactRaidFrameContainer:HookScript("OnShow", function(s) s:Hide() end)
    CompactRaidFrameContainer:Hide()
    
    oUF:RegisterStyle("diablo:raid", createStyle)
    oUF:SetActiveStyle("diablo:raid")
    
    local raid = oUF:SpawnHeader(
      "oUF_DiabloRaidHeader", 
      nil, 
      "solo,raid",
      "showSolo", cfg.units.raid.showsolo, --debug
      "showPlayer", true,
      "showParty", true,
      "showRaid", true,
      "point", "TOP",
      "yOffset", 33,      
      "xoffset", 7,
      "groupFilter", "1,2,3,4,5",
      "groupBy", "GROUP",
      "groupingOrder", "1,2,3,4,5",
      "sortMethod", "NAME",
      "maxColumns", 5,
      "unitsPerColumn", 5,
      "columnSpacing", -20,
      "columnAnchorPoint", "LEFT",
      
      "oUF-initialConfigFunction", ([[
        self:SetWidth(%d)
        self:SetHeight(%d)
        self:SetScale(%f)
      ]]):format(128, 64, cfg.units.raid.scale)
    )
    raid:SetPoint(cfg.units.raid.pos.a1,cfg.units.raid.pos.af,cfg.units.raid.pos.a2,cfg.units.raid.pos.x,cfg.units.raid.pos.y)    
   
  end