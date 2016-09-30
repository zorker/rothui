

-- rClipThing: core
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Config
-----------------------------

local f = CreateFrame("ScrollFrame",A.."MyFrame",UIParent)
f:SetSize(256,32)
f:SetPoint("CENTER")

local t = f:CreateTexture(nil,"BACKGROUND",nil,-8)
t:SetAllPoints()
t:SetColorTexture(1,0,0)

local sc = CreateFrame("Frame")
f:SetScrollChild(sc)
sc:SetSize(256,32)


local t = sc:CreateTexture(nil,"BACKGROUND",nil,-8)
t:SetSize(512,512)
t:SetPoint("CENTER",-128,0)
t:SetBlendMode("MOD")
t:SetAlpha(1)

t:SetTexture("interface\\addons\\"..A.."\\cloudsphere")

t.ag = t:CreateAnimationGroup()
t.ag.anim = t.ag:CreateAnimation("Rotation")
t.ag.anim:SetDegrees(360)
t.ag.anim:SetDuration(20)
t.ag:SetLooping("REPEAT")
t.ag:Play()