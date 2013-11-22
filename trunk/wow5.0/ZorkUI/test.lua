
---------------------------------------------
--  ZorkUI
---------------------------------------------

--  Test cases
--  zork - 2013

---------------------------------------------

local addonName, ns = ...
local mediaPath = "Interface\\AddOns\\"..addonName.."\\media\\"
local flatTexture = "Interface\\Buttons\\WHITE8x8"
local borderTexture = mediaPath.."rothB-backdrop-border_3b_2s"

local UIP = UIParent

local function GetDefaultBackdrop(edgeFile, edgeSize)
  return { 
    bgFile = nil, edgeFile = edgeFile, tile = false, tileSize = 16, edgeSize = edgeSize, 
    insets = { left = 0, right = 0, top = 0, bottom = 0, }, 
  }
end

local function NewStatusBar(statusbarTexture,edgeFile,edgeSize,padding)
  local s = CreateFrame("StatusBar", nil, UIP)
  s.bg = s:CreateTexture(nil,"BACKGROUND",nil,-8)
  s.bg:SetAllPoints()
  s.overlay = CreateFrame("Frame", nil, s)
  s.overlay:SetPoint("TOPLEFT",-padding,padding)
  s.overlay:SetPoint("BOTTOMRIGHT",padding,-padding)
  s.overlay:SetBackdrop(GetDefaultBackdrop(edgeFile, edgeSize))  
  s:SetStatusBarTexture(statusbarTexture)
  s.bg:SetTexture(statusbarTexture)
  return s
end

local bar = NewStatusBar(mediaPath.."statusbar", mediaPath.."backdrop-border-rothD", 8, 3)
bar:SetSize(128,10)
bar:SetPoint("CENTER")
bar.overlay:SetBackdropBorderColor(.5,.5,.5)
bar:SetStatusBarColor(.1,.2,.3)
bar:SetMinMaxValues(0,1)
bar:SetValue(0.7)
bar.bg:SetVertexColor(0,.6,1)

local bar = NewStatusBar(mediaPath.."statusbar", mediaPath.."backdrop-border-rothC", 8, 3)
bar:SetSize(128,32)
bar:SetPoint("CENTER",0,-50)
bar.overlay:SetBackdropBorderColor(.5,.5,.5)
bar:SetStatusBarColor(.3,.1,.1)
bar:SetMinMaxValues(0,1)
bar:SetValue(0.7)
bar.bg:SetVertexColor(1,0,0)

