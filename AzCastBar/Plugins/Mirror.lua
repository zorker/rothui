-- Icons
local AZCB_TimerIcons = {
	[0] = "Interface\\Icons\\Spell_Shadow_SoulLeech_2",
	["BREATH"] = "Interface\\Icons\\Spell_Shadow_DemonBreath",
	["FEIGNDEATH"] = "Interface\\Icons\\Ability_Rogue_FeignDeath",
};

-- Disable Blizz Mirror Bars
UIParent:UnregisterEvent("MIRROR_TIMER_START");
MirrorTimer1:UnregisterAllEvents();
MirrorTimer2:UnregisterAllEvents();
MirrorTimer3:UnregisterAllEvents();

local b;

--------------------------------------------------------------------------------------------------------
--                                           Frame Scripts                                            --
--------------------------------------------------------------------------------------------------------

local function OnUpdate(self,elapsed)
	-- Update Bar (Az: Fadeout should be called on MIRROR_TIMER_STOP, but we might need to force it here)
	if (self.fadeTime == 0) then
		self.timeProgress = (GetMirrorTimerProgress(self.timerId) / 1000);
		self.timeLeft = (self.timeProgress < 0 and 0) or (self.timeProgress < self.maxValue and self.timeProgress) or (self.maxValue);
		self.status:SetValue(self.timeLeft);
		self.right:SetText(AzCastBar_FormatTime(self.timeLeft));
		--if (self.timeLeft == 0) then
		--	self.timerId = nil;
		--	self.fadeTime = b.cfg.fadeTime;
		--end
	-- Fade
	elseif (self.fadeElapsed < self.fadeTime) then
		self.fadeElapsed = (self.fadeElapsed + arg1);
		self:SetAlpha(b.cfg.alpha - self.fadeElapsed / self.fadeTime * b.cfg.alpha);
	else
		self:Hide();
	end
end

--------------------------------------------------------------------------------------------------------
--                                           Event Handling                                           --
--------------------------------------------------------------------------------------------------------
local function OnEvent(self,event)
	-- End if not enabled
	if (not b.cfg.enabled) then
		return;
	-- Check for Timers on login
	elseif (event == "PLAYER_ENTERING_WORLD" or event == "AZCASTBAR_RESET") then
		for i = 1, 3 do
			arg1, arg2, arg3, arg4, arg5, arg6 = GetMirrorTimerInfo(i);
			if (arg1) and (arg1 ~= "UNKNOWN") then
				event = "MIRROR_TIMER_START";
				break;
			end
		end
		if (not arg1 or arg1 == "UNKNOWN") then
			return;
		end
	end

	-- End if not our timerId
	if (self.timerId) and (self.timerId ~= arg1) then
		return;
	-- Start
	elseif (event == "MIRROR_TIMER_START") then
		for i = 1, 3 do
			if (self.id ~= i) and (b.bars[i].timerId == arg1) then
				return;
			end
		end

		self.timerId = arg1;
		--self.value = arg2;
		self.maxValue = (arg3 / 1000);
		self.label = arg6;
		--self.scale = arg4;
		--self.paused = arg5;

		self.status:SetMinMaxValues(0,self.maxValue);
		self.status:SetStatusBarColor(unpack(b.cfg.colNormal));

		self.left:SetText(self.label);
		self.icon:SetTexture(AZCB_TimerIcons[self.timerId] or AZCB_TimerIcons[0]);

		self.fadeTime = 0;
		self.fadeElapsed = 0;
		self:SetAlpha(b.cfg.alpha);
		self:Show();
	-- Stop
	elseif (event == "MIRROR_TIMER_STOP") then
		if (self.timerId == arg1) and (self.fadeTime == 0) then
			self.timerId = nil;
			self.fadeTime = b.cfg.fadeTime;
		end
	end
end

--------------------------------------------------------------------------------------------------------
--                                           Event Handling                                           --
--------------------------------------------------------------------------------------------------------

do
	local bar;
	for i = 1, 3 do
		bar = AzCastBar_MakeBar();
		-- Init Bar
		bar.id = i;
		if (i == 1) then
			b = bar;
			bar.token = "Mirror";
			bar.bars = {};
			bar:SetPoint("CENTER",0,200);
			tinsert(AzCastBar_Frames,bar);
		else
			bar:SetPoint("TOP",b.bars[i - 1],"BOTTOM",0,-6);
		end
		tinsert(b.bars,bar);
		-- Events
		bar:RegisterEvent("PLAYER_ENTERING_WORLD");
		bar:RegisterEvent("MIRROR_TIMER_START");
		bar:RegisterEvent("MIRROR_TIMER_STOP");
		bar:RegisterEvent("MIRROR_TIMER_PAUSE");
		-- Specific Frame Events
		bar:SetScript("OnUpdate",OnUpdate);
		bar:SetScript("OnEvent",OnEvent);
	end
end