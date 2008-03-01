local cfg = TipTac_Config;

-- Options
local activePage = 1;
local frames = {};
local options = {
	-- General
	{
		[0] = "General",
		{ type = "Check", var = "showUnitTip", label = "Show TipTac Unit Tips", tip = "To take full advantage of all features in TipTac, you need to enable this option" },
		{ type = "Check", var = "hookTips", label = "Hook Special Tips (Requires UI Reload)", tip = "Hook special tips to modify in appearance. Changing this options requires a UI reload to take effect.", y = 12 },
		{ type = "Slider", var = "updateFreq", label = "Tip Update Frequency", min = 0, max = 5, step = 0.05, y = 12 },
		{ type = "Check", var = "showStatus", label = "Show DC, AFK and DND Status", tip = "Will show the <DC>, <AFK> and <DND> status infront of the player name" },
		{ type = "Check", var = "pvpName", label = "Use Title If Available", tip = "Shows titles for players if available such as 'Champion of the Naaru' or the old PvP titles", y = 8 },
		{ type = "DropDown", var = "showRealm", label = "Show Unit Realm", list = { ["Do not show realm"] = "none", ["Show realm"] = "show", ["Show (*) instead"] = "asterisk" } },
		{ type = "DropDown", var = "showTarget", label = "Show Unit Target", list = { ["Do not show target"] = "none", ["First line"] = "first", ["Second line"] = "second", ["Last line"] = "last" } },
		{ type = "Check", var = "showTargetedBy", label = "Show Who Targets the Unit", tip = "When in a raid or party, the tip will show who from your group is targeting the unit" },
		{ type = "Check", var = "showTalents", label = "Show Player Talents", tip = "Will show the talent specialization of the player" },
 	},
	-- Colors
	{
		[0] = "Colors",
		{ type = "Color", subType = 2, var = "colSameGuild", label = "Same Guild Color", tip = "To better recognise players from your guild, you can configure the the color of your guild name individually" },
		{ type = "Color", subType = 2, var = "colRace", label = "Race & Create Type Color", tip = "The color of the Race & Create Type text" },
		{ type = "Color", subType = 2, var = "colLevel", label = "Neutral Level Color", tip = "Units you cannot attack will have their level text shown in this color", y = 12 },
		{ type = "Check", var = "colorNameByClass", label = "Color Player Names by Class Color", tip = "With this option on, player names are colored by their class color, otherwise they will be colored by reaction" },
		{ type = "Check", var = "classColoredBorder", label = "Color Tip Border by Class Color", tip = "For players, the border color will be colored to match the color of their class" },
	},
	-- Reactions
	{
		[0] = "Reactions",
		{ type = "Check", var = "reactText", label = "Show the unit's reaction as text", tip = "With this option on, the reaction of the unit will be shown as text on the last line", y = 20 },
		{ type = "Color", subType = 2, var = "colReactText1", label = "Tapped Color", tip = "" },
		{ type = "Color", subType = 2, var = "colReactText2", label = "Hostile Color", tip = "" },
		{ type = "Color", subType = 2, var = "colReactText3", label = "Caution Color", tip = "" },
		{ type = "Color", subType = 2, var = "colReactText4", label = "Neutral Color", tip = "" },
		{ type = "Color", subType = 2, var = "colReactText5", label = "Friendly NPC or PvP Player Color", tip = "" },
		{ type = "Color", subType = 2, var = "colReactText6", label = "Friendly Player Color", tip = "" },
		{ type = "Color", subType = 2, var = "colReactText7", label = "Dead Color", tip = "" },
	},
	-- BG Color
	{
		[0] = "BG Color",
		{ type = "Check", var = "reactColoredBackdrop", label = "Color backdrop depending on the unit's reaction", tip = "If you want the tip's background color to be determined by the unit's reaction towards you, enable this. With the option off, the background color will be the one selected on the 'Backdrop' page", y = 20 },
		{ type = "Color", var = "colReactBack1", label = "Tapped Color", tip = "" },
		{ type = "Color", var = "colReactBack2", label = "Hostile Color", tip = "" },
		{ type = "Color", var = "colReactBack3", label = "Caution Color", tip = "" },
		{ type = "Color", var = "colReactBack4", label = "Neutral Color", tip = "" },
		{ type = "Color", var = "colReactBack5", label = "Friendly NPC or PvP Player Color", tip = "" },
		{ type = "Color", var = "colReactBack6", label = "Friendly Player Color", tip = "" },
		{ type = "Color", var = "colReactBack7", label = "Dead Color", tip = "" },
	},
	-- Backdrop
	{
		[0] = "Backdrop",
		{ type = "DropDown", var = "tipBackdropBG", label = "Background Texture", init = TipTacDropDowns.SharedMediaLib, media = "background" },
		{ type = "DropDown", var = "tipBackdropEdge", label = "Border Texture", init = TipTacDropDowns.SharedMediaLib, media = "border", y = 20 },
		{ type = "Color", var = "tipColor", label = "Tip Background Color" },
		{ type = "Color", var = "tipBorderColor", label = "Tip Border Color", y = 12 },
		{ type = "Color", var = "tipTacColor", label = "TipTac Background Color" },
		{ type = "Color", var = "tipTacBorderColor", label = "TipTac Border Color" },
	},
	--Font
	{
		[0] = "Font",
		{ type = "Check", var = "modifyFonts", label = "Modify the GameTooltip Font Templates", tip = "For TipTac to change the GameTooltip font templates and thus all tooltips in the User Interface, you have to enable this option", y = 12 },
		{ type = "DropDown", var = "fontFace", label = "Font Face", init = TipTacDropDowns.SharedMediaLib, media = "font" },
		{ type = "DropDown", var = "fontFlags", label = "Font Flags", list = TipTacDropDowns.FontFlags },
		{ type = "Slider", var = "fontSize", label = "Font Size", min = 6, max = 29, step = 1 },
	},
	-- Scaling
	{
		[0] = "Scaling",
		{ type = "Slider", var = "tipScale", label = "TipTacTip Scale", min = 0.2, max = 4, step = 0.05 },
		{ type = "Slider", var = "gttScale", label = "GameTooltip Scale", min = 0.2, max = 4, step = 0.05 },
	},
	-- Fading
	{
		[0] = "Fading",
		{ type = "Slider", var = "preFadeTime", label = "Pre Fade Time", min = 0, max = 5, step = 0.05 },
		{ type = "Slider", var = "fadeTime", label = "Fade Out Time", min = 0, max = 5, step = 0.05 },
	},
	-- Bars
	{
		[0] = "Bars",
		{ type = "Check", var = "healthBar", label = "Show Health Bar", tip = "Will show a health bar of the unit. This supports MobHealth, and will show estimated health if installed and available for that unit." },
		{ type = "DropDown", var = "healthBarText", label = "Health Bar Text", list = TipTacDropDowns.BarTextFormat, y = -6 },
		{ type = "Check", var = "healthBarClassColor", label = "Color the Health Bar in the Unit's Class Color", tip = "This options colors the health bar in the same color as the player class", y = 6 },
		{ type = "Color", var = "healthBarColor", label = "Health Bar Color", tip = "The color of the health bar color, has no effect for players with the option above enabled", y = 12 },
		{ type = "Check", var = "manaBar", label = "Show Mana Bar", tip = "If the unit has mana, a mana bar will be shown." },
		{ type = "DropDown", var = "manaBarText", label = "Mana Bar Text", list = TipTacDropDowns.BarTextFormat },
		{ type = "Color", var = "manaBarColor", label = "Mana Bar Color", tip = "The color of the mana bar", y = 12 },
		{ type = "Check", var = "powerBar", label = "Show Energy, Rage or Focus Bar", tip = "If the unit uses either energy, rage or focus, a bar for that will be shown." },
		{ type = "DropDown", var = "powerBarText", label = "Power Bar Text", list = TipTacDropDowns.BarTextFormat },
	},
	-- Bars Misc
	{
		[0] = "Bars Misc",
		{ type = "DropDown", var = "barFontFace", label = "Font Face", init = TipTacDropDowns.SharedMediaLib, media = "font" },
		{ type = "DropDown", var = "barFontFlags", label = "Font Flags", list = TipTacDropDowns.FontFlags },
		{ type = "Slider", var = "barFontSize", label = "Font Size", min = 6, max = 29, step = 1, y = 36 },
		{ type = "DropDown", var = "barTexture", label = "Bar Texture", init = TipTacDropDowns.SharedMediaLib, media = "statusbar" },
		{ type = "Slider", var = "barHeight", label = "Bar Height", min = 1, max = 50, step = 1 },
	},
	-- Auras
	{
		[0] = "Auras",
		{ type = "Check", var = "showBuffs", label = "Show Unit Buffs", tip = "Show buffs of the unit" },
		{ type = "Check", var = "selfBuffsOnly", label = "Show Castable Buffs Only", tip = "This will filter out and not display any buffs you cannot cast", y = 12 },
		{ type = "Check", var = "showDebuffs", label = "Show Unit Debuffs", tip = "Show debuffs of the unit" },
		{ type = "Check", var = "selfDebuffsOnly", label = "Show Removable Debuffs Only", tip = "This will filter out and not display any debuffs you cannot remove", y = 12 },
		{ type = "Slider", var = "auraSize", label = "Aura Icon Dimension", min = 8, max = 60, step = 1 },
		{ type = "Slider", var = "auraMaxRows", label = "Max Aura Rows", min = 1, max = 8, step = 1, y = 8 },
		{ type = "Check", var = "showAuraCooldown", label = "Show Cooldown Models", tip = "With this option on, you will see a visual progress of the time left on the buff. Only works for buffs you cast." },
	},
	-- Anchors
	{
		[0] = "Anchors",
		{ type = "DropDown", var = "anchorType", label = "Non-Unit Anchor Type", list = TipTacDropDowns.AnchorType },
		{ type = "DropDown", var = "anchorPoint", label = "Non-Unit Anchor Point", list = TipTacDropDowns.AnchorPos, y = 20 },
		{ type = "DropDown", var = "anchorTypeUnit", label = "Unit Anchor Type", list = TipTacDropDowns.AnchorType },
		{ type = "DropDown", var = "anchorPointUnit", label = "Unit Anchor Point", list = TipTacDropDowns.AnchorPos, y = 8 },
		{ type = "Check", var = "hideTipsInCombat", label = "Hide Tips for Unit Frames in Combat", tip = "When you are in combat, this option will prevent tips from showing when you have the mouse over a unit frame", y = 12 },
		{ type = "Slider", var = "mouseOffsetX", label = "Mouse Anchor X Offset", min = -200, max = 200, step = 1 },
		{ type = "Slider", var = "mouseOffsetY", label = "Mouse Anchor Y Offset", min = -200, max = 200, step = 1 },
	},
	-- Layouts
	{
		[0] = "Layouts",
		{ type = "DropDown", label = "Layout Template", init = TipTacDropDowns.Layouts },
	},
};

