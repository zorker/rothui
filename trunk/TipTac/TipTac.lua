local _G = getfenv(0);

local modName = "TipTac";

-- Config Data Variables
TipTac_Config = {};
local cfg;

local TT_DefaultConfig = {
	showUnitTip = true,
	hookTips = true,
	updateFreq = 0.5,
	showStatus = true,
	pvpName = true,
	showRealm = "show",
	showTarget = "second",
	showTargetedBy = true,
	showTalents = false,

	tipBackdropBG = "Interface\\Tooltips\\UI-Tooltip-Background",
	tipBackdropEdge = "Interface\\Tooltips\\UI-Tooltip-Border",
	tipTacColor = { 0.1, 0.1, 0.2, 1.0 },
	tipTacBorderColor = { 0.3, 0.3, 0.4, 1.0 },
	tipColor = { 0.1, 0.1, 0.2, 1.0 },
	tipBorderColor = { 0.3, 0.3, 0.4, 1.0 },

	reactText = false,
	colReactText1 = "|cffc0c0c0",
	colReactText2 = "|cffff0000",
	colReactText3 = "|cffff7f00",
	colReactText4 = "|cffffff00",
	colReactText5 = "|cff00ff00",
	colReactText6 = "|cff25c1eb",
	colReactText7 = "|cff808080",

	reactColoredBackdrop = false,
	colReactBack1 = { 0.2, 0.2, 0.2, 1 },
	colReactBack2 = { 0.3, 0, 0, 1 },
	colReactBack3 = { 0.3, 0.15, 0, 1 },
	colReactBack4 = { 0.3, 0.3, 0, 1 },
	colReactBack5 = { 0, 0.3, 0.1, 1 },
	colReactBack6 = { 0, 0, 0.5, 1 },
	colReactBack7 = { 0.05, 0.05, 0.05, 1 },

	colSameGuild = "|cffff32ff",
	colRace = "|cffffffff",
	colLevel = "|cffc0c0c0",

	colorNameByClass = false,
	classColoredBorder = false,

	modifyFonts = false,
	fontFace = "Fonts\\FRIZQT__.TTF",
	fontSize = 12;
	fontFlags = "",

	tipScale = 1,
	gttScale = 1,

	preFadeTime = 0.6,
	fadeTime = 0.6,

	healthBar = true,
	healthBarClassColor = true,
	healthBarText = "value",
	healthBarColor = { 0.3, 0.9, 0.3, 1 },
	manaBar = false,
	manaBarText = "value",
	manaBarColor = { 0.3, 0.55, 0.9, 1 },
	powerBar = false,
	powerBarText = "value",

	barFontFace = "Fonts\\FRIZQT__.TTF",
	barFontSize = 12,
	barFontFlags = "OUTLINE",
	barHeight = 6,
	barTexture = "Interface\\AddOns\\rTextures\\statusbar",

	showBuffs = true,
	selfBuffsOnly = false,
	showDebuffs = true,
	selfDebuffsOnly = false,
	auraSize = 18,
	auraMaxRows = 2,
	showAuraCooldown = true,

	hideTipsInCombat = false,
	anchorType = "normal",
	anchorPoint = "BOTTOMRIGHT",
	anchorTypeUnit = "normal",
	anchorPointUnit = "BOTTOMRIGHT",
	mouseOffsetX = 0,
	mouseOffsetY = 0,
};

-- Tips modified by TipTac in appearance and scale (You can add to this list if you want to modify more tips)
local TT_TipsToModify = {
	"GameTooltip",
	"ShoppingTooltip1",
	"ShoppingTooltip2",
	"ItemRefTooltip",
	"WorldMapTooltip",
	"AtlasLootTooltip",
};

local tipBackdrop = { bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 8, edgeSize = 16, insets = { left = 4, right = 4, top = 4, bottom = 4 } };

-- "Constants"
local TT_LevelMatch = "^"..TOOLTIP_UNIT_LEVEL:gsub("%%s",".+"); -- Az: Used to match "^"..LEVEL.." .+"
local TT_NotSpecified = "Not specified";
local TT_Classification = {
	["normal"] = "%s",
	["elite"] = "%s+",
	["worldboss"] = "%sb++",
	["rare"] = "%sr",
	["rareelite"] = "%sr+",
};
local TT_Reaction = {
	"Tapped",
	"Hostile",
	"Caution",
	"Neutral",
	"Friendly",
	"Friendly",
	"Dead",
};

-- Colors
local TT_WHITE = "|cffffffff";
local TT_LIGHTGRAY = "|cffc0c0c0";

local TT_ClassColors = {};
for class, color in pairs(RAID_CLASS_COLORS) do
	TT_ClassColors[class] = ("|cff%.2x%.2x%.2x"):format(color.r*255,color.g*255,color.b*255);
end

-- Data Variables (u = unit, e = extras, player = player)
local u, e, player = {}, {};
local auras = {};
TipTac = {};

--------------------------------------------------------------------------------------------------------
--                                           Frame Creation                                           --
--------------------------------------------------------------------------------------------------------

