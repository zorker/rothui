--[[
	OmniCC Full
		A featureful version of OmniCC
		Cooldown text should work on absolutely everything.  Pulses will work on anything that I can determine the icon of
--]]

local SML = LibStub and LibStub('LibSharedMedia-2.0') --shared media library
local CURRENT_VERSION = GetAddOnMetadata('OmniCC', 'Version') --the addon's current version
local L = OMNICC_LOCALS --localized strings

local DAY, HOUR, MINUTE, SHORT = 86400, 3600, 60, 9 --values for time
local ICON_SIZE = 36 --the normal size of an icon
local timers = {}
local pulses = {}
local activePulses = {}

--[[
	Addon Loading
--]]

OmniCC = CreateFrame('Frame')
OmniCC:Hide()
OmniCC:SetScript('OnEvent', function(self) self:Enable() end)
OmniCC:SetScript('OnUpdate', function(self, elapsed) self:UpdateAllPulses(elapsed) end)
OmniCC:RegisterEvent('PLAYER_LOGIN')

function OmniCC:Enable()
	if not(OmniCCDB and OmniCCDB.version) then
		self:LoadDefaults()
	else
		local cMajor, cMinor = CURRENT_VERSION:match("(%d+)%.(%d+)")
		local major, minor = OmniCCDB.version:match("(%d+)%.(%d+)")

		if major ~= cMajor then
			self:LoadDefaults()
		elseif minor ~= cMinor then
			self:UpdateSettings()
		end

		if OmniCCDB.version ~= CURRENT_VERSION then
			self:UpdateVersion()
		end
	end

	self.sets = OmniCCDB

	--enable the addon
	self:HookCooldown()
	self:LoadSlashCommands()
end

function OmniCC:LoadDefaults()
	OmniCCDB = {
		font = 'Friz Quadrata TT', --what font to use
		fontOutline = 'OUTLINE', --what outline to use on fonts
		fontSize = 12, --the base font size to use at a scale of 1

		showModel = true, --show the cooldown model or not
		useMMSS = false, --use MM:SS format for cooldowns under 3 minutes
		usePulse = false, --pulse at end of cooldown

		minScale = 0.5, --the minimum scale we want to show cooldown counts at, anything below will be hidden
		minDuration = 3, --the minimum duration we want to show cooldowns for, anything below will not show a timer

		style = {
			short = {r = 1, g = 0, b = 0, s = 1.25}, -- <= 5 seconds
			secs = {r = 1, g = 1, b = 0.4, s = 1}, -- < 1 minute
			mins = {r = 0.8, g = 0.8, b = 0.9, s = 0.9}, -- >= 1 minute
			hrs = {r = 0.8, g = 0.8, b = 0.9, s = 0.8}, -- >= 1 hr
			days = {r = 0.8, g = 0.8, b = 0.9, s = 0.65}, -- >= 1 day
		},

		version = CURRENT_VERSION,
	}
end

function OmniCC:UpdateSettings()
end

function OmniCC:UpdateVersion()
	OmniCCDB.version = CURRENT_VERSION
	self:Print(L.Updated:format(OmniCCDB.version), true)
end

--hook the cooldown function (effectively enable the addon)
--we inherit CooldownFrameTemplate here to prevent a crash issue
function OmniCC:HookCooldown()
	local methods = getmetatable(CreateFrame('Cooldown', nil, nil, 'CooldownFrameTemplate')).__index
	hooksecurefunc(methods, 'SetCooldown', function(self, start, duration)
		self:SetAlpha(OmniCC.sets.showModel and 1 or 0)

		if start > 0 and duration > OmniCC.sets.minDuration then
			OmniCC:StartTimer(self, start, duration)
		else
			local timer = timers[self]
			if timer then
				timer:Hide()
			end
		end
	end)
end


--[[
	Timer Code
--]]

--shower: a frame used to properly show and hide timer text without forcing the timer to be parented to the cooldown frame (needed for hiding the cooldown frame)
local function Shower_OnShow(self)
	local timer = timers[self:GetParent()]
	if timer.wasShown then
		timer:Show()
	end
end

local function Shower_OnHide(self)
	local timer = timers[self:GetParent()]
	if timer:IsShown() then
		timer.wasShown = true
		timer:Hide()
	end
end

--timer, the frame with cooldown text
local function Timer_OnUpdate(self, elapsed)
	if self.nextUpdate <= 0 then
		OmniCC:UpdateTimer(self)
	else
		self.nextUpdate = self.nextUpdate - elapsed
	end
end

