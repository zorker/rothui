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
  local atlasInfo = C_Texture.GetAtlasInfo(vignetteInfo.atlasName)
  local left = atlasInfo.leftTexCoord * 256
  local right = atlasInfo.rightTexCoord * 256
  local top = atlasInfo.topTexCoord * 256
  local bottom = atlasInfo.bottomTexCoord * 256
  local str = "|TInterface\\MINIMAP\\ObjectIconsAtlas:0:0:0:0:256:256:"..(left)..":"..(right)..":"..(top)..":"..(bottom).."|t"
  PlaySound(SOUNDKIT.RAID_WARNING)
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