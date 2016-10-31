
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

--get the config
L.C = rFilterConfig

--container for buff, debuffs, cooldown
L.buffs = {}
L.debuffs = {}
L.cooldowns = {}

-----------------------------
-- rLib slash command
-----------------------------

--create slash commands
rLib:CreateSlashCmd(L.addonName, L.addonShortcut, L.dragFrames, L.addonColor)