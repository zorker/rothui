
-- rActionBar: micromenu
-- zork, 2016

-----------------------------
-- Config
-----------------------------

local cfg = {}
cfg.blizzardBar     = nil
cfg.frameName       = "rABS_MicroMenu"
cfg.frameParent     = UIParent
cfg.frameTemplate   = "SecureHandlerStateTemplate"
cfg.frameVisibility = "[petbattle] hide; show"
cfg.framePoint      = { "TOP", UIParent, "TOP", 0, -10 }
cfg.frameScale      = 0.8
cfg.framePadding    = 5
cfg.buttonWidth     = 28
cfg.buttonHeight    = 58
cfg.buttonMargin    = 0
cfg.resetButtonParent = true
cfg.numCols         = 12
cfg.startPoint      = "BOTTOMLEFT"
cfg.dragInset       = -2
cfg.dragClamp       = true

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Init
-----------------------------

--buttonList
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
