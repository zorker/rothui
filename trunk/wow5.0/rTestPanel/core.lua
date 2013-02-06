
local UIP = UIParent
local CF = CreateFrame
local _G = _G
local unpack = unpack
local wipe = wipe

print("hello panel")

--<Frame name="FriendsFrame" toplevel="true" parent="UIParent" movable="true" enableMouse="true" hidden="true" inherits="ButtonFrameTemplate">

local rTestPanel = CF("Frame", "rTestPanel", UIP, "ButtonFrameTemplate")
rTestPanel:SetPoint("CENTER",0,0)
rTestPanel:SetClampedToScreen(true)
rTestPanel:SetMovable(true)
rTestPanel:SetUserPlaced(true)

rTestPanel:SetWidth(1024-100)
rTestPanel:SetWidth(768-100)

local icon = rTestPanel:CreateTexture("$parentIcon", "BACKGROUND", nil, -8)
icon:SetSize(60,60)
icon:SetPoint("TOPLEFT",-5,7)
icon:SetTexture("Interface\\FriendsFrame\\Battlenet-Portrait");

local orb = CreateFrame("PlayerModel", nil, rTestPanel)
orb:SetSize(60,60)
orb:SetPoint("TOPLEFT",-5,7)
orb:SetDisplayInfo(38699)
orb:SetCamDistanceScale(0.32)
orb:SetSize(80,80)
orb:SetPoint("TOPLEFT",-17,17)
orb:SetAlpha(1)

orb:EnableMouse(true)
orb:RegisterForDrag("LeftButton")
orb:SetScript("OnDragStart", function(self) self:GetParent():StartMoving() end)
orb:SetScript("OnDragStop", function(self) self:GetParent():StopMovingOrSizing() end)
orb:SetScript("OnEnter", function(self)
  GameTooltip:SetOwner(self, "ANCHOR_TOP")
  GameTooltip:AddLine("Tipp", 0, 1, 0.5, 1, 1, 1)
  GameTooltip:AddLine("Drag me!", 1, 1, 1, 1, 1, 1)
  GameTooltip:Show()
end)
orb:SetScript("OnLeave", function(s) GameTooltip:Hide() end)



rTestPanelTitleText:SetText("rTestPanel");



rTestPanel:Show()