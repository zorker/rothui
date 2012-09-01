
---------------------------------------
-- INIT
---------------------------------------

--get the addon namespace
local addon, ns = ...

local textureHorizontal = "Interface\\AddOns\\rStatusbarDebug\\ember"
local textureVertical = "Interface\\AddOns\\rStatusbarDebug\\ember90"

local createStatusbarVertical = function()
  local bar = CreateFrame("StatusBar",nil,UIParent)
  bar:SetSize(32,32)
  bar:SetMinMaxValues(1, 100)
  bar.minValue, bar.maxValue = bar:GetMinMaxValues()
  bar.bg = bar:CreateTexture(nil,"BACKGROUND",nil,-8)
  bar.bg:SetAllPoints(bar)
  bar.bg:SetTexture(0,0,1)
  bar.bg:SetAlpha(0.2)
  local tex = bar:CreateTexture(nil,"BACKGROUND",nil,-6)
  tex:SetTexture(textureVertical)
  bar:SetStatusBarTexture(tex)
  bar:SetOrientation("VERTICAL")
  return bar
end

local createStatusbarHorizontal = function()
  local bar = CreateFrame("StatusBar",nil,UIParent)
  bar:SetSize(32,32)
  bar:SetMinMaxValues(1, 100)
  bar.minValue, bar.maxValue = bar:GetMinMaxValues()
  bar.bg = bar:CreateTexture(nil,"BACKGROUND",nil,-8)
  bar.bg:SetAllPoints(bar)
  bar.bg:SetTexture(1,0,0)
  bar.bg:SetAlpha(0.2)
  local tex = bar:CreateTexture(nil,"BACKGROUND",nil,-6)
  tex:SetTexture(textureHorizontal)
  bar:SetStatusBarTexture(tex)
  bar:SetOrientation("HORIZONTAL")
  return bar
end

for i=1,10 do
  local bar = createStatusbarVertical()
  bar:SetValue(i*10)
  bar:SetPoint("CENTER",(-1*5*35)+i*35,0)
end

for i=1,10 do
  local bar = createStatusbarHorizontal()
  bar:SetValue(i*10)
  bar:SetPoint("CENTER",(-1*5*35)+i*35,50)
end


for i=1,10 do
  local bar = createStatusbarVertical()
  bar:SetSize(50,50)
  bar:SetValue(i*10)
  bar:SetPoint("CENTER",(-1*5*50)+i*50,120)
end

for i=1,10 do
  local bar = createStatusbarHorizontal()
  bar:SetSize(50,50)
  bar:SetValue(i*10)
  bar:SetPoint("CENTER",(-1*5*50)+i*50,190)
end

for i=1,10 do
  local bar = createStatusbarVertical()
  bar:SetSize(30,50)
  bar:SetValue(i*10)
  bar:SetPoint("CENTER",(-1*5*50)+i*50,-70)
end

for i=1,10 do
  local bar = createStatusbarHorizontal()
  bar:SetSize(50,30)
  bar:SetValue(i*10)
  bar:SetPoint("CENTER",(-1*5*50)+i*50,-140)
end

for i=0,20 do
  local bar = createStatusbarVertical()
  bar:SetValue(i*0.5)
  bar:SetPoint("CENTER",(-1*10*35)+i*35,-190)
end