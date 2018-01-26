-----------------------------
-- Variables
-----------------------------

local A, L = ...
local mediapath = "interface\\addons\\"..A.."\\"

--container
local f = CreateFrame("Frame",nil,UIParent)
f:SetPoint("CENTER")
f:SetSize(256,256)

--left ring frame with clip children
local lr = CreateFrame("Frame",nil,f)
lr:SetPoint("LEFT")
local w,h = f:GetSize()
lr:SetSize(w/2,h)
lr:SetClipsChildren(true)

--half pie/square mask texture
local m = lr:CreateMaskTexture()
m:SetTexture(mediapath.."half")
--m:SetTexture(mediapath.."half","CLAMP","CLAMP")
--CLAMP, REPEAT, CLAMPTOBLACK, CLAMPTOBLACKADDITIVE, CLAMPTOWHITE, MIRROR
m:SetSize(f:GetSize())
m:SetPoint("CENTER",f,"CENTER",0,0)

--ring texture
local t = lr:CreateTexture(nil,"BACKGROUND",nil,-8)
t:SetTexture(mediapath.."ring")
t:SetSize(f:GetSize())
t:SetPoint("CENTER",f,"CENTER",0,0)
t:SetVertexColor(1,0,0)
t:AddMaskTexture(m)
--t:RemoveMaskTexture(m)

--you can create additional textures on different layers and use the same mask

--animation group
local ag = m:CreateAnimationGroup()
local anim = ag:CreateAnimation("Rotation")
anim:SetDegrees(360)
anim:SetDuration(10)
ag:Play()
ag:SetLooping("REPEAT")