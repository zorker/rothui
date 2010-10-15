  
  --get the addon namespace
  local addon, ns = ...
  
  --get the config values
  local cfg = ns.cfg
  local barcfg = cfg.bars.totembar
  
  if not barcfg.disable and cfg.playerclass == "SHAMAN" then

    local bar = _G['MultiCastActionBarFrame']

    if bar then

      local holder = CreateFrame("Frame","rABS_TotemBar",UIParent, "SecureHandlerStateTemplate")
      holder:SetWidth(bar:GetWidth())
      holder:SetHeight(bar:GetHeight())
      if barcfg.testmode then
        bar:SetBackdrop(cfg.backdrop)
        bar:SetBackdropColor(1,0.8,1,0.6)
      end  
      cfg.applyDragFunctionality(holder,barcfg.userplaced,barcfg.locked)
            
      bar:SetParent(holder)
      bar:SetAllPoints(holder)
      
      local function moveTotem(self,a1,af,a2,x,y,...)
        if x ~= barcfg.pos.x then
          bar:SetAllPoints(holder)
        end
      end
            
      hooksecurefunc(bar, "SetPoint", moveTotem)  
      holder:SetPoint(barcfg.pos.a1,barcfg.pos.af,barcfg.pos.a2,barcfg.pos.x,barcfg.pos.y)  

      holder:SetScale(barcfg.barscale)
      
      bar:SetMovable(true)
      bar:SetUserPlaced(true)
      bar:EnableMouse(false)

    end
  
  end --disable