
-- rFilter_Zork: init
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

--config container
L.C = {}

--player name and class
L.C.playerName = UnitName("player")
local _, playerClass = UnitClass("player")
L.C.playerClass = playerClass

--set tick or use the default from rFilter
--rFilter:SetTick(0.1)