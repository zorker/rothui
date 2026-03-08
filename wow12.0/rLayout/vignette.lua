local addonName, ns = ...

local vignettesDB = {}
local vignettesBlackList = { "Garrison Cache", "Full Garrison Cache", "Expedition Scout's Pack", "Valeera Sanguinar" }

local function IsBlackListedVignette(name)
	for i = 1, #vignettesBlackList do  
		if vignettesBlackList[i] == name then  
			return true  
		end  
	end  
	return false  
end

--AlertVignette
local function AlertVignette(id)
  if not id then return end
  if vignettesDB[id] then return end
  local vignetteInfo = C_VignetteInfo.GetVignetteInfo(id)
  if not vignetteInfo then return end
  if not vignetteInfo.onMinimap then return end
  if IsBlackListedVignette(vignetteInfo.name) then return end
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