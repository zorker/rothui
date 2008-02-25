-- Config
AzCastBar_Profiles = {};
local cfg = AzCastBar_Config;

-- Options
local activePage, subPage = 1, 1;
local frames = {};
local options = {
	{
		[0] = "General",
		{ type = "Check", var = "enabled", label = "Enable Bar Plugin", tip = "Enable or disable this bar plugin" },
		{ type = "Check", var = "showIcon", label = "Show Bar Icon", tip = "This option will display an icon to the left on the cast bar.", y = 12 },
		{ type = "Check", var = "showRank", label = "Show Spell Rank", tip = "If the spell being cast has a rank, it will be shown in brackets after the spell name.", restrict = { "Player", "Target", "Focus", "Pet" } },
		{ type = "Check", var = "safeZone", label = "Show Safe Zone Area", tip = "The 'Safe Zone' is the time equal to your latency, with this option enabled, it will show this duration on the cast bar. A spell canceled after it has reached the safe zone, will still go off.", restrict = { "Player" } },
	},
	{
		[0] = "Misc",
		{ type = "Slider", var = "fadeTime", label = "Fade Out Time", min = 0.1, max = 6, step = 0.1 },
		{ type = "Slider", var = "alpha", label = "Alpha", min = 0, max = 1, step = 0.01, y = 16 },
		{ type = "DropDown", var = "texture", label = "Bar Texture", init = AzCastBarDropDowns.SharedMediaLib, media = "statusbar" },
		{ type = "DropDown", var = "backdropBG", label = "Backdrop Background", init = AzCastBarDropDowns.SharedMediaLib, media = "background" },
		{ type = "Slider", var = "backdropIndent", label = "Backdrop Indent", min = -20, max = 60, step = 0.5 },
	},
	{
		[0] = "Position",
		{ type = "Slider", var = "left", label = "Left Offset", min = 0, max = 2048, step = 1 },
		{ type = "Slider", var = "bottom", label = "Bottom Offset", min = 0, max = 1536, step = 1, y = 12 },
		{ type = "Slider", var = "width", label = "Width", min = 20, max = 2048, step = 1 },
		{ type = "Slider", var = "height", label = "Height", min = 6, max = 120, step = 1 },
	},
	{
		[0] = "Font",
		{ type = "DropDown", var = "fontFace", label = "Font Face", init = AzCastBarDropDowns.SharedMediaLib, media = "font" },
		{ type = "DropDown", var = "fontFlags", label = "Font Flags", list = AzCastBarDropDowns.FontFlags },
		{ type = "Slider", var = "fontSize", label = "Font Size", min = 4, max = 29, step = 1 },
	},
	{
		[0] = "Colors",
		{ type = "Color", var = "colBackdrop", label = "Backdrop Color" },
		{ type = "Color", var = "colBackground", label = "Background Color" },
		{ type = "Color", var = "colFont", label = "Font Color" },
		{ type = "Color", var = "colNormal", label = "Normal Bar Color", y = 16 },

		{ type = "Color", var = "colFailed", label = "Failed Cast Bar Color", restrict = { "Player", "Target", "Focus", "Pet" } },
		{ type = "Color", var = "colInterrupt", label = "Interrupted Cast Bar Color", restrict = { "Player", "Target", "Focus", "Pet" }, y = 16 },

		{ type = "Color", var = "colSafezone", label = "Safe Zone Color", restrict = { "Player" } },
	},
};

--------------------------------------------------------------------------------------------------------
--                                          Initialize Frame                                          --
--------------------------------------------------------------------------------------------------------

local f = CreateFrame("Frame","AzCastBarOptions",UIParent);

f:SetWidth(430);
f:SetHeight(420);
f:SetBackdrop({ bgFile = "Interface\\ChatFrame\\ChatFrameBackground", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = 1, tileSize = 16, edgeSize = 16, insets = { left = 4, right = 4, top = 4, bottom = 4 } });
f:SetBackdropColor(0.1,0.22,0.35,1);
f:SetBackdropBorderColor(0.1,0.1,0.1,1);
f:EnableMouse(1);
f:SetMovable(1);
f:SetToplevel(1);
f:SetClampedToScreen(1);
f:SetScript("OnShow",function() f:BuildSubOptionList(); f:BuildCategoryPage(); end);
f:Hide();

f.outline = CreateFrame("Frame",nil,f);
f.outline:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = 1, tileSize = 16, edgeSize = 16, insets = { left = 4, right = 4, top = 4, bottom = 4 } });
f.outline:SetBackdropColor(0.1,0.1,0.2,1);
f.outline:SetBackdropBorderColor(0.8,0.8,0.9,0.4);
f.outline:SetPoint("TOPLEFT",12,-12);
f.outline:SetWidth(90);

