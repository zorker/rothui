
-- rActionBar: bar1
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...
local cfg = L.cfg.bar1

-----------------------------
-- Init
-----------------------------

--buttonList
local buttonList = L:GetButtonList(cfg.buttonName, cfg.numButtons)
--create frame
local frame = L:CreateButtonFrame(cfg,buttonList)