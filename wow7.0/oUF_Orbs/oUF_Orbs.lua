
-- rButtonAura: core
-- zork, 2018

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- CONFIG
-----------------------------

L.C = {}

--mediapath
L.C.mediapath = "interface\\addons\\"..A.."\\media\\"
local size = 128

local function AddTexture(self,file,index,layer)
  if not layer then layer = "BACKGROUND" end
  local t = self:CreateTexture(nil,layer,nil,index)
  t:SetTexture(L.C.mediapath..file)
  t:SetAllPoints()
  return t
end

local function CreateUnitFrame()

  local frame = CreateFrame("Frame",nil,UIParent)
  frame:SetSize(size,size)

  local healthbar = CreateFrame("Frame",nil,frame)
  healthbar:SetAllPoints()

  local orbBg = AddTexture(healthbar,"orb_bg",-8)
  local orbFill = AddTexture(healthbar,"orb_fill",-7)
  orbFill:SetVertexColor(.8,0,0)
  local orbDebuffGlow = AddTexture(healthbar,"orb_debuff_glow",-6,"BORDER")
  orbDebuffGlow:SetBlendMode("BLEND")
  orbDebuffGlow:SetVertexColor(1,0,1)
  orbDebuffGlow:ClearAllPoints()
  orbDebuffGlow:SetPoint("CENTER")
  local glowSize = size*0.7
  orbDebuffGlow:SetSize(glowSize,glowSize)
  --orbDebuffGlow:Hide()
  local orbHl = AddTexture(healthbar,"orb_hl",-7,"BORDER")

  local powerbar = CreateFrame("Frame",nil,frame)
  powerbar:SetAllPoints()

  local ringBottomBg = AddTexture(powerbar,"ring_bottom_bg",-5)
  local ringBottomFill = AddTexture(powerbar,"ring_bottom_fill",-4)
  ringBottomFill:SetVertexColor(.8,0,0)
  local ringBottomHl = AddTexture(powerbar,"ring_bottom_hl",-3)

  local alternativepowerbar = CreateFrame("Frame",nil,frame)
  alternativepowerbar:SetAllPoints()

  local ringTopBg = AddTexture(alternativepowerbar,"ring_top_bg",-2)
  local ringTopFill = AddTexture(alternativepowerbar,"ring_top_fill",-1)
  ringTopFill:SetVertexColor(0,.4,.8)
  local ringTopHl = AddTexture(alternativepowerbar,"ring_top_hl",0)

  ringTopFill:Hide()

  local castbar = CreateFrame("Frame",nil,frame)
  castbar:SetAllPoints()
  castbar:Hide()

  local ringOuterBg = AddTexture(castbar,"ring_outer_bg",1)
  local ringOuterFill = AddTexture(castbar,"ring_outer_fill",2)
  ringOuterFill:SetVertexColor(.8,.6,0)
  local ringOuterHl = AddTexture(castbar,"ring_outer_hl",3)

  frame.castbar = castbar
  frame.alternativepowerbar = alternativepowerbar
  frame.powerbar = powerbar
  frame.healthbar = healthbar

  return frame

end

local player = CreateUnitFrame()
player:SetPoint("CENTER",-200,0)
player:SetScale(1.2)
player.alternativepowerbar:Show()

local pet = CreateUnitFrame()
pet:SetPoint("TOPRIGHT",player,"BOTTOMLEFT",20,20)
pet:SetScale(0.8)

local focus = CreateUnitFrame()
focus:SetPoint("BOTTOMRIGHT",player,"TOPLEFT",20,-20)
focus:SetScale(0.8)

local target = CreateUnitFrame()
target:SetPoint("CENTER",200,0)
target:SetScale(1.2)
target.castbar:Show()

local targettarget = CreateUnitFrame()
targettarget:SetPoint("TOPRIGHT",target,"BOTTOMLEFT",20,20)
targettarget:SetScale(0.8)

local party1 = CreateUnitFrame()
party1:SetPoint("TOPLEFT",20,-20)
party1:SetScale(0.8)

local party2 = CreateUnitFrame()
party2:SetPoint("LEFT",party1,"RIGHT",20,0)
party2:SetScale(0.8)

local party3 = CreateUnitFrame()
party3:SetPoint("LEFT",party2,"RIGHT",20,0)
party3:SetScale(0.8)

local party4 = CreateUnitFrame()
party4:SetPoint("LEFT",party3,"RIGHT",20,0)
party4:SetScale(0.8)

local party5 = CreateUnitFrame()
party5:SetPoint("LEFT",party4,"RIGHT",20,0)
party5:SetScale(0.8)