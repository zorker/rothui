
-- rThreat: core
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

L.addonName       = A
L.dragFrames      = {}
L.addonColor      = "00FFAA00"
L.addonShortcut   = "rthreat"

-----------------------------
-- VARIABLES
-----------------------------

local threatData = {}
local oldtime = 0
local wipe = wipe
local select = select
local tinsert = tinsert
local sort = sort
local floor = floor
local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local FACTION_BAR_COLORS = FACTION_BAR_COLORS
local playerGUID = UnitGUID("player")

-----------------------------
-- FUNCTIONS
-----------------------------

--create backdrop func
local function CreateBackdrop(parent,cfg)
  --backdrop settings
  local backdrop = {
    bgFile = cfg.bgFile,
    edgeFile = cfg.edgeFile,
    tile = cfg.tile,
    tileSize = cfg.tileSize,
    edgeSize = cfg.edgeSize,
    insets = {
      left = cfg.inset,
      right = cfg.inset,
      top = cfg.inset,
      bottom = cfg.inset,
    },
  }
  local frame = CreateFrame("Frame",nil,parent)
  frame:SetPoint("TOPLEFT",parent,"TOPLEFT",-cfg.inset,cfg.inset)
  frame:SetPoint("BOTTOMRIGHT",parent,"BOTTOMRIGHT",cfg.inset,-cfg.inset)
  frame:SetBackdrop(backdrop)
  frame:SetBackdropColor(cfg.bgColor.r, cfg.bgColor.g, cfg.bgColor.b, cfg.bgColor.a)
  frame:SetBackdropBorderColor(cfg.edgeColor.r, cfg.edgeColor.g, cfg.edgeColor.b, cfg.edgeColor.a)
end

local function CreateStatusbar(parent)
  --statusbar
  local bar = CreateFrame("StatusBar", nil, parent)
  bar:SetSize(L.C.statusbar.width,L.C.statusbar.height)
  bar:SetMinMaxValues(0,100)
  bar:SetStatusBarTexture(L.C.statusbar.texture)
  --bg
  local bg = bar:CreateTexture(nil, "BACKGROUND",nil,-6)
  bg:SetTexture(L.C.statusbar.texture)
  bg:SetAllPoints(bar)
  --name
  local name = bar:CreateFontString(nil, "LOW")
  name:SetFont(L.C.statusbar.font.family, L.C.statusbar.font.size, L.C.statusbar.font.outline)
  name:SetVertexColor(L.C.statusbar.font.color.r, L.C.statusbar.font.color.g, L.C.statusbar.font.color.b, L.C.statusbar.font.color.a)
  name:SetPoint("LEFT", bar, 2, 0)
  name:SetJustifyH("LEFT")
  --perc
  local perc = bar:CreateFontString(nil, "LOW")
  perc:SetFont(L.C.statusbar.font.family, L.C.statusbar.font.size, L.C.statusbar.font.outline)
  perc:SetVertexColor(L.C.statusbar.font.color.r, L.C.statusbar.font.color.g, L.C.statusbar.font.color.b, L.C.statusbar.font.color.a)
  perc:SetPoint("RIGHT", bar, -2, 0)
  perc:SetJustifyH("RIGHT")
  --val
  local val = bar:CreateFontString(nil, "LOW")
  val:SetFont(L.C.statusbar.font.family, L.C.statusbar.font.size, L.C.statusbar.font.outline)
  val:SetVertexColor(L.C.statusbar.font.color.r, L.C.statusbar.font.color.g, L.C.statusbar.font.color.b, L.C.statusbar.font.color.a)
  val:SetPoint("RIGHT", bar, -40, 0)
  val:SetJustifyH("RIGHT")
  name:SetPoint("RIGHT", val, "LEFT", -10, 0) --right point of name is left point of value
  --references
  bar.bg = bg
  bar.name = name
  bar.perc = perc
  bar.val = val
  --initial values
  bar.name:SetText("")
  bar.perc:SetText("")
  bar.val:SetText("")
  bar.bg:SetVertexColor(L.C.statusbar.color.inactive.r, L.C.statusbar.color.inactive.g, L.C.statusbar.color.inactive.b, L.C.statusbar.color.inactive.a)
  bar:SetValue(0)
  bar:SetStatusBarColor(1,1,1,0)
  return bar
end

--update threat data
local function UpdateThreatData(unit)
  if not UnitExists(unit) then return end
  local _, _, scaledPercent, _, threatValue = UnitDetailedThreatSituation(unit, "target")
  tinsert(threatData,{
    unit          = unit,
    scaledPercent = scaledPercent or 0,
    threatValue   = threatValue or 0,
  })
end

--get color func
local function GetColor(unit)
  if UnitIsPlayer(unit) then
    return RAID_CLASS_COLORS[select(2,UnitClass(unit))]
  else
    return FACTION_BAR_COLORS[UnitReaction(unit, "player")]
  end
end

--number format func
local function NumFormat(v)
  if v > 1E10 then
    return (floor(v/1E9)).."b"
  elseif v > 1E9 then
    return (floor((v/1E9)*10)/10).."b"
  elseif v > 1E7 then
    return (floor(v/1E6)).."m"
  elseif v > 1E6 then
    return (floor((v/1E6)*10)/10).."m"
  elseif v > 1E4 then
    return (floor(v/1E3)).."k"
  elseif v > 1E3 then
    return (floor((v/1E3)*10)/10).."k"
  else
    return v
  end