local a = CreateFrame("Frame","TipTacAnchor",UIParent);
a:SetWidth(112);
a:SetHeight(22);
a:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 8, edgeSize = 12, insets = { left = 2, right = 2, top = 2, bottom = 2 } });
a:SetBackdropColor(0.1,0.1,0.2,1);
a:SetBackdropBorderColor(0.1,0.1,0.1,1);
a:SetMovable(1);
a:EnableMouse(1);
a:SetToplevel(1);
a:SetClampedToScreen(1);
a:SetPoint("CENTER");
a:Hide();

a.text = a:CreateFontString(nil,"ARTWORK","GameFontHighlight");
a.text:SetText("TipTacAnchor");
a.text:SetPoint("LEFT",5,0);

a.close = CreateFrame("Button",nil,a,"UIPanelCloseButton");
a.close:SetWidth(24);
a.close:SetHeight(24);
a.close:SetPoint("RIGHT");

--------------------------------------------------------------------------------------------------------
--                                            Frame Scripts                                           --
--------------------------------------------------------------------------------------------------------

-- Events
local function OnEvent(self,event,...)
	-- Player Level Up
	if (event == "PLAYER_LEVEL_UP") then
		player.level = arg1;
	-- Player Login
	elseif (event == "PLAYER_LOGIN") then
		player = { name = UnitName("player"), level = UnitLevel("player") };
	-- Variables Loaded
	elseif (event == "VARIABLES_LOADED") then
		cfg = TipTac_Config;
		TipTac:CheckSettings();
		TipTac:ApplySettings();
		TipTac:HookTips();
		if (cfg.left and cfg.top) then
			a:ClearAllPoints();
			a:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",cfg.left,cfg.top);
		end
	-- Talents
	elseif (event == "INSPECT_TALENT_READY") then
		a:UnregisterEvent("INSPECT_TALENT_READY");
		u.talents = select(3,GetTalentTabInfo(1,true)).."/"..select(3,GetTalentTabInfo(2,true)).."/"..select(3,GetTalentTabInfo(3,true));
	end
end

-- Anchor OnMouseUp
local function OnMouseUp()
	a:StopMovingOrSizing();
	cfg.left = a:GetLeft();
	cfg.top = a:GetTop();
end

a:SetScript("OnMouseDown",function() a:StartMoving() end);
a:SetScript("OnMouseUp",OnMouseUp);
a:SetScript("OnEvent",OnEvent);

a:RegisterEvent("PLAYER_LOGIN");
a:RegisterEvent("PLAYER_LEVEL_UP");
a:RegisterEvent("VARIABLES_LOADED");

--------------------------------------------------------------------------------------------------------
--                                           Slash Handling                                           --
--------------------------------------------------------------------------------------------------------
_G["SLASH_"..modName.."1"] = "/tiptac";
_G["SLASH_"..modName.."2"] = "/tip";
SlashCmdList[modName] = function(cmd)
	-- Extract Parameters
	local param1, param2 = cmd:match("^([^%s]+)%s*(.*)$");
	param1 = (param1 and param1:lower() or cmd:lower());
	-- Options
	if (param1 == "") then
		local loaded, reason = LoadAddOn("TipTacOptions");
		if (loaded) then
			if (TipTacOptions:IsShown()) then
				TipTacOptions:Hide();
			else
				TipTacOptions:Show();
			end
		else
			AzMsg("Could not open TicTac Options: |1"..tostring(reason).."|r. Please make sure the addon is enabled from the character selection screen.");
		end
	-- Show Anchor
	elseif (param1 == "anchor") then
		a:Show();
	-- DEBUG: GTT
	elseif (param1 == "gtt") then
		if (GameTooltip:NumLines() == 0) then
			AzMsg("GameTooltip has 0 lines.");
		else
			for i = 1, GameTooltip:NumLines() do
				AzMsg("|2"..i.."|r = |1"..(_G["GameTooltipTextLeft"..i]:GetText() or "").."   |2"..(_G["GameTooltipTextRight"..i]:GetText() or ""));
			end
		end
	-- Invalid or No Command
	else
		UpdateAddOnMemoryUsage();
		AzMsg("----- |2"..modName.."|r |1"..GetAddOnMetadata(modName,"Version").."|r ----- |1"..format("%.2f",GetAddOnMemoryUsage(modName)).." |2kb|r -----");
		AzMsg("The following |2parameters|r are valid for |2/tiptac|r or |2/tip|r:");
		AzMsg(" |2anchor|r = Shows the anchor where the tooltip appears");
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
--                                              TipTacTip                                             --
--------------------------------------------------------------------------------------------------------

local t = CreateFrame("GameTooltip","TipTacTip",UIParent,"GameTooltipTemplate");
t.fadeTime = -1;
t.lastUpdate = 0;

