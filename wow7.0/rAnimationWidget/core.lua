
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

local button = CreateFrame("Button", A.."Button", UIParent, "UIPanelButtonTemplate")
button.text = _G[button:GetName().."Text"]
button.text:SetText("Pause")
button:SetWidth(button.text:GetStringWidth()+20)
button:SetHeight(button.text:GetStringHeight()+12)
button:SetPoint("CENTER",256,-64)
button:HookScript("OnClick", function(self)
  if t5.ag:IsPlaying() then
    t5.ag:Pause()
    self.text:SetText("Play")
  else
    t5.ag:Play()
    self.text:SetText("Pause")
  end
end)

--frame to test animation on
local f2 = CreateFrame("Frame", nil, UIParent)
f2:SetSize(128,128)
f2:SetPoint("CENTER",-128,-128)
f2:SetAlpha(0)

local m = CreateFrame("PlayerModel",nil,f2)
m:SetAllPoints()
--models defined on loadup are not rendered properly. model display needs to be delayed.
m:HookScript("OnEvent", function(self)
  self:SetCamDistanceScale(0.8)
  self:SetRotation(-0.4)
  self:SetDisplayInfo(21723) --murcloc costume
  self:UnregisterEvent("PLAYER_LOGIN")
end)
m:RegisterEvent("PLAYER_LOGIN")

--texture
local t = f2:CreateTexture(nil, "BACKGROUND", nil, -8)
t:SetTexture(1,1,1)
t:SetVertexColor(1,0,1)
t:SetAllPoints()

--create animation (rotation)
f2.ag = f2:CreateAnimationGroup()
f2.ag.a1 = f2.ag:CreateAnimation("Alpha")
f2.ag.a1:SetFromAlpha(1)
f2.ag.a1:SetToAlpha(0)
f2.ag.a1:SetDuration(2)
f2.ag.a2 = f2.ag:CreateAnimation("Scale")
f2.ag.a2:SetFromScale(0.3,0.3) --x and y scaling factor
f2.ag.a2:SetToScale(1.5,2) --x and y scaling factor
f2.ag.a2:SetDuration(2)
f2.ag.a3 = f2.ag:CreateAnimation("Rotation")
f2.ag.a3:SetDegrees(-45)
f2.ag.a3:SetDuration(2)
f2.ag.a4 = f2.ag:CreateAnimation("Translation")
f2.ag.a4:SetOffset(32,16)
f2.ag.a4:SetDuration(2)
f2.ag:HookScript("OnFinished", function(self)
  self:GetParent():SetAlpha(0)
end)

local button = CreateFrame("Button", A.."Button2", UIParent, "UIPanelButtonTemplate")
button.text = _G[button:GetName().."Text"]
button.text:SetText("Alpha")
button:SetWidth(button.text:GetStringWidth()+20)
button:SetHeight(button.text:GetStringHeight()+12)
button:SetPoint("CENTER",-256,-64)
button:HookScript("OnClick", function(self)
  f2.ag:Play()
end)