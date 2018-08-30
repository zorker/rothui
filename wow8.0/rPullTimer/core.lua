
-- rPullTimer: core
-- zork, 2018

-----------------------------
-- Variables
-----------------------------

local A, L = ...

local MacroEditBox = MacroEditBox
local MacroEditBox_OnEvent = MacroEditBox:GetScript("OnEvent")

local time = 0
local shortcut = "pull"

-----------------------------
-- Functions
-----------------------------

local function Pull()
  local slash = IsInRaid() and "rw" or "y"
  local text = time == 0 and "Pull now!!!" or "Pull in "..time
  local command = "/"..slash.." "..text
  MacroEditBox_OnEvent(MacroEditBox, "EXECUTE_CHAT_LINE", command)
  if not IsInRaid() then
    PlaySound(SOUNDKIT.RAID_WARNING)
    RaidNotice_AddMessage(RaidWarningFrame, text, ChatTypeInfo["RAID_WARNING"])
  end
  time = time-1
  if time >= 0 then
    C_Timer.After(1, Pull)
  end
end

SlashCmdList[shortcut] = function(cmd)
  if time > 0 then return end
  time = math.min(10,math.floor(tonumber(cmd)))
  Pull()
end
_G["SLASH_"..shortcut.."1"] = "/"..shortcut
