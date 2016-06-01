
-- rActionBar: blizzard
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
  ExtraActionButton1.style
}

local scripts = {
  "OnShow", "OnHide", "OnEvent", "OnEnter", "OnLeave", "OnUpdate", "OnValueChanged", "OnClick", "OnMouseDown", "OnMouseUp",
}

local framesToHide = {
  MainMenuBar,
  ActionBarDownButton, ActionBarUpButton, MainMenuBarVehicleLeaveButton, ExhaustionTick,
  ReputationWatchBar, ArtifactWatchBar, HonorWatchBar, MainMenuExpBar, MainMenuBarMaxLevelBar,
  OverrideActionBar,
  OverrideActionBarExpBar, OverrideActionBarHealthBar, OverrideActionBarPowerBar, OverrideActionBarPitchFrame,
  PossessBarFrame,
  --MainMenuBarArtFrame, artframe has to stay alive probably
}

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

--hide main menu bar
function L:HideMainMenuBar()
  for i, frame in next, framesToHide do
    frame:SetParent(hiddenFrame)
    frame:UnregisterAllEvents()
    DisableAllScripts(frame)
  end
end

--ResetTexture function
local function ResetTexture(self,textureFile)
  if textureFile then self:SetTexture(nil) end
end

--hook extraactionbutton1 SetTexture
hooksecurefunc(ExtraActionButton1.style, "SetTexture", ResetTexture)
