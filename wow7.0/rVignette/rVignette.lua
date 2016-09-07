
-- rVignette: core
-- zork, 2016

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
  local x, y, name, icon = C_Vignettes.GetVignetteInfoFromInstanceID(id)
  local left, right, top, bottom = GetObjectIconTextureCoords(icon)
  PlaySoundFile("Sound\\Interface\\RaidWarning.ogg")
  local str = "|TInterface\\MINIMAP\\ObjectIconsAtlas:0:0:0:0:256:256:"..(left*256)..":"..(right*256)..":"..(top*256)..":"..(bottom*256).."|t"
  RaidNotice_AddMessage(RaidWarningFrame, str..name.." spotted!", ChatTypeInfo["RAID_WARNING"])
  print(str..name,"spotted!")
  self.vignettes[id] = true
end

-----------------------------
-- Init
-----------------------------

--eventHandler
local eventHandler = CreateFrame("Frame")
eventHandler:RegisterEvent("VIGNETTE_ADDED")
eventHandler:SetScript("OnEvent", OnVignetteAdded)