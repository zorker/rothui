
-- rActionBar: blizzard
-- zork, 2019

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
}

local framesToDisable = {
  MainMenuBar,
  MicroButtonAndBagsBar, MainMenuBarArtFrame, StatusTrackingBarManager,
  ActionBarDownButton, ActionBarUpButton, MainMenuBarVehicleLeaveButton,
}

-----------------------------
-- Functions
-----------------------------

--DisableAllScripts
local function DisableAllScripts(frame)
  for i, script in next, scripts do
    if frame:HasScript(script) then
      frame:SetScript(script,nil)
    end
  end
end

--L:HideMainMenuBar
function L:HideMainMenuBar()
  for i, frame in next, framesToHide do
    frame:SetParent(hiddenFrame)
  end
  for i, frame in next, framesToDisable do
    frame:UnregisterAllEvents()
    DisableAllScripts(frame)
  end
end

--fix blizzard cooldown flash
local function FixCooldownFlash(self)
  if not self then return end
  if self:GetEffectiveAlpha() > 0 then
    self:Show()
  else
    self:Hide()
  end
end
hooksecurefunc(getmetatable(ActionButton1Cooldown).__index, "SetCooldown", FixCooldownFlash)