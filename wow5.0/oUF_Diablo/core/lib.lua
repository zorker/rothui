
  --get the addon namespace
  local addon, ns = ...

  --get oUF namespace (just in case needed)
  local oUF = ns.oUF or oUF

  --get the config
  local cfg = ns.cfg

  --object container
  local func = CreateFrame("Frame")
  ns.func = func

  ---------------------------------------------
  -- VARIABLES
  ---------------------------------------------

  local tinsert, tremove, floor, mod, format = tinsert, tremove, floor, mod, format

  ---------------------------------------------
  -- FUNCTIONS
  ---------------------------------------------

  --number format func
  func.numFormat = function(v)
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

  --round number
  func.round = function(val)
    return floor(val*1000)/1000
  end

  --format time func
  func.GetFormattedTime = function(time)
    local hr, m, s, text
    if time <= 0 then text = ""
    elseif(time < 3600 and time > 60) then
      hr = floor(time / 3600)
      m = floor(mod(time, 3600) / 60 + 1)
      text = format("%dm", m)
    elseif time < 60 then
      m = floor(time / 60)
      s = mod(time, 60)
      text = (m == 0 and format("%ds", s))
    else
      hr = floor(time / 3600 + 1)
      text = format("%dh", hr)
    end
    return text
  end

  --backdrop func
  func.createBackdrop = function(f)
    f:SetBackdrop(cfg.backdrop)
    f:SetBackdropColor(0,0,0,0.7)
    f:SetBackdropBorderColor(0,0,0,1)
  end

  --create debuff func
  func.createDebuffs = function(self)
    local f = CreateFrame("Frame", nil, self)
    f.size = self.cfg.auras.size
    if self.cfg.style == "targettarget" then
      f.num = 8
    else
      f.num = 4
    end
    f:SetHeight((f.size+5)*(f.num/4))
    f:SetWidth((f.size+5)*4)
    f:SetPoint("TOP", self, "BOTTOM", 2.5, 5)
    f.initialAnchor = "TOPLEFT"
    f["growth-x"] = "RIGHT"
    f["growth-y"] = "DOWN"
    f.spacing = 5
    f.showDebuffType = self.cfg.auras.showDebuffType
    f.onlyShowPlayer = self.cfg.auras.onlyShowPlayerDebuffs
    self.Debuffs = f
  end

  --create buff func
  func.createBuffs = function(self)
    local f = CreateFrame("Frame", nil, self)
    f.size = self.cfg.auras.size
    if self.cfg.style == "targettarget" then
      f.num = 6
    else
      f.num = 3
    end
    f:SetWidth((f.size+5)*(f.num/3))
    f:SetHeight((f.size+5)*3)
    f:SetPoint("TOPLEFT", self, "TOPRIGHT", -13, 66)
    f.initialAnchor = "TOPLEFT"
    f["growth-x"] = "RIGHT"
    f["growth-y"] = "DOWN"
    f.spacing = 5
    f.showBuffType = self.cfg.auras.showBuffType
    f.onlyShowPlayer = self.cfg.auras.onlyShowPlayerBuffs
    self.Buffs = f
  end

  --Desaturated and Button CD
  func.postUpdateDebuff = function(element, unit, button, index, duration, expirationTime)
    if(UnitIsFriend("player", unit) or button.isPlayer) then
      button.icon:SetDesaturated(false)
      --button.cd:Show()
    else
      button.icon:SetDesaturated(true)
      --button.cd:Hide()
    end
    button.icon.duration = duration
    button.icon.timeLeft = expirationTime
    button.icon.first = true
  end

  --aura icon func
  func.createAuraIcon = function(icons, button)
    --button:SetSize(icons.size,icons.size)
    --button.cd:SetReverse()
    local size = icons.size or button:GetWidth()
    button.cd:SetPoint("TOPLEFT", 1, -1)
    button.cd:SetPoint("BOTTOMRIGHT", -1, 1)
    button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    --count helper frame, this push the count fontstring over the cooldown spiral
    button.countFrame = CreateFrame("Frame",nil,button)
    button.countFrame:SetAllPoints()
    button.countFrame:SetFrameLevel(button.cd:GetFrameLevel()+2)
    --button count
    button.count:SetParent(button.countFrame)
    button.count:ClearAllPoints()
    button.count:SetPoint("TOPRIGHT", 4, 4)
    button.count:SetTextColor(0.9,0.9,0.9)
    --fix fontsize to be based on button size
    button.count:SetFont(cfg.font,size/1.8,"THINOUTLINE")
    button.overlay:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\gloss2")
    button.overlay:SetTexCoord(0,1,0,1)
    button.overlay:SetPoint("TOPLEFT", -1, 1)
    button.overlay:SetPoint("BOTTOMRIGHT", 1, -1)
    button.overlay:SetVertexColor(0.4,0.35,0.35,1)
    button.overlay:Show()
    button.overlay.Hide = function() end
    local back = button:CreateTexture(nil, "BACKGROUND")
    back:SetPoint("TOPLEFT",button.icon,"TOPLEFT",-0.18*size,0.18*size)
    back:SetPoint("BOTTOMRIGHT",button.icon,"BOTTOMRIGHT",0.18*size,-0.18*size)
    back:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\simplesquare_glow")
    back:SetVertexColor(0, 0, 0, 1)
  end

  --create AltPowerBar
  func.createAltPowerBar = function(self,name)

    local t,f
    local num = 4
    local w = 64*num
    local h = 22

    local bar = CreateFrame("StatusBar",name,self)
    bar:SetPoint(self.cfg.altpower.pos.a1,self.cfg.altpower.pos.af,self.cfg.altpower.pos.a2,self.cfg.altpower.pos.x,self.cfg.altpower.pos.y)
    bar:SetSize(w,h)
	  bar:SetStatusBarTexture(self.cfg.altpower.texture)
    bar:SetStatusBarColor(self.cfg.altpower.color.r, self.cfg.altpower.color.g, self.cfg.altpower.color.b)
    bar.colorTexture = true --color the altpower bar
    --bar:SetMinMaxValues(0,100)
    --bar:SetValue(70)

    t = bar:CreateTexture(nil,"BACKGROUND",nil,-8)
    t:SetSize(64,64)
    t:SetPoint("LEFT",-64,0)
    t:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_left")
    bar.leftedge = t

    t = bar:CreateTexture(nil,"BACKGROUND",nil,-8)
    t:SetSize(64,64)
    t:SetPoint("RIGHT",64,0)
    t:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_right")
    bar.rightedge = t

    t = bar:CreateTexture(nil,"BACKGROUND",nil,-8)
    t:SetSize(64*num,64)
    t:SetPoint("LEFT",0,0)
    t:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_back")
    bar.back = t

    local g = CreateFrame("Frame",nil,bar)
    g:SetAllPoints(bar)

    t = g:CreateTexture(nil,"BACKGROUND",nil,-8)
    t:SetSize(64*num,64)
    t:SetPoint("LEFT",0,0)
    t:SetAlpha(0.7)
    t:SetBlendMode("BLEND")
    t:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_highlight2")

    f = func.createFontString(g, cfg.font, 24, "THINOUTLINE")
    f:SetPoint("CENTER", 0, 0)
    f:SetTextColor(0.8,0.8,0.8)
    self:Tag(f, "[diablo:altpower]")

    bar:SetScale(self.cfg.altpower.scale)
    func.simpleDragFunc(bar)
    self.AltPowerBar = bar

  end

  --create aura watch func
  func.createAuraWatch = function(self)

    --start the DRUID setup
    if cfg.playerclass == "DRUID" then

      local auras = {}
      local spellIDs = {
        774, -- Rejuvenation
        8936, -- Regrowth
        33763, -- Lifebloom
        48438, -- Wild Growth
      }

      auras.onlyShowPresent = true
      auras.presentAlpha = 1
      auras.PostCreateIcon = func.createAuraIcon

      -- Set any other AuraWatch settings
      auras.icons = {}
      for i, sid in pairs(spellIDs) do
        local icon = CreateFrame("Frame", nil, self)
        icon.spellID = sid
        -- set the dimensions and positions
        icon:SetSize(self.cfg.aurawatch.size,self.cfg.aurawatch.size)
        icon:SetPoint("BOTTOM", self, "BOTTOM", 60, ((self.cfg.aurawatch.size+6) * i)+20)
        auras.icons[sid] = icon
        -- Set any other AuraWatch icon settings
      end
      --call aurawatch
      self.AuraWatch = auras
    end
  end

  --update health func
  func.updateHealth = function(bar, unit, min, max)
  
    local d = floor(min/max*100)
    local color
    local dead

    if unit and UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) then
      color = {r = 0.65, g = 0.65, b = 0.65}
    elseif UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit) then
      color = {r = 0.4, g = 0.4, b = 0.4}
      dead = 1
    elseif not cfg.colorswitcher.classcolored then
      color = cfg.colorswitcher.bright
    --elseif cfg.colorswitcher.threatColored and unit and UnitThreatSituation(unit) == 3 then
      --color = { r = 1, g = 0, b = 0, }
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
      bar.highlight:SetAlpha(0)
      if cfg.colorswitcher.useBrightForeground then
        bar.glow:SetVertexColor(1,0,0,0.6)
        bar:SetStatusBarColor(1,0,0,1)
        bar.bg:SetVertexColor(0.2,0,0,0.9)
      else
        bar.glow:SetVertexColor(1,0,0,1)
      end
    else
      --inner shadow
      bar.glow:SetVertexColor(0,0,0,0.7)
      bar.highlight:SetAlpha(cfg.highlightMultiplier)
    end
    --bar.highlight:SetAlpha((min/max)*cfg.highlightMultiplier)
  end

  --update power func
  func.updatePower = function(bar, unit, min, max)
    local color = cfg.powercolors[select(2, UnitPowerType(unit))]
    if not color then
      --prevent powertype from bugging out on certain encounters.
      color = {r=1,g=0.5,b=0.25}
    end
    bar:SetStatusBarColor(color.r, color.g, color.b,1)
    bar.bg:SetVertexColor(color.r, color.g, color.b,0.2)
  end

  --debuffglow
  func.createDebuffGlow = function(self)
    local t = self:CreateTexture(nil,"LOW",nil,-5)
    if self.cfg.style == "target" then
      t:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\target_debuffglow")
    else
      t:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\targettarget_debuffglow")
    end
    t:SetAllPoints(self)
    t:SetBlendMode("BLEND")
    t:SetVertexColor(0, 1, 1, 0) -- set alpha to 0 to hide the texture
    self.DebuffHighlight = t
    self.DebuffHighlightAlpha = 1
    self.DebuffHighlightFilter = true
  end

  --check threat
  func.checkThreat = function(self,event,unit)
    if unit then
      if self.unit ~= unit then return end
      local threat = UnitThreatSituation(unit)
      if(threat and threat > 0) then
        local r, g, b = GetThreatStatusColor(threat)
        if self.Border then
          self.Border:SetVertexColor(r,g,b)
          self.PortraitBack:SetVertexColor(r,g,b,1)
        end
      else
        if self.Border then
          self.Border:SetVertexColor(0.6,0.5,0.5)
          self.PortraitBack:SetVertexColor(0.1,0.1,0.1,0.9)
        end
      end
    end
  end

  --create portrait func
  func.createPortrait = function(self)

    local back = CreateFrame("Frame",nil,self)
    back:SetSize(self.cfg.width,self.cfg.width)
    back:SetPoint("BOTTOM", self, "TOP", 0, -35)
    self.PortraitHolder = back

    local t = back:CreateTexture(nil,"BACKGROUND",nil,-8)
    t:SetAllPoints(back)
    t:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\portrait_back")
    t:SetVertexColor(0.1,0.1,0.1,0.9)
    self.PortraitBack = t

    if self.cfg.portrait.use3D then
      self.Portrait = CreateFrame("PlayerModel", nil, back)
      self.Portrait:SetPoint("TOPLEFT",back,"TOPLEFT",27,-27)
      self.Portrait:SetPoint("BOTTOMRIGHT",back,"BOTTOMRIGHT",-27,27)

      local borderholder = CreateFrame("Frame", nil, self.Portrait)
      borderholder:SetAllPoints(back)
      self.BorderHolder = borderholder

      local border = borderholder:CreateTexture(nil,"BACKGROUND",nil,-6)
      border:SetAllPoints(borderholder)
      border:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\portrait_border")
      border:SetVertexColor(0.6,0.5,0.5)
      --border:SetVertexColor(1,0,0,1) --threat test
      self.Border = border

      local gloss = borderholder:CreateTexture(nil,"BACKGROUND",nil,-5)
      gloss:SetAllPoints(borderholder)
      gloss:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\portrait_gloss")
      gloss:SetVertexColor(0.9,0.95,1,0.6)

    else
      self.Portrait = back:CreateTexture(nil,"BACKGROUND",nil,-7)
      self.Portrait:SetPoint("TOPLEFT",back,"TOPLEFT",27,-27)
      self.Portrait:SetPoint("BOTTOMRIGHT",back,"BOTTOMRIGHT",-27,27)
      self.Portrait:SetTexCoord(0.15,0.85,0.15,0.85)

      local border = back:CreateTexture(nil,"BACKGROUND",nil,-6)
      border:SetAllPoints(back)
      border:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\portrait_border")
      border:SetVertexColor(0.6,0.5,0.5)
      self.Border = border

      local gloss = back:CreateTexture(nil,"BACKGROUND",nil,-5)
      gloss:SetAllPoints(back)
      gloss:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\portrait_gloss")
      gloss:SetVertexColor(0.9,0.95,1,0.6)

    end

    self.Name:SetPoint("BOTTOM", self, "TOP", 0, self.cfg.width-53)

  end

  --create standalone portrait func
  func.createStandAlonePortrait = function(self)

    local fname
    if self.cfg.style == "player" then
      fname = "oUF_DiabloPlayerPortrait"
    elseif self.cfg.style == "target" then
      fname = "oUF_DiabloTargetPortrait"
    end

    local pcfg = self.cfg.portrait

    local back = CreateFrame("Frame",fname,self)
    back:SetSize(pcfg.size,pcfg.size)
    back:SetPoint(pcfg.pos.a1,pcfg.pos.af,pcfg.pos.a2,pcfg.pos.x,pcfg.pos.y)

    func.applyDragFunctionality(back)

    local t = back:CreateTexture(nil,"BACKGROUND",nil,-8)
    t:SetAllPoints(back)
    t:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\portrait_back")
    t:SetVertexColor(0.1,0.1,0.1,0.9)

    if pcfg.use3D then
      self.Portrait = CreateFrame("PlayerModel", nil, back)
      self.Portrait:SetPoint("TOPLEFT",back,"TOPLEFT",pcfg.size*27/128,-pcfg.size*27/128)
      self.Portrait:SetPoint("BOTTOMRIGHT",back,"BOTTOMRIGHT",-pcfg.size*27/128,pcfg.size*27/128)

      local borderholder = CreateFrame("Frame", nil, self.Portrait)
      borderholder:SetAllPoints(back)

      local border = borderholder:CreateTexture(nil,"BACKGROUND",nil,-6)
      border:SetAllPoints(borderholder)
      border:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\portrait_border")
      border:SetVertexColor(0.6,0.5,0.5)

      local gloss = borderholder:CreateTexture(nil,"BACKGROUND",nil,-5)
      gloss:SetAllPoints(borderholder)
      gloss:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\portrait_gloss")
      gloss:SetVertexColor(0.9,0.95,1,0.6)

    else
      self.Portrait = back:CreateTexture(nil,"BACKGROUND",nil,-7)
      self.Portrait:SetPoint("TOPLEFT",back,"TOPLEFT",pcfg.size*27/128,-pcfg.size*27/128)
      self.Portrait:SetPoint("BOTTOMRIGHT",back,"BOTTOMRIGHT",-pcfg.size*27/128,pcfg.size*27/128)
      self.Portrait:SetTexCoord(0.15,0.85,0.15,0.85)

      local border = back:CreateTexture(nil,"BACKGROUND",nil,-6)
      border:SetAllPoints(back)
      border:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\portrait_border")
      border:SetVertexColor(0.6,0.5,0.5)

      local gloss = back:CreateTexture(nil,"BACKGROUND",nil,-5)
      gloss:SetAllPoints(back)
      gloss:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\portrait_gloss")
      gloss:SetVertexColor(0.9,0.95,1,0.6)

    end

  end

  --create castbar func
  func.createCastbar = function(f)

    local c = CreateFrame("StatusBar", "$parentCastbar", f)
    --wow is this outdated...man I really need to rewrite how the drag stuff is handled
    tinsert(oUF_Diablo_Bars,c:GetName())
    c:SetSize(186.8,20.2)
    c:SetStatusBarTexture(f.cfg.castbar.texture)
    c:SetScale(f.cfg.castbar.scale)
    c:SetPoint(f.cfg.castbar.pos.a1, f.cfg.castbar.pos.af, f.cfg.castbar.pos.a2, f.cfg.castbar.pos.x+10.1, f.cfg.castbar.pos.y)
    c:SetStatusBarColor(f.cfg.castbar.color.bar.r,f.cfg.castbar.color.bar.g,f.cfg.castbar.color.bar.b,f.cfg.castbar.color.bar.a)
    --c:SetStatusBarColor(0,0,0,1)

    c.background = c:CreateTexture(nil,"BACKGROUND",nil,-8)
    c.background:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\castbar")
    c.background:SetPoint("TOP",0,21.9)
    c.background:SetPoint("LEFT",-44.7,0)
    c.background:SetPoint("RIGHT",24.5,0)
    c.background:SetPoint("BOTTOM",0,-22.2)

    c.bg = c:CreateTexture(nil,"BACKGROUND",nil,-6)
    c.bg:SetTexture(f.cfg.castbar.texture)
    c.bg:SetAllPoints(c)
    c.bg:SetVertexColor(f.cfg.castbar.color.bg.r,f.cfg.castbar.color.bg.g,f.cfg.castbar.color.bg.b,f.cfg.castbar.color.bg.a)

    c.Text =  func.createFontString(c, cfg.font, 11, "THINOUTLINE")
    c.Text:SetPoint("LEFT", 5, 0)
    c.Text:SetJustifyH("LEFT")

    c.Time =  func.createFontString(c, cfg.font, 11, "THINOUTLINE")
    c.Time:SetPoint("RIGHT", -2, 0)

    c.Text:SetPoint("RIGHT", -50, 0)
    --c.Text:SetPoint("RIGHT", c.Time, "LEFT", -10, 0) --right point of text will anchor left point of time

    --icon
    c.Icon = c:CreateTexture(nil, "OVERLAY",nil,-5)
    c.Icon:SetSize(20.2,20.2)
    c.Icon:SetPoint("LEFT", -20.2, 0)
    c.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

    c.Spark = c:CreateTexture(nil,"LOW",nil,-7)
    c.Spark:SetBlendMode("ADD")
    c.Spark:SetVertexColor(0.8,0.6,0,1)

    c.glow = c:CreateTexture(nil, "OVERLAY",nil,-4)
    c.glow:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\castbar_glow")
    c.glow:SetAllPoints(c.background)
    c.glow:SetVertexColor(0,0,0,1)

    c.highlight = c:CreateTexture(nil,"OVERLAY",nil,-3)
    c.highlight:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\castbar_highlight")
    c.highlight:SetAllPoints(c.background)

    if f.cfg.style == "target" then
      c.Shield = c:CreateTexture(nil,"BACKGROUND",nil,-8)
      c.Shield:SetTexture(0,0,0,0)
    end

    --safezone
    if f.cfg.style == "player" and f.cfg.castbar.latency then
      c.SafeZone = c:CreateTexture(nil,"OVERLAY")
      c.SafeZone:SetTexture(f.cfg.castbar.texture)
      c.SafeZone:SetVertexColor(0.6,0,0,0.6)
      c.SafeZone:SetPoint("TOPRIGHT")
      c.SafeZone:SetPoint("BOTTOMRIGHT")
    end

    func.applyDragFunctionality(c)

    f.Castbar = c

  end

  --fontstring func
  func.createFontString = function(f, font, size, outline,layer)
    local fs = f:CreateFontString(nil, layer or "OVERLAY")
    fs:SetFont(font, size, outline)
    fs:SetShadowColor(0,0,0,1)
    return fs
  end

  --allows frames to become movable but frames can be locked or set to default positions
  func.applyDragFunctionality = function(f,special)
    --save the default position
    local getPoint = function(self)
      local pos = {}
      pos.a1, pos.af, pos.a2, pos.x, pos.y = self:GetPoint()
      if pos.af and pos.af:GetName() then pos.af = pos.af:GetName() end
      return pos
    end
    f.defaultPosition = getPoint(f)
    --new form of dragframe
    local df = CreateFrame("Frame",nil,f)
    df:SetAllPoints(f)
    df:SetFrameStrata("HIGH")
    --df:SetHitRectInsets(-15,-15,-15,-15)
    df:SetScript("OnDragStart", function(self) if IsAltKeyDown() and IsShiftKeyDown() then self:GetParent():StartMoving() end end)
    df:SetScript("OnDragStop", function(self) self:GetParent():StopMovingOrSizing() end)
    local t = df:CreateTexture(nil,"OVERLAY",nil,6)
    t:SetAllPoints(df)
    t:SetTexture(0,1,0)
    t:SetAlpha(0.2)
    df.texture = t
    f.dragframe = df
    f.dragframe:Hide()
    if not special then
      f:SetClampedToScreen(true)
    end
    if not cfg.framesUserplaced then
      f:SetMovable(false)
    else
      f:SetMovable(true)
      f:SetUserPlaced(true)
      if not cfg.framesLocked then
        f.dragframe:Show()
        f.dragframe:EnableMouse(true)
        f.dragframe:RegisterForDrag("LeftButton")
        f.dragframe:SetScript("OnEnter", function(s)
          GameTooltip:SetOwner(s, "ANCHOR_TOP")
          GameTooltip:AddLine(s:GetParent():GetName(), 0, 1, 0.5, 1, 1, 1)
          GameTooltip:AddLine("Hold down ALT+SHIFT to drag!", 1, 1, 1, 1, 1, 1)
          GameTooltip:Show()
        end)
        f.dragframe:SetScript("OnLeave", function(s) GameTooltip:Hide() end)
      end
    end
    --print(f:GetName())
    --print(f:IsUserPlaced())
  end

  --simple frame movement
  func.simpleDragFunc = function(f)

    f:SetHitRectInsets(-15,-15,-15,-15)
    f:SetClampedToScreen(true)
    f:SetMovable(true)
    f:SetUserPlaced(true)

    f:EnableMouse(true)

    f:RegisterForDrag("LeftButton")
    --[[
    f:SetScript("OnEnter", function(s)
      GameTooltip:SetOwner(s, "ANCHOR_CURSOR")
      GameTooltip:AddLine(s:GetName(), 0, 1, 0.5, 1, 1, 1)
      GameTooltip:AddLine("Hold down ALT+SHIFT to drag!", 1, 1, 1, 1, 1, 1)
      GameTooltip:Show()
    end)
    f:SetScript("OnLeave", function(s) GameTooltip:Hide() end)
    ]]--
    --f:SetScript("OnDragStart", function(s) if IsAltKeyDown() and IsShiftKeyDown() then s:StartMoving() end end)
    f:SetScript("OnDragStart", function(s) s:StartMoving() end)
    f:SetScript("OnDragStop", function(s) s:StopMovingOrSizing() end)

  end

  --create icon func
  func.createIcon = function(f,layer,size,anchorframe,anchorpoint1,anchorpoint2,posx,posy,sublevel)
    local icon = f:CreateTexture(nil,layer,nil,sublevel)
    icon:SetSize(size,size)
    icon:SetPoint(anchorpoint1,anchorframe,anchorpoint2,posx,posy)
    return icon
  end

  --heal prediction
  func.healPrediction = function(self)
    if not self.cfg.healprediction or (self.cfg.healprediction and not self.cfg.healprediction.show) then return end
    local w = self.Health:GetWidth()
    if w == 0 then
      w = self:GetWidth()-24.5-24.5 --raids and party have no width on the health frame for whatever reason, thus use self and subtract the setpoint values
    end
    -- my heals
    local mhpb = CreateFrame("StatusBar", nil, self.Health)
    mhpb:SetFrameLevel(self.Health:GetFrameLevel())
    mhpb:SetPoint("TOPLEFT", self.Health:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
    mhpb:SetPoint("BOTTOMLEFT", self.Health:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
    mhpb:SetWidth(w)
    mhpb:SetStatusBarTexture(self.cfg.healprediction.texture)
    mhpb:SetStatusBarColor(self.cfg.healprediction.color.myself.r,self.cfg.healprediction.color.myself.g,self.cfg.healprediction.color.myself.b,self.cfg.healprediction.color.myself.a)
    -- other heals
    local ohpb = CreateFrame("StatusBar", nil, self.Health)
    ohpb:SetFrameLevel(self.Health:GetFrameLevel())
    ohpb:SetPoint("TOPLEFT", mhpb:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
    ohpb:SetPoint("BOTTOMLEFT", mhpb:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
    ohpb:SetWidth(w)
    ohpb:SetStatusBarTexture(self.cfg.healprediction.texture)
    ohpb:SetStatusBarColor(self.cfg.healprediction.color.other.r,self.cfg.healprediction.color.other.g,self.cfg.healprediction.color.other.b,self.cfg.healprediction.color.other.a)
    -- Register it with oUF
    self.HealPrediction = {
      myBar = mhpb,
      otherBar = ohpb,
      maxOverflow = self.cfg.healprediction.maxoverflow,
    }
  end