f.outline2 = CreateFrame("Frame",nil,f);
f.outline2:SetBackdrop(f.outline:GetBackdrop());
f.outline2:SetBackdropColor(0.1,0.1,0.2,1);
f.outline2:SetBackdropBorderColor(0.8,0.8,0.9,0.4);
f.outline2:SetPoint("TOPLEFT",f.outline,"BOTTOMLEFT",0,-8);
f.outline2:SetPoint("BOTTOMLEFT",12,12);
f.outline2:SetWidth(90);

f:SetScript("OnMouseDown",function() f:StartMoving() end);
f:SetScript("OnMouseUp",function() f:StopMovingOrSizing(); cfg.optionsLeft = f:GetLeft(); cfg.optionsBottom = f:GetBottom(); end);

if (cfg.optionsLeft) and (cfg.optionsBottom) then
	f:SetPoint("BOTTOMLEFT",UIParent,"BOTTOMLEFT",cfg.optionsLeft,cfg.optionsBottom);
else
	f:SetPoint("CENTER");
end

f.header = f:CreateFontString(nil,"ARTWORK","PVPInfoTextFont");
f.header:SetPoint("TOPLEFT",f.outline,"TOPRIGHT",10,-4);
f.header:SetText("AzCastBar Options");

f.vers = f:CreateFontString(nil,"ARTWORK","GameFontNormal");
f.vers:SetPoint("TOPRIGHT",-20,-20);
f.vers:SetText(GetAddOnMetadata("AzCastBar","Version"));
f.vers:SetTextColor(1,1,0.5);

local function Reset_OnClick()
	for index, table in ipairs(options[subPage]) do
		if (table.var) then
			cfg[f.activeBar.token][table.var] = nil;
		end
	end
	AzCastBar_CheckSettings();
	AzCastBar_ApplyBarSettings(f.activeBar);
	f:BuildCategoryPage();
end

local function Profiles_OnClick()
	if (f.profilesFrame:IsShown()) then
		f.profilesFrame:Hide();
	else
		f.profilesFrame:Show();
		f.profilesFrame:BuildProfileList();
	end
end

f.btnClose = CreateFrame("Button",nil,f,"UIPanelButtonTemplate");
f.btnClose:SetWidth(68);
f.btnClose:SetHeight(24);
f.btnClose:SetPoint("BOTTOMRIGHT",-15,15);
f.btnClose:SetScript("OnClick",function() f:Hide(); f.profilesFrame:Hide(); end);
f.btnClose:SetText("Close");

f.btnReset = CreateFrame("Button",nil,f,"UIPanelButtonTemplate");
f.btnReset:SetWidth(68);
f.btnReset:SetHeight(24);
f.btnReset:SetPoint("RIGHT",f.btnClose,"LEFT",-4,0);
f.btnReset:SetScript("OnClick",Reset_OnClick);
f.btnReset:SetText("Reset");

f.btnProfiles = CreateFrame("Button",nil,f,"UIPanelButtonTemplate");
f.btnProfiles:SetWidth(68);
f.btnProfiles:SetHeight(24);
f.btnProfiles:SetPoint("RIGHT",f.btnReset,"LEFT",-4,0);
f.btnProfiles:SetScript("OnClick",Profiles_OnClick);
f.btnProfiles:SetText("Profiles");

tinsert(UISpecialFrames,f:GetName());
f.activeBar = AzCastBar_Frames[activePage];

--------------------------------------------------------------------------------------------------------
--                                        Options Category List                                       --
--------------------------------------------------------------------------------------------------------

local listButtons, listButtons2 = {}, {};

-- Create Button Entry
function f:MakeListButton(table,parent,func)
	local b = CreateFrame("Button",nil,parent);
	b:SetWidth(parent:GetWidth() - 8);
	b:SetHeight(18);
	b:SetScript("OnClick",func);

	b:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight");

	b.text = b:CreateFontString(nil,"ARTWORK","GameFontNormal");
	b.text:SetPoint("LEFT",3,0);

	tinsert(table,b);
	return b;
end

-- OnClicks
local function List2_OnClick(self,button)
	PlaySound("igMainMenuOptionCheckBoxOn");
	listButtons2[subPage].text:SetTextColor(1,0.82,0);
	subPage = self.index;
	listButtons2[subPage].text:SetTextColor(1,1,1);
	f:BuildCategoryPage();
end

