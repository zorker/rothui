
-- rStatusButton: core
-- zork, 2019

-----------------------------
-- Variables
-----------------------------

local A, L = ...

local GameTooltip = GameTooltip

-----------------------------
-- Functions
-----------------------------

--OnEnter
local function OnEnter(self)
  GameTooltip:SetOwner(self, "ANCHOR_TOP")
  GameTooltip:AddLine(self:GetName(), 1, 0.5, 0, 1, 1, 1)
  --experience
  if UnitLevel("player") < MAX_PLAYER_LEVEL then
    local cur, max = UnitXP("player"), UnitXPMax("player")
    local lvl = UnitLevel("player")
    local rested = GetXPExhaustion()
    GameTooltip:AddLine("Experience", 0, 1, 0.5, 1, 1, 1)
    GameTooltip:AddDoubleLine("Level", lvl, 1, 1, 1, 1, 1, 1)
    GameTooltip:AddDoubleLine("Cur / Max", cur.." / "..max, 1, 1, 1, 1, 1, 1)
    GameTooltip:AddDoubleLine("Needed", (max-cur), 1, 1, 1, 1, 1, 1)
    GameTooltip:AddDoubleLine("Rested", rested, 1, 1, 1, 1, 1, 1)
  end
  --pvp
  local pvpRankName = GetPVPRankInfo(UnitPVPRank("player"), "player")
  if pvpRankName then
    GameTooltip:AddLine("PvP", 0, 1, 0.5, 1, 1, 1)
    GameTooltip:AddDoubleLine("Rank", pvpRankName, 1, 1, 1, 1, 1, 1)
  end
  --reputation
  local name, standing, min, max, cur = GetWatchedFactionInfo()
  if name then
    GameTooltip:AddLine(name.." Reputation", 0, 1, 0.5, 1, 1, 1)
    GameTooltip:AddDoubleLine("Level", _G["FACTION_STANDING_LABEL"..standing], 1, 1, 1, 1, 1, 1)
    GameTooltip:AddDoubleLine("Cur / Max", cur.." / "..max, 1, 1, 1, 1, 1, 1)
    GameTooltip:AddDoubleLine("Needed", (max-cur), 1, 1, 1, 1, 1, 1)
  end
  GameTooltip:Show()
end

--OnLeave
local function OnLeave(self)
  GameTooltip:Hide()
end

--OnClick
local function OnClick(self)
  self.count = self.count+1
  if self.count % 2 == 0 then
    self.gem:SetTexture(L.mediapath.."chatgem_inactive")
  else
    self.gem:SetTexture(L.mediapath.."chatgem_active")
  end
end

-----------------------------
-- Init
-----------------------------

local button = CreateFrame("Button", A, UIParent, SecureHandlerStateTemplate)
button:SetScale(L.C.scale)
button:SetPoint(unpack(L.C.point))
button:SetSize(unpack(L.C.size))
button.frameVisibility = L.C.frameVisibility
button.frameVisibilityFunc = L.C.frameVisibilityFunc
local gem = button:CreateTexture(nil, "BACKGROUND",nil,-8)
gem:SetTexture(L.mediapath.."chatgem_active")
gem:SetAllPoints()
button.gem = gem
button.count = 1
RegisterStateDriver(button, L.C.frameVisibilityFunc or "visibility", L.C.frameVisibility)
button:SetScript("OnEnter", OnEnter)
button:SetScript("OnLeave", OnLeave)
button:SetScript("OnClick", OnClick)

--OnShow fader
if L.C.fader then
  rLib:CreateFrameFader(button, L.C.fader)
end

--drag frame
rLib:CreateDragFrame(button, L.dragFrames, -2, true)

--create slash commands
rLib:CreateSlashCmd(L.addonName, L.addonShortcut, L.dragFrames, L.addonColor)