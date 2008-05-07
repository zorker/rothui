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
      * Neither the name of rFilter nor the names of its contributors may
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
---------------------------------------------------------------------------]]
  
  local addon = CreateFrame"Frame"
  local _G = getfenv(0)
  
  addon:SetScript("OnEvent", function()
    if(event=="PLAYER_LOGIN") then
      --spellid (icon-texture), framename, and coordinates
      --30356 = shield slam spellid
      --30357 = revenge 
      addon:rsc_create_icon(30356,"rsc_frame1",0,0)
      addon:rsc_create_icon(30357,"rsc_frame2",64,0)
    end  
    
    if(event=="SPELL_UPDATE_COOLDOWN") then
      addon:rsc_check_spell(30356, "rsc_frame1")
      addon:rsc_check_spell(30357, "rsc_frame2")
    end 
    
    --[[ 
    --want to test the SPELL_UPDATE_COOLDOWN-Event
    if(event=="PLAYER_REGEN_ENABLED") then
      --framename
      addon:rsc_hide_frame("rsc_frame1")
      addon:rsc_hide_frame("rsc_frame2")
    end  
    if(event=="PLAYER_REGEN_DISABLED") then
      --spellid, framename (you need to know which frame to hide/show)
      addon:rsc_check_spell(30356, "rsc_frame1")
      addon:rsc_check_spell(30357, "rsc_frame2")
    end  
    if (event=="UNIT_AURA" and arg1=="target") then
      addon:rsc_check_spell(30356, "rsc_frame1")
      addon:rsc_check_spell(30357, "rsc_frame2")
    end
    if (event=="PLAYER_TARGET_CHANGED") then
      addon:rsc_check_spell(30356, "rsc_frame1")
      addon:rsc_check_spell(30357, "rsc_frame2")    
    end
    if(event=="PLAYER_AURAS_CHANGED") then
      addon:rsc_check_spell(30356, "rsc_frame1")
      addon:rsc_check_spell(30357, "rsc_frame2")
    end
    ]]--
  end)
  
  function addon:rsc_create_icon(spellId,frameName,posX,posY)
    local spellName, spellRank, SpellIcon, SpellCost, spellIsFunnel, spellPowerType, spellCastTime, spellMinRange, spellMaxRange = GetSpellInfo(spellId)
    local f = CreateFrame("Frame",frameName,UIParent)
    f:SetFrameStrata("BACKGROUND")
    f:SetWidth(64)
    f:SetHeight(64)
    local t = f:CreateTexture(nil,"BACKGROUND")
    t:SetTexture(SpellIcon)
    t:SetAllPoints(f)
    f.texture = t
    f:SetPoint("CENTER",posX,posY)
    f:Hide()
  end

  function addon:rsc_check_spell(spellId,frameName)
    local spellName, spellRank, SpellIcon, SpellCost, spellIsFunnel, spellPowerType, spellCastTime, spellMinRange, spellMaxRange = GetSpellInfo(spellId)
    local check_spell = 0
    local spellUsable, spellNoMana = IsUsableSpell(spellName)
    local spellCooldownStartTime, spellCooldownDuration, spellEnabled = GetSpellCooldown(spellName);
    if UnitAffectingCombat("player") == 1 then
      if UnitExists("target") == 1 then
        if IsSpellInRange(spellName,"target") == 1 then
          if spellUsable == 1 then
            if spellNoMana ~= 1 then  
              if spellCooldownDuration == 0 then
                check_spell = 1
              end
            end
          end
        end
      end
    end
    if check_spell == 1 then
      addon:rsc_show_frame(frameName)
    else
      addon:rsc_hide_frame(frameName)
    end    
  end
  
  function addon:rsc_show_frame(frameName)
    frameName:Show()
  end
  
  function addon:rsc_hide_frame(frameName)
    frameName:Hide()    
  end
  
  --addon:RegisterEvent"PLAYER_AURAS_CHANGED"
  addon:RegisterEvent"PLAYER_LOGIN"
  --addon:RegisterEvent"PLAYER_REGEN_DISABLED"
  --addon:RegisterEvent"PLAYER_REGEN_ENABLED"
  --addon:RegisterEvent"PLAYER_TARGET_CHANGED"
  --addon:RegisterEvent"UNIT_AURA"
  addon:RegisterEvent"SPELL_UPDATE_COOLDOWN"
  