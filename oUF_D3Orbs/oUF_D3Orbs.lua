    
  ----------------
  -- CONFIG
  ---------------- 
  
  --font
  local d3font = "Interface\\AddOns\\oUF_D3Orbs\\avqest.ttf"
  
  -- myscale sets scaling. range 0-1, 0.7 = 70%.  
  -- scales all units except orbs and actionbar
  local myscale = 1
  
  -- usebar defines what actionbar texture will be used. 
  -- usebar = 1 -> 24 button texture
  -- usebar = 2 -> 36 button texture
  local usebar = 2

  -- healthcolor defines what healthcolor will be used
  -- 1 = red
  -- 2 = green
  -- 3 = blue
  -- 4 = yellow
  local healthcolor = 2

  -- healthcolor defines what healthcolor will be used
  -- 1 = red
  -- 2 = green
  -- 3 = blue
  -- 4 = yellow
  local manacolor = 1
  
  ----------------
  -- CONFIG END
  ----------------  
  
  -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
  ----------------
  -- COLRORS
  ---------------- 
  
  local healthfog
  
  if healthcolor == 2 then
    healthfog = "SPELLS\\GreenRadiationFog.m2"
  elseif healthcolor == 3 then
    healthfog = "SPELLS\\BlueRadiationFog.m2"
  elseif healthcolor == 4 then
    healthfog = "SPELLS\\OrangeRadiationFog.m2"
  else
    healthfog = "SPELLS\\RedRadiationFog.m2"
  end

  local manafog
  if manacolor == 2 then
    manafog = "SPELLS\\GreenRadiationFog.m2"
  elseif manacolor == 3 then
    manafog = "SPELLS\\BlueRadiationFog.m2"
  elseif manacolor == 4 then
    manafog = "SPELLS\\OrangeRadiationFog.m2"
  else
    manafog = "SPELLS\\RedRadiationFog.m2"
  end  
  
  local colors2 = {
    power = {
      [0] = { r = 90/255, g = 180/255, b = 200/255}, -- Mana
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
      [2] = {r = 1, g = 1, b = 0}, -- new..... | content
      [3] = {r = 0, g = 1, b = 0}, -- colors.. | happy
    },
    orbcolors = {
      [1] = {r = 0.3, g = 0, b = 0}, -- red
      [2] = {r = 0, g = 0.3, b = 0}, -- green
      [3] = {r = 0, g = 0,   b = 0.3}, -- blue
      [4] = {r = 0.4, g = 0.3, b = 0}, -- yellow
    },
    orbpos = {
      [1] = {scale = 0.8, z = -12, x = 0.8, y = -1}, -- red
      [2] = {scale = 0.75, z = -12, x = 0, y = -0.5}, -- green
      [3] = {scale = 0.75, z = -12, x = 1.2, y = -0.5}, -- blue
      [4] = {scale = 0.7, z = -12, x = 0, y = -0.7}, -- yellow
    }
  }
  
  ----------------
  -- FUNCTIONS
  ---------------- 
  
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
    button.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    button.count:SetPoint("BOTTOMRIGHT", button, 1, 0)
    button.count:SetTextColor(0.7,0.7,0.7)
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
  
  end
  
  -- creates classtext for target
  local function do_classtext(self,unit)

    --stuff I need later for target classification text
    --[[
    -- http://www.wowwiki.com/World_of_Warcraft_API#Unit_Functions
    local localizedClass, englishClass = UnitClass("unit")    -- shaman etc
    local classification = UnitClassification(unit)           -- elite/worldboss
    local creatureFamily = UnitCreatureFamily(unit)           -- crab/wolf
    local creatureType = UnitCreatureType(unit)               -- humanoid, demon, beast or nil
    local isenemy = UnitIsEnemy("player", unit)               -- Returns true if the specified units are enemies, false otherwise. 
    local isplusmob = UnitIsPlusMob("unit")                   -- return 0 or 1 is mob is elite
    local unitlevel = UnitLevel("unit")                       -- return unitlevel
    local race = UnitRace("unit")                             -- race Troll, Human etc
    local reaction = UnitReaction("player", unit)             -- http://www.wowwiki.com/API_UnitReaction  
    ]]--
    
    local string = ""
    local tmpstring = ""
    local sp = " "
    
    if UnitLevel(unit) ~= -1 then
      string = UnitLevel(unit)
    else
      string = (UnitLevel("player")+3)
    end
    
    string = string..sp
    

    local unitrace = UnitRace(unit)
    local creatureType = UnitCreatureType(unit)
    
    if unitrace and UnitIsPlayer(unit) then
      string = string..unitrace..sp
    end
    
    if creatureType and not UnitIsPlayer(unit) then
      string = string..creatureType..sp
    end
    
    local unit_classification = UnitClassification(unit)
    
    if unit_classification == "worldboss" then
      tmpstring = "Boss"
    elseif unit_classification == "rare" then
      tmpstring = "Rare"
      if UnitIsPlusMob(unit) then
        tmpstring = tmpstring.." ELITE"
      end
    elseif unit_classification == "elite" then
      tmpstring = "Elite"
    end
    
    if tmpstring ~= "" then
      tmpstring = tmpstring..sp  
    end
    
    string = string..tmpstring
    tmpstring = ""
    
    local localizedClass, englishClass = UnitClass(unit)
    
    if localizedClass and UnitIsPlayer(unit) then
      string = string..localizedClass..sp
    end
    
    
    self.Classtext:SetText(string)

  end
  
  local function updateHealth(self, event, unit, bar, min, max)
    local lifeact = UnitHealth(unit)
    local lifemax = UnitHealthMax(unit)
    
    local checkplayer = 0
    if UnitIsPlayer(unit) then
      checkplayer = 1
    end
    
    local c = max - min
    local d = floor(min/max*100)
    
    if d <= 25 and d > 0 and min > 1 then
      self.LowHP:Show()
    else
      self.LowHP:Hide()
    end
    
    if unit == "player" then
      if d == 0 or d == 100 or min == 1 then
        bar.value:SetText("")
      else
        bar.value:SetText(d)
      end
    elseif unit == "target" then
      if d == 0 or d == 100 or min == 1 then
        bar.value:SetText("")
      else
        bar.value:SetText(d)
      end
    else
      if d == 0 or d == 100 or min == 1 then
        bar.value:SetText("")
      else
        bar.value:SetText(d)
      end    
    end
    
    if unit == "target" then
      do_classtext(self,unit)
    end
    
    if unit == "player" then
      self.Health.Filling:SetHeight((lifeact / lifemax) * self.Health:GetWidth())
      self.Health.Filling:SetTexCoord(0,1,  math.abs(lifeact / lifemax - 1),1)
      self.pm1:SetAlpha((lifeact / lifemax))
      self.pm2:SetAlpha((lifeact / lifemax))
    else
  		
  		self.Health:SetStatusBarColor(0.2,0,0,1)
  		if min > 1 then
  		  self.Health.bg:SetVertexColor(0.5,0,0,1)
  		else
  		  self.Health.bg:SetVertexColor(0.15,0.15,0.15,1)
  		end

  		local tmpunitname = UnitName(unit)  		
  		if unit == "target" then
    		if tmpunitname:len() > 24 then
    		  tmpunitname = tmpunitname:sub(1, 24).."..."
    		  self.Name:SetText(tmpunitname)
    		end
  		else
    		if tmpunitname:len() > 16 then
    		  tmpunitname = tmpunitname:sub(1, 16).."..."
    		  self.Name:SetText(tmpunitname)
    		end
  		end
  		
  		if UnitIsPlayer(unit) then
        if RAID_CLASS_COLORS[select(2, UnitClass(unit))] then
          local color = RAID_CLASS_COLORS[select(2, UnitClass(unit))]
          --self.Health.bg:SetVertexColor(color.r, color.g, color.b,1)
          self.Name:SetTextColor(color.r, color.g, color.b,1)
        end
      elseif unit == "pet" and UnitExists("pet") and GetPetHappiness() then
        local happiness, _, _ = GetPetHappiness()
        local color = colors2.happiness[happiness]
        --self.Health.bg:SetVertexColor(color.r, color.g, color.b,1)
        self.Name:SetTextColor(color.r, color.g, color.b,1)
      else
        local color = FACTION_BAR_COLORS[UnitReaction(unit, "player")]
        if color then
          --self.Health.bg:SetVertexColor(color.r, color.g, color.b,1)
          self.Name:SetTextColor(color.r, color.g, color.b,1)
        else
          --self.Health.bg:SetVertexColor(0,1,0,1)
          self.Name:SetTextColor(0.9, 0.8, 0)
        end
      end
    end
  end
  
  local function updatePower(self, event, unit, bar, min, max)

    local c, d
    
    if max == 0 then
      d = 0
    else
      c = max - min
      d = floor(min/max*100)
    end
    
    if unit == "player" then
      if d == 0 or d == 100 or max == 1 then
        bar.value:SetText("")
      else
        bar.value:SetText(d)
      end
    end


    local manaact = UnitMana(unit)
    local manamax = UnitManaMax(unit)
    if (manamax == 0) then
      if unit == "player" then
        self.Power.Filling:SetHeight(0)
        self.Power.Filling:SetTexCoord(0,1,1,1)
        self.pm3:SetAlpha(0)
        self.pm4:SetAlpha(0)
      else
        local color = colors2.power[UnitPowerType(unit)]
        bar:SetStatusBarColor(color.r, color.g, color.b)
        bar.bg:SetVertexColor(color.r, color.g, color.b,0.3)
      end
    else
      if unit == "player" then
        self.Power.Filling:SetVertexColor(colors2.orbcolors[manacolor].r,colors2.orbcolors[manacolor].g,colors2.orbcolors[manacolor].b,1)
        self.Power.Filling:SetHeight((manaact / manamax) * self.Power:GetWidth())
        self.Power.Filling:SetTexCoord(0,1,  math.abs(manaact / manamax - 1),1)
        self.pm3:SetAlpha((manaact / manamax))
        self.pm4:SetAlpha((manaact / manamax))
      else
        local color = colors2.power[UnitPowerType(unit)]
        bar:SetStatusBarColor(color.r, color.g, color.b)
        bar.bg:SetVertexColor(color.r, color.g, color.b,0.3)
      end
    end
  end
  
  ----------------
  -- STYLEFUNC
  ---------------- 
 
  local function styleFunc1(self, unit)
    local _, class = UnitClass("player")
    self.menu = menu
    self:RegisterForClicks("AnyUp")
    self:SetAttribute("*type2", "menu")
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)
    
    self:SetFrameStrata("BACKGROUND")
    
    ----------------
    -- SELF
    ----------------
    
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
    
    ----------------
    -- HEALTH
    ----------------
    
    if unit == "player" then
      self.Health = CreateFrame("StatusBar", nil, self)
      self.Health:SetStatusBarTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\orb_transparent.tga")
      self.Health:SetHeight(orbsize)
      self.Health:SetWidth(orbsize)
      self.Health:SetPoint("TOPLEFT", 0, 0)
    else
      self.Health = CreateFrame("StatusBar", nil, self)
      self.Health:SetStatusBarTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\statusbar.tga")
      self.Health:SetHeight(16)
      self.Health:SetWidth(self:GetWidth())
      self.Health:SetPoint("TOPLEFT",0,-1)
    end
    
    ----------------------
    -- HEALTH BACKGROUND
    ----------------------
    
    if unit == "player" then
      self.Health.bg = self.Health:CreateTexture(nil, "BACKGROUND")
      self.Health.bg:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\orb_back.tga")
      self.Health.bg:SetAllPoints(self.Health)
      self.Health.Filling = self.Health:CreateTexture(nil, "ARTWORK")
      self.Health.Filling:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\orb_filling4.tga")
      self.Health.Filling:SetPoint("BOTTOMLEFT",0,0)
      self.Health.Filling:SetWidth(orbsize)
      self.Health.Filling:SetHeight(orbsize)

      self.Health.Filling:SetVertexColor(colors2.orbcolors[healthcolor].r,colors2.orbcolors[healthcolor].g,colors2.orbcolors[healthcolor].b,1)


      self.Health.Gloss = self.Health:CreateTexture(nil, "OVERLAY")
      self.Health.Gloss:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\orb_gloss.tga")
      self.Health.Gloss:SetAllPoints(self.Health)
      
      self.pm1 = CreateFrame("PlayerModel", nil,self.Health)
      self.pm1:SetFrameStrata("BACKGROUND")
      self.pm1:SetAllPoints(self.Health)
      self.pm1:SetModel(healthfog)
      self.pm1:SetModelScale(colors2.orbpos[healthcolor].scale)
      self.pm1:SetPosition(colors2.orbpos[healthcolor].z, colors2.orbpos[healthcolor].x, colors2.orbpos[healthcolor].y) 
      
      self.pm1:SetAlpha(1)
      
      self.pm1:SetScript("OnShow",function() 
        self.pm1:ClearModel()
        self.pm1:SetModel(healthfog)
        self.pm1:SetModelScale(colors2.orbpos[healthcolor].scale)
        self.pm1:SetPosition(colors2.orbpos[healthcolor].z, colors2.orbpos[healthcolor].x, colors2.orbpos[healthcolor].y) 
      end)
      
      self.pm2 = CreateFrame("PlayerModel", nil,self.Health)
      self.pm2:SetFrameStrata("BACKGROUND")
      self.pm2:SetAllPoints(self.Health)
      self.pm2:SetModel(healthfog)
      self.pm2:SetModelScale(colors2.orbpos[healthcolor].scale)
      self.pm2:SetPosition(colors2.orbpos[healthcolor].z, colors2.orbpos[healthcolor].x, colors2.orbpos[healthcolor].y+1) 
      self.pm2:SetAlpha(1)
      
      self.pm2:SetScript("OnShow",function() 
        self.pm2:ClearModel()
        self.pm2:SetModel(healthfog)
        self.pm2:SetModelScale(colors2.orbpos[healthcolor].scale)
        self.pm2:SetPosition(colors2.orbpos[healthcolor].z, colors2.orbpos[healthcolor].x, colors2.orbpos[healthcolor].y+1) 
      end)
      
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
    
    ----------------
    -- POWER
    ----------------
    
    if unit == "player" then
      self.Power = CreateFrame("StatusBar", nil, self)
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
      self.Power.Filling:SetVertexColor(colors2.orbcolors[manacolor].r,colors2.orbcolors[manacolor].g,colors2.orbcolors[manacolor].b,1)
      self.Power.Gloss = self.Power:CreateTexture(nil, "OVERLAY")
      self.Power.Gloss:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\orb_gloss.tga")
      self.Power.Gloss:SetAllPoints(self.Power)
      
      self.pm3 = CreateFrame("PlayerModel", nil,self.Power)
      self.pm3:SetFrameStrata("BACKGROUND")
      self.pm3:SetAllPoints(self.Power)
      self.pm3:SetModel(manafog)
      self.pm3:SetModelScale(colors2.orbpos[manacolor].scale)
      self.pm3:SetPosition(colors2.orbpos[manacolor].z, colors2.orbpos[manacolor].x, colors2.orbpos[manacolor].y) 
      self.pm3:SetAlpha(1)
      
      self.pm3:SetScript("OnShow",function() 
        self.pm3:ClearModel()
        self.pm3:SetModel(manafog)
        self.pm3:SetModelScale(colors2.orbpos[manacolor].scale)
        self.pm3:SetPosition(colors2.orbpos[manacolor].z, colors2.orbpos[manacolor].x, colors2.orbpos[manacolor].y) 
      end)
      
      self.pm4 = CreateFrame("PlayerModel", nil,self.Power)
      self.pm4:SetFrameStrata("BACKGROUND")
      self.pm4:SetAllPoints(self.Power)
      self.pm4:SetModel(manafog)
      self.pm4:SetModelScale(colors2.orbpos[manacolor].scale)
      self.pm4:SetPosition(colors2.orbpos[manacolor].z, colors2.orbpos[manacolor].x, colors2.orbpos[manacolor].y+1) 
      self.pm4:SetAlpha(1)
      
      self.pm4:SetScript("OnShow",function() 
        self.pm4:ClearModel()
        self.pm4:SetModel(manafog)
        self.pm4:SetModelScale(colors2.orbpos[manacolor].scale)
        self.pm4:SetPosition(colors2.orbpos[manacolor].z, colors2.orbpos[manacolor].x, colors2.orbpos[manacolor].y+1) 
      end)  
      
    else
      self.Power = CreateFrame("StatusBar", nil, self.Health)
      self.Power:SetStatusBarTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\statusbar.tga")
      self.Power:SetHeight(4)
      self.Power:SetWidth(self:GetWidth())
      self.Power:SetPoint("TOP", self.Health, "BOTTOM", 0, 0)
      self.Power.bg = self.Power:CreateTexture(nil, "BACKGROUND")
      self.Power.bg:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\statusbar.tga")
      self.Power.bg:SetAllPoints(self.Power)
    end

    ----------------
    -- CASTBAR
    ----------------
    
    if unit == "player" or unit == "target" then
      self.Castbar = CreateFrame("StatusBar", nil, UIParent)
      self.Castbar:SetWidth(226)
      self.Castbar:SetHeight(18)
      self.Castbar:SetStatusBarTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\statusbar.tga")
      self.Castbar.bg = self.Castbar:CreateTexture(nil, "BACKGROUND")
      self.Castbar.bg:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\statusbar.tga")
      self.Castbar.bg:SetAllPoints(self.Castbar)
      self.Castbar.bg:SetVertexColor(0.15,0.15,0.15,1)
      self.Castbar.bg2 = self.Castbar:CreateTexture(nil, "BACKGROUND")
      self.Castbar.bg2:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\d3_targetframe.tga")
      self.Castbar.bg2:SetWidth(512)
      self.Castbar.bg2:SetHeight(128)
      self.Castbar.bg2:SetPoint("CENTER",-3,0)
      if unit == "player" then
        self.Castbar:SetPoint("CENTER",UIParent,"CENTER",0,-200)
        self.Castbar:SetStatusBarColor(1,0.5,0,1)
      elseif unit == "target" then
        self.Castbar:SetPoint("CENTER",UIParent,"CENTER",0,-100)
        self.Castbar:SetStatusBarColor(1,0,0,1)
      end
      
      self.Castbar.Text = SetFontString(self.Castbar, d3font, 14, "THINOUTLINE")
      self.Castbar.Text:SetPoint("LEFT", 2, 0)
      
      self.Castbar.Time = SetFontString(self.Castbar, d3font, 14, "THINOUTLINE")
      self.Castbar.Time:SetPoint("RIGHT", -2, 0)
      
      self.Castbar:Hide()
      self.Castbar:SetScale(myscale)
      --Castbar = self.Castbar
    end
    
    ---------------------
    -- NAMES and VALUES
    ---------------------
    
    if unit == "player" then
      self.Health.value = SetFontString(self.Health, d3font, 24, "THINOUTLINE")
      self.Health.value:SetPoint("CENTER", 0, 0)
      self.Power.value = SetFontString(self.Power, d3font, 24, "THINOUTLINE")
      self.Power.value:SetPoint("CENTER", 0, 0)
    elseif unit == "target" then
      self.Name = SetFontString(self, d3font, 20, "THINOUTLINE")
      self.Name:SetPoint("BOTTOM", self, "TOP", 0, 30)
      self.Health.value = SetFontString(self.Health, d3font, 16, "THINOUTLINE")
      self.Health.value:SetPoint("RIGHT", self, "RIGHT", -2, 0)
      self.Classtext = SetFontString(self, d3font, 16, "THINOUTLINE")
      self.Classtext:SetPoint("BOTTOM", self, "TOP", 0, 13)
    else
      self.Name = SetFontString(self, d3font, 18, "THINOUTLINE")
      self.Name:SetPoint("BOTTOM", self, "TOP", 0, 15)
      self.Name:SetTextColor(0.9, 0.8, 0)
      self.Health.value = SetFontString(self.Health, d3font, 16, "THINOUTLINE")
      self.Health.value:SetPoint("RIGHT", self, "RIGHT", -2, 0)
    end
    
    ---------------------
    -- DEBUFFS
    ---------------------
    
    if unit == "player" then
      -- nothing
    elseif unit == "target" then
      self.Debuffs = CreateFrame("Frame", nil, self)
      self.Debuffs.spacing = 5
      self.Debuffs:SetHeight(20)
      self.Debuffs:SetWidth(self:GetWidth())
      self.Debuffs:SetPoint("TOP", self, "BOTTOM", 0, -15)
      self.Debuffs.initialAnchor = "TOPLEFT"
      self.Debuffs["growth-y"] = "DOWN"
      self.Debuffs.showDebuffType = true
      self.Debuffs.size = math.floor(self.Debuffs:GetHeight())
      self.Debuffs.num = 40
    else
      self.Debuffs = CreateFrame("Frame", nil, self)
      self.Debuffs.spacing = 4
      self.Debuffs:SetHeight(18)
      self.Debuffs:SetWidth(self:GetWidth())
      self.Debuffs:SetPoint("TOP", self, "BOTTOM", 0, -15)
      self.Debuffs.initialAnchor = "TOPLEFT"
      self.Debuffs["growth-y"] = "DOWN"
      self.Debuffs.showDebuffType = true
      self.Debuffs.size = math.floor(self.Debuffs:GetHeight())
      self.Debuffs.num = 4
    end
    
    ---------------------
    -- Buffs
    ---------------------
    
    if unit == "player" then
      -- nothing
    elseif unit == "target" then
      self.Buffs = CreateFrame("Frame", nil, self)
      self.Buffs.spacing = 5
      self.Buffs:SetHeight(20)
      self.Buffs:SetWidth(self:GetWidth())
      self.Buffs:SetPoint("BOTTOM", self, "TOP", 0, 55)
      self.Buffs.initialAnchor = "TOPLEFT"
      self.Buffs["growth-y"] = "UP"
      self.Buffs.size = math.floor(self.Buffs:GetHeight())
      self.Buffs.num = 8
    else
      -- nothing
    end


    ---------------------
    -- Debuff Highlight
    ---------------------    

    if unit == "player" then
      self.DebuffHighlight = self:CreateTexture(nil, "BACKGROUND")
      --self.DebuffHighlight:SetAllPoints(self)
      self.DebuffHighlight:SetWidth(self:GetWidth()*1.1)
      self.DebuffHighlight:SetHeight(self:GetWidth()*1.1)
      self.DebuffHighlight:SetPoint("CENTER",0,0)
      self.DebuffHighlight:SetBlendMode("BLEND")
      self.DebuffHighlight:SetVertexColor(1, 0, 0, 0) -- set alpha to 0 to hide the texture
      self.DebuffHighlightAlpha = 0.5
      self.DebuffHighlightFilter = false
      self.DebuffHighlight:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\orb_debuff_glow.tga")
    elseif unit == "target" then
      --big mama
    else
      self.DebuffHighlight = self:CreateTexture(nil, "OVERLAY")
      self.DebuffHighlight:SetWidth(250)
      self.DebuffHighlight:SetHeight(115)
      self.DebuffHighlight:SetPoint("CENTER",-2,0)
      self.DebuffHighlight:SetBlendMode("BLEND")
      self.DebuffHighlight:SetVertexColor(1, 0, 0, 0) -- set alpha to 0 to hide the texture
      self.DebuffHighlightAlpha = 0.4
      self.DebuffHighlightFilter = false
      self.DebuffHighlight:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\d3totframe_debuff.tga")
    end


    ---------------------
    -- Low HP
    ---------------------    
    
    if unit == "player" then
      self.LowHP = self.Health:CreateTexture(nil, "OVERLAY")
      self.LowHP:SetAllPoints(self.Health)
      self.LowHP:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\orb_lowhp_glow.tga")
      self.LowHP:SetBlendMode("BLEND")
      self.LowHP:SetVertexColor(1, 0, 0, 1)
      self.LowHP:Hide()
    elseif unit == "target" then
      self.LowHP = self.Health:CreateTexture(nil, "OVERLAY")
      self.LowHP:SetWidth(505)
      self.LowHP:SetHeight(115)
      self.LowHP:SetPoint("CENTER",-3,0)
      self.LowHP:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\d3_targetframe_lowhp.tga")
      self.LowHP:SetBlendMode("ADD")
      self.LowHP:SetVertexColor(1, 0, 0, 1)
      self.LowHP:SetAlpha(0.8)
      self.LowHP:Hide()    
    else
      self.LowHP = self.Health:CreateTexture(nil, "OVERLAY")
      self.LowHP:SetWidth(250)
      self.LowHP:SetHeight(115)
      self.LowHP:SetPoint("CENTER",-2,0)
      self.LowHP:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\d3totframe_lowhp.tga")
      self.LowHP:SetBlendMode("ADD")
      self.LowHP:SetVertexColor(1, 0, 0, 1)
      self.LowHP:SetAlpha(0.8)
      self.LowHP:Hide()
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
    
    if unit ~= "player" then
      self:SetScale(myscale)
    end
  
    return self
  end

  -------------------------------------------------------
  -- REGISTER STYLE, CALL STYLEFUNC and SPAWN UNITS
  -------------------------------------------------------
  
  actstyle = "d3orb"
  --oUF:RegisterSubTypeMapping("UNIT_LEVEL")
  oUF:RegisterStyle(actstyle, styleFunc1)
  oUF:SetActiveStyle(actstyle)
  oUF:Spawn("player"):SetPoint("BOTTOM", UIParent, "BOTTOM", -250, -8)
  oUF:Spawn("target"):SetPoint("TOP", UIParent, 0, -80)
  oUF:Spawn("pet"):SetPoint("BOTTOM", UIParent, "BOTTOM",-500, 50)
  oUF:Spawn("focus"):SetPoint("BOTTOM", UIParent, "BOTTOM", 500, 50)
  oUF:Spawn("targettarget"):SetPoint("RIGHT", oUF.units.target, "LEFT", -80, 0)
  
  local party  = oUF:Spawn("header", "oUF_Party")
  party:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 45, -50)
  party:SetManyAttributes("showParty", true, "yOffset", 50, "point", "BOTTOM", "showPlayer", false)
  
  local partyToggle = CreateFrame("Frame")
  partyToggle:RegisterEvent("PLAYER_LOGIN")
  partyToggle:RegisterEvent("RAID_ROSTER_UPDATE")
  partyToggle:RegisterEvent("PARTY_LEADER_CHANGED")
  partyToggle:RegisterEvent("PARTY_MEMBER_CHANGED")
  partyToggle:SetScript("OnEvent", function(self)
    if(InCombatLockdown()) then
      self:RegisterEvent("PLAYER_REGEN_ENABLED")
    else
      self:UnregisterEvent("PLAYER_REGEN_ENABLED")
      if(GetNumRaidMembers() > 0) then
        --party:Hide()
        party:Show()
      else
        party:Show()
      end
    end
  end)


  -----------------------------
  -- CREATING D3 ART FRAMES
  -----------------------------

  local d3f = CreateFrame("Frame",nil,UIParent)
  d3f:SetFrameStrata("TOOLTIP")
  d3f:SetWidth(155)
  d3f:SetHeight(155)
  d3f:SetPoint("BOTTOM",305,0)
  d3f:Show()
  --d3f:SetScale(myscale)
  local d3t = d3f:CreateTexture(nil,"BACKGROUND")
  d3t:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\d3_angel")
  d3t:SetAllPoints(d3f)

  local d3f2 = CreateFrame("Frame",nil,UIParent)
  d3f2:SetFrameStrata("TOOLTIP")
  d3f2:SetWidth(155)
  d3f2:SetHeight(155)
  d3f2:SetPoint("BOTTOM",-312,0)
  d3f2:Show()
  --d3f2:SetScale(myscale)
  local d3t2 = d3f2:CreateTexture(nil,"HIGHLIGHT ")
  d3t2:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\d3_demon")
  d3t2:SetAllPoints(d3f2)
  
  local d3f3 = CreateFrame("Frame",nil,UIParent)
  d3f3:SetFrameStrata("TOOLTIP")
  d3f3:SetWidth(500)
  d3f3:SetHeight(112)
  d3f3:SetPoint("BOTTOM",0,-3)
  d3f3:Show()
  --d3f3:SetScale(myscale)
  local d3t3 = d3f3:CreateTexture(nil,"BACKGROUND")
  d3t3:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\d3_bottom")
  d3t3:SetAllPoints(d3f3)
  
  local d3f4 = CreateFrame("Frame",nil,UIParent)
  d3f4:SetFrameStrata("BACKGROUND")
  d3f4:SetWidth(512)
  d3f4:SetHeight(256)
  d3f4:SetPoint("BOTTOM",1,0)
  d3f4:Show()
  --d3f4:SetScale(myscale)
  local d3t4 = d3f4:CreateTexture(nil,"BACKGROUND")
  if usebar == 1 then
    d3t4:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\d3_bar6")
  else
    d3t4:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\d3_bar5")
  end
  d3t4:SetAllPoints(d3f4)
    
