AzCastBarDropDowns = {};

local cfg = AzCastBar_Config;
local info = {};

-- Shared Media
local SML = LibStub and LibStub("LibSharedMedia-2.0",1) or nil;


-- DropDown Lists
AzCastBarDropDowns.FontFlags = {
	["None"] = "",
	["Outline"] = "OUTLINE",
	["Thick Outline"] = "THICKOUTLINE",
};

--------------------------------------------------------------------------------------------------------
--                                        Default DropDown Init                                       --
--------------------------------------------------------------------------------------------------------

local function Default_SelectValue(arg1,arg2)
	UIDropDownMenu_SetSelectedValue(arg1,this.value);
	cfg[AzCastBarOptions.activeBar.token][arg1.option.var] = this.value;
	AzCastBar_ApplyBarSettings(AzCastBarOptions.activeBar);
end

function AzCastBarDropDowns:Default()
	local dropDown = AzCastBarOptions.lastDropDown or this:GetParent();
	info.func = Default_SelectValue;
	info.arg1 = dropDown;
	for text, option in pairs(dropDown.option.list) do
		info.text = text;
		info.value = option;
		info.checked = (cfg[AzCastBarOptions.activeBar.token][dropDown.option.var] == option);
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


do
	local AZCB_Textures = {
		--"Interface\\Addons\\AzCastBar\\Textures\\Test",
		"Interface\\Addons\\AzCastBar\\Textures\\HorizontalFade",
		"Interface\\Addons\\AzCastBar\\Textures\\Pale",
		"Interface\\Addons\\AzCastBar\\Textures\\Lines",
		"Interface\\Addons\\AzCastBar\\Textures\\SmoothBar",
		"Interface\\Addons\\AzCastBar\\Textures\\Streamline",
		"Interface\\Addons\\AzCastBar\\Textures\\Streamline-Inverted",
		"Interface\\Addons\\rTextures\\Rounded",
	};
	local textureName;
	for _, texture in ipairs(AZCB_Textures) do
		textureName = texture:match("\\([^\\]+)$");
		if (SML) then
			SML:Register("statusbar","|cffffff00"..textureName,texture);
		else
			SharedMediaLibSubstitute["statusbar"][textureName] = texture;
		end
	end
end

function AzCastBarDropDowns:SharedMediaLib()
	local dropDown = AzCastBarOptions.lastDropDown or this:GetParent();
	local query = dropDown.option.media;
	info.func = Default_SelectValue;
	info.arg1 = dropDown;

	if (SML) then
		for _, name in pairs(SML:List(query)) do
			info.text = name;
			info.value = SML:Fetch(query,name);
			info.checked = (cfg[AzCastBarOptions.activeBar.token][dropDown.option.var] == name);
			UIDropDownMenu_AddButton(info);
		end
	else
		for name, value in pairs(SharedMediaLibSubstitute[query]) do
			info.text = name;
			info.value = value;
			info.checked = (cfg[AzCastBarOptions.activeBar.token][dropDown.option.var] == value);
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
		fontFace = "Fonts\\FRIZQT__.TTF",
		fontSize = 12,
		fontFlags = "NORMAL",
		showTarget = "second",
		tipTacColor = { 0.1, 0.1, 0.2, 1.0 };
		tipTacBorderColor = { 0.3, 0.3, 0.4, 1.0 };
		tipColor = { 0.1, 0.1, 0.2, 1.0 };
		tipBorderColor = { 0.3, 0.3, 0.4, 1.0 };
		colNormal = "|cff25c1eb";
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
		colNormal = "|cff00aaff";
		--colSameGuild = "|cffff32ff";
		colRace = "|cffddeeaa";
		colLevel = "|cffffcc00";
		anchorTypeUnit = "mouse",
		anchorPointUnit = "BOTTOM",
	},
	-- TipBuddy Layout
	["TipBuddy"] = {
		fontFace = "Fonts\\FRIZQT__.TTF",
		fontSize = 12,
		fontFlags = "NORMAL",
		showTarget = "second",
		tipTacColor = { 0.1, 0.22, 0.35, 0.78 };
		tipTacBorderColor = { 0.8, 0.8, 0.9, 1.0 };
		tipColor = { 0.1, 0.1, 0.1, 0.8 };
		tipBorderColor = { 0.8, 0.8, 0.9, 1.0 };
		colNormal = "|cff25c1eb";
		colSameGuild = "|cffff32ff";
		colRace = "|cffffffff";
		colLevel = "|cffc0c0c0";
	},
	["Test"] = {
		tipTacColor = { 0.1,0.1,0.2,1 };
		tipTacBorderColor = { 0.1, 0.1, 0.1, 1.0 };
		tipColor = { 0.1,0.1,0.2,1 };
		tipBorderColor = { 0.1, 0.1, 0.1, 1.0 };
	}
};

local function Layout_SelectValue(arg1,arg2)
	for name, value in pairs(presets[this.value]) do
		cfg[name] = value;
	end
--	TipTac_ApplySettings();
	AzCastBarOptions:BuildCategoryPage();
	UIDropDownMenu_SetSelectedValue(arg1,this.value);
end

function AzCastBarDropDowns:Layouts()
	info.func = Layout_SelectValue;
	info.arg1 = this:GetParent();
	for name in pairs(presets) do
		info.text = name;
		info.value = name;
		info.checked = nil;
		UIDropDownMenu_AddButton(info);
	end
end