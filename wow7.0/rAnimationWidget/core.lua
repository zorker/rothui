
-- rAnimationWidget: core
-- zork, 2016

-----------------------------
-- Local Variables
-----------------------------

local A, L = ...

-----------------------------
-- Init
-----------------------------

print(A,"loaded")

--helper frame
local f = CreateFrame("Frame", nil, UIParent)

--texture
local t1 = f:CreateTexture(nil, "BACKGROUND", nil, -8)
t1:SetTexture(1,1,1)
t1:SetVertexColor(0,1,1)
t1:SetPoint("CENTER", UIParent, -256, 0)
t1:SetSize(64,64)

--create animation (rotation)
t1.ag = t1:CreateAnimationGroup()
t1.ag.a1 = t1.ag:CreateAnimation("Rotation")
t1.ag.a1:SetDegrees(-45)
t1.ag.a1:SetDuration(2)
t1.ag:SetLooping("REPEAT")
t1.ag:Play()

--texture
local t2 = f:CreateTexture(nil, "BACKGROUND", nil, -8)
t2:SetTexture(1,1,1)
t2:SetVertexColor(0,1,1)
t2:SetPoint("CENTER", UIParent, -128, 0)
t2:SetSize(64,64)

--create animation (rotation)
t2.ag = t2:CreateAnimationGroup()
t2.ag.a1 = t2.ag:CreateAnimation("Translation")
t2.ag.a1:SetOffset(32,16)
t2.ag.a1:SetDuration(2)
t2.ag:SetLooping("REPEAT")
t2.ag:Play()

--texture
local t3 = f:CreateTexture(nil, "BACKGROUND", nil, -8)
t3:SetTexture(1,1,1)
t3:SetVertexColor(0,1,1)
t3:SetPoint("CENTER", UIParent, 0, 0)
t3:SetSize(64,64)

--create animation (rotation)
t3.ag = t3:CreateAnimationGroup()
t3.ag.a1 = t3.ag:CreateAnimation("Scale")
t3.ag.a1:SetFromScale(0.3,0.3) --x and y scaling factor
t3.ag.a1:SetToScale(1.5,2) --x and y scaling factor
t3.ag.a1:SetDuration(2)
t3.ag:SetLooping("REPEAT")
t3.ag:Play()

--texture
local t4 = f:CreateTexture(nil, "BACKGROUND", nil, -8)
t4:SetTexture(1,1,1)
t4:SetVertexColor(0,1,1)
t4:SetPoint("CENTER", UIParent, 128, 0)
t4:SetSize(64,64)

--create animation (rotation)
t4.ag = t4:CreateAnimationGroup()
t4.ag.a1 = t4.ag:CreateAnimation("Alpha")
t4.ag.a1:SetFromAlpha(1)
t4.ag.a1:SetToAlpha(0)
t4.ag.a1:SetDuration(2)
t4.ag:SetLooping("REPEAT")
t4.ag:Play()

--texture
local t5 = f:CreateTexture(nil, "BACKGROUND", nil, -8)
t5:SetTexture(1,1,1)
t5:SetVertexColor(0,1,1)
t5:SetPoint("CENTER", UIParent, 256, 0)
t5:SetSize(64,64)

--create animation (rotation)
t5.ag = t5:CreateAnimationGroup()
t5.ag.a1 = t5.ag:CreateAnimation("Alpha")
t5.ag.a1:SetFromAlpha(1)
t5.ag.a1:SetToAlpha(0)
t5.ag.a1:SetDuration(2)
t5.ag.a2 = t5.ag:CreateAnimation("Scale")
t5.ag.a2:SetFromScale(0.3,0.3) --x and y scaling factor
t5.ag.a2:SetToScale(1.5,2) --x and y scaling factor
t5.ag.a2:SetDuration(2)
t5.ag.a3 = t5.ag:CreateAnimation("Rotation")
t5.ag.a3:SetDegrees(-45)
t5.ag.a3:SetDuration(2)
t5.ag.a4 = t5.ag:CreateAnimation("Translation")
t5.ag.a4:SetOffset(32,16)
t5.ag.a4:SetDuration(2)
t5.ag:SetLooping("REPEAT")
t5.ag:Play()