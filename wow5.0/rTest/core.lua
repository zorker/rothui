
local UIP = UIParent
local CF = CreateFrame
local _G = _G
local unpack = unpack

local addon = CF("Frame", "rTestFullscreenFrame", UIP)
addon:SetFrameStrata("FULLSCREEN")
addon:SetAllPoints()
addon:EnableMouse(1)

local bg = addon:CreateTexture(nil, "BACKGROUND", nil, -8)
bg:SetTexture(255,255,222)
bg:SetAllPoints()

--rTestReloadButton // UIPanelButtonTemplate
local button = CF("Button", "rTestReloadButton", addon, "UIPanelButtonTemplate")
button:SetPoint("BOTTOMLEFT", 5, 5)
local text = _G[button:GetName().."Text"]
text:SetText("Reload UI")
button:SetWidth(text:GetStringWidth()+30)
button:SetHeight(text:GetStringHeight()+20)
button:HookScript("OnClick", ReloadUI)

--rTestHideButton // UIPanelButtonTemplate
local button = CF("Button", "rTestHideButton", addon, "UIPanelButtonTemplate")
button:SetPoint("LEFT", rTestReloadButton, "RIGHT", 0, 0)
local text = _G[button:GetName().."Text"]
text:SetText("Hide")
button:SetWidth(text:GetStringWidth()+30)
button:SetHeight(text:GetStringHeight()+20)
button:HookScript("OnClick", function() addon:Hide() end)

local text = addon:CreateFontString(nil, nil, "GameFontBlackMedium")
text:SetText("rTest 0.1")
text:SetPoint("LEFT", rTestHideButton, "RIGHT", 5, 0)

--console
local sf = CF("ScrollFrame", "rTestConsole", addon, "InputScrollFrameTemplate")
sf:SetPoint("BOTTOMRIGHT", -5, 5)
sf:SetWidth(600)
sf:SetHeight(100)

local console = sf.EditBox
console:SetWidth(sf:GetWidth())
console:SetMaxLetters(0)

console.log = function(text) 
  console:SetText(console:GetText().."\n"..GetTime()..": "..text)
end

--button helper
local buttonHelper = function(name, parent, template, pointparent, point) 
  local button = CF("Button", name, parent, template)
  if point then
    button:SetPoint(unpack(point))
  elseif pointparent then
    button:SetPoint("TOPLEFT", pointparent, "BOTTOMLEFT", 0, -5)
  end
  local text = _G[button:GetName().."Text"]-- or addon:CreateFontString(nil, nil, "GameFontNormal")
  if text then
    text:SetText(template)
    button:SetWidth(text:GetStringWidth()+30)
    button:SetHeight(text:GetStringHeight()+20)
  end
  if button:GetWidth() == 0 then
    button:SetSize(30,30)
  end
  button:HookScript("OnClick", function() PlaySound("INTERFACESOUND_LOSTTARGETUNIT") end)
  return button
end

local prevButton = nil
local templateList = {
  { template = "UIPanelButtonTemplate",  point = {"TOPLEFT", 5, -5} },
  { template = "UIMenuButtonStretchTemplate" },
  { template = "UIGoldBorderButtonTemplate" },
  { template = "UIPanelButtonGrayTemplate" },
  { template = "UIPanelCloseButton" },
  { template = "UIPanelScrollUpButtonTemplate" },
  { template = "UIPanelScrollDownButtonTemplate" },
  { template = "TabButtonTemplate" },
  { template = "GameMenuButtonTemplate" },
  { template = "UIServiceButtonTemplate" },
  { template = "UIPanelInfoButton" },
  { template = "UIPanelSquareButton" },
  { template = "UIPanelLargeSilverButton" },
  --{ template = "TruncatedButtonTemplate" },
  { template = "MagicButtonTemplate" },
  --{ template = "MainHelpPlateButton" },
  --{ template = "HelpPlateButton" },
  { template = "UIDropDownMenuButtonTemplate" },
  { template = "UIDropDownListTemplate" },    
  { template = "OptionsFrameTabButtonTemplate" },  
  { template = "OptionsListButtonTemplate" },    
  { template = "OptionsButtonTemplate" },    
   
}

for i,obj in ipairs(templateList) do
  local button = buttonHelper("rTestButton"..i, addon, obj.template, prevButton, obj.point or nil)
  console.log("loading button "..button:GetName().." with template "..obj.template)
  prevButton = button  
end


--frame helper
local frameHelper = function(type, name, parent, template, pointparent, point) 
  local frame = CF(type, name, parent, template)
  if point then
    frame:SetPoint(unpack(point))
  elseif pointparent then
    frame:SetPoint("TOPLEFT", pointparent, "BOTTOMLEFT", 0, -5)
  end
  local text = _G[frame:GetName().."Text"]-- or addon:CreateFontString(nil, nil, "GameFontNormal")
  if text then
    text:SetText(template)
  end
  if frame:GetHeight() == 0 then
    if type == "ScrollFrame" or type == "Slider" then
      frame:SetHeight(100)
    else
      frame:SetHeight(30)
    end
    console.log("heiht of type "..name.." is 0")
  end
  if frame:GetWidth() == 0 then
    frame:SetWidth(200)
    console.log("width of type "..name.." is 0")
  end
  if not frame:IsVisible() then
    console.log(name.." is not visible")
  end
  return frame
