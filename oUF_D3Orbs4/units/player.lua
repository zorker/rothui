  
  -- // oUF D3Orbs 4.0
  -- // zork - 2010
  
  --get the addon namespace
  local addon, ns = ...
  
  --get the config values
  local cfg = ns.cfg
  --get the library
  local lib = ns.lib

  local unitconfig = cfg.units.player


  -----------------------------
  -- STYLE FUNCTIONS
  -----------------------------

  --the player style
  local function createStyle(self)
  
    --make the config values available for the self object
    self.config = unitconfig
    
    --createActionBarBackground
    lib.createActionBarBackground(self)
    
    --init unit parameters
    lib.initUnitParameters(self)
    
    lib.applyDragFunctionality(self)
    
    --create the health orb
    self.Health = lib.createOrb(self,"health")
    self.Health.Smooth = true

    --create the power orb
    self.Power = lib.createOrb(self,"power")
    lib.applyDragFunctionality(self.Power)
    self.Power.frequentUpdates = true
    self.Power.Smooth = true
    
    --hp strings
    local hpval1, hpval2, ppval1, ppval2, hpvalf, ppvalf
    hpvalf = CreateFrame("FRAME", nil, self.Health)
    hpvalf:SetAllPoints(self.Health)
    
    hpval1 = lib.createFontString(hpvalf, cfg.font, 28, "THINOUTLINE")
    hpval1:SetPoint("CENTER", 0, 10)
    hpval2 = lib.createFontString(hpvalf, cfg.font, 16, "THINOUTLINE")
    hpval2:SetPoint("CENTER", 0, -10)
    hpval2:SetTextColor(0.6,0.6,0.6)
    
    self:Tag(hpval1, "[perhp]")
    self:Tag(hpval2, "[d3oShortHP]")

    --pp strings
    ppvalf = CreateFrame("FRAME", nil, self.Power)
    ppvalf:SetAllPoints(self.Power)
    
    ppval1 = lib.createFontString(ppvalf, cfg.font, 28, "THINOUTLINE")
    ppval1:SetPoint("CENTER", 0, 10)
    ppval2 = lib.createFontString(ppvalf, cfg.font, 16, "THINOUTLINE")
    ppval2:SetPoint("CENTER", 0, -10)
    ppval2:SetTextColor(0.6,0.6,0.6)
    
    self:Tag(ppval1, "[perpp]")
    self:Tag(ppval2, "[d3oShortPP]")
    
    --create the other art now, important because of the layers
    lib.createAngelFrame(self)
    lib.createDemonFrame(self)
    lib.createBottomLine(self)
    
  end  

  -----------------------------
  -- SPAWN UNITS
  -----------------------------

  if unitconfig.show then
    oUF:RegisterStyle("oUF_D3Orbs4Player", createStyle)
    oUF:SetActiveStyle("oUF_D3Orbs4Player")
    oUF:Spawn("player", "oUF_D3Orbs4PlayerFrame")  
  end