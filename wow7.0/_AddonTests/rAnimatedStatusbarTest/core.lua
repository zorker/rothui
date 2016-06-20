
-- AnimatedStatusBarTest: core
-- zork, 2016

-----------------------------
-- Local Variables
-----------------------------

local A, L = ...

local mediapath = "interface\\addons\\"..A.."\\media\\"

-----------------------------
-- Init
-----------------------------

local function Round(number, decimals)
  return (("%%.%df"):format(decimals)):format(number)
end

local frame = CreateFrame("Frame",A.."Frame",UIParent)
frame:SetPoint("CENTER")
frame:SetSize(256, 16)

local bar = CreateFrame("Statusbar",A.."FrameBar",frame,"AnimatedStatusBarTemplate")
bar:SetStatusBarTexture("Interface/TargetingFrame/UI-TargetingFrame-BarFill")
bar:SetAllPoints()

--local bar = CreateFrame("Statusbar",nil,UIParent,nil)

bar:SetMinMaxValues(0,1)
bar:SetValue(0.5)
--bar:SetStatusBarTexture("Interface/TargetingFrame/UI-TargetingFrame-BarFill")
bar:SetStatusBarAtlas("_honorsystem-bar-fill")

--print(bar:GetStatusBarTexture():GetTexture())
--bar:SetStatusBarAtlas("_honorsystem-bar-fill")

local slider = CreateFrame("Slider", A.."Slider", UIParent, "OptionsSliderTemplate")
slider:SetMinMaxValues(0,1)
slider:SetValue(bar:GetValue())
slider:SetValueStep(0.01)

slider.text = _G[A.."SliderText"]
slider.low = _G[A.."SliderLow"]
slider.high = _G[A.."SliderHigh"]

slider:SetPoint("TOP", bar, "BOTTOM", 0, -30)
slider.title = "Value"
slider.text:SetText(slider.title..": "..Round(slider:GetValue(), 3))
local smin, smax = slider:GetMinMaxValues()
slider.low:SetText(smin)
slider.high:SetText(smax)

slider:SetScript("OnValueChanged", function(self,value)
  --bar:SetValue(value)
  bar:SetAnimatedValues(value, 0, 1, 1)
  self.text:SetText(self.title..": "..Round(value, 3))
end)

