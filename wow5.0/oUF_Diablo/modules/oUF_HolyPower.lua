--[[ Element: Holy Power Indicator

 Toggles the visibility of the player's holy power indicator.

 Widget

 HolyPower - An array consisting of three UI widgets.

 Examples

   local HolyPower = {}
   local maxHolyPower = UnitPowerMax('player', SPELL_POWER_HOLY_POWER)
   for index = 1, maxHolyPower do
      local Texture = self:CreateTexture(nil, 'BACKGROUND')

      -- Position and size
      Texture:SetSize(16, 16)
      Texture:SetTexture(1, 1, 0)
      Texture:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', index * Texture:GetWidth(), 0)

      HolyPower[index] = Texture
   end

   -- Register with oUF
   self.HolyPower = HolyPower

 Hooks

 Override(self) - Used to completely override the internal update function.
                  Removing the table key entry will make the element fall-back
                  to its internal function again.
]]

if(select(2, UnitClass('player')) ~= 'PALADIN') then return end

local parent, ns = ...
local oUF = ns.oUF or oUF

local SPELL_POWER_HOLY_POWER = SPELL_POWER_HOLY_POWER

local Update = function(self, event, unit, powerType)
  if(self.unit ~= unit or (powerType and powerType ~= "HOLY_POWER")) then return end
  local bar = self.HolyPowerBar
  local num = UnitPower("player", SPELL_POWER_HOLY_POWER)
  local maxHolyPower = UnitPowerMax("player", SPELL_POWER_HOLY_POWER)
  if num < 1 then
    if bar:IsShown() then bar:Hide() end
    return
  else
    if not bar:IsShown() then bar:Show() end
  end
  --adjust the width of the holy power frame
  local w = 64*(maxHolyPower+2)
  bar:SetWidth(w)
  for i = 1, bar.maxOrbs do
    local orb = self.HolyPower[i]
    if i > maxHolyPower then
       if orb:IsShown() then orb:Hide() end
    else
      if not orb:IsShown() then orb:Show() end
    end
  end
  for i = 1, maxHolyPower do
    local orb = self.HolyPower[i]
    local full = num/maxHolyPower
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
	return (self.HolyPower.Override or Update) (self, ...)
end

local ForceUpdate = function(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit, 'HOLY_POWER')
end

local function Enable(self)
	local hp = self.HolyPower
	if(hp) then
		hp.__owner = self
		hp.ForceUpdate = ForceUpdate

		self:RegisterEvent('UNIT_POWER', Path)

		return true
	end
end

local function Disable(self)
	local hp = self.HolyPower
	if(hp) then
		self:UnregisterEvent('UNIT_POWER', Path)
	end
end

oUF:AddElement('HolyPower', Path, Enable, Disable)
