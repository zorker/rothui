
-- rTalkingHead: core
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

L.addonName       = A
L.dragFrames      = {}
L.addonColor      = "00FF00AA"
L.addonShortcut   = "rth"

-----------------------------
-- Config
-----------------------------

local cfg = {
  scale = 1,
  point = { "TOP", 0, -150},
}

-----------------------------
-- Init
-----------------------------

local frame = CreateFrame("Frame", A.."Parent", UIParent)
frame:SetScale(cfg.scale)
frame:SetPoint(unpack(cfg.point))
frame:SetSize(64,64)

--TalkingHeadFrame
TalkingHeadFrame:SetParent(frame)
TalkingHeadFrame:ClearAllPoints()
TalkingHeadFrame:SetPoint("CENTER")
TalkingHeadFrame.ignoreFramePositionManager = true

--drag frame
rLib:CreateDragFrame(frame, L.dragFrames, -2, true)

--create slash commands
rLib:CreateSlashCmd(L.addonName, L.addonShortcut, L.dragFrames, L.addonColor)