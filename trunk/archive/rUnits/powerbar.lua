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
  	  if color then 
  	    bar.value:SetTextColor(color.r, color.g, color.b) 
  	  end
  	end
  	
  	if(unit == "player") then
  	  bar.value:SetTextColor(1,1,1) 
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
      bar.value:SetText(min)
    else
  		local c = max - min
  		if(c > 0) then
  			bar.value:SetText(max-c.." | ")
  		else
  			bar.value:SetText(max.." | ")
  		end
  	end
        
  
  end
