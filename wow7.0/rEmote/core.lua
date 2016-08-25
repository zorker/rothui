
-- rEmote: core
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Functions
-----------------------------

local function OnEmote(self,event,arg1,arg2)

  --format the string (in case %s is used inside arg1 it will be replaced with value of arg2)
  local string = format(arg1, arg2)

  -- choose chattype
  --post to blizzard combat text
  --if CombatText_AddMessage then
    --CombatText_AddMessage(string, COMBAT_TEXT_SCROLL_FUNCTION, 1, 0, 0, "crit", nil)
  --end
  --post to boss emote frame
  if RaidNotice_AddMessage then
    RaidNotice_AddMessage(RaidBossEmoteFrame, string, ChatTypeInfo["RAID_WARNING"])
  end
  --post to raidwarningframe
  --RaidNotice_AddMessage(RaidWarningFrame, string, ChatTypeInfo["RAID_WARNING"])

  --play a sound...DING
  PlaySoundFile("Interface\\AddOns\\rEmote\\Alarm.mp3")

end

-----------------------------
-- Init
-----------------------------

--eventHandler
local eventHandler = CreateFrame("Frame")

--events
eventHandler:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
eventHandler:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
--eventHandler:RegisterEvent("CHAT_MSG_MONSTER_SAY")
--eventHandler:RegisterEvent("CHAT_MSG_MONSTER_WHISPER")
eventHandler:RegisterEvent("CHAT_MSG_MONSTER_YELL")

--on event
eventHandler:SetScript("OnEvent", OnEmote)