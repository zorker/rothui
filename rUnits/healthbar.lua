  
  local select = select
  local type = type
  local UnitHealth = UnitHealth
  local UnitHealthMax = UnitHealthMax
  local UnitIsTapped = UnitIsTapped
  local UnitIsTappedByPlayer = UnitIsTappedByPlayer
  local UnitIsPlayer = UnitIsPlayer
  local UnitIsConnected = UnitIsConnected
  local UnitClass = UnitClass
  local UnitReactionColor = UnitReactionColor
  local UnitReaction = UnitReaction
  local RAID_CLASS_COLORS = RAID_CLASS_COLORS
  
  local health = pUF.colors.health
  local min, max, bar, color
  
  function pUF:UpdateHealth(unit)
  	if(self.unit ~= unit) then return end
  
  	min, max = UnitHealth(unit), UnitHealthMax(unit)
  	bar = self.Health
  
  	bar:SetMinMaxValues(0, max)
  	bar:SetValue(min)
  
    if(unit == "pet" and GetPetHappiness()) then
			color = happiness[GetPetHappiness()]
		elseif(UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) or not UnitIsConnected(unit)) then
			color = health[1]
		else
			--color = UnitIsPlayer(unit) and RAID_CLASS_COLORS[select(2, UnitClass(unit))] or UnitReactionColor[UnitReaction(unit, "player")]
			color = health[2]
		end
		if(color) then
			bar:SetStatusBarColor(color.r, color.g, color.b)

			if(bar.bg) then
				--bar.bg:SetVertexColor(color.r*.5, color.g*.5, color.b*.5)
				bar.bg:SetVertexColor(1,1,1,0.3)
			end
		end
		
  	local c = max - min
  	local d = floor(min/max*100)
  	
    bar.value:SetTextColor(1, 1, 1)
  
  	if(UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) or not UnitIsConnected(unit)) then
  		bar.value:SetTextColor(.5, .5, .5)	
  	end
  	
  	if UnitIsPlayer(unit) then
  	  local color = UnitIsPlayer(unit) and RAID_CLASS_COLORS[select(2, UnitClass(unit))]
  	  bar.value:SetTextColor(color.r, color.g, color.b) 
  	end
  	
  	if(UnitIsDead(unit)) then
  		bar.value:SetText"Dead"
  	elseif(UnitIsGhost(unit)) then
  		bar.value:SetText"Ghost"
  	elseif(not UnitIsConnected(unit)) then
  		bar.value:SetText"Offline"
  	elseif(UnitIsEnemy("player",unit)) then
  		if(c > 0) then
  			bar.value:SetText(max-c.."%")
  		else
  			bar.value:SetText(max.."%")
  		end
  	elseif(unit == "pet")then
  		if(c > 0) then
  			bar.value:SetText(max-c.." / "..max)
  		else
  			bar.value:SetText(max)
  		end
  	elseif(UnitIsPlayer(unit)) then
 	    bar.value:SetText(min.." . "..d.."%")
  	else
      bar.value:SetText(d.."%")
  	end

  end
