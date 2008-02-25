local f = AzCastBarOptions;
local p = CreateFrame("Frame",nil,f);
local cfg = AzCastBar_Config;

--------------------------------------------------------------------------------------------------------
--                                      Profiles: Button Function                                     --
--------------------------------------------------------------------------------------------------------

-- CopyTable
local function CopyTable(source)
	local dest = {};
	for k, v in pairs(source) do
		if (type(v) == "table") then
			dest[k] = CopyTable(v);
		else
			dest[k] = v;
		end
	end
	return dest;
end

-- Load
local function Button_Load_OnClick(self,button)
	for n, v in pairs(cfg) do
		cfg[n] = nil;
	end
	for token, table in pairs(AzCastBar_Profiles[p.edit:GetText()]) do
		for _, bar in ipairs(AzCastBar_Frames) do
			if (token == bar.token) then
				cfg[token] = CopyTable(table);
			end
		end
	end
	AzCastBar_CheckSettings();
	AzCastBar_ApplyAllSettings();
	f:BuildCategoryPage();
end

-- Save
local function Button_Save_OnClick(self,button)
	AzCastBar_Profiles[p.edit:GetText()] = CopyTable(cfg);
	p:BuildProfileList();
end

-- Delete
local function Button_Delete_OnClick(self,button)
	AzCastBar_Profiles[p.edit:GetText()] = nil;
	p:BuildProfileList();
end

-- Text Changed
local function Edit_OnTextChanged(self)
	local name = p.edit:GetText();
	-- save
	if (name == "") then
		p.btnSave:Disable();
	else
		p.btnSave:Enable();
	end
	-- load & delete
	if (AzCastBar_Profiles[name]) then
		p.btnLoad:Enable();
		p.btnDelete:Enable();
	else
		p.btnLoad:Disable();
		p.btnDelete:Disable();
	end
end

--------------------------------------------------------------------------------------------------------
--                                       Profiles: Create Window                                      --
--------------------------------------------------------------------------------------------------------

p:SetWidth(198);
p:SetHeight(256);
p:SetPoint("CENTER",UIParent);
p:SetBackdrop(f:GetBackdrop());
p:SetBackdropColor(0.1,0.22,0.35,1);
p:SetBackdropBorderColor(0.1,0.1,0.1,1);
p:EnableMouse(1);
p:SetMovable(1);
p:SetToplevel(1);
p:SetClampedToScreen(1);
p:SetScript("OnMouseDown",function() p:StartMoving() end);
p:SetScript("OnMouseUp",function() p:StopMovingOrSizing(); end);
p:Hide();

p.header = p:CreateFontString(nil,"ARTWORK","PVPInfoTextFont");
p.header:SetPoint("TOPLEFT",12,-12);

p.close = CreateFrame("Button",nil,p,"UIPanelCloseButton");
p.close:SetWidth(24);
p.close:SetHeight(24);
p.close:SetPoint("TOPRIGHT",-5,-5);
p.close:SetScript("OnClick",function() p:Hide(); end)

p.outline = CreateFrame("Frame",nil,p);
p.outline:SetHeight(158);
p.outline:SetPoint("TOPLEFT",12,-38);
p.outline:SetPoint("BOTTOMRIGHT",-12,62);
p.outline:SetBackdrop(f.outline:GetBackdrop());
p.outline:SetBackdropColor(0.1,0.1,0.2,1);
p.outline:SetBackdropBorderColor(0.8,0.8,0.9,0.4);

p.edit = CreateFrame("EditBox","AzCastBarOptionsProfilesEdit",p,"InputBoxTemplate");
p.edit:SetWidth(110);
p.edit:SetHeight(21);
p.edit:SetPoint("TOPLEFT",p.outline,"BOTTOMLEFT",7,-1);
p.edit:SetPoint("TOPRIGHT",p.outline,"BOTTOMRIGHT",-2,-1);
p.edit:SetScript("OnTextChanged",Edit_OnTextChanged);
p.edit:SetAutoFocus(nil);

p.btnLoad = CreateFrame("Button",nil,p,"UIPanelButtonTemplate");
p.btnLoad:SetWidth(56);
p.btnLoad:SetHeight(24);
p.btnLoad:SetPoint("BOTTOMLEFT",12,12);
p.btnLoad:SetScript("OnClick",Button_Load_OnClick);
p.btnLoad:SetText("Load");

p.btnSave = CreateFrame("Button",nil,p,"UIPanelButtonTemplate");
p.btnSave:SetWidth(56);
p.btnSave:SetHeight(24);
p.btnSave:SetPoint("LEFT",p.btnLoad,"RIGHT",2,0);
p.btnSave:SetScript("OnClick",Button_Save_OnClick);
p.btnSave:SetText("Save");

p.btnDelete = CreateFrame("Button",nil,p,"UIPanelButtonTemplate");
p.btnDelete:SetWidth(56);
p.btnDelete:SetHeight(24);
p.btnDelete:SetPoint("LEFT",p.btnSave,"RIGHT",2,0);
p.btnDelete:SetScript("OnClick",Button_Delete_OnClick);
p.btnDelete:SetText("Delete");

f.profilesFrame = p;

--------------------------------------------------------------------------------------------------------
--                                        Profiles: Build List                                        --
--------------------------------------------------------------------------------------------------------

local profilesList;
local profilesButtons = {};

