
-- rBuffFrameDurationBar: core
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Functions
-----------------------------

local function CreateBar(button)
  local bar = CreateFrame("StatusBar", nil, button)
  bar:SetPoint("BOTTOMLEFT")
  bar:SetPoint("BOTTOMRIGHT")
  bar:SetHeight(10)
  local t = bar:CreateTexture()
  t:SetColorTexture(1,1,1)
  t:SetVertexColor(0,1,0)
  bar:SetStatusBarTexture(t)
  button.duration:HookScript("OnShow",bar.Show)
  button.duration:HookScript("OnHide",bar.Hide)
  if not button.duration:IsShown() then
    bar:Hide()
  end
  return bar
end

local function UpdateDuration(button, timeleft)
  if not button then return end
  button.durationBar = button.durationBar or CreateBar(button)
  --print(button:GetID(),button.unit,button.filter,button.timeMod,button.expirationTime,timeLeft,GetTime())
  local name, rank, texture, count, debuffType, duration, expirationTime, _, _, _, spellId, _, _, _, _, timeMod = UnitAura(button.unit, button:GetID(), button.filter)
  if not name then return end
  if duration and expirationTime and duration > 0 then
    button.durationBar:SetMinMaxValues(exipirationTime-duration, exipirationTime)
    button.durationBar:SetValue(GetTime())
  end
end

hooksecurefunc("AuraButton_UpdateDuration", UpdateDuration)