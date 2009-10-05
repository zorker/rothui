
  -- oUF_Simple layout by roth - 2009
  
  -----------------------------
  -- VARIABLES + CONFIG
  -----------------------------
  
  --player name
  local myname, _ = UnitName("player")
  --player class
  local _, myclass = UnitClass("player")
  --player color
  local mycolor = rRAID_CLASS_COLORS[select(2, myclass)]
  --statusbar texture
  local mytexture = "Interface\\AddOns\\oUF_Simple\\statusbar"
  local myborder = "Interface\\AddOns\\oUF_Simple\\border"
  --font used
  local myfont = "FONTS\\FRIZQT__.ttf"    
  --scale
  local myscale = 0.82
  
  -- shall frames be moved
  -- set this to 0 to reset all frame positions
  local allow_frame_movement = 1
  
  -- set this to 1 after you have moved everything in place
  -- THIS IS IMPORTANT because it will deactivate the mouse clickablity on that frame.
  local lock_all_frames = 0
  
  --hide party in raids yes/no
  local hidepartyinraid = 1
  
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
      bar.bg:SetVertexColor(color.r*0.2, color.g*0.2, color.b*0.2,0.9)
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
        bar.bg:SetVertexColor(color.r*0.2, color.g*0.2, color.b*0.2,0.9)
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
    self:SetAttribute('initial-height', self.height)
	  self:SetAttribute('initial-width', self.width)
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
      self.Power.frequentUpdates = true
    end
    
  end
  
  --aura icon func
  local function kiss_createAuraIcon(self, button, icons, index, debuff)
    button.cd:SetReverse()
    button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    local bcol = { r = 0.1, g = 0.1, b = 0.1, }
    button.iconBG = button:CreateTexture(nil, "LOW")
    button.iconBG:SetPoint("TOPLEFT",button.icon,"TOPLEFT",-2,2)
    button.iconBG:SetPoint("BOTTOMRIGHT",button.icon,"BOTTOMRIGHT",2,-2)
    button.iconBG:SetTexture(myborder)
    button.iconBG:SetVertexColor(bcol.r,bcol.g,bcol.b,1)
    
  end
  
  --buff func
  local function kiss_createBuffs(self,unit)
    self.Buffs = CreateFrame("Frame", nil, self)
    self.Buffs.size = 22
    self.Buffs.num = 40
    self.Buffs.onlyShowPlayer = false
    self.Buffs:SetHeight((self.Buffs.size+5)*3)
    self.Buffs:SetWidth(self.width)
    self.Buffs:SetPoint("TOPLEFT", self, "TOPRIGHT", 7, 0)
    self.Buffs.initialAnchor = "TOPLEFT"
    self.Buffs["growth-x"] = "RIGHT"
    self.Buffs["growth-y"] = "DOWN"
    self.Buffs.spacing = 5
  end
  
  --debuff func
  local function kiss_createDebuffs(self,unit)
    self.Debuffs = CreateFrame("Frame", nil, self)
    if unit == "target" then
      self.Debuffs.size = 22
      self.Debuffs.num = 40
      self.Debuffs:SetHeight((self.Debuffs.size+5)*3)
      self.Debuffs:SetWidth(self.width)
      self.Debuffs:SetPoint("TOPLEFT", self, "BOTTOMRIGHT", 10, 15)
      self.Debuffs.initialAnchor = "TOPLEFT"
      self.Debuffs["growth-x"] = "RIGHT"
      self.Debuffs["growth-y"] = "DOWN"
      self.Debuffs.spacing = 5
    else
      self.Debuffs.size = 22
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
    self.Castbar.bg = self.Castbar:CreateTexture(nil, "BACKGROUND")
    self.Castbar.bg:SetTexture(mytexture)
    self.Castbar.bg:ClearAllPoints()
    self.Castbar.bg:SetPoint("TOPLEFT",self.Castbar,"TOPLEFT",-2,2)
    self.Castbar.bg:SetPoint("BOTTOMRIGHT",self.Castbar,"BOTTOMRIGHT",2,-2)
    local castcol = { r = 0.9, g = 0.6, b = 0.4, }
    self.Castbar.bg:SetVertexColor(castcol.r*0.2,castcol.g*0.2,castcol.b*0.2,1)
    self.Castbar:SetStatusBarColor(castcol.r,castcol.g,castcol.b,1)
  
    self.Castbar.Text = SetFontString(self.Castbar, myfont, 14, "THINOUTLINE")
    self.Castbar.Text:SetPoint("LEFT", 2, 0)
    self.Castbar.Text:SetPoint("RIGHT", -50, 0)
    self.Castbar.Text:SetJustifyH("LEFT")
    
    self.Castbar.Time = SetFontString(self.Castbar, myfont, 14, "THINOUTLINE")
    self.Castbar.Time:SetPoint("RIGHT", -2, 0)
  
    --icon
    self.Castbar.Icon = self.Castbar:CreateTexture(nil, "LOW")
    self.Castbar.Icon:SetWidth(self.Castbar.height)
    self.Castbar.Icon:SetHeight(self.Castbar.height)
    if unit == "player" then
      --self.Castbar.Icon:SetPoint("LEFT", self, "RIGHT", 5, 0)
      self.Castbar.Icon:SetPoint("RIGHT", self.Castbar, "LEFT", -5, 0)
    elseif unit == "focus" then
      --self.Castbar.Icon:SetPoint("LEFT", self, "RIGHT", 5, 0)
      self.Castbar.Icon:SetPoint("RIGHT", self.Castbar, "LEFT", -5, 0)
    else
      self.Castbar.Icon:SetPoint("RIGHT", self.Castbar, "LEFT", -5, 0)
    end
    self.Castbar.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

    self.Castbar.IconBG = self.Castbar:CreateTexture(nil, "BACKGROUND")
    self.Castbar.IconBG:SetPoint("TOPLEFT",self.Castbar.Icon,"TOPLEFT",-2,2)
    self.Castbar.IconBG:SetPoint("BOTTOMRIGHT",self.Castbar.Icon,"BOTTOMRIGHT",2,-2)
    self.Castbar.IconBG:SetTexture(mytexture)
    self.Castbar.IconBG:SetVertexColor(castcol.r*0.2,castcol.g*0.2,castcol.b*0.2,1)
  
  end
  
  --create portraits func
  local function kiss_createPortraits(self,unit)
    self.Portrait_bgf = CreateFrame("Frame",nil,self)
    self.Portrait_bgf:SetPoint("RIGHT", self, "LEFT", -5, 0)
    self.Portrait_bgf:SetWidth(self.height)
    self.Portrait_bgf:SetHeight(self.height)
    
    local castcol = { r = 0.9, g = 0.6, b = 0.4, }
    self.Portrait_BG = self.Portrait_bgf:CreateTexture(nil, "BACKGROUND")
    self.Portrait_BG:SetPoint("TOPLEFT",self.Portrait_bgf,"TOPLEFT",-2,2)
    self.Portrait_BG:SetPoint("BOTTOMRIGHT",self.Portrait_bgf,"BOTTOMRIGHT",2,-2)
    self.Portrait_BG:SetTexture(mytexture)
    self.Portrait_BG:SetVertexColor(castcol.r*0.2,castcol.g*0.2,castcol.b*0.2,1)
  
    self.Portrait = CreateFrame("PlayerModel", nil, self.Portrait_bgf)
    self.Portrait:SetPoint("TOPLEFT",self.Portrait_bgf,"TOPLEFT",0,-0)
    self.Portrait:SetPoint("BOTTOMRIGHT",self.Portrait_bgf,"BOTTOMRIGHT",-0,0)

  end
  
  
  -- check threat
  local function check_threat(self,event,unit)
    if unit then
      if self.unit ~= unit then
        return
      end
      local threat = UnitThreatSituation(unit)
  		if threat == 3 then
  		  self.Portrait_glosst:SetVertexColor(1,0,0)
  		elseif threat == 2 then
  		  self.Portrait_glosst:SetVertexColor(1,0.6,0)
  		else
  		  self.Portrait_glosst:SetVertexColor(0.37,0.3,0.3)
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
  
  -----------------------------
  -- CUSTOM TAGS
  -----------------------------
  
  oUF.Tags["[kiss_name]"] = function(unit) 
    local tmpunitname = UnitName(unit)      
    if unit == "target" then
      if tmpunitname:len() > 20 then
        tmpunitname = tmpunitname:sub(1, 20).."..."
      end
    else
      if tmpunitname:len() > 16 then
        tmpunitname = tmpunitname:sub(1, 16).."..."
      end
    end
    return tmpunitname
  end
  
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
    local name = SetFontString(self.Health, myfont, 14, "THINOUTLINE")
    name:SetPoint("LEFT", self.Health, "LEFT", 2, 0)
    local hpval = SetFontString(self.Health, myfont, 14, "THINOUTLINE")
    hpval:SetPoint("RIGHT", self.Health, "RIGHT", -2, 0)
    hpval:SetAlpha(1)
    local classtext = SetFontString(self.Power, myfont, 13, "THINOUTLINE")
    classtext:SetPoint("LEFT", self.Power, "LEFT", 2, 0)
    classtext:SetJustifyH("LEFT")
    classtext:SetAlpha(1)
    local ppval = SetFontString(self.Power, myfont, 13, "THINOUTLINE")
    ppval:SetPoint("RIGHT", self.Power, "RIGHT", -2, 0)
    ppval:SetAlpha(1)
    self.Name = name
    self:Tag(name, "[kiss_name]")
    self:Tag(hpval, "[kiss_abshp]/[perhp]%")
    self:Tag(classtext, "[kiss_classtext]")
    self:Tag(ppval, "[kiss_abspp]/[perpp]%")
    
    kiss_createCastbar(self,unit)
    kiss_createPortraits(self,unit)
    self.PostUpdateHealth = kiss_updateHealth
    self.PostUpdatePower = kiss_updatePower
    self.PostCreateAuraIcon = kiss_createAuraIcon
    self:SetAttribute('initial-scale', myscale)
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
    local name = SetFontString(self.Health, myfont, 14, "THINOUTLINE")
    name:SetPoint("LEFT", self.Health, "LEFT", 2, 0)
    local hpval = SetFontString(self.Health, myfont, 14, "THINOUTLINE")
    hpval:SetPoint("RIGHT", self.Health, "RIGHT", -2, 0)
    hpval:SetAlpha(1)
    local classtext = SetFontString(self.Power, myfont, 13, "THINOUTLINE")
    classtext:SetPoint("LEFT", self.Power, "LEFT", 2, 0)
    classtext:SetJustifyH("LEFT")
    classtext:SetAlpha(1)
    local ppval = SetFontString(self.Power, myfont, 13, "THINOUTLINE")
    ppval:SetPoint("RIGHT", self.Power, "RIGHT", -2, 0)
    ppval:SetAlpha(1)
    self.Name = name
    self:Tag(name, "[kiss_name]")
    self:Tag(hpval, "[kiss_abshp]/[perhp]%")
    self:Tag(classtext, "[kiss_classtext]")
    self:Tag(ppval, "[kiss_abspp]/[perpp]%")
    
    kiss_createCastbar(self,unit)
    kiss_createPortraits(self,unit)
    self.PostUpdateHealth = kiss_updateHealth
    self.PostUpdatePower = kiss_updatePower
    self.PostCreateAuraIcon = kiss_createAuraIcon
    self:SetAttribute('initial-scale', myscale)
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
    local name = SetFontString(self.Health, myfont, 14, "THINOUTLINE")
    name:SetPoint("LEFT", self.Health, "LEFT", 2, 0)
    local hpval = SetFontString(self.Health, myfont, 14, "THINOUTLINE")
    hpval:SetPoint("RIGHT", self.Health, "RIGHT", -2, 0)
    hpval:SetAlpha(1)
    local classtext = SetFontString(self.Power, myfont, 13, "THINOUTLINE")
    classtext:SetPoint("LEFT", self.Power, "LEFT", 2, 0)
    classtext:SetPoint("RIGHT", self.Power, "RIGHT", (self.width/2.2)*(-1), 0)
    classtext:SetJustifyH("LEFT")
    classtext:SetAlpha(1)
    local ppval = SetFontString(self.Power, myfont, 13, "THINOUTLINE")
    ppval:SetPoint("RIGHT", self.Power, "RIGHT", -2, 0)
    ppval:SetAlpha(1)
    self.Name = name
    self:Tag(name, "[kiss_name]")
    self:Tag(hpval, "[kiss_abshp]/[perhp]%")
    self:Tag(classtext, "[kiss_classtext]")
    self:Tag(ppval, "[kiss_abspp]/[perpp]%")
    
    kiss_createCastbar(self,unit)
    kiss_createPortraits(self,unit)
    self.PostUpdateHealth = kiss_updateHealth
    self.PostUpdatePower = kiss_updatePower
    self.PostCreateAuraIcon = kiss_createAuraIcon
    self:SetAttribute('initial-scale', myscale)
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
    local name = SetFontString(self.Health, myfont, 14, "THINOUTLINE")
    name:SetPoint("LEFT", self.Health, "LEFT", 2, 0)
    name:SetPoint("RIGHT", self.Health, "RIGHT", (self.width/2.2)*(-1), 0)
    name:SetJustifyH("LEFT")
    local hpval = SetFontString(self.Health, myfont, 14, "THINOUTLINE")
    hpval:SetPoint("RIGHT", self.Health, "RIGHT", -2, 0)
    hpval:SetAlpha(1)
    local classtext = SetFontString(self.Power, myfont, 13, "THINOUTLINE")
    classtext:SetPoint("LEFT", self.Power, "LEFT", 2, 0)
    classtext:SetPoint("RIGHT", self.Power, "RIGHT", (self.width/2.2)*(-1), 0)
    classtext:SetJustifyH("LEFT")
    classtext:SetAlpha(1)
    local ppval = SetFontString(self.Power, myfont, 13, "THINOUTLINE")
    ppval:SetPoint("RIGHT", self.Power, "RIGHT", -2, 0)
    ppval:SetAlpha(1)
    self.Name = name
    self:Tag(name, "[kiss_name]")
    self:Tag(hpval, "[kiss_abshp]/[perhp]%")
    self:Tag(classtext, "[kiss_classtext]")
    self:Tag(ppval, "[kiss_abspp]/[perpp]%")
    
    --kiss_createCastbar(self,unit)
    self.PostUpdateHealth = kiss_updateHealth
    self.PostUpdatePower = kiss_updatePower
    self.PostCreateAuraIcon = kiss_createAuraIcon
    self:SetAttribute('initial-scale', myscale)
  end  

  -----------------------------
  -- REGISTER STYLES
  -----------------------------

  oUF:RegisterStyle("oUF_Simple_player", CreatePlayerStyle)
  oUF:RegisterStyle("oUF_Simple_target", CreateTargetStyle)
  oUF:RegisterStyle("oUF_Simple_focus", CreateFocusStyle)
  oUF:RegisterStyle("oUF_Simple_tot", CreateToTStyle)
  
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