-- Tip OnUpdate
local function TipTacTip_OnUpdate(self,elapsed)
	self.lastUpdate = (self.lastUpdate + elapsed);
	-- Reposition Tip if Mouse Anchor is enabled
	if (cfg.anchorTypeUnit == "mouse") then
		TipTac:AnchorFrameToMouse(self);
	end
	-- Fade Out
	if (self.fadeTime ~= -1) then
		if (GameTooltip:IsVisible() or self.lastUpdate > self.fadeTime + cfg.preFadeTime) then
			self:Hide();
		elseif (self.lastUpdate > cfg.preFadeTime) then
			self:SetAlpha(1 - (self.lastUpdate - cfg.preFadeTime) / self.fadeTime);
		end
	-- Hide Tip if unit is no more, hide GTT only if it is not showing anything new. This seems like a messy way, but don't know of any better.
	-- The GTT:GetUnit() evaluation in the end, is to avoid hiding the GTT when you move to a unitframe which does not call GTT:SetUnit(), but instead uses a custom tip.
	elseif (not UnitIsUnit(u.token,"mouseover") or not GameTooltip:GetUnit() or GameTooltip:GetUnit() ~= UnitName(u.token)) then
		if (not GameTooltip:IsVisible() or GameTooltipTextLeft1:GetText() == u.gttName) then
			self.lastUpdate = 0;
			self.fadeTime = cfg.fadeTime;
			GameTooltip:Hide();
		else
			self:Hide();
		end
	-- Update Tip
	-- Az: Updating the GTT makes TipTac update extras like Beast Lore without moving the mouse off and on, more cpu used I guess?
	-- Although this sounds good, MobInfo2 seems to update the GTT in another way, so updating the tooltip with GTT:SetUnit() will not work
	-- as it clears the lines MobInfo2 added, and it doesn't seem to add extra lines by hooking GTT.OnTooltipSetUnit() or GTT:SetUnit()
	elseif (cfg.updateFreq > 0) and (self.lastUpdate > cfg.updateFreq) then
		self.lastUpdate = 0;
		--GameTooltip:SetUnit(u.token);
		TipTac:ShowUnit(u.token);
	end

	-- Sometimes the GTT changes, that causes its Show() to be called and reset Alpha to 1, if that happens, force it back to 0 here
	-- But only do so if TheTipTacTip didn't get hidden, meaning: the GTT aren't showing some other tip now.
	if (GameTooltip:GetAlpha() ~= 0 and self:IsVisible()) then
		GameTooltip:SetAlpha(0);
	end
end

t:SetScript("OnUpdate",TipTacTip_OnUpdate);
t:SetScript("OnHide",nil);

--------------------------------------------------------------------------------------------------------
--                                              GTT Hooks                                             --
--------------------------------------------------------------------------------------------------------

-- Az: This is apparently the order at which the GTT construsts the tip
-- GameTooltip_SetDefaultAnchor()
-- InternalGTTFuntionToFillTip() -- GTT:GetUnit() becomes valid after this!
-- GTT:Show()
-- GTT.OnTooltipSetUnit()

-- HOOK: GameTooltip_SetDefaultAnchor (For Re-Anchoring)
function GameTooltip_SetDefaultAnchor(tooltip,parent)
	-- Return if no tooltip or parent
	if (not tooltip or not parent) then
		return;
	end
	-- Get Anchor Settings
	-- Az: This isn't really working, as GameTooltip:GetUnit() would just return nil here for the GTT because this happens before the unit is actually set.
	--     As a temp fix I have made showingUnit also be determined if mouseover unit exists. Don't like it though :/
	local showingUnit = GameTooltip:GetUnit() or UnitExists("mouseover");
	local type = (showingUnit and cfg.anchorTypeUnit or cfg.anchorType);
	local point = (showingUnit and cfg.anchorPointUnit or cfg.anchorPoint);
	-- Position Tip to Normal, Mouse or Smart anchor
	if (type == "mouse") then
		tooltip:SetOwner(parent,"ANCHOR_NONE");
		TipTac:AnchorFrameToMouse(tooltip);
	elseif (type == "smart") and (parent ~= UIParent) then
		tooltip:SetOwner(parent,"ANCHOR_RIGHT",cfg.mouseOffsetX,cfg.mouseOffsetY);
	else
		tooltip:SetOwner(parent,"ANCHOR_NONE");
		tooltip:SetPoint(point,a);
	end
	tooltip.default = 1;
end

-- HOOK: This is the function that determines the GTT color for the first line for a unit
local Real_GameTooltip_UnitColor = GameTooltip_UnitColor;
function GameTooltip_UnitColor(unit,...)
	if (not cfg.showUnitTip) and (cfg.colorNameByClass) and (UnitIsPlayer(unit)) then
		local color = RAID_CLASS_COLORS[select(2,UnitClass(unit))];
		return color.r, color.g, color.b;
	else
		return Real_GameTooltip_UnitColor(unit,...);
	end
end

-- HOOK: GTT OnTooltipSetUnit
GameTooltip:HookScript("OnTooltipSetUnit",
function(self)
	if (cfg.hideTipsInCombat) and (UnitAffectingCombat("player")) and (GameTooltip:GetOwner():GetName() ~= "UIParent") then
		GameTooltip:Hide();
	elseif (cfg.showUnitTip) then
		TipTac:ShowUnit(select(2,self:GetUnit()),1);
	end
end
);

-- HOOK: GTT OnUpdate
GameTooltip:HookScript("OnUpdate",
function(self,elapsed)
	if (self:GetAlpha() ~= 0) and (self:GetAnchorType() ~= "ANCHOR_CURSOR") then
		if (GameTooltip:GetUnit() and cfg.anchorTypeUnit == "mouse") or (cfg.anchorType == "mouse") then
			TipTac:AnchorFrameToMouse(self);
		end
	end
end
);

