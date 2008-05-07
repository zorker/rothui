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
      --spellid (icon-texture), framename, coordinates, framestrata
      --30356 = shield slam spellid
      --30357 = revenge 
      addon:rsc_create_icon(30356,"rsc_frame1",0,0,"MEDIUM") --ss
      addon:rsc_create_icon(30357,"rsc_frame2",0,0,"LOW") --rev
      addon:rsc_create_icon(2565,"rsc_frame3",0,40,"BACKGROUND") --block
      addon:rsc_create_icon(29707,"rsc_frame4",-40,0,"BACKGROUND") --heroic
      addon:rsc_create_icon(30022,"rsc_frame5",0,0,"BACKGROUND") --deva
      addon:rsc_onUpDate()
    end  
    
    if(event=="PLAYER_REGEN_ENABLED") then
      addon:rsc_hide_timeframe("OnUpdateDemoFrame")
    end  
    
    if(event=="PLAYER_REGEN_DISABLED") then
      addon:rsc_show_timeframe("OnUpdateDemoFrame")
    end  
    
  end)
  
  function addon:rsc_create_icon(spellId,frameName,posX,posY,framestrata)
    local spellName, spellRank, SpellIcon, SpellCost, spellIsFunnel, spellPowerType, spellCastTime, spellMinRange, spellMaxRange = GetSpellInfo(spellId)
    local f = CreateFrame("Frame",frameName,UIParent)
    f:SetFrameStrata(framestrata)
    f:SetWidth(32)
    f:SetHeight(32)
    local t = f:CreateTexture(nil,"BACKGROUND")
    t:SetTexture(SpellIcon)
    t:SetTexCoord(0.1,0.9,0.1,0.9)
    t:SetAllPoints(f)
    f.texture = t

    local t2 = f:CreateTexture(nil,"LOW")
    t2:SetTexture("Interface\\AddOns\\rTextures\\gloss")
    t2:SetPoint("TOPLEFT", f, "TOPLEFT", -2, 2)
    t2:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 2, -2)
    f.texture = t2
    
    f:SetPoint("CENTER",posX,posY)
    f:Hide()
  end

  function addon:rsc_onUpDate()
    local f = CreateFrame("Frame", "OnUpdateDemoFrame")
    local totalElapsed = 0
    local function onUpdateDemo(self, elapsed)
      totalElapsed = totalElapsed + elapsed
      if (totalElapsed < 0.3) then 
        return 
      else
        --ChatFrame1:AddMessage("tick"..totalElapsed)
        --totalElapsed = totalElapsed - floor(totalElapsed)
        totalElapsed = totalElapsed - 0.3
        addon:rsc_check_spell(30356, "rsc_frame1")
        addon:rsc_check_spell(30357, "rsc_frame2")   
        addon:rsc_check_spell(2565, "rsc_frame3")
        addon:rsc_check_spell(29707, "rsc_frame4")
        addon:rsc_check_spell(30022, "rsc_frame5")
      end
    end
    f:SetScript("OnUpdate", onUpdateDemo)
    if UnitAffectingCombat("player") == 1 then
      f:Show()
    else
      f:Hide()
    end
  end

  function addon:rsc_check_spell(spellId,frameName)
    local spellName, spellRank, SpellIcon, SpellCost, spellIsFunnel, spellPowerType, spellCastTime, spellMinRange, spellMaxRange = GetSpellInfo(spellId)
    local check_spell = 0
    local spellUsable, spellNoMana = IsUsableSpell(spellName)
    local spellCooldownStartTime, spellCooldownDuration, spellEnabled = GetSpellCooldown(spellName);
    local localizedClass, englishClass = UnitClass("player");
    local stance = GetShapeshiftForm(true);
    
    --WARRIORS will get this only when stance == 2
    
    if UnitAffectingCombat("player") == 1 then
      if UnitExists("target") == 1 then
        if IsSpellInRange(spellName,"target") == 1 or IsSpellInRange(spellName,"target") == nil then
          if spellUsable == 1 then
            if spellNoMana ~= 1 then  
              if spellCooldownDuration < 1 then
                if englishClass == "WARRIOR" then
                  if stance == 2 then
                    if spellId == 29707 then
                      --heroic
                      if UnitMana("player") > 50 then
                        --ChatFrame1:AddMessage("tick"..UnitMana("player"))
                        check_spell = 1
                      end
                    else
                      check_spell = 1
                    end
                  end
                else  
                  check_spell = 1
                end
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
    local f = _G[frameName]
    f:Show() 
  end
  
  function addon:rsc_hide_frame(frameName)
    local f = _G[frameName]
    f:Hide()    
  end
  
  function addon:rsc_show_timeframe(frameName)
    local f = _G[frameName]
    f:Show() 
  end
  
  function addon:rsc_hide_timeframe(frameName)
    local f = _G[frameName]
    f:Hide()    
  end
  
  addon:RegisterEvent"PLAYER_LOGIN"
  addon:RegisterEvent"PLAYER_REGEN_DISABLED"
  addon:RegisterEvent"PLAYER_REGEN_ENABLED"
