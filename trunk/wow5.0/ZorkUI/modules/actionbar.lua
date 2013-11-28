
---------------------------------------------
--  ZorkUI
---------------------------------------------

--  actionbar module
--  zork - 2013

---------------------------------------------

local addonName, ns = ...
local lib = ns.lib

local UIP = UIParent

print("module actionbar")

local frame = CreateFrame("Frame", nil, UIP)
frame:SetSize(200,10)
frame:SetPoint("CENTER",0,0)
--parent,texture -> parent.zuiBackground, adds a background texture to the frame
lib:CreateZUIBackground(frame)
--parent,texture,edgesize,padding -> parent.zuiBorder, a frame with a backdrop
lib:CreateZUIBorder(frame,lib.mediaPath.."backdrop-border-rothC",8,3)

local frame = CreateFrame("Frame", nil, UIP)
frame:SetSize(200,10)
frame:SetPoint("CENTER",0,-20)
lib:CreateZUIBackground(frame)
frame:SetZUIBackgroundColor(1,0,0,1)
lib:CreateZUIBorder(frame,lib.mediaPath.."backdrop-border-rothD")
frame:SetZUIBorderColor(0,1,1,1)

local frame = CreateFrame("Frame", nil, UIP)
frame:SetSize(200,10)
frame:SetPoint("CENTER",0,-40)
lib:CreateZUIBackground(frame)
frame:SetZUIBackgroundColor(0,1,0)
lib:CreateZUIBorder(frame)
frame:SetZUIBorderColor(.58,.55,.55)

local frame = CreateFrame("Frame", nil, UIP)
frame:SetSize(36,36)
frame:SetPoint("CENTER",0,-80)
lib:CreateZUIBackground(frame)
lib:CreateZUIBorder(frame)
frame.icon = frame:CreateTexture(nil,"BACKGROUND",nil,-5)
frame.icon:SetAllPoints()
frame.icon:SetTexture(select(3,GetSpellInfo(132404)))
frame.icon:SetTexCoord(.1,.9,.1,.9)

local frame = CreateFrame("Frame", nil, UIP)
frame:SetSize(24,24)
frame:SetPoint("CENTER",50,-80)
lib:CreateZUIBackground(frame)
lib:CreateZUIBorder(frame)

frame.icon = frame:CreateTexture(nil,"BACKGROUND",nil,-5)
frame.icon:SetAllPoints()
frame.icon:SetTexture(select(3,GetSpellInfo(132404)))
frame.icon:SetTexCoord(.1,.9,.1,.9)

local bar = CreateFrame("StatusBar", nil, UIP)
bar:SetSize(200,8)
bar:SetPoint("CENTER",0,-120)
lib:CreateZUIBackground(bar)
lib:CreateZUIBorder(bar)
bar:SetMinMaxValues(0,1)
bar:SetValue(0.6)
bar:SetStatusBarTexture(lib.mediaPath.."statusbar")
bar:SetStatusBarColor(1,0,0)
bar:SetZUIBackgroundColor(.2,0,0)
bar:SetZUIBorderColor(.58,.15,.15)

local bar = CreateFrame("StatusBar", nil, UIP)
bar:SetSize(200,20)
bar:SetPoint("CENTER",0,-150)
lib:CreateZUIBackground(bar)
lib:CreateZUIBorder(bar)
bar:SetMinMaxValues(0,1)
bar:SetValue(0.6)
bar:SetStatusBarTexture(lib.mediaPath.."statusbar")
bar:SetStatusBarColor(1,0,0)
bar:SetZUIBackgroundColor(.2,0,0)
bar:SetZUIBorderColor(.38,.35,.35)