-- lib actionbutton test for spellflyout
-- zork, 2024

-----------------------------
-- Variables
-----------------------------

local A, L = ...

local faderConfig = {
  fadeInAlpha = 1,
  fadeInDuration = 0.3,
  fadeInSmooth = "OUT",
  fadeOutAlpha = 0.3,
  fadeOutDuration = 0.9,
  fadeOutSmooth = "OUT",
  fadeOutDelay = 0,
}

-----------------------------
-- Functions
-----------------------------

--GetButtonList
local function GetButtonList(buttonName,numButtons)
  local buttonList = {}
  for i=1, numButtons do
    local button = _G[buttonName..i]
    if not button then break end
    table.insert(buttonList, button)
  end
  return buttonList
end

--AddActionButtonFader
local function AddActionButtonFader(bar)
  local buttonList = GetButtonList(bar:GetName().."Button", NUM_ACTIONBAR_BUTTONS)
  rLib:CreateButtonFrameFader(bar, buttonList, faderConfig)
end

--CreateTestBar
local function CreateTestBar()

  local buttonSize = 45
  local buttonPaddingX = 2

  -- Create a Header to drive this
  local bar = CreateFrame("Frame", "MyTestBar", UIParent, "SecureHandlerStateTemplate")
  bar:SetPoint("CENTER", 0, 0)
  bar:SetSize(buttonSize,buttonSize)
  local bg = bar:CreateTexture(nil, "BACKGROUND")
  bg:SetAllPoints(bar)
  bg:SetColorTexture(1,1,1)
  bg:SetVertexColor(0,1,0,0.8)
  bar:Show()
  bar:EnableMouse(true)
  RegisterStateDriver(MyTestBar, "page", "[mod:alt]2;1")
  bar:SetAttribute("_onstate-page", [[
      self:SetAttribute("state", newstate)
      control:ChildUpdate("state", newstate)
  ]])

  -- Create a button on the header
  local button1 = LibStub("LibActionButton-1.0"):CreateButton(1, "MyTestBarButton1", MyTestBar)
  button1:SetPoint("LEFT", 0,  0)
  button1:Show()
  button1:SetState(1, "action", 1)
  button1:SetState(2, "action", 2)

  --AddActionButtonFader for MyTestBar
  AddActionButtonFader(MyTestBar)

  --hook LABFlyout after login (not loaded before)
  --works only after first init of LibActionButton Bar
  LABFlyoutHandlerFrame:HookScript("OnShow", rLib.LABFlyoutHandlerFrameOnShow)

end

rLib:RegisterCallback("PLAYER_LOGIN", CreateTestBar)