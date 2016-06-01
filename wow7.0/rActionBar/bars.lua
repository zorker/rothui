
-- rActionBar: bars
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Init
-----------------------------

--BagBar
function rActionBar:CreateBagBar(addonName,cfg)
  cfg.blizzardBar = nil
  cfg.frameName = (addonName or A).."BagBar"
  cfg.frameParent = cfg.frameParent or UIParent
  cfg.frameTemplate = "SecureHandlerStateTemplate"
  cfg.frameVisibility = cfg.frameVisibility or "[petbattle] hide; show"
  cfg.dragInset = cfg.dragInset or -2
  cfg.dragClamp = cfg.dragClamp or true
  local buttonList = { MainMenuBarBackpackButton, CharacterBag0Slot, CharacterBag1Slot, CharacterBag2Slot, CharacterBag3Slot }
  local frame = L:CreateButtonFrame(cfg,buttonList)
end

--MicroMenuBar
function rActionBar:CreateMicroMenuBar(addonName,cfg)
  cfg.blizzardBar = nil
  cfg.frameName = (addonName or A).."MicroMenuBar"
  cfg.frameParent = cfg.frameParent or UIParent
  cfg.frameTemplate = "SecureHandlerStateTemplate"
  cfg.frameVisibility = cfg.frameVisibility or "[petbattle] hide; show"
  cfg.dragInset = cfg.dragInset or -2
  cfg.dragClamp = cfg.dragClamp or true
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

--Bar1
function rActionBar:CreateActionBar1(addonName,cfg)
  cfg.blizzardBar = nil
  cfg.frameName = (addonName or A).."Bar1"
  cfg.frameParent = cfg.frameParent or UIParent
  cfg.frameTemplate = "SecureHandlerStateTemplate"
  cfg.frameVisibility = cfg.frameVisibility or "[petbattle] hide; show"
  cfg.framePage = "[vehicleui]vui; [possessbar]pb; [overridebar]ob; [shapeshift]ss; [bonusbar:1]bb1; [bonusbar:2]bb2; [bonusbar:3]bb3; [bonusbar:4]bb4; [bonusbar:5]bb5; [bar:2]b2; [bar:3]b3; [bar:4]b4; [bar:5]b5; [bar:6]b6; [form]frm; [bar:1]b1; xx"
  cfg.buttonName = "ActionButton"
  cfg.numButtons = NUM_ACTIONBAR_BUTTONS
  cfg.dragInset = cfg.dragInset or -2
  cfg.dragClamp = cfg.dragClamp or true
  local buttonList = L:GetButtonList(cfg.buttonName, cfg.numButtons)
  local frame = L:CreateButtonFrame(cfg,buttonList)
end

--Bar2
function rActionBar:CreateActionBar2(addonName,cfg)
  cfg.blizzardBar = MultiBarBottomLeft
  cfg.frameName = (addonName or A).."Bar2"
  cfg.frameParent = cfg.frameParent or UIParent
  cfg.frameTemplate = "SecureHandlerStateTemplate"
  cfg.frameVisibility = cfg.frameVisibility or "[petbattle][overridebar][vehicleui][possessbar][shapeshift] hide; show"
  cfg.buttonName = "MultiBarBottomLeftButton"
  cfg.numButtons = NUM_ACTIONBAR_BUTTONS
  cfg.dragInset = cfg.dragInset or -2
  cfg.dragClamp = cfg.dragClamp or true
  local buttonList = L:GetButtonList(cfg.buttonName, cfg.numButtons)
  local frame = L:CreateButtonFrame(cfg,buttonList)
end

--Bar3
function rActionBar:CreateActionBar3(addonName,cfg)
  cfg.blizzardBar = MultiBarBottomRight
  cfg.frameName = (addonName or A).."Bar3"
  cfg.frameParent = cfg.frameParent or UIParent
  cfg.frameTemplate = "SecureHandlerStateTemplate"
  cfg.frameVisibility = cfg.frameVisibility or "[petbattle][overridebar][vehicleui][possessbar][shapeshift] hide; show"
  cfg.buttonName = "MultiBarBottomRightButton"
  cfg.numButtons = NUM_ACTIONBAR_BUTTONS
  cfg.dragInset = cfg.dragInset or -2
  cfg.dragClamp = cfg.dragClamp or true
  local buttonList = L:GetButtonList(cfg.buttonName, cfg.numButtons)
  local frame = L:CreateButtonFrame(cfg,buttonList)
end

