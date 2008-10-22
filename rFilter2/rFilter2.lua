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
  local rf2_player_name, _ = UnitName("player")
  local _, rf2_player_class = UnitClass("player")
  
  -----------------------------------------------------
  -- EDIT YOUR BUFFS/DEBUFFS IN HERE
  -- IMPORTANT, TAGS HAVE TO BE UNIQUE!!!
  -----------------------------------------------------

  -- to enable the icons OOC, put this to 1 while moving the icons and to 0 when ready
  -- 0 = off // 1 = on
  local testmode = 0
  
  --alpha when buff/debuff/cd not active
  --values between 0 and one are allowed
  local alpha_when_not_active = 0
  
  local alpha_when_in_combat = 0.3
  
  --make icon grey when buff noch active
  --0 = off // 1 = on
  local use_grey_vertex = 1

  --DEFAULT_CHAT_FRAME:AddMessage("found "..rf2_player_name.." : "..rf2_player_class)
  
  if rf2_player_name == "Grombur" and rf2_player_class == "HUNTER" then
    rf2_spell_list = {
      buffs = {
        --[1] = { tag = "battle", spellid = 2048, unit = "player", size = 32, fontsize = 24, posx = 0, posy = 0, framestrata = "BACKGROUND", anchor = "UIParent"},
        --[2] = { tag = "commanding", spellid = 469, unit = "player", size = 32, fontsize = 24, posx = 40, posy = 0, framestrata = "BACKGROUND", anchor = "UIParent"},
      },
      debuffs = {
        --[1] = { tag = "demo", spellid = 25203, unit = "target", size = 32, fontsize = 24, posx = 0, posy = 40, framestrata = "BACKGROUND", anchor = "UIParent"},
        --[2] = { tag = "sunder", spellid = 25225, unit = "target", size = 32, fontsize = 24, posx = 40, posy = 40, framestrata = "BACKGROUND", anchor = "UIParent"},
        --[3] = { tag = "clap", spellid = 25264, unit = "target", size = 32, fontsize = 24, posx = 80, posy = 40, framestrata = "BACKGROUND", anchor = "UIParent"},
        --[4] = { tag = "scorpid", spellid = 3043, unit = "target", size = 32, fontsize = 24, posx = 120, posy = 40, framestrata = "BACKGROUND", anchor = "UIParent"},
      },
      cooldowns = {
        --[1] = { tag = "wrath", spellid = 19574, size = 32, fontsize = 24, posx = 0, posy = 80, framestrata = "BACKGROUND", anchor = "UIParent"},
        --[2] = { tag = "rapid", spellid = 3045, size = 32, fontsize = 24, posx = 40, posy = 80, framestrata = "BACKGROUND", anchor = "UIParent"},
        --[3] = { tag = "arcane", spellid = 27019, size = 32, fontsize = 24, posx = 80, posy = 80, framestrata = "BACKGROUND", anchor = "UIParent"},
      },
    }
  elseif rf2_player_name == "Rothar" and rf2_player_class == "WARRIOR" then
    rf2_spell_list = {
      buffs = {
        --[1] = { tag = "commanding", spellid = 469,  unit = "player", size = 24, fontsize = 18, posx = -298, posy = -134, framestrata = "LOW", anchor = "UIParent"},
        --[2] = { tag = "battle",     spellid = 2048, unit = "player", size = 24, fontsize = 18, posx = -268, posy = -134, framestrata = "LOW", anchor = "UIParent"},
        --[3] = { tag = "block", spellid = 2565, size = 20, fontsize = 15, posx = 30, posy = -260, framestrata = "BACKGROUND", anchor = "UIParent"},
        --[3] = { tag = "rampage", spellid = 30033, size = 18, fontsize = 14, posx = -25, posy = -260, framestrata = "BACKGROUND", anchor = "UIParent"},
        --[3] = { tag = "berserker", spellid = 18499, size = 32, fontsize = 24, posx = 160, posy = 0, framestrata = "BACKGROUND", anchor = "UIParent"},
        --[5] = { tag = "block", spellid = 2565, size = 32, fontsize = 24, posx = 80, posy = 0, framestrata = "BACKGROUND", anchor = "UIParent"},
      },
      debuffs = {
        --[1] = { tag = "sunder",       spellid = 25225,  unit = "target", size = 24, fontsize = 18, posx = -230, posy = -134, framestrata = "LOW", anchor = "UIParent"},
        --[2] = { tag = "demo",         spellid = 25203,  unit = "target", size = 24, fontsize = 18, posx = -200, posy = -134, framestrata = "LOW", anchor = "UIParent"},
        --[3] = { tag = "clap",         spellid = 25264,  unit = "target", size = 24, fontsize = 18, posx = -170, posy = -134, framestrata = "LOW", anchor = "UIParent"},
        --[4] = { tag = "scorpid",      spellid = 3043,   unit = "target", size = 18, fontsize = 16, posx = 60, posy = -300, framestrata = "LOW", anchor = "UIParent"},
        --[5] = { tag = "fearie",       spellid = 26993,  unit = "target", size = 18, fontsize = 16, posx = 90, posy = -300, framestrata = "LOW", anchor = "UIParent"},
        --[6] = { tag = "fearieferal",  spellid = 27011,  unit = "target", size = 18, fontsize = 16, posx = 90, posy = -300, framestrata = "LOW", anchor = "UIParent"},
        --[7] = { tag = "curseofreck", spellid = 27226, size = 18, fontsize = 14, posx = 50, posy = -230, framestrata = "BACKGROUND", anchor = "UIParent"},
        --[8] = { tag = "curseoftong", spellid = 11719, size = 18, fontsize = 14, posx = 75, posy = -230, framestrata = "BACKGROUND", anchor = "UIParent"},
      },
      cooldowns = {
        --[1] = { tag = "bloodrage", spellid = 2687, size = 32, fontsize = 24, posx = 0, posy = 0, framestrata = "BACKGROUND", anchor = "UIParent"},
        --[2] = { tag = "berserkercool", spellid = 18499, size = 32, fontsize = 24, posx = 50, posy = 0, framestrata = "BACKGROUND", anchor = "UIParent"},
        --[1] = { tag = "revenge", spellid = 30357, size = 32, fontsize = 24, posx = 0, posy = 80, framestrata = "BACKGROUND", anchor = "UIParent"},
        --[2] = { tag = "shieldslam", spellid = 30356, size = 32, fontsize = 24, posx = 40, posy = 80, framestrata = "BACKGROUND", anchor = "UIParent"},
      },
    }   
  else
    rf2_spell_list = {
      buffs = {
        --[1] = { tag = "battle", spellid = 2048, unit = "player", size = 32, fontsize = 24, posx = 0, posy = 0, framestrata = "BACKGROUND", anchor = "UIParent"},
        --[2] = { tag = "commanding", spellid = 469, unit = "player", size = 32, fontsize = 24, posx = 40, posy = 0, framestrata = "BACKGROUND", anchor = "UIParent"},
      },
      debuffs = {
        --[1] = { tag = "demo", spellid = 25203, unit = "target", size = 32, fontsize = 24, posx = 0, posy = 40, framestrata = "BACKGROUND", anchor = "UIParent"},
        --[2] = { tag = "sunder", spellid = 25225, unit = "target", size = 32, fontsize = 24, posx = 40, posy = 40, framestrata = "BACKGROUND", anchor = "UIParent"},
        --[3] = { tag = "clap", spellid = 25264, unit = "target", size = 32, fontsize = 24, posx = 80, posy = 40, framestrata = "BACKGROUND", anchor = "UIParent"},
        --[4] = { tag = "scorpid", spellid = 3043, unit = "target", size = 32, fontsize = 24, posx = 120, posy = 40, framestrata = "BACKGROUND", anchor = "UIParent"},
      },
      cooldowns = {
        --[1] = { tag = "revenge", spellid = 30357, size = 32, fontsize = 24, posx = 0, posy = 80, framestrata = "BACKGROUND", anchor = "UIParent"},
        --[2] = { tag = "shieldslam", spellid = 30356, size = 32, fontsize = 24, posx = 40, posy = 80, framestrata = "BACKGROUND", anchor = "UIParent"},
        --[3] = { tag = "bloodrage", spellid = 2687, size = 32, fontsize = 24, posx = 80, posy = 80, framestrata = "BACKGROUND", anchor = "UIParent"},
      },
    }    
  end
  
  -----------------------------------------------------
  -- DO NOT TOUCH ANYTHING BELOW THIS LINE !!!
  -----------------------------------------------------
  
  addon:SetScript("OnEvent", function()
    if(event=="PLAYER_LOGIN") then
      for index,value in ipairs(rf2_spell_list.buffs) do 
        local string = rf2_spell_list.buffs[index]
        addon:rf2_create_icon(string.spellid,"rf2_"..string.tag,string.size,string.fontsize,string.posx,string.posy,string.framestrata,string.anchor)
      end
      for index,value in ipairs(rf2_spell_list.debuffs) do 
        local string = rf2_spell_list.debuffs[index]
        addon:rf2_create_icon(string.spellid,"rf2_"..string.tag,string.size,string.fontsize,string.posx,string.posy,string.framestrata,string.anchor)
      end      
      for index,value in ipairs(rf2_spell_list.cooldowns) do 
        local string = rf2_spell_list.cooldowns[index]
        addon:rf2_create_icon(string.spellid,"rf2_"..string.tag,string.size,string.fontsize,string.posx,string.posy,string.framestrata,string.anchor)
      end
      addon:rf2_onUpdate()
    end
  end)
  
  function addon:rf2_create_icon(spellId,frameName,size,fontsize,posX,posY,framestrata,anchor)
    local spellName, spellRank, SpellIcon, SpellCost, spellIsFunnel, spellPowerType, spellCastTime, spellMinRange, spellMaxRange = GetSpellInfo(spellId)
    local f = CreateFrame("Frame",frameName,UIParent)
    f:SetFrameStrata(framestrata)
    f:SetWidth(size)
    f:SetHeight(size)
    local t = f:CreateTexture(frameName.."_icon","BACKGROUND")
    t:SetTexture(SpellIcon)
    t:SetTexCoord(0.1,0.9,0.1,0.9)
    t:SetAllPoints(f)
    f.texture = t
    local t2 = f:CreateTexture(nil,"LOW")
    t2:SetTexture("Interface\\AddOns\\rTextures\\gloss")
    t2:SetPoint("TOPLEFT", f, "TOPLEFT", -2, 2)
    t2:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 2, -2)
    f.texture = t2
    local time = f:CreateFontString(frameName.."_time", "ARTWORK")
    time:SetPoint("CENTER", f, "CENTER", 0, 1)
    time:SetFont(NAMEPLATE_FONT,fontsize,"OUTLINE")
    time:SetTextColor(1, 1, 0)
    time:SetText("")
    time:Show()
    local num = f:CreateFontString(frameName.."_num", "OVERLAY")
    num:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 4, -4)
    num:SetFont(NAMEPLATE_FONT,floor(fontsize*0.9),"OUTLINE")
    num:SetTextColor(0.8, 0.8, 0.8)
    num:SetText("")
    num:Show()
    f:SetPoint("CENTER",posX,posY)
    f:Show()
  end
  
  
  function addon:rf2_onUpdate()
    local f = CreateFrame("Frame", "rf2_OnUpdateFrame")
    local totalElapsed = 0
    local function rf2_OnUpdateFunc(self, elapsed)
      totalElapsed = totalElapsed + elapsed
      local rf2_update_timer = 1
      if (totalElapsed < rf2_update_timer) then 
        return 
      else
        totalElapsed = totalElapsed - floor(totalElapsed)
        for index,value in ipairs(rf2_spell_list.buffs) do 
          local string = rf2_spell_list.buffs[index]
          addon:rf2_check_buff(string.tag,string.spellid,string.unit)
        end
        for index,value in ipairs(rf2_spell_list.debuffs) do 
          local string = rf2_spell_list.debuffs[index]
          addon:rf2_check_debuff(string.tag,string.spellid,string.unit)
        end
        for index,value in ipairs(rf2_spell_list.cooldowns) do 
          local string = rf2_spell_list.cooldowns[index]
          addon:rf2_check_cooldown(string.tag,string.spellid)
        end
      end
    end
    f:SetScript("OnUpdate", rf2_OnUpdateFunc)
    f:Show()    
  end
  
 
  function addon:rf2_check_buff(frameTag,spellId,unit)
    local spellName, spellRank, SpellIcon, SpellCost, spellIsFunnel, spellPowerType, spellCastTime, spellMinRange, spellMaxRange = GetSpellInfo(spellId)
    
    if unit == nil then
      unit = "player"
    end
    
    local f = _G["rf2_"..frameTag]
    f:SetAlpha(alpha_when_not_active)
    
    if UnitAffectingCombat("player") == 1 then
      f:SetAlpha(alpha_when_in_combat)
    end
    
    local f2 = _G["rf2_"..frameTag.."_time"]
    local f3 = _G["rf2_"..frameTag.."_num"]
    f2:SetText("")
    f3:SetText("")
    
    local f4 = _G["rf2_"..frameTag.."_icon"]
    if use_grey_vertex == 1
    then
      local shaderSupported = f4:SetDesaturated(1)
    end
    
    for i = 1, 40 do
      local name, rank, texture, applications, debuffType, duration, timeleft, isMine, isStealable = UnitBuff(unit, i)
      --local name, rank, texture, applications, duration, timeleft = UnitBuff(unit, i)
      
      if name == spellName then

        timeleft = timeleft-GetTime()
        --DEFAULT_CHAT_FRAME:AddMessage("found "..name.." timeleft "..timeleft-GetTime().." duration "..duration.." now "..GetTime())

        local floortime = ""
        if timeleft ~= nil then
          if timeleft >= 60 then 
            floortime = floor((timeleft/60)+1).."m"
          elseif timeleft <= 1.5 then
            floortime = floor(timeleft*10)/10
          else
            floortime = floor(timeleft+0.5)  
          end
        end
        local floornum = ""
        if applications ~= nil then
          floornum = floor(applications)
          if floornum == 0 then
            floornum = ""
          end
        end 
        
        f:SetAlpha(1)
        f2:SetText(floortime)
        f3:SetText(floornum)
        
        if use_grey_vertex == 1
        then
          local shaderSupported = f4:SetDesaturated(nil)
        end
        
      end
    end
    
    if testmode == 1 
    then
      f:SetAlpha(1)
      f2:SetText("99")
      f3:SetText("9")
    end
    
  end
  
  function addon:rf2_check_debuff(frameTag,spellId,unit)
    local spellName, spellRank, SpellIcon, SpellCost, spellIsFunnel, spellPowerType, spellCastTime, spellMinRange, spellMaxRange = GetSpellInfo(spellId)

    if unit == nil then
      unit = "target"
    end

    local f = _G["rf2_"..frameTag]
    f:SetAlpha(alpha_when_not_active)
    
    if UnitAffectingCombat("player") == 1 then
      f:SetAlpha(alpha_when_in_combat)
    end

    local f2 = _G["rf2_"..frameTag.."_time"]
    local f3 = _G["rf2_"..frameTag.."_num"]
    f2:SetText("")
    f3:SetText("")
    
    local f4 = _G["rf2_"..frameTag.."_icon"]
    if use_grey_vertex == 1
    then
      local shaderSupported = f4:SetDesaturated(1)
    end

    for i = 1, 40 do
      local name, _, texture, applications, debufftype, duration, timeleft = UnitDebuff(unit, i)
      if name == spellName then
      
        timeleft = timeleft-GetTime()
        --DEFAULT_CHAT_FRAME:AddMessage("found "..name.." timeleft "..timeleft.." duration "..duration.." now "..GetTime())
      
        local floortime = ""
        if timeleft ~= nil then
          if timeleft >= 60 then 
            floortime = floor((timeleft/60)+1).."m"
          elseif timeleft <= 1.5 then
            floortime = floor(timeleft*10)/10
          else
            floortime = floor(timeleft+0.5)  
          end
        end
        local floornum = ""
        if applications ~= nil then
          floornum = floor(applications)
          if floornum == 0 then
            floornum = ""
          end
        end        
        
        f:SetAlpha(1)
        f2:SetText(floortime)
        f3:SetText(floornum)
        
        if use_grey_vertex == 1
        then
          local shaderSupported = f4:SetDesaturated(nil)
        end
        
      end
    end

    if testmode == 1 
    then
      f:SetAlpha(1)
      f2:SetText("99")
      f3:SetText("9")
    end
    
  end
  
  
  function addon:rf2_check_cooldown(frameTag,spellId)
    local spellName, spellRank, SpellIcon, SpellCost, spellIsFunnel, spellPowerType, spellCastTime, spellMinRange, spellMaxRange = GetSpellInfo(spellId)
    
    local f = _G["rf2_"..frameTag]
    f:SetAlpha(alpha_when_not_active)

    local f2 = _G["rf2_"..frameTag.."_time"]
    local f3 = _G["rf2_"..frameTag.."_num"]
    f2:SetText("")
    f3:SetText("")
    
    local f4 = _G["rf2_"..frameTag.."_icon"]
    if use_grey_vertex == 1
    then
      f4:SetVertexColor(0.2,0.2,0.2)
    end

    local spellCooldownStartTime, spellCooldownDuration, spellEnabled = GetSpellCooldown(spellName);
    
    local localstartime = 0
    if spellCooldownStartTime ~= nil then
      localstartime = spellCooldownStartTime
    end
    
    local floortime = 0
    if spellCooldownDuration ~= nil then
      floortime = spellCooldownDuration
    end
    
    local floornum = ""
    if spellEnabled ~= nil then
      floornum = floor(spellEnabled)
      if floornum == 0 then
        floornum = "1"
      else
        floornum = ""
      end
    end
    
    local now = GetTime()
    local cooldown = (localstartime+floortime-now)
    cooldown = floor(cooldown+0.5)
    
    if cooldown > 0 then
      f:SetAlpha(1)
      f2:SetText(cooldown)
      f3:SetText(floornum)
      
      if use_grey_vertex == 1
      then
        f4:SetVertexColor(1,1,1)
      end
      
    end
      
    if testmode == 1 
    then
      f:SetAlpha(1)
      f2:SetText("99")
      f3:SetText("9")
    end

  end
  
  addon:RegisterEvent"PLAYER_LOGIN"