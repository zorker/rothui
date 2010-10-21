  
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
  initUnitParameters = function(self)
    self:SetFrameStrata("BACKGROUND")
    self:SetSize(self.cfg.width, self.cfg.height)
    self:SetScale(self.cfg.scale)
    self:SetPoint(self.cfg.pos.a1,self.cfg.pos.af,self.cfg.pos.a2,self.cfg.pos.x,self.cfg.pos.y)
    self.menu = func.menu
    self:RegisterForClicks("AnyDown")
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)
    --func.createBackdrop(self)
    func.applyDragFunctionality(self)
  end

  ---------------------------------------------
  -- TARGET STYLE FUNC
  ---------------------------------------------

  local function createStyle(self)
  
    --apply config to self
    self.cfg = cfg.units.target
    self.cfg.style = "target"
    
    --init
    initUnitParameters(self)
    
    --create the art    
    
    --createhealthPower
    
    --strings
    
    --aura
    
    --castbar
    
    --combobar
    
    --add self to unit container (maybe access to that unit is needed in another style)
    unit.target = self  
    
  end  

  ---------------------------------------------
  -- SPAWN TARGET UNIT
  ---------------------------------------------

  if cfg.units.target.show then
    oUF:RegisterStyle("diablo:target", createStyle)
    oUF:SetActiveStyle("diablo:target")
    oUF:Spawn("target", "oUF_DiabloTargetFrame")  
  end