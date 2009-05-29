  
  --helper frame
  local a = CreateFrame("Frame", nil, UIParent)
  
  --register events
  a:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
  a:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
  a:RegisterEvent("CHAT_MSG_MONSTER_SAY")
  --a:RegisterEvent("CHAT_MSG_MONSTER_WHISPER")
  a:RegisterEvent("CHAT_MSG_MONSTER_YELL")
  
  --setscript
  a:SetScript("OnEvent", function (self,event,arg1,arg2)    
    
    local string
    
    if event == "CHAT_MSG_MONSTER_EMOTE" then
      string = format(arg1, arg2)
    else
      string = arg1
    end
    
    -- choose chattype
    
    --post to blizzard combat text
    CombatText_AddMessage(string, COMBAT_TEXT_SCROLL_FUNCTION, 1, 0, 0, "crit", nil)
    
    --post to boss emote frame
    --RaidNotice_AddMessage(RaidBossEmoteFrame, string, ChatTypeInfo["RAID_WARNING"]) 
    
    --post to raidwarningframe
    --RaidNotice_AddMessage(RaidWarningFrame, string, ChatTypeInfo["RAID_WARNING"])    
    
    --play a sound
    PlaySoundFile("Interface\\AddOns\\rEmote\\Alarm.mp3")
  end)    