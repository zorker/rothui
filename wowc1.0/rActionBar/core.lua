
-- rActionBar: core
-- zork, 2019

-----------------------------
-- Variables
-----------------------------

local A, L = ...

L.addonName       = A
L.dragFrames      = {}
L.addonColor      = "0000FF00"
L.addonShortcut   = "rab"

-----------------------------
-- rActionBar Global
-----------------------------

rActionBar = {}
rActionBar.addonName = A

-----------------------------
-- Functions
-----------------------------

function L:GetButtonList(buttonName,numButtons)
  local buttonList = {}
  for i=1, numButtons do
    local button = _G[buttonName..i]
    if not button then break end
    table.insert(buttonList, button)
  end
  return buttonList
end

--points
--1. p1, f, fp1, fp2
--2. p2, rb-1, p3, bm1, bm2
--3. p4, b-1, p5, bm3, bm4
local function SetupButtonPoints(frame, buttonList, buttonWidth, buttonHeight, numCols, p1, fp1, fp2, p2, p3, bm1, bm2, p4, p5, bm3, bm4)
  for index, button in next, buttonList do
    if not frame.__blizzardBar then
      button:SetParent(frame)
    end
    button:SetSize(buttonWidth, buttonHeight)
    button:ClearAllPoints()
    if index == 1 then
      button:SetPoint(p1, frame, fp1, fp2)
    elseif numCols == 1 or mod(index, numCols) == 1 then
      button:SetPoint(p2, buttonList[index-numCols], p3, bm1, bm2)
    else
      button:SetPoint(p4, buttonList[index-1], p5, bm3, bm4)
    end
  end
end

local function SetupButtonFrame(frame, framePadding, buttonList, buttonWidth, buttonHeight, buttonMargin, numCols, startPoint)
  local numButtons = # buttonList
  numCols = min(numButtons, numCols)
  local numRows = ceil(numButtons/numCols)
  local frameWidth = numCols*buttonWidth + (numCols-1)*buttonMargin + 2*framePadding
  local frameHeight = numRows*buttonHeight + (numRows-1)*buttonMargin + 2*framePadding
  frame:SetSize(frameWidth,frameHeight)
  --TOPLEFT
  --1. TL, f, p, -p
  --2. T, rb-1, B, 0, -m
  --3. L, b-1, R, m, 0
  if startPoint == "TOPLEFT" then
    SetupButtonPoints(frame, buttonList, buttonWidth, buttonHeight, numCols, startPoint, framePadding, -framePadding, "TOP", "BOTTOM", 0, -buttonMargin, "LEFT", "RIGHT", buttonMargin, 0)
  --end
  --TOPRIGHT
  --1. TR, f, -p, -p
  --2. T, rb-1, B, 0, -m
  --3. R, b-1, L, -m, 0
  elseif startPoint == "TOPRIGHT" then
    SetupButtonPoints(frame, buttonList, buttonWidth, buttonHeight, numCols, startPoint, -framePadding, -framePadding, "TOP", "BOTTOM", 0, -buttonMargin, "RIGHT", "LEFT", -buttonMargin, 0)
  --end
  --BOTTOMRIGHT
  --1. BR, f, -p, p
  --2. B, rb-1, T, 0, m
  --3. R, b-1, L, -m, 0
  elseif startPoint == "BOTTOMRIGHT" then
    SetupButtonPoints(frame, buttonList, buttonWidth, buttonHeight, numCols, startPoint, -framePadding, framePadding, "BOTTOM", "TOP", 0, buttonMargin, "RIGHT", "LEFT", -buttonMargin, 0)
  --end
  --BOTTOMLEFT
  --1. BL, f, p, p
  --2. B, rb-1, T, 0, m
  --3. L, b-1, R, m, 0
  --elseif startPoint == "BOTTOMLEFT" then
  else
    startPoint = "BOTTOMLEFT"
    SetupButtonPoints(frame, buttonList, buttonWidth, buttonHeight, numCols, startPoint, framePadding, framePadding, "BOTTOM", "TOP", 0, buttonMargin, "LEFT", "RIGHT", buttonMargin, 0)
  end
end

function L:CreateButtonFrame(cfg,buttonList)
  --create new parent frame for buttons
  local frame = CreateFrame("Frame", cfg.frameName, cfg.frameParent, cfg.frameTemplate)
  frame:SetPoint(unpack(cfg.framePoint))
  frame:SetScale(cfg.frameScale)
  frame.__blizzardBar = cfg.blizzardBar
  SetupButtonFrame(frame, cfg.framePadding, buttonList, cfg.buttonWidth, cfg.buttonHeight, cfg.buttonMargin, cfg.numCols, cfg.startPoint)
  --reparent the Blizzard bar
  if cfg.blizzardBar then
    cfg.blizzardBar:SetParent(frame)
    cfg.blizzardBar:EnableMouse(false)
  end
  --show/hide the frame on a given state driver
  if cfg.frameVisibility then
    frame.frameVisibility = cfg.frameVisibility
    frame.frameVisibilityFunc = cfg.frameVisibilityFunc
    RegisterStateDriver(frame, cfg.frameVisibilityFunc or "visibility", cfg.frameVisibility)
  end
  --add drag functions
  rLib:CreateDragFrame(frame, L.dragFrames, -2, true)
  --hover animation
  if cfg.fader then
    rLib:CreateButtonFrameFader(frame, buttonList, cfg.fader)
  end
  return frame
end

--create slash commands
rLib:CreateSlashCmd(L.addonName, L.addonShortcut, L.dragFrames, L.addonColor)