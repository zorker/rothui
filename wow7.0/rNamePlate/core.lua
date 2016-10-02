
-- rNamePlate: core
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

local W = CreateFrame("Frame") --worker
local UFM = {} --unit frame mixin
local C_NamePlate = C_NamePlate

-----------------------------
-- SetCVar
-----------------------------

--default values
SetCVar('nameplateShowAll', GetCVarDefault("nameplateShowAll"))
SetCVar("nameplateMaxAlpha", GetCVarDefault("nameplateMaxAlpha"))
SetCVar("nameplateShowEnemies", GetCVarDefault("nameplateShowEnemies"))
SetCVar("ShowClassColorInNameplate", GetCVarDefault("ShowClassColorInNameplate"))
SetCVar("nameplateOtherTopInset", GetCVarDefault("nameplateOtherTopInset"))
SetCVar("nameplateOtherBottomInset", GetCVarDefault("nameplateOtherBottomInset"))
SetCVar("nameplateMinScale", GetCVarDefault("nameplateMinScale"))
SetCVar("namePlateMaxScale", GetCVarDefault("namePlateMaxScale"))
SetCVar("nameplateMinScaleDistance", GetCVarDefault("nameplateMinScaleDistance"))
SetCVar("nameplateMaxDistance", GetCVarDefault("nameplateMaxDistance"))
SetCVar("NamePlateHorizontalScale", GetCVarDefault("NamePlateHorizontalScale"))
SetCVar("NamePlateVerticalScale", GetCVarDefault("NamePlateVerticalScale"))

-----------------------------
-- Hide Blizzard
-----------------------------

function W:UpdateNamePlateOptions(...)
  print("UpdateNamePlateOptions",...)
end

--disable blizzard nameplates
NamePlateDriverFrame:UnregisterAllEvents()
NamePlateDriverFrame:Hide()
NamePlateDriverFrame.UpdateNamePlateOptions = W.UpdateNamePlateOptions

-----------------------------
-- Worker
-----------------------------

function W:NAME_PLATE_CREATED(nameplate)
  print("NAME_PLATE_CREATED",nameplate:GetName(),nameplate:GetSize())
  local unitFrame = CreateFrame("Button", nameplate:GetName().."UnitFrame", nameplate)
  unitFrame:SetAllPoints()
  nameplate.unitFrame = unitFrame
  --mix-in ubm table data
  Mixin(unitFrame, UFM)
  --create subframes (health, name, etc...)
  unitFrame:Create(nameplate)
end

function W:NAME_PLATE_UNIT_ADDED(unit)
  local nameplate = C_NamePlate.GetNamePlateForUnit(unit)
  nameplate.unitFrame:UnitAdded(nameplate,unit)
end

function W:NAME_PLATE_UNIT_REMOVED(unit)
  local nameplate = C_NamePlate.GetNamePlateForUnit(unit)
  nameplate.unitFrame:UnitRemoved(nameplate,unit)
end

function W:OnEvent(event,...)
  print("W:OnEvent",...)
  self[event](event,...)
end

W:SetScript("OnEvent", W.OnEvent)

W:RegisterEvent("NAME_PLATE_CREATED")
W:RegisterEvent("NAME_PLATE_UNIT_ADDED")
W:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
--W:RegisterEvent("PLAYER_TARGET_CHANGED")
--W:RegisterEvent("DISPLAY_SIZE_CHANGED")
--W:RegisterEvent("UNIT_AURA")
--W:RegisterEvent("VARIABLES_LOADED")
--W:RegisterEvent("CVAR_UPDATE")
--W:RegisterEvent("RAID_TARGET_UPDATE")
--W:RegisterEvent("UNIT_FACTION")

-----------------------------
-- Unit Frame Mixin
-----------------------------

function UFM:Create(nameplate)
  print("UFM:Create",self:GetName(),nameplate:GetName())
  --create health bar
  local t = self:CreateTexture(nil,"BACKGROUND",nil,-8)
  t:SetColorTexture(0,1,0)
  t:SetSize(32,32)
  t:SetPoint("CENTER")

  --create name
  self:Hide()
end

function UFM:UnitAdded(nameplate,unit)
  print("UFM:UnitAdded",self:GetName(),nameplate:GetName(),unit)

  self.unit = unit
  self.inVehicle = UnitInVehicle(unit)


  self:Show()

end

function UFM:UnitRemoved(nameplate,unit)
  print("UFM:UnitRemoved",self:GetName(),nameplate:GetName(),unit)

  self.unit = nil
  self.inVehicle = nil

  self:Hide()

end