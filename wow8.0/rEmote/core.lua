
-- rEmote: core
-- zork, 2018

-----------------------------
-- Variables
-----------------------------

local A, L = ...

local RaidWarningFrame, RaidBossEmoteFrame, RaidNotice_AddMessage = RaidWarningFrame, RaidBossEmoteFrame, RaidNotice_AddMessage

local slots = {
  RaidBossEmoteFrameSlot1,
  RaidBossEmoteFrameSlot2,
  RaidWarningFrameSlot1,
  RaidWarningFrameSlot2
}
for i, slot in next, slots do
  slot:SetFont(STANDARD_TEXT_FONT, 19.9, "OUTLINE") --lol 20 acts totally wierd. use 19.9 >_<
  slot:SetShadowOffset(1,-2)
  slot:SetShadowColor(0,0,0,0.5)
end

-----------------------------
-- Functions
-----------------------------

local function RaidWarning(self,event,...)
  print(A,"RaidWarning",event,...)
end
--hooksecurefunc("RaidWarningFrame_OnEvent", RaidWarning)


local function RaidBossEmote(self,event,...)
  --print(A,"RaidBossEmote",event,...)
  if event == "CLEAR_BOSS_EMOTES" then return end
  local text, playerName, displayTime, playSound = ...
  if not playSound then
    PlaySoundFile("Interface\\AddOns\\rEmote\\Alarm.mp3")
  end
end
hooksecurefunc("RaidBossEmoteFrame_OnEvent", RaidBossEmote)

local function OnEmote(self,event,...)
  --print(A,"OnEmote",event,...)
  local text, playerName = ...
  local body = format(text, playerName, playerName)
  --PlaySound(SOUNDKIT.RAID_WARNING)
  PlaySoundFile("Interface\\AddOns\\rEmote\\Alarm.mp3")
  RaidNotice_AddMessage(RaidBossEmoteFrame, body, ChatTypeInfo[event] or ChatTypeInfo["RAID_WARNING"])
end

-----------------------------
-- Event Handler
-----------------------------

--event handler
local eventHandler = CreateFrame("Frame")
eventHandler:SetScript("OnEvent", OnEmote)
--eventHandler:RegisterEvent("CHAT_MSG_RAID_WARNING")
--eventHandler:RegisterEvent("RAID_BOSS_WHISPER")
--eventHandler:RegisterEvent("RAID_BOSS_EMOTE")
--eventHandler:RegisterEvent("CLEAR_BOSS_EMOTES")
--eventHandler:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
eventHandler:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
--eventHandler:RegisterEvent("CHAT_MSG_MONSTER_SAY")
eventHandler:RegisterEvent("CHAT_MSG_MONSTER_WHISPER")
eventHandler:RegisterEvent("CHAT_MSG_MONSTER_YELL")
