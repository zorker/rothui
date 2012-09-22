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
  
  function rUnits:UpdateName(unit)

  	if(self.unit ~= unit) then return end

  	local name = UnitName(unit)
    local lvl = UnitLevel(unit)
  	
    self.Name:SetTextColor(1,1,1)
  
    --if UnitReactionColor[UnitReaction(unit, "player")] then
    --  local color = UnitReactionColor[UnitReaction(unit, "player")]
    --  self.Name:SetTextColor(color.r, color.g, color.b)
    --end
  
  	--if(UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) or not UnitIsConnected(unit)) then
    --self.Name:SetTextColor(.5, .5, .5)	
  	--end
  	
  	if UnitIsPlayer(unit) then
  	  local color = UnitIsPlayer(unit) and RAID_CLASS_COLORS[select(2, UnitClass(unit))]
  	  self.Name:SetTextColor(color.r, color.g, color.b) 
  	end
  	
  	if(unit == "player") then
  	  self.Name:SetTextColor(1,1,1) 
  	  self.Name:Hide()
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