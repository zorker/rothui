
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

local function Okay(self,...)
  --xpcall(function(...) print(...) end, geterrorhandler())
  print(self:GetName(),"okay")
end

local function Default(self,...)
  print(self:GetName(),"default")
end

local function Refresh(panel,...)
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

local function Cancel(self,...)
  print(self:GetName(),"cancel")
end

local function InitPanelButtons(panel)
  panel.okay = Okay
  panel.cancel = Cancel
  panel.refresh = Refresh
  panel.default = Default
end

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

local function CreatePanelButton(panel,blizzardButton,i,r)
  if not blizzardButton then return end
  local k = i+NUM_ACTIONBAR_BUTTONS*r
  local button = CreateFrame("Button", A.."PanelButton"..k, panel, "ActionButtonTemplate, SecureHandlerClickTemplate")
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
  table.insert(panel.buttons,button)
end

local function CreatePanelButtons(panel)
  panel.buttons = {}
  for i = 1, NUM_ACTIONBAR_BUTTONS do
    CreatePanelButton(panel,_G["ActionButton"..i],i,0)
    CreatePanelButton(panel,_G["MultiBarBottomLeftButton"..i],i,1)
    CreatePanelButton(panel,_G["MultiBarBottomRightButton"..i],i,2)
    CreatePanelButton(panel,_G["MultiBarRightButton"..i],i,3)
    CreatePanelButton(panel,_G["MultiBarLeftButton"..i],i,4)
  end
end

--mainPanel
local panel = CreateFrame("Frame", A.."MainPanel", UIParent)
panel.name = A
InitPanelButtons(panel)
CreatePanelHeader(panel,"Buttons","Setup your aura buttons here.")
CreatePanelButtons(panel)
InterfaceOptions_AddCategory(panel)
L.P.mainPanel = panel

--childPanel1
--[[ L.P.childPanel1 = CreateFrame("Frame", A.."ChildPanel1", L.P.mainPanel)
L.P.childPanel1.name = L.P.childPanel1:GetName()
L.P.childPanel1.parent = L.P.mainPanel.name
InitPanelButtons(L.P.childPanel1)
InterfaceOptions_AddCategory(L.P.childPanel1) ]]

