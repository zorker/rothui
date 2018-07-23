
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
  cfg.frameName = addonName.."BagBar"
  cfg.frameParent = cfg.frameParent or UIParent
  cfg.frameTemplate = "SecureHandlerStateTemplate"
  cfg.frameVisibility = cfg.frameVisibility or "[petbattle] hide; show"
  local buttonList = { MainMenuBarBackpackButton, CharacterBag0Slot, CharacterBag1Slot, CharacterBag2Slot, CharacterBag3Slot }
  local frame = L:CreateButtonFrame(cfg,buttonList)
end

--MicroMenuBar
function rActionBar:CreateMicroMenuBar(addonName,cfg)
  cfg.blizzardBar = nil
  cfg.frameName = addonName.."MicroMenuBar"
  cfg.frameParent = cfg.frameParent or UIParent
  cfg.frameTemplate = "SecureHandlerStateTemplate"
  cfg.frameVisibility = cfg.frameVisibility or "[petbattle] hide; show"
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
  OverrideActionBar:SetScript("OnShow", nil)
  MainMenuBar:SetScript("OnShow", nil)
end

--Bar1
function rActionBar:CreateActionBar1(addonName,cfg)
  L:HideMainMenuBar()
  cfg.blizzardBar = nil
  cfg.frameName = addonName.."Bar1"
  cfg.frameParent = cfg.frameParent or UIParent
  cfg.frameTemplate = "SecureHandlerStateTemplate"
  cfg.frameVisibility = cfg.frameVisibility or "[petbattle] hide; show"
  cfg.actionPage = cfg.actionPage or "[bar:6]6;[bar:5]5;[bar:4]4;[bar:3]3;[bar:2]2;[overridebar]14;[shapeshift]13;[vehicleui]12;[possessbar]12;[bonusbar:5]11;[bonusbar:4]10;[bonusbar:3]9;[bonusbar:2]8;[bonusbar:1]7;1"
  local buttonName = "ActionButton"
  local numButtons = NUM_ACTIONBAR_BUTTONS
  local buttonList = L:GetButtonList(buttonName, numButtons)
  local frame = L:CreateButtonFrame(cfg,buttonList)
  --fix the button grid for actionbar1
  local function ToggleButtonGrid()
    if InCombatLockdown() then
      print("Grid toggle for actionbar1 is not possible in combat.")
      return
    end
    local showgrid = tonumber(GetCVar("alwaysShowActionBars"))
    for i, button in next, buttonList do
      button:SetAttribute("showgrid", showgrid)
      ActionButton_ShowGrid(button)
    end
  end
  hooksecurefunc("MultiActionBar_UpdateGridVisibility", ToggleButtonGrid)
  --_onstate-page state driver
  for i, button in next, buttonList do
    frame:SetFrameRef(buttonName..i, button)
  end
  frame:Execute(([[
    buttons = table.new()
    for i=1, %d do
      table.insert(buttons, self:GetFrameRef("%s"..i))
    end
  ]]):format(numButtons, buttonName))
  frame:SetAttribute("_onstate-page", [[
    --print("_onstate-page","index",newstate)
    for i, button in next, buttons do
      button:SetAttribute("actionpage", newstate)
    end
  ]])
  RegisterStateDriver(frame, "page", cfg.actionPage)
end

--Bar2
function rActionBar:CreateActionBar2(addonName,cfg)
  cfg.blizzardBar = MultiBarBottomLeft
  cfg.frameName = addonName.."Bar2"
  cfg.frameParent = cfg.frameParent or UIParent
  cfg.frameTemplate = "SecureHandlerStateTemplate"
  cfg.frameVisibility = cfg.frameVisibility or "[petbattle][overridebar][vehicleui][possessbar][shapeshift] hide; show"
  local buttonName = "MultiBarBottomLeftButton"
  local numButtons = NUM_ACTIONBAR_BUTTONS
  local buttonList = L:GetButtonList(buttonName, numButtons)
  local frame = L:CreateButtonFrame(cfg,buttonList)
end

--Bar3
function rActionBar:CreateActionBar3(addonName,cfg)
  cfg.blizzardBar = MultiBarBottomRight
  cfg.frameName = addonName.."Bar3"
  cfg.frameParent = cfg.frameParent or UIParent
  cfg.frameTemplate = "SecureHandlerStateTemplate"
  cfg.frameVisibility = cfg.frameVisibility or "[petbattle][overridebar][vehicleui][possessbar][shapeshift] hide; show"
  local buttonName = "MultiBarBottomRightButton"
  local numButtons = NUM_ACTIONBAR_BUTTONS
  local buttonList = L:GetButtonList(buttonName, numButtons)
  local frame = L:CreateButtonFrame(cfg,buttonList)
end

--Bar4
function rActionBar:CreateActionBar4(addonName,cfg)
  cfg.blizzardBar = MultiBarRight
  cfg.frameName = addonName.."Bar4"
  cfg.frameParent = cfg.frameParent or UIParent
  cfg.frameTemplate = "SecureHandlerStateTemplate"
  cfg.frameVisibility = cfg.frameVisibility or "[petbattle][overridebar][vehicleui][possessbar][shapeshift] hide; show"
  local buttonName = "MultiBarRightButton"
  local numButtons = NUM_ACTIONBAR_BUTTONS
  local buttonList = L:GetButtonList(buttonName, numButtons)
  local frame = L:CreateButtonFrame(cfg,buttonList)
