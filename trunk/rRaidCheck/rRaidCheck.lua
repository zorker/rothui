--[[-------------------------------------------------------------------------
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
      * Neither the name of rRaidCheck nor the names of its contributors may
        be used to endorse or promote products derived from this
        software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES LOSS OF USE,
  DATA, OR PROFITS OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
---------------------------------------------------------------------------]]--
  
  local addon = CreateFrame"Frame"
  local _G = getfenv(0)  
  
  local totalElapsed = 0.0;
  
  addon:SetScript("OnEvent", function()
    if(event=="PLAYER_LOGIN") then
      addon:rrc_createframe()
    end  
  end)

  function addon:rrc_onUpdate(self, elapsed)
    totalElapsed = totalElapsed + elapsed
    if (totalElapsed < 2) then 
      return
    end
    totalElapsed = totalElapsed - floor(totalElapsed)
    local n = GetNumRaidMembers()  
    if n > 0 then  
      
      -- SET texts of the frames with the return values of the functions
      
      local fin_raidhp  = addon:rrc_checkhealth()
      local fin_raidmp  = addon:rrc_checkmana()
      local fin_dead    = addon:rrc_checkdead()
      
      rrc_t0:SetText("Raid Health "..fin_raidhp.." %")
      rrc_t1:SetText("Raid Mana "..fin_raidmp.." %")
      rrc_t2:SetText("Raid Dead "..fin_dead)
      
    end
  end
  
  
  function addon:rrc_createframe()
    local f = CreateFrame("Frame","rrc_frame",UIParent)
    f:SetFrameStrata("BACKGROUND")
    f:SetWidth(100)
    --f:SetHeight(100)
    f:SetBackdrop({
      bgFile = "Interface/Tooltips/UI-Tooltip-Background", 
      edgeFile = "", 
      tile = true, tileSize = 16, edgeSize = 16, 
      insets = { left = 0, right = 0, top = 0, bottom = 0 }
    })
    f:SetBackdropColor(0,0,0,0.8)
    f:ClearAllPoints()  
    f:SetPoint("TOPLEFT",UIParent,"TOPLEFT",0,0)
    f:Show()
    
    local rrc_t0 = f:CreateFontString("rrc_t0")
    rrc_t0:SetPoint("TOPLEFT", 5, -5)
    rrc_t0:SetFontObject(GameFontHighlight)
    rrc_t0:SetTextColor(0, 1, 0)
    rrc_t0:SetText("Raid Health")
    rrc_t0:Show()
  
    local rrc_t1 = f:CreateFontString("rrc_t1")
    rrc_t1:SetPoint("TOPLEFT", "rrc_t0", "BOTTOMLEFT", 0, -2)
    rrc_t1:SetFontObject(GameFontHighlight)
    rrc_t1:SetTextColor(0, 0, 1)
    rrc_t1:SetText("Raid Mana")
    rrc_t1:Show()
    
    local rrc_t2 = f:CreateFontString("rrc_t2")
    rrc_t2:SetPoint("TOPLEFT", "rrc_t1", "TOPRIGHT", 5, 0)
    rrc_t2:SetFontObject(GameFontHighlight)
    rrc_t2:SetTextColor(0.6, 0.6, 0.6)
    rrc_t2:SetText("Raid Dead")
    rrc_t2:Show()
    
    f:SetScript("OnUpdate", addon:rrc_onUpdate);
    
  end
  
  function addon:rrc_checkhealth()
    local n = GetNumRaidMembers()  
    if n > 0 then
      local c = 0
      local d
      local unit
      local i
      local act_hp
      local max_hp
      local per_hp
      local sum_per_hp = 0
      local avg_raid_hp
      for i = 1, n do
        unit = "raid"..i
        if(UnitIsDead(unit)) then
          c = c + 1
        elseif(UnitIsGhost(unit)) then
          c = c + 1
        elseif(not UnitIsConnected(unit)) then
          c = c + 1
        else
          act_hp = UnitHealth(unit);
          max_hp = UnitHealthMax(unit);
          per_hp = floor(act_hp/max_hp*100)
          sum_per_hp = sum_per_hp + per_hp
        end
      end
      d = n - c
      if d == 0 then
        avg_raid_hp = 0
      else    
        avg_raid_hp = floor(sum_per_hp / d)
      end
      -- avg_raid_hp liefert den % HP wert des Raids, offline, tote, oder ghosts werden nicht gewertet
      return avg_raid_hp
    end
  end
  
  function addon:rrc_checkmana()
    local n = GetNumRaidMembers()  
    if n > 0 then
      local c = 0
      local d
      local unit
      local i
      local act_mp
      local max_mp
      local per_mp
      local sum_per_mp = 0
      local avg_raid_mp
      for i = 1, n do
        unit = "raid"..i
        if(UnitIsDead(unit)) then
          c = c + 1
        elseif(UnitIsGhost(unit)) then
          c = c + 1
        elseif(not UnitIsConnected(unit)) then
          c = c + 1
        elseif(UnitPowerType(unit) > 0) then
          c = c + 1
        else
          act_mp = UnitMana(unit);
          max_mp = UnitManaMax(unit);
          per_mp = floor(act_mp/max_mp*100)
          sum_per_mp = sum_per_mp + per_mp
        end
      end
      d = n - c
      if d == 0 then
        avg_raid_mp = 0
      else    
        avg_raid_mp = floor(sum_per_mp / d)
      end
      -- avg_raid_mp liefert den % MP wert des Raids, offline, tote, ghosts oder klassen ohne Powertype=0 werden nicht gewertet
      return avg_raid_mp
    end
  end
  
  function addon:rrc_checkdead()
    local n = GetNumRaidMembers()  
    if n > 0 then
      local c = 0
      local unit
      local i
      for i = 1, n do
        unit = "raid"..i
        if(UnitIsDead(unit)) then
          c = c + 1
        end
      end
      -- c liefert Anzahl an toten
      return c
    end
  end
  
  function addon:rrc_checkghosts()
    local n = GetNumRaidMembers()  
    if n > 0 then
      local c = 0
      local unit
      local i
      for i = 1, n do
        unit = "raid"..i
        if(UnitIsGhost(unit)) then
          c = c + 1
        end
      end
      -- c liefert Anzahl an ghosts
      return c
    end
  end
  
  function addon:rrc_checkoffline()
    local n = GetNumRaidMembers()  
    if n > 0 then
      local c = 0
      local unit
      local i
      for i = 1, n do
        unit = "raid"..i
        if(not UnitIsConnected(unit)) then
          c = c + 1
        end
      end
      -- c liefert Anzahl an Offline
      return c
    end
  end
  
  addon:RegisterEvent"PLAYER_LOGIN"
