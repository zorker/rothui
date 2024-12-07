local A, L = ...

local GT = GameTooltip
local math = math
local pi, halfpi = math.pi, math.pi / 2

local cfg = {}

cfg.orbSize = 200
cfg.orbDebuffGlowColor = {0, 1, 1, 0}
cfg.orbBackgroundColor = {0, 0, 0, 1}
cfg.orbFillingColor = {.7, 0, .7, 1}
cfg.orbFillingTexture = 6
cfg.orbSparkColor = {1, 0, 1, 1}
cfg.orbModelAlpha = 1
cfg.orbHighlightAlpha = 1

cfg.modelList = {}

--stopped at index 3425
table.insert(cfg.modelList, 113764)
table.insert(cfg.modelList, 94285)
table.insert(cfg.modelList, 88991)
table.insert(cfg.modelList, 65947)
table.insert(cfg.modelList, 83176)
table.insert(cfg.modelList, 82009)
table.insert(cfg.modelList, 81399)
table.insert(cfg.modelList, 81327)
table.insert(cfg.modelList, 81077)
table.insert(cfg.modelList, 80318)
table.insert(cfg.modelList, 76935)
table.insert(cfg.modelList, 75294)
table.insert(cfg.modelList, 75298)
table.insert(cfg.modelList, 74840)
table.insert(cfg.modelList, 69879)
table.insert(cfg.modelList, 66808)
table.insert(cfg.modelList, 66092)
table.insert(cfg.modelList, 66202)
table.insert(cfg.modelList, 64697)
table.insert(cfg.modelList, 64562)
table.insert(cfg.modelList, 60225)
table.insert(cfg.modelList, 58948)
table.insert(cfg.modelList, 56632)
table.insert(cfg.modelList, 48109)
table.insert(cfg.modelList, 48254)
table.insert(cfg.modelList, 47882)
table.insert(cfg.modelList, 44652)
table.insert(cfg.modelList, 42938)
table.insert(cfg.modelList, 39581)
table.insert(cfg.modelList, 39316)
table.insert(cfg.modelList, 34404)
table.insert(cfg.modelList, 33853)
table.insert(cfg.modelList, 32368)
table.insert(cfg.modelList, 29286)
table.insert(cfg.modelList, 29074)
table.insert(cfg.modelList, 28460)
table.insert(cfg.modelList, 27393)
table.insert(cfg.modelList, 18877)
table.insert(cfg.modelList, 100018)
table.insert(cfg.modelList, 93977)
table.insert(cfg.modelList, 91994)
table.insert(cfg.modelList, 38699)
table.insert(cfg.modelList, 120816)
table.insert(cfg.modelList, 118264)
table.insert(cfg.modelList, 109622)
table.insert(cfg.modelList, 108191)
table.insert(cfg.modelList, 108172)
table.insert(cfg.modelList, 107088)
table.insert(cfg.modelList, 106201)
table.insert(cfg.modelList, 101968)
table.insert(cfg.modelList, 101672)
table.insert(cfg.modelList, 101272)
table.insert(cfg.modelList, 100007)
table.insert(cfg.modelList, 98573)
table.insert(cfg.modelList, 97296)
table.insert(cfg.modelList, 95410)
table.insert(cfg.modelList, 95935)
table.insert(cfg.modelList, 92626)
table.insert(cfg.modelList, 92612)
table.insert(cfg.modelList, 92613)
table.insert(cfg.modelList, 92614)
table.insert(cfg.modelList, 90499)
table.insert(cfg.modelList, 89106)
table.insert(cfg.modelList, 84936)
table.insert(cfg.modelList, 70769)
table.insert(cfg.modelList, 57012)
table.insert(cfg.modelList, 56959)
table.insert(cfg.modelList, 55752)
table.insert(cfg.modelList, 48106)

