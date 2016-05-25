
-- rActionBar: extrabar
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...
local cfg = L.cfg.extrabar

-----------------------------
-- Init
-----------------------------

--buttonList
local buttonList = L:GetButtonList(cfg.buttonName, cfg.numButtons)
--create frame
local frame = L:CreateButtonFrame(cfg,buttonList)
--special settings
cfg.blizzardBar:ClearAllPoints()
cfg.blizzardBar:SetPoint("CENTER")
cfg.blizzardBar.ignoreFramePositionManager = true