--Bar4
function rActionBar:CreateActionBar4(addonName,cfg)
  cfg.blizzardBar = MultiBarRight
  cfg.frameName = (addonName or A).."Bar4"
  cfg.frameParent = cfg.frameParent or UIParent
  cfg.frameTemplate = "SecureHandlerStateTemplate"
  cfg.frameVisibility = cfg.frameVisibility or "[petbattle][overridebar][vehicleui][possessbar][shapeshift] hide; show"
  cfg.buttonName = "MultiBarRightButton"
  cfg.numButtons = NUM_ACTIONBAR_BUTTONS
  cfg.dragInset = cfg.dragInset or -2
  cfg.dragClamp = cfg.dragClamp or true
  local buttonList = L:GetButtonList(cfg.buttonName, cfg.numButtons)
  local frame = L:CreateButtonFrame(cfg,buttonList)
end

--Bar5
function rActionBar:CreateActionBar5(addonName,cfg)
  cfg.blizzardBar = MultiBarLeft
  cfg.frameName = (addonName or A).."Bar5"
  cfg.frameParent = cfg.frameParent or UIParent
  cfg.frameTemplate = "SecureHandlerStateTemplate"
  cfg.frameVisibility = cfg.frameVisibility or "[petbattle][overridebar][vehicleui][possessbar][shapeshift] hide; show"
  cfg.buttonName = "MultiBarLeftButton"
  cfg.numButtons = NUM_ACTIONBAR_BUTTONS
  cfg.dragInset = cfg.dragInset or -2
  cfg.dragClamp = cfg.dragClamp or true
  local buttonList = L:GetButtonList(cfg.buttonName, cfg.numButtons)
  local frame = L:CreateButtonFrame(cfg,buttonList)
end

--StanceBar
function rActionBar:CreateStanceBar(addonName,cfg)
  cfg.blizzardBar = StanceBarFrame
  cfg.frameName = (addonName or A).."StanceBar"
  cfg.frameParent = cfg.frameParent or UIParent
  cfg.frameTemplate = "SecureHandlerStateTemplate"
  cfg.frameVisibility = cfg.frameVisibility or "[petbattle][overridebar][vehicleui][possessbar][shapeshift] hide; [stance][form] show; hide"
  cfg.buttonName = "StanceButton"
  cfg.numButtons = NUM_STANCE_SLOTS
  cfg.dragInset = cfg.dragInset or -2
  cfg.dragClamp = cfg.dragClamp or true
  local buttonList = L:GetButtonList(cfg.buttonName, cfg.numButtons)
  local frame = L:CreateButtonFrame(cfg,buttonList)
end

--PetBar
function rActionBar:CreatePetBar(addonName,cfg)
  cfg.blizzardBar = PetActionBarFrame
  cfg.frameName = (addonName or A).."PetBar"
  cfg.frameParent = cfg.frameParent or UIParent
  cfg.frameTemplate = "SecureHandlerStateTemplate"
  cfg.frameVisibility = cfg.frameVisibility or "[petbattle][overridebar][vehicleui][possessbar][shapeshift] hide; [pet] show; hide"
  cfg.buttonName = "PetActionButton"
  cfg.numButtons = NUM_PET_ACTION_SLOTS
  cfg.dragInset = cfg.dragInset or -2
  cfg.dragClamp = cfg.dragClamp or true
  local buttonList = L:GetButtonList(cfg.buttonName, cfg.numButtons)
  local frame = L:CreateButtonFrame(cfg,buttonList)
end

--ExtraBar
function rActionBar:CreateExtraBar(addonName,cfg)
  cfg.blizzardBar = ExtraActionBarFrame
  cfg.frameName = (addonName or A).."ExtraBar"
  cfg.frameParent = cfg.frameParent or UIParent
  cfg.frameTemplate = "SecureHandlerStateTemplate"
  cfg.frameVisibility = cfg.frameVisibility or "[extrabar] show; hide"
  cfg.buttonName = "ExtraActionButton"
  cfg.numButtons = NUM_ACTIONBAR_BUTTONS
  cfg.dragInset = cfg.dragInset or -2
  cfg.dragClamp = cfg.dragClamp or true
  local buttonList = L:GetButtonList(cfg.buttonName, cfg.numButtons)
  local frame = L:CreateButtonFrame(cfg,buttonList)
  --special
  ExtraActionBarFrame:ClearAllPoints()
  ExtraActionBarFrame:SetPoint("CENTER")
  ExtraActionBarFrame.ignoreFramePositionManager = true
end

--VehicleExitBar
function rActionBar:CreateVehicleExitBar(addonName,cfg)
  cfg.blizzardBar = nil
  cfg.frameName = (addonName or A).."VehicleExitBar"
  cfg.frameParent = cfg.frameParent or UIParent
  cfg.frameTemplate = "SecureHandlerStateTemplate"
  cfg.frameVisibility = cfg.frameVisibility or "[canexitvehicle] show; hide"
  cfg.dragInset = cfg.dragInset or -2
  cfg.dragClamp = cfg.dragClamp or true
  local buttonList = { OverrideActionBar.LeaveButton }
  local frame = L:CreateButtonFrame(cfg, buttonList)
end

