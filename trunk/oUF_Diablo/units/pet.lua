  
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
  local unitcfg = cfg.units.pet

  ---------------------------------------------
  -- PET STYLE FUNC
  ---------------------------------------------

  local function createStyle(self)
  
    self.mystyle = "pet"
    
    --do stuff for that style
    self:SetPoint("CENTER",0,0)
    
    --add self to unit container (maybe access to that unit is needed in another style)
    unit.pet = self    
    
  end  

  ---------------------------------------------
  -- SPAWN PET UNIT
  ---------------------------------------------

  if unitconfig.show then
    oUF:RegisterStyle("diablo:pet", createStyle)
    oUF:SetActiveStyle("diablo:pet")
    oUF:Spawn("pet", "oUF_DiabloPetFrame")  
  end