
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
  --azerite
  local azeriteItemLocation = C_AzeriteItem.FindActiveAzeriteItem()
  if azeriteItemLocation then
    local cur, max = C_AzeriteItem.GetAzeriteItemXPInfo(azeriteItemLocation)
    local lvl = C_AzeriteItem.GetPowerLevel(azeriteItemLocation)
    GameTooltip:AddLine("Azerite", 0, 1, 0.5, 1, 1, 1)
    GameTooltip:AddDoubleLine("Level", lvl, 1, 1, 1, 1, 1, 1)
    GameTooltip:AddDoubleLine("Cur/Max", cur.." / "..max, 1, 1, 1, 1, 1, 1)
    GameTooltip:AddDoubleLine("Needed", (max-cur), 1, 1, 1, 1, 1, 1)
  end
  --experience
  if UnitLevel("player") < MAX_PLAYER_LEVEL and not IsXPUserDisabled() then
    local cur, max = UnitXP("player"), UnitXPMax("player")
    local level = UnitLevel("player")
    local rested = GetXPExhaustion()
    GameTooltip:AddLine("Experience", 0, 1, 0.5, 1, 1, 1)
    GameTooltip:AddDoubleLine("Level", lvl, 1, 1, 1, 1, 1, 1)
    GameTooltip:AddDoubleLine("Cur/Max", cur.." / "..max, 1, 1, 1, 1, 1, 1)
    GameTooltip:AddDoubleLine("Needed", (max-cur), 1, 1, 1, 1, 1, 1)
    GameTooltip:AddDoubleLine("Rested", rested, 1, 1, 1, 1, 1, 1)
  end
  --honor
  --if InActiveBattlefield() or IsInActiveWorldPVP() then
    local cur, max = UnitHonor("player"), UnitHonorMax("player")
    local level = UnitHonorLevel("player")
    GameTooltip:AddLine("Honor", 0, 1, 0.5, 1, 1, 1)
    GameTooltip:AddDoubleLine("Level", lvl, 1, 1, 1, 1, 1, 1)
    GameTooltip:AddDoubleLine("Cur/Max", cur.." / "..max, 1, 1, 1, 1, 1, 1)
    GameTooltip:AddDoubleLine("Needed", (max-cur), 1, 1, 1, 1, 1, 1)
  --end
  --reputation
  local name, standing, min, max, cur = GetWatchedFactionInfo()
  if name then
    GameTooltip:AddLine(name.."Reputation", 0, 1, 0.5, 1, 1, 1)
    GameTooltip:AddDoubleLine("Level", _G["FACTION_STANDING_LABEL"..standing], 1, 1, 1, 1, 1, 1)
    GameTooltip:AddDoubleLine("Cur/Max", cur.." / "..max, 1, 1, 1, 1, 1, 1)
    GameTooltip:AddDoubleLine("Needed", (max-cur), 1, 1, 1, 1, 1, 1)
  end
  GameTooltip:Show()
end

local function OnLeave(self)
  GameTooltip:Hide()
end

local function OnClick(self)
  self.count = self.count+1
  if self.count % 2 == 0 then
    self.gem:SetTexture(L.mediapath.."chatgem_active")
  else
    self.gem:SetTexture(L.mediapath.."chatgem_inactive")
  end
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
local gem = button:CreateTexture(nil, "BACKGROUND",nil,-8)
gem:SetTexture(L.mediapath.."chatgem_active")
gem:SetAllPoints()
button.gem = gem
button.count = 1
RegisterStateDriver(button, cfg.frameVisibilityFunc or "visibility", cfg.frameVisibility)
button:SetScript("OnEnter", OnEnter)
button:SetScript("OnLeave", OnLeave)
button:SetScript("OnClick", OnClick)

--drag frame
rLib:CreateDragFrame(frame, L.dragFrames, -2, true)

--create slash commands
rLib:CreateSlashCmd(L.addonName, L.addonShortcut, L.dragFrames, L.addonColor)