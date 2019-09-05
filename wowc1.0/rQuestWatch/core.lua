
-- rQuestWatch: core
-- zork, 2019

-----------------------------
-- Variables
-----------------------------

local A, L = ...

L.addonName       = A
L.dragFrames      = {}
L.addonColor      = "00FF00AA"
L.addonShortcut   = "rqw"

-----------------------------
-- Config
-----------------------------

local cfg = {
  scale = 1,
  point = { "RIGHT", -110, -100 },
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
QuestWatchFrame.ignoreFramePositionManager = true

--drag frame
rLib:CreateDragResizeFrame(QuestWatchFrame, L.dragFrames, -2, true)

--frame fader
rLib:CreateFrameFader(QuestWatchFrame, cfg.fader)

--create slash commands
rLib:CreateSlashCmd(L.addonName, L.addonShortcut, L.dragFrames, L.addonColor)