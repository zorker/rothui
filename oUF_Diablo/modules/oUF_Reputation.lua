local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, 'oUF Reputation was unable to locate oUF install')

for tag, func in pairs({
	['currep'] = function()
		local _, _, _, _, value = GetWatchedFactionInfo()
		return value
	end,
	['maxrep'] = function()
		local _, _, _, max = GetWatchedFactionInfo()
		return max
	end,
	['perrep'] = function()
		local _, _, _, max, value = GetWatchedFactionInfo()
		return math.floor(value / max * 100 + 0.5)
	end,
	['standing'] = function()
		local _, standing = GetWatchedFactionInfo()
		return standing
	end,
	['reputation'] = function()
		return GetWatchedFactionInfo()
	end,
}) do
	oUF.Tags[tag] = func
	oUF.TagEvents[tag] = 'UPDATE_FACTION'
end

local function Update(self, event, unit)
	local reputation = self.Reputation
	
	if(not GetWatchedFactionInfo()) then
		return reputation:Hide()
	else
		reputation:Show()
	end

	local name, standing, min, max, value = GetWatchedFactionInfo()
	reputation:SetMinMaxValues(min, max)
	reputation:SetValue(value)

	if(reputation.PostUpdate) then
		return reputation:PostUpdate(unit, name, standing, min, max, value)
	end
end

local function Path(self, ...)
	return (self.Reputation.Override or Update) (self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local function Enable(self, unit)
	local reputation = self.Reputation
	if(reputation) then
		reputation.__owner = self
		reputation.ForceUpdate = ForceUpdate

		self:RegisterEvent('UPDATE_FACTION', Path)

		if(not reputation:GetStatusBarTexture()) then
			reputation:SetStatusBarTexture([=[Interface\TargetingFrame\UI-StatusBar]=])
		end

		return true
	end
end

local function Disable(self)
	if(self.Reputation) then
		self:UnregisterEvent('UPDATE_FACTION', Path)
	end
end

oUF:AddElement('Reputation', Path, Enable, Disable)
