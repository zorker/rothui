
-- rBuffFrame: core
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

L.addonName       = A
L.dragFrames      = {}
L.addonColor      = "0000FFFF"
L.addonShortcut   = "rbf"

-----------------------------
-- Hide Blizzard BuffFrame
-----------------------------

--local hiddenFrame = CreateFrame("Frame")
--hiddenFrame:Hide()
--BuffFrame:SetParent(hiddenFrame)

-----------------------------
-- rBuffFrame Global
-----------------------------

rBuffFrame = {}
rBuffFrame.addonName = A

-----------------------------
-- Functions
-----------------------------

local function GetButtonList(buttonName,numButtons,buttonList)
  buttonList = buttonList or {}
  for i=1, numButtons do
    local button = _G[buttonName..i]
    if not button then break end
    if button:IsShown() then
      table.insert(buttonList, button)
    end
  end
  return buttonList
end

--points
--1. p1, f, fp1, fp2
--2. p2, rb-1, p3, bm1, bm2
--3. p4, b-1, p5, bm3, bm4
local function SetupButtonPoints(frame, buttonList, buttonWidth, buttonHeight, numCols, p1, fp1, fp2, p2, p3, bm1, bm2, p4, p5, bm3, bm4)
  for index, button in next, buttonList do
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
  numCols = max(min(numButtons, numCols),1)
  local numRows = max(ceil(numButtons/numCols),1)
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

function rBuffFrame:CreateBuffFrame(addonName,cfg)
  cfg.frameName = addonName.."BuffFrame"
  cfg.frameParent = cfg.frameParent or UIParent
  cfg.frameTemplate = nil
  --create new parent frame for buttons
  local frame = CreateFrame("Frame", cfg.frameName, cfg.frameParent, cfg.frameTemplate)
  frame:SetPoint(unpack(cfg.framePoint))
  frame:SetScale(cfg.frameScale)
  local function UpdateAllBuffAnchors()
    --add temp enchant buttons
    local buttonList = GetButtonList("TempEnchant",BuffFrame.numEnchants)
    --add all other buff buttons
    buttonList = GetButtonList("BuffButton",BUFF_MAX_DISPLAY,buttonList)
    --adjust frame by button list
    SetupButtonFrame(frame, cfg.framePadding, buttonList, cfg.buttonWidth, cfg.buttonHeight, cfg.buttonMargin, cfg.numCols, cfg.startPoint)
  end
  hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", UpdateAllBuffAnchors)
  --add drag functions
  rLib:CreateDragFrame(frame, L.dragFrames, -2, true)
  return frame
end

function rBuffFrame:CreateDebuffFrame(addonName,cfg)
  cfg.frameName = addonName.."DebuffFrame"
  cfg.frameParent = cfg.frameParent or UIParent
  cfg.frameTemplate = nil
  --create new parent frame for buttons
  local frame = CreateFrame("Frame", cfg.frameName, cfg.frameParent, cfg.frameTemplate)
  frame:SetPoint(unpack(cfg.framePoint))
  frame:SetScale(cfg.frameScale)
  local function UpdateAllDebuffAnchors(buttonName, index)
    --add all other debuff buttons
    local buttonList = GetButtonList("DebuffButton",DEBUFF_MAX_DISPLAY)
    --adjust frame by button list
    SetupButtonFrame(frame, cfg.framePadding, buttonList, cfg.buttonWidth, cfg.buttonHeight, cfg.buttonMargin, cfg.numCols, cfg.startPoint)
  end
  hooksecurefunc("DebuffButton_UpdateAnchors", UpdateAllDebuffAnchors)
  --add drag functions
  local relativeToName, _, relativeTo  = nil, unpack(cfg.framePoint)
  if type(relativeTo) == "table" then
    relativeToName = relativeTo:GetName()
  elseif type(relativeTo) == "string" and _G[relativeTo] then
    relativeToName = relativeTo
  end
  if relativeToName ~= addonName.."BuffFrame" then
    rLib:CreateDragFrame(frame, L.dragFrames, -2, true)
  end
  return frame
end

--create slash commands
rLib:CreateSlashCmd(L.addonName, L.addonShortcut, L.dragFrames, L.addonColor)