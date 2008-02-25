-- Disable Blizz Casting Bars
CastingBarFrame.showCastbar = nil;
CastingBarFrame:UnregisterAllEvents();
PetCastingBarFrame.showCastbar = nil;
PetCastingBarFrame:UnregisterAllEvents();

-- Start Frame FadeOut
local function StartFadeOut(bar)
	if (bar.fadeTime == 0) then
		if (bar.safezone) then
			bar.safezone:Hide();
		end
		bar.fadeTime = bar.cfg.fadeTime;
	end
end

--------------------------------------------------------------------------------------------------------
--                                              OnUpdate                                              --
--------------------------------------------------------------------------------------------------------

local function OnUpdate(self,elapsed)
	-- Update Bar (Only player unit seems to give proper UNIT_SPELLCAST_STOP event, so start fadeout when cast completes)
	if (self.fadeTime == 0) then
		self.timeProgress = (GetTime() - self.startTime);
		if (self.timeProgress > self.castTime) then
			self.timeProgress = self.castTime;
		end
		self.timeLeft = (self.castTime - self.timeProgress);
		self.delayText = (self.castDelay == 0 and "" or ("|cffff8080"..(self.castDelay > 0 and "+" or "")..AzCastBar_FormatTime(self.castDelay).."|r  "));

		self.status:SetValue(self.isCast and self.timeProgress or self.timeLeft);
		self.right:SetText(self.delayText..AzCastBar_FormatTime(self.timeLeft));

		if (self.safezone) and (self.safezone:IsVisible()) then
			self.safeZonePercent = (select(3,GetNetStats()) / 1000 / self.castTime * self.status:GetWidth());
			self.safezone:SetWidth(self.safeZonePercent <= 100 and self.safeZonePercent or 100);
		end

		if (self.timeLeft == 0) then
			StartFadeOut(self);
		end
	-- Fade
	elseif (self.fadeElapsed <= self.fadeTime) then
		self.fadeElapsed = (self.fadeElapsed + elapsed);
		self:SetAlpha(self.cfg.alpha - self.fadeElapsed / self.fadeTime * self.cfg.alpha);
	else
		self.isCast, self.isChannel = nil, nil;
		self:Hide();
	end