-- New Tip OnShow
local function TipsOnShow(self,...)
	if (self.OnShow_TipTac) then
		self.OnShow_TipTac(...);
	end

	local unit = select(2,self:GetUnit());
	if (unit) and (UnitIsPlayer(unit)) and (cfg.classColoredBorder) then
		local color = RAID_CLASS_COLORS[select(2,UnitClass(unit))];
		self:SetBackdropBorderColor(color.r,color.g,color.b,1);
	else
		self:SetBackdropBorderColor(unpack(cfg.tipBorderColor)); -- Def: (1,1,1,1)
	end
	self:SetBackdropColor(unpack(cfg.tipColor)); -- Def: For most: (0.1,0.1,0.2), for world objects?: (0,0.2,0.35)
end

-- Function to loop through tips to modify and hook
function TipTac:HookTips()
	if (cfg.hookTips) then
		for _, tip in ipairs(TT_TipsToModify) do
			tip = _G[tip];
			if (type(tip) == "table") then
				-- Change Backdrop of the tip
				tip:SetBackdrop(tipBackdrop);
				-- HOOK: Tip OnShow
				tip.OnShow_TipTac = tip:GetScript("OnShow");
				tip:SetScript("OnShow",TipsOnShow);
			end
		end
	end
end

--------------------------------------------------------------------------------------------------------
--                                       Add Unit Details to Tip                                      --
--------------------------------------------------------------------------------------------------------

-- Get Reaction Index
local function GetUnitReactionIndex(unit)
	if (UnitIsDead(unit)) then
		return 7;
	-- Players (Can't rely on UnitPlayerControlled() alone, since it always returns nil on units out of range)
	elseif (UnitIsPlayer(unit) or UnitPlayerControlled(unit)) then
		if (UnitCanAttack(unit,"player")) then
			if (UnitCanAttack("player",unit)) then
				return 2;
			else
				return 3;
			end
		elseif (UnitCanAttack("player",unit)) then
			return 4;
		elseif (UnitIsPVP(unit) and not UnitIsPVPSanctuary(unit) and not UnitIsPVPSanctuary("player")) then
			return 5;
		else
			return 6;
		end
	-- Tapped
	elseif (UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit)) then
		return 1;
	-- Others
	else
		local reaction = (UnitReaction(unit,"player") or 3);
		if (reaction > 5) then
			return 5;
		elseif (reaction < 2) then
			return 2;
		else
			return reaction;
		end
	end
end

-- Returns the correct difficulty color compared to the player
local function GetDifficultyLevelColor(level)
	level = (level - player.level);
	if (level > 4) then
		return "|cffff2020"; -- red
	elseif (level > 2) then
		return "|cffff8040"; -- orange
	elseif (level >= -2) then
		return "|cffffff00"; -- yellow
	elseif (level >= -GetQuestGreenRange()) then
		return "|cff40c040"; -- green
	else
		return "|cff808080"; -- gray
	end
end

-- Add Target Line
local function AddTargetLine()
	if (cfg.showTarget == "first") then
		t:AddLine(u.line1.."|r : "..u.target);
	elseif (cfg.showTarget == "last") then
		t:AddLine("Targeting: "..u.target);
	elseif (cfg.showTarget == "second") then
		t:AddLine("  "..u.target);
	end
	u.raidIcon = GetRaidTargetIndex(u.token.."target");
	if (u.raidIcon) then
		t:AddTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons");
		SetRaidTargetIconTexture(TipTacTipTexture1,u.raidIcon);
	end
end

