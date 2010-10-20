  
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
  local unitcfg = cfg.units.player

  ---------------------------------------------
  -- PLAYER STYLE FUNC
  ---------------------------------------------

  local function createStyle(self)
  
    self.mystyle = "player"
    
    --do stuff for that style
    self:SetPoint("CENTER",0,0)
    
    --add self to unit container (maybe access to that unit is needed in another style)
    unit.player = self    
    
  end  

  ---------------------------------------------
  -- SPAWN PLAYER UNIT
  ---------------------------------------------

  if unitconfig.show then
    oUF:RegisterStyle("diablo:player", createStyle)
    oUF:SetActiveStyle("diablo:player")
    oUF:Spawn("player", "oUF_DiabloPlayerFrame")  
  end