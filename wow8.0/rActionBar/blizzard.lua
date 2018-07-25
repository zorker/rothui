
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

local scripts = {
  "OnShow", "OnHide", "OnEvent", "OnEnter", "OnLeave", "OnUpdate", "OnValueChanged", "OnClick", "OnMouseDown", "OnMouseUp",
}

local framesToHide = {
  MainMenuBar,
  OverrideActionBar,
}

local framesToDisable = {
  MainMenuBar,
  --MicroButtonAndBagsBar, MainMenuBarArtFrame
  ActionBarDownButton, ActionBarUpButton, MainMenuBarVehicleLeaveButton, ExhaustionTick,
  --ReputationWatchBar, ArtifactWatchBar, HonorWatchBar, MainMenuExpBar, MainMenuBarMaxLevelBar,
  OverrideActionBar,
  OverrideActionBarExpBar, OverrideActionBarHealthBar, OverrideActionBarPowerBar, OverrideActionBarPitchFrame,
}

-----------------------------
-- Init
-----------------------------

local function DisableAllScripts(frame)
  if not frame then return end
  for i, script in next, scripts do
    if frame:HasScript(script) then
      frame:SetScript(script,nil)
    end
  end
end

--hide main menu bar
function L:HideMainMenuBar()
  for i, frame in next, framesToHide do
    if frame then
      frame:SetParent(hiddenFrame)
    end
  end
  for i, frame in next, framesToDisable do
    if frame then
      frame:UnregisterAllEvents()
      DisableAllScripts(frame)
    end
  end
end

--fix blizzard cooldown flash
hooksecurefunc(getmetatable(ActionButton1Cooldown).__index, 'SetCooldown', function(self)
  if not self then return end
  if self:GetEffectiveAlpha() > 0 then
    self:Show()
  else
    self:Hide()
  end
end)