-- Add Unit Details
local function AddUnitDetails()
	u.isPlayer = UnitIsPlayer(u.token);
	u.reactionIndex = GetUnitReactionIndex(u.token);
	u.reaction = cfg["colReactText"..u.reactionIndex];
	-- Players
	if (u.isPlayer) then
		-- class
		u.class, u.classFixed = UnitClass(u.token);
		u.class = " "..(TT_ClassColors[u.classFixed] or TT_WHITE)..u.class;
		-- name
		u.name, u.realm = UnitName(u.token);
		u.line1 = (cfg.colorNameByClass and (TT_ClassColors[u.classFixed] or TT_WHITE) or u.reaction)..(cfg.pvpName and UnitPVPName(u.token) or u.name);
		if (u.realm) and (u.realm ~= "") and (cfg.showRealm ~= "none") then
			if (cfg.showRealm == "show") then
				u.line1 = u.line1.." - "..u.realm;
			else
				u.line1 = u.line1.." (*)";
			end
		end
		-- afk or dnd
		if (cfg.showStatus) then
			if (not UnitIsConnected(u.token)) then
				u.line1 = TT_WHITE.."<DC> "..u.line1;
			elseif (UnitIsAFK(u.token)) then
				u.line1 = TT_WHITE.."<AFK> "..u.line1;
			elseif (UnitIsDND(u.token)) then
				u.line1 = TT_WHITE.."<DND> "..u.line1;
			end
		end
		-- guild
		u.guild, u.guildRank = GetGuildInfo(u.token);
		if (u.guild) then
			player.guild = GetGuildInfo("player");
			if (u.guild == player.guild) then
				u.guild = cfg.colSameGuild.."<"..u.guild..">";
			else
				u.guild = u.reaction.."<"..u.guild..">";
			end
		end
		-- race
		u.race = " "..cfg.colRace..(UnitRace(u.token) or "");
	-- NPCs
	else
		-- name
		u.name = UnitName(u.token);
		u.line1 = u.reaction..u.name;
		-- guild
		u.guild = GameTooltipTextLeft2:GetText();
		u.guildRank = nil;
		if (u.guild) then
			if (u.guild:find(TT_LevelMatch)) then
				u.guild = nil;
			else
				u.guild = u.reaction.."<"..u.guild..">";
			end
		end
		-- race
		u.race = "";
		-- class
		u.class = UnitCreatureFamily(u.token) or UnitCreatureType(u.token);
		if (not u.class or u.class == TT_NotSpecified) then
			u.class = "Unknown";
		end
		u.class = " "..cfg.colRace..u.class;
	end
	-- Target
	if (cfg.showTarget == "none") then
		u.target = nil;
	else
		u.target = UnitName(u.token.."target");
		if (u.target == "Unknown") and (not UnitExists(u.token.."target")) then
			u.target = nil;
		elseif (u.target) then
			if (u.target == player.name) then
				u.target = TT_WHITE.."<<YOU>>"
			else
				u.targetReaction = cfg["colReactText"..GetUnitReactionIndex(u.token.."target")];
				if (UnitIsPlayer(u.token.."target")) then
					u.target = u.targetReaction.."["..(TT_ClassColors[select(2,UnitClass(u.token.."target"))] or TT_LIGHTGRAY)..u.target..u.targetReaction.."]";
				else
					u.target = u.targetReaction.."["..u.target.."]";
				end
			end
		end
	end
	-- Level + Classification
	u.level = UnitLevel(u.token);
	u.levelText = (u.level == -1 and "??" or u.level);
	u.classification = UnitClassification(u.token);
	if (TT_Classification[u.classification]) then
		u.levelText = TT_Classification[u.classification]:format(u.levelText);
	end
	if (UnitCanAttack(u.token,"player") or UnitCanAttack("player",u.token)) then
		u.levelText = GetDifficultyLevelColor(u.level ~= -1 and u.level or 500)..u.levelText.."  ";
	else
		u.levelText = cfg.colLevel..u.levelText.." ";
	end
	-- Add The Stuff
	if (u.target) and (cfg.showTarget == "first") then
		AddTargetLine();
	else
		t:AddLine(u.line1);
	end
	if (u.target) and (cfg.showTarget == "second") then
		AddTargetLine();
	end
	if (u.guild) then
		t:AddLine(u.guild);
	end
	t:AddLine(u.levelText..u.race..u.class,1,1,1);
	if (u.target) and (cfg.showTarget == "last") then
		AddTargetLine();
	end
end

-- Add Extra GTT Lines
local function AddExtraLines()
	for i = 2, GameTooltip:NumLines() do
		e.lineL = _G["GameTooltipTextLeft"..i]:GetText();
		if (e.lineL) and (e.lineL:find(TT_LevelMatch)) then
			for i = i + 1, GameTooltip:NumLines() do
				e.lineL, e.lineR = _G["GameTooltipTextLeft"..i], _G["GameTooltipTextRight"..i];
				if (e.lineL:GetText() ~= PVP_ENABLED) then
					e.r, e.g, e.b = e.lineL:GetTextColor();
					t:AddDoubleLine(e.lineL:GetText(),e.lineR:GetText(),e.r,e.g,e.b,e.lineR:GetTextColor());
				end
			end
			return;
		end
	end
end

-- Add "Targeted By" line
local function AddTargetedBy()
	e.numParty, e.numRaid = GetNumPartyMembers(), GetNumRaidMembers();
	if (e.numParty > 0 or e.numRaid > 0) then
		e.players, e.counter = "", 0;
		for i = 1, (e.numRaid > 0 and e.numRaid or e.numParty) do
			e.unit = (e.numRaid > 0 and "raid"..i or "party"..i);
			if (UnitIsUnit(e.unit.."target",u.token)) and (not UnitIsUnit(e.unit,"player")) then
				if (mod(e.counter + 3,6) == 0) then
					e.players = e.players.."\n";
				end
				e.color = RAID_CLASS_COLORS[select(2,UnitClass(e.unit))];
				e.players = ("%s|cff%.2x%.2x%.2x%s|r, "):format(e.players,e.color.r*255,e.color.g*255,e.color.b*255,UnitName(e.unit));
				e.counter = (e.counter + 1);
			end
		end
		if (e.players ~= "") then
			t:AddLine("Targeted By (|cffffffff"..e.counter.."|r): "..e.players:sub(1,-5));
		end
	end
end

--------------------------------------------------------------------------------------------------------
--                                        Health & Power Bars                                         --
--------------------------------------------------------------------------------------------------------

local statusBars = {};

