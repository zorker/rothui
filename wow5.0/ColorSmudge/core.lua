
  ---------------------------------------------
  --  ColorSmudge
  ---------------------------------------------

  --  Color destruction derby
  --  zork - 2013

  -----------------------------------------
  -- VARIABLES
  -----------------------------------------

  --get the addon namespace
  local addon, ns = ...
  
  local CF = CreateFrame
  local CPF = ColorPickerFrame
  local floor = floor

  local backdrop = {
    bgFile = "",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = false,
    tileSize = 16,
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 },
  }
  
  -----------------------------------------
  -- FUNCTIONS
  -----------------------------------------  
  
  --basic fontstring func
  local CreateBasicFontString = function(parent, name, layer, template, text)
    local fs = parent:CreateFontString(name,layer,template)
    fs:SetText(text)
    return fs
  end
  
  --basic color picker func
  local CreateBasicColorPicker = function(parent, name, title, width, height)
    local picker = CF("Button", name, parent)
    picker:SetSize(width, height)
    picker:SetBackdrop(backdrop)
    picker:SetBackdropBorderColor(0.5,0.5,0.5)
    --texture
    local texture = picker:CreateTexture(nil,"BACKGROUND",nil,-7)
    --texture:SetAllPoints(picker)
    texture:SetPoint("TOPLEFT",4,-4)
    texture:SetPoint("BOTTOMRIGHT",-4,4)
    texture:SetTexture(1,1,1)
    picker.texture = texture
    picker.text = CreateBasicFontString(picker,nil,nil,"GameFontNormal",title)
    picker.text:SetTextColor(1,1,1)
    picker.text:SetPoint("BOTTOM", picker, "TOP", 0, 5)
    picker.disabled = false
    function picker:Trash() end
    function picker:Callback(color)
      local r,g,b
      if color then r,g,b = unpack(color) else r,g,b = CPF:GetColorRGB() end
      picker.texture:SetVertexColor(r,g,b)
      picker:OnColorUpdate(r,g,b)
    end
    function picker:OnClick()
      --we need to reset the functions incase another picker is clicked, otherwise the old functions will still be used
      CPF.func, CPF.opacityFunc, CPF.cancelFunc = self.Trash, self.Trash, self.Trash
      local r,g,b,a = self.texture:GetVertexColor()
      CPF:SetColorRGB(r,g,b)
      CPF.hasOpacity, CPF.opacity = nil, a
      CPF.previousValues = {r,g,b,a}
      CPF.func, CPF.opacityFunc, CPF.cancelFunc = self.Callback, self.Callback, self.Callback
      CPF:Hide() -- Need to run the OnShow handler.
      CPF:Show()
    end
    picker:SetScript("OnClick", picker.OnClick)
    return picker
  end
  
  local CreateBasicSlider = function(parent, name, title, minVal, maxVal, valStep)
    local slider = CF("Slider", name, parent, "OptionsSliderTemplate")
    local editbox = CF("EditBox", "$parentEditBox", slider, "InputBoxTemplate")
    slider:SetMinMaxValues(minVal, maxVal)
    slider:SetValue(minVal)
    slider:SetValueStep(valStep)
    slider.text = _G[name.."Text"]
    slider.text:SetText(title)
    slider.textLow = _G[name.."Low"]
    slider.textHigh = _G[name.."High"]
    slider.textLow:SetText(floor(minVal))
    slider.textHigh:SetText(floor(maxVal))
    slider.textLow:SetTextColor(0.4,0.4,0.4)
    slider.textHigh:SetTextColor(0.4,0.4,0.4)
    editbox:SetSize(50,30)
    editbox:ClearAllPoints()
    editbox:SetPoint("TOP", slider, "BOTTOM", 0, -5)
    editbox:SetText(slider:GetValue())
    editbox:SetAutoFocus(false)
    slider:SetScript("OnValueChanged", function(self,value)
      self.editbox:SetText(floor(value))
    end)
    editbox:SetScript("OnTextChanged", function(self)
      local value = self:GetText()
      if tonumber(value) then
        if floor(self:GetParent():GetValue()) ~= floor(value) then
          self:GetParent():SetValue(floor(value))
        end
      end
    end)
    editbox:SetScript("OnEnterPressed", function(self)
      local value = self:GetText()
      if tonumber(value) then
        self:GetParent():SetValue(floor(value))
        self:ClearFocus()
      end
    end)
    slider.editbox = editbox
    return slider
  end
  
  local frame = CF("ColorSelect", addon.."TextureFrame", UIParent)
  frame:SetSize(180,50)
  frame:SetPoint("CENTER",0,-30)
  frame:SetBackdrop(backdrop)
  frame:SetBackdropBorderColor(0.5,0.5,0.5)
  frame.colorA = {r=1,g=1,b=1}
  frame.colorB = {r=1,g=1,b=1}
  frame.colorC = {r=1,g=1,b=1}
  frame.percentage = 0
  --texture
  local texture = frame:CreateTexture(nil,"BACKGROUND",nil,-7)
  texture:SetPoint("TOPLEFT",4,-4)
  texture:SetPoint("BOTTOMRIGHT",-4,4)
  texture:SetTexture(1,1,1)
  frame.texture = texture  
  function frame:UpdateColor()
    self:SetColorRGB(self.colorA.r, self.colorA.g, self.colorA.b)
    self.colorA.h, self.colorA.s, self.colorA.v = self:GetColorHSV()
    self:SetColorRGB(self.colorB.r, self.colorB.g, self.colorB.b)
    self.colorB.h, self.colorB.s, self.colorB.v = self:GetColorHSV()
    --check if the angle between the two H values is > 180
    if abs(self.colorA.h-self.colorB.h) > 180 then
      local radius = (360-abs(self.colorA.h-self.colorB.h))*self.percentage/100
      --calculate the 360° breakpoint
      if self.colorA.h < self.colorB.h then
        self.colorC.h = floor(self.colorA.h-radius)
        if self.colorC.h < 0 then
          self.colorC.h = 360+self.colorC.h
        end
      else
        self.colorC.h = floor(self.colorA.h+radius)
        if self.colorC.h > 360 then
          self.colorC.h = self.colorC.h-360
        end
      end
    else
      self.colorC.h = floor(self.colorA.h-(self.colorA.h-self.colorB.h)*self.percentage/100)
    end    
    self.colorC.s = self.colorA.s-(self.colorA.s-self.colorB.s)*self.percentage/100
    self.colorC.v = self.colorA.v-(self.colorA.v-self.colorB.v)*self.percentage/100
    self:SetColorHSV(self.colorC.h, self.colorC.s, self.colorC.v)
    self.colorC.r, self.colorC.g, self.colorC.b = self:GetColorRGB()
    self.texture:SetVertexColor(self.colorC.r, self.colorC.g, self.colorC.b)    
  end
 
  local picker1 = CreateBasicColorPicker(UIParent, addon.."ColorPicker1", "ColorPicker1", 75, 25)
  function picker1:OnColorUpdate(r,g,b)
    frame.colorA = {r=r,g=g,b=b}
    frame:UpdateColor()
  end
  picker1:SetPoint("CENTER",-150,-100)
  
  local picker2 = CreateBasicColorPicker(UIParent, addon.."ColorPicker2", "ColorPicker2", 75, 25)
  function picker2:OnColorUpdate(r,g,b)
    frame.colorB = {r=r,g=g,b=b}
    frame:UpdateColor()
  end
  picker2:SetPoint("CENTER",150,-100)
  
  local slider1 = CreateBasicSlider(UIParent, addon.."ColorSlider1", "ColorSlider1", 0, 100, 1)
  slider1:HookScript("OnValueChanged", function(self,value)
    value = floor(value)
    frame.percentage = value
    frame:UpdateColor()
  end)
  slider1:SetPoint("CENTER",0,-100)