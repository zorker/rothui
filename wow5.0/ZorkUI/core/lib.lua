
---------------------------------------------
--  ZorkUI
---------------------------------------------

--  Lib module
--  zork - 2013

---------------------------------------------

local addonName, ns = ...

local lib = CreateFrame("Frame")
ns.lib = lib

---------------------------------------------
--local variables
---------------------------------------------

local UIP = UIParent
local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local math = math
local flatTexture = "Interface\\Buttons\\WHITE8x8"
local mediaPath = "Interface\\AddOns\\"..addonName.."\\media\\"
local defaultBorder = mediaPath.."roth-backdrop-border_3b_3s"

---------------------------------------------
--lib variables
---------------------------------------------

lib.mediaPath = mediaPath
lib.playerName  = UnitName("player")
lib.playerClass = select(2,UnitClass("player"))
lib.playerColor = RAID_CLASS_COLORS[lib.playerClass]

---------------------------------------------
--local functions
---------------------------------------------

local function Round(v,i)
  local m = 10^(math.abs(i or 0))
  return math.floor(v*m+0.5)/m
end

local function PrintEvent(event,text)
  print(addonName.." > "..(event or "NONE").." > "..(text or "NO_TEXT"))
end

local function GetDefaultBackdrop(edgeFile,edgeSize)
  return { 
    bgFile = nil, edgeFile = edgeFile, tile = false, tileSize = 16, edgeSize = edgeSize, 
    insets = { left = 0, right = 0, top = 0, bottom = 0, }, 
  }
end

---------------------------------------------
--lib functions
---------------------------------------------

function lib.PLAYER_LOGIN(self, event, ...)
  PrintEvent(event)
end

function lib.UI_SCALE_CHANGED(self, event, ...)
  PrintEvent(event,Round(UIP:GetEffectiveScale(),4))
end

function lib:CreateZUIBackground(parent,texture)
  if parent.zuiBackground then return end
  parent.zuiBackground = parent:CreateTexture(nil, "BACKGROUND", nil, -8)
  if texture then
    parent.zuiBackground:SetTexture(texture)
  else
    parent.zuiBackground:SetTexture(1,1,1)
  end
  parent.zuiBackground:SetAllPoints()
  parent.zuiBackground:SetVertexColor(0,0,0,0.7)
  local mt = getmetatable(parent).__index
  mt.SetZUIBackgroundColor = function(self,r,g,b,a)
    self.zuiBackground:SetVertexColor(r or 1, g or 1, b or 1, a or 1)
  end
end

function lib:CreateZUIBorder(parent,edgeFile,edgeSize,padding)
  if parent.zuiBorder then return end
  edgeFile = edgeFile or defaultBorder
  edgeSize = edgeSize or 8
  padding = padding or 3
  parent.zuiBorder = CreateFrame("Frame", nil, parent)
  parent.zuiBorder:SetPoint("TOPLEFT",-padding,padding)
  parent.zuiBorder:SetPoint("BOTTOMRIGHT",padding,-padding)
  parent.zuiBorder:SetBackdrop(GetDefaultBackdrop(edgeFile,edgeSize))  
  parent.zuiBorder:SetBackdropBorderColor(lib.playerColor.r,lib.playerColor.g,lib.playerColor.b)
  local mt = getmetatable(parent).__index
  mt.SetZUIBorderColor = function(self,r,g,b,a)
    self.zuiBorder:SetBackdropBorderColor(r or 1, g or 1, b or 1, a or 1)
  end
end

lib:SetScript("OnEvent", function(self, event, ...)
  self[event](self, event, ...)
end)

lib:RegisterEvent("PLAYER_LOGIN")
lib:RegisterEvent("UI_SCALE_CHANGED")

PrintEvent("ONLOAD","core lib")

