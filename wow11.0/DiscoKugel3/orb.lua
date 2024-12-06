local A, L = ...

local math = math
local pi, halfpi = math.pi, math.pi / 2

local cfg = {}

cfg.orbSize = 200
cfg.orbDebuffGlowColor = {0, 1, 1, 0}
cfg.orbBackgroundColor = {0, 0, 0, 1}
cfg.orbFillingColor = {1, 0, 0, 1}
cfg.orbFillingTexture = 7
cfg.orbModelAlpha = 1
cfg.orbHighlightAlpha = 1

-- update orb func
local function UpdateOrbValue(bar, value)
  local orb = bar:GetParent()
  local min, max = bar:GetMinMaxValues()
  local per = 0
  if max > 0 then
    per = value / max * 100
  end
  local offset = orb.size - per * orb.size / 100
  orb.scrollFrame:SetPoint("TOP", 0, -offset)
  orb.scrollFrame:SetVerticalScroll(offset)
  -- adjust the orb spark in width/height matching the current scrollframe state
  if not orb.spark then
    return
  end
  local multiplier = floor(math.sin(per / 100 * pi) * 100) / 100
  if multiplier <= 0.25 then
    orb.spark:Hide()
  else
    orb.spark:SetWidth(256 * orb.size / 256 * multiplier)
    orb.spark:SetHeight(32 * orb.size / 256 * multiplier)
    orb.spark:SetPoint("TOP", orb.scrollFrame, 0, 16 * orb.size / 256 * multiplier)
    orb.spark:Show()
  end
end

local function CreateColorPickerButton(parent, name, color)
  -- color picker button frame
  local button = CreateFrame("Button", name, parent)
  Mixin(button, BackdropTemplateMixin)
  button.backdropInfo = BACKDROP_TOAST_12_12
  button:ApplyBackdrop()
  button.Center:SetColorTexture(1,1,1)
  button.Center:SetVertexColor(unpack(color))
  -- color picker Callback func
  function button:Callback()
    local r,g,b = ColorPickerFrame:GetColorRGB()
    local a = ColorPickerFrame:GetColorAlpha()
    button.Center:SetVertexColor(r,g,b,a)
    button:UpdateColor(r,g,b,a)
  end
  function button:CallbackCancel()
  end
  -- color picker OnClick func
  button:SetScript("OnClick", function(self)
    local info = {}
    info.r, info.g, info.b, info.opacity = self:GetBackdropColor()
    info.hasOpacity = true
    info.swatchFunc = self.Callback
    info.cancelFunc = self.CallbackCancel
    info.opacityFunc = self.Callback
    ColorPickerFrame:SetupColorPickerAndShow(info)
  end)
  return button
end

local function CreateSliderWithEditbox(orb,name,minValue,maxValue,curValue)
  local slider = CreateFrame("Slider", name .. "Slider", orb, "OptionsSliderTemplate")
  local editbox = CreateFrame("EditBox", "$parentEditBox", slider, "InputBoxTemplate")
  slider.__orb = orb
  slider:SetMinMaxValues(minValue, maxValue)
  slider:SetValue(curValue)
  slider:SetValueStep(1)
  slider.text = _G[slider:GetName() .. "Text"]
  editbox:SetSize(30, 30)
  editbox:ClearAllPoints()
  editbox:SetPoint("LEFT", slider, "RIGHT", 15, 0)
  editbox:SetText(slider:GetValue())
  editbox:SetAutoFocus(false)
  editbox.slider = slider
  slider.editbox = editbox
  return slider
end

