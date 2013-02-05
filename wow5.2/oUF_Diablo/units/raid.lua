
  --get the addon namespace
  local addon, ns = ...

  --get oUF namespace (just in case needed)
  local oUF = ns.oUF or oUF

  --get the config
  local cfg = ns.cfg

  --get the functions
  local func = ns.func

  --get the unit container
  local unit = ns.unit

  local dragFrameList = ns.dragFrameList

  ---------------------------------------------
  -- UNIT SPECIFIC FUNCTIONS
  ---------------------------------------------

  --init parameters
  local initUnitParameters = function(self)
    --self:SetFrameStrata("BACKGROUND")
    --self:SetFrameLevel(1)
    --self:SetSize(self.cfg.width, self.cfg.height)
    --self:SetScale(self.cfg.scale)
    --self:SetPoint(self.cfg.pos.a1,self.cfg.pos.af,self.cfg.pos.a2,self.cfg.pos.x,self.cfg.pos.y)
    self.menu = func.menu
    self:RegisterForClicks("AnyDown")
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)
    --func.createBackdrop(self)
    --self:SetHitRectInsets(15,15,15,15)
  end


  --whitelist
  local whitelist = {}
  if cfg.units.raid.auras.whitelist then
    for _,spellid in pairs(cfg.units.raid.auras.whitelist) do
      local spell = GetSpellInfo(spellid)
      if spell then whitelist[spellid] = true end
    end
  end

  --blacklist
  local blacklist = {}
  if cfg.units.raid.auras.blacklist then
    for _,spellid in pairs(cfg.units.raid.auras.blacklist) do
      local spell = GetSpellInfo(spellid)
      if spell then blacklist[spellid] = true end
    end
  end

  --custom aura filter
  local customFilter = function(icons, unit, icon, name, rank, texture, count, dtype, duration, timeLeft, caster, isStealable, shouldConsolidate, spellID, canApplyAura, isBossDebuff)
    local ret = false
    if(blacklist[spellID]) then
      ret = false
    elseif(whitelist[spellID]) then
      ret = true
    elseif isBossDebuff then
      ret = true
    elseif caster and caster:match("(boss)%d?$") == "boss" then
      ret = true
    end
    return ret
  end

  --create aura func
  local createAuras = function(self)
    local f = CreateFrame("Frame", nil, self)
    local cfg = self.cfg.auras
    f.size = cfg.size or 26
    f.num = cfg.num or 5
    f.spacing = cfg.spacing or 5
    f.initialAnchor = cfg.initialAnchor or "TOPLEFT"
    f["growth-x"] = cfg.growthX or "RIGHT"
    f["growth-y"] = cfg.growthY or "DOWN"
    f.disableCooldown = cfg.disableCooldown or false
    f.showDebuffType = cfg.showDebuffType or false
    f.showBuffType = cfg.showBuffType or false
    if not cfg.doNotUseCustomFilter then
      f.CustomFilter = customFilter
    end
    f:SetHeight(f.size)
    f:SetWidth((f.size+f.spacing)*f.num)
    if cfg.pos then
      f:SetPoint(cfg.pos.a1 or "CENTER", self, cfg.pos.a2 or "CENTER", cfg.pos.x or 0, cfg.pos.y or 0)
    else
      f:SetPoint("CENTER",0,-5)
    end
    self.Auras = f
  end

  --aura icon func
  local createAuraIcon = function(icons, button)
    --button:EnableMouse(false)
    local bw = button:GetWidth()
    if button.cd then
      button.cd:SetPoint("TOPLEFT", 1, -1)
      button.cd:SetPoint("BOTTOMRIGHT", -1, 1)
      button.count:SetParent(button.cd)
    end
    button.count:ClearAllPoints()
    button.count:SetPoint("TOPRIGHT", 4, 4)
    button.count:SetTextColor(0.9,0.9,0.9)
    button.count:SetFont(cfg.font,bw/1.8,"THINOUTLINE")
    button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    button.overlay:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\default_border")
    button.overlay:SetTexCoord(0,1,0,1)
    button.overlay:SetPoint("TOPLEFT", -1, 1)
    button.overlay:SetPoint("BOTTOMRIGHT", 1, -1)
    button.overlay:SetVertexColor(0.2,0.15,0.15,1)
    button.overlay:Show()
    button.overlay.Hide = function() end
  end

  --create aura watch func
  local createAuraWatch = function(self)

    --start the DRUID setup
    if cfg.playerclass == "DRUID" then

      local auras = {}
      local spellIDs = {
        774, -- Rejuvenation
        8936, -- Regrowth
        33763, -- Lifebloom
        48438, -- Wild Growth
      }

      local dir = {
        [1] = { indicator = true, color = { r=1,g=0,b=1 },        size = 8, pos = "TOPLEFT",       x = 12, y = -12 },
        [2] = { indicator = true, color = { r=0,g=1,b=0 },        size = 8, pos = "BOTTOMLEFT",    x = 12, y = 12 },
        [3] = { indicator = true, color = { r=0.5,g=1,b=0.5 },    size = 8, pos = "TOPRIGHT",      x = -12, y = -12 },
        [4] = { indicator = true, color = { r=1,g=1,b=0 },        size = 8, pos = "BOTTOMRIGHT",   x = -12, y = 12 },
      }

      auras.onlyShowPresent = true
      auras.presentAlpha = 1

      auras.PostCreateIcon = function(self, icon, sid)
        if icon.cd then
          icon.cd:SetPoint("TOPLEFT", 1, -1)
          icon.cd:SetPoint("BOTTOMRIGHT", -1, 1)
        end
        --count hack for lifebloom
        if sid == 33763 and icon.count then
          icon.count:SetFont("Interface\\AddOns\\oUF_Diablo\\media\\visitor1.ttf",8,"THINOUTLINE, MONOCHROME")
          icon.count:ClearAllPoints()
          icon.count:SetPoint("CENTER", 3, 3)
          icon.count:SetParent(icon.cd)
        end
      end

      -- Set any other AuraWatch settings
      auras.icons = {}
      for i, sid in pairs(spellIDs) do
        local icon = CreateFrame("Frame", nil, self)
        icon.spellID = sid
        -- set the dimensions and positions
        icon.size = dir[i].size
        icon:SetSize(dir[i].size,dir[i].size)
        --position icon
        icon:SetPoint(dir[i].pos, self, dir[i].pos, dir[i].x, dir[i].y)
        --make indicator
        if dir[i].indicator then
          local tex = icon:CreateTexture(nil, "OVERLAY")
          tex:SetAllPoints(icon)
          tex:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\indicator")
          tex:SetVertexColor(dir[i].color.r,dir[i].color.g,dir[i].color.b)
          icon.icon = tex
        end

        auras.icons[sid] = icon
        -- Set any other AuraWatch icon settings
      end
      --call aurawatch
      self.AuraWatch = auras
    end
  end

  --update health func
  local updateHealth = function(bar, unit, min, max)
    local d = floor(min/max*100)
    local color
    local dead
    if UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit) then
      color = {r = 0.4, g = 0.4, b = 0.4}
      dead = 1
    elseif not cfg.colorswitcher.classcolored then
      color = cfg.colorswitcher.bright
    elseif cfg.colorswitcher.threatColored and unit and UnitThreatSituation(unit) == 3 then
      color = { r = 1, g = 0, b = 0, }
    elseif UnitIsPlayer(unit) then
      color = RAID_CLASS_COLORS[select(2, UnitClass(unit))]
    else
      color = FACTION_BAR_COLORS[UnitReaction(unit, "player")]
    end
    if not color then color = { r = 0.5, g = 0.5, b = 0.5, } end
    --dead
    if dead == 1 then
      bar:SetStatusBarColor(0,0,0,0)
      bar.bg:SetVertexColor(0,0,0,0)
    else
      --alive
      if cfg.colorswitcher.useBrightForeground then
        bar:SetStatusBarColor(color.r,color.g,color.b,color.a or 1)
        bar.bg:SetVertexColor(cfg.colorswitcher.dark.r,cfg.colorswitcher.dark.g,cfg.colorswitcher.dark.b,cfg.colorswitcher.dark.a)
      else
        bar:SetStatusBarColor(cfg.colorswitcher.dark.r,cfg.colorswitcher.dark.g,cfg.colorswitcher.dark.b,cfg.colorswitcher.dark.a)
        bar.bg:SetVertexColor(color.r,color.g,color.b,color.a or 1)
      end
    end
    --low hp
    if d <= 25 and dead ~= 1 then
      if cfg.colorswitcher.useBrightForeground then
        bar.glow:SetVertexColor(0.3,0,0,0.9)
        bar:SetStatusBarColor(1,0,0,1)
        bar.bg:SetVertexColor(0.15,0,0,0.7)
      else
        bar.glow:SetVertexColor(1,0,0,1)
      end
    else
      --inner shadow
      bar.glow:SetVertexColor(0,0,0,0.7)
    end
    bar.highlight:SetAlpha((min/max)*cfg.highlightMultiplier)
  end

  --check threat
  local checkThreat = function(self,event,unit)
    self.Health:ForceUpdate()
  end

  --actionbar background
  local createArtwork = function(self)
    local t = self:CreateTexture(nil,"BACKGROUND",nil,-8)
    t:SetAllPoints(self)
    t:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\targettarget")

    if self.cfg.special.chains then
      local c1 = self:CreateTexture(nil,"BACKGROUND",nil,-7)
      c1:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\chain2")
      c1:SetSize(32,32)
      c1:SetPoint("CENTER",-32,28)
      c1:SetAlpha(0.9)
      local c2 = self:CreateTexture(nil,"BACKGROUND",nil,-7)
      c2:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\chain2")
      c2:SetSize(32,32)
      c2:SetPoint("CENTER",32,28)
      c2:SetAlpha(0.9)
    end

  end

  --create health frames
  local createHealthFrame = function(self)

    local cfg = self.cfg.health

    --health
    local h = CreateFrame("StatusBar", nil, self)
    h:SetPoint("TOP",0,-21.9)
    h:SetPoint("LEFT",24.5,0)
    h:SetPoint("RIGHT",-24.5,0)
    h:SetPoint("BOTTOM",0,28.7)

    h:SetStatusBarTexture(cfg.texture)
    h.bg = h:CreateTexture(nil,"BACKGROUND",nil,-6)
    h.bg:SetTexture(cfg.texture)
    h.bg:SetAllPoints(h)

    h.glow = h:CreateTexture(nil,"OVERLAY",nil,-5)
    h.glow:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\targettarget_hpglow")
    h.glow:SetAllPoints(self)
    h.glow:SetVertexColor(0,0,0,1)

    h.highlight = h:CreateTexture(nil,"OVERLAY",nil,-4)
    h.highlight:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\targettarget_highlight")
    h.highlight:SetAllPoints(self)

    self.Health = h
    self.Health.Smooth = false
  end

  --create health power strings
  local createHealthPowerStrings = function(self)

    local name = func.createFontString(self, cfg.font, 12, "THINOUTLINE")
    name:SetPoint("BOTTOM", self, "TOP", 0, -14)
    name:SetPoint("LEFT", self.Health, 0, 0)
    name:SetPoint("RIGHT", self.Health, 0, 0)
    --name:SetJustifyH("LEFT")
    self.Name = name

    local hpval = func.createFontString(self.Health, cfg.font, 11, "THINOUTLINE")
    hpval:SetPoint("RIGHT", -2,0)

    self:Tag(name, "[diablo:name]")
    self:Tag(hpval, self.cfg.health.tag or "")

  end


  ---------------------------------------------
  -- RAID STYLE FUNC
  ---------------------------------------------

  local function createStyle(self)

    --apply config to self
    self.cfg = cfg.units.raid
    self.cfg.style = "raid"

    self.cfg.width = 128
    self.cfg.height = 64

    --init
    initUnitParameters(self)

    --create the art
    createArtwork(self)

    --createhealthPower
    createHealthFrame(self)

    --health power strings
    createHealthPowerStrings(self)

    --health update
    self.Health.PostUpdate = updateHealth
    self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", checkThreat)

    --debuffglow
    func.createDebuffGlow(self)

    --range
    self.Range = {
      insideAlpha = 1,
      outsideAlpha = self.cfg.alpha.notinrange
    }

    --auras
    if self.cfg.auras.show then
      createAuras(self)
      self.Auras.PostCreateIcon = createAuraIcon
    end

    --aurawatch
    if self.cfg.aurawatch.show then
      createAuraWatch(self)
    end

    --icons
    self.RaidIcon = func.createIcon(self.Health,"OVERLAY",14,self.Health,"BOTTOM","TOP",0,-6,-1)
    self.ReadyCheck = func.createIcon(self.Health,"OVERLAY",24,self.Health,"CENTER","CENTER",0,0,-1)
    self.LFDRole = func.createIcon(self.Health,"LOW",12,self.Health,"TOP","BOTTOM",0,-2,-1)
    self.LFDRole:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\lfd_role")
    self.LFDRole:SetDesaturated(1)

    --add heal prediction
    func.healPrediction(self)

  end

  ---------------------------------------------
  -- SPAWN RAID UNIT
  ---------------------------------------------

  if cfg.units.raid.show then

    --rCreateDragFrame(CompactRaidFrameManager, dragFrameList, -2 , false) --frame, dragFrameList, inset, clamp

    local crfm = _G["CompactRaidFrameManager"]
    CompactRaidFrameManagerToggleButton:HookScript("OnClick", function(m)
      if CompactRaidFrameManager.collapsed then
        CompactRaidFrameManager:SetAlpha(0.2)
      else
        CompactRaidFrameManager:SetAlpha(1)
      end
    end)
    CompactRaidFrameManager:SetAlpha(0.2)
    CompactRaidFrameManagerToggleButton:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
      GameTooltip:AddLine("RaidFrameManger", 0, 1, 0.5, 1, 1, 1)
      if CompactRaidFrameManager.collapsed then
        GameTooltip:AddLine("Click to open.", 1, 1, 1, 1, 1, 1)
      else
        GameTooltip:AddLine("Click to close.", 1, 1, 1, 1, 1, 1)
      end
      GameTooltip:Show()
    end)
    CompactRaidFrameManagerToggleButton:SetScript("OnLeave", function(self)
      GameTooltip:Hide()
    end)

    --register style
    oUF:RegisterStyle("diablo:raid", createStyle)
    oUF:SetActiveStyle("diablo:raid")

    local attr = cfg.units.raid.attributes

    local function getRaidScale(id)
      if id == 1 then
        return cfg.units.raid.scale*0.95
      elseif id == 2 then
        return cfg.units.raid.scale*0.9
      else
        return cfg.units.raid.scale*0.75
      end
    end

    local function getRaidVisibility(id)
      if id == 1 then
        return attr.visibility1
      elseif id == 2 then
        return attr.visibility2
      else
        return attr.visibility3
      end
    end

    local raid, group, i, j

    local raidDragFrame = CreateFrame("Frame", "oUF_DiabloRaidDragFrame", UIParent)
    raidDragFrame:SetSize(50,50)
    raidDragFrame:SetPoint(cfg.units.raid.pos.a1,cfg.units.raid.pos.af,cfg.units.raid.pos.a2,cfg.units.raid.pos.x,cfg.units.raid.pos.y)
    func.applyDragFunctionality(raidDragFrame)
    table.insert(oUF_Diablo_Units,"oUF_DiabloRaidDragFrame") --add frames to the slash command function

    for i=1, 3 do
      raid = {}
      for j=1, NUM_RAID_GROUPS do
        local name = "oUF_DiabloRaid"..i.."Group"..j
        group = oUF:SpawnHeader(
          name, --name of raid group header
          nil,
          getRaidVisibility(i),
          "showPlayer",         attr.showPlayer,
          "showSolo",           attr.showSolo,
          "showParty",          attr.showParty,
          "showRaid",           attr.showRaid,
          "point",              attr.point,
          "yOffset",            attr.yOffset,
          "xoffset",            attr.xoffset,
          --"groupFilter",        "1,2,3,4,5,6,7,8",
          "groupFilter",        tostring(j),
          --"groupBy",            "GROUP",
          --"groupingOrder",      "1,2,3,4,5,6,7,8",
          --"sortMethod",         "NAME",
          --"maxColumns",         attr.maxColumns,
          "unitsPerColumn",     5,
          --"unitsPerColumn",     attr.unitsPerColumn,
          --"columnSpacing",      attr.columnSpacing,
          --"columnAnchorPoint",  attr.columnAnchorPoint,
          "oUF-initialConfigFunction", ([[
            self:SetWidth(%d)
            self:SetHeight(%d)
          ]]):format(128, 64)
        )
        group:SetScale(getRaidScale(i))
        if j == 1 then
          --group:SetPoint(cfg.units.raid.pos.a1,cfg.units.raid.pos.af,cfg.units.raid.pos.a2,cfg.units.raid.pos.x,cfg.units.raid.pos.y)
          group:SetPoint("TOPLEFT",raidDragFrame,0,0)
        else
          if attr.columnAnchorPoint == "TOP" then
            group:SetPoint("TOPLEFT", raid[j-1], "BOTTOMLEFT", 0, attr.columnSpacing)
          elseif attr.columnAnchorPoint == "BOTTOM" then
            group:SetPoint("BOTTOMLEFT", raid[j-1], "TOPLEFT", 0, attr.columnSpacing)
          elseif attr.columnAnchorPoint == "LEFT" then
            group:SetPoint("TOPLEFT", raid[j-1], "TOPRIGHT", attr.columnSpacing, 0)
          else
            group:SetPoint("TOPRIGHT", raid[j-1], "TOPLEFT", attr.columnSpacing, 0)
          end
        end
        --func.applyDragFunctionality(group)
        --table.insert(oUF_Diablo_Units,name) --add raid frames to the slash command function
        raid[j] = group
      end
    end
  end