--------------------------------------------------------------------------------------------------------
--                                          Initialize Frame                                          --
--------------------------------------------------------------------------------------------------------

local f = CreateFrame("Frame","TipTacOptions",UIParent);

f:SetWidth(424);
f:SetHeight(360);
f:SetBackdrop({ bgFile = "Interface\\ChatFrame\\ChatFrameBackground", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = 1, tileSize = 16, edgeSize = 16, insets = { left = 4, right = 4, top = 4, bottom = 4 } });
f:SetBackdropColor(0.1,0.22,0.35,1);
f:SetBackdropBorderColor(0.1,0.1,0.1,1);
f:EnableMouse(1);
f:SetMovable(1);
f:SetToplevel(1);
f:SetClampedToScreen(1);
f:SetScript("OnShow",function() f:BuildCategoryPage(); end);
f:Hide();

f.outline = CreateFrame("Frame",nil,f);
f.outline:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = 1, tileSize = 16, edgeSize = 16, insets = { left = 4, right = 4, top = 4, bottom = 4 } });
f.outline:SetBackdropColor(0.1,0.1,0.2,1);
f.outline:SetBackdropBorderColor(0.8,0.8,0.9,0.4);
f.outline:SetPoint("TOPLEFT",12,-12);
f.outline:SetPoint("BOTTOMLEFT",12,12);
f.outline:SetWidth(84);

