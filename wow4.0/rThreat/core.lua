
  -- // rThreat
  -- // zork - 2011

  --get the addon namespace
  local addon, ns = ...

  --get the config
  local cfg = ns.cfg

  -----------------------------
  -- VARIABLES
  -----------------------------

  local player_name, _ = UnitName("player")
  local _, player_class = UnitClass("player")
  local threatTable = {}
  local i
  local oldtime = 0

  -----------------------------
  -- FUNCTIONS
  -----------------------------

  --apply drag functionality func
  local applyDragFunctionality = function(f,userplaced,locked)
    f:SetScript("OnDragStart", function(s) if IsAltKeyDown() and IsShiftKeyDown() then s:StartMoving() end end)
    f:SetScript("OnDragStop", function(s) s:StopMovingOrSizing() end)

    local t = f:CreateTexture(nil,"OVERLAY",nil,6)
    t:SetAllPoints(f)
    t:SetTexture(0,1,0)
    t:SetAlpha(0)
    f.dragtexture = t
    f:SetHitRectInsets(-15,-15,-15,-15)
    f:SetClampedToScreen(true)

    if not userplaced then
      f:SetMovable(false)
    else
      f:SetMovable(true)
      f:SetUserPlaced(true)
      if not locked then
        f.dragtexture:SetAlpha(0.4)
        f:EnableMouse(true)
        f:RegisterForDrag("LeftButton")
        f:SetScript("OnEnter", function(s)
          GameTooltip:SetOwner(s, "ANCHOR_TOP")
          GameTooltip:AddLine(s:GetName(), 0, 1, 0.5, 1, 1, 1)
          GameTooltip:AddLine("Hold down ALT+SHIFT to drag!", 1, 1, 1, 1, 1, 1)
          GameTooltip:Show()
        end)
        f:SetScript("OnLeave", function(s) GameTooltip:Hide() end)
      else
        f.dragtexture:SetAlpha(0)
        f:EnableMouse(nil)
        f:RegisterForDrag(nil)
        f:SetScript("OnEnter", nil)
        f:SetScript("OnLeave", nil)
      end
    end
  end

  --create backdrop func (cheat to use it for borders aswell)
  local function createBackdrop(anchor,cfg,typ)
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
    local f = CreateFrame("Frame",nil,anchor)
    f:SetPoint("TOPLEFT",anchor,"TOPLEFT",-cfg.inset,cfg.inset)
    f:SetPoint("BOTTOMRIGHT",anchor,"BOTTOMRIGHT",cfg.inset,-cfg.inset)
    f:SetBackdrop(backdrop)
    f:SetBackdropColor(cfg.bgColor.r, cfg.bgColor.g, cfg.bgColor.b, cfg.bgColor.a)
    f:SetBackdropBorderColor(cfg.edgeColor.r, cfg.edgeColor.g, cfg.edgeColor.b, cfg.edgeColor.a)
    if typ == "shadow" then
      anchor.shadow = f
    else
      f:SetFrameStrata("LOW") --make the border hover the other frames
      anchor.border = f
    end
  end

  --get threat data
  local function getThreatData(unit)
    local isTanking, status, scaledPercent, rawPercent, threatValue = UnitDetailedThreatSituation(unit, "target")
    local _, class = UnitClass(unit)
    local values = {
      UnitID        = unit,
      UnitName      = UnitName(unit) or "Not found",
      UnitClass     = class or "Not found",
      isTanking     = isTanking or 0,
      status        = status or 0,
      scaledPercent = scaledPercent or 0,
      rawPercent    = rawPercent or 0,
      threatValue   = threatValue or 0,
    }
    return values
  end

  --get color func
  local function getColor(unit)
    local color = { r=1, g=0, b=1 }
    if UnitIsPlayer(unit) then
      local _, class = UnitClass(unit)
      color = rRAID_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
      return color
    else
      local reaction = UnitReaction(unit, "player")
      if reaction then
        color = FACTION_BAR_COLORS[reaction]
        return color
      end
    end
    return color
  end

  --number format func
  local numFormat = function(v)
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
  local compare = function(a, b)
    return a.scaledPercent > b.scaledPercent
  end

  --update threatbar func
  local function updateThreatBars(self)

    threatTable = {}  --clear table
    local typ = 0     --0 = player only, 1 = raid, 2 = party, 3 = pet
    local unit

    -- check raid
    if GetNumRaidMembers() > 0 then
      typ = 1
      for i=1,GetNumRaidMembers() do
        --check for raid members
        unit = "raid"..i
        if(UnitExists(unit)) then
          table.insert(threatTable,getThreatData(unit))
        end
        --check for raid pets
        unit = "raidpet"..i
        if(UnitExists(unit)) then
          table.insert(threatTable,getThreatData(unit))
        end
      end
    -- check party (party excludes player and pet, thus we add them manually)
    elseif GetNumPartyMembers() > 0 then
      typ = 2
      --check player
      table.insert(threatTable,getThreatData("player"))
      --check player pet
      if not UnitInVehicle("player") and UnitExists("pet") then
        table.insert(threatTable,getThreatData("pet"))
      end
      for i=1,GetNumPartyMembers() do
        --check for party members
        unit = "party"..i
        if(UnitExists(unit)) then
          table.insert(threatTable,getThreatData(unit))
        end
        --check for partypets
        unit = "partypet"..i
        if(UnitExists(unit)) then
          table.insert(threatTable,getThreatData(unit))
        end
      end
    -- check solo+pet
    elseif not UnitInVehicle("player") and UnitExists("pet") then
      typ = 3
      table.insert(threatTable,getThreatData("player"))
      table.insert(threatTable,getThreatData("pet"))
    -- check solo
    else
      table.insert(threatTable,getThreatData("player"))
    end

    --sort the threat table
    table.sort(threatTable, compare)

    --print statusbars
    for i=0,cfg.statusbars.count-1 do
      --get values out of table
      local entry = threatTable[i+1]
      local bar = self.barcontainer.content.bars[i]
      if(entry) then
        bar.name.value = entry.UnitName
        bar.name:SetText(bar.name.value)
        bar.val:SetText(numFormat(entry.threatValue))
        bar.perc:SetText(floor(entry.scaledPercent).."%")
        bar:SetValue(entry.scaledPercent)
        local color = getColor(entry.UnitID)
        if not color then
          color = { r=1, g=0, b=1 }
        end
        --if cfg.statusbars.marker and entry.UnitName == player_name and entry.UnitClass == player_class then
        if cfg.statusbars.marker and entry.UnitName == player_name and UnitIsPlayer(entry.UnitID) then
          --use marker and check if the unit is the player
          --if that is the case rewrite the color to red
          color = { r=1, g=0, b=0 }
        end
        bar:SetStatusBarColor(color.r, color.g, color.b, cfg.statusbars.texture.alpha.foreground)
        bar.bg:SetVertexColor(color.r*cfg.statusbars.texture.multiplier, color.g*cfg.statusbars.texture.multiplier, color.b*cfg.statusbars.texture.multiplier, cfg.statusbars.texture.alpha.background)
      else
        bar.name:SetText("")
        bar.perc:SetText("")
        bar.val:SetText("")
        bar:SetValue(0)
        bar:SetStatusBarColor(1,1,1,0)
        bar.bg:SetVertexColor(cfg.statusbars.inactive.color.r, cfg.statusbars.inactive.color.g, cfg.statusbars.inactive.color.b, cfg.statusbars.inactive.color.a)
      end
    end
  end

  --check status func
  local function checkStatus(self,event,...)
    --print(event)
    local _, type = GetInstanceInfo()
    --print("you are in this type of instance: "..type)
    if (cfg.partyonly and (GetNumRaidMembers() + GetNumPartyMembers() == 0)) or (cfg.hideinpvp and (type == "arena" or type == "pvp")) then
      self:Hide()
      return
    end
    if not cfg.hide then self:Show() end
    local unit = "target"
    if UnitExists(unit) and not UnitIsDeadOrGhost(unit) and InCombatLockdown() then
      self:Show()
      local currenttime = GetTime()
      if currenttime-oldtime > cfg.timespan then
        --print("Getting new data")
        updateThreatBars(self)
        oldtime = currenttime
      end
    else
      oldtime = 0
      if cfg.hide then
        self:Hide()
      end
    end
  end

  --create threat bars func
  local function initThreatBars()

    -- | H O L D E R | --

    --first create a holder frame to gather all the objects (make that dragable later)
    local holder = CreateFrame("Frame","rThreatDragFrame",UIParent)
    holder:SetSize(cfg.title.width,cfg.title.height) --the holder should be dragable thus we make it match the size of the title
    holder:SetFrameStrata("BACKGROUND")
    holder:SetFrameLevel(1)
    holder:SetPoint(cfg.position.coord.a1,cfg.position.coord.af,cfg.position.coord.a2,cfg.position.coord.x,cfg.position.coord.y)
    applyDragFunctionality(holder,cfg.position.userplaced,cfg.position.locked)

    local title

    -- | T I T L E | --
    if cfg.title.show then

      --title container
      title = CreateFrame("Frame",nil,holder)
      title:SetAllPoints(holder)

      --shadow stuff
      if cfg.shadow.show then createBackdrop(title,cfg.shadow,"shadow") end

      --frame to hold the namestring
      local content = CreateFrame("Frame",nil,title)
      content:SetAllPoints(title)

      --title string
      local name = content:CreateFontString(nil, "BACKGROUND")
      name:SetFont(cfg.title.font.font, cfg.title.font.size, cfg.title.font.outline)
      name:SetPoint("CENTER", 0, 0)
      name:SetText("rThreat")
      name:SetVertexColor(cfg.title.font.color.r, cfg.title.font.color.g, cfg.title.font.color.b, cfg.title.font.color.a)

      --background for title frame
      local bg = content:CreateTexture(nil, "BACKGROUND",nil,-8)
      bg:SetTexture(cfg.title.bg.texture)
      bg:SetAllPoints(content)
      bg:SetVertexColor(cfg.title.bg.color.r, cfg.title.bg.color.g, cfg.title.bg.color.b, cfg.title.bg.color.a)

      content.name = name
      content.bg = bg
      title.content = content

      --border stuff
      if cfg.border.show then createBackdrop(title,cfg.border,"border") end

    end

    -- | B A R S | --

    --minimum of two rows
    if not cfg.statusbars.count or cfg.statusbars.count < 2 then
      cfg.statusbars.count = 2
    end

    --bar container
    local barcontainer = CreateFrame("Frame",nil,holder)
    if cfg.title.show then
      barcontainer:SetPoint("TOP",title,"BOTTOM",0,-cfg.title.gap)
    else
      barcontainer:SetPoint("TOP",0,0)
    end
    barcontainer:SetSize(cfg.statusbars.width,cfg.statusbars.height*cfg.statusbars.count+cfg.statusbars.gap*cfg.statusbars.count-cfg.statusbars.gap)

    --shadow stuff
    if cfg.shadow.show then createBackdrop(barcontainer,cfg.shadow,"shadow") end

    --frame to hold all the statusbars
    local barframe = CreateFrame("Frame",nil,barcontainer)
    barframe:SetAllPoints(barcontainer)

    --background for statusbarframe
    local bg = barframe:CreateTexture(nil, "BACKGROUND",nil,-8)
    bg:SetTexture(cfg.statusbars.bg.texture)
    bg:SetAllPoints(barframe)
    bg:SetVertexColor(cfg.statusbars.bg.color.r, cfg.statusbars.bg.color.g, cfg.statusbars.bg.color.b, cfg.statusbars.bg.color.a)

    --statusbars
    local bars = {}

    for i=0,cfg.statusbars.count-1 do
      bars[i] = CreateFrame("StatusBar", nil, barcontainer)
      bars[i]:SetSize(cfg.statusbars.width,cfg.statusbars.height)
      bars[i]:SetMinMaxValues(0,100)
      if(i==0) then
        bars[i]:SetPoint("TOP",barframe,"TOP",0,0)
      else
        bars[i]:SetPoint("TOP",bars[i-1],"BOTTOM",0,-cfg.statusbars.gap)
      end
      bars[i]:SetStatusBarTexture(cfg.statusbars.texture.texture)
      bars[i].value = 0;
      bars[i]:SetValue(bars[i].value);

      local bg = bars[i]:CreateTexture(nil, "BACKGROUND",nil,-6)
      bg:SetTexture(cfg.statusbars.texture.texture)
      bg:SetAllPoints(bars[i])
      bg:SetVertexColor(cfg.statusbars.inactive.color.r, cfg.statusbars.inactive.color.g, cfg.statusbars.inactive.color.b, cfg.statusbars.inactive.color.a)

      local name = bars[i]:CreateFontString(nil, "LOW")
      name:SetFont(cfg.statusbars.font.font, cfg.statusbars.font.size, cfg.statusbars.font.outline)
      name:SetVertexColor(cfg.statusbars.font.color.r, cfg.statusbars.font.color.g, cfg.statusbars.font.color.b, cfg.statusbars.font.color.a)
      name:SetPoint("LEFT", bars[i], 2, 0)
      name.value = ""
      name:SetJustifyH("LEFT")
      name:SetText(name.value)

      local perc = bars[i]:CreateFontString(nil, "LOW")
      perc:SetFont(cfg.statusbars.font.font, cfg.statusbars.font.size, cfg.statusbars.font.outline)
      perc:SetVertexColor(cfg.statusbars.font.color.r, cfg.statusbars.font.color.g, cfg.statusbars.font.color.b, cfg.statusbars.font.color.a)
      perc:SetPoint("RIGHT", bars[i], -2, 0)
      perc.value = bars[i].value.."%"
      perc:SetJustifyH("RIGHT")
      perc:SetText("")

      local val = bars[i]:CreateFontString(nil, "LOW")
      val:SetFont(cfg.statusbars.font.font, cfg.statusbars.font.size, cfg.statusbars.font.outline)
      val:SetVertexColor(cfg.statusbars.font.color.r, cfg.statusbars.font.color.g, cfg.statusbars.font.color.b, cfg.statusbars.font.color.a)
      val:SetPoint("RIGHT", bars[i], -40, 0)
      val.value = bars[i].value
      val:SetJustifyH("RIGHT")
      val:SetText("")

      name:SetPoint("RIGHT", val, "LEFT", -10, 0) --right point of name is left point of value

      bars[i].bg = bg
      bars[i].name = name
      bars[i].perc = perc
      bars[i].val = val

    end

    barframe.bg = bg
    barframe.bars = bars
    barcontainer.content = barframe

    --border stuff
    if cfg.border.show then createBackdrop(barcontainer,cfg.border,"border") end

    if title then
      holder.title = title
    end
    holder.barcontainer = barcontainer

    holder:SetScript("OnEvent", checkStatus)

    --holder:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE")
    holder:RegisterEvent("UNIT_THREAT_LIST_UPDATE")
    holder:RegisterEvent("PLAYER_TARGET_CHANGED")
    holder:RegisterEvent("PLAYER_ENTERING_WORLD")
    holder:RegisterEvent("PLAYER_REGEN_DISABLED")
    holder:RegisterEvent("PLAYER_REGEN_ENABLED")
    holder:RegisterEvent("PARTY_MEMBERS_CHANGED")

    holder:SetScale(cfg.scale)

    if cfg.hide then
      holder:Hide()
    end

  end

  -----------------------------
  -- CALL
  -----------------------------

  initThreatBars()
