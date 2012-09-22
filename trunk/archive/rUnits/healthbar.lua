--[[-------------------------------------------------------------------------
  Copyright (c) 2006-2008, Trond A Ekseth
  Copyright (c) 2008, p3lim
  Copyright (c) 2008, zork
  All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are
  met:

      * Redistributions of source code must retain the above copyright
        notice, this list of conditions and the following disclaimer.
      * Redistributions in binary form must reproduce the above
        copyright notice, this list of conditions and the following
        disclaimer in the documentation and/or other materials provided
        with the distribution.
      * Neither the name of rUnits nor the names of its contributors may
        be used to endorse or promote products derived from this
        software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
---------------------------------------------------------------------------]]
  
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
  
  local health = rUnits.colors.health
  local min, max, bar, color
  
  function rUnits:UpdateHealth(unit)
  	if(self.unit ~= unit) then return end
  
  	min, max = UnitHealth(unit), UnitHealthMax(unit)
  	
  	local GetPetHappiness = GetPetHappiness
  	local happiness = rUnits.colors.happiness
  	
  	bar = self.Health
  
  	bar:SetMinMaxValues(0, max)
  	bar:SetValue(min)
  
    if(unit == "pet" and GetPetHappiness()) then
			--color = happiness[GetPetHappiness()]
			color = health[2]
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
				color = UnitIsPlayer(unit) and RAID_CLASS_COLORS[select(2, UnitClass(unit))] or UnitReactionColor[UnitReaction(unit, "player")]
				if color then 
				  bar.bg:SetVertexColor(color.r, color.g, color.b,0.9)
				else
				  bar.bg:SetVertexColor(1,1,1,0.3)
				end
			end
		end
		
  	local c = max - min
  	local d = floor(min/max*100)
  	
    bar.value:SetTextColor(1,1,1)
    
    --color = UnitReactionColor[UnitReaction(unit, "player")]
    --bar.value:SetTextColor(color.r, color.g, color.b)
  
  	--if(UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) or not UnitIsConnected(unit)) then
  	--	bar.value:SetTextColor(.5, .5, .5)	
  	--end
  	
  	if UnitIsPlayer(unit) then
  	  local color = UnitIsPlayer(unit) and RAID_CLASS_COLORS[select(2, UnitClass(unit))]
  	  if color then bar.value:SetTextColor(color.r, color.g, color.b) end
  	end
  	
  	if(unit == "player") then
  	  bar.value:SetTextColor(1,1,1) 
  	end
  	
  	if(UnitIsDead(unit)) then
  		bar.value:SetText"Dead"
  		bar.value:SetTextColor(0.6, 0.6, 0.6)
  		bar.bg:SetVertexColor(1,1,1,0.3)
  	elseif(UnitIsGhost(unit)) then
  		bar.value:SetText"Ghost"
  		bar.value:SetTextColor(0.6, 0.6, 0.6)
  		bar.bg:SetVertexColor(1,1,1,0.3)
  	elseif(not UnitIsConnected(unit)) then
  		bar.value:SetText"Offline"
  		bar.value:SetTextColor(0.6, 0.6, 0.6)
  		bar.bg:SetVertexColor(1,1,1,0.3)
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
 	    bar.value:SetText(min.." . "..max.." . "..d.."%")
  	else
      bar.value:SetText(d.."%")
  	end

  end