cfg.modelSettings = {}
cfg.modelSettings[113764] = { camDistanceScale = 0.85 }
cfg.modelSettings[94285] = { camDistanceScale = 0.74 }
cfg.modelSettings[83176] = { camDistanceScale = 1.29 }
cfg.modelSettings[65947] = { camDistanceScale = 0.85 }
cfg.modelSettings[38699] = { camDistanceScale = 0.5 }
cfg.modelSettings[107088] = { camDistanceScale = 11 }
cfg.modelSettings[107039] = { camDistanceScale = 15 }
cfg.modelSettings[96197] = { camDistanceScale = 1.5 }
cfg.modelSettings[94249] = { camDistanceScale = 7.5 }
cfg.modelSettings[92626] = { camDistanceScale = 1.75 }
cfg.modelSettings[88991] = { camDistanceScale = 5 }
cfg.modelSettings[84936] = { camDistanceScale = 0.4 }
cfg.modelSettings[80318] = { camDistanceScale = 0.75 }
cfg.modelSettings[76935] = { camDistanceScale = 0.6 }
cfg.modelSettings[77177] = { camDistanceScale = 5.65 }
cfg.modelSettings[75294] = { camDistanceScale = 3.85 }
cfg.modelSettings[75298] = { camDistanceScale = 0.6 }
cfg.modelSettings[74564] = { camDistanceScale = 2 }
cfg.modelSettings[66092] = { camDistanceScale = 2.35 }
cfg.modelSettings[66202] = { camDistanceScale = 2.35 }
cfg.modelSettings[64697] = { camDistanceScale = 2.35 }
cfg.modelSettings[64562] = { camDistanceScale = 2.35 }

local function RoundNumber(n)
  return math.floor((n) * 1000) / 1000
end

local function SetModelOrientation(model, distance, yaw, pitch)
  if not model:HasCustomCamera() then
    return
  end
  model.distance, model.yaw, model.pitch = distance, yaw, pitch
  local x = distance * math.cos(yaw) * math.cos(pitch)
  local y = distance * math.sin(-yaw) * math.cos(pitch)
  local z = (distance * math.sin(-pitch))
  model:SetCameraPosition(x, y, z)
end

local function CustomCamperaOnUpdate(model, elapsed)
  if not model:HasCustomCamera() then
    return
  end
  if not model.pitch then
    return
  end
  local x, y = GetCursorPosition()
  local pitch = model.pitch + (y - model.cursorY) * pi / 256
  local limit = false
  if pitch > halfpi - 0.05 or pitch < -halfpi + 0.05 then
    limit = true
  end
  if limit then
    local rotation = format("%.0f", math.abs(math.deg(((x - model.cursorX) / 64 + model:GetFacing())) % 360))
    if rotation ~= format("%.0f", math.abs(math.deg(model:GetFacing()) % 360)) then
      model:SetRotation(math.rad(rotation))
      model.rotation = rotation
    end
  else
    local yaw = model.yaw + (x - model.cursorX) * pi / 256
    SetModelOrientation(model, model.distance, yaw, pitch)
  end
  model.cursorX, model.cursorY = x, y
end

local function PositionOnUpdate(model, elapsed)
  local x, y = GetCursorPosition()
  local px, py, pz = model:GetPosition()
  if IsShiftKeyDown() then
    local mx = format("%.2f", (px + (y - model.cursorY) / 100))
    if format("%.2f", px) ~= mx then
      model:SetPosition(mx, py, pz)
      model.posX, model.posY = py, pz
    end
  else
    local my = format("%.2f", (py + (x - model.cursorX) / 84))
    local mz = format("%.2f", (pz + (y - model.cursorY) / 84))
    if format("%.2f", py) ~= my or format("%.2f", pz) ~= mz then
      model:SetPosition(px, my, mz)
      model.posX, model.posY = my, mz
    end
  end
  model.cursorX, model.cursorY = x, y
end

local function RotationOnUpdate(model, elapsed)
  local x, y = GetCursorPosition()
  local rotation = format("%.0f", math.abs(math.deg(((x - model.cursorX) / 84 + model:GetFacing())) % 360))
  if rotation ~= format("%.0f", math.abs(math.deg(model:GetFacing()) % 360)) then
    model:SetRotation(math.rad(rotation))
    model.rotation = rotation
  end
  model.cursorX, model.cursorY = x, y
end

