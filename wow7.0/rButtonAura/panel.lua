
-- rButtonAura: panel
-- zork, 2018

-----------------------------
-- Variables
-----------------------------

local A, L = ...

--panel container
L.P = {}

-----------------------------
-- Functions
-----------------------------

--IOFPanelOkay
local function IOFPanelOkay(panel,...)
  --xpcall(function(...) print(...) end, geterrorhandler())
  print(panel:GetName(),"okay")
end

--IOFPanelDefault
local function IOFPanelDefault(panel,...)
  print(panel:GetName(),"default")
  L.F.ResetDBG()
  L.F.ResetDBC()
end

--IOFPanelRefresh
local function IOFPanelRefresh(panel,...)
  print(panel:GetName(),"refresh")
  for i, button in next, panel.buttons do
    local type, id, subType, spellID = GetActionInfo(button.blizzardButton.action)
    --if type == "spell" or type == "macro" or type == "item" then
    if type then
      button.icon:SetTexture(button.blizzardButton.icon:GetTexture())
    else
      button.icon:SetColorTexture(0.05,0.05,0.05)
    end
  end
end

--IOFPanelCancel
local function IOFPanelCancel(panel,...)
  print(panel:GetName(),"cancel")
end

--InitIOFButtons
local function InitIOFButtons(panel)
  panel.okay = IOFPanelOkay
  panel.cancel = IOFPanelCancel
  panel.refresh = IOFPanelRefresh
  panel.default = IOFPanelDefault
end

--CreatePanelHeader
local function CreatePanelHeader(panel,title,subtitle)
  local t = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
  t:SetPoint("TOPLEFT", 16, -16)
  t:SetText(title)
  if not subtitle then return end
  local st = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
  st:SetHeight(32)
  st:SetPoint("TOPLEFT", t, "BOTTOMLEFT", 0, -8)
  st:SetPoint("RIGHT", panel, -32, 0)
  st:SetNonSpaceWrap(true)
  st:SetJustifyH("LEFT")
  st:SetJustifyV("TOP")
  st:SetText(subtitle)
end

--PanelActionButtonOnClick
local function PanelActionButtonOnClick(button)
  local panel = button.__owner
  if panel.activeActionButton and panel.activeActionButton ~= button and panel.activeActionButton:GetChecked() then
    --disable the last checked action button, only one may survive
    panel.activeActionButton:SetChecked(false)
  end
  if button:GetChecked() then
    panel.activeActionButton = button
  else
    panel.activeActionButton = nil
  end
end

--more templates!

--CheckButton "OptionsCheckButtonTemplate"
--CheckButton "OptionsSmallCheckButtonTemplate"
--CheckButton "InterfaceOptionsCheckButtonTemplate"
--CheckButton "UICheckButtonTemplate"
--CheckButton "UIRadioButtonTemplate"
--Slider "OptionsSliderTemplate"
--EditBox "InputBoxTemplate"

--CreatePanelActionButton
local function CreatePanelActionButton(panel,blizzardButton,i,r)
  if not blizzardButton then return end
  local k = i+NUM_ACTIONBAR_BUTTONS*r
  --"ActionButtonTemplate, SecureHandlerClickTemplate"
  local button = CreateFrame("Checkbutton", A.."PanelButton"..k, panel, "ActionButtonTemplate")
  button.__owner = panel
  button.blizzardButton = blizzardButton
  button:SetSize(32,32)
  if k == 1 then
    button:SetPoint("TOPLEFT", 16, -80)
  elseif i == 1 then
    local aboveButton = _G[A.."PanelButton"..(k-NUM_ACTIONBAR_BUTTONS)]
    button:SetPoint("TOPLEFT", aboveButton, "BOTTOMLEFT", 0, -8)
  else
    local prevButton = _G[A.."PanelButton"..(k-1)]
    button:SetPoint("LEFT", prevButton, "RIGHT", 8, 0)
  end
  button:HookScript("OnClick",PanelActionButtonOnClick)
  table.insert(panel.buttons,button)
end

--CreatePanelActionButtons
local function CreatePanelActionButtons(panel)
  panel.buttons = {}
  for i = 1, NUM_ACTIONBAR_BUTTONS do
    CreatePanelActionButton(panel,_G["ActionButton"..i],i,0)
    CreatePanelActionButton(panel,_G["MultiBarBottomLeftButton"..i],i,1)
    CreatePanelActionButton(panel,_G["MultiBarBottomRightButton"..i],i,2)
    CreatePanelActionButton(panel,_G["MultiBarRightButton"..i],i,3)
    CreatePanelActionButton(panel,_G["MultiBarLeftButton"..i],i,4)
  end
end

-----------------------------
-- Main Panel
-----------------------------

local panel = CreateFrame("Frame", A.."MainPanel", UIParent)
panel.name = A
InitIOFButtons(panel)
CreatePanelHeader(panel,"Button Aura Setup","Pick one of the action buttons and configure the aura you want to display on the button.")
CreatePanelActionButtons(panel)
InterfaceOptions_AddCategory(panel)
L.P.mainPanel = panel

--childPanel1
--[[ L.P.childPanel1 = CreateFrame("Frame", A.."ChildPanel1", L.P.mainPanel)
L.P.childPanel1.name = L.P.childPanel1:GetName()
L.P.childPanel1.parent = L.P.mainPanel.name
CreatePanelHeader(panel,"ChildPanel1Header","Nothing here yet.")
InterfaceOptions_AddCategory(L.P.childPanel1) ]]

