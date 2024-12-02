-- rBlizzardStuff/vignette: show alert on special minimap indicators (rares/chests)
-- zork, 2024

-----------------------------
-- Variables
-----------------------------

local A, L = ...

local vignettesDB = {}

-----------------------------
-- Functions
-----------------------------

local function VignetteAdded(event,id)
  if not id then return end
  if vignettesDB[id] then return end
  local vignetteInfo = C_VignetteInfo.GetVignetteInfo(id)
  if not vignetteInfo then return end
  if not vignetteInfo.onMinimap then return end
  local atlasInfo = C_Texture.GetAtlasInfo(vignetteInfo.atlasName)
  local left = atlasInfo.leftTexCoord * 256
  local right = atlasInfo.rightTexCoord * 256
  local top = atlasInfo.topTexCoord * 256
  local bottom = atlasInfo.bottomTexCoord * 256
  local str = "|TInterface\\MINIMAP\\ObjectIconsAtlas:0:0:0:0:256:256:"..(left)..":"..(right)..":"..(top)..":"..(bottom).."|t"
  PlaySoundFile(567397)
  if vignetteInfo.name ~= "Garrison Cache" and vignetteInfo.name ~= "Full Garrison Cache" then
    RaidNotice_AddMessage(RaidWarningFrame, str.." "..vignetteInfo.name.." spotted!", ChatTypeInfo["RAID_WARNING"])
    print(str.." "..vignetteInfo.name,"spotted!")
    vignettesDB[id] = true
  end
end

rLib:RegisterCallback("VIGNETTE_MINIMAP_UPDATED", VignetteAdded)