f:SetScript("OnMouseDown",function() f:StartMoving() end);
f:SetScript("OnMouseUp",function() f:StopMovingOrSizing(); cfg.optionsLeft = f:GetLeft(); cfg.optionsBottom = f:GetBottom(); end);

if (cfg.optionsLeft) and (cfg.optionsBottom) then
	f:SetPoint("BOTTOMLEFT",UIParent,"BOTTOMLEFT",cfg.optionsLeft,cfg.optionsBottom);
else
	f:SetPoint("CENTER");
end

f.header = f:CreateFontString(nil,"ARTWORK","PVPInfoTextFont");
f.header:SetPoint("TOPLEFT",f.outline,"TOPRIGHT",10,-4);
f.header:SetText("TipTac Options");

f.vers = f:CreateFontString(nil,"ARTWORK","GameFontNormal");
f.vers:SetPoint("TOPRIGHT",-20,-20);
f.vers:SetText(GetAddOnMetadata("TipTac","Version"));
f.vers:SetTextColor(1,1,0.5);

local function Reset_OnClick()
	for index, table in ipairs(options[activePage]) do
		if (table.var) then
			cfg[table.var] = nil;
		end
	end
	TipTac:CheckSettings();
	TipTac:ApplySettings();
	f:BuildCategoryPage();
