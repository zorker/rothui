
-- rBuffFrame_Zork: layout
-- zork, 2016

-- Zork's buff frame Layout for rBuffFrame

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- buffFrameConfig
-----------------------------

local buffFrameConfig = {
  framePoint      = { "TOPRIGHT", Minimap, "TOPLEFT", -5, -5 },
  frameScale      = 1,
  framePadding    = 5,
  buttonWidth     = 32,
  buttonHeight    = 32,
  buttonMargin    = 5,
  numCols         = 10,
  startPoint      = "TOPRIGHT",
  --rowMargin       = 20,
}
--create
local buffFrame = rBuffFrame:CreateBuffFrame(A, buffFrameConfig)

-----------------------------
-- debuffFrameConfig
-----------------------------

local debuffFrameConfig = {
  framePoint      = { "TOPRIGHT", buffFrame, "BOTTOMRIGHT", 0, -5 },
  frameScale      = 1,
  framePadding    = 5,
  buttonWidth     = 40,
  buttonHeight    = 40,
  buttonMargin    = 5,
  numCols         = 8,
  startPoint      = "TOPRIGHT",
}
--create
rBuffFrame:CreateDebuffFrame(A, debuffFrameConfig)
