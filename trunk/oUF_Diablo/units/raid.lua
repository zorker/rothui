  
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
    self:SetHitRectInsets(15,15,15,15)
  end

  --create health frames
  local createHealthFrame = function(self)
    
    --healthframe
    local h = CreateFrame("StatusBar", nil, self)
    h:SetPoint("TOP",0,-15)
    h:SetPoint("LEFT",15,0)
    h:SetPoint("RIGHT",-15,0)
    h:SetPoint("BOTTOM",0,15)
    
    h:SetStatusBarTexture("") --transparent 
    h.w = self:GetWidth()-30

    --parse the class color override variable to the health object
    h.classcoloroverride = self.cfg.health.classcoloroverride

    --background
    local b = self:CreateTexture(nil,"BACKGROUND",nil,-8)
    b:SetAllPoints(self)
    b:SetTexture("Interface\\AddOns\\rTextures\\raid_back")
    h.dropshadow = b
    --b:SetVertexColor(0.5,0.5,0.5,1)
    
    --bg texture that will not make the whole frame red
    local t = h:CreateTexture(nil,"BACKGROUND",nil,-6)
    t:SetPoint("TOPRIGHT",h,"TOPRIGHT",0,0)
    t:SetPoint("BOTTOMRIGHT",h,"BOTTOMRIGHT",0,0)
    t:SetWidth(0.01)
    --t:SetWidth(20)
    t:SetTexture(self.cfg.health.texture)
    h.back = t
    --h.back:SetVertexColor(1,0,0,0.9)
    
    --new fake statusbar
    local n = h:CreateTexture(nil,"BACKGROUND",nil,-6)
    n:SetPoint("TOPLEFT",h,"TOPLEFT",0,0)
    n:SetPoint("BOTTOMLEFT",h,"BOTTOMLEFT",0,0)
    n:SetPoint("RIGHT", t, "LEFT", 0, 0) --right point of n will anchor left point of t
    n:SetTexture(self.cfg.health.texture)
    h.new = n
    --h.new:SetVertexColor(0.15,0.15,0.15,1)

    --border texture
    h.border = h:CreateTexture(nil,"BACKGROUND",nil,-4)
    --h.border:SetTexture("Interface\\AddOns\\rTextures\\raid_border")
    h.border:SetTexture("Interface\\AddOns\\rTextures\\portrait_border")
    h.border:SetAllPoints(self)
    h.border:SetVertexColor(0.8,0.65,0.65)
    --h.border:SetVertexColor(1,0,0,1)
    --h.border:SetVertexColor(120/255,100/255,100/255,1)

    --lowhp glow
    h.glow = h:CreateTexture(nil,"BACKGROUND",nil,-5)
    h.glow:SetTexture("Interface\\AddOns\\rTextures\\raid_hpglow")
    h.glow:SetAllPoints(self)
    h.glow:SetVertexColor(0,0,0,0.7)
    --h.glow:SetVertexColor(1,0,0,1)
    
    --debuff highlight
    local d = self:CreateTexture(nil,"BACKGROUND",nil,-7)
    d:SetTexture("Interface\\AddOns\\rTextures\\raid_debuffglow")
    d:SetAllPoints(self)
    d:SetBlendMode("BLEND")
    d:SetVertexColor(0, 1, 0, 0) -- set alpha to 0 to hide the texture
    self.DebuffHighlight = d
    self.DebuffHighlightAlpha = 1
    self.DebuffHighlightFilter = true
    
    --skull
    local s = h:CreateTexture(nil,"OVERLAY",nil,-4)
    s:SetTexture("interface\\targetingframe\\ui-targetingframe-skull")
    s:SetSize(22,22)
    s:SetPoint("LEFT",-13,0)
    --s:SetDesaturated(1)
    s:Hide()
    h.skull = s
    
    --disconnect
    local disco = h:CreateTexture(nil,"OVERLAY",nil,-4)
    disco:SetTexture("interface\\buttons\\ui-grouploot-pass-up")
    disco:SetSize(18,18)
    disco:SetPoint("LEFT",-11,0)
    h.disco = disco
    
    
    --name
    local name = func.createFontString(h, cfg.font, 10.5, "THINOUTLINE","BORDER")
    name:SetPoint("LEFT", h, 0, 0)
    name:SetPoint("RIGHT", h, -0, 0)
    name:SetJustifyH("CENTER")
    self:Tag(name, self.cfg.health.tag or "")  
    --name:SetText("-23.2k")
    --name:SetText("Haudraufinixx")
    h.Name = name
    
    self.Health = h
    
  end
  
  --update health func
  local updateHealth = function(bar, unit, min, max)
    local d = floor(min/max*100)    
    --apply bar width
    if d == 100 then
      bar.back:SetWidth(0.01) --fix (0) makes the bar go anywhere
    elseif d < 100 then
      local w = bar.w
      bar.back:SetWidth(w-(w*d/100)) --calc new width of bar based on size of healthbar
    end    
    local color, dead, disco
    
    if UnitIsDeadOrGhost(unit) then
      color = {r = 0.4, g = 0.4, b = 0.4}
      dead = 1
    elseif not UnitIsConnected(unit) then
      color = {r = 0.4, g = 0.4, b = 0.4}
      disco = 1
    elseif UnitIsPlayer(unit) then
      color = rRAID_CLASS_COLORS[select(2, UnitClass(unit))] or RAID_CLASS_COLORS[select(2, UnitClass(unit))]
    else
      color = FACTION_BAR_COLORS[UnitReaction(unit, "player")]
    end
    
    if not color then color = { r = 0.5, g = 0.5, b = 0.5, } end

    if dead or disco then
      bar.new:SetVertexColor(0,0,0,0)
      bar.back:SetVertexColor(0,0,0,0)
    else
      if not cfg.colorswitcher.classcolored and not bar.classcoloroverride then
        color = cfg.colorswitcher.bright
      end
      if cfg.colorswitcher.useBrightForeground then
        bar.new:SetVertexColor(color.r,color.g,color.b,color.a or 1)
        bar.back:SetVertexColor(cfg.colorswitcher.dark.r,cfg.colorswitcher.dark.g,cfg.colorswitcher.dark.b,cfg.colorswitcher.dark.a)
      else
        bar.new:SetVertexColor(cfg.colorswitcher.dark.r,cfg.colorswitcher.dark.g,cfg.colorswitcher.dark.b,cfg.colorswitcher.dark.a)
        bar.back:SetVertexColor(color.r,color.g,color.b,color.a or 1)
      end
    end

    if dead then
      bar.glow:SetVertexColor(0,0,0,0.5)
      bar.disco:Hide()
      bar.skull:Show()
      bar.dropshadow:SetAlpha(0.5)
      bar.border:SetAlpha(0.5)
    elseif disco then
      bar.glow:SetVertexColor(0,0,0,0.5)
      bar.skull:Hide()
      bar.disco:Show()      
      bar.dropshadow:SetAlpha(0.5)
      bar.border:SetAlpha(0.5)
    elseif d <= 25 and min > 1 then
      bar.glow:SetVertexColor(1,0,0,1)
      bar.skull:Hide()
      bar.disco:Hide()
      bar.dropshadow:SetAlpha(1)
      bar.border:SetAlpha(1)
      if cfg.colorswitcher.useBrightForeground then
        bar.new:SetVertexColor(1,0,0,1)
      else
        bar.back:SetVertexColor(1,0,0,1)
      end
    else
      bar.glow:SetVertexColor(0,0,0,0.7)
      bar.skull:Hide()
      bar.disco:Hide()
      bar.dropshadow:SetAlpha(1)
      bar.border:SetAlpha(1)
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


  ---------------------------------------------
  -- RAID STYLE FUNC
  ---------------------------------------------

  local function createStyle(self)
  
    --apply config to self
    self.cfg = cfg.units.raid
    self.cfg.style = "raid"
    
    self.cfg.width = 64
    self.cfg.height = 64
    
    --init
    initUnitParameters(self)

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
    
    --icons
    self.RaidIcon = func.createIcon(self.Health,"LOW",14,self.Health,"BOTTOM","TOP",0,-6,-1)
    self.ReadyCheck = func.createIcon(self.Health,"OVERLAY",24,self.Health,"CENTER","CENTER",0,0,-1)
    self.LFDRole = func.createIcon(self.Health,"LOW",12,self.Health,"TOP","BOTTOM",0,4,-1)
    self.LFDRole:SetTexture("Interface\\AddOns\\rTextures\\lfd_role")
    self.LFDRole:SetDesaturated(1)
    
  end  

  ---------------------------------------------
  -- SPAWN RAID UNIT
  ---------------------------------------------

  if cfg.units.raid.show then
    
    --disable the blizzard raidframe container+manager
    CompactRaidFrameManager:UnregisterAllEvents()
    CompactRaidFrameManager:HookScript("OnShow", function(s) s:Hide() end)
    CompactRaidFrameManager:Hide()
    
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
      "raid",               --visibility debug
      "showPlayer",         false,
      "showSolo",           false,
      "showParty",          false,
      "showRaid",           true,
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
      ]]):format(64, 64, cfg.units.raid.scale)
    )
    raid:SetPoint(cfg.units.raid.pos.a1,cfg.units.raid.pos.af,cfg.units.raid.pos.a2,cfg.units.raid.pos.x,cfg.units.raid.pos.y)
    
    func.applyDragFunctionality(raid)
   
  end