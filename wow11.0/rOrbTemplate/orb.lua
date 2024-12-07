-------------------------------------------------
-- Variables
-------------------------------------------------

local A, L = ...

--print(A, 'orb.lua file init')

-------------------------------------------------
-- Function
-------------------------------------------------

local function OnDragStart(self, button)
  self:StartMoving()
end

local function OnDragStop(self)
  self:StopMovingOrSizing()
end

local function EnableDrag(self)
  self:RegisterForDrag("LeftButton")
  self:SetScript("OnDragStart", OnDragStart)
  self:SetScript("OnDragStop", OnDragStop)
  self:EnableMouse(true)
  self:SetClampedToScreen(true)
  self:SetMovable(true)
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

local function CreateOrb()

  local orb = CreateFrame("Frame", "rOrbPlayerHealth", UIParent, "OrbTemplate")
  local healthBar = orb.FillingStatusBar
  local model = healthBar.ModelFrame

  orb:SetPoint("CENTER",-300,0)
  --orb:SetScale(.75)

  model.orbSettings = {}
  model.orbSettings.panAdjustY = 128
  model:SetDisplayInfo(113764)

  --EnableDrag(orb)

  local healthSlider = CreateSliderWithEditbox(orb, "OrbHealthValue", 0, 100, 100)
  healthSlider:ClearAllPoints()
  healthSlider:SetPoint("TOP", orb, "BOTTOM", 0, -30)
  healthSlider.text:SetText("Health")
  healthSlider:SetScript("OnValueChanged", function(self, value)
    value = math.floor(value + 0.5)
    self.editbox:SetText(value)
    self.__orb.FillingStatusBar:SetValue(value/100)
  end)
  healthSlider.editbox:SetScript("OnEnterPressed", function(self)
    self:GetParent():SetValue(self:GetText())
    self:ClearFocus()
  end)

end

-------------------------------------------------
-- Load
-------------------------------------------------

rLib:RegisterCallback("PLAYER_LOGIN", CreateOrb)