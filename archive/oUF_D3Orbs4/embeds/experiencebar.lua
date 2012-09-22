--[[

	Elements handled:
	 .Experience [statusbar]
	 .Experience.Text [fontstring] (optional)
	 .Experience.Rested [statusbar] (optional)

	Booleans:
	 - Tooltip

	Functions that can be overridden from within a layout:
	 - PostUpdate(self, event, unit, bar, min, max)
	 - OverrideText(bar, unit, min, max)

--]]
local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, 'oUF Experience was unable to locate oUF install')

local hunter = select(2, UnitClass('player')) == 'HUNTER'

local function xp(unit)
	if(unit == 'pet') then
		return GetPetExperience()
	else
		return UnitXP(unit), UnitXPMax(unit)
	end
end

local function tooltip(self)
	local unit = self:GetParent().unit
	local min, max = xp(unit)
	local bars = unit == 'pet' and 6 or 20

	GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMRIGHT', 5, -5)
	GameTooltip:AddLine(format('XP: %d / %d (%d%% - %d bars)', min, max, min / max * 100, bars))
	GameTooltip:AddLine(format('Left: %d (%d%% - %d bars)', max - min, (max - min) / max * 100, bars * (max - min) / max))

	if(self.exhaustion) then
		GameTooltip:AddLine(format('|cff0090ffRested: +%d (%d%%)', self.exhaustion, self.exhaustion / max * 100))
	end

	GameTooltip:Show()
end

local function update(self)
	local bar, unit = self.Experience, self.unit

	local exhaustion = GetXPExhaustion()
	local min, max = xp(unit)
	bar:SetMinMaxValues(0, max)
	bar:SetValue(min)
	bar:Show()

	if(bar.Text) then
		if(bar.OverrideText) then
			bar:OverrideText(unit, min, max)
		else
			bar.Text:SetFormattedText('%d / %d', min, max)
		end
	end

	if(bar.Rested) then
		if(unit == 'player' and exhaustion and exhaustion > 0) then
			bar.Rested:SetMinMaxValues(0, max)
			bar.Rested:SetValue(math.min(min + exhaustion, max))
			bar.exhaustion = exhaustion
		else
			bar.Rested:SetMinMaxValues(0, 1)
			bar.Rested:SetValue(0)
			bar.exhaustion = nil
		end
	end

	if(bar.PostUpdate) then
		bar.PostUpdate(self, event, unit, bar, min, max)
	end
end

local function argcheck(self)
	local bar = self.Experience

	if(self.unit == 'player') then
		if(IsXPUserDisabled()) then
			self:DisableElement('Experience')
			self:RegisterEvent('ENABLE_XP_GAIN', function(self)
				self:EnableElement('Experience')
				self:UpdateElement('Experience')
			end)
		elseif(UnitLevel('player') == MAX_PLAYER_LEVEL) then
			bar:Hide()
		else
			update(self)
		end
	elseif(self.unit == 'pet') then
		if(not self.disallowVehicleSwap and UnitHasVehicleUI('player')) then
			update(self)
			bar:Hide()
		elseif(UnitExists('pet') and UnitLevel('pet') ~= UnitLevel('player') and hunter) then
			update(self)
		else
			bar:Hide()
		end
	end
end

local function petcheck(self, event, unit)
	if(unit == 'player') then
		argcheck(self)
	end
end

local function enable(self, unit)
	local bar = self.Experience

	if(bar) then
		if(not bar:GetStatusBarTexture()) then
			bar:SetStatusBarTexture([=[Interface\TargetingFrame\UI-StatusBar]=])
		end

		self:RegisterEvent('PLAYER_XP_UPDATE', argcheck)
		self:RegisterEvent('PLAYER_LEVEL_UP', argcheck)
		self:RegisterEvent('UNIT_PET', petcheck)

		if(bar.Rested) then
			self:RegisterEvent('UPDATE_EXHAUSTION', argcheck)
			bar.Rested:SetFrameLevel(1)
		end

		if(hunter) then
			self:RegisterEvent('UNIT_PET_EXPERIENCE', argcheck)
		end

		if(not self.disallowVehicleSwap) then
			self:RegisterEvent('UNIT_ENTERED_VEHICLE', argcheck)
			self:RegisterEvent('UNIT_EXITED_VEHICLE', argcheck)
		end

		if(bar.Tooltip) then
			bar:EnableMouse()
			bar:HookScript('OnLeave', GameTooltip_Hide)
			bar:HookScript('OnEnter', tooltip)
		end

		bar:HookScript('OnHide', function(self)
			if(self.Rested) then
				self.Rested:Hide()
			end
		end)

		bar:HookScript('OnShow', function(self)
			if(self.Rested) then
				self.Rested:Show()
			end
		end)

		return true
	end
end

local function disable(self)
	local bar = self.Experience
	if(bar) then
		bar:Hide()
		self:UnregisterEvent('PLAYER_XP_UPDATE', argcheck)
		self:UnregisterEvent('PLAYER_LEVEL_UP', argcheck)
		self:UnregisterEvent('UNIT_PET', petcheck)

		if(bar.Rested) then
			self:UnregisterEvent('UPDATE_EXHAUSTION', argcheck)
		end

		if(hunter) then
			self:UnregisterEvent('UNIT_PET_EXPERIENCE', argcheck)
		end

		if(not self.disallowVehicleSwap) then
			self:UnregisterEvent('UNIT_ENTERED_VEHICLE', argcheck)
			self:UnregisterEvent('UNIT_EXITED_VEHICLE', argcheck)
		end
	end
end

oUF:AddElement('Experience', argcheck, enable, disable)