-- Make a StatusBar
local function MakeStatusBar()
	local f = CreateFrame("StatusBar",nil,t);
	f:SetWidth(1);
	f:SetHeight(6);
	f:SetStatusBarColor(0.2,0.9,0.2);

	f.background = f:CreateTexture(nil,"BACKGROUND");
	f.background:SetTexture(0.3,0.3,0.3,0.6);
	f.background:SetAllPoints();

	f.text = f:CreateFontString(nil,"ARTWORK");
	f.text:SetPoint("CENTER");
	f.text:SetTextColor(1,1,1);

	tinsert(statusBars,f);
	return f;
end

MakeStatusBar();
MakeStatusBar();

-- Configures the Health and Power Bars
local function SetupHealthAndPowerBar()
	u.powerType = UnitPowerType(u.token);
	-- Visibility
	if (cfg.healthBar) then
		statusBars[1]:Show();
		if (u.isPlayer) and (cfg.healthBarClassColor) then
			local color = RAID_CLASS_COLORS[u.classFixed];
			statusBars[1]:SetStatusBarColor(color.r, color.g, color.b);
		else
			statusBars[1]:SetStatusBarColor(unpack(cfg.healthBarColor));
		end
	else
		statusBars[1]:Hide();
	end
	if (cfg.powerBar and u.powerType ~= 0) or (cfg.manaBar and u.powerType == 0) then
		if (u.powerType == 0) then
			statusBars[2]:SetStatusBarColor(unpack(cfg.manaBarColor));
		else
			u.powerColor = ManaBarColor[u.powerType] or { r = 0.5, g = 0.5, b = 0.5 };
			statusBars[2]:SetStatusBarColor(u.powerColor.r,u.powerColor.g,u.powerColor.b);
		end
		statusBars[2]:Show();
	else
		statusBars[2]:Hide();
	end
	-- Anchor Frames
	statusBars[2]:ClearAllPoints();
	statusBars[1]:ClearAllPoints();
	if (statusBars[2]:IsShown()) then
		statusBars[2]:SetPoint("BOTTOMLEFT",8,9);
		statusBars[2]:SetPoint("BOTTOMRIGHT",-8,9);
		if (statusBars[1]:IsShown()) then
			statusBars[1]:SetPoint("BOTTOMLEFT",statusBars[2],"TOPLEFT",0,4);
			statusBars[1]:SetPoint("BOTTOMRIGHT",statusBars[2],"TOPRIGHT",0,4);
		end
	elseif (statusBars[1]:IsShown()) then
		statusBars[1]:SetPoint("BOTTOMLEFT",8,9);
		statusBars[1]:SetPoint("BOTTOMRIGHT",-8,9);
	end
	-- Calculate the space needed for the shown bars
	TipTacTip.barsOffset = 0;
	for _, bar in ipairs(statusBars) do
		if (bar:IsShown()) then
			TipTacTip.barsOffset = (TipTacTip.barsOffset + cfg.barHeight + 2);
		end
	end
	if (TipTacTip.barsOffset > 0) then
		TipTacTip.barsOffset = (TipTacTip.barsOffset + 3);
	end
end

-- Update Health & Power
local function UpdateHealthAndPowerBar()
	-- Health
	if (statusBars[1]:IsShown()) then
		u.hp, u.hpMax = UnitHealth(u.token), UnitHealthMax(u.token);
		statusBars[1]:SetMinMaxValues(0,u.hpMax);
		statusBars[1]:SetValue(u.hp);
		if (cfg.healthBarText == "none") then
			statusBars[1].text:SetText("");
		else
			if (MobHealth_PPP) then
				u.ppp = MobHealth_PPP(u.name..":"..u.level);
				if (u.ppp) and (u.ppp > 0) then
					u.hp, u.hpMax = floor(u.ppp * u.hp + 0.5), floor(u.ppp * 100 + 0.5);
				end
			end
			if (cfg.healthBarText == "percent") or (u.hpMax == 100) then
				statusBars[1].text:SetText(floor(u.hp / u.hpMax * 100).."%");
			elseif (cfg.healthBarText == "value") then
				statusBars[1].text:SetText(u.hp.." / "..u.hpMax);
			end
		end
	end
	-- Power
	if (statusBars[2]:IsShown()) then
		u.power, u.powerMax = UnitMana(u.token), UnitManaMax(u.token);
		statusBars[2]:SetMinMaxValues(0,u.powerMax);
		statusBars[2]:SetValue(u.power);
		local barText = (u.powerType == 0 and cfg.manaBarText or cfg.powerBarText);
		if (barText == "none") or (barText == "percent" and u.powerMax == 0) then
			statusBars[2].text:SetText("");
		elseif (barText == "value") then
			statusBars[2].text:SetText(u.power.." / "..u.powerMax);
		elseif (barText == "percent") then
			statusBars[2].text:SetText(floor(u.power / u.powerMax * 100).."%");
		end
	end
end

--------------------------------------------------------------------------------------------------------
--                                       Auras - Buffs & Debuffs                                      --
--------------------------------------------------------------------------------------------------------

