local addonName, ns = ...

--SetStateDriver
local function SetStateDriver()
  --MainMenuBar
  RegisterStateDriver(MainActionBar, "visibility", "[petbattle][vehicleui] hide; [combat][mod:shift][@target,exists,nodead][@vehicle,exists][overridebar][shapeshift][vehicleui][possessbar] show; hide")
  --state driver for PlayerFrame
  RegisterStateDriver(PlayerFrame, "visibility", "[petbattle] hide; [combat][mod:shift][@target,exists,nodead][@vehicle,exists][overridebar][shapeshift][vehicleui][possessbar] show; hide")
  --state driver for StanceBar
  RegisterStateDriver(StanceBar, "visibility", "[mod:alt] show; hide")
  --state driver for BagsBar
  RegisterStateDriver(BagsBar, "visibility", "[mod:ctrl] show; hide")
  --state driver for MicroMenuContainer
  RegisterStateDriver(MicroMenuContainer, "visibility", "[mod:ctrl] show; hide")
  --state driver for MicroButtonAndBagsBar
  RegisterStateDriver(MicroButtonAndBagsBar, "visibility", "[mod:ctrl] show; hide")
  --state driver for MainStatusTrackingBarContainer
  RegisterStateDriver(MainStatusTrackingBarContainer, "visibility", "[mod:alt] show; hide")
  --state driver for ObjectiveTrackerFrame
  --RegisterStateDriver(ObjectiveTrackerFrame, "visibility", "[mod:alt] show; hide")
  --MultiBarBottomLeft - Multibar 2
  RegisterStateDriver(MultiBarBottomLeft, "visibility", "[petbattle][vehicleui] hide; [combat][mod:shift][@target,exists,nodead] show; hide")
  --AddActionButtonFader for Multibar 4
  --RegisterStateDriver(MultiBarRight, "visibility", "[petbattle][vehicleui] hide; [combat][mod:shift][@target,exists,nodead] show; hide")
  RegisterStateDriver(MultiBarRight, "visibility", "[mod:shift] show; hide")
end

ns.SetStateDriver = SetStateDriver