  
  --guild
  CHAT_GUILD_GET = "|Hchannel:GUILD|hG|h %s "
  CHAT_OFFICER_GET = "|Hchannel:OFFICER|hO|h %s "
    
  --raid
  CHAT_RAID_GET = "|Hchannel:RAID|hR|h %s "
  CHAT_RAID_WARNING_GET = "RW %s "
  CHAT_RAID_LEADER_GET = "|Hchannel:RAID|hRL|h %s "
  
  --party
  CHAT_PARTY_GET = "|Hchannel:PARTY|hP|h %s "
  CHAT_PARTY_LEADER_GET =  "|Hchannel:PARTY|hPL|h %s "
  CHAT_PARTY_GUIDE_GET =  "|Hchannel:PARTY|hPG|h %s "

  --instance
  CHAT_INSTANCE_CHAT_GET = "|Hchannel:Battleground|hI.|h %s: "
  CHAT_INSTANCE_CHAT_LEADER_GET = "|Hchannel:Battleground|hIL.|h %s: "
  
  --whisper  
  CHAT_WHISPER_INFORM_GET = "to %s "
  CHAT_WHISPER_GET = "from %s "
  CHAT_BN_WHISPER_INFORM_GET = "to %s "
  CHAT_BN_WHISPER_GET = "from %s "
  
  --say / yell
  CHAT_SAY_GET = "%s "
  CHAT_YELL_GET = "%s "
  
  --flags
  CHAT_FLAG_AFK = "[AFK] "
  CHAT_FLAG_DND = "[DND] "
  CHAT_FLAG_GM = "[GM] "

  local gsub = _G.string.gsub
      
  for i = 1, NUM_CHAT_WINDOWS do
    if ( i ~= 2 ) then
      local f = _G["ChatFrame"..i]
      local am = f.AddMessage
      f.AddMessage = function(frame, text, ...)
        return am(frame, text:gsub('|h%[(%d+)%. .-%]|h', '|h%1|h'), ...)
      end
    end
  end 