local function CreateAura()
	local aura = CreateFrame("Frame",nil,t);
	aura:SetWidth(cfg.auraSize);
	aura:SetHeight(cfg.auraSize);
	aura.count = aura:CreateFontString(nil,"OVERLAY");
	aura.count:SetPoint("BOTTOMRIGHT",1,0);
	aura.count:SetFont("Fonts\\FRIZQT__.TTF",(cfg.auraSize / 2),"OUTLINE");
	aura.icon = aura:CreateTexture(nil,"BACKGROUND");
	aura.icon:SetAllPoints();
	aura.cooldown = CreateFrame("Cooldown",nil,aura,"CooldownFrameTemplate");
	aura.cooldown:SetReverse(1);
	aura.cooldown:SetAllPoints();
	aura.border = aura:CreateTexture(nil,"OVERLAY");
	aura.border:SetPoint("TOPLEFT",-1,1);
	aura.border:SetPoint("BOTTOMRIGHT",1,-1);
	aura.border:SetTexture("Interface\\Buttons\\UI-Debuff-Overlays");
	aura.border:SetTexCoord(0.296875,0.5703125,0,0.515625);
	tinsert(auras,aura);
	return aura;
end

local function SetupAuras()
	local index = 1;
	local aura;
	local maxAuras = floor(t:GetWidth() / (cfg.auraSize + 1));
	local iconTexture, count, debuffType, duration, timeLeft;
	-- Get Buffs
	if (cfg.showBuffs) then
		iconTexture, count, duration, timeLeft = select(3,UnitBuff(u.token,index,cfg.selfBuffsOnly));
		while (iconTexture) do
			-- Get Aura Frame
			aura = auras[index] or CreateAura();
			-- Anchor It
			aura:ClearAllPoints();
			if (index == 1) then
				aura:SetPoint("BOTTOMLEFT",t,"TOPLEFT");
			elseif (maxAuras == 1) or (mod(index,maxAuras) == 1) then
				aura:SetPoint("BOTTOM",auras[index - maxAuras],"TOP",0,1);
			else
				aura:SetPoint("LEFT",auras[index - 1],"RIGHT",1,0);
			end
			-- Cooldown
			if (cfg.showAuraCooldown) and (duration and duration > 0 and timeLeft and timeLeft > 0) then
				aura.cooldown:SetCooldown(GetTime() + timeLeft - duration,duration);
			else
				aura.cooldown:Hide();
			end
			-- Set Texture + Count
			aura.icon:SetTexture(iconTexture);
			aura.count:SetText(count and count > 1 and count or "");
			-- Border
			aura.border:Hide();
			-- Show + Next, Break if exceed max desired rows of auras
			aura:Show();
			index = (index + 1);
			if (index / maxAuras > cfg.auraMaxRows) then
				break;
			end
			iconTexture, count, duration, timeLeft = select(3,UnitBuff(u.token,index,cfg.selfBuffsOnly));
		end
	end
	-- Get Debuffs
	if (cfg.showDebuffs) and (index / maxAuras <= cfg.auraMaxRows) then
		local buffCount, debuffIndex = (index - 1), 1;
		local lineOffset = floor(buffCount / maxAuras);
		local buffsOnFirstLine = (maxAuras - mod(buffCount,maxAuras));
		iconTexture, count, debuffType, duration, timeLeft = select(3,UnitDebuff(u.token,debuffIndex,cfg.selfDebuffsOnly));
		while (iconTexture) do
			-- Get Aura Frame
			aura = auras[index] or CreateAura();
			-- Anchor It
			aura:ClearAllPoints();
			if (debuffIndex <= buffsOnFirstLine) and (debuffIndex == 1) then
				aura:SetPoint("BOTTOMRIGHT",t,"TOPRIGHT",0,(cfg.auraSize + 1) * lineOffset);
			elseif (mod(index - 1,maxAuras) == 0) then
				aura:SetPoint("BOTTOMRIGHT",t,"TOPRIGHT",0,(cfg.auraSize + 1) * floor(index / maxAuras));
			else
				aura:SetPoint("RIGHT",auras[index - 1],"LEFT",-1,0);
			end
			-- Cooldown
			if (cfg.showAuraCooldown) and (duration and duration > 0 and timeLeft and timeLeft > 0) then
				aura.cooldown:SetCooldown(GetTime() + timeLeft - duration,duration);
			else
				aura.cooldown:Hide();
			end
			-- Set Texture + Count
			aura.icon:SetTexture(iconTexture);
			aura.count:SetText(count and count > 1 and count or "");
			-- Border
			local color = DebuffTypeColor[debuffType or "none"];
			aura.border:SetVertexColor(color.r,color.g,color.b);
			aura.border:Show();
			-- Show + Next, Break if exceed max desired rows of aura
			aura:Show();
			index = (index + 1);
			debuffIndex = (debuffIndex + 1);
			if (index / maxAuras > cfg.auraMaxRows) then
				break;
			end
			iconTexture, count, debuffType, duration, timeLeft = select(3,UnitDebuff(u.token,debuffIndex,cfg.selfDebuffsOnly));
		end
	end
	-- Hide the Unused
	for i = index, #auras do
		auras[i]:Hide();
	end
end

--------------------------------------------------------------------------------------------------------
--                                                Misc                                                --
--------------------------------------------------------------------------------------------------------

-- Defaults Void Settings
function TipTac:CheckSettings()
	for option, value in pairs(TT_DefaultConfig) do
		if (cfg[option] == nil) then
			cfg[option] = value;
		end
	end
end

