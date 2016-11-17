
-- rFilter: core/init
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

L.addonName       = A
L.dragFrames      = {}
L.addonColor      = "0099FF00"
L.addonShortcut   = "rfilter"

--tick
L.tick = 0.1

--container for buff, debuffs, cooldown
L.buffs = {}
L.debuffs = {}
L.cooldowns = {}

-----------------------------
-- rFilter Global
-----------------------------

rFilter = {}
rFilter.addonName = A

-----------------------------
-- rLib slash command
-----------------------------

--create slash commands
rLib:CreateSlashCmd(L.addonName, L.addonShortcut, L.dragFrames, L.addonColor)