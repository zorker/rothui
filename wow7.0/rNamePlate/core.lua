
-- rNamePlate: core
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

local npdf = NamePlateDriverFrame

-----------------------------
-- Functions
-----------------------------

local groups = {
  "Friendly",
  "Enemy",
}

local options = {
  useClassColors = true,
  displayNameWhenSelected = false,
  displayNameByPlayerNameRules = false,
  playLoseAggroHighlight = false,
}

for i, group  in next, groups do
  for key, value in next, options do
    _G["DefaultCompactNamePlate"..group.."FrameOptions"][key] = value
  end
end

local function OnNamePlateCreated(self,frame)
  print("OnNamePlateCreated", self:GetName(), frame:GetName())
end

local function ApplyFrameOptions(self,frame,unit)
  print("ApplyFrameOptions", self:GetName(), frame:GetName(), unit)
end

local function UpdateNamePlateOptions(self)
  print("UpdateNamePlateOptions", self:GetName())
end

hooksecurefunc(npdf, "OnNamePlateCreated", OnNamePlateCreated)
hooksecurefunc(npdf, "ApplyFrameOptions", ApplyFrameOptions)
hooksecurefunc(npdf, "UpdateNamePlateOptions", UpdateNamePlateOptions)