end

--Bar5
function rActionBar:CreateActionBar5(addonName,cfg)
  cfg.blizzardBar = MultiBarLeft
  cfg.frameName = addonName.."Bar5"
  cfg.frameParent = cfg.frameParent or UIParent
  cfg.frameTemplate = "SecureHandlerStateTemplate"
  cfg.frameVisibility = cfg.frameVisibility or "[petbattle][overridebar][vehicleui][possessbar][shapeshift] hide; show"
  local buttonName = "MultiBarLeftButton"
  local numButtons = NUM_ACTIONBAR_BUTTONS
  local buttonList = L:GetButtonList(buttonName, numButtons)
  local frame = L:CreateButtonFrame(cfg,buttonList)
end

--StanceBar
function rActionBar:CreateStanceBar(addonName,cfg)
  cfg.blizzardBar = StanceBarFrame
  cfg.frameName = addonName.."StanceBar"
  cfg.frameParent = cfg.frameParent or UIParent
  cfg.frameTemplate = "SecureHandlerStateTemplate"
  cfg.frameVisibility = cfg.frameVisibility or "[petbattle][overridebar][vehicleui][possessbar][shapeshift] hide; show"
  local buttonName = "StanceButton"
  local numButtons = NUM_STANCE_SLOTS
  local buttonList = L:GetButtonList(buttonName, numButtons)
  local frame = L:CreateButtonFrame(cfg,buttonList)
  --special
  StanceBarLeft:SetTexture(nil)
  StanceBarMiddle:SetTexture(nil)
  StanceBarRight:SetTexture(nil)
end

--PetBar
function rActionBar:CreatePetBar(addonName,cfg)
  cfg.blizzardBar = PetActionBarFrame
  cfg.frameName = addonName.."PetBar"
  cfg.frameParent = cfg.frameParent or UIParent
  cfg.frameTemplate = "SecureHandlerStateTemplate"
  cfg.frameVisibility = cfg.frameVisibility or "[petbattle][overridebar][vehicleui][possessbar][shapeshift] hide; [pet] show; hide"
  local buttonName = "PetActionButton"
  local numButtons = NUM_PET_ACTION_SLOTS
  local buttonList = L:GetButtonList(buttonName, numButtons)
  local frame = L:CreateButtonFrame(cfg,buttonList)
  --special
  SlidingActionBarTexture0:SetTexture(nil)
  SlidingActionBarTexture1:SetTexture(nil)
end

--ExtraBar
function rActionBar:CreateExtraBar(addonName,cfg)
  cfg.blizzardBar = ExtraActionBarFrame
  cfg.frameName = addonName.."ExtraBar"
  cfg.frameParent = cfg.frameParent or UIParent
  cfg.frameTemplate = "SecureHandlerStateTemplate"
  cfg.frameVisibility = cfg.frameVisibility or "[extrabar] show; hide"
  local buttonName = "ExtraActionButton"
  local numButtons = NUM_ACTIONBAR_BUTTONS
  local buttonList = L:GetButtonList(buttonName, numButtons)
  local frame = L:CreateButtonFrame(cfg,buttonList)
  --special
  ExtraActionBarFrame.ignoreFramePositionManager = true
end

--VehicleExitBar
function rActionBar:CreateVehicleExitBar(addonName,cfg)
  cfg.blizzardBar = nil
  cfg.frameName = addonName.."VehicleExitBar"
  cfg.frameParent = cfg.frameParent or UIParent
  cfg.frameTemplate = "SecureHandlerStateTemplate"
  cfg.frameVisibility = cfg.frameVisibility or "[canexitvehicle]c;[mounted]m;n"
  cfg.frameVisibilityFunc = "exit"
  --create vehicle exit button
  local button = CreateFrame("CHECKBUTTON", A.."VehicleExitButton", nil, "ActionButtonTemplate, SecureHandlerClickTemplate")
  button.icon:SetTexture("interface\\addons\\"..A.."\\media\\vehicleexit")
  button:RegisterForClicks("AnyUp")
  local function OnClick(self)
    if UnitOnTaxi("player") then TaxiRequestEarlyLanding() else VehicleExit() end self:SetChecked(false)
  end
  button:SetScript("OnClick", OnClick)
  local buttonList = { button }
  local frame = L:CreateButtonFrame(cfg, buttonList)
  --[canexitvehicle] is not triggered on taxi, exit workaround
  frame:SetAttribute("_onstate-exit", [[ if CanExitVehicle() then self:Show() else self:Hide() end ]])
  if not CanExitVehicle() then frame:Hide() end
end

--PossessExitBar, this is the two button bar to cancel a possess in progress
function rActionBar:CreatePossessExitBar(addonName,cfg)
  cfg.blizzardBar = PossessBarFrame
  cfg.frameName = addonName.."PossessExitBar"
  cfg.frameParent = cfg.frameParent or UIParent
  cfg.frameTemplate = "SecureHandlerStateTemplate"
  cfg.frameVisibility = cfg.frameVisibility or "[possessbar] show; hide"
  local buttonName = "PossessButton"
  local numButtons = NUM_POSSESS_SLOTS
  local buttonList = L:GetButtonList(buttonName, numButtons)
  local frame = L:CreateButtonFrame(cfg,buttonList)
  --special
  PossessBackground1:SetTexture(nil)
  PossessBackground2:SetTexture(nil)
end