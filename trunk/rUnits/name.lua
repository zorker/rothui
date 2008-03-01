  
  function pUF:UpdateName(unit)

  	if(self.unit ~= unit) then return end

  	local name = UnitName(unit)
    local lvl = UnitLevel(unit)
  	
    self.Name:SetTextColor(1, 1, 1)
  
  	if(UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) or not UnitIsConnected(unit)) then
  		self.Name:SetTextColor(.5, .5, .5)	
  	end
  	
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
  end