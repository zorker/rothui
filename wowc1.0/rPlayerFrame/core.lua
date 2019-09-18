
-- rPlayerFrame: core
-- zork, 2019

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Init
-----------------------------

--using code from Semlar (https://www.wowinterface.com/forums/showthread.php?t=48971)
local frame = CreateFrame("Frame", nil, nil, "SecureHandlerStateTemplate")
frame:SetFrameRef("PlayerFrame", PlayerFrame)
frame:SetAttribute("_onstate-display", [[
  if newstate == "show" then
    self:GetFrameRef("PlayerFrame"):Show()
  else
    self:GetFrameRef("PlayerFrame"):Hide()
  end
]])
RegisterStateDriver(frame, "display", L.C.frameVisibility)

--PlayerFrameTexture
PlayerFrameTexture:SetAlpha(L.C.textureAlpha)
TargetFrameTextureFrameTexture:SetAlpha(L.C.textureAlpha)
TargetFrameToTTextureFrameTexture:SetAlpha(L.C.textureAlpha)

--OnShow fader
if L.C.fader then
  rLib:CreateFrameFader(PlayerFrame, L.C.fader)
end
