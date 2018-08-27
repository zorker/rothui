
-- rEmote: core
-- zork, 2018

-----------------------------
-- Variables
-----------------------------

local A, L = ...

local RaidWarningFrame, RaidBossEmoteFrame, RaidNotice_AddMessage = RaidWarningFrame, RaidBossEmoteFrame, RaidNotice_AddMessage

-----------------------------
-- Functions
-----------------------------

-- RaidNotice_AddMessage( RaidBossEmoteFrame, "This is a TEST of the MESSAGE!", ChatTypeInfo["RAID_BOSS_EMOTE"] );

--[[
function RaidWarningFrame_OnEvent(self, event, message)
  if ( event == "CHAT_MSG_RAID_WARNING" ) then
    message = ChatFrame_ReplaceIconAndGroupExpressions(message);

    RaidNotice_AddMessage( self, message, ChatTypeInfo["RAID_WARNING"] );
    PlaySound(SOUNDKIT.RAID_WARNING);
  end
end
function RaidBossEmoteFrame_OnEvent(self, event, ...)
  if (event == "RAID_BOSS_EMOTE" or event == "RAID_BOSS_WHISPER") then
    local text, playerName, displayTime, playSound = ...;
    local body = format(text, playerName, playerName);  --No need for pflag, monsters can't be afk, dnd, or GMs.
    local info = ChatTypeInfo[event];
    RaidNotice_AddMessage(self, body, info, displayTime);
    if ( playSound ) then
      if ( event == "RAID_BOSS_WHISPER" ) then
        PlaySound(SOUNDKIT.UI_RAID_BOSS_WHISPER_WARNING);
      else
        PlaySound(SOUNDKIT.RAID_BOSS_EMOTE_WARNING);
      end
    end
  elseif ( event == "CLEAR_BOSS_EMOTES" ) then
    RaidNotice_Clear(self);
  end
end
]]

local function RaidWarning(self,event,...)
  print(A,"RaidWarning",event,...)
--[[   if event == "CLEAR_BOSS_EMOTES" then return end
  local text, playerName, displayTime, playSound = ...
  if not playSound then
    PlaySound(SOUNDKIT.RAID_WARNING)
  end ]]
end
hooksecurefunc("RaidWarningFrame_OnEvent", RaidWarning)


local function RaidBossEmote(self,event,...)
  print(A,"RaidBossEmote",event,...)
--[[   if event == "CLEAR_BOSS_EMOTES" then return end
  local text, playerName, displayTime, playSound = ...
  if not playSound then
    PlaySound(SOUNDKIT.RAID_WARNING)
  end ]]
end
hooksecurefunc("RaidBossEmoteFrame_OnEvent", RaidBossEmote)

local function OnEmote(self,event,...)
  print(A,"OnEmote",event,...)
  --local string = format(arg1, arg2)
  --RaidNotice_AddMessage(RaidBossEmoteFrame, string, ChatTypeInfo["RAID_WARNING"])
  --RaidNotice_AddMessage(RaidWarningFrame, string, ChatTypeInfo["RAID_WARNING"])
  --PlaySound(SOUNDKIT.RAID_WARNING)
end

-----------------------------
-- Event Handler
-----------------------------

--event handler
local eventHandler = CreateFrame("Frame")
eventHandler:SetScript("OnEvent", OnEmote)
eventHandler:RegisterEvent("CHAT_MSG_RAID_WARNING")
eventHandler:RegisterEvent("RAID_BOSS_WHISPER")
eventHandler:RegisterEvent("RAID_BOSS_EMOTE")
eventHandler:RegisterEvent("CLEAR_BOSS_EMOTES")
eventHandler:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
eventHandler:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
eventHandler:RegisterEvent("CHAT_MSG_MONSTER_SAY")
eventHandler:RegisterEvent("CHAT_MSG_MONSTER_WHISPER")
eventHandler:RegisterEvent("CHAT_MSG_MONSTER_YELL")