end

--compare values func
local function Compare(a, b)
  return a.scaledPercent > b.scaledPercent
end

--update threatbar func
local function UpdateThreatBars(self)
  --wipe
  wipe(threatData)
  local numGroupMembers = GetNumGroupMembers()
  -- check raid
  if UnitInRaid("player") and numGroupMembers > 0 then
    for i=1, numGroupMembers do
      UpdateThreatData("raid"..i)
      UpdateThreatData("raidpet"..i)
    end
  -- check party (party excludes player and pet)
  elseif numGroupMembers > 0 then
    --check player
    UpdateThreatData("player")
    --check player pet
    if not UnitInVehicle("player") then
      UpdateThreatData("pet")
    end
    --check party
    for i=1, numGroupMembers do
      UpdateThreatData("party"..i)
      UpdateThreatData("partypet"..i)
    end
  --solo
  else
    UpdateThreatData("player")
    if not UnitInVehicle("player") then
      UpdateThreatData("pet")
    end
  end

  --sort the threat table
  sort(threatData, Compare)

  --update view
  for i=1,L.C.statusbar.count do
    --get values out of table
    local data = threatData[i]
    local bar = self.bars[i]
    if(data) then
      bar.name:SetText(UnitName(data.unit) or "Not found")
      bar.val:SetText(NumFormat(data.threatValue))
      bar.perc:SetText(floor(data.scaledPercent).."%")
      bar:SetValue(data.scaledPercent)
      local color = GetColor(data.unit) or { r=1, g=0, b=1 }
      if L.C.statusbar.marker and UnitGUID(data.unit) == playerGUID then
        color = { r=1, g=0, b=0 }
      end
      bar:SetStatusBarColor(color.r, color.g, color.b, L.C.statusbar.color.bar.a)
      bar.bg:SetVertexColor(color.r*L.C.statusbar.color.bg.multiplier, color.g*L.C.statusbar.color.bg.multiplier, color.b*L.C.statusbar.color.bg.multiplier, L.C.statusbar.color.bg.a)
    else
      bar.name:SetText("")
      bar.perc:SetText("")
      bar.val:SetText("")
      bar:SetValue(0)
      bar:SetStatusBarColor(1,1,1,0)
      bar.bg:SetVertexColor(L.C.statusbar.color.inactive.r, L.C.statusbar.color.inactive.g, L.C.statusbar.color.inactive.b, L.C.statusbar.color.inactive.a)
    end
  end
end

--check status func
local function CheckStatus(self, event)
  local instanceType = select(2,GetInstanceInfo())
  if (L.C.hideOOC and not InCombatLockdown()) or (L.C.partyOnly and GetNumGroupMembers() == 0) or (L.C.hideInPVP and (instanceType == "arena" or instanceType == "pvp")) then
    self:Hide()
    return
  end
  if UnitExists("target") and not UnitIsDeadOrGhost("target") and InCombatLockdown() then
    self:Show()
    local now = GetTime()
    if now-oldtime > L.C.timespan then
      UpdateThreatBars(self)
      oldtime = now
    end
  else
    oldtime = 0
  end
end

-----------------------------
-- INIT
-----------------------------

--minimum of 1 row
if not L.C.statusbar.count or L.C.statusbar.count < 1 then
  L.C.statusbar.count = 1
end

--statusbar table
local bars = {}

--first create a frame frame to gather all the objects (make that dragable later)
local frame = CreateFrame("Frame", A.."BarFrame", UIParent)
frame:SetSize(L.C.statusbar.width,L.C.statusbar.height*L.C.statusbar.count+L.C.statusbar.gap*L.C.statusbar.count-L.C.statusbar.gap)
frame:SetFrameStrata("BACKGROUND")
frame:SetFrameLevel(1)
frame:SetPoint(L.C.frame.pos.a1,L.C.frame.pos.af,L.C.frame.pos.a2,L.C.frame.pos.x,L.C.frame.pos.y)
frame:SetScale(L.C.scale)
frame.bars = bars

--background
local bg = frame:CreateTexture(nil, "BACKGROUND",nil,-8)
bg:SetTexture(1,1,1)
bg:SetAllPoints()
bg:SetVertexColor(L.C.frame.bg.color.r, L.C.frame.bg.color.g, L.C.frame.bg.color.b, L.C.frame.bg.color.a)

--shadow outline
if L.C.shadow.show then
  CreateBackdrop(frame,L.C.shadow)
end

--create statusbars
for i=1,L.C.statusbar.count do
  bars[i] = CreateStatusbar(frame)
  if(i==1) then
    bars[i]:SetPoint("TOP")
  else
    bars[i]:SetPoint("TOP",bars[i-1],"BOTTOM",0,-L.C.statusbar.gap)
  end
end

--events
frame:SetScript("OnEvent", CheckStatus)
frame:RegisterEvent("UNIT_THREAT_LIST_UPDATE")
frame:RegisterEvent("PLAYER_TARGET_CHANGED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PLAYER_REGEN_DISABLED")
frame:RegisterEvent("PLAYER_REGEN_ENABLED")
frame:RegisterEvent("GROUP_ROSTER_UPDATE")

--drag frame
rLib:CreateDragFrame(frame, L.dragFrames, -2, true)

--create slash commands
rLib:CreateSlashCmd(L.addonName, L.addonShortcut, L.dragFrames, L.addonColor)