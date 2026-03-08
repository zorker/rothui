local addonName, ns = ...

local vignettesDB = {}
local blacklistedVignette = {}
local blacklistNames = { 
  "Garrison Cache", 
  "Full Garrison Cache", 
  "Expedition Scout's Pack", 
  "Valeera Sanguinar", 
  "Decor Specialist", 
  "Altar of Blessings",
  "Rostrum of Transformation"
}

--SetBlackListedVignettes
local function SetBlackListedVignettes()
	for i = 1, #blacklistNames do
    blacklistedVignette[blacklistNames[i]] = true
	end  
end
SetBlackListedVignettes()

--AlertVignette
local function AlertVignette(id)
  if not id then return end
  if vignettesDB[id] then return end
  local vignetteInfo = C_VignetteInfo.GetVignetteInfo(id)
  if not vignetteInfo then return end
  if not vignetteInfo.onMinimap then return end
  if blacklistedVignette[vignetteInfo.name] then return end
  local atlasInfo = C_Texture.GetAtlasInfo(vignetteInfo.atlasName)
  local left = atlasInfo.leftTexCoord * 256
  local right = atlasInfo.rightTexCoord * 256
  local top = atlasInfo.topTexCoord * 256
  local bottom = atlasInfo.bottomTexCoord * 256
  local str = "|TInterface\\MINIMAP\\ObjectIconsAtlas:0:0:0:0:256:256:"..(left)..":"..(right)..":"..(top)..":"..(bottom).."|t"
  RaidNotice_AddMessage(RaidWarningFrame, str.." "..vignetteInfo.name.." spotted!", ChatTypeInfo["RAID_WARNING"])
  print(str.." "..vignetteInfo.name,"spotted!")
  PlaySoundFile(2530811) --do you see it from xala'tath
  vignettesDB[id] = true
end

ns.AlertVignette = AlertVignette