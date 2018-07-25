
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
  MicroButtonAndBagsBar, MainMenuBarArtFrame, StatusTrackingBarManager,
  ActionBarDownButton, ActionBarUpButton, MainMenuBarVehicleLeaveButton,
  OverrideActionBar,
  OverrideActionBarExpBar, OverrideActionBarHealthBar, OverrideActionBarPowerBar, OverrideActionBarPitchFrame,
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
  --bring back the currency
  local function OnEvent(self,event)
    TokenFrame_LoadUI()
    TokenFrame_Update()
    BackpackTokenFrame_Update()
  end
  hiddenFrame:SetScript("OnEvent",OnEvent)
  hiddenFrame:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
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