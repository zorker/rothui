
-- rActionBar: core/slashcmd
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Init
-----------------------------

SlashCmdList[L.addonShortcut] = rLib:CreateSlashCmd(L.addonName, L.addonShortcut, L.dragFrames, L.addonColor)
SLASH_rabs1 = "/"..L.addonShortcut; --the value in the between SLASH_ and NUMBER has to match the value of shortcut

print("|c"..L.addonColor..L.addonName.." loaded.|r")
print("|c"..L.addonColor.."\/"..L.addonShortcut.."|r to display the command list")
