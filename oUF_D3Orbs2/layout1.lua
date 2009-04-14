
  -- oUF_D3Orbs2 layout by roth - 2009
  
  -----------------------------
  -- VARIABLES
  -----------------------------
  
  local orbsize = 150
  local d3font = "FONTS\\FRIZQT__.ttf"
  
  local playerscale = 0.82
  local targetscale = 0.82
  
  local use_rbottombarstyler = 0
  
  -- usebar defines what actionbar texture will be used. 
  -- not really needed anymore, 36 texture will only be used if MultiBarRight is shown
  -- usebar = 1 -> choose automatically
  -- usebar = 2 -> 12 button texture always
  -- usebar = 3 -> 24 button texture always
  -- usebar = 4 -> 36 button texture always
  local usebar = 1
  
  local tabvalues = {
    power = {
      [-2] = PowerBarColor["AMMO"], -- fuel
      [-1] = PowerBarColor["FUEL"], -- fuel
      [0] = PowerBarColor["MANA"], -- Mana
      --[0] = {r = 1/255, g = 130/255, b = 255/255}, -- Mana
      [1] = PowerBarColor["RAGE"], -- Rage
      [2] = PowerBarColor["FOCUS"], -- Focus
      [3] = PowerBarColor["ENERGY"], -- Energy
      [4] = PowerBarColor["HAPPINESS"], -- Happiness
      [5] = PowerBarColor["RUNES"], -- dont know
      [6] = PowerBarColor["RUNIC_POWER"], -- deathknight
    },
    frame_positions = {
      [1] =   { a1 = "BOTTOM",  a2 = "BOTTOM",  af = "UIParent",  x = 260,    y = -9      }, --player mana orb
      [2] =   { a1 = "BOTTOM",  a2 = "BOTTOM",  af = "UIParent",  x = -260,   y = -9      }, --player health orb
      [3] =   { a1 = "CENTER",  a2 = "CENTER",  af = "UIParent",  x = 0,      y = -200    }, --target frame
      [4] =   { a1 = "RIGHT",   a2 = "LEFT",    af = "oUF_D3Orbs2_TargetFrame",        x = -80,    y = 0       }, --tot
      [8] =   { a1 = "BOTTOM",  a2 = "BOTTOM",  af = "UIParent",  x = 270,    y = 0       }, --angel
      [9] =   { a1 = "BOTTOM",  a2 = "BOTTOM",  af = "UIParent",  x = -265,   y = 0       }, --demon
      [10] =  { a1 = "BOTTOM",  a2 = "BOTTOM",  af = "UIParent",  x = 0,      y = -5      }, --botomline texture
      [11] =  { a1 = "BOTTOM",  a2 = "BOTTOM",  af = "UIParent",  x = 1,      y = 0       }, --bottom bar background texture
      [12] =  { a1 = "CENTER",  a2 = "CENTER",  af = "oUF_D3Orbs2_TargetFrame",  x = 0,      y = 100     }, --castbar target
      [13] =  { a1 = "CENTER",  a2 = "CENTER",  af = "oUF_D3Orbs2_TargetFrame",  x = 0,      y = -80    },  --castbar player
      [14] =  { a1 = "CENTER",  a2 = "CENTER",  af = "oUF_D3Orbs2_TargetFrame",  x = 0,      y = 180     }, --castbar focus
    },
  }
  
  UnitPopupMenus["SELF"] = { "PVP_FLAG", "LOOT_METHOD", "LOOT_THRESHOLD", "OPT_OUT_LOOT_TITLE", "LOOT_PROMOTE", "DUNGEON_DIFFICULTY", "RESET_INSTANCES", "RAID_TARGET_ICON", "LEAVE", "CANCEL" }
  UnitPopupMenus["PET"] = { "PET_PAPERDOLL", "PET_RENAME", "PET_ABANDON", "PET_DISMISS", "CANCEL" }
  UnitPopupMenus["PARTY"] = { "MUTE", "UNMUTE", "PARTY_SILENCE", "PARTY_UNSILENCE", "RAID_SILENCE", "RAID_UNSILENCE", "BATTLEGROUND_SILENCE", "BATTLEGROUND_UNSILENCE", "WHISPER", "PROMOTE", "LOOT_PROMOTE", "UNINVITE", "INSPECT", "ACHIEVEMENTS", "TRADE", "FOLLOW", "DUEL", "RAID_TARGET_ICON", "PVP_REPORT_AFK", "RAF_SUMMON", "RAF_GRANT_LEVEL", "CANCEL" }
  UnitPopupMenus["PLAYER"] = { "WHISPER", "INSPECT", "INVITE", "ACHIEVEMENTS", "TRADE", "FOLLOW", "DUEL", "RAID_TARGET_ICON", "RAF_SUMMON", "RAF_GRANT_LEVEL", "CANCEL" }
  UnitPopupMenus["RAID_PLAYER"] = { "MUTE", "UNMUTE", "RAID_SILENCE", "RAID_UNSILENCE", "BATTLEGROUND_SILENCE", "BATTLEGROUND_UNSILENCE", "WHISPER", "INSPECT", "ACHIEVEMENTS", "TRADE", "FOLLOW", "DUEL", "RAID_TARGET_ICON", "RAID_LEADER", "RAID_PROMOTE", "RAID_DEMOTE", "LOOT_PROMOTE", "RAID_REMOVE", "PVP_REPORT_AFK", "RAF_SUMMON", "RAF_GRANT_LEVEL", "CANCEL" }
  UnitPopupMenus["RAID"] = { "MUTE", "UNMUTE", "RAID_SILENCE", "RAID_UNSILENCE", "BATTLEGROUND_SILENCE", "BATTLEGROUND_UNSILENCE", "RAID_LEADER", "RAID_PROMOTE", "RAID_MAINTANK", "RAID_MAINASSIST", "LOOT_PROMOTE", "RAID_DEMOTE", "RAID_REMOVE", "PVP_REPORT_AFK", "CANCEL" }
  UnitPopupMenus["VEHICLE"] = { "RAID_TARGET_ICON", "VEHICLE_LEAVE", "CANCEL" }
  UnitPopupMenus["TARGET"] = { "RAID_TARGET_ICON", "CANCEL" }
  UnitPopupMenus["FOCUS"] = { "RAID_TARGET_ICON", "CANCEL" }
  
  -----------------------------
  -- FUNCTIONS
  -----------------------------

  --chat output func
  local function am(text)
    DEFAULT_CHAT_FRAME:AddMessage(text)
  end
  
  --update player health func
  local function d3o2_updatePlayerHealth(self, event, unit, bar, min, max)
    self.Health.Filling:SetHeight((min / max) * self.Health:GetWidth())
    self.Health.Filling:SetTexCoord(0,1,  math.abs(min / max - 1),1)
    self.Health.Filling:SetVertexColor(0.5,1,0)
  end
  
  --update player power func
  local function d3o2_updatePlayerPower(self, event, unit, bar, min, max)
    self.Power.Filling:SetHeight((min / max) * self.Power:GetWidth())
    self.Power.Filling:SetTexCoord(0,1,  math.abs(min / max - 1),1)
    self.Power.Filling:SetVertexColor(0,0.5,1)
  end
  
  --update health func
  local function d3o2_updateHealth(self, event, unit, bar, min, max)
    bar:SetStatusBarColor(0.15,0.15,0.15,0.9)
    bar.bg:SetVertexColor(0.7,0,0,1)
    local color
    if UnitIsPlayer(unit) then
      if RAID_CLASS_COLORS[select(2, UnitClass(unit))] then
        color = RAID_CLASS_COLORS[select(2, UnitClass(unit))]
      end
    else
      color = FACTION_BAR_COLORS[UnitReaction(unit, "player")]
    end
    self.Name:SetTextColor(color.r, color.g, color.b,1)
  end
  
  --update power func
  local function d3o2_updatePower(self, event, unit, bar, min, max)
    --if max == 0 then
    --  bar:SetAlpha(0)
    --else
    --  bar:SetAlpha(1)
      local color = tabvalues.power[UnitPowerType(unit)]
      bar:SetStatusBarColor(color.r, color.g, color.b,0.9)
      bar.bg:SetVertexColor(color.r*0.3, color.g*0.3, color.b*0.3,1)
    --end
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
  
  --setup frame width, height, strata
  local function d3o2_setupFrame(self,w,h,strata)
    self.menu = menu
    self:RegisterForClicks("AnyUp")
    self:SetAttribute("*type2", "menu")
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)
    self:SetFrameStrata(strata)
    self:SetWidth(w)
    self:SetHeight(h)
  end
  
  --create orb func
  local function d3o2_createOrb(self,type)
    local orb = CreateFrame("StatusBar", nil, self)    
    orb:SetStatusBarTexture("Interface\\AddOns\\rTextures\\orb_transparent.tga")
    orb:SetHeight(orbsize)
    orb:SetWidth(orbsize)
    orb.bg = orb:CreateTexture(nil, "BACKGROUND")
    orb.bg:SetTexture("Interface\\AddOns\\rTextures\\orb_back2.tga")
    orb.bg:SetAllPoints(orb)
    orb.Filling = orb:CreateTexture(nil, "ARTWORK")
    orb.Filling:SetTexture("Interface\\AddOns\\rTextures\\orb_filling4.tga")
    orb.Filling:SetPoint("BOTTOMLEFT",0,0)
    orb.Filling:SetWidth(orbsize)
    orb.Filling:SetHeight(orbsize)
    orbGlossHolder = CreateFrame("Frame", nil, orb)
    orbGlossHolder:SetAllPoints(orb)
    orbGlossHolder:SetFrameStrata("LOW")
    orbOrbGloss = orbGlossHolder:CreateTexture(nil, "OVERLAY")
    orbOrbGloss:SetTexture("Interface\\AddOns\\rTextures\\orb_gloss.tga")
    orbOrbGloss:SetAllPoints(orbGlossHolder)
    if type == "power" then
      orb:SetPoint(tabvalues.frame_positions[1].a1, tabvalues.frame_positions[1].af, tabvalues.frame_positions[1].a2, tabvalues.frame_positions[1].x, tabvalues.frame_positions[1].y)
      self.Power = orb
      self.Power.Filling = orb.Filling
      self.Power.frequentUpdates = true
      self.Power.Smooth = true
    else
      orb:SetPoint("TOPLEFT", 0, 0)
      self.Health = orb
      self.Health.Filling = orb.Filling
      self.Health.Smooth = true
    end
  end
  
  --set fontstring
  local function SetFontString(parent, fontName, fontHeight, fontStyle)
    local fs = parent:CreateFontString(nil, "OVERLAY")
    fs:SetFont(fontName, fontHeight, fontStyle)
    fs:SetShadowColor(0,0,0,1)
    return fs
  end
  
  --create health and power bar func for every frame but not player
  local function d3o2_createHealthPowerFrames(self,unit)
    --health
    self.Health = CreateFrame("StatusBar", nil, self)
    self.Health:SetStatusBarTexture("Interface\\AddOns\\rTextures\\statusbar.tga")
    self.Health:SetHeight(16)
    self.Health:SetWidth(self:GetWidth())
    if unit == "target" or unit == "targettarget" then
      self.Health:SetPoint("TOPLEFT",0,-1)
    else
      self.Health:SetPoint("BOTTOMLEFT",0,1)
    end      
    if unit == "target" then
      self.bg = self:CreateTexture(nil, "BACKGROUND")
      self.bg:SetTexture("Interface\\AddOns\\rTextures\\d3_targetframe.tga")
      self.bg:SetWidth(512)
      self.bg:SetHeight(128)
      self.bg:SetPoint("CENTER",-3,0)
      self.Health.bg = self.Health:CreateTexture(nil, "BACKGROUND")
      self.Health.bg:SetTexture("Interface\\AddOns\\rTextures\\statusbar.tga")
      self.Health.bg:SetAllPoints(self.Health)    
    elseif unit == "targettarget" then
      self.bg = self:CreateTexture(nil, "BACKGROUND")
      self.bg:SetTexture("Interface\\AddOns\\rTextures\\d3totframe.tga")
      self.bg:SetWidth(256)
      self.bg:SetHeight(128)
      self.bg:SetPoint("CENTER",-2,0)
      self.Health.bg = self.Health:CreateTexture(nil, "BACKGROUND")
      self.Health.bg:SetTexture("Interface\\AddOns\\rTextures\\statusbar.tga")
      self.Health.bg:SetAllPoints(self.Health)
    else
      self.bg = self:CreateTexture(nil, "BACKGROUND")
      self.bg:SetTexture("Interface\\AddOns\\rTextures\\d3totframe.tga")
      self.bg:SetWidth(256)
      self.bg:SetHeight(128)
      self.bg:SetPoint("BOTTOM",-2,-56)
      self.Health.bg = self.Health:CreateTexture(nil, "BACKGROUND")
      self.Health.bg:SetTexture("Interface\\AddOns\\rTextures\\statusbar.tga")
      self.Health.bg:SetAllPoints(self.Health)    
    end  
    self.Health.Smooth = true
    --power    
    self.Power = CreateFrame("StatusBar", nil, self.Health)
    self.Power:SetStatusBarTexture("Interface\\AddOns\\rTextures\\statusbar.tga")
    self.Power:SetHeight(4)
    self.Power:SetWidth(self:GetWidth())
    self.Power:SetPoint("TOP", self.Health, "BOTTOM", 0, 0)
    self.Power.bg = self.Power:CreateTexture(nil, "BACKGROUND")
    self.Power.bg:SetTexture("Interface\\AddOns\\rTextures\\statusbar.tga")
    self.Power.bg:SetAllPoints(self.Power)
    self.Power.Smooth = true
  end
  
  --aura icon func
  local function d3o2_createAuraIcon(self, button, icons, index, debuff)
    button.cd:SetReverse()
    button.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    button.count:SetPoint("BOTTOMRIGHT", button, 1, 0)
    button.count:SetTextColor(0.7,0.7,0.7)
    self.ButtonOverlay = button:CreateTexture(nil, "OVERLAY")
    self.ButtonOverlay:SetTexture("Interface\\AddOns\\rTextures\\gloss2.tga")
    self.ButtonOverlay:SetVertexColor(0.37,0.3,0.3,1);
    self.ButtonOverlay:SetParent(button)
    self.ButtonOverlay:SetPoint("TOPLEFT", -1, 1)
    self.ButtonOverlay:SetPoint("BOTTOMRIGHT", 1, -1)  
  end
  
  --buff func
  local function d3o2_createBuffs(self,unit)
    self.Buffs = CreateFrame("Frame", nil, self)
    self.Buffs.size = 20
    self.Buffs.num = 40
    self.Buffs:SetHeight((self.Buffs.size+5)*3)
    self.Buffs:SetWidth(self:GetWidth())
    self.Buffs:SetPoint("BOTTOMLEFT", self, "TOPRIGHT", 20, 15)
    self.Buffs.initialAnchor = "BOTTOMLEFT"
    self.Buffs["growth-x"] = "RIGHT"
    self.Buffs["growth-y"] = "UP"
    self.Buffs.spacing = 5
  end
  
  --debuff func
  local function d3o2_createDebuffs(self,unit)
    self.Debuffs = CreateFrame("Frame", nil, self)
    if unit == "target" then
      self.Debuffs.size = 20
      self.Debuffs.num = 40
      self.Debuffs:SetHeight((self.Debuffs.size+5)*3)
      self.Debuffs:SetWidth(self:GetWidth())
      self.Debuffs:SetPoint("TOPLEFT", self, "BOTTOMRIGHT", 20, -15)
      self.Debuffs.initialAnchor = "TOPLEFT"
      self.Debuffs["growth-x"] = "RIGHT"
      self.Debuffs["growth-y"] = "DOWN"
      self.Debuffs.spacing = 5
    else
      self.Debuffs.size = 20
      self.Debuffs.num = 5
      self.Debuffs:SetHeight((self.Debuffs.size+5)*1)
      self.Debuffs:SetWidth(self:GetWidth())
      self.Debuffs:SetPoint("TOP", self, "BOTTOM", 0, -15)
      self.Debuffs.initialAnchor = "TOPLEFT"
      self.Debuffs["growth-x"] = "RIGHT"
      self.Debuffs["growth-y"] = "DOWN"
      self.Debuffs.spacing = 5      
    end
    self.Debuffs.onlyShowPlayer = false
    self.Debuffs.showDebuffType = false
  end
  
  local function d3o2_createCastbar(self,unit)
    self.Castbar = CreateFrame("StatusBar", nil, UIParent)
    self.Castbar:SetFrameStrata("DIALOG")
    self.Castbar:SetWidth(224)
    self.Castbar:SetHeight(18)
    self.Castbar:SetStatusBarTexture("Interface\\AddOns\\rTextures\\statusbar.tga")
    self.Castbar.bg2 = self.Castbar:CreateTexture(nil, "BACKGROUND")
    self.Castbar.bg2:SetTexture("Interface\\AddOns\\rTextures\\d3_targetframe.tga")
    self.Castbar.bg2:SetWidth(512)
    self.Castbar.bg2:SetHeight(128)
    self.Castbar.bg2:SetPoint("CENTER",-3,0)
    self.Castbar.bg = self.Castbar:CreateTexture(nil, "BORDER")
    self.Castbar.bg:SetTexture("Interface\\AddOns\\rTextures\\statusbar.tga")
    self.Castbar.bg:SetAllPoints(self.Castbar)
    self.Castbar.bg:SetVertexColor(180/255,110/255,30/255,1)
    self.Castbar:SetStatusBarColor(0.15,0.15,0.15,0.9)
    if unit == "player" then
      self.Castbar:SetPoint(tabvalues.frame_positions[13].a1, tabvalues.frame_positions[13].af, tabvalues.frame_positions[13].a2, tabvalues.frame_positions[13].x, tabvalues.frame_positions[13].y)
    elseif unit == "target" then
      self.Castbar:SetPoint(tabvalues.frame_positions[12].a1, tabvalues.frame_positions[12].af, tabvalues.frame_positions[12].a2, tabvalues.frame_positions[12].x, tabvalues.frame_positions[12].y)
    elseif unit == "focus" then
      self.Castbar:SetPoint(tabvalues.frame_positions[14].a1, tabvalues.frame_positions[14].af, tabvalues.frame_positions[14].a2, tabvalues.frame_positions[14].x, tabvalues.frame_positions[14].y)
    end
    
    self.Castbar.Text = SetFontString(self.Castbar, d3font, 14, "THINOUTLINE")
    self.Castbar.Text:SetPoint("LEFT", 2, 0)
    self.Castbar.Time = SetFontString(self.Castbar, d3font, 14, "THINOUTLINE")
    self.Castbar.Time:SetPoint("RIGHT", -2, 0)
    self.Castbar:SetScale(targetscale)
  
  end
  
  -----------------------------
  -- CUSTOM TAGS
  -----------------------------
  
  oUF.Tags["[d3o2abshp]"] = function(unit) 
    local v = UnitHealth(unit)
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
  oUF.TagEvents["[d3o2abshp]"] = "UNIT_HEALTH"
  
  oUF.Tags["[d3o2absmp]"] = function(unit) 
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
  oUF.TagEvents["[d3o2absmp]"] = "UNIT_ENERGY UNIT_FOCUS UNIT_MANA UNIT_RAGE UNIT_RUNIC_POWER"
  
  oUF.Tags["[d3o2classtext]"] = function(unit) 
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
    elseif unit_classification == "rare" then
      tmpstring = "Rare"
      if UnitIsPlusMob(unit) then
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
    d3o2_setupFrame(self,orbsize,orbsize,"BACKGROUND")    
    if use_rbottombarstyler ~= 1 then
      d3o2_createOrb(self,"health")
      d3o2_createOrb(self,"power")
      self.HealthValueHolder = CreateFrame("FRAME", nil, self.Health)
      self.HealthValueHolder:SetFrameStrata("LOW")
      self.HealthValueHolder:SetAllPoints(self.Health)
      local hpval1 = SetFontString(self.HealthValueHolder, d3font, 28, "THINOUTLINE")
      hpval1:SetPoint("CENTER", 0, 10)
      local hpval2 = SetFontString(self.HealthValueHolder, d3font, 16, "THINOUTLINE")
      hpval2:SetPoint("CENTER", 0, -10)
      hpval2:SetTextColor(0.6,0.6,0.6)
      self.PowerValueHolder = CreateFrame("FRAME", nil, self.Power)
      self.PowerValueHolder:SetFrameStrata("LOW")
      self.PowerValueHolder:SetAllPoints(self.Power)
      local mpval1 = SetFontString(self.PowerValueHolder, d3font, 28, "THINOUTLINE")
      mpval1:SetPoint("CENTER", 0, 10)
      local mpval2 = SetFontString(self.PowerValueHolder, d3font, 16, "THINOUTLINE")
      mpval2:SetPoint("CENTER", 0, -10)
      mpval2:SetTextColor(0.6,0.6,0.6)
      self:Tag(hpval1, "[perhp]")
      self:Tag(hpval2, "[d3o2abshp]")
      self:Tag(mpval1, "[perpp]")
      self:Tag(mpval2, "[d3o2absmp]")
      self.PostUpdateHealth = d3o2_updatePlayerHealth
      self.PostUpdatePower = d3o2_updatePlayerPower
      self.disallowVehicleSwap = true    
    end
    d3o2_createCastbar(self,unit)
    self:SetScale(playerscale)
  end
  
  --create the target style
  local function CreateTargetStyle(self, unit)
    d3o2_setupFrame(self,224,20,"BACKGROUND")
    d3o2_createHealthPowerFrames(self,unit)
    d3o2_createBuffs(self,unit)
    d3o2_createDebuffs(self,unit)
    
    local name = SetFontString(self, d3font, 20, "THINOUTLINE")
    name:SetPoint("BOTTOM", self, "TOP", 0, 30)
    local hpval = SetFontString(self.Health, d3font, 14, "THINOUTLINE")
    hpval:SetPoint("RIGHT", self, "RIGHT", -2, 2)
    local classtext = SetFontString(self, d3font, 16, "THINOUTLINE")
    classtext:SetPoint("BOTTOM", self, "TOP", 0, 13)
    self.Name = name
    self:Tag(name, "[name]")
    self:Tag(hpval, "[d3o2abshp] - [perhp]%")
    self:Tag(classtext, "[d3o2classtext]")
    
    d3o2_createCastbar(self,unit)
    
    self.PostUpdateHealth = d3o2_updateHealth
    self.PostUpdatePower = d3o2_updatePower
    self.PostCreateAuraIcon = d3o2_createAuraIcon
    self:SetScale(targetscale)
  end
  
  --create the tot style
  local function CreateToTStyle(self, unit)
    d3o2_setupFrame(self,110,20,"BACKGROUND")
    d3o2_createHealthPowerFrames(self,unit)
    d3o2_createDebuffs(self,unit)
    local name = SetFontString(self, d3font, 18, "THINOUTLINE")
    name:SetPoint("BOTTOM", self, "TOP", 0, 15)
    local hpval = SetFontString(self.Health, d3font, 14, "THINOUTLINE")
    hpval:SetPoint("RIGHT", self, "RIGHT", -2, 2)
    self.Name = name
    self:Tag(name, "[name]")
    self:Tag(hpval, "[perhp]%")
    
    self.PostUpdateHealth = d3o2_updateHealth
    self.PostUpdatePower = d3o2_updatePower
    self.PostCreateAuraIcon = d3o2_createAuraIcon
    self:SetScale(targetscale)
  end

  -----------------------------
  -- REGISTER STYLES
  -----------------------------

  oUF:RegisterStyle("oUF_D3Orbs2_player", CreatePlayerStyle)
  oUF:RegisterStyle("oUF_D3Orbs2_target", CreateTargetStyle)
  oUF:RegisterStyle("oUF_D3Orbs2_tot", CreateToTStyle)
  
  -----------------------------
  -- SPAWN UNITS
  -----------------------------
  
  oUF:SetActiveStyle("oUF_D3Orbs2_target")
  oUF:Spawn("target","oUF_D3Orbs2_TargetFrame"):SetPoint(tabvalues.frame_positions[3].a1, tabvalues.frame_positions[3].af, tabvalues.frame_positions[3].a2, tabvalues.frame_positions[3].x, tabvalues.frame_positions[3].y)  
  oUF:SetActiveStyle("oUF_D3Orbs2_player")
  oUF:Spawn("player", "oUF_D3Orbs2_PlayerFrame"):SetPoint(tabvalues.frame_positions[2].a1, tabvalues.frame_positions[2].af, tabvalues.frame_positions[2].a2, tabvalues.frame_positions[2].x, tabvalues.frame_positions[2].y)  
  oUF:SetActiveStyle("oUF_D3Orbs2_tot")
  oUF:Spawn("targettarget","oUF_D3Orbs2_ToT"):SetPoint(tabvalues.frame_positions[4].a1, tabvalues.frame_positions[4].af, tabvalues.frame_positions[4].a2, tabvalues.frame_positions[4].x, tabvalues.frame_positions[4].y)
  
  -----------------------------
  -- CREATING D3 ART FRAMES
  -----------------------------
  
  if use_rbottombarstyler ~= 1 then
    
    local d3f = CreateFrame("Frame",nil,UIParent)
    d3f:SetFrameStrata("TOOLTIP")
    d3f:SetWidth(320)
    d3f:SetHeight(160)
    d3f:SetPoint(tabvalues.frame_positions[8].a1, tabvalues.frame_positions[8].af, tabvalues.frame_positions[8].a2, tabvalues.frame_positions[8].x, tabvalues.frame_positions[8].y)
    d3f:Show()
    d3f:SetScale(playerscale)
    local d3t = d3f:CreateTexture(nil,"BACKGROUND")
    d3t:SetTexture("Interface\\AddOns\\rTextures\\d3_angel2")
    d3t:SetAllPoints(d3f)
  
    local d3f2 = CreateFrame("Frame",nil,UIParent)
    d3f2:SetFrameStrata("TOOLTIP")
    d3f2:SetWidth(320)
    d3f2:SetHeight(160)
    d3f2:SetPoint(tabvalues.frame_positions[9].a1, tabvalues.frame_positions[9].af, tabvalues.frame_positions[9].a2, tabvalues.frame_positions[9].x, tabvalues.frame_positions[9].y)
    d3f2:Show()
    d3f2:SetScale(playerscale)
    local d3t2 = d3f2:CreateTexture(nil,"BACKGROUND")
    d3t2:SetTexture("Interface\\AddOns\\rTextures\\d3_demon2")
    d3t2:SetAllPoints(d3f2)
    
    local d3f3 = CreateFrame("Frame",nil,UIParent)
    d3f3:SetFrameStrata("TOOLTIP")
    d3f3:SetWidth(500)
    d3f3:SetHeight(112)
    d3f3:SetPoint(tabvalues.frame_positions[10].a1, tabvalues.frame_positions[10].af, tabvalues.frame_positions[10].a2, tabvalues.frame_positions[10].x, tabvalues.frame_positions[10].y)
    d3f3:Show()
    d3f3:SetScale(playerscale)
    local d3t3 = d3f3:CreateTexture(nil,"BACKGROUND")
    d3t3:SetTexture("Interface\\AddOns\\rTextures\\d3_bottom")
    d3t3:SetAllPoints(d3f3)
    
    local d3f4 = CreateFrame("Frame",nil,UIParent)
    d3f4:SetFrameStrata("BACKGROUND")
    d3f4:SetWidth(512)
    d3f4:SetHeight(256)
    d3f4:SetPoint(tabvalues.frame_positions[11].a1, tabvalues.frame_positions[11].af, tabvalues.frame_positions[11].a2, tabvalues.frame_positions[11].x, tabvalues.frame_positions[11].y)
    d3f4:Show()
    d3f4:SetScale(playerscale)
    local d3t4 = d3f4:CreateTexture(nil,"BACKGROUND")
    d3t4:SetAllPoints(d3f4)
  
  
    
    if usebar == 2 then
      d3t4:SetTexture("Interface\\AddOns\\rTextures\\bar1")
    elseif usebar == 3 then
      d3t4:SetTexture("Interface\\AddOns\\rTextures\\bar2")
    elseif usebar == 4 then
      d3t4:SetTexture("Interface\\AddOns\\rTextures\\bar3")
    else
      if MultiBarBottomRight:IsShown() then
        d3t4:SetTexture("Interface\\AddOns\\rTextures\\bar3")
      elseif MultiBarBottomLeft:IsShown() then
        d3t4:SetTexture("Interface\\AddOns\\rTextures\\bar2")
      else
        d3t4:SetTexture("Interface\\AddOns\\rTextures\\bar1")
      end
      MultiBarBottomRight:HookScript("OnShow", function() d3t4:SetTexture("Interface\\AddOns\\rTextures\\bar3") end)
      MultiBarBottomRight:HookScript("OnHide", function() d3t4:SetTexture("Interface\\AddOns\\rTextures\\bar2") end)
      MultiBarBottomLeft:HookScript("OnShow", function() d3t4:SetTexture("Interface\\AddOns\\rTextures\\bar2") end)
      MultiBarBottomLeft:HookScript("OnHide", function() d3t4:SetTexture("Interface\\AddOns\\rTextures\\bar1") end)
    end
  


  end