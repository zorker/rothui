
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
  local cur, max, lvl, rested
  GameTooltip:SetOwner(self, "ANCHOR_TOP")
  GameTooltip:AddLine(self:GetName(), 0, 1, 0.5, 1, 1, 1)
  --azeriteItemLocation
  local azeriteItemLocation = C_AzeriteItem.FindActiveAzeriteItem()
  if azeriteItemLocation then
    cur, max = C_AzeriteItem.GetAzeriteItemXPInfo(azeriteItemLocation)
    lvl = C_AzeriteItem.GetPowerLevel(azeriteItemLocation)
    GameTooltip:AddLine("Azerite", 0, 1, 0.5, 1, 1, 1)
    GameTooltip:AddDoubleLine("Level", lvl, 1, 1, 1, 1, 1, 1)
    GameTooltip:AddDoubleLine("Experience", cur.." / "..max, 1, 1, 1, 1, 1, 1)
  end
  if UnitLevel("player") < MAX_PLAYER_LEVEL and not IsXPUserDisabled() then
    cur, max = UnitXP("player"), UnitXPMax("player")
    level = UnitLevel("player")
    rested = GetXPExhaustion()
    GameTooltip:AddDoubleLine("Level", lvl, 1, 1, 1, 1, 1, 1)
    GameTooltip:AddDoubleLine("Experience", cur.." / "..max, 1, 1, 1, 1, 1, 1)
    GameTooltip:AddDoubleLine("Rested Experience", rested, 1, 1, 1, 1, 1, 1)
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
button.frameVisibilityFunc = cfg.frameVisibilityFunc
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