-- create orb func
local function CreateOrb()

  -- create the orb baseframe
  local orb = CreateFrame("Frame", A .. "Orb", UIParent)
  orb.size = cfg.orbSize
  orb:SetSize(orb.size, orb.size)
  orb:SetPoint("CENTER", 0, 200)

  -- background
  local bg = orb:CreateTexture("$parentBG", "BACKGROUND", nil, -6)
  bg:SetAllPoints()
  bg:SetTexture("Interface\\AddOns\\DiscoKugel3\\media\\orb_back")
  bg:SetVertexColor(unpack(cfg.orbBackgroundColor))
  orb.bg = bg

  -- filling statusbar
  local fill = CreateFrame("StatusBar", "$parentFill", orb)
  fill:SetAllPoints()
  fill:SetMinMaxValues(0, 100)
  fill:SetStatusBarTexture("Interface\\AddOns\\DiscoKugel3\\media\\orb_filling"..cfg.orbFillingTexture)
  fill:SetStatusBarColor(unpack(cfg.orbFillingColor))
  fill:SetOrientation("VERTICAL")
  fill:SetScript("OnValueChanged", UpdateOrbValue)
  orb.fill = fill

  -- scrollframe
  local scrollFrame = CreateFrame("ScrollFrame", "$parentScrollFrame", orb)
  scrollFrame:SetSize(orb:GetSize())
  scrollFrame:SetPoint("TOP")
  -- scrollchild
  local scrollChild = CreateFrame("Frame", "$parentScrollChild", scrollFrame)
  scrollChild:SetSize(orb:GetSize())
  scrollFrame:SetScrollChild(scrollChild)
  orb.scrollFrame = scrollFrame

  -- orb model
  local model = CreateFrame("PlayerModel", "$parentModel", scrollChild)
  model:SetSize(orb:GetSize())
  model:SetPoint("TOP")
  model:SetAlpha(cfg.orbModelAlpha)
  orb.model = model

  -- overlay frame
  local overlay = CreateFrame("Frame", "$parentOverlay", scrollFrame)
  overlay:SetAllPoints(orb)
  orb.overlay = orb

  -- spark frame
  local spark = overlay:CreateTexture(nil, "BACKGROUND", nil, -3)
  spark:SetTexture("Interface\\AddOns\\DiscoKugel3\\media\\orb_spark")
  -- the spark should fit the filling color otherwise it will stand out too much
  spark:SetVertexColor(unpack(cfg.orbFillingColor))
  spark:SetWidth(256 * orb.size / 256)
  spark:SetHeight(32 * orb.size / 256)
  spark:SetPoint("TOP", scrollFrame, 0, -16 * orb.size / 256)
  -- texture will be blended by blendmode, http://wowprogramming.com/docs/widgets/Texture/SetBlendMode
  -- spark:SetAlpha(1)
  spark:SetBlendMode("ADD")
  spark:Hide()
  orb.spark = spark

  --debuff glow
  local glow = overlay:CreateTexture("$parentGlow", "BACKGROUND", nil, 2)
  glow:SetPoint("CENTER")
  glow:SetSize(orb.size + 5, orb.size + 5)
  glow:SetBlendMode("BLEND")
  -- glow:SetColorTexture(1,1,1)
  glow:SetTexture("Interface\\AddOns\\DiscoKugel3\\media\\orb_debuff_glow")
  glow:SetVertexColor(unpack(cfg.orbDebuffGlowColor))
  orb.glow = glow

  -- highlight
  local highlight = overlay:CreateTexture("$parentHighlight", "BACKGROUND", nil, 3)
  highlight:SetAllPoints()
  highlight:SetTexture("Interface\\AddOns\\DiscoKugel3\\media\\orb_gloss")
  highlight:SetAlpha(cfg.orbHighlightAlpha)
  orb.highlight = highlight

  orb.fill:SetValue(100)

  local healthSlider = CreateSliderWithEditbox(orb,"OrbHealthValue",0,100,100)
  healthSlider:ClearAllPoints()
  healthSlider:SetPoint("TOP", orb, "BOTTOM", 0, -30)
  healthSlider.text:SetText("Health")
  healthSlider:SetScript("OnValueChanged", function(self, value)
    value = math.floor(value + 0.5)
    self.editbox:SetText(value)
    self.__orb.fill:SetValue(value)
  end)
  healthSlider.editbox:SetScript("OnEnterPressed", function(self)
    self:GetParent():SetValue(self:GetText())
    self:ClearFocus()
  end)

  local debuffGlowColorPicker = CreateColorPickerButton(orb, A..'DebuffGlowColorPicker', cfg.orbDebuffGlowColor)
  debuffGlowColorPicker:SetSize(40, 40)
  debuffGlowColorPicker:SetPoint("TOP", healthSlider, "BOTTOM", -30, -20)
  function debuffGlowColorPicker:UpdateColor(r, g, b, a)
    orb.glow:SetVertexColor(r,g,b,a)
  end

  local fillingColorPicker = CreateColorPickerButton(orb, A..'FillingColorPicker', cfg.orbFillingColor)
  fillingColorPicker:SetSize(40, 40)
  fillingColorPicker:SetPoint("LEFT", debuffGlowColorPicker, "RIGHT", 30, 0)
  function fillingColorPicker:UpdateColor(r, g, b, a)
    orb.fill:SetStatusBarColor(r,g,b,a)
    orb.spark:SetVertexColor(r,g,b,a)
  end

  local fillingTextureSlider = CreateSliderWithEditbox(orb,"OrbFillingTexture",1,7,7)
  fillingTextureSlider:ClearAllPoints()
  fillingTextureSlider:SetPoint("TOP", debuffGlowColorPicker, "BOTTOM", 30, -30)
  fillingTextureSlider.text:SetText("FillingTexture")
  fillingTextureSlider:SetScript("OnValueChanged", function(self, value)
    value = math.floor(value + 0.5)
    self.editbox:SetText(value)
    self.__orb.fill:SetStatusBarTexture("Interface\\AddOns\\DiscoKugel3\\media\\orb_filling"..value)
  end)
  fillingTextureSlider.editbox:SetScript("OnEnterPressed", function(self)
    self:GetParent():SetValue(self:GetText())
    self:ClearFocus()
  end)


end

CreateOrb()
