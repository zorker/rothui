
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

  ---------------------------------------------
  -- UNIT SPECIFIC FUNCTIONS
  ---------------------------------------------

  --init parameters
  local initUnitParameters = function(self)
    self:SetFrameStrata("BACKGROUND")
    self:SetFrameLevel(1)
    self:SetSize(self.cfg.width, self.cfg.height)
    --self:SetScale(self.cfg.scale)
    --self:SetPoint(self.cfg.pos.a1,self.cfg.pos.af,self.cfg.pos.a2,self.cfg.pos.x,self.cfg.pos.y)
    self.menu = func.menu
    self:RegisterForClicks("AnyDown")
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)
    --func.createBackdrop(self)
    --self:SetHitRectInsets(15,15,15,15)
  end


  --fill the whitelist table automatically with all the spellids
  local whitelist = {}
  for i,spellid in pairs(cfg.units.raid.auras.spelllist) do
    local spell = GetSpellInfo(spellid)
    if spell then whitelist[spell] = true end
    --if spell then whitelist[spellid] = true end
  end

  --custom aura filter
  local customFilter = function(icons, unit, icon, name, rank, texture, count, dtype, duration, timeLeft, caster, isStealable, shouldConsolidate, spellID)
    if(whitelist[name]) then return true end
    --if(whitelist[spellID]) then return true end
  end

  --create aura func
  local createAuras = function(self)
    local f = CreateFrame("Frame", nil, self)
    f.size = self.cfg.auras.size
    f.num = 1
    f:SetHeight(f.size)
    f:SetWidth(f.size)
    f:SetPoint("CENTER", self, "CENTER", 0, 0)
    f.initialAnchor = "TOPLEFT"
    f["growth-x"] = "RIGHT"
    f["growth-y"] = "DOWN"
    f.spacing = -f.size
    f.disableCooldown = self.cfg.auras.disableCooldown
    f.showDebuffType  = self.cfg.auras.showDebuffType
    f.showBuffType    = self.cfg.auras.showBuffType
    f.CustomFilter = customFilter
    self.Auras = f
  end

  --aura icon func
  local createAuraIcon = function(icons, button)
    button:EnableMouse(false)
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
    button.overlay:SetTexture("Interface\\AddOns\\rTextures\\aura_square")
    button.overlay:SetTexCoord(0,1,0,1)
    button.overlay:SetPoint("TOPLEFT", -1, 1)
    button.overlay:SetPoint("BOTTOMRIGHT", 1, -1)
    button.overlay:SetVertexColor(0,0,0,1)
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
          icon.count:SetFont("Interface\\AddOns\\rTextures\\visitor1.ttf",8,"THINOUTLINE, MONOCHROME")
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
        icon:SetSize(dir[i].size,dir[i].size)
        --position icon
        icon:SetPoint(dir[i].pos, self, dir[i].pos, dir[i].x, dir[i].y)
        --make indicator
        if dir[i].indicator then
          local tex = icon:CreateTexture(nil, "OVERLAY")
          tex:SetAllPoints(icon)
          tex:SetTexture("Interface\\AddOns\\rTextures\\indicator")
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

  --check threat
  local checkThreat = function(self,event,unit)
    if unit then
      if self.unit ~= unit then return end
      local threat = UnitThreatSituation(unit)
      if(threat and threat > 0) then
        local r, g, b = GetThreatStatusColor(threat)
        if self.Health.border then
          self.Health.border:SetVertexColor(r,g,b)
        end
      else
        if self.Health.border then
          self.Health.border:SetVertexColor(0.8,0.65,0.65)
        end
      end
    end
  end

  --actionbar background
  local createArtwork = function(self)
    local t = self:CreateTexture(nil,"BACKGROUND",nil,-8)
    t:SetAllPoints(self)
    t:SetTexture("Interface\\AddOns\\rTextures\\targettarget")

    local c1 = self:CreateTexture(nil,"BACKGROUND",nil,-7)
    c1:SetTexture("Interface\\AddOns\\rTextures\\chain2")
    c1:SetSize(32,32)
    c1:SetPoint("CENTER",-32,28)
    c1:SetAlpha(0.9)

    local c2 = self:CreateTexture(nil,"BACKGROUND",nil,-7)
    c2:SetTexture("Interface\\AddOns\\rTextures\\chain2")
    c2:SetSize(32,32)
    c2:SetPoint("CENTER",32,28)
    c2:SetAlpha(0.9)

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
    h.glow:SetTexture("Interface\\AddOns\\rTextures\\targettarget_hpglow")
    h.glow:SetAllPoints(self)
    h.glow:SetVertexColor(0,0,0,1)

    h.highlight = h:CreateTexture(nil,"OVERLAY",nil,-4)
    h.highlight:SetTexture("Interface\\AddOns\\rTextures\\targettarget_highlight")
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
    self.Health.PostUpdate = func.updateHealth

    --debuffglow
    func.createDebuffGlow(self)

    --range
    self.Range = {
      insideAlpha = 1,
      outsideAlpha = self.cfg.alpha.notinrange
    }

    --icons
    self.RaidIcon = func.createIcon(self.Health,"LOW",14,self.Health,"BOTTOM","TOP",0,-6,-1)
    self.ReadyCheck = func.createIcon(self.Health,"OVERLAY",24,self.Health,"CENTER","CENTER",0,0,-1)
    self.LFDRole = func.createIcon(self.Health,"LOW",12,self.Health,"TOP","BOTTOM",0,-2,-1)
    self.LFDRole:SetTexture("Interface\\AddOns\\rTextures\\lfd_role")
    self.LFDRole:SetDesaturated(1)

    --[[

    --create frame
    createHealthFrame(self)

    --health update
    self.Health.PostUpdate = updateHealth

    --threat
    self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", checkThreat)

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
    self.RaidIcon = func.createIcon(self.Health,"LOW",14,self.Health,"BOTTOM","TOP",0,-6,-1)
    self.ReadyCheck = func.createIcon(self.Health,"OVERLAY",24,self.Health,"CENTER","CENTER",0,0,-1)
    self.LFDRole = func.createIcon(self.Health,"LOW",12,self.Health,"TOP","BOTTOM",0,4,-1)
    self.LFDRole:SetTexture("Interface\\AddOns\\rTextures\\lfd_role")
    self.LFDRole:SetDesaturated(1)
    ]]--


  end

  ---------------------------------------------
  -- SPAWN RAID UNIT
  ---------------------------------------------

  if cfg.units.raid.show then

    if cfg.units.raid.hideManager then
      --disable the blizzard raidframe container+manager
      CompactRaidFrameManager:UnregisterAllEvents()
      CompactRaidFrameManager:HookScript("OnShow", function(s) s:Hide() end)
      CompactRaidFrameManager:Hide()
    else
      local listener = CreateFrame("Frame")
      listener.check = function(self, event, addon)
        if(addon~="Blizzard_CompactRaidFrames") then return end
        CompactRaidFrameManagerToggleButton:EnableMouse(false)
        local man = CompactRaidFrameManager
        man:SetAlpha(0)
        man.container:SetParent(UIParent)
        man:SetScript("OnMouseUp", CompactRaidFrameManager_Toggle)
        man:SetScript("OnEnter", function(self)
          if(self.collapsed) then
            UIFrameFadeIn(man, .2, 0, 1)
          end
        end)
        man:SetScript("OnLeave", function(self)
          if(self.collapsed) then
            UIFrameFadeOut(man, .2, 1, 0)
          end
        end)
        self:UnregisterEvent(event)
        self:SetScript("OnEvent", nil)
      end
      if(IsAddOnLoaded("Blizzard_CompactRaidFrames")) then
        listener.check(listener, "ADDON_LOADED", "Blizzard_CompactRaidFrames")
      else
        listener:RegisterEvent("ADDON_LOADED")
        listener:SetScript("OnEvent", listener.check)
      end
    end

    CompactRaidFrameContainer:UnregisterAllEvents()
    CompactRaidFrameContainer:HookScript("OnShow", function(s) s:Hide() end)
    CompactRaidFrameContainer:Hide()

    --register style
    oUF:RegisterStyle("diablo:raid", createStyle)
    oUF:SetActiveStyle("diablo:raid")

    local attr = cfg.units.raid.attributes

    --spawn raid
    local raid = oUF:SpawnHeader(
      "oUF_DiabloRaidHeader", --name
      nil,
      attr.visibility,
      "showPlayer",         attr.showPlayer,
      "showSolo",           attr.showSolo,
      "showParty",          attr.showParty,
      "showRaid",           attr.showRaid,
      "point",              attr.point,
      "yOffset",            attr.yOffset,
      "xoffset",            attr.xoffset,
      "groupFilter",        "1,2,3,4,5,6,7,8",
      "groupBy",            "GROUP",
      "groupingOrder",      "1,2,3,4,5,6,7,8",
      "sortMethod",         "NAME",
      "maxColumns",         attr.maxColumns,
      "unitsPerColumn",     attr.unitsPerColumn,
      "columnSpacing",      attr.columnSpacing,
      "columnAnchorPoint",  attr.columnAnchorPoint,

      "oUF-initialConfigFunction", ([[
        self:SetWidth(%d)
        self:SetHeight(%d)
        self:SetScale(%f)
      ]]):format(128, 64, cfg.units.raid.scale)
    )
    raid:SetPoint(cfg.units.raid.pos.a1,cfg.units.raid.pos.af,cfg.units.raid.pos.a2,cfg.units.raid.pos.x,cfg.units.raid.pos.y)

    --spawn raid for above 10 people but < 25people (same attributes, but lower scale)
    local raid2 = oUF:SpawnHeader(
      "oUF_DiabloRaidHeader2", --name
      nil,
      attr.visibility10plus,
      "showPlayer",         attr.showPlayer,
      "showSolo",           attr.showSolo,
      "showParty",          attr.showParty,
      "showRaid",           attr.showRaid,
      "point",              attr.point,
      "yOffset",            attr.yOffset,
      "xoffset",            attr.xoffset,
      "groupFilter",        "1,2,3,4,5,6,7,8",
      "groupBy",            "GROUP",
      "groupingOrder",      "1,2,3,4,5,6,7,8",
      "sortMethod",         "NAME",
      "maxColumns",         attr.maxColumns,
      "unitsPerColumn",     attr.unitsPerColumn,
      "columnSpacing",      attr.columnSpacing,
      "columnAnchorPoint",  attr.columnAnchorPoint,

      "oUF-initialConfigFunction", ([[
        self:SetWidth(%d)
        self:SetHeight(%d)
        self:SetScale(%f)
      ]]):format(128, 64, cfg.units.raid.scale*0.95)
    )
    raid2:SetPoint(cfg.units.raid.pos.a1,cfg.units.raid.pos.af,cfg.units.raid.pos.a2,cfg.units.raid.pos.x,cfg.units.raid.pos.y)

    --spawn raid for above 25 people (same attributes, but lower scale)
    local raid3 = oUF:SpawnHeader(
      "oUF_DiabloRaidHeader3", --name
      nil,
      attr.visibility25plus,
      "showPlayer",         attr.showPlayer,
      "showSolo",           attr.showSolo,
      "showParty",          attr.showParty,
      "showRaid",           attr.showRaid,
      "point",              attr.point,
      "yOffset",            attr.yOffset,
      "xoffset",            attr.xoffset,
      "groupFilter",        "1,2,3,4,5,6,7,8",
      "groupBy",            "GROUP",
      "groupingOrder",      "1,2,3,4,5,6,7,8",
      "sortMethod",         "NAME",
      "maxColumns",         attr.maxColumns,
      "unitsPerColumn",     attr.unitsPerColumn,
      "columnSpacing",      attr.columnSpacing,
      "columnAnchorPoint",  attr.columnAnchorPoint,

      "oUF-initialConfigFunction", ([[
        self:SetWidth(%d)
        self:SetHeight(%d)
        self:SetScale(%f)
      ]]):format(128, 64, cfg.units.raid.scale*0.8)
    )
    raid3:SetPoint(cfg.units.raid.pos.a1,cfg.units.raid.pos.af,cfg.units.raid.pos.a2,cfg.units.raid.pos.x,cfg.units.raid.pos.y)

    func.applyDragFunctionality(raid)
    func.applyDragFunctionality(raid2)
    func.applyDragFunctionality(raid3)

  end