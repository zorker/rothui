--[[ Element: Harmony Orbs
 Toggles visibility of the players Chi.

 Widget

 Harmomy - An array consisting of four UI widgets.

 Notes

 The default harmony orb texture will be applied to textures within the Harmony
 array that don't have a texture or color defined.

 Examples

   local Harmony = {}
   for index = 1, UnitPowerMax('player', SPELL_POWER_LIGHT_FORCE) do
      local Chi = self:CreateTexture(nil, 'BACKGROUND')

      -- Position and size of the chi orbs.
      Chi:SetSize(14, 14)
      Chi:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', index * Chi:GetWidth(), 0)

      Harmony[index] = Chi
   end

   -- Register with oUF
   self.Harmony = Harmony

 Hooks

 Override(self) - Used to completely override the internal update function.
                  Removing the table key entry will make the element fall-back
                  to its internal function again.
]]

local parent, ns = ...
local oUF = ns.oUF or oUF

local SPELL_POWER_LIGHT_FORCE = SPELL_POWER_LIGHT_FORCE

local Update = function(self, event, unit)
  if(self.unit ~= unit or (powerType and powerType ~= "LIGHT_FORCE")) then return end
  local bar = self.HarmonyPowerBar
  local num = UnitPower(unit, SPELL_POWER_LIGHT_FORCE)
  local max = UnitPowerMax(unit, SPELL_POWER_LIGHT_FORCE)
  if num < 1 then
    if bar:IsShown() then bar:Hide() end
    return
  else
    if not bar:IsShown() then bar:Show() end
  end
  --adjust the width of the harmony power frame
  local w = 64*(max+2)
  bar:SetWidth(w)
  for i = 1, bar.maxOrbs do
    local orb = self.Harmony[i]
    if i > max then
       if orb:IsShown() then orb:Hide() end
    else
      if not orb:IsShown() then orb:Show() end
    end
  end
  for i = 1, max do
    local orb = self.Harmony[i]
    local full = num/max
    if(i <= num) then
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
	return (self.Harmony.Override or Update) (self, ...)
end

local ForceUpdate = function(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local Enable = function(self, unit)
	local element = self.Harmony
	if(element and unit == 'player') then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		self:RegisterEvent('UNIT_POWER', Path, true)
		self:RegisterEvent('UNIT_DISPLAYPOWER', Path, true)

		for index = 1, UnitPowerMax(unit, SPELL_POWER_LIGHT_FORCE) do
			local chi = element[index]
			if(chi:IsObjectType'Texture' and not chi:GetTexture()) then
				chi:SetTexture[[Interface\PlayerFrame\MonkUI]]
				chi:SetTexCoord(0.00390625, 0.08593750, 0.71093750, 0.87500000)
			end
		end

		return true
	end
end

local Disable = function(self)
	local element = self.Harmony
	if(element) then
		self:UnregisterEvent('UNIT_POWER', Path)
		self:UnregisterEvent('UNIT_DISPLAYPOWER', Path)
	end
end

oUF:AddElement('Harmony', Path, Enable, Disable)
