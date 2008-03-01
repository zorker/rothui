local _G = getfenv(0);
local cfg = TipTac_Config;
TTOFactory = {};

local function ChangeSetting(var,value)
	cfg[var] = value;
	TipTac:ApplySettings();
end

--------------------------------------------------------------------------------------------------------
--                                            Slider Frame                                            --
--------------------------------------------------------------------------------------------------------

-- EditBox Enter Pressed
local function SliderEdit_OnEnterPressed(self)
	self:GetParent().slider:SetValue(self:GetNumber());
end

-- Slider Value Changed
local function Slider_OnValueChanged(self)
	if (not TipTacOptions.updatingOptions) then
		self:GetParent().edit:SetNumber(self:GetValue());
		ChangeSetting(self:GetParent().option.var,self:GetValue());
	end
end

-- OnMouseWheel
local function Slider_OnMouseWheel(self)
	self:SetValue(self:GetValue() + self:GetParent().option.step * arg1);
end

-- New Slider
TTOFactory.Slider = function(index)
	local f = CreateFrame("Frame",nil,TipTacOptions);
	f:SetWidth(292);
	f:SetHeight(32);

	f.edit = CreateFrame("EditBox","TipTacOptionsEdit"..index,f,"InputBoxTemplate");
	f.edit:SetWidth(45);
	f.edit:SetHeight(21);
	f.edit:SetPoint("BOTTOMLEFT");
	f.edit:SetScript("OnEnterPressed",SliderEdit_OnEnterPressed);
	f.edit:SetAutoFocus(nil);
	f.edit:SetMaxLetters(4);

	f.slider = CreateFrame("Slider","TipTacOptionsSlider"..index,f,"OptionsSliderTemplate");
	f.slider:SetPoint("TOPLEFT",f.edit,"TOPRIGHT",5,-3);
	f.slider:SetPoint("BOTTOMRIGHT",0,-2);
	f.slider:SetScript("OnValueChanged",Slider_OnValueChanged);
	f.slider:SetScript("OnMouseWheel",Slider_OnMouseWheel);
	f.slider:EnableMouseWheel(1);

	f.text = _G["TipTacOptionsSlider"..index.."Text"];
	f.low = _G["TipTacOptionsSlider"..index.."Low"];
	f.low:ClearAllPoints();
	f.low:SetPoint("BOTTOMLEFT",f.slider,"TOPLEFT",0,0);
	f.high = _G["TipTacOptionsSlider"..index.."High"];
	f.high:ClearAllPoints();
	f.high:SetPoint("BOTTOMRIGHT",f.slider,"TOPRIGHT",0,0);

	return f;
end

--------------------------------------------------------------------------------------------------------
--                                           Check Buttons                                            --
--------------------------------------------------------------------------------------------------------

local function CheckButton_OnEnter(self)
	self.text:SetTextColor(1,1,1);
	if (self.option.tip) then
		GameTooltip:SetOwner(self,"ANCHOR_RIGHT");
		GameTooltip:SetText(self.option.tip,nil,nil,nil,nil,1);
	end
end

local function CheckButton_OnLeave(self)
	self.text:SetTextColor(1,0.82,0);
	GameTooltip:Hide();
end

local function CheckButton_OnClick(self)
	ChangeSetting(self.option.var,self:GetChecked() == 1);
end

-- New CheckButton
TTOFactory.Check = function(index)
	local f = CreateFrame("CheckButton","TipTacCheckButton"..index,TipTacOptions,"OptionsCheckButtonTemplate");
	f:SetWidth(26);
	f:SetHeight(26);
	f:SetScript("OnEnter",CheckButton_OnEnter);
	f:SetScript("OnClick",CheckButton_OnClick);
	f:SetScript("OnLeave",CheckButton_OnLeave);

	f.text = _G["TipTacCheckButton"..index.."Text"];

	return f;
end

--------------------------------------------------------------------------------------------------------
--                                           Color Buttons                                            --
--------------------------------------------------------------------------------------------------------

