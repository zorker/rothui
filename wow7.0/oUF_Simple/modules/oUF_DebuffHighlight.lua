local A, L = ...
local oUF = L.oUF or oUF
if not oUF then return end

local playerClass = select(2,UnitClass("player"))
local CanDispel = {
  PRIEST = { Magic = true, Disease = true, },
  SHAMAN = { Magic = true, Curse = true, },
  PALADIN = { Magic = true, Poison = true, Disease = true, },
  MAGE = { Curse = true, },
  DRUID = { Magic = true, Curse = true, Poison = true, },
  MONK = { Magic = true, Disease = true, Poison = true, }
}

local dispellist = CanDispel[playerClass] or {}
local origColors = {}
local origBorderColors = {}
local origPostUpdateAura = {}

local function GetDebuffType(unit, filter)
  for i = 1, 40 do
    local _, _, texture, _, debuffType = UnitAura(unit, i, "HARMFUL")
    if not texture then
      return
    end
    if debuffType and not filter or (filter and dispellist[debuffType]) then
      return debuffType, texture
    end
  end
end

local function Update(self, event, unit)
  if self.unit ~= unit then return end
  local debuffType, texture  = GetDebuffType(unit, self.DebuffHighlightFilter)
  if debuffType then
    local color = DebuffTypeColor[debuffType]
    if self.DebuffHighlightBackdrop or self.DebuffHighlightBackdropBorder then
      if self.DebuffHighlightBackdrop then
        self.DebuffHighlight:SetBackdropColor(color.r, color.g, color.b, self.DebuffHighlightAlpha or 1)
      end
      if self.DebuffHighlightBackdropBorder then
        self.DebuffHighlight:SetBackdropBorderColor(color.r, color.g, color.b, self.DebuffHighlightAlpha or 1)
      end
    elseif self.DebuffHighlightUseTexture then
      self.DebuffHighlight:SetTexture(texture)
    else
      self.DebuffHighlight:SetVertexColor(color.r, color.g, color.b, self.DebuffHighlightAlpha or .5)
    end
  else
    if self.DebuffHighlightBackdrop or self.DebuffHighlightBackdropBorder then
      local color
      if self.DebuffHighlightBackdrop then
        color = origColors[self]
        self.DebuffHighlight:SetBackdropColor(color.r, color.g, color.b, color.a)
      end
      if self.DebuffHighlightBackdropBorder then
        color = origBorderColors[self]
        self.DebuffHighlight:SetBackdropBorderColor(color.r, color.g, color.b, color.a)
      end
    elseif self.DebuffHighlightUseTexture then
      self.DebuffHighlight:SetTexture(nil)
    else
      local color = origColors[self]
      self.DebuffHighlight:SetVertexColor(color.r, color.g, color.b, color.a)
    end
  end
end

local function Enable(self)
  if not self.DebuffHighlight then
    return
  end
  if self.DebuffHighlightFilter and not CanDispel[playerClass] then
    return
  end
  self:RegisterEvent("UNIT_AURA", Update)
  if self.DebuffHighlightBackdrop or self.DebuffHighlightBackdropBorder then
    local r, g, b, a = self:GetBackdropColor()
    origColors[self] = { r = r, g = g, b = b, a = a}
    r, g, b, a = self:GetBackdropBorderColor()
    origBorderColors[self] = { r = r, g = g, b = b, a = a}
  elseif not self.DebuffHighlightUseTexture then
    local r, g, b, a = self.DebuffHighlight:GetVertexColor()
    origColors[self] = { r = r, g = g, b = b, a = a}
  end
  return true
end

local function Disable(self)
  if self.DebuffHighlightBackdrop or self.DebuffHighlightBackdropBorder or self.DebuffHighlight then
    self:UnregisterEvent("UNIT_AURA", Update)
  end
end

oUF:AddElement("DebuffHighlight", Update, Enable, Disable)
