-- rBlizzardStuff/blizzardui: blizzard ui adjustments, state-drivers and mouseover fading for multibars
-- zork, 2024

-----------------------------
-- Variables
-----------------------------

local A, L = ...

local faderConfig = {
  fadeInAlpha = 1,
  fadeInDuration = 0.3,
  fadeInSmooth = "OUT",
  fadeOutAlpha = 0,
  fadeOutDuration = 0.9,
  fadeOutSmooth = "OUT",
  fadeOutDelay = 0,
}

-----------------------------
-- Functions
-----------------------------

--GetButtonList
local function GetButtonList(buttonName,numButtons)
  local buttonList = {}
  for i=1, numButtons do
    local button = _G[buttonName..i]
    if not button then break end
    table.insert(buttonList, button)
  end
  return buttonList
end

--AddActionButtonFader
local function AddActionButtonFader(bar)
  local buttonList = GetButtonList(bar:GetName().."Button", NUM_ACTIONBAR_BUTTONS)
  rLib:CreateButtonFrameFader(bar, buttonList, faderConfig)
end

--AdjustBlizzardFrames
local function AdjustBlizzardFrames()
  RegisterStateDriver(MainMenuBar, "visibility", "[petbattle][vehicleui] hide; [combat][mod:shift][@target,exists,nodead][@vehicle,exists][overridebar][shapeshift][vehicleui][possessbar] show; hide")
  --state driver for PlayerFrame
  RegisterStateDriver(PlayerFrame, "visibility", "[petbattle] hide; [combat][mod:shift][@target,exists,nodead][@vehicle,exists][overridebar][shapeshift][vehicleui][possessbar] show; hide")
  --state driver for BagsBar
  RegisterStateDriver(BagsBar, "visibility", "[mod:ctrl] show; hide")
  --state driver for MicroMenuContainer
  RegisterStateDriver(MicroMenuContainer, "visibility", "[mod:ctrl] show; hide")
  --state driver for MicroButtonAndBagsBar
  RegisterStateDriver(MicroButtonAndBagsBar, "visibility", "[mod:ctrl] show; hide")
  --state driver for MainStatusTrackingBarContainer
  RegisterStateDriver(MainStatusTrackingBarContainer, "visibility", "[mod:alt] show; hide")
  --state driver for ObjectiveTrackerFrame
  RegisterStateDriver(ObjectiveTrackerFrame, "visibility", "[mod:alt] show; hide")
  --MultiBarBottomLeft - Multibar 2
  RegisterStateDriver(MultiBarBottomLeft, "visibility", "[petbattle][vehicleui] hide; [combat][mod:shift][@target,exists,nodead] show; hide")
  --AddActionButtonFader for Multibar 4 and 5
  AddActionButtonFader(MultiBarRight)
  AddActionButtonFader(MultiBarLeft)
  --hide bufframe by clicking the button
  if BuffFrame.CollapseAndExpandButton:GetChecked() then
    BuffFrame.CollapseAndExpandButton:Click()
  end
end

rLib:RegisterCallback("PLAYER_LOGIN", AdjustBlizzardFrames)