local function List_OnClick(self,button)
	p.edit:SetText(profilesList[self.index]);
end

function p:BuildProfileList()
	profilesList = {};
	for entryName in pairs(AzCastBar_Profiles) do
		tinsert(profilesList,entryName);
	end
	sort(profilesList);
	p.header:SetText("Profiles ("..#profilesList..")");
	p:SetHeight(max(8,#profilesList) * 18 + 112);

	local entry;
	for i = 1, #profilesList do
		entry = profilesButtons[i] or f:MakeListButton(profilesButtons,p.outline,List_OnClick);
		entry.text:SetText(profilesList[i]);
		entry.index = i;
		entry:ClearAllPoints();
		if (i == 1) then
			entry:SetPoint("TOPLEFT",5,-6);
		else
			entry:SetPoint("TOPLEFT",profilesButtons[i - 1],"BOTTOMLEFT");
		end
		entry:Show();
	end

	for i = (#profilesList + 1), #profilesButtons do
		profilesButtons[i]:Hide();
	end

	Edit_OnTextChanged();
end

--------------------------------------------------------------------------------------------------------
--                                              Edit Mode                                             --
--------------------------------------------------------------------------------------------------------

-- OnUpdate
local function EditMode_OnUpdate(self,elapsed)
	self.status:SetValue(mod(GetTime(),2));
	self.right:SetText(AzCastBar_FormatTime(mod(GetTime(),2)));
end

-- Stop Moving a Bar
local function EditMode_OnMouseUp(self,button)
	self:StopMovingOrSizing();
	-- Save New Position
	cfg[self.token].left = self:GetLeft();
	cfg[self.token].bottom = self:GetBottom();
	-- Reflect Change in Options if Visible
	if (f:IsVisible()) and (self == f.activeBar) then
		-- az: change this or?
		f:BuildCategoryPage();
	end
end

-- Toggle EditMode
local function EditMode_OnClick(self,button)
	for _, frame in ipairs(AzCastBar_Frames) do
		-- EditMode - ON
		if (self:GetChecked()) then
			if (frame.OnEditMode) then
				frame.OnEditMode(1);
			end

			frame:EnableMouse(1);
			frame:SetMovable(1);

			frame.oldOnMouseDown = frame:GetScript("OnMouseDown");
			frame.oldOnMouseUp = frame:GetScript("OnMouseUp");
			frame.oldOnUpdate = frame:GetScript("OnUpdate");
			frame.oldOnEvent = frame:GetScript("OnEvent");

			frame:SetScript("OnMouseDown",function() this:StartMoving(); end);
			frame:SetScript("OnMouseUp",EditMode_OnMouseUp);
			frame:SetScript("OnUpdate",EditMode_OnUpdate);
			frame:SetScript("OnEvent",nil);

			frame.oldShown = frame:IsShown();
			frame.oldText = frame.left:GetText();
			frame.oldMin, frame.oldMax = frame.status:GetMinMaxValues();

			frame.left:SetText(frame.token.." Bar");
			frame.status:SetMinMaxValues(0,2);
			frame.status:SetStatusBarColor(unpack(frame.cfg.colNormal));
			if (frame.icon) then
				frame.oldIcon = frame.icon:GetTexture();
				frame.icon:SetTexture("Interface\\Icons\\Spell_Nature_UnrelentingStorm");
			end

			frame:SetAlpha(frame.cfg.alpha);
			frame:Show();
		-- EditMode - OFF
		else
			if (not frame.oldShown) then
				frame:Hide();
			end
			frame:EnableMouse(0);
			frame:SetMovable(0);

			frame:SetScript("OnMouseDown",frame.oldOnMouseDown);
			frame:SetScript("OnMouseUp",frame.oldOnMouseUp);
			frame:SetScript("OnUpdate",frame.oldOnUpdate);
			frame:SetScript("OnEvent",frame.oldOnEvent);
			if (frame.oldOnEvent) then
				frame:oldOnEvent("AZCASTBAR_RESET","");
			end

			frame.left:SetText(frame.oldText);
			frame.right:SetText("0.0");
			frame.status:SetMinMaxValues(frame.oldMin,frame.oldMax);
			frame.status:SetValue(0);


			if (frame.icon) then
				frame.icon:SetTexture(frame.oldIcon);
			end

			frame.oldText = nil;
			frame.oldMin, frame.oldMax = nil, nil;
			frame.oldShown = nil;
			frame.oldIcon = nil;
			frame.oldOnMouseDown = nil;
			frame.oldOnMouseUp = nil;
			frame.oldOnUpdate = nil;
			frame.oldOnEvent = nil;

			if (frame.OnEditMode) then
				frame.OnEditMode();
			end
		end
	end
end

-- Edit Mode CheckButton
f.editMode = CreateFrame("CheckButton","AzCastBarCheckButtonEditMode",f,"OptionsCheckButtonTemplate");
f.editMode:SetWidth(26);
f.editMode:SetHeight(26);
f.editMode:SetScript("OnEnter",nil);
f.editMode:SetScript("OnLeave",nil);
f.editMode:SetScript("OnClick",EditMode_OnClick);
f.editMode:SetPoint("BOTTOMLEFT",f.outline2,"BOTTOMRIGHT",8,2);
AzCastBarCheckButtonEditModeText:SetText("Edit Mode");