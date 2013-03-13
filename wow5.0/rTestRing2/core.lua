
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

  -----------------------------
  -- FUNCTIONS
  -----------------------------

  local f = CF("Frame",nil,UIP)
  f:SetSize(512,512)
  f:SetScale(0.2)
  f.w, f.h = f:GetSize()
  f:SetPoint("CENTER")

  local t = f:CreateTexture(nil, "BACKGROUND", nil, -8)
  t:SetTexture("Interface\\AddOns\\rTestRing2\\media\\ring")
  t:SetAllPoints()
  t:SetAlpha(0.2)

  --left ring
  local sf1 = CF("ScrollFrame",nil,f)
  sf1:SetSize(f.w/2,f.h)
  sf1:SetPoint("LEFT")

  local sc1 = CF("Frame")
  sf1:SetScrollChild(sc1)
  sc1:SetSize(f.w,f.h)

  local rt1 = sc1:CreateTexture(nil,"BACKGROUND",nil,-6)
  rt1:SetTexture("Interface\\AddOns\\rTestRing2\\media\\ring_half")
  rt1:SetSize(sqrt(2)*f.w,sqrt(2)*f.h)
  rt1:SetPoint("CENTER")
  rt1:SetVertexColor(1,0,0)
  rt1:SetRotation(math.rad(180+10)) -- etc

  --right ring
  local sf2 = CF("ScrollFrame",nil,f)
  sf2:SetSize(f.w/2,f.h)
  sf2:SetPoint("RIGHT")

  local sc2 = CF("Frame")
  sf2:SetScrollChild(sc2)
  sc2:SetSize(f.w,f.h)

  local rt2 = sc2:CreateTexture(nil,"BACKGROUND",nil,-6)
  rt2:SetTexture("Interface\\AddOns\\rTestRing2\\media\\ring_half")
  rt2:SetSize(sqrt(2)*f.w,sqrt(2)*f.h)
  rt2:SetPoint("CENTER",-f.w/2,0)
  rt2:SetVertexColor(0,0,1)
  rt2:SetRotation(math.rad(0-10)) -- etc


  local f = CF("Frame",nil,UIP)
  f:SetSize(512,512)
  f:SetScale(0.2)
  f.w, f.h = f:GetSize()
  f:SetPoint("CENTER",0,-512-64)

  local t = f:CreateTexture(nil, "BACKGROUND", nil, -8)
  t:SetTexture("Interface\\AddOns\\rTestRing2\\media\\ring")
  t:SetAllPoints()
  t:SetAlpha(0.2)

  --top ring
  local sf1 = CF("ScrollFrame",nil,f)
  sf1:SetSize(f.w,f.h/2)
  sf1:SetPoint("TOP")

  local sc1 = CF("Frame")
  sf1:SetScrollChild(sc1)
  sc1:SetSize(f.w,f.h)

  local rt1 = sc1:CreateTexture(nil,"BACKGROUND",nil,-6)
  rt1:SetTexture("Interface\\AddOns\\rTestRing2\\media\\ring_half")
  rt1:SetSize(sqrt(2)*f.w,sqrt(2)*f.h)
  rt1:SetPoint("CENTER",0,0)
  rt1:SetVertexColor(0,1,0)
  rt1:SetRotation(math.rad(90+10)) -- etc

  --bottom ring
  local sf2 = CF("ScrollFrame",nil,f)
  sf2:SetSize(f.w,f.h/2)
  sf2:SetPoint("BOTTOM")

  local sc2 = CF("Frame")
  sf2:SetScrollChild(sc2)
  sc2:SetSize(f.w,f.h)

  local rt2 = sc2:CreateTexture(nil,"BACKGROUND",nil,-6)
  rt2:SetTexture("Interface\\AddOns\\rTestRing2\\media\\ring_half")
  rt2:SetSize(sqrt(2)*f.w,sqrt(2)*f.h)
  rt2:SetPoint("CENTER",0,f.h/2)
  rt2:SetVertexColor(1,1,0)
  rt2:SetRotation(math.rad(270-10)) -- etc


  --TOP RING CONTAINER

  local f = CF("Frame",nil,UIP)
  f:SetSize(512,512)
  f:SetScale(0.138)
  f.w, f.h = f:GetSize()
  f:SetPoint("CENTER",0,0)

  local t = f:CreateTexture(nil, "BACKGROUND", nil, -8)
  t:SetTexture("Interface\\AddOns\\rTestRing2\\media\\ring")
  t:SetAllPoints()
  t:SetAlpha(0.2)

  --left ring
  local sf1 = CF("ScrollFrame",nil,f)
  sf1:SetSize(f.w/2,f.h)
  sf1:SetPoint("LEFT")

  local sc1 = CF("Frame")
  sf1:SetScrollChild(sc1)
  sc1:SetSize(f.w,f.h)

  local rt1 = sc1:CreateTexture(nil,"BACKGROUND",nil,-6)
  rt1:SetTexture("Interface\\AddOns\\rTestRing2\\media\\ring_half")
  rt1:SetSize(sqrt(2)*f.w,sqrt(2)*f.h)
  rt1:SetPoint("CENTER")
  rt1:SetVertexColor(1,0.5,0)
  rt1:SetRotation(math.rad(180-0)) -- etc

  --right ring
  local sf2 = CF("ScrollFrame",nil,f)
  sf2:SetSize(f.w/2,f.h)
  sf2:SetPoint("RIGHT")

  local sc2 = CF("Frame")
  sf2:SetScrollChild(sc2)
  sc2:SetSize(f.w,f.h)

  local rt2 = sc2:CreateTexture(nil,"BACKGROUND",nil,-6)
  rt2:SetTexture("Interface\\AddOns\\rTestRing2\\media\\ring_half")
  rt2:SetSize(sqrt(2)*f.w,sqrt(2)*f.h)
  rt2:SetPoint("CENTER",-f.w/2,0)
  rt2:SetVertexColor(1,0.5,0)
  rt2:SetRotation(math.rad(0-10)) -- etc

  local icon = select(3,GetSpellInfo(12880))
  --icon = "Interface\\LFGFrame\\UI-LFR-PORTRAIT"
  local t = f:CreateTexture(nil,"BACKGROUND",nil,-8)
  t:SetTexCoord(0, 1, 0, 1)
  t:SetSize(f.w*0.65,f.h*0.65)
  t:SetPoint("CENTER")
  --t:SetTexture(icon)
  SetPortraitToTexture(t,icon)
