local _G = getfenv(0);

-- Bars
AzCastBar_Frames = {};

-- Saved Variables
AzCastBar_Config = {};
local cfg;

-- Default Config
local AZCB_DefOptions = {
	enabled = true,
	showIcon = true,
	texture = "Interface\\Addons\\rTextures\\statusbar",
	width = 300,
	height = 20,

	fontFace = "Fonts\\FRIZQT__.TTF",
	fontFlags = "",
	fontSize = 12,

	alpha = 1,
	fadeTime = 0.6,
	backdropBG = "Interface\\Tooltips\\UI-Tooltip-Background",
	backdropIndent = -3,

	colBackdrop = { 0.1, 0.22, 0.35, 1.0 },
	colBackground = { 1.0, 1.0, 1.0, 1.0 },
	colFont = { 1.0, 1.0, 1.0, 1.0 },
	colNormal = { 0.4, 0.6, 0.8, 1.0 },
};

-- Init Specific Mod Vars
local modName = "AzCastBar";
local modVers = GetAddOnMetadata(modName,"Version");

--------------------------------------------------------------------------------------------------------
--                                          OnLoad & OnEvent                                          --
--------------------------------------------------------------------------------------------------------

-- Modify All CastBars to fit the Users Settings on "VARIABLES_LOADED"
local function OnEvent(self,event)
	cfg = AzCastBar_Config;
	AzCastBar_CheckSettings();
	AzCastBar_ApplyAllSettings();
end

local f = CreateFrame("Frame",nil);
f:SetScript("OnEvent",OnEvent);
f:RegisterEvent("VARIABLES_LOADED");

