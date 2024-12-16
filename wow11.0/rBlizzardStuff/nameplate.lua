-- rBlizzardStuff/nameplate: nameplate adjustments
-- zork, 2024
-----------------------------
-- Variables
-----------------------------
local A, L = ...

-- gradient nameplate colors horizontally
local nameplateBorderColors = {
  tankwarning = {
    color = CreateColor(1, 0.8, 0, 1),
    alphaLeft = 1,
    alphaRight = .7
  },
  default = {
    color = CreateColor(0, 0, 0, 1),
    alphaLeft = .5,
    alphaRight = .1
  },
  selected = {
    color = CreateColor(0, 1, 1, 1),
    alphaLeft = .9,
    alphaRight = 0.1
  }
}
local nameplateBackgroundColor = CreateColor(0, 0, 0, .5)

local iconTexCoord = {0.12, 0.92, 0.12, 0.92}

local classificationColors = {}
classificationColors["worldboss"] = {
  color = {1, 0, 0, 1},
  desaturated = false
}
classificationColors["boss"] = {
  color = {1, 0, 0, 1},
  desaturated = false
}
classificationColors["rareelite"] = {
  color = {1, 0, 0, 1},
  desaturated = false
}
classificationColors["elite"] = {
  color = {0, 0, 0, 0.4},
  desaturated = false
}
classificationColors["rare"] = {
  color = {1, 0, 0, 1},
  desaturated = false
}
classificationColors["normal"] = {
  color = {0, 0, 0, 0.4},
  desaturated = false
}
classificationColors["trivial"] = {
  color = {0, 0, 0, 0.4},
  desaturated = false
}
classificationColors["minus"] = {
  color = {0, 0, 0, 0.2},
  desaturated = false
}

-----------------------------
-- Functions
-----------------------------

local function SetBorderColor(self, colorConfig)
  self.HealthBarsContainer.background:SetVertexColor(nameplateBackgroundColor:GetRGBA())
  local r, g, b, a = colorConfig.color:GetRGBA()
  self.HealthBarsContainer.border.Top:SetGradient("HORIZONTAL", CreateColor(r, g, b, colorConfig.alphaLeft),
    CreateColor(r, g, b, colorConfig.alphaRight))
  self.HealthBarsContainer.border.Left:SetVertexColor(r, g, b, colorConfig.alphaLeft)
  self.HealthBarsContainer.border.Right:SetVertexColor(r, g, b, colorConfig.alphaRight)
  self.HealthBarsContainer.border.Bottom:SetGradient("HORIZONTAL", CreateColor(r, g, b, colorConfig.alphaLeft),
    CreateColor(r, g, b, colorConfig.alphaRight))
end

local function SetupNamePlateCastbar(self)
  self.castBar:SetHeight(self.HealthBarsContainer:GetHeight() * 1)
  self.castBar.Icon:SetScale(self.HealthBarsContainer:GetScale() * 1.75)
  self.castBar.Icon:SetTexCoord(unpack(iconTexCoord))
  self.castBar.Icon:ClearAllPoints()
  PixelUtil.SetPoint(self.castBar.Icon, "BOTTOMRIGHT", self.castBar, "BOTTOMLEFT", -1, -1)
  self.castBar.Text:ClearAllPoints()
  PixelUtil.SetPoint(self.castBar.Text, "TOP", self.castBar, "BOTTOM", 0, 0)
end

local function IsPlayerEffectivelyTank()
  local assignedRole = UnitGroupRolesAssigned("player")
  if (assignedRole == "NONE") then
    local spec = GetSpecialization();
    return spec and GetSpecializationRole(spec) == "TANK"
  end
  return assignedRole == "TANK";
end

local function IsOnThreatList(threatStatus)
  return threatStatus ~= nil
end

local function IsNameplateFrame(self)
  if self:IsForbidden() then
    return false
  end
  if not self.HealthBarsContainer then
    return false
  end
  if not self.classificationIndicator then
    return false
  end
  if not self.selectionHighlight then
    return false
  end
  if not self.displayedUnit then
    return false
  end
  if not self.displayedUnit:match('nameplate%d?$') then
    return false
  end
  local nameplate = C_NamePlate.GetNamePlateForUnit(self.displayedUnit)
  if not nameplate then
    return false
  end
  return true
end

local function UpdateNamePlateBorder(self)
  if not IsNameplateFrame(self) then
    return
  end
  if UnitIsUnit(self.displayedUnit, "target") then
    SetBorderColor(self, nameplateBorderColors.selected)
    return
  end
  if IsInGroup() and IsPlayerEffectivelyTank() then
    local isTanking, threatStatus = UnitDetailedThreatSituation("player", self.displayedUnit)
    if not isTanking and IsOnThreatList(threatStatus) then
      SetBorderColor(self, nameplateBorderColors.tankwarning)
      return
    end
  end
  SetBorderColor(self, nameplateBorderColors.default)
end

local function AddNameBackground(self)
  local layer, sublayer = self.name:GetDrawLayer()
  local bg = self:CreateTexture(nil, layer)
  bg:SetDrawLayer(layer, sublayer - 1)
  bg:SetPoint("BOTTOMLEFT", self.HealthBarsContainer.border.Top, "TOPLEFT", -20, 0)
  bg:SetPoint("BOTTOMRIGHT", self.HealthBarsContainer.border.Top, "TOPRIGHT", 20, 0)
  bg:SetHeight(16)
  bg:SetAtlas("glues-characterSelect-TopHUD-BG")
  self.name.__bg = bg
  return bg
end

local function UpdateNamePlateClassificationIndicator(self)
  if not IsNameplateFrame(self) then
    return
  end
  self.classificationIndicator:Hide()
  local classification = UnitClassification(self.displayedUnit)
  if not classification then
    return
  end
  local bg = self.name.__bg or AddNameBackground(self)
  bg:SetVertexColor(unpack(classificationColors[classification].color))
  bg:SetDesaturated(classificationColors[classification].desaturated)
end

local function UpdateNamePlateSelectionHighlight(self)
  if not IsNameplateFrame(self) then
    return
  end
  self.selectionHighlight:Hide()
end

hooksecurefunc("CompactUnitFrame_UpdateHealthBorder", UpdateNamePlateBorder)
hooksecurefunc("CompactUnitFrame_UpdateClassificationIndicator", UpdateNamePlateClassificationIndicator)
hooksecurefunc("CompactUnitFrame_UpdateSelectionHighlight", UpdateNamePlateSelectionHighlight)
hooksecurefunc("DefaultCompactNamePlateFrameAnchorInternal", SetupNamePlateCastbar)
