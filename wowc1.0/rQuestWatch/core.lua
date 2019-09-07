
-- rQuestWatch: core
-- zork, 2019

-----------------------------
-- Variables
-----------------------------

local A, L = ...

L.addonName       = A
L.dragFrames      = {}
L.addonColor      = "00FFCC00"
L.addonShortcut   = "rqw"

-----------------------------
-- Config
-----------------------------

local cfg = {
  scale = 1,
  point = { "RIGHT", -110, 100 },
  size = { 260, 500 },
  fader = {
    fadeInAlpha = 1,
    fadeInDuration = 0.3,
    fadeInSmooth = "OUT",
    fadeOutAlpha = 0,
    fadeOutDuration = 0.9,
    fadeOutSmooth = "OUT",
    fadeOutDelay = 0,
  },
}

-----------------------------
-- Init
-----------------------------

--QuestWatchFrame
QuestWatchFrame:SetScale(cfg.scale)
QuestWatchFrame:ClearAllPoints()
QuestWatchFrame:SetPoint(unpack(cfg.point))
QuestWatchFrame:SetSize(unpack(cfg.size))

--drag frame
rLib:CreateDragFrame(QuestWatchFrame, L.dragFrames, -2, true)

--FramePositionDelegate.UIParentManageFramePositions is interfering with the position try to fix it
local EnableSetPoint = QuestWatchFrame.SetPoint
local DisableSetPoint = function() end
QuestWatchFrame.SetPoint = DisableSetPoint
QuestWatchFrame.dragFrame:HookScript("OnDragStart", function() QuestWatchFrame.SetPoint = EnableSetPoint end)
QuestWatchFrame.dragFrame:HookScript("OnDragStop", function() QuestWatchFrame.SetPoint = DisableSetPoint end)

--frame fader
rLib:CreateFrameFader(QuestWatchFrame, cfg.fader)

--create slash commands
rLib:CreateSlashCmd(L.addonName, L.addonShortcut, L.dragFrames, L.addonColor)