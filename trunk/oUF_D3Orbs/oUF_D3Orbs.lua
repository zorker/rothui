 
  -- Colors
  local colors2 = {
    power = {
      [0] = { r = 48/255, g = 113/255, b = 191/255}, -- Mana
      [1] = { r = 255/255, g = 1/255, b = 1/255}, -- Rage
      [2] = { r = 255/255, g = 178/255, b = 0}, -- Focus
      [3] = { r = 1, g = 1, b = 34/255}, -- Energy
      [4] = { r = 0, g = 1, b = 1} -- Happiness
    },
    health = {
      [0] = {r = 49/255, g = 207/255, b = 37/255}, -- Health
      [1] = {r = .6, g = .6, b = .6}, -- Tapped targets
      [2] = {r = .1, g = .1, b = .1} -- black bar
    },
    happiness = {
      [0] = {r = 1, g = 1, b = 1}, -- bla test
      [1] = {r = 1, g = 0, b = 0}, -- need.... | unhappy
      [2] = {r = 1 ,g = 1, b = 0}, -- new..... | content
      [3] = {r = 0, g = 1, b = 0}, -- colors.. | happy
    },
  }
  
  local function menu(self)
    local unit = self.unit:sub(1, -2)
    local cunit = self.unit:gsub("(.)", string.upper, 1)
    if(unit == "party" or unit == "partypet") then
      ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor", 0, 0)
    elseif(_G[cunit.."FrameDropDown"]) then
      ToggleDropDownMenu(1, nil, _G[cunit.."FrameDropDown"], "cursor", 0, 0)
    end
  end
  
  local function SetFontString(parent, fontName, fontHeight, fontStyle)
    local fs = parent:CreateFontString(nil, "OVERLAY")
    fs:SetFont(fontName, fontHeight, fontStyle)
    --fs:SetJustifyH("CENTER")
    fs:SetShadowColor(0,0,0,1)
    return fs
  end
  
  local function auraIcon(self, button, icons, index, debuff)
    icons.showDebuffType = false
    button.cd:SetReverse()
    button.icon:SetTexCoord(.07, .93, .07, .93)
    button.count:SetPoint("BOTTOMRIGHT", button, 1, 0)
    button.count:SetTextColor(.84,.75,.65)
    button:SetScript("OnMouseUp", function(self, mouseButton)
      if mouseButton == "RightButton" then
        local name, rank = UnitBuff("player", index)
        CancelPlayerBuff(name, rank)
      end
    end)
  
    self.ButtonOverlay = button:CreateTexture(nil, "OVERLAY")
    self.ButtonOverlay:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\gloss.tga")
    self.ButtonOverlay:SetParent(button)
    self.ButtonOverlay:SetPoint("TOPLEFT", -1, 1)
    self.ButtonOverlay:SetPoint("BOTTOMRIGHT", 1, -1)
    --self.ButtonOverlay:SetVertexColor(.31,.45,.63,1)
    --self.ButtonOverlay:SetBlendMode("BLEND")
  
  end
  
  -- yyyyyyyyyyyyyyyyyyyyyyy
  
  local function updateHealth(self, event, unit, bar, min, max)
    local lifeact = UnitHealth(unit)
    local lifemax = UnitHealthMax(unit)
    
    local c = max - min
    local d = floor(min/max*100)
    
    if unit == "player" then
      if d == 0 or d == 100 then
        bar.value:SetText("")
      else
        bar.value:Show()
        bar.value:SetText(d)
      end
    elseif unit == "target" then
      if d == 0 or d == 100 then
        bar.value:SetText("")
      else
        bar.value:Show()
        bar.value:SetText(d)
      end
    else
      if d == 0 or d == 100 then
        bar.value:SetText("")
      else
        bar.value:Show()
        bar.value:SetText(d)
      end    
    end
    
    if unit == "player" then
      self.Health.Filling:SetHeight((lifeact / lifemax) * self.Health:GetWidth())
      self.Health.Filling:SetTexCoord(0,1,  math.abs(lifeact / lifemax - 1),1)
      --self.pm1:SetAlpha((lifeact / lifemax)/2)
      --self.pm2:SetAlpha((lifeact / lifemax)/2)
    else
  		self.Health:SetStatusBarColor(0.2,0,0,1)
  		if UnitIsPlayer(unit) then
        if RAID_CLASS_COLORS[select(2, UnitClass(unit))] then
          local color = RAID_CLASS_COLORS[select(2, UnitClass(unit))]
          self.Health.bg:SetVertexColor(color.r, color.g, color.b,1)
        end
      elseif unit == "pet" and UnitExists("pet") and GetPetHappiness() then
        local happiness, _, _ = GetPetHappiness()
        local color = colors2.happiness[happiness]
        self.Health.bg:SetVertexColor(color.r, color.g, color.b,1)
      else
        local color = FACTION_BAR_COLORS[UnitReaction(unit, "player")]
        if color then
          self.Health.bg:SetVertexColor(color.r, color.g, color.b,1)
        else
          self.Health.bg:SetVertexColor(0,1,0,1)
        end
      end
    end
  end
  
  local function updatePower(self, event, unit, bar, min, max)
    local manaact = UnitMana(unit)
    local manamax = UnitManaMax(unit)
    if (manamax == 0) then
      if unit == "player" then
        self.Power.Filling:SetHeight(0)
        self.Power.Filling:SetTexCoord(0,1,1,1)
        --self.pm3:SetAlpha(0)
        --self.pm4:SetAlpha(0)
      else
        local color = colors2.power[UnitPowerType(unit)]
        bar:SetStatusBarColor(color.r, color.g, color.b)
      end
    else
      if unit == "player" then
        self.Power.Filling:SetHeight((manaact / manamax) * self.Power:GetWidth())
        self.Power.Filling:SetTexCoord(0,1,  math.abs(manaact / manamax - 1),1)
        --self.pm3:SetAlpha((manaact / manamax)/2)
        --self.pm4:SetAlpha((manaact / manamax)/2)
      else
        local color = colors2.power[UnitPowerType(unit)]
        bar:SetStatusBarColor(color.r, color.g, color.b)
      end
    end
  end
  
 
  local function styleFunc1(self, unit)
    local _, class = UnitClass("player")
    self.menu = menu
    self:RegisterForClicks("AnyUp")
    self:SetAttribute("*type2", "menu")
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)
    
    self:SetFrameStrata("BACKGROUND")
    
    local orbsize = 130
    
    if unit == "player" then
      self:SetHeight(orbsize)
      self:SetWidth(orbsize)
    elseif unit == "target" then
      self:SetHeight(20)
      self:SetWidth(226)
    else
      self:SetHeight(20)
      self:SetWidth(110)
    end
  
    if unit == "player" then
      self.Health = CreateFrame("StatusBar", nil, self)
      self.Health:SetStatusBarTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\orb_transparent.tga")
      self.Health:SetHeight(orbsize)
      self.Health:SetWidth(orbsize)
      self.Health:SetPoint("TOPLEFT", 0, 0)
    else
      self.Health = CreateFrame("StatusBar", nil, self)
      self.Health:SetStatusBarTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\statusbar.tga")
      self.Health:SetHeight(18)
      self.Health:SetWidth(self:GetWidth())
      self.Health:SetPoint("TOPLEFT",0,-1)
    end
    
    if unit == "player" then
      self.Health.bg = self.Health:CreateTexture(nil, "BACKGROUND")
      self.Health.bg:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\orb_back.tga")
      self.Health.bg:SetAllPoints(self.Health)
      
      self.Health.Filling = self.Health:CreateTexture(nil, "ARTWORK")
      self.Health.Filling:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\orb_filling4.tga")
      self.Health.Filling:SetPoint("BOTTOMLEFT",0,0)
      self.Health.Filling:SetWidth(orbsize)
      self.Health.Filling:SetHeight(orbsize)
      self.Health.Filling:SetVertexColor(0.6,0,0,1)

      self.Health.Gloss = self.Health:CreateTexture(nil, "OVERLAY")
      self.Health.Gloss:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\orb_gloss.tga")
      self.Health.Gloss:SetAllPoints(self.Health)

    elseif unit == "target" then
      self.bg = self:CreateTexture(nil, "BACKGROUND")
      self.bg:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\d3_targetframe.tga")
      self.bg:SetWidth(512)
      self.bg:SetHeight(128)
      self.bg:SetPoint("CENTER",-3,0)
      self.Health.bg = self.Health:CreateTexture(nil, "BACKGROUND")
      self.Health.bg:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\statusbar.tga")
      self.Health.bg:SetAllPoints(self.Health)    
    else
      self.bg = self:CreateTexture(nil, "BACKGROUND")
      self.bg:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\d3totframe.tga")
      self.bg:SetWidth(256)
      self.bg:SetHeight(128)
      self.bg:SetPoint("CENTER",-2,0)
      self.Health.bg = self.Health:CreateTexture(nil, "BACKGROUND")
      self.Health.bg:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\statusbar.tga")
      self.Health.bg:SetAllPoints(self.Health)
    end
    

    
    if unit == "player" then
      self.Power = CreateFrame("StatusBar", nil, self)
      --want non-transparent background? comment this in.
      --self.Power:SetBackdrop({bgFile = "Interface\\AddOns\\oUF_D3Orbs\\textures\\orb_back_flat.tga", insets = {top = 0, left = 0, bottom = 0, right = 0}})
      self.Power:SetStatusBarTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\orb_transparent.tga")
      self.Power:SetHeight(orbsize)
      self.Power:SetWidth(orbsize)
      self.Power:SetPoint("BOTTOM", UIParent, "BOTTOM", 250, -8)
      self.Power.bg = self.Power:CreateTexture(nil, "BACKGROUND")
      self.Power.bg:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\orb_back.tga")
      self.Power.bg:SetAllPoints(self.Power)
      self.Power.Filling = self.Power:CreateTexture(nil, "ARTWORK")
      self.Power.Filling:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\orb_filling4.tga")
      self.Power.Filling:SetPoint("BOTTOMLEFT",0,0)
      self.Power.Filling:SetWidth(orbsize)
      self.Power.Filling:SetHeight(orbsize)
      self.Power.Filling:SetVertexColor(0.1,0.5,0.5,1)
      self.Power.Gloss = self.Power:CreateTexture(nil, "OVERLAY")
      self.Power.Gloss:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\orb_gloss.tga")
      self.Power.Gloss:SetAllPoints(self.Power)
    else
      self.Power = CreateFrame("StatusBar", nil, self.Health)
      self.Power:SetStatusBarTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\statusbar.tga")
      self.Power:SetHeight(1)
      self.Power:SetWidth(self:GetWidth())
      self.Power:SetPoint("BOTTOM", self.Health, "BOTTOM", 0, 0)
      --self.Power.bg = self.Power:CreateTexture(nil, "BACKGROUND")
      --self.Power.bg:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\statusbar.tga")
      --self.Power.bg:SetAllPoints(self.Power)
    end

  
    if unit == "player" or unit == "target" then
      self.Castbar = CreateFrame("StatusBar", nil, UIParent)
      self.Castbar:SetWidth(226)
      self.Castbar:SetHeight(18)
      self.Castbar:SetStatusBarTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\statusbar.tga")
      self.Castbar:SetStatusBarColor(1,0.8,0,1)
      self.Castbar:SetPoint("BOTTOM",0,350)
      self.Castbar.bg = self.Castbar:CreateTexture(nil, "BACKGROUND")
      self.Castbar.bg:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\d3_targetframe.tga")
      self.Castbar.bg:SetWidth(512)
      self.Castbar.bg:SetHeight(128)
      self.Castbar.bg:SetPoint("CENTER",-3,0)
      if unit == "player" then
        self.Castbar:SetPoint("BOTTOM",0,250)
      elseif unit == "target" then
        self.Castbar:SetPoint("BOTTOM",0,350)
      end
      
      self.Castbar.Text = SetFontString(self.Castbar, NAMEPLATE_FONT, 16, "THINOUTLINE")
      self.Castbar.Text:SetPoint("LEFT", 2, 0)
      
      self.Castbar.Time = SetFontString(self.Castbar, NAMEPLATE_FONT, 16, "THINOUTLINE")
      self.Castbar.Time:SetPoint("RIGHT", -2, 0)
      
      self.Castbar:Hide()
      Castbar = self.Castbar
    end
    
    
    if unit == "player" then
      self.Health.value = SetFontString(self.Health, NAMEPLATE_FONT, 24, "THINOUTLINE")
      self.Health.value:SetPoint("CENTER", 0, 0)
    elseif unit == "target" then
      self.Name = SetFontString(self.Health, "Interface\\AddOns\\oUF_D3Orbs\\avqest.ttf", 20, "THINOUTLINE")
      self.Name:SetPoint("BOTTOM", self, "TOP", 0, 30)
      self.Name:SetTextColor(0.9, 0.8, 0)
      self.Health.value = SetFontString(self.Health, NAMEPLATE_FONT, 16, "THINOUTLINE")
      self.Health.value:SetPoint("RIGHT", -2, 0)
    else
      self.Name = SetFontString(self.Health, "Interface\\AddOns\\oUF_D3Orbs\\avqest.ttf", 18, "THINOUTLINE")
      self.Name:SetPoint("BOTTOM", self, "TOP", 0, 15)
      self.Name:SetTextColor(0.9, 0.8, 0)
      self.Health.value = SetFontString(self.Health, NAMEPLATE_FONT, 16, "THINOUTLINE")
      self.Health.value:SetPoint("RIGHT", -2, 0)
    end
    
    
    
    self.outsideRangeAlpha = 1
    self.inRangeAlpha = 1
    self.Range = false
      
    self.PostUpdateHealth = updateHealth
    self.PostUpdatePower = updatePower
    self.PostCreateAuraIcon = auraIcon
    self.UNIT_NAME_UPDATE = updateName
    self.UNIT_HAPPINESS = updateName
    self.PLAYER_TARGET_CHANGED = updateTarget
    
    if unit == "pet" or unit == "focus" then
      --self:SetScale(1)
    end
  
    return self
  end
  
  actstyle = "d3orb"
  --oUF:RegisterSubTypeMapping("UNIT_LEVEL")
  oUF:RegisterStyle(actstyle, styleFunc1)
  oUF:SetActiveStyle(actstyle)
  oUF:Spawn("player"):SetPoint("BOTTOM", UIParent, "BOTTOM", -250, -8)
  oUF:Spawn("target"):SetPoint("TOP", UIParent, 0, -80)
  oUF:Spawn("pet"):SetPoint("BOTTOM", UIParent, "BOTTOM",-500, 50)
  oUF:Spawn("focus"):SetPoint("BOTTOM", UIParent, "BOTTOM", 500, 50)
  oUF:Spawn("targettarget"):SetPoint("RIGHT", oUF.units.target, "LEFT", -80, 0)

  local d3f = CreateFrame("Frame",nil,UIParent)
  d3f:SetFrameStrata("TOOLTIP")
  d3f:SetWidth(155)
  d3f:SetHeight(155)
  d3f:SetPoint("BOTTOM",305,0)
  d3f:Show()
  local d3t = d3f:CreateTexture(nil,"BACKGROUND")
  d3t:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\d3_angel")
  d3t:SetAllPoints(d3f)

  local d3f2 = CreateFrame("Frame",nil,UIParent)
  d3f2:SetFrameStrata("TOOLTIP")
  d3f2:SetWidth(155)
  d3f2:SetHeight(155)
  d3f2:SetPoint("BOTTOM",-312,0)
  d3f2:Show()
  local d3t2 = d3f2:CreateTexture(nil,"HIGHLIGHT ")
  d3t2:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\d3_demon")
  d3t2:SetAllPoints(d3f2)
  
  local d3f3 = CreateFrame("Frame",nil,UIParent)
  d3f3:SetFrameStrata("TOOLTIP")
  d3f3:SetWidth(500)
  d3f3:SetHeight(112)
  d3f3:SetPoint("BOTTOM",0,-3)
  d3f3:Show()
  local d3t3 = d3f3:CreateTexture(nil,"BACKGROUND")
  d3t3:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\d3_bottom")
  d3t3:SetAllPoints(d3f3)
  
  local d3f4 = CreateFrame("Frame",nil,UIParent)
  d3f4:SetFrameStrata("BACKGROUND")
  d3f4:SetWidth(512)
  d3f4:SetHeight(256)
  d3f4:SetPoint("BOTTOM",1,0)
  d3f4:Show()
      
  local d3t4 = d3f4:CreateTexture(nil,"BACKGROUND")
  d3t4:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\d3_bar6")
  d3t4:SetAllPoints(d3f4)
    