local function ResetModelValues(model)
  model.camDistanceScale = 1
  model.portraitZoom = 0
  model.posX = 0
  model.posY = 0
  model.rotation = 0
  model:SetPortraitZoom(model.portraitZoom)
  model:SetCamDistanceScale(model.camDistanceScale)
  model:SetPosition(0, model.posX, model.posY)
  model:SetRotation(model.rotation)
  model:RefreshCamera()
  model:SetCustomCamera(1)
  if model:HasCustomCamera() then
    local x, y, z = model:GetCameraPosition()
    local tx, ty, tz = model:GetCameraTarget()
    model:SetCameraTarget(0, ty, tz)
    if x == 0 then
      return
    end
    SetModelOrientation(model, math.sqrt(x * x + y * y + z * z), -math.atan(y / x), -math.atan(z / x))
  end
end

local function ModelOnMouseDown(model, button)
  if button == "LeftButton" then
    if model:GetParent().isCanvas then
      if IsShiftKeyDown() then
        if model:HasCustomCamera() then
          model.cursorX, model.cursorY = GetCursorPosition()
          model:SetScript("OnUpdate", CustomCamperaOnUpdate)
        end
      else
        if not L.canvas.overlay.isOverlay then
          L.canvas.overlay:Init()
        end
        L.F:PlaySound(L.C.sound.click)
        L.canvas.overlay:Enable(model.displayIndex)
      end
    else
      if model:HasCustomCamera() then
        model.cursorX, model.cursorY = GetCursorPosition()
        model:SetScript("OnUpdate", CustomCamperaOnUpdate)
      end
    end
  elseif button == "RightButton" then
    if IsControlKeyDown() then
      ResetModelValues(model)
    else
      model.cursorX, model.cursorY = GetCursorPosition()
      model:SetScript("OnUpdate", RotationOnUpdate)
    end
  elseif button == "MiddleButton" or button == "Button4" or button == "Button5" then
    model.cursorX, model.cursorY = GetCursorPosition()
    model:SetScript("OnUpdate", PositionOnUpdate)
  end
end

local function ModelOnMouseUp(model, button)
  model:SetScript("OnUpdate", nil)
end

local function ModelOnMouseWheel(model, delta)
  local deltaAdjust = 0.01
  if IsControlKeyDown() then
    deltaAdjust = 0.15
  end
  if model:HasCustomCamera() then
    local max = 40
    local min = 0.1
    model.distance = math.min(math.max(model.distance - delta * deltaAdjust, min), max)
    SetModelOrientation(model, model.distance, model.yaw, model.pitch)
  else
    if IsShiftKeyDown() then
      local max = 1
      local min = 0
      model.portraitZoom = math.min(math.max(model.portraitZoom + delta * deltaAdjust, min), max)
      model:SetPortraitZoom(model.portraitZoom)
    else
      local max = 10
      local min = 0.1
      model.camDistanceScale = math.min(math.max(model.camDistanceScale - delta * deltaAdjust, min), max)
      model:SetCamDistanceScale(model.camDistanceScale)
    end
  end
end

