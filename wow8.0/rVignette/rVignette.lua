-- rVignette: core
-- zork, 2018

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Functions
-----------------------------

local function OnVignetteAdded(self,event,id)
  if not id then return end
  self.vignettes = self.vignettes or {}
  if self.vignettes[id] then return end
  local vignetteInfo = C_VignetteInfo.GetVignetteInfo(id)
  if not vignetteInfo then return end
  local filename, width, height, txLeft, txRight, txTop, txBottom = GetAtlasInfo(vignetteInfo.atlasName)
  if not filename then return end
  local atlasWidth = width/(txRight-txLeft)
  local atlasHeight = height/(txBottom-txTop)
  local pxLeft = atlasWidth*txLeft
  local pxRight = atlasWidth*txRight
  local pxTop = atlasHeight*txTop
  local pxBottom = atlasHeight*txBottom
  local str = string.format("|T%s:%d:%d:0:0:%d:%d:%d:%d:%d:%d|t", filename, size, size, atlasWidth, atlasHeight, pxLeft, pxRight, pxTop, pxBottom)
  PlaySoundFile("Sound\\Interface\\RaidWarning.ogg")
  RaidNotice_AddMessage(RaidWarningFrame, str.." "..vignetteInfo.name.." spotted!", ChatTypeInfo["RAID_WARNING"])
  print(str.." "..vignetteInfo.name,"spotted!")
  self.vignettes[id] = true
end

-----------------------------
-- Init
-----------------------------

--eventHandler
local eventHandler = CreateFrame("Frame")
eventHandler:RegisterEvent("VIGNETTE_MINIMAP_UPDATED")
eventHandler:SetScript("OnEvent", OnVignetteAdded)