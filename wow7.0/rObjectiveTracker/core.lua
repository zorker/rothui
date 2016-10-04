
-- rObjectiveTracker: core
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

L.addonName       = A
L.dragFrames      = {}
L.addonColor      = "00FF00AA"
L.addonShortcut   = "rot"

-----------------------------
-- Config
-----------------------------

local cfg = {
  scale = 0.9,
  point = { "TOPRIGHT", -120, -220 },
  size = { 260, 550 }
}

-----------------------------
-- Init
-----------------------------

--ObjectiveTrackerFrame
ObjectiveTrackerFrame:SetScale(cfg.scale)
ObjectiveTrackerFrame:ClearAllPoints()
ObjectiveTrackerFrame:SetPoint(unpack(cfg.point))
ObjectiveTrackerFrame:SetSize(unpack(cfg.size))

--drag frame
rLib:CreateDragResizeFrame(ObjectiveTrackerFrame, L.dragFrames, -2, true)

--create slash commands
rLib:CreateSlashCmd(L.addonName, L.addonShortcut, L.dragFrames, L.addonColor)