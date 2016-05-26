
-- rActionBar: bars
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Init
-----------------------------

--BAGS
do
  local cfg = L.cfg.bags
  local buttonList = { MainMenuBarBackpackButton, CharacterBag0Slot, CharacterBag1Slot, CharacterBag2Slot, CharacterBag3Slot }
  local frame = L:CreateButtonFrame(cfg,buttonList)
end

--MICROMENU
do
  local cfg = L.cfg.micromenu
  local buttonList = {}
  for idx, buttonName in next, MICRO_BUTTONS do
    local button = _G[buttonName]
    if button and button:IsShown() then
      table.insert(buttonList, button)
    end
  end
  local frame = L:CreateButtonFrame(cfg,buttonList)
  --special
  PetBattleFrame.BottomFrame.MicroButtonFrame:SetScript("OnShow", nil)
end

--BAR1-5
for i=1, 5 do
  local cfg = L.cfg["bar"..i]
  local buttonList = L:GetButtonList(cfg.buttonName, cfg.numButtons)
  local frame = L:CreateButtonFrame(cfg,buttonList)
end

--OVERRIDEBAR
do
  local cfg = L.cfg.overridebar
  local buttonList = L:GetButtonList(cfg.buttonName, cfg.numButtons)
  --add leave button to buttonList
  table.insert(buttonList, OverrideActionBar.LeaveButton)
  local frame = L:CreateButtonFrame(cfg,buttonList)
  --special
  cfg.blizzardBar:SetScript("OnShow", nil) --micromenu
  RegisterStateDriver(cfg.blizzardBar, "visibility", cfg.blizzardBarVisibility) --show/hide
end

--EXTRABAR
do
  local cfg = L.cfg.extrabar
  local buttonList = L:GetButtonList(cfg.buttonName, cfg.numButtons)
  local frame = L:CreateButtonFrame(cfg,buttonList)
  --special
  cfg.blizzardBar:ClearAllPoints()
  cfg.blizzardBar:SetPoint("CENTER")
  cfg.blizzardBar.ignoreFramePositionManager = true
end