end

f.btnAnchor = CreateFrame("Button",nil,f,"UIPanelButtonTemplate");
f.btnAnchor:SetWidth(75);
f.btnAnchor:SetHeight(24);
f.btnAnchor:SetPoint("BOTTOMLEFT",f.outline,"BOTTOMRIGHT",10,3);
f.btnAnchor:SetScript("OnClick",function() if (TipTacAnchor:IsVisible()) then TipTacAnchor:Hide(); else TipTacAnchor:Show(); end end);
f.btnAnchor:SetText("Anchor");

f.btnReset = CreateFrame("Button",nil,f,"UIPanelButtonTemplate");
f.btnReset:SetWidth(75);
f.btnReset:SetHeight(24);
f.btnReset:SetPoint("LEFT",f.btnAnchor,"RIGHT",38,0);
f.btnReset:SetScript("OnClick",Reset_OnClick);
f.btnReset:SetText("Reset");

f.btnClose = CreateFrame("Button",nil,f,"UIPanelButtonTemplate");
f.btnClose:SetWidth(75);
f.btnClose:SetHeight(24);
f.btnClose:SetPoint("BOTTOMRIGHT",-15,15);
f.btnClose:SetScript("OnClick",function() f:Hide(); end);
f.btnClose:SetText("Close");

tinsert(UISpecialFrames,f:GetName());

--------------------------------------------------------------------------------------------------------
--                                        Options Category List                                       --
--------------------------------------------------------------------------------------------------------

do
	local listButtons = {};

	local function List_OnClick(self,button)
		listButtons[activePage].text:SetTextColor(1,0.82,0);
		activePage = self.index;
		listButtons[activePage].text:SetTextColor(1,1,1);
		PlaySound("igMainMenuOptionCheckBoxOn");
		f:BuildCategoryPage();
	end

	local buttonWidth = (f.outline:GetWidth() - 8);
	local function MakeListEntry()
		local b = CreateFrame("Button",nil,f.outline);
		b:SetWidth(buttonWidth);
		b:SetHeight(18);

		b:SetScript("OnClick",List_OnClick);
		b:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight");

		b.text = b:CreateFontString(nil,"ARTWORK","GameFontNormal");
		b.text:SetPoint("LEFT",3,0);

		tinsert(listButtons,b);
		return b;
	end

	local button;
	for index, table in ipairs(options) do
		button = listButtons[index] or MakeListEntry();
		button.text:SetText(table[0]);
		button.index = index;
		if (index == activePage) then
			button.text:SetTextColor(1,1,1);
		end
		if (index == 1) then
			button:SetPoint("TOPLEFT",f.outline,"TOPLEFT",5,-6);
		else
			button:SetPoint("TOPLEFT",listButtons[index - 1],"BOTTOMLEFT");
		end
	end
