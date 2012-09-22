
  -- oUF_Simple layout by roth - 2009
  
  -----------------------------
  -- VARIABLES + CONFIG
  -----------------------------
  
  --player name
  local myname, _ = UnitName("player")
  --player class
  local _, myclass = UnitClass("player")
  --player color
  local mycolor = rRAID_CLASS_COLORS[myclass]
  --textures
  local myflat = "Interface\\AddOns\\oUF_Simple\\flat"
  local mytexture = "Interface\\AddOns\\oUF_Simple\\statusbar"
  local myborder = "Interface\\AddOns\\oUF_Simple\\border"
  local myglow = "Interface\\AddOns\\oUF_Simple\\square_glow"
  local mycombo = "Interface\\AddOns\\oUF_Simple\\combo"
  --font used
  local myfont = "FONTS\\FRIZQT__.ttf"    
  --scale
  local myscale = 0.82
  
  --hide party in raids yes/no
  local hidepartyinraid = 1
  
  --show pvp icon
  local showpvp = 0
  
  -- shall frames be moved
  -- set this to 0 to reset all frame positions
  local allow_frame_movement = 1
  
  -- set this to 1 after you have moved everything in place
  -- THIS IS IMPORTANT because it will deactivate the mouse clickablity on that frame.
  local lock_all_frames = 0
  
  local castcol = { r = 0.9, g = 0.6, b = 0.4, }
  local bdc = { r = castcol.r*0.2, g = castcol.g*0.2, b = castcol.b*0.2, a = 0.93, }
  --local castcol = mycolor
  --local bdc = { r = mycolor.r*0.2, g = mycolor.g*0.2, b = mycolor.b*0.2, a = 0.93, }
  
  --some values
  local tabvalues = {
    power = {
      [-2] = rPowerBarColor["AMMO"], -- fuel
      [-1] = rPowerBarColor["FUEL"], -- fuel
      [0] = rPowerBarColor["MANA"], -- Mana
      [1] = rPowerBarColor["RAGE"], -- Rage
      [2] = rPowerBarColor["FOCUS"], -- Focus
      [3] = rPowerBarColor["ENERGY"], -- Energy
      [4] = rPowerBarColor["HAPPINESS"], -- Happiness
      [5] = rPowerBarColor["RUNES"], -- dont know
      [6] = rPowerBarColor["RUNIC_POWER"], -- deathknight
    },
    happiness = {
      [0] = {r = 1, g = 1, b = 1}, -- doh
      [1] = {r = 1, g = 0, b = 0}, -- need.... | unhappy
      [2] = {r = 1, g = 1, b = 0}, -- new..... | content
      [3] = {r = 0, g = 1, b = 0}, -- colors.. | happy
    },
    runes = {
    	[1] = { 1, 0, 0  },
    	[2] = { 1, 0, 0  },
    	[3] = { 0, 0.5, 0 },
    	[4] = { 0, 0.5, 0 },
    	[5] = { 0, 1, 1 },
    	[6] = { 0, 1, 1 },
    },
  }
  
  -----------------------------
  -- VARIABLES + CONFIG END
  -----------------------------
  
  -----------------------------
  -- FUNCTIONS
  -----------------------------

  --chat output func
  local function am(text)
    DEFAULT_CHAT_FRAME:AddMessage(text)
  end
    
  local function kiss_set_me_a_backdrop(f)
    f:SetBackdrop( { 
      bgFile = mytexture, 
      edgeFile = "", tile = false, tileSize = 0, edgeSize = 32, 
      insets = { left = -2, right = -2, top = -2, bottom = -2 }
    })
    f:SetBackdropColor(bdc.r,bdc.g,bdc.b,bdc.a)
  end
  
  local function kiss_set_me_a_debuffbackdrop(f)
    if f.Portrait_bgf then
      f:SetBackdrop( { 
        bgFile = myflat, 
        edgeFile = "", tile = false, tileSize = 0, edgeSize = 32, 
        insets = { left = -60, right = -5, top = -5, bottom = -5 }
      })
    else
      f:SetBackdrop( { 
        bgFile = myflat, 
        edgeFile = "", tile = false, tileSize = 0, edgeSize = 32, 
        insets = { left = -5, right = -5, top = -5, bottom = -5 }
      })
    end
    f:SetBackdropColor(0,0,0,0)
  end
  
  --do format func
  local function do_format(v)
    local string = ""
    if v > 1000000 then
      string = (floor((v/1000000)*10)/10).."m"
    elseif v > 1000 then
      string = (floor((v/1000)*10)/10).."k"
    else
      string = v
    end  
    return string
  end
  
  
  --update health func
  local function kiss_updateHealth(self, event, unit, bar, min, max)
    local d = floor(min/max*100)
    local color
    local dead
    if UnitIsDeadOrGhost(unit) == 1 or UnitIsConnected(unit) == nil then
      color = {r = 0.4, g = 0.4, b = 0.4}
      dead = 1
    elseif UnitIsPlayer(unit) then
      if rRAID_CLASS_COLORS[select(2, UnitClass(unit))] then
        color = rRAID_CLASS_COLORS[select(2, UnitClass(unit))]
      end
    elseif unit == "pet" and UnitExists("pet") and GetPetHappiness() then
      local happiness = GetPetHappiness()
      color = tabvalues.happiness[happiness]
    else
      color = rFACTION_BAR_COLORS[UnitReaction(unit, "player")]
    end
    
    if unit == "pet" and UnitExists("pet") then
      self.Name:SetText(UnitName(unit))    
    end

    if color then
      bar:SetStatusBarColor(color.r, color.g, color.b,1)
      bar.bg:SetVertexColor(color.r*0.2, color.g*0.2, color.b*0.2,bdc.a)
    end

    if dead == 1 then
      bar.bg:SetVertexColor(0,0,0,0.7)  
    end
    if color then
      self.Name:SetTextColor(color.r, color.g, color.b,1)
    end
  end
  
  --update power func
  local function kiss_updatePower(self, event, unit, bar, min, max)
      local color = tabvalues.power[UnitPowerType(unit)]
      if color then
        bar:SetStatusBarColor(color.r, color.g, color.b,1)
        bar.bg:SetVertexColor(color.r*0.2, color.g*0.2, color.b*0.2,bdc.a)
      end
  end

  --menu  
  local function menu(self)
    local unit = self.unit:sub(1, -2)
    local cunit = self.unit:gsub("(.)", string.upper, 1)
    if(unit == "party" or unit == "partypet") then
      ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor", 0, 0)
    elseif(_G[cunit.."FrameDropDown"]) then
      ToggleDropDownMenu(1, nil, _G[cunit.."FrameDropDown"], "cursor", 0, 0)
    end
  end
  
  --setup frames
  local function kiss_setupFrame(self)
    self.menu = menu
    self:RegisterForClicks("AnyUp")
    self:SetAttribute("*type2", "menu")
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)
    self:SetAttribute("initial-height", self.height)
    self:SetAttribute("initial-width", self.width)
  end
  
  
  --set fontstring
  local function SetFontString(parent, fontName, fontHeight, fontStyle)
    local fs = parent:CreateFontString(nil, "OVERLAY")
    fs:SetFont(fontName, fontHeight, fontStyle)
    fs:SetShadowColor(0,0,0,1)
    return fs
  end
  
  --create health and power bar
  local function kiss_createHealthPowerFrames(self,unit)
    --health
    self.Health = CreateFrame("StatusBar", nil, self)
    self.Health:SetStatusBarTexture(mytexture)
    self.Health:SetHeight(25)
    self.Health:SetWidth(self.width)
    self.Health:SetPoint("TOP",0,0)
    self.Health.bg = self.Health:CreateTexture(nil, "BACKGROUND")
    self.Health.bg:SetTexture(mytexture)
    self.Health.bg:ClearAllPoints()
    self.Health.bg:SetPoint("TOPLEFT",self.Health,"TOPLEFT",-2,2)
    self.Health.bg:SetPoint("BOTTOMRIGHT",self.Health,"BOTTOMRIGHT",2,-2)
     
    --power    
    self.Power = CreateFrame("StatusBar", nil, self)
    self.Power:SetStatusBarTexture(mytexture)
    self.Power:SetHeight(20)
    self.Power:SetWidth(self.width)
    self.Power:SetPoint("BOTTOM",0,0)
    self.Power.bg = self.Power:CreateTexture(nil, "BACKGROUND")
    self.Power.bg:SetTexture(mytexture)    
    self.Power.bg:ClearAllPoints()
    self.Power.bg:SetPoint("TOPLEFT",self.Power,"TOPLEFT",-2,2)
    self.Power.bg:SetPoint("BOTTOMRIGHT",self.Power,"BOTTOMRIGHT",2,-2)
    
    if unit == "pet" or unit == "player" then
      --self.Power.frequentUpdates = true
    end
    
  end
  
  --aura icon func
  local function kiss_createAuraIcon(self, button, icons, index, debuff)
    button.cd:SetReverse()
    button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    button.icon:SetDrawLayer("BORDER") 
    kiss_set_me_a_backdrop(button)
  end
  
  --buff func
  local function kiss_createBuffs(self,unit)
    self.Buffs = CreateFrame("Frame", nil, self)
    self.Buffs.size = 20
    self.Buffs.num = 40
    self.Buffs.onlyShowPlayer = false
    self.Buffs:SetHeight((self.Buffs.size+5)*3)
    self.Buffs:SetWidth(self.width)
    self.Buffs:SetPoint("BOTTOMLEFT", self, "TOPRIGHT", 5, -20)
    self.Buffs.initialAnchor = "BOTTOMLEFT"
    self.Buffs["growth-x"] = "RIGHT"
    self.Buffs["growth-y"] = "UP"
    self.Buffs.spacing = 5
  end
  
  --combopoint unit changer by p3lim
  local function updateCombo(self, event, unit)
    if(unit == PlayerFrame.unit and unit ~= self.CPoints.unit) then
      self.CPoints.unit = unit
    end
  end

  --idea for code taken from oUF_viv by Dawn
  local function kiss_createComboPoints(self,unit)
    self.CPoints = {}
    self.CPoints.unit = "player"
    
    for i = 1, 5 do
      self.CPoints[i] = CreateFrame("Frame", nil, self)
      --self.CPoints[i] = self:CreateTexture(nil, "OVERLAY")
      self.CPoints[i]:SetHeight(6)
      self.CPoints[i]:SetWidth((self.width+2) / 5 - 2 )
      kiss_set_me_a_backdrop(self.CPoints[i])
      
      self.CPoints[i].bg = self.CPoints[i]:CreateTexture(nil, "LOW")
      self.CPoints[i].bg:SetTexture(mytexture)
      self.CPoints[i].bg:SetAllPoints(self.CPoints[i])
      
      if(i==1) then
        self.CPoints[i]:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -5)
      else
        self.CPoints[i]:SetPoint("TOPLEFT", self.CPoints[i-1], "TOPRIGHT", 2, 0)
      end
    end
    self.CPoints[1].bg:SetVertexColor(1,1,0)
    self.CPoints[2].bg:SetVertexColor(1,0.75,0)
    self.CPoints[3].bg:SetVertexColor(1,0.5,0)
    self.CPoints[4].bg:SetVertexColor(1,0.25,0)
    self.CPoints[5].bg:SetVertexColor(1,0,0)
    --call function from p3lim
    self:RegisterEvent("UNIT_COMBO_POINTS", updateCombo)
  end
  
  --code taken from oUF_P3lim
  local function kiss_CreateRuneBar(self,unit)  
    self.Runes = CreateFrame("Frame", nil, self)
    self.Runes:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -5)
    self.Runes:SetHeight(6)
    self.Runes:SetWidth(self.width)
    self.Runes.anchor = "TOPLEFT"
    self.Runes.growth = "RIGHT"
    self.Runes.height = 6
    self.Runes.spacing = 2
    self.Runes.width = (self.width+2) / 6 - 2
    for index = 1, 6 do
      self.Runes[index] = CreateFrame("StatusBar", nil, self.Runes)
      self.Runes[index]:SetStatusBarTexture(mytexture)
	    local r, g, b = unpack(tabvalues.runes[index])
	    self.Runes[index]:SetStatusBarColor(r, g, b)
      kiss_set_me_a_backdrop(self.Runes[index])
    end    
    self.Debuffs:SetPoint("TOP", self.Runes, "BOTTOM", 0, -5)    
  end
  
  --debuff func
  local function kiss_createDebuffs(self,unit)
    self.Debuffs = CreateFrame("Frame", nil, self)
    if unit == "target" then
      self.Debuffs.size = 20
      self.Debuffs.num = 40
      self.Debuffs:SetHeight((self.Debuffs.size+5)*3)
      self.Debuffs:SetWidth(self.width)
      self.Debuffs:SetPoint("TOPLEFT", self, "BOTTOMRIGHT", 5, 20)
      self.Debuffs.initialAnchor = "TOPLEFT"
      self.Debuffs["growth-x"] = "RIGHT"
      self.Debuffs["growth-y"] = "DOWN"
      self.Debuffs.spacing = 5
    else
      self.Debuffs.size = 20
      self.Debuffs.num = 8
      self.Debuffs:SetHeight((self.Debuffs.size+5)*1)
      self.Debuffs:SetWidth(self.width)
      self.Debuffs:SetPoint("TOP", self, "BOTTOM", 0, -5)
      self.Debuffs.initialAnchor = "TOPLEFT"
      self.Debuffs["growth-x"] = "RIGHT"
      self.Debuffs["growth-y"] = "DOWN"
      self.Debuffs.spacing = 5      
    end
    self.Debuffs.onlyShowPlayer = false
    self.Debuffs.showDebuffType = false
  end
  
  local function kiss_createCastbar(self,unit)
    self.Castbar = CreateFrame("StatusBar", nil, self)
    self.Castbar:ClearAllPoints()
    self.Castbar.height = 30
    self.Castbar:SetHeight(self.Castbar.height)
    self.Castbar:SetWidth(self.width)
    self.Castbar:SetPoint("BOTTOM",self,"TOP",0,5)
    self.Castbar:SetStatusBarTexture(mytexture)
    self.Castbar:SetStatusBarColor(castcol.r,castcol.g,castcol.b,1)
    kiss_set_me_a_backdrop(self.Castbar)
    --text
    self.Castbar.Text = SetFontString(self.Castbar, myfont, 14, "THINOUTLINE")
    self.Castbar.Text:SetPoint("LEFT", 2, 0)
    self.Castbar.Text:SetPoint("RIGHT", -50, 0)
    self.Castbar.Text:SetJustifyH("LEFT")
    --time
    self.Castbar.Time = SetFontString(self.Castbar, myfont, 14, "THINOUTLINE")
    self.Castbar.Time:SetPoint("RIGHT", -2, 0)
    --icon
    self.Castbar.Icon = self.Castbar:CreateTexture(nil, "LOW")
    self.Castbar.Icon:SetWidth(self.Castbar.height)
    self.Castbar.Icon:SetHeight(self.Castbar.height)
    self.Castbar.Icon:SetPoint("RIGHT", self.Castbar, "LEFT", -5, 0)
    self.Castbar.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    --since the icon is no frame no backdrop possible, helper texture
    self.Castbar.IconBG = self.Castbar:CreateTexture(nil, "BACKGROUND")
    self.Castbar.IconBG:SetPoint("TOPLEFT",self.Castbar.Icon,"TOPLEFT",-2,2)
    self.Castbar.IconBG:SetPoint("BOTTOMRIGHT",self.Castbar.Icon,"BOTTOMRIGHT",2,-2)
    self.Castbar.IconBG:SetTexture(mytexture)
    self.Castbar.IconBG:SetVertexColor(bdc.r,bdc.g,bdc.b,bdc.a)
  end
  
  --create portraits func
  local function kiss_createPortraits(self,unit)
    self.Portrait_bgf = CreateFrame("Frame",nil,self)
    self.Portrait_bgf:SetPoint("RIGHT", self, "LEFT", -5, 0)
    self.Portrait_bgf:SetWidth(self.height)
    self.Portrait_bgf:SetHeight(self.height)
    kiss_set_me_a_backdrop(self.Portrait_bgf)
  
    self.Portrait = CreateFrame("PlayerModel", nil, self.Portrait_bgf)
    self.Portrait:SetPoint("TOPLEFT",self.Portrait_bgf,"TOPLEFT",0,-0)
    self.Portrait:SetPoint("BOTTOMRIGHT",self.Portrait_bgf,"BOTTOMRIGHT",-0,0)
    
    self.AggroBorder = self.Portrait_bgf:CreateTexture(nil,"LOW")
    self.AggroBorder:SetPoint("TOPLEFT",self.Portrait_bgf,"TOPLEFT",-9,9)
    self.AggroBorder:SetPoint("BOTTOMRIGHT",self.Portrait_bgf,"BOTTOMRIGHT",9,-9)
    self.AggroBorder:SetTexture(myglow)
    self.AggroBorder:SetVertexColor(bdc.r,bdc.g,bdc.b,bdc.a)
  end
  
  
  -- check threat
  local function check_threat(self,event,unit)
    if unit then
      if self.unit ~= unit then
        return
      end
      local threat = UnitThreatSituation(unit)
      if threat == 3 then
        --self.Portrait_bgf:SetBackdropColor(0.6,0,0,bdc.a)
        self.AggroBorder:SetVertexColor(0.8,0,0,bdc.a)
      elseif threat == 2 then
        --self.Portrait_bgf:SetBackdropColor(0.6,0.4,0,bdc.a)
        self.AggroBorder:SetVertexColor(0.8,0.6,0,bdc.a)
      else
        --self.Portrait_bgf:SetBackdropColor(bdc.r,bdc.g,bdc.b,bdc.a)
        self.AggroBorder:SetVertexColor(bdc.r,bdc.g,bdc.b,bdc.a)
      end
    end
  end
  
  local function make_me_movable(f)
    if allow_frame_movement == 0 then
      f:IsUserPlaced(false)
    else
      f:SetMovable(true)
      f:SetUserPlaced(true)
      if lock_all_frames == 0 then
        f:EnableMouse(true)
        f:RegisterForDrag("LeftButton","RightButton")
        f:SetScript("OnDragStart", function(self) if IsAltKeyDown() and IsShiftKeyDown() then self:StartMoving() end end)
        f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
      end
    end  
  end
  
  local function kiss_createDebuffGlow(self)
    kiss_set_me_a_debuffbackdrop(self)
    self.DebuffHighlightBackdrop = true
    self.DebuffHighlightAlpha = 0.6
    self.DebuffHighlightFilter = true
  end
  
  local function kiss_createIcons(self,unit)
    self.Leader = self.Health:CreateTexture(nil, "OVERLAY")
    self.Leader:SetHeight(16)
    self.Leader:SetWidth(16)
    self.Leader:SetPoint("TOPLEFT", self.Health, "TOPLEFT", 5, 10)
    self.Leader:SetTexture("Interface\\GroupFrame\\UI-Group-LeaderIcon")

    self.MasterLooter = self.Health:CreateTexture(nil, "OVERLAY")
    self.MasterLooter:SetHeight(14)
    self.MasterLooter:SetWidth(14)
    self.MasterLooter:SetPoint("TOPLEFT", self.Health, "TOPLEFT", 21, 10)
    self.MasterLooter:SetTexture("Interface\\GroupFrame\\UI-Group-MasterLooter")
    
    if showpvp == 1 then
      self.PvP = self.Health:CreateTexture(nil, "OVERLAY")
      self.PvP:SetHeight(50)
      self.PvP:SetWidth(50)
      self.PvP:SetPoint("TOPLEFT", self.Health, "TOPLEFT", -75, -10)
    end
    
    self.Resting = self.Health:CreateTexture(nil, "OVERLAY")
    self.Resting:SetHeight(30)
    self.Resting:SetWidth(30)
    self.Resting:SetPoint("TOPLEFT", -68, 20)
    
    self.RaidIcon = self.Health:CreateTexture(nil, "OVERLAY")
    self.RaidIcon:SetHeight(20)
    self.RaidIcon:SetWidth(20)
    self.RaidIcon:SetPoint("TOP", self.Health, "TOP", -10, 10)
    self.RaidIcon:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
  end
  
  local function kiss_createRaidIconOnly(self,unit)
    self.RaidIcon = self.Health:CreateTexture(nil, "OVERLAY")
    self.RaidIcon:SetHeight(20)
    self.RaidIcon:SetWidth(20)
    self.RaidIcon:SetPoint("TOP", self.Health, "TOP", -10, 10)
    self.RaidIcon:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
  end
  
  local function kiss_createTextStrings(self,unit)
    local name = SetFontString(self.Health, myfont, 14, "THINOUTLINE")
    name:SetPoint("LEFT", self.Health, "LEFT", 2, 0)
    name:SetJustifyH("LEFT")
    local hpval = SetFontString(self.Health, myfont, 14, "THINOUTLINE")
    hpval:SetPoint("RIGHT", self.Health, "RIGHT", -2, 0)
    name:SetPoint("RIGHT", hpval, "LEFT", -5, 0)
    local classtext = SetFontString(self.Power, myfont, 13, "THINOUTLINE")
    classtext:SetPoint("LEFT", self.Power, "LEFT", 2, 0)
    classtext:SetJustifyH("LEFT")
    local ppval = SetFontString(self.Power, myfont, 13, "THINOUTLINE")
    ppval:SetPoint("RIGHT", self.Power, "RIGHT", -2, 0)
    classtext:SetPoint("RIGHT", ppval, "LEFT", -5, 0)
    self.Name = name
    self:Tag(name, "[name]")
    self:Tag(hpval, "[kiss_abshp]/[perhp]%")
    self:Tag(classtext, "[kiss_classtext]")
    self:Tag(ppval, "[kiss_abspp]/[perpp]%")
  end
  
  -----------------------------
  -- CUSTOM TAGS
  -----------------------------
  
  oUF.Tags["[kiss_misshp]"] = function(unit) 
    local max, min = UnitHealthMax(unit), UnitHealth(unit)
    local v = max-min
    local string = ""
    if UnitIsDeadOrGhost(unit) == 1 then
      string = "dead"
    elseif UnitIsConnected(unit) == nil then
      string = "off"
    elseif v == 0 then
      string = ""
    elseif v > 1000000 then
      string = -(floor((v/1000000)*10)/10).."m"
    elseif v > 1000 then
      string = -(floor((v/1000)*10)/10).."k"
    else
      string = -v
    end  
    return string
  end
  oUF.TagEvents["[kiss_misshp]"] = "UNIT_HEALTH"
  
  oUF.Tags["[kiss_abshp]"] = function(unit) 
    local v = UnitHealth(unit)
    local string = ""
    if UnitIsDeadOrGhost(unit) == 1 then
      string = "dead"
    elseif UnitIsConnected(unit) == nil then
      string = "off"
    elseif v > 1000000 then
      string = (floor((v/1000000)*10)/10).."m"
    elseif v > 1000 then
      string = (floor((v/1000)*10)/10).."k"
    else
      string = v
    end  
    return string
  end
  oUF.TagEvents["[kiss_abshp]"] = "UNIT_HEALTH"
  
  oUF.Tags["[kiss_abspp]"] = function(unit) 
    local v = UnitMana(unit)
    local string = ""
    if v > 1000000 then
      string = (floor((v/1000000)*10)/10).."m"
    elseif v > 1000 then
      string = (floor((v/1000)*10)/10).."k"
    else
      string = v
    end  
    return string
  end
  oUF.TagEvents["[kiss_abspp]"] = "UNIT_ENERGY UNIT_FOCUS UNIT_MANA UNIT_RAGE UNIT_RUNIC_POWER"
  
  oUF.Tags["[kiss_classtext]"] = function(unit) 
    local string, tmpstring, sp = "", "", " "
    if UnitLevel(unit) ~= -1 then
      string = UnitLevel(unit)
    else
      string = "??"
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
    elseif unit_classification == "rare" or unit_classification == "rareelite" then
      tmpstring = "Rare"
      if unit_classification == "rareelite" then
        tmpstring = tmpstring.." Elite"
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
    return string
  end
    
  -----------------------------
  -- CREATE STYLES
  -----------------------------
  --create the player style
  local function CreatePlayerStyle(self, unit)
    self.width = 250
    self.height = 50
    kiss_setupFrame(self)
    make_me_movable(self)
    kiss_createHealthPowerFrames(self,unit)
    --kiss_createBuffs(self,unit)
    kiss_createDebuffs(self,unit)
    kiss_createTextStrings(self,unit)
    kiss_createCastbar(self,unit)
    kiss_createPortraits(self,unit)
    self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", check_threat)
    self.PostUpdateHealth = kiss_updateHealth
    self.PostUpdatePower = kiss_updatePower
    self.PostCreateAuraIcon = kiss_createAuraIcon
    self:SetAttribute("initial-scale", myscale)
    kiss_createDebuffGlow(self)
    kiss_createIcons(self,unit)
    if myclass == "DEATHKNIGHT" then
      kiss_CreateRuneBar(self,unit)
    end
  end  
    
  --create the target style
  local function CreateTargetStyle(self, unit)
    self.width = 250
    self.height = 50
    kiss_setupFrame(self)
    make_me_movable(self)
    kiss_createHealthPowerFrames(self,unit)
    kiss_createBuffs(self,unit)
    kiss_createDebuffs(self,unit)
    kiss_createTextStrings(self,unit)
    kiss_createCastbar(self,unit)
    kiss_createPortraits(self,unit)
    self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", check_threat)
    self.PostUpdateHealth = kiss_updateHealth
    self.PostUpdatePower = kiss_updatePower
    self.PostCreateAuraIcon = kiss_createAuraIcon
    self:SetAttribute("initial-scale", myscale)
    kiss_createDebuffGlow(self)
    kiss_createIcons(self,unit)
    kiss_createComboPoints(self,unit)
  end  
  
  --create the focus style
  local function CreateFocusStyle(self, unit)
    self.width = 200
    self.height = 50
    kiss_setupFrame(self)
    make_me_movable(self)
    kiss_createHealthPowerFrames(self,unit)
    --kiss_createBuffs(self,unit)
    kiss_createDebuffs(self,unit)
    kiss_createTextStrings(self,unit)
    kiss_createCastbar(self,unit)
    kiss_createPortraits(self,unit)
    self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", check_threat)
    self.PostUpdateHealth = kiss_updateHealth
    self.PostUpdatePower = kiss_updatePower
    self.PostCreateAuraIcon = kiss_createAuraIcon
    self:SetAttribute("initial-scale", myscale)
    kiss_createDebuffGlow(self)
    kiss_createIcons(self,unit)
  end  
  
  --create the tot style
  local function CreateToTStyle(self, unit)
    self.width = 175
    self.height = 50
    kiss_setupFrame(self)
    make_me_movable(self)
    kiss_createHealthPowerFrames(self,unit)
    --kiss_createBuffs(self,unit)
    kiss_createDebuffs(self,unit)
    kiss_createTextStrings(self,unit)    
    --kiss_createCastbar(self,unit)
    self.PostUpdateHealth = kiss_updateHealth
    self.PostUpdatePower = kiss_updatePower
    self.PostCreateAuraIcon = kiss_createAuraIcon
    self:SetAttribute("initial-scale", myscale)
    kiss_createDebuffGlow(self)
    kiss_createRaidIconOnly(self,unit)
  end  

  --create the party style
  local function CreatePartyStyle(self, unit)
    self.width = 200
    self.height = 50
    kiss_setupFrame(self)
    --make_me_movable(self)
    kiss_createHealthPowerFrames(self,unit)
    --kiss_createBuffs(self,unit)
    kiss_createDebuffs(self,unit)
    kiss_createTextStrings(self,unit)
    --kiss_createCastbar(self,unit)
    kiss_createPortraits(self,unit)
    self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", check_threat)
    self.PostUpdateHealth = kiss_updateHealth
    self.PostUpdatePower = kiss_updatePower
    self.PostCreateAuraIcon = kiss_createAuraIcon
    --self:SetAttribute("initial-scale", myscale)
    self.Range = true
    self.outsideRangeAlpha = 0.6
    self.inRangeAlpha = 1
    kiss_createDebuffGlow(self)
    kiss_createIcons(self,unit)
  end  

  -----------------------------
  -- REGISTER STYLES
  -----------------------------

  oUF:RegisterStyle("oUF_Simple_player", CreatePlayerStyle)
  oUF:RegisterStyle("oUF_Simple_target", CreateTargetStyle)
  oUF:RegisterStyle("oUF_Simple_focus", CreateFocusStyle)
  oUF:RegisterStyle("oUF_Simple_tot", CreateToTStyle)
  oUF:RegisterStyle("oUF_Simple_Party", CreatePartyStyle)
  
  -----------------------------
  -- SPAWN UNITS
  -----------------------------
  
  oUF:SetActiveStyle("oUF_Simple_target")
  oUF:Spawn("target","oUF_Simple_TargetFrame"):SetPoint("CENTER",UIParent,"CENTER",0,0)
  oUF:SetActiveStyle("oUF_Simple_player")
  oUF:Spawn("player", "oUF_Simple_PlayerFrame"):SetPoint("CENTER",UIParent,"CENTER",0,0)
  oUF:SetActiveStyle("oUF_Simple_focus")
  oUF:Spawn("focus", "oUF_Simple_FocusFrame"):SetPoint("CENTER",UIParent,"CENTER",0,0)
  oUF:Spawn("pet", "oUF_Simple_PetFrame"):SetPoint("CENTER",UIParent,"CENTER",0,0)
  oUF:SetActiveStyle("oUF_Simple_tot")
  oUF:Spawn("targettarget", "oUF_Simple_ToTFrame"):SetPoint("CENTER",UIParent,"CENTER",0,0)
  oUF:Spawn("focustarget", "oUF_Simple_FocusTargetFrame"):SetPoint("CENTER",UIParent,"CENTER",0,0)
  
  local oUF_SimplePartyDragFrame = CreateFrame("Frame","oUF_SimplePartyDragFrame",UIParent)
  oUF_SimplePartyDragFrame:SetWidth(280)
  oUF_SimplePartyDragFrame:SetHeight(75)
  oUF_SimplePartyDragFrame:SetScale(myscale)
  if lock_all_frames == 0 then
    --oUF_SimplePartyDragFrame:SetBackdrop({bgFile = myflat, edgeFile = "", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 0, right = 0, top = 0, bottom = 0 }})
  end
  oUF_SimplePartyDragFrame:SetPoint("CENTER",0,0)
  make_me_movable(oUF_SimplePartyDragFrame)
  
  oUF:SetActiveStyle("oUF_Simple_Party")
  local party = oUF:Spawn("header", "oUF_Party")
  party:SetParent(oUF_SimplePartyDragFrame)
  party:ClearAllPoints()
  party:SetPoint("TOPLEFT",66,-13)
  --party:SetPoint("TOP",oUF_SimplePartyDragFrame,"CENTER",0,0)
  party:SetManyAttributes("showParty", true, "yOffset", -37, "point", "TOP", "showPlayer", false)
  party:SetAttribute("showRaid", false)
  party:Show()

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
        if hidepartyinraid == 1 then
          party:Hide()
        else
          party:Show()
        end
      else
        party:Show()
      end
    end
  end)