
-- rStatusButton: core
-- zork, 2018

-----------------------------
-- Variables
-----------------------------

local A, L = ...

L.addonName       = A
L.dragFrames      = {}
L.addonColor      = "00FF00AA"
L.addonShortcut   = "rsb"

L.mediapath       = "interface\\addons\\"..A.."\\media\\"

local GameTooltip, C_AzeriteItem = GameTooltip, C_AzeriteItem

-----------------------------
-- Config
-----------------------------

local cfg = {
  scale = 0.9,
  point = { "TOP", 0, -150 },
  size = { 32, 32 },
  frameVisibility = "[petbattle][overridebar][vehicleui][possessbar][shapeshift] hide; [mod] show; hide"
  frameVisibilityFunc = nil
}

-----------------------------
-- Functions
-----------------------------

local function OnEnter(self)
  GameTooltip:SetOwner(self, "ANCHOR_TOP")
  GameTooltip:AddLine(self:GetName(), 0, 1, 0.5, 1, 1, 1)
  --azeriteItemLocation
  local azeriteItemLocation = C_AzeriteItem.FindActiveAzeriteItem()
  if azeriteItemLocation then
    local cur, max = C_AzeriteItem.GetAzeriteItemXPInfo(azeriteItemLocation)
    local level = C_AzeriteItem.GetPowerLevel(azeriteItemLocation)
    GameTooltip:AddDoubleLine("AzeriteItemXP", cur.." / "..max, 1, 1, 1, 1, 1, 1)
    GameTooltip:AddDoubleLine("AzeriteItemLvl", level, 1, 1, 1, 1, 1, 1)
  end
  GameTooltip:Show()
end

local function OnLeave(self)
  GameTooltip:Hide()
end

-----------------------------
-- Init
-----------------------------

local button = CreateFrame("Button", A, UIParent, SecureHandlerStateTemplate)
button:SetScale(cfg.scale)
button:SetPoint(unpack(cfg.point))
button:SetSize(unpack(cfg.size))
button.frameVisibility = cfg.frameVisibility
button.frameVisibilityFunc = nil
RegisterStateDriver(button, cfg.frameVisibilityFunc or "visibility", cfg.frameVisibility)

button:SetScript("OnEnter", OnEnter)
button:SetScript("OnLeave", OnLeave)

local gem = button:CreateTexture(nil, "BACKGROUND",nil,-8)
gem:SetTexture(L.mediapath.."chatgem_active.tga")
gem:SetAllPoints()
button.gem = gem

--drag frame
rLib:CreateDragFrame(frame, L.dragFrames, -2, true)

--create slash commands
rLib:CreateSlashCmd(L.addonName, L.addonShortcut, L.dragFrames, L.addonColor)