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

  --DEFAULT_CHAT_FRAME:AddMessage("found "..rf2_player_name.." : "..rf2_player_class)
  
  if rf2_player_name == "Grombur" and rf2_player_class == "HUNTER" then
    rf2_spell_list = {
      buffs = {
        [1] = { tag = "battle", spellid = 2048, size = 32, fontsize = 24, posx = 0, posy = 0, framestrata = "BACKGROUND", anchor = "UIParent"},
        [2] = { tag = "commanding", spellid = 469, size = 32, fontsize = 24, posx = 40, posy = 0, framestrata = "BACKGROUND", anchor = "UIParent"},
      },
      debuffs = {
        [1] = { tag = "demo", spellid = 25203, size = 32, fontsize = 24, posx = 0, posy = 40, framestrata = "BACKGROUND", anchor = "UIParent"},
        [2] = { tag = "sunder", spellid = 25225, size = 32, fontsize = 24, posx = 40, posy = 40, framestrata = "BACKGROUND", anchor = "UIParent"},
        [3] = { tag = "clap", spellid = 25264, size = 32, fontsize = 24, posx = 80, posy = 40, framestrata = "BACKGROUND", anchor = "UIParent"},
        [4] = { tag = "scorpid", spellid = 3043, size = 32, fontsize = 24, posx = 120, posy = 40, framestrata = "BACKGROUND", anchor = "UIParent"},
      },
      cooldowns = {
        [1] = { tag = "wrath", spellid = 19574, size = 32, fontsize = 24, posx = 0, posy = 80, framestrata = "BACKGROUND", anchor = "UIParent"},
        [2] = { tag = "rapid", spellid = 3045, size = 32, fontsize = 24, posx = 40, posy = 80, framestrata = "BACKGROUND", anchor = "UIParent"},
        [3] = { tag = "arcane", spellid = 27019, size = 32, fontsize = 24, posx = 80, posy = 80, framestrata = "BACKGROUND", anchor = "UIParent"},
      },
    }
  elseif rf2_player_name == "Rothar" and rf2_player_class == "WARRIOR" then
    rf2_spell_list = {
      buffs = {
        [1] = { tag = "battle", spellid = 2048, size = 32, fontsize = 24, posx = 0, posy = 0, framestrata = "BACKGROUND", anchor = "UIParent"},
        [2] = { tag = "commanding", spellid = 469, size = 32, fontsize = 24, posx = 40, posy = 0, framestrata = "BACKGROUND", anchor = "UIParent"},
      },
      debuffs = {
        [1] = { tag = "demo", spellid = 25203, size = 32, fontsize = 24, posx = 0, posy = 40, framestrata = "BACKGROUND", anchor = "UIParent"},
        [2] = { tag = "sunder", spellid = 25225, size = 32, fontsize = 24, posx = 40, posy = 40, framestrata = "BACKGROUND", anchor = "UIParent"},
        [3] = { tag = "clap", spellid = 25264, size = 32, fontsize = 24, posx = 80, posy = 40, framestrata = "BACKGROUND", anchor = "UIParent"},
        [4] = { tag = "scorpid", spellid = 3043, size = 32, fontsize = 24, posx = 120, posy = 40, framestrata = "BACKGROUND", anchor = "UIParent"},
      },
      cooldowns = {
        [1] = { tag = "revenge", spellid = 30357, size = 32, fontsize = 24, posx = 0, posy = 80, framestrata = "BACKGROUND", anchor = "UIParent"},
        [2] = { tag = "shieldslam", spellid = 30356, size = 32, fontsize = 24, posx = 40, posy = 80, framestrata = "BACKGROUND", anchor = "UIParent"},
        [3] = { tag = "bloodrage", spellid = 2687, size = 32, fontsize = 24, posx = 80, posy = 80, framestrata = "BACKGROUND", anchor = "UIParent"},
      },
    }   
  else
    rf2_spell_list = {
      buffs = {
        [1] = { tag = "battle", spellid = 2048, size = 32, fontsize = 24, posx = 0, posy = 0, framestrata = "BACKGROUND", anchor = "UIParent"},
        --[2] = { tag = "commanding", spellid = 469, size = 32, fontsize = 24, posx = 40, posy = 0, framestrata = "BACKGROUND", anchor = "UIParent"},
      },
      debuffs = {
        [1] = { tag = "demo", spellid = 25203, size = 32, fontsize = 24, posx = 0, posy = 40, framestrata = "BACKGROUND", anchor = "UIParent"},
        [2] = { tag = "sunder", spellid = 25225, size = 32, fontsize = 24, posx = 40, posy = 40, framestrata = "BACKGROUND", anchor = "UIParent"},
        --[3] = { tag = "clap", spellid = 25264, size = 32, fontsize = 24, posx = 80, posy = 40, framestrata = "BACKGROUND", anchor = "UIParent"},
        --[4] = { tag = "scorpid", spellid = 3043, size = 32, fontsize = 24, posx = 120, posy = 40, framestrata = "BACKGROUND", anchor = "UIParent"},
      },
      cooldowns = {
        [1] = { tag = "revenge", spellid = 30357, size = 32, fontsize = 24, posx = 0, posy = 80, framestrata = "BACKGROUND", anchor = "UIParent"},
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
      --DEFAULT_CHAT_FRAME:AddMessage("hallo welt")
      for index,value in ipairs(rf2_spell_list.buffs) do 
        local string = rf2_spell_list.buffs[index]
        --DEFAULT_CHAT_FRAME:AddMessage(tostring(index).." : "..string.tag.." : "..string.spellid.." : "..string.posx.." : "..string.posy.." : "..string.framestrata.." : "..string.anchor)
        --create the frames
        addon:rf2_create_icon(string.spellid,"rf2_"..string.tag,string.size,string.fontsize,string.posx,string.posy,string.framestrata,string.anchor)
      end
      for index,value in ipairs(rf2_spell_list.debuffs) do 
        local string = rf2_spell_list.debuffs[index]
        --DEFAULT_CHAT_FRAME:AddMessage(tostring(index).." : "..string.tag.." : "..string.spellid.." : "..string.posx.." : "..string.posy.." : "..string.framestrata.." : "..string.anchor)
        --create the frames
        addon:rf2_create_icon(string.spellid,"rf2_"..string.tag,string.size,string.fontsize,string.posx,string.posy,string.framestrata,string.anchor)
      end      
      for index,value in ipairs(rf2_spell_list.cooldowns) do 
        local string = rf2_spell_list.cooldowns[index]
        --DEFAULT_CHAT_FRAME:AddMessage(tostring(index).." : "..string.tag.." : "..string.spellid.." : "..string.posx.." : "..string.posy.." : "..string.framestrata.." : "..string.anchor)
        --create the frames
        addon:rf2_create_icon(string.spellid,"rf2_"..string.tag,string.size,string.fontsize,string.posx,string.posy,string.framestrata,string.anchor)
      end   
      --create the OnUpdate timer frame
      addon:rf2_onUpdate()
    end

    --stop timer when out of combat
    if(event=="PLAYER_REGEN_ENABLED") then
      addon:rf2_hide_timeframe("rf2_OnUpdateFrame")
      for index,value in ipairs(rf2_spell_list.buffs) do 
        local string = rf2_spell_list.buffs[index]
        local f = _G["rf2_"..string.tag]
        f:Hide()
      end
      for index,value in ipairs(rf2_spell_list.debuffs) do 
        local string = rf2_spell_list.debuffs[index]
        local f = _G["rf2_"..string.tag]
        f:Hide()
      end      
      for index,value in ipairs(rf2_spell_list.cooldowns) do 
        local string = rf2_spell_list.cooldowns[index]
        local f = _G["rf2_"..string.tag]
        f:Hide()
      end  
    end
    
    --start the timer when in combat
    if(event=="PLAYER_REGEN_DISABLED") then
      addon:rf2_show_timeframe("rf2_OnUpdateFrame")
    end  


  end)
  
  function addon:rf2_create_icon(spellId,frameName,size,fontsize,posX,posY,framestrata,anchor)
    --get spell infos
    local spellName, spellRank, SpellIcon, SpellCost, spellIsFunnel, spellPowerType, spellCastTime, spellMinRange, spellMaxRange = GetSpellInfo(spellId)
    --create the basic frame
    local f = CreateFrame("Frame",frameName,UIParent)
    f:SetFrameStrata(framestrata)
    f:SetWidth(size)
    f:SetHeight(size)
    --create icon texture
    local t = f:CreateTexture(nil,"BACKGROUND")
    t:SetTexture(SpellIcon)
    t:SetTexCoord(0.1,0.9,0.1,0.9)
    t:SetAllPoints(f)
    f.texture = t
    --create gloss texture
    local t2 = f:CreateTexture(nil,"LOW")
    t2:SetTexture("Interface\\AddOns\\rTextures\\gloss")
    t2:SetPoint("TOPLEFT", f, "TOPLEFT", -2, 2)
    t2:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 2, -2)
    f.texture = t2
    local time = f:CreateFontString(frameName.."_time", "OVERLAY")
    time:SetPoint("CENTER", f, "CENTER", 0, 0)
    --time:SetFontObject(GameFontHighlight)
    time:SetFont(NAMEPLATE_FONT,fontsize,"OUTLINE")
    time:SetTextColor(1, 1, 0)
    time:SetText("")
    time:Show()
    local num = f:CreateFontString(frameName.."_num", "ARTWORK")
    num:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 0, 0)
    --time:SetFontObject(GameFontHighlight)
    num:SetFont(NAMEPLATE_FONT,floor(fontsize*0.8),"OUTLINE")
    num:SetTextColor(0.8, 0.8, 0.8)
    num:SetText("")
    num:Show()
    --position the frame
    f:SetPoint("CENTER",posX,posY)
    f:Hide()
  end
  
  
  function addon:rf2_onUpdate()
    --create the timer frame that will "contain" the timer
    --timer can be switched on/off when showing/hiding the frame
    local f = CreateFrame("Frame", "rf2_OnUpdateFrame")
    local totalElapsed = 0
    --hacked timer function from Iriel
    local function rf2_OnUpdateFunc(self, elapsed)
      totalElapsed = totalElapsed + elapsed
      --determines how often the function is called
      local rf2_update_timer = 1
      if (totalElapsed < rf2_update_timer) then 
        --do nothing
        --THIS ONE IS IMPORTANT
        --you need this or the onUpdate function will kill your CPU
        return 
      else
        --ChatFrame1:AddMessage("tick"..totalElapsed)
        totalElapsed = totalElapsed - floor(totalElapsed)
        --totalElapsed = totalElapsed - rf2_update_timer
        --do sth
        for index,value in ipairs(rf2_spell_list.buffs) do 
          local string = rf2_spell_list.buffs[index]
          --call check buff
          --DEFAULT_CHAT_FRAME:AddMessage("check buff")
          addon:rf2_check_buff(string.tag,string.spellid)
        end
        for index,value in ipairs(rf2_spell_list.debuffs) do 
          local string = rf2_spell_list.debuffs[index]
          --call check debuff
          --DEFAULT_CHAT_FRAME:AddMessage("check debuff")
          addon:rf2_check_debuff(string.tag,string.spellid)
        end
        for index,value in ipairs(rf2_spell_list.cooldowns) do 
          local string = rf2_spell_list.cooldowns[index]
          --call check cooldowns
          --DEFAULT_CHAT_FRAME:AddMessage("check cooldowns")
          addon:rf2_check_cooldown(string.tag,string.spellid)
        end
      end
    end
    --set a script on the frame that activates itself on each onupdate (every frame generation!)
    f:SetScript("OnUpdate", rf2_OnUpdateFunc)
    --Hide (STOP) the timer out of combat, otherwise Show (START) it
    if UnitAffectingCombat("player") == 1 then
      f:Show()
    else
      f:Hide()
    end
  end
  
  --starts the onupdate timer
  function addon:rf2_show_timeframe(frameName)
    local f = _G[frameName]
    f:Show()
  end
  
  --stops the onupdate timer
  function addon:rf2_hide_timeframe(frameName)
    local f = _G[frameName]
    f:Hide()
  end
  
  function addon:rf2_check_buff(frameTag,spellId)
    local spellName, spellRank, SpellIcon, SpellCost, spellIsFunnel, spellPowerType, spellCastTime, spellMinRange, spellMaxRange = GetSpellInfo(spellId)
    local f = _G["rf2_"..frameTag]
    f:Hide()
    local f2 = _G["rf2_"..frameTag.."_time"]
    local f3 = _G["rf2_"..frameTag.."_num"]
    for i = 1, 40 do
      local name, rank, texture, applications, duration, timeleft = UnitBuff("player", i)
      if name == spellName then
        local floortime = ""
        if timeleft ~= nil then
          floortime = floor(timeleft)
        end
        local floornum = ""
        if applications ~= nil then
          floornum = floor(applications)
          if floornum == 0 then
            floornum = ""
          end
        end 
        --DEFAULT_CHAT_FRAME:AddMessage("found "..name.." : "..floortime)
        f:Show()
        f2:SetText(floortime)
        f3:SetText(floornum)
      end
    end
  end
  
  function addon:rf2_check_debuff(frameTag,spellId)
    local spellName, spellRank, SpellIcon, SpellCost, spellIsFunnel, spellPowerType, spellCastTime, spellMinRange, spellMaxRange = GetSpellInfo(spellId)
    local f = _G["rf2_"..frameTag]
    f:Hide()
    local f2 = _G["rf2_"..frameTag.."_time"]
    local f3 = _G["rf2_"..frameTag.."_num"]
    for i = 1, 40 do
      local name, _, texture, applications, debufftype, duration, timeleft = UnitDebuff("target", i)
      if name == spellName then
        local floortime = ""
        if timeleft ~= nil then
          floortime = floor(timeleft)
        end
        local floornum = ""
        if applications ~= nil then
          floornum = floor(applications)
          if floornum == 0 then
            floornum = ""
          end
        end        
        --DEFAULT_CHAT_FRAME:AddMessage("found "..spellName.." : "..floortime)
        f:Show()
        f2:SetText(floortime)
        f3:SetText(floornum)
      end
    end
  end
  
  
  function addon:rf2_check_cooldown(frameTag,spellId)
    local spellName, spellRank, SpellIcon, SpellCost, spellIsFunnel, spellPowerType, spellCastTime, spellMinRange, spellMaxRange = GetSpellInfo(spellId)
    local f = _G["rf2_"..frameTag]
    f:Hide()
    local f2 = _G["rf2_"..frameTag.."_time"]
    local f3 = _G["rf2_"..frameTag.."_num"]
    local spellCooldownStartTime, spellCooldownDuration, spellEnabled = GetSpellCooldown(spellName);
    
    local localstartime = 0
    if spellCooldownStartTime ~= nil then
      localstartime = floor(spellCooldownStartTime)
    end
    
    local floortime = 0
    if spellCooldownDuration ~= nil then
      floortime = floor(spellCooldownDuration)
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
    local now = floor(GetTime())
    --DEFAULT_CHAT_FRAME:AddMessage("found "..frameTag.." : "..floortime.." : "..localstartime.." : "..now)
    local cooldown = (localstartime+floortime-now)
    --if cooldown == 2 then
    --  DEFAULT_CHAT_FRAME:AddMessage(spellName.." READY IN 2 SECONDS !!!")
    --end
    if cooldown > 1 then
      f:Show()
    end
    f2:SetText(cooldown)
    f3:SetText(floornum)
    
  end
  
  
  addon:RegisterEvent"PLAYER_LOGIN"
  addon:RegisterEvent"PLAYER_REGEN_DISABLED"
  addon:RegisterEvent"PLAYER_REGEN_ENABLED"