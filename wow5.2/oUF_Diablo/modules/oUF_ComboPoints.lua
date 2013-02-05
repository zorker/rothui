
local parent, ns = ...
local oUF = ns.oUF or oUF

local GetComboPoints = GetComboPoints
local MAX_COMBO_POINTS = MAX_COMBO_POINTS

local Update = function(self, event, unit)
  if unit == "pet" then return end
  local bar = self.ComboBar

  local cp = 0
  if(UnitExists("vehicle") and GetComboPoints("vehicle") >= 1) then
    cp = GetComboPoints("vehicle")
  else
    cp = GetComboPoints("player")
  end

  if cp < 1 then
    bar:Hide()
    return
  else
    bar:Show()
  end

  for i=1, MAX_COMBO_POINTS do
    local orb = self.ComboPoints[i]
    local full = cp/MAX_COMBO_POINTS
    if(i <= cp) then
      if full == 1 then
        orb.fill:SetVertexColor(1,0,0)
        orb.glow:SetVertexColor(1,0,0)
      else
        orb.fill:SetVertexColor(bar.color.r,bar.color.g,bar.color.b)
        orb.glow:SetVertexColor(bar.color.r,bar.color.g,bar.color.b)
      end
      orb.fill:Show()
      orb.glow:Show()
      orb.highlight:Show()
    else
      orb.fill:Hide()
      orb.glow:Hide()
      orb.highlight:Hide()
    end
  end
end

local Path = function(self, ...)
  return (self.ComboPoints.Override or Update) (self, ...)
end

local ForceUpdate = function(element)
  return Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local Enable = function(self)
  local element = self.ComboPoints
  if(element) then
    element.__owner = self
    element.ForceUpdate = ForceUpdate

    self:RegisterEvent('UNIT_COMBO_POINTS', Path, true)
    self:RegisterEvent('PLAYER_TARGET_CHANGED', Path, true)

    return true
  end
end

local Disable = function(self)
  local element = self.ComboPoints
  if(element) then
    self:UnregisterEvent('UNIT_COMBO_POINTS', Path)
    self:UnregisterEvent('PLAYER_TARGET_CHANGED', Path)
  end
end

oUF:AddElement('ComboPoints', Path, Enable, Disable)
