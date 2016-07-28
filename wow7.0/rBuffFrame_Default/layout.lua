
-- rBuffFrame_Default: layout
-- zork, 2016

-- Default buff frame Layout for rBuffFrame

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- buffFrameConfig
-----------------------------

local buffFrameConfig = {
  framePoint      = { "TOPRIGHT", Minimap, "TOPLEFT", -35, 0 },
  frameScale      = 1,
  framePadding    = 5,
  buttonWidth     = 32,
  buttonHeight    = 32,
  buttonMargin    = 5,
  numCols         = 1,
  startPoint      = "TOPRIGHT",
}
--create
rBuffFrame:CreateBuffFrame(A, buffFrameConfig)

-----------------------------
-- debuffFrameConfig
-----------------------------

local debuffFrameConfig = {
  framePoint      = { "TOPRIGHT", _G[A.."BuffFrame"], "BOTTOMRIGHT", 0, 0 },
  frameScale      = 1,
  framePadding    = 5,
  buttonWidth     = 32,
  buttonHeight    = 32,
  buttonMargin    = 5,
  numCols         = 1,
  startPoint      = "TOPRIGHT",
}
--create
rBuffFrame:CreateDebuffFrame(A, debuffFrameConfig)
