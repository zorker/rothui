
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
L.C.buff = {}
L.C.debuff = {}
L.C.raidbuff = {}
L.C.cooldown = {}
L.C.actionButtonConfig = {}
