
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
  selectedBorderColor = false, --CreateColor(1, 1, 1, .35),
  tankBorderColor = false,
  newTankBorderColor = {0, 1, 0, 0.8},
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

--UpdateAggroHighlight
local function UpdateAggroHighlight(frame)
  if frame.displayedUnit:match("(nameplate)%d?$") ~= "nameplate" then return end
  local status = UnitThreatSituation("player", frame.displayedUnit)
  if ( status and status > 0 ) then
    frame.aggroHighlight:SetVertexColor(GetThreatStatusColor(status))
    frame.aggroHighlight:Show()
  else
    frame.aggroHighlight:Hide()
  end
end
--hooksecurefunc("CompactUnitFrame_UpdateAggroHighlight", UpdateAggroHighlight)

--OnEvent
local function OnEvent(frame,event,...)
  if event ~= "UNIT_THREAT_LIST_UPDATE" then return end
  if frame.displayedUnit:match("(nameplate)%d?$") ~= "nameplate" then return end
  local unit = ...
  if unit == frame.displayedUnit then
    CompactUnitFrame_UpdateAggroHighlight(frame)
  end
end
--hooksecurefunc("CompactUnitFrame_OnEvent", OnEvent)

--SetupNamePlate
local function SetupNamePlate(frame, setupOptions, frameOptions)
  --frame.aggroHighlight:SetAlpha(1)
end
--hooksecurefunc("DefaultCompactNamePlateFrameSetupInternal", SetupNamePlate)

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
  --print("UpdateHealthBorder", frame:GetName(), frame.displayedUnit, IsTank(), UnitAffectingCombat(frame.displayedUnit))
  if not IsTank() then return end
  local status = UnitThreatSituation("player", frame.displayedUnit)
  if status and status >= 3 then
    frame.healthBar.border:SetVertexColor(unpack(frame.optionTable.newTankBorderColor))
  end
end
hooksecurefunc("CompactUnitFrame_UpdateHealthBorder", UpdateHealthBorder)