function OmniCC:StartTimer(cooldown, start, duration)
	local timer = timers[cooldown] or self:CreateTimer(cooldown)
	if timer then
		timer.start = start
		timer.duration = duration
		timer.nextUpdate = 0
		timer:Show()
	end
end

function OmniCC:CreateTimer(cooldown)
	--controls the visibility of the timer
	local shower = CreateFrame('Frame', nil, cooldown)
	shower:SetScript('OnShow', Shower_OnShow)
	shower:SetScript('OnHide', Shower_OnHide)

	local timer = CreateFrame('Frame', nil, cooldown:GetParent())
	timer:SetFrameLevel(cooldown:GetFrameLevel() + 5) --make sure the timer is on top of things like the cooldown model
	timer:SetAllPoints(cooldown)
	timer:SetToplevel(true)
	timer:Hide()
	timer:SetScript('OnUpdate', Timer_OnUpdate)

	local text = timer:CreateFontString(nil, 'OVERLAY')
	text:SetPoint('CENTER', timer, 'CENTER', 0, 1)
	timer.text = text

	-- parent icon, used for shine stuff
	local parent = cooldown:GetParent()
	if parent then
		if parent.icon then
			timer.icon = parent.icon
		else
			local name = parent:GetName()
			if name then
				timer.icon = getglobal(name .. 'Icon') or getglobal(name .. 'IconTexture')
			end
		end
	end

	timers[cooldown] = timer

	return timer
end

function OmniCC:UpdateTimer(timer)
	local rScale = timer:GetEffectiveScale() / UIParent:GetEffectiveScale()
	local iconScale = floor(timer:GetWidth() + 0.5) / ICON_SIZE --icon sizes seem to vary a little bit, so this takes care of making them round to whole numbers

	if iconScale*rScale < self:GetMinScale() or iconScale == 0 then
		timer.toNextUpdate = 1
		timer.text:Hide()
	else
		local remain = timer.duration - (GetTime() - timer.start)
		if floor(remain + 0.5) > 0 then
			local time, nextUpdate = self:GetFormattedTime(remain)
			local font, size, r, g, b, outline = self:GetFormattedFont(remain)
			local text = timer.text

			--do another check for too small fonts
			if floor(size * iconScale) > 0 then
				text:SetFont(font, size * iconScale, outline)
				text:SetText(time)
				text:SetTextColor(r, g, b)
				text:Show()
				timer.nextUpdate = nextUpdate
			else
				timer.nextUpdate = 1
			end
		else
			timer:Hide()

			if self:ShowingPulse() then
				self:StartPulse(timer)
			end
		end
	end
end

function OmniCC:UpdateAllTimers()
	for _,timer in pairs(timers) do
		timer.nextUpdate = 0
	end
end

function OmniCC:GetFormattedTime(s)
	if s >= DAY then
		return format('%dd', floor(s/DAY + 0.5)), s % DAY
	elseif s >= HOUR then
		return format('%dh', floor(s/HOUR + 0.5)), s % HOUR
	elseif s >= MINUTE then
		if s <= MINUTE*3 and self:UsingMMSS() then
			return format('%d:%02d', floor(s/60), s % MINUTE), s - floor(s)
		end
		return format('%dm', floor(s/MINUTE + 0.5)), s % MINUTE
	end
	return floor(s + 0.5), s - floor(s)
end

function OmniCC:GetFormattedFont(s)
	local style = self.sets.style
	local fontSize = self.sets.fontSize
	local outline = self.sets.fontOutline

	if s > DAY then
		style = style.days
	elseif s > HOUR then
		style = style.hrs
	elseif s > MINUTE then
		style = style.mins
	elseif s > SHORT then
		style = style.secs
	else
		style = style.short
	end
	return self:GetFont(), fontSize * style.s * 1.3, style.r, style.g, style.b, outline
end


--[[
	Pulse Code
--]]

function OmniCC:CreatePulse(parent)
	local frame = CreateFrame('Frame', nil, parent)
	frame:SetAllPoints(parent)
	frame:SetToplevel(true)

	local icon = frame:CreateTexture(nil, 'OVERLAY')
	icon:SetPoint('CENTER')
	icon:SetBlendMode('ADD')
	icon:SetHeight(frame:GetHeight())
	icon:SetWidth(frame:GetWidth())
	frame.icon = icon

	pulses[parent] = frame

	return frame
end