local function ModelOnEnter(model)
  if not IsAltKeyDown() then
    return
  end
  local pz, px, py = model:GetPosition()
  pz, px, py = RoundNumber(pz), RoundNumber(px), RoundNumber(py)
  GT:SetOwner(model, "ANCHOR_CURSOR")
  -- GT:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -90, 90)
  GT:AddLine("Model Info", 0, 1, 0.5, 1, 1, 1)
  GT:AddLine(" ")
  GT:AddDoubleLine("DisplayInfo", model:GetDisplayInfo(), 1, 1, 1, 1, 1, 1)
  GT:AddDoubleLine("DisplayIndex", model.displayIndex, 1, 1, 1, 1, 1, 1)
  GT:AddDoubleLine("ModelFileID", model.modelFileID, 1, 1, 1, 1, 1, 1)
  GT:AddDoubleLine("SetPosition", "(" .. pz .. "," .. px .. "," .. px .. ")", 1, 1, 1, 1, 1, 1)
  GT:AddDoubleLine("SetRotation", model.rotation, 1, 1, 1, 1, 1, 1)
  GT:AddDoubleLine("SetFacing", RoundNumber(model:GetFacing()), 1, 1, 1, 1, 1, 1)
  if model:HasCustomCamera() then
    local x, y, z = model:GetCameraPosition()
    local tx, ty, tz = model:GetCameraTarget()
    x, y, z = RoundNumber(x), RoundNumber(y), RoundNumber(z)
    tx, ty, tz = RoundNumber(tx), RoundNumber(ty), RoundNumber(tz)
    GT:AddDoubleLine("CustomCamera", "true", 1, 1, 1, 1, 1, 1)
    GT:AddDoubleLine("SetCameraPosition", "(" .. x .. "," .. y .. "," .. z .. ")", 1, 1, 1, 1, 1, 1)
    GT:AddDoubleLine("SetCameraTarget", "(" .. tx .. "," .. ty .. "," .. tz .. ")", 1, 1, 1, 1, 1, 1)
  else
    GT:AddDoubleLine("CustomCamera", "false", 1, 1, 1, 1, 1, 1)
    GT:AddDoubleLine("SetCamDistanceScale", model.camDistanceScale, 1, 1, 1, 1, 1, 1)
    GT:AddDoubleLine("SetPortraitZoom", model.portraitZoom, 1, 1, 1, 1, 1, 1)
  end
  GT:AddLine(" ")
  if model.isOverlayModel then
    if model:HasCustomCamera() then
      GT:AddLine("Hold LEFT and drag mouse to move model camera.")
    else
      GT:AddLine("Model has no custom camera, cannot be moved freely with LEFT mouse.")
    end
  else
    GT:AddLine("Click LEFT for big overlay.")
    if model:HasCustomCamera() then
      GT:AddLine("Hold SHIFT + LEFT and drag mouse to move model camera.")
    end
  end
  GT:AddLine("Hold RIGHT and drag mouse to rotate model.")
  GT:AddLine("Hold MIDDLE or MOUSE4 and drag mouse to move model.")
  if model:HasCustomCamera() then
    GT:AddLine("Use MWHEEL to scale camera.")
  else
    GT:AddLine("Use MWHEEL to scale camera.")
    GT:AddLine("Use SHIFT + MWHEEL to zoom to portrait.")
  end
  GT:AddLine("Click CONTROL + RIGHT to reset.")
  GT:Show()
end

local function ModelOnLeave(model)
  GT:Hide()
end

local function ResetModelValues(model)
  model.camDistanceScale = 1
  model.portraitZoom = 0
  model.posX = 0
  model.posY = 0
  model.rotation = 0
  model:SetPortraitZoom(model.portraitZoom)
  model:SetCamDistanceScale(model.camDistanceScale)
  model:SetPosition(0, model.posX, model.posY)
  model:SetRotation(model.rotation)
  model:RefreshCamera()
  model:SetCustomCamera(1)
  if model:HasCustomCamera() then
    local x, y, z = model:GetCameraPosition()
    local tx, ty, tz = model:GetCameraTarget()
    model:SetCameraTarget(0, ty, tz)
    if x == 0 then
      return
    end
    SetModelOrientation(model, math.sqrt(x * x + y * y + z * z), -math.atan(y / x), -math.atan(z / x))
  end
end

local function OffsetOrbModelY(model, y)
  local x = 0
  local px, py, pz = model:GetPosition()
  -- z-axis has to be adjusted if model frame shrinks in height on statusbar value change
  local mx = (px + (y - model.posY) / 84)
  --local mx = px
  local mz = (pz + (y - model.posY) / 84)
  model:SetPosition(mx, py, mz)
  model.posY = y
end

-- update orb func
local function UpdateOrbValue(bar, value)
  local orb = bar:GetParent()
  local min, max = bar:GetMinMaxValues()
  local per = 0
  if max > 0 then
    per = value / max * 100
  end
  local offset = orb.size - per * orb.size / 100
  OffsetOrbModelY(orb.model, offset / 2)
  -- model z-axis has to be adjusted if model frame shrinks in height on statusbar value change
  orb.model:SetHeight(per * orb.size / 100)
  if per == 0 then
    orb.model:Hide()
  else
    orb.model:Show()
  end
  -- orb.model:SetAlpha((per / 100))
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
    orb.spark:SetPoint("TOP", orb.fill:GetStatusBarTexture(), 0, 16 * orb.size / 256 * multiplier)
    orb.spark:Show()
  end
