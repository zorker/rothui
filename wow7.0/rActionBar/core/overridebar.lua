
-- rActionBar: overridebar
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...
local cfg = L.cfg.overridebar

-----------------------------
-- Init
-----------------------------

--buttonList
local buttonList = L:GetButtonList(cfg.buttonName, cfg.numButtons)
--add the leave button
table.insert(buttonList, OverrideActionBar.LeaveButton)
--create frame
local frame = L:CreateButtonFrame(cfg,buttonList)
--special settings
cfg.blizzardBar:SetScript("OnShow", nil)
RegisterStateDriver(cfg.blizzardBar, "visibility", cfg.blizzardBarVisibility)