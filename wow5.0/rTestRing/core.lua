
  -- // DiscoKugel2
  -- // zork - 2013

  --get the addon namespace
  local addon, ns = ...

  local unpack = unpack
  local _G = _G
  local CF = CreateFrame
  local UIP = UIParent
  local abs = math.abs
  local sin = math.sin
  local pi = math.pi
  
  local backdrop = {
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", 
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", 
    tile = true, 
    tileSize = 16, 
    edgeSize = 16, 
    insets = { left = 4, right = 4, top = 4, bottom = 4 },
  }
  
  -----------------------------
  -- FUNCTIONS
  -----------------------------
  
  local f = CF("Frame",nil,UIP)
  f:SetSize(512,512)
  f:SetPoint("CENTER")
  
  local t = f:CreateTexture(nil, "BACKGROUND", nil, -8)
  t:SetTexture("Interface\\AddOns\\rTestRing\\media\\ring")
  t:SetAllPoints()
  t:SetAlpha(0.2)
  
  local sf1 = CF("ScrollFrame",nil,f)
  sf1:SetSize(256,512)
  sf1:SetPoint("LEFT")
  sf1:SetBackdrop(backdrop) 
  
  local sc1 = CF("Frame")
  sf1:SetScrollChild(sc1)
  sc1:SetSize(f:GetSize())
  
  local t = sc1:CreateTexture(nil,"BACKGROUND",nil,-8)
  t:SetTexture(1,1,1)
  t:SetVertexColor(0,1,1)
  t:SetAlpha(0.2)
  t:SetAllPoints()
  
  local rt1 = sc1:CreateTexture(nil,"BACKGROUND",nil,-6)
  rt1:SetTexture("Interface\\AddOns\\rTestRing\\media\\ring_half")
  rt1:SetSize(f:GetSize())
  rt1:SetPoint("CENTER")
  rt1:SetVertexColor(1,0,0)

  local ag = rt1:CreateAnimationGroup()
  local anim = ag:CreateAnimation("Rotation")
  anim:SetDegrees(360)
  anim:SetDuration(60)
  ag:Play()
  ag:SetLooping("REPEAT")

  
  
  
  