function OmniCC:StartPulse(timer)
	local icon = timer.icon
	local parent = timer:GetParent()

	if icon and parent:IsVisible() then
		local pulse = pulses[parent] or self:CreatePulse(parent)
		if pulse and not activePulses[pulse] then
			pulse.scale = 1
			pulse.icon:SetTexture(icon:GetTexture())

			local r, g, b = icon:GetVertexColor()
			pulse.icon:SetVertexColor(r, g, b, 0.7)
			pulse:Show()

			--enable the pulse updater
			activePulses[pulse] = true
			self:Show()
		end
	end
end

function OmniCC:UpdatePulse(pulse, elapsed)
	if pulse.scale >= 2 then
		pulse.dec = 1
	end

	pulse.scale = max(min(pulse.scale + (pulse.dec and -1 or 1) * pulse.scale * (elapsed/0.5), 2), 1)

	if pulse.scale <= 1 then
		activePulses[pulse] = nil
		pulse:Hide()
		pulse.dec = nil
	else
		pulse.icon:SetHeight(pulse:GetHeight() * pulse.scale)
		pulse.icon:SetWidth(pulse:GetWidth() * pulse.scale)
	end
end

function OmniCC:UpdateAllPulses(elapsed)
	if next(activePulses) then
		for pulse in pairs(activePulses) do
			self:UpdatePulse(pulse, elapsed)
		end
	else
		self:Hide()
	end
end

--[[
	Utility Functions
--]]

function OmniCC:Print(msg, showAddon)
	if showAddon then
		ChatFrame1:AddMessage(format('|cFF33FF99OmniCC|r: %s', tostring(msg)))
	else
		ChatFrame1:AddMessage(tostring(msg))
	end
end


--[[
	Configuration Functions
--]]

function OmniCC:SetFont(font)
	self.sets.font = font
	self:UpdateAllTimers()
end

--wrapper for shared media library
--gets the path to the font we're using
function OmniCC:GetFont()
	return SML:Fetch(SML.MediaType.FONT, self.sets.font)
end

--get the name of the font we're using
function OmniCC:GetFontName()
	return self.sets.font
end

function OmniCC:SetFontSize(fontSize)
	if fontSize then
		self.sets.fontSize = fontSize
		self:UpdateAllTimers()
	end
end

function OmniCC:GetFontSize()
	return self.sets.fontSize
end

function OmniCC:SetFontOutline(outline)
	self.sets.fontOutline = outline
	self:UpdateAllTimers()
end

function OmniCC:GetFontOutline()
	return self.sets.fontOutline
end

function OmniCC:SetDurationColor(duration, r, g, b)
	local style = self.sets.style
	if duration and style[duration] then
		style[duration].r = r
		style[duration].g = g
		style[duration].b = b
		self:UpdateAllTimers()
	end
end

function OmniCC:SetDurationScale(duration, scale)
	local style = self.sets.style
	if duration and style[duration] then
		style[duration].s = scale
		self:UpdateAllTimers()
	end
end

function OmniCC:GetDurationFormat(duration)
	local style = self.sets.style
	if duration and style[duration] then
		local style = style[duration]
		return style.r, style.g, style.b, style.s
	end
end

function OmniCC:SetMinScale(scale)
	if scale then
		self.sets.minScale = scale
		self:UpdateAllTimers()
	end
end

function OmniCC:GetMinScale()
	return self.sets.minScale
end

function OmniCC:SetMinDuration(duration)
	if duration then
		self.sets.minDuration = duration
	end
end

function OmniCC:GetMinDuration()
	return self.sets.minDuration
end

function OmniCC:SetShowPulse(enable)
	self.sets.usePulse = enable
end

function OmniCC:ShowingPulse()
	return self.sets.usePulse
end

function OmniCC:SetShowModels(enable)
	self.sets.showModel = enable
end

function OmniCC:ShowingModels()
	return self.sets.showModel
end

function OmniCC:SetUseMMSS(enable)
	self.sets.useMMSS = enable
	self:UpdateAllTimers()
end

function OmniCC:UsingMMSS()
	return self.sets.useMMSS
end


--[[ Slash Commands ]]--

function OmniCC:LoadSlashCommands()
	SlashCmdList['OmniCCCOMMAND'] = function(cmd)
		local enabled = select(4, GetAddOnInfo('OmniCC_Options'))
		if enabled then
			if OmniCCOptionsFrame then
				if OmniCCOptionsFrame:IsShown() then
					OmniCCOptionsFrame:Hide()
				else
					UIFrameFadeIn(OmniCCOptionsFrame, 0.2)
				end
			else
				LoadAddOn('OmniCC_Options')
			end
		else
			self:Print('Options menu addon not present', true)
		end
	end

	SLASH_OmniCCCOMMAND1 = '/omnicc'
	SLASH_OmniCCCOMMAND2 = '/occ'
end