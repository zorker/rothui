
-- rActionBar: core/blizzard
-- zork, 2016

-----------------------------
-- Config
-----------------------------

local cfg = {}

-----------------------------
-- Variables
-----------------------------

local A, L = ...

local hiddenFrame = CreateFrame("Frame")
hiddenFrame:Hide()

local texturesToHide = {
  StanceBarLeft, StanceBarMiddle, StanceBarRight,
  SlidingActionBarTexture0, SlidingActionBarTexture1, --petbar background
  --PossessBackground1, PossessBackground2,
  --MainMenuBarTexture0, MainMenuBarTexture1, MainMenuBarTexture2, MainMenuBarTexture3,
  --MainMenuBarLeftEndCap, MainMenuBarRightEndCap,
  ExtraActionButton1.style
}

local scripts = {
  "OnShow", "OnHide", "OnEvent", "OnEnter", "OnLeave", "OnUpdate", "OnValueChanged", "OnClick", "OnMouseDown", "OnMouseUp",
}

local framesToHide = {
  MainMenuBar, ActionBarDownButton, ActionBarUpButton, MainMenuBarVehicleLeaveButton, ArtifactWatchBar, HonorWatchBar, MainMenuExpBar, MainMenuBarMaxLevelBar,
  OverrideActionBar, OverrideActionBarExpBar, OverrideActionBarHealthBar, OverrideActionBarPowerBar, OverrideActionBarPitchFrame,
  PossessBarFrame,
  --MainMenuBarArtFrame, artframe has to stay alive probably
}

--[[
local overridebarTextures =  {
  "_BG",
  "EndCapL",
  "EndCapR",
  "_Border",
  "Divider1",
  "Divider2",
  "Divider3",
  "ExitBG",
  "MicroBGL",
  "MicroBGR",
  "_MicroBGMid",
  "ButtonBGL",
  "ButtonBGR",
  "_ButtonBGMid",
  "PitchOverlay",
  "PitchButtonBG",
  "PitchBG",
  "PitchMarker",
  "PitchUpUp",
  "PitchUpDown",
  "PitchUpHighlight",
  "PitchDownUp",
  "PitchDownDown",
  "PitchDownHighlight",
  --"LeaveUp",
  --"LeaveDown",
  --"LeaveHighlight",
  "HealthBarBG",
  "HealthBarOverlay",
  "PowerBarBG",
  "PowerBarOverlay",
}
]]--

-----------------------------
-- Init
-----------------------------

--hide all textures
for i, texture in next, texturesToHide do
  texture:SetTexture(nil)
end

local function DisableAllScripts(frame)
  for i, script in next, scripts do
    if frame:HasScript(script) then
      frame:SetScript(script,nil)
    end
  end
end

--hide all frames
for i, frame in next, framesToHide do
  frame:SetParent(hiddenFrame)
  frame:UnregisterAllEvents()
  DisableAllScripts(frame)
end

--ResetTexture function
local function ResetTexture(self,textureFile)
  if textureFile then self:SetTexture(nil) end
end

--hook overridebar SetTexture
--for i, texture in next, overridebarTextures do
  --hooksecurefunc(OverrideActionBar[texture], "SetTexture", ResetTexture)
--end

--hook extraactionbutton1 SetTexture
hooksecurefunc(ExtraActionButton1.style, "SetTexture", ResetTexture)

--slideouts

local slideouts = {
  OverrideActionBar.slideout,
  MainMenuBar.slideout,
  MultiBarRight.slideout,
}

local function OnPlay(self)
  self:GetParent().hideOnFinish = true
  self:Stop()
end

--slideouts
for i, slideout in next, slideouts do
  slideout:SetScript("OnPlay", OnPlay)
  slideout:SetScript("OnFinished", nil)
end