local function List_OnClick(self,button)
	PlaySound("igMainMenuOptionCheckBoxOn");
	listButtons[activePage].text:SetTextColor(1,0.82,0);
	activePage = self.index;
	listButtons[activePage].text:SetTextColor(1,1,1);
	f.activeBar = AzCastBar_Frames[activePage];
	f:BuildSubOptionList();
	f:BuildCategoryPage();
end

-- List Bar Plugins
local button;
for index, frame in ipairs(AzCastBar_Frames) do
	button = listButtons[index] or f:MakeListButton(listButtons,f.outline,List_OnClick);
	button.text:SetText(frame.token);
	button.index = index;
	if (index == activePage) then
		button.text:SetTextColor(1,1,1);
	end
	if (index == 1) then
		button:SetPoint("TOPLEFT",5,-6);
	else
		button:SetPoint("TOPLEFT",listButtons[index - 1],"BOTTOMLEFT");
	end
end

-- Sub Options
function f:BuildSubOptionList()
	local button;
	for index, table in ipairs(options) do
		button = listButtons2[index] or f:MakeListButton(listButtons2,f.outline2,List2_OnClick);
		button.text:SetText(table[0]);
		button.index = index;
		if (index == subPage) then
			button.text:SetTextColor(1,1,1);
		end
		if (index == 1) then
			button:SetPoint("TOPLEFT",5,-6);
		else
			button:SetPoint("TOPLEFT",listButtons2[index - 1],"BOTTOMLEFT");
		end
		button:Show();
	end
	for i = (#options + 1), #listButtons2 do
		listButtons2[i]:Hide();
	end
end

f.outline:SetHeight(max(6,#listButtons) * 18 + 12);

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
		frame = ACBFactory[type](index);
		if (not frames[type]) then
			frames[type] = {};
		end
		tinsert(frames[type],frame);
	end
	-- Return Frame
	return frame;
end

local xExtraOffsets = { ["Check"] = 10, ["Slider"] = 18, ["Color"] = 14, ["DropDown"] = 120 };
local yExtraOffsets = { ["Check"] = 0, ["Slider"] = 4, ["Color"] = 6, ["DropDown"] = 0 };

local function EntryInTable(table,value)
	for index, name in ipairs(table) do
		if (name == value) then
			return 1;
		end
	end
	return;
end

-- Build Page
function f:BuildCategoryPage()
	local frame;
	local frameUseCount = {};
	local yOffset = -38;
	-- Loop Through Options
	f.updatingOptions = 1;
	for index, table in ipairs(options[subPage]) do
		if (not table.restrict) or (EntryInTable(table.restrict,f.activeBar.token)) then
			-- Az: debug
			if (cfg[f.activeBar.token][table.var] == nil) then
				AzMsg("|2Warning:|r the variable |1"..table.var.."|r for the |1"..f.activeBar.token.."|r frame, was |1nil|r.");
			end
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
				frame.slider:SetValue(cfg[f.activeBar.token][table.var]);
				frame.edit:SetNumber(cfg[f.activeBar.token][table.var]);
				frame.low:SetText(table.min);
				frame.high:SetText(table.max);
			-- check
			elseif (table.type == "Check") then
				frame:SetHitRectInsets(0,frame.text:GetWidth() * -1,0,0);
				frame:SetChecked(cfg[f.activeBar.token][table.var]);
			-- color
			elseif (table.type == "Color") then
				frame:SetHitRectInsets(0,frame.text:GetWidth() * -1,0,0);
				if (table.subType == 2) then
					frame.texture:SetVertexColor(f:HexStringToRGBA(cfg[f.activeBar.token][table.var]));
				else
				frame.texture:SetVertexColor(unpack(cfg[f.activeBar.token][table.var]));
				end
			-- dropdown
			elseif (table.type == "DropDown") then
				f.lastDropDown = frame;
				UIDropDownMenu_Initialize(frame,table.init or AzCastBarDropDowns.Default);
				UIDropDownMenu_SetWidth(160,frame);
				UIDropDownMenu_SetText("|cff20ff20Select...",frame);
				if (table.var) then
					UIDropDownMenu_SetSelectedValue(frame,cfg[f.activeBar.token][table.var]);
				end
			end
			-- Anchor the Frame
			frame:ClearAllPoints();
			frame:SetPoint("TOPLEFT",f.outline,"TOPRIGHT",xExtraOffsets[table.type] + (table.x or 0),yOffset);
			yOffset = (yOffset - frame:GetHeight() - yExtraOffsets[table.type] - (table.y or 0));
			-- Show
			frame:Show();
		end
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

--------------------------------------------------------------------------------------------------------
--                                                Misc                                                --
--------------------------------------------------------------------------------------------------------