-- Apply Settings
function TipTac:ApplySettings()
	-- Set Backdrop
	tipBackdrop.bgFile = cfg.tipBackdropBG;
	tipBackdrop.edgeFile = cfg.tipBackdropEdge;
	t:SetBackdrop(tipBackdrop);
	-- Set TipTacTip Appearance
	if (not cfg.reactColoredBackdrop) then
		t:SetBackdropColor(unpack(cfg.tipTacColor));
	end
	if (not cfg.classColoredBorder) then
		t:SetBackdropBorderColor(unpack(cfg.tipTacBorderColor));
	end
	-- Set Scale
	t:SetScale(cfg.tipScale);
	for _, tip in ipairs(TT_TipsToModify) do
		tip = _G[tip];
		if (type(tip) == "table") then
			tip:SetScale(cfg.gttScale);
			tip:SetBackdrop(tipBackdrop);
			if (tip:IsShown()) then
				tip:SetBackdropBorderColor(unpack(cfg.tipBorderColor));
				tip:SetBackdropColor(unpack(cfg.tipColor));
			end
		end
	end
	-- Bar Appearances
	for _, bar in ipairs(statusBars) do
		bar:SetStatusBarTexture(cfg.barTexture);
		bar:SetHeight(cfg.barHeight);
		bar.text:SetFont(cfg.barFontFace,cfg.barFontSize,cfg.barFontFlags);
	end
	-- If disabled, hide auras, else set their size
	for _, aura in ipairs(auras) do
		if (cfg.showBuffs or cfg.showDebuffs) then
			aura:SetWidth(cfg.auraSize);
			aura:SetHeight(cfg.auraSize);
			aura.count:SetFont("Fonts\\FRIZQT__.TTF",(cfg.auraSize / 2),"OUTLINE");
		else
			aura:Hide();
		end
	end
	-- GameTooltip Font Templates
	if (cfg.modifyFonts) then
		GameTooltipHeaderText:SetFont(cfg.fontFace,cfg.fontSize + 2,cfg.fontFlags);
		GameTooltipText:SetFont(cfg.fontFace,cfg.fontSize,cfg.fontFlags);
		GameTooltipTextSmall:SetFont(cfg.fontFace,cfg.fontSize - 2,cfg.fontFlags);
	end
end

-- Anchor any given frame to mouse position
function TipTac:AnchorFrameToMouse(frame)
	local x, y = GetCursorPosition();
	local effScale = frame:GetEffectiveScale();
	local showingUnit = (t:IsShown() or GameTooltip:GetUnit()); -- Az: easier way to set this?
	frame:ClearAllPoints();
	frame:SetPoint(showingUnit and cfg.anchorPointUnit or cfg.anchorPoint,UIParent,"BOTTOMLEFT",(x / effScale + cfg.mouseOffsetX),(y / effScale + cfg.mouseOffsetY));
end

-- Show Unit
function TipTac:ShowUnit(unitToken,first)
	-- Init
	if (first) then
		-- Talents
		if (cfg.showTalents) then
			u.talents = nil;
			if (UnitIsPlayer(unitToken)) then
				a:RegisterEvent("INSPECT_TALENT_READY");
				NotifyInspect(unitToken);
			else
				a:UnregisterEvent("INSPECT_TALENT_READY");
			end
		end
		-- Normal Init
		u.token = unitToken;
		u.gttName = GameTooltipTextLeft1:GetText();
		GameTooltip_SetDefaultAnchor(t,GameTooltip:GetOwner());
	else
		t:ClearLines();
	end
	-- Construct the TipTacTip
	AddUnitDetails();
	if (cfg.reactText) then
		t:AddLine(cfg["colReactText"..u.reactionIndex]..TT_Reaction[u.reactionIndex]);
	end
	AddExtraLines();
	-- Talents
	if (cfg.showTalents) and (u.talents) then
		t:AddLine("Talents: "..TT_WHITE..u.talents);
	end
	if (cfg.showTargetedBy) then
		AddTargetedBy();
	end
	if (cfg.showBuffs or cfg.showDebuffs) then
		SetupAuras();
	end
	if (first) or (UnitPowerType(u.token) ~= u.powerType) then
		SetupHealthAndPowerBar();
	end
	UpdateHealthAndPowerBar();
	-- Border
	if (first) and (cfg.classColoredBorder) then
		if (u.isPlayer) then
			local color = RAID_CLASS_COLORS[u.classFixed];
			t:SetBackdropBorderColor(color.r,color.g,color.b,1);
		else
			t:SetBackdropBorderColor(unpack(cfg.tipBorderColor));
		end
	end
	-- Backdrop Color
	if (cfg.reactColoredBackdrop) then
		t:SetBackdropColor(unpack(cfg["colReactBack"..u.reactionIndex]));
		if (not cfg.classColoredBorder or not u.isPlayer) then
			t:SetBackdropBorderColor(unpack(cfg["colReactBack"..u.reactionIndex]));
		end
	end
	-- Hide GTT & Reset Fade
	if (first) then
		t.fadeTime = -1;
		GameTooltip:SetAlpha(0);
	end
	-- Show & Adjust Height
	t:Show();
	t:SetHeight(t:GetHeight() + t.barsOffset);
end