
-- rNamePlate: core
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Options
-----------------------------

local groups = {
  "Friendly",
  "Enemy",
}

local options = {
  useClassColors = true,
  --displayNameWhenSelected = true,
  --displayNameByPlayerNameRules = true,
  playLoseAggroHighlight = false,
  --displayAggroHighlight = true,
  displaySelectionHighlight = false,
  --considerSelectionInCombatAsHostile = false,
  --colorNameWithExtendedColors = true,
  --colorHealthWithExtendedColors = true,
  selectedBorderColor = false,
  tankBorderColor = false,
  defaultBorderColor = CreateColor(0, 0, 0, 0.2),
}

for i, group  in next, groups do
  for key, value in next, options do
    _G["DefaultCompactNamePlate"..group.."FrameOptions"][key] = value
  end
end

-----------------------------
-- Functions
-----------------------------

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

