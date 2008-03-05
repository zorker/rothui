  
  function rUnits:UpdateName(unit)

  	if(self.unit ~= unit) then return end

  	local name = UnitName(unit)
    local lvl = UnitLevel(unit)
  	
    self.Name:SetTextColor(0.6, 0.6, 0.6)
  
    if UnitReactionColor[UnitReaction(unit, "player")] then
      local color = UnitReactionColor[UnitReaction(unit, "player")]
      self.Name:SetTextColor(color.r, color.g, color.b)
    end
  
  	--if(UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) or not UnitIsConnected(unit)) then
    --self.Name:SetTextColor(.5, .5, .5)	
  	--end
  	
  	if UnitIsPlayer(unit) then
  	  local color = UnitIsPlayer(unit) and RAID_CLASS_COLORS[select(2, UnitClass(unit))]
  	  self.Name:SetTextColor(color.r, color.g, color.b) 
  	end
      
    if(unit == "target") then
      if(UnitClassification(unit)=="worldboss") then
      self.Name:SetText("b++ "..name)
      elseif(UnitClassification(unit)=="rareelite") then
      self.Name:SetText(lvl.."r+ "..name)
      elseif(UnitClassification(unit)=="elite") then
      self.Name:SetText(lvl.."+ "..name)
      elseif(UnitClassification(unit)=="rare") then
      self.Name:SetText(lvl.."r "..name)
      else
      self.Name:SetText(lvl.." "..name)
      end
    else
      self.Name:SetText(name)
    end
    
  	if(UnitIsDead(unit)) then
  		self.Name:SetTextColor(0.6, 0.6, 0.6)
  	elseif(UnitIsGhost(unit)) then
  		self.Name:SetTextColor(0.6, 0.6, 0.6)
  	elseif(not UnitIsConnected(unit)) then
  		self.Name:SetTextColor(0.6, 0.6, 0.6)
  	end
    
  end