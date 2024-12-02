-- rBlizzardStuff/nameplate: nameplate adjustments
-- zork, 2024

-----------------------------
-- Variables
-----------------------------

local A, L = ...

--gradient nameplate colors horizontally
local nameplateBorderColors = {
  tankwarning = {
    color = CreateColor(1, 0.8, 0, 1),
    alphaLeft = 1,
    alphaRight = .7
  },
  default = {
    color = CreateColor(0, 0, 0, 1),
    alphaLeft = .9,
    alphaRight = .4
  },
  selected = {
    color = CreateColor(1, 1, 1, 1),
    alphaLeft = .9,
    alphaRight = .5
  }
}
local nameplateBackgroundColor = CreateColor(0, 0, 0, .5)

local iconTexCoord = {0.12,0.92,0.12,0.92}

-----------------------------
-- Functions
-----------------------------

local function SetBorderColor(frame, colorConfig)
  frame.HealthBarsContainer.background:SetVertexColor(nameplateBackgroundColor:GetRGBA())
  local r,g,b,a = colorConfig.color:GetRGBA()
  frame.HealthBarsContainer.border.Top:SetGradient("HORIZONTAL", CreateColor(r, g, b, colorConfig.alphaLeft), CreateColor(r, g, b, colorConfig.alphaRight))
  frame.HealthBarsContainer.border.Left:SetVertexColor(r, g, b, colorConfig.alphaLeft)
  frame.HealthBarsContainer.border.Right:SetVertexColor(r, g, b, colorConfig.alphaRight)
  frame.HealthBarsContainer.border.Bottom:SetGradient("HORIZONTAL", CreateColor(r, g, b, colorConfig.alphaLeft), CreateColor(r, g, b, colorConfig.alphaRight))
end

local function SetupNamePlateCastbar(frame)
  frame.castBar:SetHeight(frame.HealthBarsContainer:GetHeight()*1)
  frame.castBar.Icon:SetScale(frame.HealthBarsContainer:GetScale()*1.75)
  frame.castBar.Icon:SetTexCoord(unpack(iconTexCoord))
  frame.castBar.Icon:ClearAllPoints()
  PixelUtil.SetPoint(frame.castBar.Icon, "BOTTOMRIGHT", frame.castBar, "BOTTOMLEFT", -1, -1)
  frame.castBar.Text:ClearAllPoints()
  PixelUtil.SetPoint(frame.castBar.Text, "TOP", frame.castBar, "BOTTOM", 0, 0)
end

local function IsPlayerEffectivelyTank()
  local assignedRole = UnitGroupRolesAssigned("player")
  if ( assignedRole == "NONE" ) then
    local spec = GetSpecialization();
    return spec and GetSpecializationRole(spec) == "TANK"
  end
  return assignedRole == "TANK";
end

local function IsOnThreatList(threatStatus)
  return threatStatus ~= nil
end

local function UpdateNamePlateBorder(frame)
  if not frame.HealthBarsContainer then return end
  local nameplate = C_NamePlate.GetNamePlateForUnit(frame.displayedUnit)
  if not nameplate then return end
  if UnitIsUnit(frame.displayedUnit, "target") then
    SetBorderColor(frame, nameplateBorderColors.selected)
    return
  end
  if IsInGroup() and IsPlayerEffectivelyTank() then
    local isTanking, threatStatus = UnitDetailedThreatSituation("player", frame.displayedUnit)
    if not isTanking and IsOnThreatList(threatStatus) then
      SetBorderColor(frame, nameplateBorderColors.tankwarning)
      return
    end
  end
  SetBorderColor(frame, nameplateBorderColors.default)
end

local function UpdateNamePlateClassificationIndicator(frame)
  if not frame.classificationIndicator then return end
  local nameplate = C_NamePlate.GetNamePlateForUnit(frame.displayedUnit)
  if not nameplate then return end
  frame.classificationIndicator:Hide()
end

local function UpdateNamePlateSelectionHighlight(frame)
  if not frame.selectionHighlight then return end
  local nameplate = C_NamePlate.GetNamePlateForUnit(frame.displayedUnit)
  if not nameplate then return end
  frame.selectionHighlight:Hide()
end

hooksecurefunc("CompactUnitFrame_UpdateHealthBorder", UpdateNamePlateBorder)
hooksecurefunc("CompactUnitFrame_UpdateClassificationIndicator", UpdateNamePlateClassificationIndicator)
hooksecurefunc("CompactUnitFrame_UpdateSelectionHighlight", UpdateNamePlateSelectionHighlight)
hooksecurefunc("DefaultCompactNamePlateFrameAnchorInternal", SetupNamePlateCastbar)
