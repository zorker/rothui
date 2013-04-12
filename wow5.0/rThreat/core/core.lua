
  --get the addon namespace
  local addon, ns = ...

  --get the config
  local cfg = ns.cfg
  --get the dragframelist
  local dragFrameList = ns.dragFrameList

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

  --create backdrop func (cheat to use it for borders aswell)
  local function CreateBackdrop(parent,cfg,typ)
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
    if typ == "border" then
      frame:SetFrameStrata("LOW") --make the border hover the other frames
    end
  end

  --get threat data
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
      local reaction = UnitReaction(unit, "player")
      if reaction then
        return FACTION_BAR_COLORS[reaction]
      end
    end
    return { r=1, g=0, b=1 }
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
    for i=1,cfg.statusbar.count do
      --get values out of table
      local data = threatData[i]
      local bar = self.bars[i]
      if(data) then
        bar.name:SetText(UnitName(data.unit) or "Not found")
        bar.val:SetText(NumFormat(data.threatValue))
        bar.perc:SetText(floor(data.scaledPercent).."%")
        bar:SetValue(data.scaledPercent)
        local color = GetColor(data.unit)
        if cfg.statusbar.marker and UnitGUID(data.unit) == playerGUID then
          color = { r=1, g=0, b=0 }
        end
        bar:SetStatusBarColor(color.r, color.g, color.b, cfg.statusbar.color.bar.a)
        bar.bg:SetVertexColor(color.r*cfg.statusbar.color.bg.multiplier, color.g*cfg.statusbar.color.bg.multiplier, color.b*cfg.statusbar.color.bg.multiplier, cfg.statusbar.color.bg.a)
      else
        bar.name:SetText("")
        bar.perc:SetText("")
        bar.val:SetText("")
        bar:SetValue(0)
        bar:SetStatusBarColor(1,1,1,0)
        bar.bg:SetVertexColor(cfg.statusbar.color.inactive.r, cfg.statusbar.color.inactive.g, cfg.statusbar.color.inactive.b, cfg.statusbar.color.inactive.a)
      end
    end
  end

  --check status func
  local function CheckStatus(self, event)
    local instanceType = select(2,GetInstanceInfo())
    if (cfg.hideOOC and not InCombatLockdown()) or (cfg.partyOnly and GetNumGroupMembers() == 0) or (cfg.hideInPVP and (instanceType == "arena" or instanceType == "pvp")) then
      self:Hide()
      return
    end
    if UnitExists("target") and not UnitIsDeadOrGhost("target") and InCombatLockdown() then
      self:Show()
      local now = GetTime()
      if now-oldtime > cfg.timespan then
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
  if not cfg.statusbar.count or cfg.statusbar.count < 1 then
    cfg.statusbar.count = 1
  end

  --statusbars
  local bars = {}

  --first create a frame frame to gather all the objects (make that dragable later)
  local frame = CreateFrame("Frame", addon.."BarFrame", UIParent)
  frame:SetSize(cfg.statusbar.width,cfg.statusbar.height*cfg.statusbar.count+cfg.statusbar.gap*cfg.statusbar.count-cfg.statusbar.gap)
  frame:SetFrameStrata("BACKGROUND")
  frame:SetFrameLevel(1)
  frame:SetPoint(cfg.frame.pos.a1,cfg.frame.pos.af,cfg.frame.pos.a2,cfg.frame.pos.x,cfg.frame.pos.y)
  frame:SetScale(cfg.scale)
  frame.bars = bars

  --drag frame
  rCreateDragFrame(frame, dragFrameList, -2 , true) --frame, dragFrameList, inset, clamp

  --background
  local bg = frame:CreateTexture(nil, "BACKGROUND",nil,-8)
  bg:SetTexture(1,1,1)
  bg:SetAllPoints()
  bg:SetVertexColor(cfg.frame.bg.color.r, cfg.frame.bg.color.g, cfg.frame.bg.color.b, cfg.frame.bg.color.a)

  --shadow outline
  if cfg.shadow.show then
    CreateBackdrop(frame,cfg.shadow,"shadow")
  end

  --threat bars
  for i=1,cfg.statusbar.count do
    --statusbar
    bars[i] = CreateFrame("StatusBar", nil, frame)
    bars[i]:SetSize(cfg.statusbar.width,cfg.statusbar.height)
    bars[i]:SetMinMaxValues(0,100)
    if(i==1) then
      bars[i]:SetPoint("TOP",frame,"TOP",0,0)
    else
      bars[i]:SetPoint("TOP",bars[i-1],"BOTTOM",0,-cfg.statusbar.gap)
    end
    bars[i]:SetStatusBarTexture(cfg.statusbar.texture)
    --bg
    local bg = bars[i]:CreateTexture(nil, "BACKGROUND",nil,-6)
    bg:SetTexture(cfg.statusbar.texture)
    bg:SetAllPoints(bars[i])
    --name
    local name = bars[i]:CreateFontString(nil, "LOW")
    name:SetFont(cfg.statusbar.font.family, cfg.statusbar.font.size, cfg.statusbar.font.outline)
    name:SetVertexColor(cfg.statusbar.font.color.r, cfg.statusbar.font.color.g, cfg.statusbar.font.color.b, cfg.statusbar.font.color.a)
    name:SetPoint("LEFT", bars[i], 2, 0)
    name:SetJustifyH("LEFT")
    --perc
    local perc = bars[i]:CreateFontString(nil, "LOW")
    perc:SetFont(cfg.statusbar.font.family, cfg.statusbar.font.size, cfg.statusbar.font.outline)
    perc:SetVertexColor(cfg.statusbar.font.color.r, cfg.statusbar.font.color.g, cfg.statusbar.font.color.b, cfg.statusbar.font.color.a)
    perc:SetPoint("RIGHT", bars[i], -2, 0)
    perc:SetJustifyH("RIGHT")
    --val
    local val = bars[i]:CreateFontString(nil, "LOW")
    val:SetFont(cfg.statusbar.font.family, cfg.statusbar.font.size, cfg.statusbar.font.outline)
    val:SetVertexColor(cfg.statusbar.font.color.r, cfg.statusbar.font.color.g, cfg.statusbar.font.color.b, cfg.statusbar.font.color.a)
    val:SetPoint("RIGHT", bars[i], -40, 0)
    val:SetJustifyH("RIGHT")
    --other
    name:SetPoint("RIGHT", val, "LEFT", -10, 0) --right point of name is left point of value
    bars[i].bg = bg
    bars[i].name = name
    bars[i].perc = perc
    bars[i].val = val
    bars[i].name:SetText("")
    bars[i].perc:SetText("")
    bars[i].val:SetText("")
    bars[i].bg:SetVertexColor(cfg.statusbar.color.inactive.r, cfg.statusbar.color.inactive.g, cfg.statusbar.color.inactive.b, cfg.statusbar.color.inactive.a)
    bars[i]:SetValue(0)
    bars[i]:SetStatusBarColor(1,1,1,0)
  end

  --frame border
  if cfg.border.show then
    CreateBackdrop(frame,cfg.border,"border")
  end

  --events
  frame:SetScript("OnEvent", CheckStatus)
  frame:RegisterEvent("UNIT_THREAT_LIST_UPDATE")
  frame:RegisterEvent("PLAYER_TARGET_CHANGED")
  frame:RegisterEvent("PLAYER_ENTERING_WORLD")
  frame:RegisterEvent("PLAYER_REGEN_DISABLED")
  frame:RegisterEvent("PLAYER_REGEN_ENABLED")
  frame:RegisterEvent("GROUP_ROSTER_UPDATE")
