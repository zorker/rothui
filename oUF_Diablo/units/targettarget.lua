  
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

  --get config for this specific unit
  local unitcfg = cfg.units.targettarget

  ---------------------------------------------
  -- TARGETTARGET STYLE FUNC
  ---------------------------------------------

  local function createStyle(self)
  
    self.mystyle = "targettarget"
  
    --do stuff for that style
    self:SetPoint("CENTER",0,0)
    
    --add self to unit container (maybe access to that unit is needed in another style)
    unit.targettarget = self    
    
  end  

  ---------------------------------------------
  -- SPAWN TARGETTARGET UNIT
  ---------------------------------------------

  if unitconfig.show then
    oUF:RegisterStyle("diablo:targettarget", createStyle)
    oUF:SetActiveStyle("diablo:targettarget")
    oUF:Spawn("targettarget", "oUF_DiabloTargetTargetFrame")
  end