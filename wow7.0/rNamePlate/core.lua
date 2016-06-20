
-- rNamePlate: core
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Options
-----------------------------

local mediapath = "interface\\addons\\"..A.."\\media\\"

local groups = {
  "Friendly",
  "Enemy",
}

local options = {
  useClassColors = true,
  --displayNameWhenSelected = true,
  --displayNameByPlayerNameRules = true,
  --playLoseAggroHighlight = false,
  --displayAggroHighlight = true,
  displaySelectionHighlight = false,
  --considerSelectionInCombatAsHostile = false,
  --colorNameWithExtendedColors = true,
  --colorHealthWithExtendedColors = true,
  selectedBorderColor = false,
  tankBorderColor = false,
  defaultBorderColor = CreateColor(0, 0, 0, 0.2),
  showClassificationIndicator = false,
}

for i, group  in next, groups do
  for key, value in next, options do
    _G["DefaultCompactNamePlate"..group.."FrameOptions"][key] = value
  end
end

-----------------------------
-- Functions
-----------------------------

--SetupNamePlate
local function SetupNamePlate(frame, setupOptions, frameOptions)
  --frame.healthBar:SetStatusBarTexture(mediapath.."statusbar")
  frame.castBar:SetStatusBarTexture(mediapath.."statusbar")
  if GetCVar("NamePlateVerticalScale") == "1" then
    frame.castBar:SetHeight(11)
    frame.castBar.Icon:SetTexCoord(0.1,0.9,0.1,0.9)
    frame.castBar.Icon:SetSize(17,17)
    frame.castBar.Icon:ClearAllPoints()
    frame.castBar.Icon:SetPoint("BOTTOMRIGHT",frame.castBar,"BOTTOMLEFT")
  end
end
hooksecurefunc("DefaultCompactNamePlateFrameSetupInternal", SetupNamePlate)

local function IsTank()
  local assignedRole = UnitGroupRolesAssigned("player")
  if assignedRole == "TANK" then return true end
  local role = GetSpecializationRole(GetSpecialization())
  if role == "TANK" then return true end
  return false
end

--UpdateHealthBorder
local function UpdateHealthBorder(frame)
  if frame.displayedUnit:match("(nameplate)%d?$") ~= "nameplate" then return end
  if not IsTank() then return end
  local status = UnitThreatSituation("player", frame.displayedUnit)
  if status and status >= 3 then
    frame.healthBar.border:SetVertexColor(0, 1, 0, 0.8)
  end
end
hooksecurefunc("CompactUnitFrame_UpdateHealthBorder", UpdateHealthBorder)

