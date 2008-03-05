  
  local type = type
  local UnitMana = UnitMana
  local UnitManaMax = UnitManaMax
  local UnitPowerType = UnitPowerType
  local GetPetHappiness = GetPetHappiness
  
  local power = rUnits.colors.power
  local happiness = rUnits.colors.happiness
  local min, max, bar, color
  
  function rUnits:UpdatePower(unit)
  	if(self.unit ~= unit) then return end
  
  	min, max = UnitMana(unit), UnitManaMax(unit)
  	bar = self.Power
  
  	local c = max - min
  	local d = floor(min/max*100)
  
  	bar:SetMinMaxValues(0, max)
  	bar:SetValue(min)
  	
    color = power[UnitPowerType(unit)]
  
    if(unit == "pet" and GetPetHappiness()) then
	    color = happiness[GetPetHappiness()]
    else
      color = power[UnitPowerType(unit)]
      --color = UnitIsPlayer(unit) and RAID_CLASS_COLORS[select(2, UnitClass(unit))] or UnitReactionColor[UnitReaction(unit, "player")]
    end

    if(color) then
      bar:SetStatusBarColor(color.r, color.g, color.b)
      if(bar.bg) then
        bar.bg:SetVertexColor(color.r*.5, color.g*.5, color.b*.5)
      end
    end
    
    bar.value:SetTextColor(1, 1, 1)
  
  	if(UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) or not UnitIsConnected(unit)) then
  		bar.value:SetTextColor(.5, .5, .5)	
  	end
  	
  	if UnitIsPlayer(unit) then
  	  local color = UnitIsPlayer(unit) and RAID_CLASS_COLORS[select(2, UnitClass(unit))]
  	  bar.value:SetTextColor(color.r, color.g, color.b) 
  	end
    
  	if(min < 0) then
  		bar.value:SetText()
  	elseif(UnitIsDead(unit)) then
  		bar.value:SetText()
  	elseif(UnitIsGhost(unit)) then
  		bar.value:SetText()
  	elseif(not UnitIsConnected(unit)) then
  		bar.value:SetText()
  	elseif(unit == "player") then
      local c = max - min
      bar.value:SetText(min.." . ")
    else
  		local c = max - min
  		if(c > 0) then
  			bar.value:SetText(max-c.." | ")
  		else
  			bar.value:SetText(max.." | ")
  		end
  	end
        
  
  end
