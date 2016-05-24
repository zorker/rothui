
-- rActionBar: blizzard
-- zork, 2016

-----------------------------
-- Config
-----------------------------

local cfg = {}

-----------------------------
-- Local Variables
-----------------------------

local A, L = ...

local hiddenFrame = CreateFrame("Frame")
hiddenFrame:Hide()

local texturesToHide = {
  StanceBarLeft, StanceBarMiddle, StanceBarRight,
  SlidingActionBarTexture0, SlidingActionBarTexture1,
  PossessBackground1, PossessBackground2,
  MainMenuBarTexture0, MainMenuBarTexture1, MainMenuBarTexture2, MainMenuBarTexture3,
  MainMenuBarLeftEndCap, MainMenuBarRightEndCap
}

local framesToHide = {
  MainMenuBar, MainMenuBarPageNumber,
  ActionBarDownButton, ActionBarUpButton,
  OverrideActionBarExpBar, OverrideActionBarHealthBar, OverrideActionBarPowerBar, OverrideActionBarPitchFrame
}

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
  "LeaveHighlight",
  "HealthBarBG",
  "HealthBarOverlay",
  "PowerBarBG",
  "PowerBarOverlay",
}

-----------------------------
-- Init
-----------------------------

--hide all textures
for idx, texture in next, texturesToHide do
  texture:SetTexture(nil)
end

--hide all frames
for idx, frame in next, framesToHide do
  frame:SetParent(hiddenFrame)
end

--ResetTexture function
local function ResetTexture(self,textureFile)
  if textureFile then self:SetTexture(nil) end
end

--hide all override textures
for idx, texture in next, overridebarTextures do
  hooksecurefunc(OverrideActionBar[texture], "SetTexture", ResetTexture)
end