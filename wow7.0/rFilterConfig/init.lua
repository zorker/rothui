
-- rFilterConfig: init
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

--functions container
L.F = {}
--config container
L.C = {}
--make the config global
rFilterConfig = L.C

--player name and class
L.C.playerName = UnitName("player")
local _, playerClass = UnitClass("player")
L.C.playerClass = playerClass

--buff, debuff, raidbuff, cooldown
L.C.buffs = {}
L.C.debuffs = {}
L.C.raidbuffs = {}
L.C.cooldowns = {}
L.C.actionButtonConfig = {}
