TipTacDropDowns = {};

local cfg = TipTac_Config;
local info = {};

-- Shared Media
local SML = LibStub and LibStub("LibSharedMedia-2.0",1) or nil;

-- DropDown Lists
TipTacDropDowns.FontFlags = {
	["None"] = "",
	["Outline"] = "OUTLINE",
	["Thick Outline"] = "THICKOUTLINE",
};
TipTacDropDowns.AnchorType = {
	["Normal Anchor"] = "normal",
	["Mouse Anchor"] = "mouse",
	["Smart Anchor"] = "smart",
};

TipTacDropDowns.AnchorPos = {
	["Top"] = "TOP",
	["Top Left"] = "TOPLEFT",
	["Top Right"] = "TOPRIGHT",
	["Bottom"] = "BOTTOM",
	["Bottom Left"] = "BOTTOMLEFT",
	["Bottom Right"] = "BOTTOMRIGHT",
	["Left"] = "LEFT",
	["Right"] = "RIGHT",
	["Center"] = "CENTER",
};

TipTacDropDowns.BarTextFormat = {
	["No text"] = "none",
	["Show percentage"] = "percent",
	["Show values if available"] = "value",
};

--------------------------------------------------------------------------------------------------------
--                                        Default DropDown Init                                       --
--------------------------------------------------------------------------------------------------------

local function Default_SelectValue(arg1,arg2)
	UIDropDownMenu_SetSelectedValue(arg1,this.value);
	cfg[arg1.option.var] = this.value;
	TipTac:ApplySettings();
end

function TipTacDropDowns:Default()
	local dropDown = TipTacOptions.lastDropDown or this:GetParent();
	info.func = Default_SelectValue;
	info.arg1 = dropDown;
	for text, option in pairs(dropDown.option.list) do
		info.text = text;
		info.value = option;
		info.checked = (cfg[dropDown.option.var] == option);
		UIDropDownMenu_AddButton(info);
	end
end

--------------------------------------------------------------------------------------------------------
--                                          Shared Media Lib                                          --
--------------------------------------------------------------------------------------------------------

local SharedMediaLibSubstitute = not SML and {
	["font"] = {
		["Friz Quadrata TT"] = "Fonts\\FRIZQT__.TTF",
		["Arial Narrow"] = "Fonts\\ARIALN.TTF",
		["Skurri"] = "Fonts\\SKURRI.TTF",
		["Morpheus"] = "Fonts\\MORPHEUS.TTF",
	},
	["background"] = {
		["Blizzard Tooltip"] = "Interface\\Tooltips\\UI-Tooltip-Background",
		["Solid"] = "Interface\\ChatFrame\\ChatFrameBackground",
	},
	["border"] = {
		["None"] = "Interface\\None",
		["Blizzard Dialog"]  = "Interface\\DialogFrame\\UI-DialogBox-Border",
		["Blizzard Tooltip"] = "Interface\\Tooltips\\UI-Tooltip-Border",
	},
	["statusbar"] = {
		["Blizzard StatusBar"] = "Interface\\TargetingFrame\\UI-StatusBar",
	},
} or nil;

function TipTacDropDowns:SharedMediaLib()
	local dropDown = TipTacOptions.lastDropDown or this:GetParent();
	local query = dropDown.option.media;
	info.func = Default_SelectValue;
	info.arg1 = dropDown;

	if (SML) then
		for _, name in pairs(SML:List(query)) do
			info.text = name;
			info.value = SML:Fetch(query,name);
			info.checked = (cfg[dropDown.option.var] == name);
			UIDropDownMenu_AddButton(info);
		end
	else
		for name, value in pairs(SharedMediaLibSubstitute[query]) do
			info.text = name;
			info.value = value;
			info.checked = (cfg[dropDown.option.var] == value);
			UIDropDownMenu_AddButton(info);
		end
	end
end

--------------------------------------------------------------------------------------------------------
--                                           Layout Presets                                           --
--------------------------------------------------------------------------------------------------------

local presets = {
	-- TipTac Layout
	["TipTac (Default)"] = {
		showTarget = "second",

		tipTacColor = { 0.1, 0.1, 0.2, 1.0 };
		tipTacBorderColor = { 0.3, 0.3, 0.4, 1.0 };
		tipColor = { 0.1, 0.1, 0.2, 1.0 };
		tipBorderColor = { 0.3, 0.3, 0.4, 1.0 };

		reactColoredBackdrop = false,

		colSameGuild = "|cffff32ff";
		colRace = "|cffffffff";
		colLevel = "|cffc0c0c0";
	},
	-- TipBuddy Layout
	["TipBuddy"] = {
		showTarget = "second",

		tipTacColor = { 0.1, 0.22, 0.35, 0.78 };
		tipTacBorderColor = { 0.8, 0.8, 0.9, 1.0 };
		tipColor = { 0.1, 0.1, 0.1, 0.8 };
		tipBorderColor = { 0.8, 0.8, 0.9, 1.0 };

		colSameGuild = "|cffff32ff";
		colRace = "|cffffffff";
		colLevel = "|cffc0c0c0";
	},
	-- TinyTip Layout
	["TinyTip"] = {
		showTarget = "last",

		tipTacColor = { 0, 0, 0.5, 1.0 };
		tipTacBorderColor = { 0, 0, 0.75, 1.0 };
		tipColor = { 0, 0, 0, 1 };
		tipBorderColor = { 0, 0, 0, 1 };

		reactColoredBackdrop = true,

		colRace = "|cffddeeaa";
		colLevel = "|cffffcc00";
	},
};

local function Layout_SelectValue(arg1,arg2)
	for name, value in pairs(presets[this.value]) do
		cfg[name] = value;
	end
	TipTac:ApplySettings();
	TipTacOptions:BuildCategoryPage();
	UIDropDownMenu_SetSelectedValue(arg1,this.value);
end

function TipTacDropDowns:Layouts()
	info.func = Layout_SelectValue;
	info.arg1 = this:GetParent();
	for name in pairs(presets) do
		info.text = name;
		info.value = name;
		info.checked = nil;
		UIDropDownMenu_AddButton(info);
	end
end