end
--------------------------------------------------------------------------------------------------------
--                                           Event Handling                                           --
--------------------------------------------------------------------------------------------------------
local function OnEvent(self,event)
	-- End if not enabled
	if (not self.cfg or not self.cfg.enabled) then
		return;
	-- Entering World + Target/Focus Change
	elseif (event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_TARGET_CHANGED" or event == "PLAYER_FOCUS_CHANGED" or event == "AZCASTBAR_RESET") then
		if (UnitCastingInfo(self.unit)) then
			event = "UNIT_SPELLCAST_START";
			arg1 = self.unit;
		elseif (UnitChannelInfo(self.unit)) then
			event = "UNIT_SPELLCAST_CHANNEL_START";
			arg1 = self.unit;
		else
			self:Hide();
			return;
		end
	end

	-- Check Unit
	if (self.unit ~= arg1) then
		return;
	-- Hide the CastBar if another bar handles this cast (Player > Target > Focus)
	elseif (self.unit ~= "player" and UnitIsUnit(self.unit,"player")) or (self.unit == "focus" and UnitIsUnit("focus","target")) then
		self:Hide();
		return;
	-- Start
	elseif (event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_CHANNEL_START") then
		self.isCast = (event == "UNIT_SPELLCAST_START");
		self.isChannel = (event == "UNIT_SPELLCAST_CHANNEL_START");

		if (self.isCast) then
			self.spell, self.rank, self.label, self.iconPath, self.startTime, self.endTime = UnitCastingInfo(self.unit);
		else
			self.spell, self.rank, self.label, self.iconPath, self.startTime, self.endTime = UnitChannelInfo(self.unit);
		end

		self.startTime, self.endTime = (self.startTime / 1000), (self.endTime / 1000);
		self.castTime = (self.endTime - self.startTime);

		if (self.unit == "player") then
			if (self.spell == "Hearthstone") and (GetBindLocation()) then
				self.rank = GetBindLocation();
			end
			if (self.cfg.safeZone) and (self.isCast) then
				self.safezone:Show();
			end
		end

		self.status:SetMinMaxValues(0,self.castTime);
		self.status:SetStatusBarColor(unpack(self.cfg.colNormal));
		self.left:SetText(self.cfg.showRank and self.rank ~= "" and self.spell.." ("..self.rank..")" or self.spell);
		self.icon:SetTexture(self.iconPath);

		self.fadeTime = 0;
		self.fadeElapsed = 0;
		self.castDelay = 0;
		self:SetAlpha(self.cfg.alpha);
		self:Show();
	-- Quit if Hidden
	elseif (not self:IsVisible()) then
		return;
	-- Failed (Happens after UNIT_SPELLCAST_STOP, so keep them here)
	elseif (event == "UNIT_SPELLCAST_FAILED") and (not self.isChannel) then
		self.status:SetValue(self.castTime);
		self.status:SetStatusBarColor(unpack(self.cfg.colFailed));
		self.right:SetText("Failed");
		StartFadeOut(self);
	-- Interrupted (Happens after UNIT_SPELLCAST_STOP, so keep them here)
	elseif (event == "UNIT_SPELLCAST_INTERRUPTED") and (not self.isChannel) then
		self.status:SetValue(self.castTime);
		self.status:SetStatusBarColor(unpack(self.cfg.colInterrupt));
		self.right:SetText("Interrupted");
		StartFadeOut(self);
	-- Quit here if no cast or channel is in progress
	elseif (self.fadeTime ~= 0) then
		return;
	-- Stop (Happens even with instant spells & abilities) (UNIT_SPELLCAST_STOP gets called right after UNIT_SPELLCAST_CHANNEL_START for some reason) (Doesn't always seem to trigger when target or focus completes cast)
	elseif (event == "UNIT_SPELLCAST_STOP" and self.isCast) or (event == "UNIT_SPELLCAST_CHANNEL_STOP" and self.isChannel) then
		self.status:SetValue(self.isCast and self.castTime or 0);
		StartFadeOut(self);
	-- Cast Delayed (Az: Debug code here)
	elseif (event == "UNIT_SPELLCAST_DELAYED" or event == "UNIT_SPELLCAST_CHANNEL_UPDATE") then
		local startTimeNew, endTimeNew;
		if (event == "UNIT_SPELLCAST_DELAYED") then
			startTimeNew, endTimeNew = select(5,UnitCastingInfo(self.unit));
		else
			startTimeNew, endTimeNew = select(5,UnitChannelInfo(self.unit));
		end
		if (startTimeNew and endTimeNew) then
			local endTimeOld = self.endTime;
			self.startTime, self.endTime = (startTimeNew / 1000), (endTimeNew / 1000);
			self.castDelay = (self.castDelay + self.endTime - endTimeOld);
		else
			AzMsg("--- |2"..event.." are NIL|r ---");
			AzMsg("startTime = |1"..tostring(startTimeNew).."|r, endTime = |1"..tostring(endTimeNew).."|r.");
		end
	end
end

--------------------------------------------------------------------------------------------------------
--                                              Setup Bar                                             --
--------------------------------------------------------------------------------------------------------

do
	local bars = { "player", "target", "focus", "pet" };
	local bar, lastBar;
	for _, token in ipairs(bars) do
		bar = AzCastBar_MakeBar();
		-- Init Bar
		bar.token = token:gsub("^(.)",strupper);
		bar.unit = token;
		tinsert(AzCastBar_Frames,bar);
		-- Anchor
		if (lastBar) then
			bar:SetPoint("TOP",lastBar,"BOTTOM",0,-8);
		else
			bar:SetPoint("CENTER",0,-100);
		end
		lastBar = bar;
		-- Events
		bar:RegisterEvent("PLAYER_ENTERING_WORLD");
		bar:RegisterEvent("UNIT_SPELLCAST_START");
		bar:RegisterEvent("UNIT_SPELLCAST_STOP");
		bar:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED");
		bar:RegisterEvent("UNIT_SPELLCAST_FAILED");
		bar:RegisterEvent("UNIT_SPELLCAST_DELAYED");
		bar:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START");
		bar:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE");
		bar:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP");
		bar:SetScript("OnUpdate",OnUpdate);
		bar:SetScript("OnEvent",OnEvent);
		-- Specific Frame Stuff
		if (token == "player") then
			bar.safezone = bar.status:CreateTexture(nil,"ARTWORK");
			bar.safezone:SetTexture(0.3,0.8,0.3,0.6);
			bar.safezone:SetPoint("TOPRIGHT");
			bar.safezone:SetPoint("BOTTOMRIGHT");
			bar.safezone:Hide();
		elseif (token == "target") then
			bar:RegisterEvent("PLAYER_TARGET_CHANGED");
		elseif (token == "focus") then
			bar:RegisterEvent("PLAYER_TARGET_CHANGED");
			bar:RegisterEvent("PLAYER_FOCUS_CHANGED");
		end
	end
end