end

local function CreateColorPickerButton(parent, name, color)
  -- color picker button frame
  local button = CreateFrame("Button", name, parent)
  button:EnableMouse(true)
  Mixin(button, BackdropTemplateMixin)
  button.backdropInfo = BACKDROP_TOAST_12_12
  button:ApplyBackdrop()
  button.Center:SetColorTexture(1, 1, 1)
  button.Center:SetVertexColor(unpack(color))
  button:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 5)
    GameTooltip:AddLine(self:GetName(), 0, 1, 0.5, 1, 1, 1)
    GameTooltip:Show()
  end)
  button:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
  end)
  -- color picker Callback func
  function button:Callback()
    local r, g, b = ColorPickerFrame:GetColorRGB()
    local a = ColorPickerFrame:GetColorAlpha()
    button.Center:SetVertexColor(r, g, b, a)
    button:UpdateColor(r, g, b, a)
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

local function CreateSliderWithEditbox(orb, name, minValue, maxValue, curValue)
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
  orb:SetPoint("CENTER", -200, 200)

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
  fill:SetStatusBarTexture("Interface\\AddOns\\DiscoKugel3\\media\\orb_filling" .. cfg.orbFillingTexture)
  fill:SetStatusBarColor(unpack(cfg.orbFillingColor))
  fill:SetOrientation("VERTICAL")
  fill:SetScript("OnValueChanged", UpdateOrbValue)
  orb.fill = fill

  -- spark frame
  local spark = orb.fill:CreateTexture()
  local sparkLayer, sparkSublayer = orb.fill:GetStatusBarTexture():GetDrawLayer()
  spark:SetDrawLayer(sparkLayer, sparkSublayer + 1)
  spark:SetTexture("Interface\\AddOns\\DiscoKugel3\\media\\orb_spark")
  -- the spark should fit the filling color otherwise it will stand out too much
  spark:SetVertexColor(unpack(cfg.orbSparkColor))
  -- texture will be blended by blendmode, http://wowprogramming.com/docs/widgets/Texture/SetBlendMode
  -- spark:SetAlpha(1)
  spark:SetBlendMode("ADD")
  spark:Hide()
  orb.spark = spark

  -- orb model
  local model = CreateFrame("PlayerModel", "$parentModel", orb.fill)
  model:SetSize(orb.size, orb.size)
  model:SetPoint("TOP", orb.fill:GetStatusBarTexture())
  model:SetAlpha(cfg.orbModelAlpha)
  model.displayInfo = cfg.modelList[1]
  function model:Update()
    ResetModelValues(self)
    if cfg.modelSettings[self.displayInfo] and cfg.modelSettings[self.displayInfo].camDistanceScale then
      self:SetCamDistanceScale(cfg.modelSettings[self.displayInfo].camDistanceScale)
    end
    self:ClearModel()
    self:SetDisplayInfo(self.displayInfo)
  end
  model:Update()
  model.posX, model.posY = 0, 0
  Mixin(model, BackdropTemplateMixin)
  model.backdropInfo = BACKDROP_TOAST_12_12
  --model:ApplyBackdrop()
  --model.Center:SetColorTexture(1, 1, 1)
  --model.Center:SetVertexColor(0,0,0,0)
  model:SetScript("OnMouseWheel", ModelOnMouseWheel)
  model:SetScript("OnMouseDown", ModelOnMouseDown)
  model:SetScript("OnMouseUp", ModelOnMouseUp)
  model:SetScript("OnEnter", ModelOnEnter)
  model:SetScript("OnLeave", ModelOnLeave)
  orb.model = model

  -- overlay frame
  local overlay = CreateFrame("Frame", "$parentOverlay", orb.fill)
  overlay:SetFrameLevel(orb.model:GetFrameLevel() + 1)
  overlay:SetAllPoints(orb)
  orb.overlay = orb

  -- debuff glow
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

  local healthSlider = CreateSliderWithEditbox(orb, "OrbHealthValue", 0, 100, 100)
  healthSlider:ClearAllPoints()
  healthSlider:SetPoint("TOPLEFT", orb, "TOPRIGHT", 30, 0)
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

  local fillingColorPicker = CreateColorPickerButton(orb, A .. 'FillingColorPicker', cfg.orbFillingColor)
  fillingColorPicker:SetSize(40, 40)
  fillingColorPicker:SetPoint("TOP", healthSlider, "BOTTOM", 0, -20)
  function fillingColorPicker:UpdateColor(r, g, b, a)
    orb.fill:SetStatusBarColor(r, g, b, a)
    -- orb.spark:SetVertexColor(r, g, b, a)
  end

  local debuffGlowColorPicker = CreateColorPickerButton(orb, A .. 'DebuffGlowColorPicker', cfg.orbDebuffGlowColor)
  debuffGlowColorPicker:SetSize(40, 40)
  debuffGlowColorPicker:SetPoint("LEFT", fillingColorPicker, "RIGHT", 20, 0)
  function debuffGlowColorPicker:UpdateColor(r, g, b, a)
    orb.glow:SetVertexColor(r, g, b, a)
  end

  local sparkColorPicker = CreateColorPickerButton(orb, A .. 'SparkColorPicker', cfg.orbSparkColor)
  sparkColorPicker:SetSize(40, 40)
  sparkColorPicker:SetPoint("RIGHT", fillingColorPicker, "LEFT", -20, 0)
  function sparkColorPicker:UpdateColor(r, g, b, a)
    orb.spark:SetVertexColor(r, g, b, a)
  end

  local fillingTextureSlider = CreateSliderWithEditbox(orb, "OrbFillingTexture", 1, 7, cfg.orbFillingTexture)
  fillingTextureSlider:ClearAllPoints()
  fillingTextureSlider:SetPoint("TOP", fillingColorPicker, "BOTTOM", 0, -30)
  fillingTextureSlider.text:SetText("FillingTexture")
  fillingTextureSlider:SetScript("OnValueChanged", function(self, value)
    value = math.floor(value + 0.5)
    self.editbox:SetText(value)
    self.__orb.fill:SetStatusBarTexture("Interface\\AddOns\\DiscoKugel3\\media\\orb_filling" .. value)
  end)
  fillingTextureSlider.editbox:SetScript("OnEnterPressed", function(self)
    self:GetParent():SetValue(self:GetText())
    self:ClearFocus()
  end)

  local modelAlphaSlider = CreateSliderWithEditbox(orb, "OrbModelAlpha", 0, 100, cfg.orbModelAlpha * 100)
  modelAlphaSlider:ClearAllPoints()
  modelAlphaSlider:SetPoint("TOP", fillingTextureSlider, "BOTTOM", 0, -30)
  modelAlphaSlider.text:SetText("ModelAlpha")
  modelAlphaSlider:SetScript("OnValueChanged", function(self, value)
    value = math.floor(value + 0.5)
    self.editbox:SetText(value)
    self.__orb.model:SetAlpha(value / 100)
  end)
  modelAlphaSlider.editbox:SetScript("OnEnterPressed", function(self)
    self:GetParent():SetValue(self:GetText())
    self:ClearFocus()
  end)

  local modelSelector = CreateSliderWithEditbox(orb, "OrbModelSelector", 1, table.getn(cfg.modelList), 1)
  modelSelector:ClearAllPoints()
  modelSelector:SetPoint("TOPLEFT", modelAlphaSlider, "BOTTOMLEFT", 0, -30)
  modelSelector:SetWidth(600)
  modelSelector.text:SetText("ModelSelector")
  modelSelector:SetScript("OnValueChanged", function(self, value)
    value = math.floor(value + 0.5)
    self.editbox:SetText(value)
    self.__orb.model.displayInfo = cfg.modelList[value]
    self.__orb.model:Update()
  end)
  modelSelector.editbox:SetScript("OnEnterPressed", function(self)
    self:GetParent():SetValue(self:GetText())
    self:ClearFocus()
  end)

end

CreateOrb()