end

local prevFrame = nil
local templateList = {
  { type = "Slider", template = "OptionsSliderTemplate",  point = {"TOPLEFT", 300, -25} },
  { type = "EditBox", template = "InputBoxTemplate", point = {"TOPLEFT", 400, -25} },   
  
  { type = "Slider", template = "UIPanelScrollBarTemplate",  point = {"TOPLEFT", 300, -100} },  
  { type = "Slider", template = "UIPanelScrollBarTrimTemplate",  point = {"TOPLEFT", 350, -100} },
  { type = "Slider", template = "UIPanelScrollBarTemplateLightBorder",  point = {"TOPLEFT", 400, -100} },
  { type = "Slider", template = "MinimalScrollBarTemplate",  point = {"TOPLEFT", 450, -100} },   
  
  { type = "CheckButton", template = "OptionsBaseCheckButtonTemplate",  point = {"TOPLEFT", 350, -350} },   
  { type = "CheckButton", template = "OptionsCheckButtonTemplate", },   
  { type = "CheckButton", template = "OptionsSmallCheckButtonTemplate", },   
  { type = "CheckButton", template = "UICheckButtonTemplate", },   
  { type = "CheckButton", template = "UIRadioButtonTemplate", },   
  
  { type = "EditBox", template = "InputBoxTemplate", },   
  { type = "EditBox", template = "SearchBoxTemplate", },   
  { type = "EditBox", template = "BagSearchBoxTemplate", },   

  { type = "ScrollFrame", template = "InputScrollFrameTemplate"},   
  
  --{ type = "ScrollFrame", template = "UIPanelScrollFrameCodeTemplate", point = {"TOPLEFT", 550, -25} },  
  { type = "ScrollFrame", template = "UIPanelScrollFrameTemplate", point = {"TOPLEFT", 500, -100}  },  
  { type = "ScrollFrame", template = "UIPanelScrollFrameTemplate2", point = {"TOPLEFT", 550, -100} },  
  { type = "ScrollFrame", template = "MinimalScrollFrameTemplate", point = {"TOPLEFT", 600, -100} },  
  { type = "ScrollFrame", template = "FauxScrollFrameTemplate", point = {"TOPLEFT", 650, -100} },  
  { type = "ScrollFrame", template = "FauxScrollFrameTemplateLight", point = {"TOPLEFT", 700, -100} },  
  { type = "ScrollFrame", template = "ListScrollFrameTemplate", point = {"TOPLEFT", 750, -100} },  
  
}

for i,obj in ipairs(templateList) do
  local frame = frameHelper(obj.type, "rTest"..obj.type..i, addon, obj.template, prevFrame, obj.point or nil)
  console.log("loading "..obj.type.." "..frame:GetName().." with template "..obj.template)
  prevFrame = frame  
end

local slider = rTestSlider1

local editbox = rTestEditBox2

editbox:SetWidth(30)
editbox:ClearAllPoints()
editbox:SetPoint("LEFT", slider, "RIGHT", 15, 0)

slider:SetMinMaxValues(1, 100)
slider:SetValue(1)
slider:SetValueStep(1)
slider:SetScript("OnValueChanged", function(self,value)
  console.log(self:GetName().." value: "..value)
  editbox:SetText(floor(value))
end)

editbox:SetScript("OnEnterPressed", function(self)
  slider:SetValue(floor(self:GetText()))
end)

--color picker

local function showColorPicker(r,g,b,a,callback)
  ColorPickerFrame:SetParent(addon)
  ColorPickerFrame:SetColorRGB(r,g,b)
  ColorPickerFrame.hasOpacity, ColorPickerFrame.opacity = (a ~= nil), a
  ColorPickerFrame.previousValues = {r,g,b,a}
  ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = callback, callback, callback
  ColorPickerFrame:Hide() -- Need to run the OnShow handler.
  ColorPickerFrame:Show()
end
     
--frame
local f = CF("FRAME",nil,addon)
f:SetSize(50,50)
f:SetPoint("RIGHT",-20,0)
--texture
local t = f:CreateTexture(nil,"BACKGROUND",nil,-7)
t:SetAllPoints(f)
t:SetTexture(1,1,1)
t:SetVertexColor(1,0,1) --bugfix. setting color directly on settexture will result in a bug
f.tex = t      
--recolor callback function
f.callback = function(color)
  local r,g,b,a
  if color then
    r,g,b,a = unpack(color)
  else
    r,g,b = ColorPickerFrame:GetColorRGB()
    
    a = OpacitySliderFrame:GetValue()
  end
  f.tex:SetVertexColor(r,g,b,a)
end
f:EnableMouse(true)
f:SetScript("OnMouseDown", function(self,button,...)
  if button == "LeftButton" then
    local r,g,b,a = self.tex:GetVertexColor()
    showColorPicker(r,g,b,a,self.callback)
  end
end)

print("hello world")