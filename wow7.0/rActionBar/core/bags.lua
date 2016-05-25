
-- rActionBar: bags
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...
local cfg = L.cfg.bags

-----------------------------
-- Init
-----------------------------

--buttonList
local buttonList = { MainMenuBarBackpackButton, CharacterBag0Slot, CharacterBag1Slot, CharacterBag2Slot, CharacterBag3Slot }
--create frame
local frame = L:CreateButtonFrame(cfg,buttonList)