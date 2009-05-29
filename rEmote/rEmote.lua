  
  --helper frame
  local a = CreateFrame("Frame", nil, UIParent)
  
  --register events
  a:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
  a:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
  a:RegisterEvent("CHAT_MSG_MONSTER_SAY")
  --a:RegisterEvent("CHAT_MSG_MONSTER_WHISPER")
  a:RegisterEvent("CHAT_MSG_MONSTER_YELL")
  
  --setscript
  a:SetScript("OnEvent", function (self,event,arg1)    
    
    -- choose chattype
    CombatText_AddMessage(arg1, COMBAT_TEXT_SCROLL_FUNCTION, .7, .7, 1, "crit", nil)
    --RaidNotice_AddMessage(RaidBossEmoteFrame, arg1, ChatTypeInfo["RAID_WARNING"]) 
    --RaidNotice_AddMessage(RaidWarningFrame, arg1, ChatTypeInfo["RAID_WARNING"])    
    
    --play a sound
    PlaySoundFile("Interface\\AddOns\\rEmote\\Alarm.mp3")
  end)    