-- Color Picker Function
local function ColorButton_ColorPickerFunc(prevVal,...)
	local r, g, b, a;
	if (prevVal) then
		r, g, b, a  = unpack(prevVal);
	else
		r, g, b = ColorPickerFrame:GetColorRGB();
		a = (1 - OpacitySliderFrame:GetValue());
	end
	ColorPickerFrame.frame.texture:SetVertexColor(r,g,b,a);
	if (ColorPickerFrame.frame.option.subType == 2) then
		ChangeSetting(ColorPickerFrame.frame.option.var,format("|c%.2x%.2x%.2x%.2x",a * 255,r * 255,g * 255,b * 255));
	else
		ChangeSetting(ColorPickerFrame.frame.option.var,{ r, g, b, a });
	end
end

-- OnClick
local function ColorButton_OnClick(self,button)
	local r, g, b, a;
	if (self.option.subType == 2) then
		r, g, b, a = TipTacOptions:HexStringToRGBA(cfg[self.option.var]);
	else
		r, g, b, a = unpack(cfg[self.option.var]);
	end

	ColorPickerFrame.frame = self;
	ColorPickerFrame.func = ColorButton_ColorPickerFunc;
	ColorPickerFrame.cancelFunc = ColorButton_ColorPickerFunc;
	ColorPickerFrame.opacityFunc = ColorButton_ColorPickerFunc;
	ColorPickerFrame.hasOpacity = true;
	ColorPickerFrame.opacity = (1 - a);
	ColorPickerFrame.previousValues = { r, g, b, a };

	OpacitySliderFrame:SetValue(1 - a);
	ColorPickerFrame:SetColorRGB(r,g,b);
	ColorPickerFrame:Show();
end

-- OnEnter
local function ColorButton_OnEnter(self)
	self.text:SetTextColor(1,1,1);
	self.border:SetVertexColor(1,1,0);
	if (self.option.tip) then
		GameTooltip:SetOwner(self,"ANCHOR_RIGHT");
		GameTooltip:SetText(self.option.tip,nil,nil,nil,nil,1);
	end
end

-- OnLeave
local function ColorButton_OnLeave(self)
	self.text:SetTextColor(1,0.82,0);
	self.border:SetVertexColor(1,1,1);
	GameTooltip:Hide();
end

-- New ColorButton
TTOFactory.Color = function(index)
	local f = CreateFrame("Button",nil,TipTacOptions);
	f:SetWidth(18);
	f:SetHeight(18);
	f:SetScript("OnEnter",ColorButton_OnEnter);
	f:SetScript("OnLeave",ColorButton_OnLeave)
	f:SetScript("OnClick",ColorButton_OnClick);

	f.texture = f:CreateTexture();
	f.texture:SetPoint("TOPLEFT",-1,1);
	f.texture:SetPoint("BOTTOMRIGHT",1,-1);
	f.texture:SetTexture("Interface\\ChatFrame\\ChatFrameColorSwatch");
	f:SetNormalTexture(f.texture);

	f.border = f:CreateTexture(nil,"BACKGROUND");
	f.border:SetPoint("TOPLEFT");
	f.border:SetPoint("BOTTOMRIGHT");
	f.border:SetTexture(1,1,1,1);

	f.text = f:CreateFontString(nil,"ARTWORK","GameFontNormal");
	f.text:SetPoint("LEFT",f,"RIGHT",4,1);

	return f;
end

--------------------------------------------------------------------------------------------------------
--                                           DropDown Frame                                           --
--------------------------------------------------------------------------------------------------------

-- New DropDown
TTOFactory.DropDown = function(index)
	local f = CreateFrame("Frame","TipTacDropDown"..index,TipTacOptions,"UIDropDownMenuTemplate");

	f.button = _G["TipTacDropDown"..index.."Button"];
	f.button:SetHitRectInsets(-150,0,0,0);

	f.text = f:CreateFontString(nil,"ARTWORK","GameFontNormalSmall");
	f.text:SetPoint("LEFT",-106,3);

	return f;
end