end

--------------------------------------------------------------------------------------------------------
--                                        Build Option Category                                       --
--------------------------------------------------------------------------------------------------------

-- Converts string colors to RGBA
function f:HexStringToRGBA(string)
	local a, r, g, b = string:match("^|c(..)(..)(..)(..)");
	return format("%d","0x"..r) / 255, format("%d","0x"..g) / 255, format("%d","0x"..b) / 255, format("%d","0x"..a) / 255;
end

-- Get Frame
local function GetFrame(type,id,index)
	local frame;
	-- Find existsing frame
	if (frames[type]) and (frames[type][index]) then
		frame = frames[type][index];
	-- Create new frame
	else
		frame = TTOFactory[type](index);
		if (not frames[type]) then
			frames[type] = {};
		end
		tinsert(frames[type],frame);
	end
	-- Return Frame
	return frame;
end

local xExtraOffsets = { ["Check"] = 10, ["Slider"] = 18, ["Color"] = 14, ["DropDown"] = 120 };
local yExtraOffsets = { ["Check"] = -4, ["Slider"] = 4, ["Color"] = 6, ["DropDown"] = 0 };

-- Build Page
function f:BuildCategoryPage()
	local frame;
	local frameUseCount = {};
	local yOffset = -38;
	-- Loop Through Options
	f.updatingOptions = 1;
	for index, table in ipairs(options[activePage]) do
		-- Az: debug
--		if (cfg[table.var] == nil) then
--			AzMsg("|2Warning:|r the variable |1"..tostring(table.var).."|r, was |1nil|r.");
--		end
		-- Init the Frame
		frameUseCount[table.type] = (frameUseCount[table.type] or 0) + 1;
		frame = GetFrame(table.type,index,frameUseCount[table.type]);
		-- Setup the Frame
		frame.option = table;
		frame.text:SetText(table.label);
		-- slider
		if (table.type == "Slider") then
			frame.slider:SetMinMaxValues(table.min,table.max);
			frame.slider:SetValueStep(table.step);
			frame.slider:SetValue(cfg[table.var]);
			frame.edit:SetNumber(cfg[table.var]);
			frame.low:SetText(table.min);
			frame.high:SetText(table.max);
		-- check
		elseif (table.type == "Check") then
			frame:SetHitRectInsets(0,frame.text:GetWidth() * -1,0,0);
			frame:SetChecked(cfg[table.var]);
		-- color
		elseif (table.type == "Color") then
			frame:SetHitRectInsets(0,frame.text:GetWidth() * -1,0,0);
			if (table.subType == 2) then
				frame.texture:SetVertexColor(f:HexStringToRGBA(cfg[table.var]));
			else
				frame.texture:SetVertexColor(unpack(cfg[table.var]));
			end
		-- dropdown
		elseif (table.type == "DropDown") then
			f.lastDropDown = frame;
			UIDropDownMenu_Initialize(frame,table.init or TipTacDropDowns.Default);
			UIDropDownMenu_SetWidth(160,frame);
			UIDropDownMenu_SetText("|cff20ff20Select...",frame);
			if (table.var) then
				UIDropDownMenu_SetSelectedValue(frame,cfg[table.var]);
			end
		end
		-- Anchor the Frame
		frame:ClearAllPoints();
		frame:SetPoint("TOPLEFT",f.outline,"TOPRIGHT",xExtraOffsets[table.type] + (table.x or 0),yOffset);
		yOffset = (yOffset - frame:GetHeight() - yExtraOffsets[table.type] - (table.y or 0));
		-- Show
		frame:Show();
	end
	f.lastDropDown = nil;
	-- Hide Unused Frames
	for type, table in pairs(frames) do
		for i = (frameUseCount[type] or 0) + 1, #table do
			table[i]:Hide();
		end
	end
	-- Reset
	f.updatingOptions = nil;
end