--------------------------------------------------------------------------------------------------------
--                                           Slash Handling                                           --
--------------------------------------------------------------------------------------------------------
_G["SLASH_"..modName.."1"] = "/acb";
SlashCmdList[modName] = function(cmd)
	-- Extract Parameters
	local param1, param2 = cmd:match("^([^%s]+)%s*(.*)$");
	param1 = (param1 and param1:lower() or cmd:lower());
	-- Options
	if (param1 == "") then
		local loaded, reason = LoadAddOn("AzCastBarOptions");
		if (loaded) and (#AzCastBar_Frames > 0) then
			if (AzCastBarOptions:IsVisible()) then
				AzCastBarOptions:Hide();
			else
				AzCastBarOptions:Show();
			end
		else
			AzMsg("Could not open AzCastBar Options: |1"..tostring(reason).."|r. Please make sure the addon is enabled from the character selection screen.");
		end
	-- Invalid or No Command
	else
		UpdateAddOnMemoryUsage();
		AzMsg("----- |2"..modName.."|r |1"..modVers.."|r ----- |1"..format("%.2f",GetAddOnMemoryUsage(modName)).." |2kb|r -----");
		AzMsg("The following |2parameters|r are valid for |2/acb|r...");
	end
end

--------------------------------------------------------------------------------------------------------
--                                Global Chat Message Function (Rev 3)                                --
--------------------------------------------------------------------------------------------------------
if (not AZMSG_REV or AZMSG_REV < 3) then
	AZMSG_REV = 3;
	function AzMsg(text)
		DEFAULT_CHAT_FRAME:AddMessage(tostring(text):gsub("|1","|cffffff80"):gsub("|2","|cffffffff"),128/255,192/255,255/255);
	end
end
--------------------------------------------------------------------------------------------------------
--                                           Apply Settings                                           --
--------------------------------------------------------------------------------------------------------

-- Checks if the settings exists and are correct
function AzCastBar_CheckSettings()
	-- Check if each frame has settings, reset to default if they do not
	local cfgEntry;
	for _, frame in ipairs(AzCastBar_Frames) do
		if (not cfg[frame.token]) then
			cfg[frame.token] = {};
		end
		cfgEntry = cfg[frame.token];
		-- Get positioning from current
		if (cfgEntry.left == nil) then
			cfgEntry.left = frame:GetLeft();
		end
		if (cfgEntry.bottom == nil) then
			cfgEntry.bottom = frame:GetBottom();
		end
		-- CastBar Specifics Defaults
		if (frame.token == "Player" or frame.token == "Target" or frame.token == "Focus" or frame.token == "Pet") then
			if (frame.token == "Player") then
				if (cfgEntry.safeZone == nil) then
					cfgEntry.safeZone = true;
				end
				if (cfgEntry.colSafezone == nil) then
					cfgEntry.colSafezone = {0.3,0.8,0.3,0.6};
				end
			end
			if (cfgEntry.colFailed == nil) then
				cfgEntry.colFailed = { 1.0, 0.5, 0.5, 1.0 };
			end
			if (cfgEntry.colInterrupt == nil) then
				cfgEntry.colInterrupt = { 1.0, 0.75, 0.5, 1.0 };
			end
			if (cfgEntry.showRank == nil) then
				cfgEntry.showRank = true;
			end
		end
		-- Options with constant defaults
		for optionName, defOption in pairs(AZCB_DefOptions) do
			if (cfgEntry[optionName] == nil) then
				cfgEntry[optionName] = defOption;
			end
		end
	end
end

-- Apply Settings to All Bars
function AzCastBar_ApplyAllSettings()
	for _, frame in ipairs(AzCastBar_Frames) do
		AzCastBar_ApplyBarSettings(frame);
	end
end

-- Apply Settings to Given Bar and all its subbars
function AzCastBar_ApplyBarSettings(frame)
	if (frame.bars) and (#frame.bars > 1) then
		for i = 1, #frame.bars do
			AzCastBar_ApplyBarSettingsSpecific(frame,i);
		end
	else
		AzCastBar_ApplyBarSettingsSpecific(frame);
	end
end

-- Apply Settings to Given Bar
function AzCastBar_ApplyBarSettingsSpecific(baseFrame,id)
	local cfgEntry = cfg[baseFrame.token];
	local frame = (not id or id == 1) and (baseFrame) or (baseFrame.bars[id]);
	-- Main Bar Changes Only (Give the Frame a Pointer to it's own Config table + Position)
	if (not id or id == 1) then
		frame.cfg = cfgEntry;
		frame:ClearAllPoints();
		frame:SetPoint("BOTTOMLEFT",UIParent,"BOTTOMLEFT",cfgEntry.left,cfgEntry.bottom);
	end
	-- Width + Height
	frame:SetWidth(cfgEntry.width);
	frame:SetHeight(cfgEntry.height);
	-- Icon
	if (frame.icon) then
		if (cfgEntry.showIcon) then
			frame.status:SetPoint("TOPLEFT",frame.icon,"TOPRIGHT",3,0);
			frame.icon:Show();
		else
			frame.status:SetPoint("TOPLEFT");
			frame.icon:Hide();
		end
		frame.icon:SetWidth(cfgEntry.height);
	end
	-- Font Size
	frame.left:SetFont(cfgEntry.fontFace,cfgEntry.fontSize,cfgEntry.fontFlags);
	frame.right:SetFont(cfgEntry.fontFace,cfgEntry.fontSize,cfgEntry.fontFlags);
	-- Alpha
	frame:SetAlpha(cfgEntry.alpha);
	-- Outline
	frame:SetBackdrop({ bgFile = cfgEntry.backdropBG, insets = { left = cfgEntry.backdropIndent, right = cfgEntry.backdropIndent, top = cfgEntry.backdropIndent, bottom = cfgEntry.backdropIndent } });
	-- Texture
	frame.texture:SetTexture(cfgEntry.texture);
	-- Colors
	frame:SetBackdropColor(unpack(cfgEntry.colBackdrop));
	frame.background:SetTexture(cfgEntry.texture);
	frame.background:SetVertexColor(1,1,1,0.3);
	frame.status:SetStatusBarColor(unpack(cfgEntry.colNormal));
	frame.right:SetTextColor(unpack(cfgEntry.colFont));
	frame.left:SetTextColor(unpack(cfgEntry.colFont));
	if (frame.safezone) then
  	frame.safezone:SetTexture(cfgEntry.texture);
  	frame.safezone:SetVertexColor(1,0,0,0.7);
	end
	-- Call the OnConfigChanged func
	if (baseFrame.OnConfigChanged) then
		baseFrame.OnConfigChanged();
	end
end

--------------------------------------------------------------------------------------------------------
--                                                Misc                                                --
--------------------------------------------------------------------------------------------------------

-- Format time as it is shown on the CastBar
function AzCastBar_FormatTime(sec)
	if (sec <= 60) then
		return ("%.1f"):format(sec);
	else
		return ("%d:%.2d"):format(sec/60,mod(sec,60));
	end
end

function AzCastBar_MakeBar()
	local f = CreateFrame("Frame",nil,UIParent);
	f:SetWidth(300);
	f:SetHeight(20);
	f:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", insets = { left = -3, right = -3, top = -3, bottom = -3 } });
	f:EnableMouse(0);
	f:SetToplevel(1);
	f:Hide();

	f.icon = f:CreateTexture(nil,"ARTWORK");
	f.icon:SetWidth(18);
	f.icon:SetHeight(1);
	f.icon:SetPoint("TOPLEFT");
	f.icon:SetPoint("BOTTOMLEFT");
	f.icon:SetTexture("Interface\\Icons\\Spell_Nature_UnrelentingStorm");
	f.icon:SetTexCoord(0.1,0.9,0.1,0.9);

	f.status = CreateFrame("StatusBar",nil,f);
	f.status:SetPoint("TOPLEFT",f.icon,"TOPRIGHT",3,0);
	f.status:SetPoint("BOTTOMRIGHT");
	f.status:SetStatusBarColor(0.5,0.75,1,1);

	f.texture = f.status:CreateTexture();
	f.texture:SetPoint("TOPLEFT");
	f.texture:SetPoint("BOTTOMRIGHT");
	f.texture:SetTexture("Interface\\TargetingFrame\\UI-StatusBar");
	f.texture:SetVertexColor(0.5,0.75,1,1);

	f.status:SetStatusBarTexture(f.texture);

	f.background = f.status:CreateTexture(nil,"BACKGROUND");
	--f.background:SetTexture("Interface\\TargetingFrame\\UI-StatusBar");
	f.background:SetTexture(0.3,0.3,0.3,0.3);
	f.background:SetPoint("TOPLEFT");
	f.background:SetPoint("BOTTOMRIGHT");

	f.right = f.status:CreateFontString(nil,"ARTWORK","GameFontHighlight");
	f.right:SetPoint("RIGHT",-4,0);

	f.left = f.status:CreateFontString(nil,"ARTWORK","GameFontHighlight");
	f.left:SetJustifyH("LEFT");
	f.left:SetPoint("LEFT",4,0);
	f.left:SetPoint("RIGHT",f.right,"LEFT");

	return f;
end