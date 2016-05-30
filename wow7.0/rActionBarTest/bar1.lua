
-- rActionBar: bar1
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

local hiddenFrame = CreateFrame("Frame")
hiddenFrame:Hide()

local framesToHide = {
  OverrideActionBar, MainMenuBar,
}

--hide all frames
for i, frame in next, framesToHide do
  frame:SetParent(hiddenFrame)
  frame:UnregisterAllEvents()
end

--create new parent frame
local frame = CreateFrame("Frame", "rABSTestBar1", UIParent, "SecureHandlerStateTemplate")
frame:SetPoint("BOTTOM",0,10)
frame:SetScale(1)
frame:SetSize(36,36)

for i=1,12 do
  local button = _G["ActionButton"..i];
  button:SetParent(frame);
  frame:SetFrameRef("ActionButton"..i, button);
end

ActionButton1:ClearAllPoints()
ActionButton1:SetPoint("CENTER")

OverrideActionBar.LeaveButton:SetParent(frame)
OverrideActionBar.LeaveButton:SetAllPoints(ActionButton12)
OverrideActionBar.LeaveButton:Hide()
frame:SetFrameRef("LeaveVehicle", OverrideActionBar.LeaveButton)

frame:Execute([[
  frame = self
  buttons = table.new()
  for i = 1, 12 do
    table.insert(buttons, self:GetFrameRef("ActionButton"..i))
  end
  leave = self:GetFrameRef("LeaveVehicle")
]])

frame:SetAttribute("_onstate-page", [[
  --print("newstate",newstate,type(newstate))
  local s=SecureCmdOptionParse
  print(s("[bonusbar]bb;no-bb"),s("[canexitvehicle]cev;no-cev"),s("[overridebar]ob;no-ob"),s("[possessbar]pb;no-pb"),s("[shapeshift]ss;no-ss"),s("[vehicleui]vui;no-vui"),s("[@vehicle,exists]ve;no-ve"))
  --print("GetShapeshiftForm", GetShapeshiftForm())
  --print("GetActionBarPage", GetActionBarPage())
  --print("GetBonusBarOffset", GetBonusBarOffset())
  --print("HasVehicleActionBar", HasVehicleActionBar())
  --print("HasOverrideActionBar", HasOverrideActionBar())
  --print("HasTempShapeshiftActionBar", HasTempShapeshiftActionBar())
  --print("HasOverrideUI", HasOverrideUI())
  --print("GetVehicleBarIndex", GetVehicleBarIndex())
  --print("GetOverrideBarIndex", GetOverrideBarIndex())
  --print("HasExtraActionBar", HasExtraActionBar())
  --print("GetTempShapeshiftBarIndex", GetTempShapeshiftBarIndex())
  --print("CanExitVehicle", CanExitVehicle())
  --print("HasBonusActionBar", HasBonusActionBar())
  --print("GetBonusBarIndex", GetBonusBarIndex())

  --emulate the actionbar controller
  if HasVehicleActionBar() then
      newstate = GetVehicleBarIndex()
  elseif HasOverrideActionBar() then
      newstate = GetOverrideBarIndex()
  elseif HasTempShapeshiftActionBar() then
      newstate = GetTempShapeshiftBarIndex()
  elseif GetBonusBarOffset() > 0 then
      newstate = GetBonusBarOffset()+6
  else
      newstate = GetActionBarPage()
  end

  print("newstate",newstate,type(newstate))

  for i, button in ipairs(buttons) do
    button:SetAttribute("actionpage", newstate);
  end
  if CanExitVehicle() then
    leave:Show()
  else
    leave:Hide()
  end
]])

RegisterStateDriver(frame, "page", "[vehicleui] 12; [possessbar] 12; [overridebar] 14; [shapeshift] 13; [bar:2] 2; [bar:3] 3; [bar:4] 4; [bar:5] 5; [bar:6] 6; [bonusbar:1] 7; [bonusbar:2] 8; [bonusbar:3] 9; [bonusbar:4] 10; 1")
