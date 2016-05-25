
-- rActionBar: micromenu
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...
local cfg = L.cfg.micromenu

-----------------------------
-- Init
-----------------------------

--buttonList, create from microbuttons
local buttonList = {}
for idx, buttonName in next, MICRO_BUTTONS do
  local button = _G[buttonName]
  if button and button:IsShown() then
    table.insert(buttonList, button)
  end
end
--create frame
local frame = L:CreateButtonFrame(cfg,buttonList)
--special
PetBattleFrame.BottomFrame.MicroButtonFrame:SetScript("OnShow", nil)
