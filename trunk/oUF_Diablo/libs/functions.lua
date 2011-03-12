  
  --get the addon namespace
  local addon, ns = ...  

  --get oUF namespace (just in case needed)
  local oUF = ns.oUF or oUF  
  
  --get the config
  local cfg = ns.cfg  
  
  --object container
  local func = CreateFrame("Frame")
  
  ---------------------------------------------
  -- FUNCTIONS
  ---------------------------------------------
  
  --number format func
  func.numFormat = function(v)
    local string = ""
    if v > 1E6 then
      string = (floor((v/1E6)*10)/10).."m"
    elseif v > 1E3 then
      string = (floor((v/1E3)*10)/10).."k"
    else
      string = v
    end  
    return string
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
  
  --menu function from phanx
  local dropdown = CreateFrame("Frame", "MyAddOnUnitDropDownMenu", UIParent, "UIDropDownMenuTemplate")
  
  UIDropDownMenu_Initialize(dropdown, function(self)
    local unit = self:GetParent().unit
    if not unit then return end  
    local menu, name, id
    if UnitIsUnit(unit, "player") then
      menu = "SELF"
    elseif UnitIsUnit(unit, "vehicle") then
      menu = "VEHICLE"
    elseif UnitIsUnit(unit, "pet") then
      menu = "PET"
    elseif UnitIsPlayer(unit) then
      id = UnitInRaid(unit)
      if id then
        menu = "RAID_PLAYER"
        name = GetRaidRosterInfo(id)
      elseif UnitInParty(unit) then
        menu = "PARTY"
      else
        menu = "PLAYER"
      end
    else
      menu = "TARGET"
      name = RAID_TARGET_ICON
    end
    if menu then
      UnitPopup_ShowMenu(self, menu, unit, name, id)
    end
  end, "MENU")
  
  func.menu = function(self)
    dropdown:SetParent(self)
    ToggleDropDownMenu(1, nil, dropdown, "cursor", 0, 0)
  end
  
  --remove focus from menu list
  do 
    for k,v in pairs(UnitPopupMenus) do
      for x,y in pairs(UnitPopupMenus[k]) do
        if y == "SET_FOCUS" then
          table.remove(UnitPopupMenus[k],x)
        elseif y == "CLEAR_FOCUS" then
          table.remove(UnitPopupMenus[k],x)
        end
      end
    end
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
  
  --aura icon func
  func.createAuraIcon = function(icons, button)
    local bw = button:GetWidth()
    --button.cd:SetReverse()
    button.cd:SetPoint("TOPLEFT", 1, -1)
    button.cd:SetPoint("BOTTOMRIGHT", -1, 1)
    button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    button.count:SetParent(button.cd)
    button.count:ClearAllPoints()
    button.count:SetPoint("TOPRIGHT", 4, 4)
    button.count:SetTextColor(0.9,0.9,0.9)
    --fix fontsize to be based on button size
    button.count:SetFont(cfg.font,bw/1.8,"THINOUTLINE")
    button.overlay:SetTexture("Interface\\AddOns\\rTextures\\gloss2")
    button.overlay:SetTexCoord(0,1,0,1)
    button.overlay:SetPoint("TOPLEFT", -1, 1)
    button.overlay:SetPoint("BOTTOMRIGHT", 1, -1)
    button.overlay:SetVertexColor(0.4,0.35,0.35,1)
    button.overlay:Show()
    button.overlay.Hide = function() end    
    local back = button:CreateTexture(nil, "BACKGROUND")
    back:SetPoint("TOPLEFT",button.icon,"TOPLEFT",-0.18*bw,0.18*bw)
    back:SetPoint("BOTTOMRIGHT",button.icon,"BOTTOMRIGHT",0.18*bw,-0.18*bw)
    back:SetTexture("Interface\\AddOns\\rTextures\\simplesquare_glow")
    back:SetVertexColor(0, 0, 0, 1)    
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
    if UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit) then
      color = {r = 0.4, g = 0.4, b = 0.4}
      dead = 1
    elseif UnitIsPlayer(unit) then
      color = rRAID_CLASS_COLORS[select(2, UnitClass(unit))] or RAID_CLASS_COLORS[select(2, UnitClass(unit))]
    elseif UnitIsUnit(unit, "pet") and GetPetHappiness() then
      color = cfg.happycolors[GetPetHappiness()]
    else
      color = FACTION_BAR_COLORS[UnitReaction(unit, "player")]
    end

    if not color then color = { r = 0.5, g = 0.5, b = 0.5, } end

    if dead == 1 then
      bar:SetStatusBarColor(0,0,0,0)
      bar.bg:SetVertexColor(0,0,0,0)
    else
      if not cfg.colorswitcher.classcolored then
        color = cfg.colorswitcher.bright
      end
      if cfg.colorswitcher.useBrightForeground then
        bar:SetStatusBarColor(color.r,color.g,color.b,color.a or 1)
        bar.bg:SetVertexColor(cfg.colorswitcher.dark.r,cfg.colorswitcher.dark.g,cfg.colorswitcher.dark.b,cfg.colorswitcher.dark.a)
      else
        bar:SetStatusBarColor(cfg.colorswitcher.dark.r,cfg.colorswitcher.dark.g,cfg.colorswitcher.dark.b,cfg.colorswitcher.dark.a)
        bar.bg:SetVertexColor(color.r,color.g,color.b,color.a or 1)
      end
    end

    if d <= 25 and min > 1 then
      bar.glow:SetVertexColor(1,0,0,1)
    else
      bar.glow:SetVertexColor(0,0,0,0.7)
    end

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
      t:SetTexture("Interface\\AddOns\\rTextures\\target_debuffglow")
    else
      t:SetTexture("Interface\\AddOns\\rTextures\\targettarget_debuffglow")
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
    t:SetTexture("Interface\\AddOns\\rTextures\\portrait_back")
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
      border:SetTexture("Interface\\AddOns\\rTextures\\portrait_border")
      border:SetVertexColor(0.6,0.5,0.5)
      --border:SetVertexColor(1,0,0,1) --threat test
      self.Border = border

      local gloss = borderholder:CreateTexture(nil,"BACKGROUND",nil,-5)
      gloss:SetAllPoints(borderholder)
      gloss:SetTexture("Interface\\AddOns\\rTextures\\portrait_gloss")
      gloss:SetVertexColor(0.9,0.95,1,0.6)
      
    else
      self.Portrait = back:CreateTexture(nil,"BACKGROUND",nil,-7)
      self.Portrait:SetPoint("TOPLEFT",back,"TOPLEFT",27,-27)
      self.Portrait:SetPoint("BOTTOMRIGHT",back,"BOTTOMRIGHT",-27,27)
      self.Portrait:SetTexCoord(0.15,0.85,0.15,0.85)
      
      local border = back:CreateTexture(nil,"BACKGROUND",nil,-6)
      border:SetAllPoints(back)
      border:SetTexture("Interface\\AddOns\\rTextures\\portrait_border")
      border:SetVertexColor(0.6,0.5,0.5)
      self.Border = border

      local gloss = back:CreateTexture(nil,"BACKGROUND",nil,-5)
      gloss:SetAllPoints(back)
      gloss:SetTexture("Interface\\AddOns\\rTextures\\portrait_gloss")
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
    t:SetTexture("Interface\\AddOns\\rTextures\\portrait_back")
    t:SetVertexColor(0.1,0.1,0.1,0.9)

    if pcfg.use3D then
      self.Portrait = CreateFrame("PlayerModel", nil, back)
      self.Portrait:SetPoint("TOPLEFT",back,"TOPLEFT",pcfg.size*27/128,-pcfg.size*27/128)
      self.Portrait:SetPoint("BOTTOMRIGHT",back,"BOTTOMRIGHT",-pcfg.size*27/128,pcfg.size*27/128)
      
      local borderholder = CreateFrame("Frame", nil, self.Portrait)
      borderholder:SetAllPoints(back)
      
      local border = borderholder:CreateTexture(nil,"BACKGROUND",nil,-6)
      border:SetAllPoints(borderholder)
      border:SetTexture("Interface\\AddOns\\rTextures\\portrait_border")
      border:SetVertexColor(0.6,0.5,0.5)

      local gloss = borderholder:CreateTexture(nil,"BACKGROUND",nil,-5)
      gloss:SetAllPoints(borderholder)
      gloss:SetTexture("Interface\\AddOns\\rTextures\\portrait_gloss")
      gloss:SetVertexColor(0.9,0.95,1,0.6)
      
    else
      self.Portrait = back:CreateTexture(nil,"BACKGROUND",nil,-7)
      self.Portrait:SetPoint("TOPLEFT",back,"TOPLEFT",pcfg.size*27/128,-pcfg.size*27/128)
      self.Portrait:SetPoint("BOTTOMRIGHT",back,"BOTTOMRIGHT",-pcfg.size*27/128,pcfg.size*27/128)
      self.Portrait:SetTexCoord(0.15,0.85,0.15,0.85)
      
      local border = back:CreateTexture(nil,"BACKGROUND",nil,-6)
      border:SetAllPoints(back)
      border:SetTexture("Interface\\AddOns\\rTextures\\portrait_border")
      border:SetVertexColor(0.6,0.5,0.5)

      local gloss = back:CreateTexture(nil,"BACKGROUND",nil,-5)
      gloss:SetAllPoints(back)
      gloss:SetTexture("Interface\\AddOns\\rTextures\\portrait_gloss")
      gloss:SetVertexColor(0.9,0.95,1,0.6)

    end
    
  end
  
  --create castbar func
  func.createCastbar = function(f)
  
    local cname
    if f.cfg.style == "player" then
      cname = "oUF_DiabloPlayerCastbar"
    elseif f.cfg.style == "target" then
      cname = "oUF_DiabloTargetCastbar"
    elseif f.cfg.style == "focus" then
      cname = "oUF_DiabloFocusCastbar"
    end
    
    c = CreateFrame("StatusBar", cname, f)
    c:SetSize(186.8,20.2)
    c:SetStatusBarTexture(f.cfg.castbar.texture)
    c:SetScale(f.cfg.castbar.scale)
    c:SetPoint(f.cfg.castbar.pos.a1, f.cfg.castbar.pos.af, f.cfg.castbar.pos.a2, f.cfg.castbar.pos.x+10.1, f.cfg.castbar.pos.y)
    c:SetStatusBarColor(f.cfg.castbar.color.bar.r,f.cfg.castbar.color.bar.g,f.cfg.castbar.color.bar.b,f.cfg.castbar.color.bar.a)
    --c:SetStatusBarColor(0,0,0,1)

    c.background = c:CreateTexture(nil,"BACKGROUND",nil,-8)
    c.background:SetTexture("Interface\\AddOns\\rTextures\\castbar")
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
    c.glow:SetTexture("Interface\\AddOns\\rTextures\\castbar_glow")
    c.glow:SetAllPoints(c.background)
    c.glow:SetVertexColor(0,0,0,1)
    
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
    f:SetScript("OnDragStart", function(s) if IsAltKeyDown() and IsShiftKeyDown() then s:StartMoving() end end)
    f:SetScript("OnDragStop", function(s) s:StopMovingOrSizing() end)
    
    local t = f:CreateTexture(nil,"OVERLAY",nil,6)
    t:SetAllPoints(f)
    t:SetTexture(0,1,0)
    t:SetAlpha(0)
    f.dragtexture = t    
    f:SetHitRectInsets(-15,-15,-15,-15)
    if not special then    
      f:SetClampedToScreen(true)
    end
    
    if not cfg.framesUserplaced then
      f:SetMovable(false)
    else
      f:SetMovable(true)
      f:SetUserPlaced(true)
      if not cfg.framesLocked then
        f.dragtexture:SetAlpha(0.2)
        f:EnableMouse(true)
        f:RegisterForDrag("LeftButton")
        f:SetScript("OnEnter", function(s) 
          GameTooltip:SetOwner(s, "ANCHOR_TOP")
          GameTooltip:AddLine(s:GetName(), 0, 1, 0.5, 1, 1, 1)
          GameTooltip:AddLine("Hold down ALT+SHIFT to drag!", 1, 1, 1, 1, 1, 1)
          GameTooltip:Show()
        end)
        f:SetScript("OnLeave", function(s) GameTooltip:Hide() end)
      end
    end  

    --print(f:GetName())
    --print(f:IsUserPlaced())
    
  end
  
  --create icon func
  func.createIcon = function(f,layer,size,anchorframe,anchorpoint1,anchorpoint2,posx,posy,sublevel)
    local icon = f:CreateTexture(nil,layer,nil,sublevel)
    icon:SetSize(size,size)
    icon:SetPoint(anchorpoint1,anchorframe,anchorpoint2,posx,posy)
    return icon
  end
  
  ---------------------------------------------
  -- HANDOVER
  ---------------------------------------------
  
  --object container to addon namespace
  ns.func = func