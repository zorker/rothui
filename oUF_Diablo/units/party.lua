  
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
  end
  
  --actionbar background
  local createArtwork = function(self)
    local t = self:CreateTexture(nil,"BACKGROUND",nil,-8)
    t:SetAllPoints(self)
    t:SetTexture("Interface\\AddOns\\rTextures\\targettarget")
  end

  --create health frames
  local createHealthFrame = function(self)
    
    local cfg = self.cfg.health
    
    --health
    local h = CreateFrame("StatusBar", nil, self)
    h:SetPoint("TOP",0,-21.9)
    h:SetPoint("LEFT",24.5,0)
    h:SetPoint("RIGHT",-24.5,0)
    h:SetPoint("BOTTOM",0,28.7)
    
    h:SetStatusBarTexture(cfg.texture)
    h.bg = h:CreateTexture(nil,"BACKGROUND",nil,-6)
    h.bg:SetTexture(cfg.texture)
    h.bg:SetAllPoints(h)

    h.glow = h:CreateTexture(nil,"OVERLAY",nil,-5)
    h.glow:SetTexture("Interface\\AddOns\\rTextures\\targettarget_hpglow")
    h.glow:SetAllPoints(self)
    h.glow:SetVertexColor(0,0,0,1)
    
    self.Health = h
    self.Health.Smooth = true
  end
  
  --create power frames
  local createPowerFrame = function(self)    
    local cfg = self.cfg.power
        
    --power
    local h = CreateFrame("StatusBar", nil, self)
    h:SetPoint("TOP",0,-38.5)
    h:SetPoint("LEFT",24.5,0)
    h:SetPoint("RIGHT",-24.5,0)
    h:SetPoint("BOTTOM",0,21.9)

    h:SetStatusBarTexture(cfg.texture)
    
    h.bg = h:CreateTexture(nil,"BACKGROUND",nil,-6)
    h.bg:SetTexture(cfg.texture)
    h.bg:SetAllPoints(h)

    h.glow = h:CreateTexture(nil,"OVERLAY",nil,-5)
    h.glow:SetTexture("Interface\\AddOns\\rTextures\\targettarget_ppglow")
    h.glow:SetAllPoints(self)
    h.glow:SetVertexColor(0,0,0,1)
    
    self.Power = h
    self.Power.Smooth = true
    
  end
  
  --create health power strings
  local createHealthPowerStrings = function(self)
  
    local name = func.createFontString(self, cfg.font, 14, "THINOUTLINE")
    name:SetPoint("BOTTOM", self, "TOP", 0, -13)
    name:SetPoint("LEFT", 5,0)
    name:SetPoint("RIGHT", -5,-2)
    self.Name = name

    local hpval = func.createFontString(self.Health, cfg.font, 11, "THINOUTLINE")
    hpval:SetPoint("RIGHT", -2,0)
    
    self:Tag(name, "[name]")
    self:Tag(hpval, "[diablo_MissHP]")
    
  end

  ---------------------------------------------
  -- PARTY STYLE FUNC
  ---------------------------------------------

  local function createStyle(self)
  
    --apply config to self
    self.cfg = cfg.units.party
    self.cfg.style = "party"
    
    self.cfg.width = 128
    self.cfg.height = 64
    
    --init
    initUnitParameters(self)
    
    --create the art    
    createArtwork(self)
    
    --createhealthPower
    createHealthFrame(self)
    createPowerFrame(self)
    
    --health power strings
    createHealthPowerStrings(self)
    
    --health power update
    self.Health.PostUpdate = func.updateHealth
    self.Power.PostUpdate = func.updatePower
    
    --create portrait
    if self.cfg.portrait.show then
      func.createPortrait(self)
      self:SetHitRectInsets(0, 0, -100, 0);
    end
    
    --auras
    if self.cfg.auras.show then
      func.createDebuffs(self)      
      self.Debuffs.PostCreateIcon = func.createAuraIcon
    end
    
  end  

  ---------------------------------------------
  -- SPAWN PARTY UNIT
  ---------------------------------------------

  if cfg.units.party.show then
    oUF:RegisterStyle("diablo:party", createStyle)
    oUF:SetActiveStyle("diablo:party")
    
    local party = oUF:SpawnHeader(
      "oUF_DiabloPartyHeader", 
      nil, 
      "solo,party",
      "showSolo", cfg.units.party.showsolo, --debug
      "showParty", true,
      "showPlayer", true,
      "point", "LEFT",
      "oUF-initialConfigFunction", ([[
        self:SetWidth(%d)
        self:SetHeight(%d)
        self:SetScale(%f)
      ]]):format(128, 64, cfg.units.party.scale)
    )
    if cfg.units.party.portrait.show then
      party:SetPoint(cfg.units.party.pos.a1,cfg.units.party.pos.af,cfg.units.party.pos.a2,cfg.units.party.pos.x,cfg.units.party.pos.y-85*cfg.units.party.scale)
    else
      party:SetPoint(cfg.units.party.pos.a1,cfg.units.party.pos.af,cfg.units.party.pos.a2,cfg.units.party.pos.x,cfg.units.party.pos.y)
    end
    
  end