
local UIP = UIParent
local CF = CreateFrame
local _G = _G
local unpack = unpack
local wipe = wipe
local tinsert = tinsert

print("hello panel")

local rTestPanel = CF("Frame", "rTestPanel", UIP, "ButtonFrameTemplate")
rTestPanel:SetFrameStrata("HIGH")
rTestPanel:SetPoint("CENTER",0,0)
rTestPanel:SetClampedToScreen(true)
rTestPanel:SetMovable(true)
rTestPanel:SetUserPlaced(true)
rTestPanel:EnableMouse(true)

rTestPanel:SetWidth(1024-200)
rTestPanel:SetHeight(768-200)

rTestPanelTitleText:SetText("rTestPanel")
rTestPanel:Show()

local icon = rTestPanel:CreateTexture("$parentIcon", "BACKGROUND", nil, -8)
icon:SetSize(60,60)
icon:SetPoint("TOPLEFT",-5,7)
icon:SetTexture("Interface\\FriendsFrame\\Battlenet-Portrait")

local orb = CreateFrame("PlayerModel", nil, rTestPanel)
orb:SetSize(60,60)
orb:SetPoint("TOPLEFT",-5,7)
orb:SetDisplayInfo(38699)
orb:SetCamDistanceScale(0.32)
orb:SetSize(80,80)
orb:SetPoint("TOPLEFT",-17,17)
orb:SetAlpha(0.2)

orb:EnableMouse(true)
orb:RegisterForDrag("LeftButton")
orb:SetScript("OnDragStart", function(self) self:GetParent():StartMoving() end)
orb:SetScript("OnDragStop", function(self) self:GetParent():StopMovingOrSizing() end)
orb:SetScript("OnEnter", function(self)
  GameTooltip:SetOwner(self, "ANCHOR_TOP")
  GameTooltip:AddLine(self:GetParent():GetName(), 0, 1, 0.5, 1, 1, 1)
  GameTooltip:AddLine("Drag me!", 1, 1, 1, 1, 1, 1)
  GameTooltip:Show()
end)
orb:SetScript("OnLeave", function(s) GameTooltip:Hide() end)

-- create bottom tabs

rTestPanel.numTabs = 5
rTestPanel.selectedTab = 1
rTestPanel.subFrames = {}
rTestPanel.name = rTestPanel:GetName()

rTestPanel.showSubFrame = function(name)
  for index, value in pairs(rTestPanel.subFrames) do
    if (value == name) then
      print("showing "..name)
      _G[value]:Show()
    else
      print("hiding "..name)
      _G[value]:Hide()
    end	
  end 
end

local updatePanel = function(panel)
  PanelTemplates_UpdateTabs(panel)
  _G[panel.name.."TitleText"]:SetText(panel.name.."SubFrame"..panel.selectedTab)
  panel.showSubFrame(panel.name.."SubFrame"..panel.selectedTab)
end

local setPanel = function(panel,id)
  PanelTemplates_SetTab(panel, id)
  updatePanel(panel)
end

local createBottomTab = function(parent,index)
  local tab = CF("Button", "$parentTab"..index, parent, "CharacterFrameTabButtonTemplate")
  tab.text = "TAB"..index
  tab.id = index
  if index == 1 then
    tab:SetPoint("BOTTOMLEFT",5,-30)
  else
    tab:SetPoint("LEFT", "$parentTab"..index-1, "RIGHT", -15, 0)
  end
  tab:HookScript("OnClick", function(self) 
    print("click "..self.id) 
    setPanel(self:GetParent(), self.id)
  end)
  tab:SetText("Tab "..index)
end

for i = 1, rTestPanel.numTabs do
  createBottomTab(rTestPanel,i)
end

--create subframes
local createSubFrame = function(parent,index)
  local subframe = CF("Frame", "$parentSubFrame"..index, parent, nil)
  subframe:SetAllPoints()
  tinsert(rTestPanel.subFrames,subframe:GetName())
end

for i = 1, rTestPanel.numTabs do
  createSubFrame(rTestPanel,i)
end

updatePanel(rTestPanel)

rTestPanel:HookScript("OnShow",updatePanel)




