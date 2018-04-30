local A, L = ...
local oUF = L.oUF or oUF
if not oUF then return end

--config/variables

local playerClass = select(2,UnitClass("player"))
local canDispel = {
  PRIEST = { Magic = true, Disease = true, },
  SHAMAN = { Magic = true, Curse = true, },
  PALADIN = { Magic = true, Poison = true, Disease = true, },
  MAGE = { Curse = true, },
  DRUID = { Magic = true, Curse = true, Poison = true, },
  MONK = { Magic = true, Disease = true, Poison = true, }
}
local dispelList = canDispel[playerClass] or {}
local origColors = {}
local origBorderColors = {}
local DebuffTypeColor, UnitAura, unpack = DebuffTypeColor, UnitAura, unpack

--GetDebuffType
local function GetDebuffType(unit, filter)
  for i = 1, 40 do
    local _, texture, _, debuffType = UnitAura(unit, i, "HARMFUL")
    if not texture then
      return
    end
    if debuffType and not filter or (filter and dispelList[debuffType]) then
      return debuffType, texture
    end
  end
end

--Update
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
      self.DebuffHighlight:SetVertexColor(color.r, color.g, color.b, self.DebuffHighlightAlpha or 1)
    end
  else
    if self.DebuffHighlightBackdrop or self.DebuffHighlightBackdropBorder then
      if self.DebuffHighlightBackdrop then
        self.DebuffHighlight:SetBackdropColor(unpack(origColors[self]))
      end
      if self.DebuffHighlightBackdropBorder then
        self.DebuffHighlight:SetBackdropBorderColor(unpack(origBorderColors[self]))
      end
    elseif self.DebuffHighlightUseTexture then
      self.DebuffHighlight:SetTexture(nil)
    else
      self.DebuffHighlight:SetVertexColor(unpack(origColors[self]))
    end
  end
end

--Enable
local function Enable(self)
  if not self.DebuffHighlight then return end
  if self.DebuffHighlightFilter and not canDispel[playerClass] then return end
  if self.DebuffHighlightBackdrop or self.DebuffHighlightBackdropBorder then
    origColors[self] = { self.DebuffHighlight:GetBackdropColor() }
    origBorderColors[self] = { self.DebuffHighlight:GetBackdropBorderColor() }
  elseif not self.DebuffHighlightUseTexture then
    origColors[self] = { self.DebuffHighlight:GetVertexColor() }
  end
  self:RegisterEvent("UNIT_AURA", Update)
  return true
end

--Disable
local function Disable(self)
  if self.DebuffHighlight then
    self:UnregisterEvent("UNIT_AURA", Update)
  end
end

--oUF:AddElement
oUF:AddElement("DebuffHighlight", Update, Enable, Disable)
