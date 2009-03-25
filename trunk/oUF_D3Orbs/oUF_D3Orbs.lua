
  -- oUF_D3Orbs layout by roth - 2008-2009
  -- http://www.wowinterface.com/downloads/info11314-oUF_D3Orbs.html
    
  ----------------
  -- CONFIG
  ---------------- 
  
  --font, set your font here
  local d3font = "FONTS\\FRIZQT__.ttf"
  
  -- do you only want the orbs?
  -- 1 = orbs only
  -- 0 = normal mode
  local orbsonly = 0

  -- healthcolor defines what healthcolor will be used
  -- 1 = red
  -- 2 = green
  -- 3 = blue
  -- 4 = yellow
  local healthcolor = 2

  -- manacolor defines what manacolor will be used
  -- 1 = red
  -- 2 = green
  -- 3 = blue
  -- 4 = yellow
  local manacolor = 1
  
  -- automatically color mana on class
  -- 0 = off
  -- 1 = on
  local color_mana_on_class = 1
  
  -- colors druid mana on stance
  -- 0 = off
  -- 1 = on
  local druid_mana_color = 1

  -- colorswitch will let you switch the health fore and background color
  -- 1 = foreground: red, background: grey
  -- 0 = foreground: grey, background: red
  local colorswitch = 0
  
  -- use_classcolor defines if units should use class/faction coloring
  -- this will remove animations from orbs!
  -- 0 = no
  -- 1 = yes
  local use_classcolor = 0
  
  -- hide party frames while in raid/battleground
  -- 1 = yes
  -- 0 = no
  local hidepartyinraid = 1
  
  -- myscale sets scaling of player orbs and actionbar background. range 0-1, 0.7 = 70%.  
  local myscale = 0.82
  
  -- target_scale sets scaling of target, target of target and castbars
  local target_scale = 0.82
  
  -- petscale scales pet,focus and party
  local pet_scale = 0.49
  
  --use 3D portraits or 2D portraits
  -- 0 = 2D
  -- 1 = 3D
  local use_3dportraits = 1
  
  -- usebar defines what actionbar texture will be used. 
  -- not really needed anymore, 36 texture will only be used if MultiBarRight is shown
  -- usebar = 1 -> 24 button texture
  -- usebar = 2 -> 36 button texture
  local usebar = 2  
  
  ----------------
  -- CONFIG END
  ----------------  
  
  -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
  --position deathknight runes
  RuneButtonIndividual1:ClearAllPoints()
  RuneButtonIndividual1:SetPoint("BOTTOM", UIParent, "BOTTOM", -55, 140)
 
  --------------------------------
  -- COLOR and POSITION-TABLES
  --------------------------------
  
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

  if color_mana_on_class == 1 then
    local _, pt = UnitClass("player")
    if pt == "WARRIOR" or pt == "DEATHKNIGHT" then
      manacolor = 1
    elseif pt == "ROGUE" then
      manacolor = 4
    else
      manacolor = 3
    end
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
  
  local dudustance
  
  local colors2 = {
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
      [2] = {r = 0, g = 0.3, b = .1}, -- green
      [3] = {r = 0, g = 0.2,   b = 0.3}, -- blue
      [4] = {r = 0.4, g = 0.3, b = 0}, -- yellow
    },
    orbpos = {
      [1] = {scale = 0.8, z = -12, x = 0.8, y = -1.7}, -- red
      [2] = {scale = 0.75, z = -12, x = 0, y = -1}, -- green
      [3] = {scale = 0.75, z = -12, x = 1.2, y = -1}, -- blue
      [4] = {scale = 0.75, z = -12, x = -0.3, y = -1.2}, -- yellow
    },
    frame_positions = {
      [1] =   { f = "PlayerPowerOrb",   a1 = "BOTTOM",  a2 = "BOTTOM",  af = "UIParent",          x = 260,    y = -8      },
      [2] =   { f = "PlayerHealthOrb",  a1 = "BOTTOM",  a2 = "BOTTOM",  af = "UIParent",          x = -260,   y = -8      },
      [3] =   { f = "Target",           a1 = "CENTER",  a2 = "CENTER",  af = "UIParent",          x = 0,      y = -200    },
      [4] =   { f = "ToT",              a1 = "RIGHT",   a2 = "LEFT",    af = "ouf_target",        x = -80,    y = 0       },
      [5] =   { f = "Pet",              a1 = "TOPLEFT",  a2 = "TOPLEFT",  af = "UIParent",          x = 30/(pet_scale),   y = -300/(pet_scale)      },
      [6] =   { f = "Focus",            a1 = "TOPLEFT",  a2 = "TOPLEFT",  af = "UIParent",          x = 30/(pet_scale),    y = -420/(pet_scale)      },
      [7] =   { f = "Party",            a1 = "TOPLEFT", a2 = "TOPLEFT", af = "UIParent",      x = 30,     y = 50     },
      [8] =   { f = "Angel",            a1 = "BOTTOM",  a2 = "BOTTOM",  af = "UIParent",          x = 325,    y = 0       },
      [9] =   { f = "Demon",            a1 = "BOTTOM",  a2 = "BOTTOM",  af = "UIParent",          x = -325,   y = 0       },
      [10] =  { f = "BottomLine",       a1 = "BOTTOM",  a2 = "BOTTOM",  af = "UIParent",          x = 0,      y = -3      },
      [11] =  { f = "BarTexture",       a1 = "BOTTOM",  a2 = "BOTTOM",  af = "UIParent",          x = 1,      y = 0       },
      [12] =  { f = "CastbarTarget",    a1 = "CENTER",  a2 = "CENTER",  af = "ouf_target",        x = 0,      y = 100     },
      [13] =  { f = "CastbarPlayer",    a1 = "CENTER",  a2 = "CENTER",  af = "ouf_target",        x = 0,      y = -80    },
      [14] =  { f = "CastbarTarget",    a1 = "CENTER",  a2 = "CENTER",  af = "ouf_target",        x = 0,      y = 180     },
    },
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
  
  ----------------------------------------
  -- druid mana coloring func
  ----------------------------------------
  
  local function check_druid_mana(a,b)

    --DEFAULT_CHAT_FRAME:AddMessage("ping")
    
    local st = GetShapeshiftForm()
    if st == 3 then
      manacolor = 4
      manafog = "SPELLS\\OrangeRadiationFog.m2"
    elseif st == 1 then
      manacolor = 1
      manafog = "SPELLS\\RedRadiationFog.m2"
    else 
      manacolor = 3
      manafog = "SPELLS\\BlueRadiationFog.m2"
    end
    
    if st ~= dudustance then
      b.Power.Filling:SetVertexColor(colors2.orbcolors[manacolor].r,colors2.orbcolors[manacolor].g,colors2.orbcolors[manacolor].b,1)
  
      b.pm3:SetModel(manafog)
      b.pm3:SetModelScale(colors2.orbpos[manacolor].scale)
      b.pm3:SetPosition(colors2.orbpos[manacolor].z, colors2.orbpos[manacolor].x, colors2.orbpos[manacolor].y) 
  
      b.pm4:SetModel(manafog)
      b.pm4:SetModelScale(colors2.orbpos[manacolor].scale)
      b.pm4:SetPosition(colors2.orbpos[manacolor].z, colors2.orbpos[manacolor].x, colors2.orbpos[manacolor].y+1) 
      
      dudustance = st
    end
    
  end
  
  UnitPopupMenus["SELF"] = { "PVP_FLAG", "LOOT_METHOD", "LOOT_THRESHOLD", "OPT_OUT_LOOT_TITLE", "LOOT_PROMOTE", "DUNGEON_DIFFICULTY", "RESET_INSTANCES", "RAID_TARGET_ICON", "LEAVE", "CANCEL" }
  UnitPopupMenus["PET"] = { "PET_PAPERDOLL", "PET_RENAME", "PET_ABANDON", "PET_DISMISS", "CANCEL" }
  UnitPopupMenus["PARTY"] = { "MUTE", "UNMUTE", "PARTY_SILENCE", "PARTY_UNSILENCE", "RAID_SILENCE", "RAID_UNSILENCE", "BATTLEGROUND_SILENCE", "BATTLEGROUND_UNSILENCE", "WHISPER", "PROMOTE", "LOOT_PROMOTE", "UNINVITE", "INSPECT", "ACHIEVEMENTS", "TRADE", "FOLLOW", "DUEL", "RAID_TARGET_ICON", "PVP_REPORT_AFK", "RAF_SUMMON", "RAF_GRANT_LEVEL", "CANCEL" }
  UnitPopupMenus["PLAYER"] = { "WHISPER", "INSPECT", "INVITE", "ACHIEVEMENTS", "TRADE", "FOLLOW", "DUEL", "RAID_TARGET_ICON", "RAF_SUMMON", "RAF_GRANT_LEVEL", "CANCEL" }
  UnitPopupMenus["RAID_PLAYER"] = { "MUTE", "UNMUTE", "RAID_SILENCE", "RAID_UNSILENCE", "BATTLEGROUND_SILENCE", "BATTLEGROUND_UNSILENCE", "WHISPER", "INSPECT", "ACHIEVEMENTS", "TRADE", "FOLLOW", "DUEL", "RAID_TARGET_ICON", "RAID_LEADER", "RAID_PROMOTE", "RAID_DEMOTE", "LOOT_PROMOTE", "RAID_REMOVE", "PVP_REPORT_AFK", "RAF_SUMMON", "RAF_GRANT_LEVEL", "CANCEL" }
  UnitPopupMenus["RAID"] = { "MUTE", "UNMUTE", "RAID_SILENCE", "RAID_UNSILENCE", "BATTLEGROUND_SILENCE", "BATTLEGROUND_UNSILENCE", "RAID_LEADER", "RAID_PROMOTE", "RAID_MAINTANK", "RAID_MAINASSIST", "LOOT_PROMOTE", "RAID_DEMOTE", "RAID_REMOVE", "PVP_REPORT_AFK", "CANCEL" }
  UnitPopupMenus["VEHICLE"] = { "RAID_TARGET_ICON", "VEHICLE_LEAVE", "CANCEL" }
  UnitPopupMenus["TARGET"] = { "RAID_TARGET_ICON", "CANCEL" }
  UnitPopupMenus["FOCUS"] = { "RAID_TARGET_ICON", "CANCEL" }
  
  ----------------
  -- SET FONT STRING
  ---------------- 
  
  local function SetFontString(parent, fontName, fontHeight, fontStyle)
    local fs = parent:CreateFontString(nil, "OVERLAY")
    fs:SetFont(fontName, fontHeight, fontStyle)
    fs:SetShadowColor(0,0,0,1)
    return fs
  end
  
  ----------------
  -- AURA ICON
  ---------------- 
  
  local function auraIcon(self, button, icons, index, debuff)
    icons.showDebuffType = false
    button.cd:SetReverse()
    button.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    button.count:SetPoint("BOTTOMRIGHT", button, 1, 0)
    button.count:SetTextColor(0.7,0.7,0.7)
    button:SetScript("OnMouseUp", function(self, mouseButton)
      if mouseButton == "RightButton" then
        local name, rank = UnitBuff("player", index)
        CancelUnitBuff("player", name, rank)
      end
    end)
  
    self.ButtonOverlay = button:CreateTexture(nil, "OVERLAY")
    self.ButtonOverlay:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\gloss2.tga")
    self.ButtonOverlay:SetVertexColor(0.37,0.3,0.3,1);
    self.ButtonOverlay:SetParent(button)
    self.ButtonOverlay:SetPoint("TOPLEFT", -1, 1)
    self.ButtonOverlay:SetPoint("BOTTOMRIGHT", 1, -1)
  
  end

  ----------------
  -- CLASS TEXT
  ---------------- 
  
  local function do_classtext(self,unit)
    
    local string = ""
    local tmpstring = ""
    local sp = " "

    if UnitLevel(unit) ~= -1 then
      string = UnitLevel(unit)
    else
      --string = (UnitLevel("player")+3)
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
    
    self.Classtext:SetText(string)

  end
  
  ----------------
  -- VALUE FORMAT
  ---------------- 
  
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
  
  ----------------
  -- UPDATE HEALTH
  ---------------- 
  
  local function updateHealth(self, event, unit, bar, min, max)
    
    local lifeact = UnitHealth(unit)
    local lifemax = UnitHealthMax(unit)
    
    local checkplayer = 0
    if UnitIsPlayer(unit) then
      checkplayer = 1
    end
    
    local c = max - min
    local d = floor(min/max*100)
    
    local newmin = do_format(min)
    local newmax = do_format(max)
    
    if d <= 25 and d > 0 and min > 1 then
      self.LowHP:Show()
    else
      self.LowHP:Hide()
    end
    
    if unit == "player" then
      if d == 0 or d == 100 or min == 1 then
        --bar.value:SetText("")
        --bar.value2:SetText("")
        bar.value:SetText(d)
        bar.value2:SetText(newmin)
      else
        bar.value:SetText(d)
        bar.value2:SetText(newmin)
      end
      
    elseif unit == "target" then
    
      if d == 0 or d == 100 or min == 1 then
        --bar.value:SetText("")
        bar.value:SetText(newmin.." - "..d.."%")
      else
        --bar.value:SetText(d)
        bar.value:SetText(newmin.." - "..d.."%")        
      end
    else
      if d == 0 or d == 100 or min == 1 then
        --bar.value:SetText("")
        bar.value:SetText(d.."%")
      else
        bar.value:SetText(d.."%")
      end    
      
      if unit == "player" or unit == "target" or unit == "targettarget" then
        --nothing
      else
        bar.value:SetText("")
      end
      
    end
    
    if unit == "target" then
      do_classtext(self,unit)
    end
    
    if unit == "player" then
      self.Health.Filling:SetHeight((lifeact / lifemax) * self.Health:GetWidth())
      self.Health.Filling:SetTexCoord(0,1,  math.abs(lifeact / lifemax - 1),1)
      if use_classcolor == 0 then
        self.pm1:SetAlpha((lifeact / lifemax))
        self.pm2:SetAlpha((lifeact / lifemax))
      else        
        local color = RAID_CLASS_COLORS[select(2, UnitClass(unit))]
        self.Health.Filling:SetVertexColor(color.r, color.g, color.b,1)
      end
    else
      
      --self.Health.bg:SetVertexColor(0.15,0.15,0.15,1)
      if colorswitch == 1 and use_classcolor ~= 1 then
         self.Health:SetStatusBarColor(1,0,0,1)
      else
        self.Health:SetStatusBarColor(0.15,0.15,0.15,0.9)
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
      
      local color
      
      if UnitIsPlayer(unit) then
        if RAID_CLASS_COLORS[select(2, UnitClass(unit))] then
          color = RAID_CLASS_COLORS[select(2, UnitClass(unit))]
        end
      elseif unit == "pet" and UnitExists("pet") and GetPetHappiness() then
        local happiness, _, _ = GetPetHappiness()
        color = colors2.happiness[happiness]
      else
        color = FACTION_BAR_COLORS[UnitReaction(unit, "player")]
      end

      if color then
        --self.Health.bg:SetVertexColor(color.r, color.g, color.b,1)
        if use_classcolor == 1 then
          self.Health.bg:SetVertexColor(color.r*0.7, color.g*0.7, color.b*0.7,1)
        else
          if colorswitch == 1 then
            self.Health.bg:SetVertexColor(0.15,0.15,0.15,1)
          else
            self.Health.bg:SetVertexColor(0.7,0,0,1)
          end
        end
        self.Name:SetTextColor(color.r, color.g, color.b,1)
      else
        --self.Health.bg:SetVertexColor(0,1,0,1)
        self.Health.bg:SetVertexColor(0.9, 0.8, 0, 1)
        self.Name:SetTextColor(0.9, 0.8, 0)
      end
      
      if d <= 25 and d > 0 and min > 1 then
        --self.Name:SetTextColor(0.7,0,0,1)
        self.Health.bg:SetVertexColor(0.7,0,0,1)
      end
      if min == 0 then
        --self.Health.bg:SetVertexColor(0.15,0.15,0.15,0.5)
      end
      
    end
    
  end
  
  ----------------
  -- UPDATE POWER
  ---------------- 
  
  local function updatePower(self, event, unit, bar, min, max)

    local c, d
    
    if max == 0 then
      d = 0
    else
      c = max - min
      d = floor(min/max*100)
    end
    
    local newmin = do_format(min)
    local newmax = do_format(max)
    local _, class = UnitClass("player")
    local shape = GetShapeshiftForm()      
    
    if unit == "player" then
      if class == "WARRIOR" or (class == "DRUID" and shape == 3) or (class == "DRUID" and shape == 1) or class == "DEATHKNIGHT" or class == "ROGUE" then
        bar.value:SetText(newmin)
        bar.value2:SetText(d)
      else
        bar.value:SetText(d)
        bar.value2:SetText(newmin)
      end
    end

    local manaact = UnitMana(unit)
    local manamax = UnitManaMax(unit)
    if (manamax == 0) then
      if unit == "player" then
        self.Power.Filling:SetHeight(0)
        self.Power.Filling:SetTexCoord(0,1,1,1)
        if use_classcolor == 0 then
          self.pm3:SetAlpha(0)
          self.pm4:SetAlpha(0)
        end
      else
        --local color = colors2.power[UnitPowerType(unit)]
        --local powerType, powerTypeString = UnitPowerType(unit);
        local color = colors2.power[UnitPowerType(unit)]
        bar:SetStatusBarColor(color.r, color.g, color.b)
        bar.bg:SetVertexColor(color.r, color.g, color.b,0.3)
      end
    else
      if unit == "player" then
        self.Power.Filling:SetHeight((manaact / manamax) * self.Power:GetWidth())
        self.Power.Filling:SetTexCoord(0,1,  math.abs(manaact / manamax - 1),1)
        if use_classcolor == 0 then
          self.Power.Filling:SetVertexColor(colors2.orbcolors[manacolor].r,colors2.orbcolors[manacolor].g,colors2.orbcolors[manacolor].b,1)
          self.pm3:SetAlpha((manaact / manamax))
          self.pm4:SetAlpha((manaact / manamax))
        else        
          local color = colors2.power[UnitPowerType(unit)]
          self.Power.Filling:SetVertexColor(color.r, color.g, color.b,1)
        end
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
    
    local orbsize = 150
    if unit == "player" then
      self:SetHeight(orbsize)
      self:SetWidth(orbsize)
    elseif unit == "target" then
      self:SetHeight(20)
      self:SetWidth(224)
    elseif unit == "targettarget" then
      self:SetHeight(20)
      self:SetWidth(110)    
    else
      self:SetHeight(200)
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
    elseif unit == "target" or unit == "targettarget" then
      self.Health = CreateFrame("StatusBar", nil, self)
      self.Health:SetStatusBarTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\statusbar.tga")
      self.Health:SetHeight(16)
      self.Health:SetWidth(self:GetWidth())
      self.Health:SetPoint("TOPLEFT",0,-1)
    else
      self.Health = CreateFrame("StatusBar", nil, self)
      self.Health:SetStatusBarTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\statusbar.tga")
      self.Health:SetHeight(16)
      self.Health:SetWidth(self:GetWidth())
      self.Health:SetPoint("BOTTOMLEFT",0,1)
    end
    
    ----------------
    -- SMOOTH HEALTH
    ----------------
    
    self.Health.Smooth = true
    
    ----------------------
    -- HEALTH BACKGROUND
    ----------------------
    
    if unit == "player" then
      self.Health.bg = self.Health:CreateTexture(nil, "BACKGROUND")
      self.Health.bg:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\orb_back2.tga")
      self.Health.bg:SetAllPoints(self.Health)
      self.Health.Filling = self.Health:CreateTexture(nil, "ARTWORK")
      self.Health.Filling:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\orb_filling4.tga")
      self.Health.Filling:SetPoint("BOTTOMLEFT",0,0)
      self.Health.Filling:SetWidth(orbsize)
      self.Health.Filling:SetHeight(orbsize)

      if use_classcolor == 0 then

        self.Health.Filling:SetVertexColor(colors2.orbcolors[healthcolor].r,colors2.orbcolors[healthcolor].g,colors2.orbcolors[healthcolor].b,1)
        
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
        
      else
        --test     
      end
      
      self.HealthGlossHolder = CreateFrame("Frame", nil, self.Health)
      self.HealthGlossHolder:SetAllPoints(self.Health)
      self.HealthGlossHolder:SetFrameStrata("LOW")
      self.HealthOrbGloss = self.HealthGlossHolder:CreateTexture(nil, "OVERLAY")
      self.HealthOrbGloss:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\orb_gloss.tga")
      self.HealthOrbGloss:SetAllPoints(self.HealthGlossHolder)
      
      
    elseif unit == "target" then
      self.bg = self:CreateTexture(nil, "BACKGROUND")
      self.bg:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\d3_targetframe.tga")
      self.bg:SetWidth(512)
      self.bg:SetHeight(128)
      self.bg:SetPoint("CENTER",-3,0)
      self.Health.bg = self.Health:CreateTexture(nil, "BACKGROUND")
      self.Health.bg:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\statusbar.tga")
      self.Health.bg:SetAllPoints(self.Health)    
    elseif unit == "targettarget" then
      self.bg = self:CreateTexture(nil, "BACKGROUND")
      self.bg:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\d3totframe.tga")
      self.bg:SetWidth(256)
      self.bg:SetHeight(128)
      self.bg:SetPoint("CENTER",-2,0)
      self.Health.bg = self.Health:CreateTexture(nil, "BACKGROUND")
      self.Health.bg:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\statusbar.tga")
      self.Health.bg:SetAllPoints(self.Health)
    else
      self.bg = self:CreateTexture(nil, "BACKGROUND")
      self.bg:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\d3totframe.tga")
      self.bg:SetWidth(256)
      self.bg:SetHeight(128)
      self.bg:SetPoint("BOTTOM",-2,-56)
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
      --self.Power:SetPoint("BOTTOM", UIParent, "BOTTOM", 250, -8)
      self.Power:SetPoint(colors2.frame_positions[1].a1, colors2.frame_positions[1].af, colors2.frame_positions[1].a2, colors2.frame_positions[1].x, colors2.frame_positions[1].y)
      self.Power.frequentUpdates = true
      self.Power.bg = self.Power:CreateTexture(nil, "BACKGROUND")
      self.Power.bg:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\orb_back2.tga")
      self.Power.bg:SetAllPoints(self.Power)
      self.Power.Filling = self.Power:CreateTexture(nil, "ARTWORK")
      self.Power.Filling:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\orb_filling4.tga")
      self.Power.Filling:SetPoint("BOTTOMLEFT",0,0)
      self.Power.Filling:SetWidth(orbsize)
      self.Power.Filling:SetHeight(orbsize)
      
      if use_classcolor == 0 then
      
        self.Power.Filling:SetVertexColor(colors2.orbcolors[manacolor].r,colors2.orbcolors[manacolor].g,colors2.orbcolors[manacolor].b,1)

        self.pm3 = CreateFrame("PlayerModel",nil,self.Power)
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
        
        self.pm4 = CreateFrame("PlayerModel",nil,self.Power)
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
      
      end
      
      self.PowerGlossHolder = CreateFrame("Frame", nil, self.Power)
      self.PowerGlossHolder:SetAllPoints(self.Power)
      self.PowerGlossHolder:SetFrameStrata("LOW")
      self.PowerOrbGloss = self.PowerGlossHolder:CreateTexture(nil, "OVERLAY")
      self.PowerOrbGloss:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\orb_gloss.tga")
      self.PowerOrbGloss:SetAllPoints(self.PowerGlossHolder)
      
      
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
    -- SMOOTH POWER
    ----------------

    self.Power.Smooth = true

    ----------------
    -- CASTBAR
    ----------------
    if orbsonly ~= 1 then
      if unit == "player" or unit == "target" or unit == "focus" then
        self.Castbar = CreateFrame("StatusBar", nil, UIParent)
        self.Castbar:SetFrameStrata("DIALOG")
        self.Castbar:SetWidth(224)
        self.Castbar:SetHeight(18)
        self.Castbar:SetStatusBarTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\statusbar.tga")
  
        self.Castbar.bg2 = self.Castbar:CreateTexture(nil, "BACKGROUND")
        self.Castbar.bg2:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\d3_targetframe.tga")
        self.Castbar.bg2:SetWidth(512)
        self.Castbar.bg2:SetHeight(128)
        self.Castbar.bg2:SetPoint("CENTER",-3,0)
  
        self.Castbar.bg = self.Castbar:CreateTexture(nil, "BORDER")
        self.Castbar.bg:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\statusbar.tga")
        self.Castbar.bg:SetAllPoints(self.Castbar)
        --self.Castbar.bg:SetVertexColor(0.15,0.15,0.15,1)
        if colorswitch == 1 then
          self.Castbar.bg:SetVertexColor(0.15,0.15,0.15,1)
          self.Castbar:SetStatusBarColor(180/255,110/255,30/255,1)      
        else 
          self.Castbar.bg:SetVertexColor(180/255,110/255,30/255,1)
          self.Castbar:SetStatusBarColor(0.15,0.15,0.15,0.9)
        end
  
        if unit == "player" then
          --self.Castbar:SetPoint("CENTER",UIParent,"CENTER",0,-275)
          self.Castbar:SetPoint(colors2.frame_positions[13].a1, colors2.frame_positions[13].af, colors2.frame_positions[13].a2, colors2.frame_positions[13].x, colors2.frame_positions[13].y)
          --self.Castbar:SetStatusBarColor(180/255,110/255,30/255,1)
        elseif unit == "target" then
          --self.Castbar:SetPoint("CENTER",UIParent,"CENTER",0,-110)
          self.Castbar:SetPoint(colors2.frame_positions[12].a1, colors2.frame_positions[12].af, colors2.frame_positions[12].a2, colors2.frame_positions[12].x, colors2.frame_positions[12].y)
          --self.Castbar:SetStatusBarColor(160/255,20/255,140/255,1)
        elseif unit == "focus" then
          self.Castbar:SetPoint(colors2.frame_positions[14].a1, colors2.frame_positions[14].af, colors2.frame_positions[14].a2, colors2.frame_positions[14].x, colors2.frame_positions[14].y)
        end
        
        self.Castbar.Text = SetFontString(self.Castbar, d3font, 14, "THINOUTLINE")
        self.Castbar.Text:SetPoint("LEFT", 2, 0)
        
        --self.Castbar.Time = SetFontString(self.Castbar, d3font, 14, "THINOUTLINE")
        --self.Castbar.Time:SetPoint("RIGHT", -2, 0)
        
        self.Castbar:Hide()
        self.Castbar:SetScale(target_scale)
        Castbar = self.Castbar
        
      end
    end
    
    ---------------------
    -- NAMES and VALUES
    ---------------------
    
    if unit == "player" then
      self.HealthValueHolder = CreateFrame("FRAME", nil, self.Health)
      self.HealthValueHolder:SetFrameStrata("LOW")
      self.HealthValueHolder:SetAllPoints(self.Health)
      self.Health.value = SetFontString(self.HealthValueHolder, d3font, 28, "THINOUTLINE")
      self.Health.value:SetPoint("CENTER", 0, 10)
      self.Health.value2 = SetFontString(self.HealthValueHolder, d3font, 16, "THINOUTLINE")
      self.Health.value2:SetPoint("CENTER", 0, -10)
      self.Health.value2:SetTextColor(0.6,0.6,0.6)
      self.PowerValueHolder = CreateFrame("FRAME", nil, self.Power)
      self.PowerValueHolder:SetFrameStrata("LOW")
      self.PowerValueHolder:SetAllPoints(self.Power)
      self.Power.value = SetFontString(self.PowerValueHolder, d3font, 28, "THINOUTLINE")
      self.Power.value:SetPoint("CENTER", 0, 10)
      self.Power.value2 = SetFontString(self.PowerValueHolder, d3font, 16, "THINOUTLINE")
      self.Power.value2:SetPoint("CENTER", 0, -10)
      self.Power.value2:SetTextColor(0.6,0.6,0.6)
    elseif unit == "target" then
      self.Name = SetFontString(self, d3font, 20, "THINOUTLINE")
      self.Name:SetPoint("BOTTOM", self, "TOP", 0, 30)
      self.Health.value = SetFontString(self.Health, d3font, 14, "THINOUTLINE")
      self.Health.value:SetPoint("RIGHT", self, "RIGHT", -2, 2)
      self.Classtext = SetFontString(self, d3font, 16, "THINOUTLINE")
      self.Classtext:SetPoint("BOTTOM", self, "TOP", 0, 13)
    else
      self.Name = SetFontString(self, d3font, 18, "THINOUTLINE")
      self.Name:SetPoint("BOTTOM", self, "TOP", 0, 15)
      self.Name:SetTextColor(0.9, 0.8, 0)
      self.Health.value = SetFontString(self.Health, d3font, 14, "THINOUTLINE")
      self.Health.value:SetPoint("RIGHT", self, "RIGHT", -2, 2)
    end
        
    ---------------------
    -- PVP ICON
    ---------------------
    
    --[[
    if unit == "player" then
      self.PvP = self.Health:CreateTexture(self:GetName().."PVPIcon", "OVERLAY", self)
      self.PvP:SetHeight(64)
      self.PvP:SetWidth(64)
      self.PvP:SetPoint("CENTER", self, "CENTER", -50, 50)
    elseif unit == "target" then
      self.PvP = self.Health:CreateTexture(self:GetName().."PVPIcon", "OVERLAY", self)
      self.PvP:SetHeight(40)
      self.PvP:SetWidth(40)
      self.PvP:SetPoint("LEFT", self, "LEFT", -30, -10)    
    end
    ]]--
    
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
      --self.Debuffs:SetPoint("TOP", self, "BOTTOM", 0, -15)
      self.Debuffs:SetPoint("LEFT", self, "RIGHT", 20, -25)
      self.Debuffs.initialAnchor = "TOPLEFT"
      self.Debuffs["growth-y"] = "DOWN"
      self.Debuffs.showDebuffType = true
      self.Debuffs.size = math.floor(self.Debuffs:GetHeight())
      self.Debuffs.num = 40
    elseif unit == "targettarget" then
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
    else
      self.Debuffs = CreateFrame("Frame", nil, self)
      self.Debuffs.spacing = 4
      self.Debuffs:SetHeight(24)
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
      --self.Buffs:SetPoint("BOTTOM", self, "TOP", 0, 55)
      self.Buffs:SetPoint("LEFT", self, "RIGHT", 20, 25)
      self.Buffs.initialAnchor = "TOPLEFT"
      self.Buffs["growth-y"] = "UP"
      self.Buffs.size = math.floor(self.Buffs:GetHeight())
      self.Buffs.num = 40
    else
      -- nothing
    end


    ---------------------
    -- Debuff Highlight
    ---------------------    

    if unit == "player" then
      self.DebuffHighlight = self:CreateTexture(nil, "BACKGROUND")
      --self.DebuffHighlight:SetAllPoints(self)
      self.DebuffHighlight:SetWidth(self:GetWidth())
      self.DebuffHighlight:SetHeight(self:GetWidth())
      self.DebuffHighlight:SetPoint("CENTER",0,0)
      self.DebuffHighlight:SetBlendMode("BLEND")
      self.DebuffHighlight:SetVertexColor(1, 0, 0, 0) -- set alpha to 0 to hide the texture
      self.DebuffHighlightAlpha = 0.5
      self.DebuffHighlightFilter = false
      self.DebuffHighlight:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\orb_debuff_glow.tga")
    elseif unit == "target" then
      --big mama
    elseif unit == "targettarget" then
      self.DebuffHighlight = self:CreateTexture(nil, "OVERLAY")
      self.DebuffHighlight:SetWidth(250)
      self.DebuffHighlight:SetHeight(115)
      self.DebuffHighlight:SetPoint("CENTER",-2,0)
      self.DebuffHighlight:SetBlendMode("BLEND")
      self.DebuffHighlight:SetVertexColor(1, 0, 0, 0) -- set alpha to 0 to hide the texture
      self.DebuffHighlightAlpha = 0.4
      self.DebuffHighlightFilter = true
      self.DebuffHighlight:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\d3totframe_debuff.tga")
    else
      self.DebuffHighlight = self:CreateTexture(nil, "OVERLAY")
      self.DebuffHighlight:SetWidth(250)
      self.DebuffHighlight:SetHeight(115)
      self.DebuffHighlight:SetPoint("BOTTOM",-2,-50)
      self.DebuffHighlight:SetBlendMode("BLEND")
      self.DebuffHighlight:SetVertexColor(1, 0, 0, 0) -- set alpha to 0 to hide the texture
      self.DebuffHighlightAlpha = 0.4
      self.DebuffHighlightFilter = true
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
    

    
    ---------------------
    -- Raid Icon
    ---------------------  
    
    if unit == "player" then
      --nothing   
    elseif unit == "target" then
      self.RaidIcon = self:CreateTexture(nil, "OVERLAY")
      self.RaidIcon:SetHeight(24)
      self.RaidIcon:SetWidth(24)
      self.RaidIcon:SetPoint("RIGHT", self.Name, "LEFT", -5, 2)
      self.RaidIcon:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
    else
      self.RaidIcon = self:CreateTexture(nil, "OVERLAY")
      self.RaidIcon:SetHeight(16)
      self.RaidIcon:SetWidth(16)
      self.RaidIcon:SetPoint("RIGHT", self.Name, "LEFT", -2, 2)
      self.RaidIcon:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
    end

    ---------------------
    -- Leader Icon
    ---------------------  
    
    if unit == "player" then
      self.Leader = self:CreateTexture(nil, "OVERLAY")
      self.Leader:SetHeight(16)
      self.Leader:SetWidth(16)
      self.Leader:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
      self.Leader:SetTexture("Interface\\GroupFrame\\UI-Group-LeaderIcon")    
    elseif unit == "target" or unit == "targettarget" then 
      -- nothing
    else
      self.Leader = self:CreateTexture(nil, "OVERLAY")
      self.Leader:SetHeight(24)
      self.Leader:SetWidth(24)
      self.Leader:SetPoint("RIGHT", self.Health, "LEFT", -22, 22)
      self.Leader:SetTexture("Interface\\GroupFrame\\UI-Group-LeaderIcon")      
    end
    
    ---------------------
    -- Portrait
    --------------------- 
    
    if unit == "player" or unit == "target" or unit == "targettarget" then
      --nothing
    else
    
      self.Portrait_bgf = CreateFrame("Frame",nil,self)
      self.Portrait_bgf:SetPoint("BOTTOM",self.Health,"TOP",0,14)
      self.Portrait_bgf:SetWidth(self:GetWidth()+10)
      self.Portrait_bgf:SetHeight(self:GetWidth()+10)  
      
      self.Portrait_bgt = self.Portrait_bgf:CreateTexture(nil, "BACKGROUND")
      self.Portrait_bgt:SetAllPoints(self.Portrait_bgf)
      self.Portrait_bgt:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\d3portrait_back2.tga")
      self.Portrait_bgt:SetVertexColor(0.7,0.7,0.7)
    
      if use_3dportraits == 1 and unit ~= "focustarget" then
        self.Portrait = CreateFrame("PlayerModel", nil, self.Portrait_bgf)
        self.Portrait:SetPoint("TOPLEFT",self.Portrait_bgf,"TOPLEFT",4,-4)
        self.Portrait:SetPoint("BOTTOMRIGHT",self.Portrait_bgf,"BOTTOMRIGHT",-4,4)
  
        self.Portrait_glossf = CreateFrame("Frame",nil,self.Portrait)
        self.Portrait_glossf:SetAllPoints(self.Portrait_bgf)
      else
        self.Portrait = self.Portrait_bgf:CreateTexture(nil, "BORDER")
        self.Portrait:SetPoint("TOPLEFT",self.Portrait_bgf,"TOPLEFT",0,-0)
        self.Portrait:SetPoint("BOTTOMRIGHT",self.Portrait_bgf,"BOTTOMRIGHT",-0,0)
  
        self.Portrait_glossf = CreateFrame("Frame",nil,self.Portrait_bgf)
        self.Portrait_glossf:SetAllPoints(self.Portrait_bgf)
      end

      self.Portrait_glosst = self.Portrait_glossf:CreateTexture(nil, "ARTWORK")
      self.Portrait_glosst:SetAllPoints(self.Portrait_glossf)
      --self.Portrait_glosst:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\gloss.tga")
      --self.Portrait_glosst:SetTexture("Interface\\AddOns\\rTextures\\simplesquare_roth2")
      self.Portrait_glosst:SetTexture("Interface\\AddOns\\rTextures\\simplesquare_roth")
      self.Portrait_glosst:SetVertexColor(0.37,0.3,0.3)

      self.Name:SetPoint("BOTTOM", self.Portrait_bgf, "TOP", 0, 5)
      self.Name:SetFont(d3font,22,"THINOUTLINE")
      
    end
    
    
    ---------------------
    -- Combo Points
    ---------------------      
    
    if unit == "target" then
      self.CPoints = SetFontString(self.Health, d3font, 24, "THINOUTLINE")
      self.CPoints:SetPoint("LEFT", self.Name, "RIGHT", 5, -1)
      self.CPoints:SetTextColor(1, .5, 0)
      self.CPoints.unit = "player"
    end
    
    
    ---------------------
    -- SCALING
    ---------------------  
    
    --if unit ~= "player" and unit ~= "target" then
    if unit == "player" then
      self:SetScale(myscale)
    elseif unit == "target" or unit == "targettarget" then
      self:SetScale(target_scale)
    else
      self:SetScale(pet_scale)
    end
    
    ---------------------------------
    -- DRUID MANA COLORING (NEW!)
    ---------------------------------
    
    if unit == "player" and class == "DRUID" and druid_mana_color == 1 and use_classcolor == 0 then
      self.Power:RegisterEvent("PLAYER_ENTERING_WORLD")
      self.Power:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
      self.Power:SetScript("OnEvent", function()
        check_druid_mana(self.Power,self)        
      end)
    end    
    
    ---------------------
    -- OTHERS
    ---------------------    
    
    self.outsideRangeAlpha = 0.4
    self.inRangeAlpha = 1
    self.Range = false
      
    self.PostUpdateHealth = updateHealth
    self.PostUpdatePower = updatePower
    self.PostCreateAuraIcon = auraIcon
    self.UNIT_NAME_UPDATE = updateName
    self.UNIT_HAPPINESS = updateName
    self.PLAYER_TARGET_CHANGED = updateTarget
  
    return self

  end

  -------------------------------------------------------
  -- REGISTER STYLE, CALL STYLEFUNC
  -------------------------------------------------------
  
  actstyle = "d3orb"
  --oUF:RegisterSubTypeMapping("UNIT_LEVEL")
  oUF:RegisterStyle(actstyle, styleFunc1)
  oUF:SetActiveStyle(actstyle)
  
  -------------------------------------------------------
  -- SPAWN UNITS and POSITION THEM
  -------------------------------------------------------

  if orbsonly ~= 1 then
    oUF:Spawn("target","ouf_target"):SetPoint(colors2.frame_positions[3].a1, colors2.frame_positions[3].af, colors2.frame_positions[3].a2, colors2.frame_positions[3].x, colors2.frame_positions[3].y)  
    oUF:Spawn("player","ouf_player"):SetPoint(colors2.frame_positions[2].a1, colors2.frame_positions[2].af, colors2.frame_positions[2].a2, colors2.frame_positions[2].x, colors2.frame_positions[2].y)
    oUF:Spawn("targettarget","ouf_tot"):SetPoint(colors2.frame_positions[4].a1, colors2.frame_positions[4].af, colors2.frame_positions[4].a2, colors2.frame_positions[4].x, colors2.frame_positions[4].y)
    oUF:Spawn("pet","ouf_pet"):SetPoint(colors2.frame_positions[5].a1, colors2.frame_positions[5].af, colors2.frame_positions[5].a2, colors2.frame_positions[5].x, colors2.frame_positions[5].y)
    oUF:Spawn("focus","ouf_focus"):SetPoint(colors2.frame_positions[6].a1, colors2.frame_positions[6].af, colors2.frame_positions[6].a2, colors2.frame_positions[6].x, colors2.frame_positions[6].y)
    oUF:Spawn('focustarget'):SetPoint('CENTER', oUF.units.focus, 'CENTER', 180, 0)
  else
    oUF:Spawn("player","ouf_player"):SetPoint(colors2.frame_positions[2].a1, colors2.frame_positions[2].af, colors2.frame_positions[2].a2, colors2.frame_positions[2].x, colors2.frame_positions[2].y)
  end
  
  -------------------------------------------------------
  -- SPAWN PARTY and POSITION IT
  -------------------------------------------------------
  
  local party, partytoggle
  
  if orbsonly ~= 1 then
    party  = oUF:Spawn("header", "oUF_Party")
    party:SetPoint(colors2.frame_positions[7].a1, colors2.frame_positions[7].af, colors2.frame_positions[7].a2, colors2.frame_positions[7].x, colors2.frame_positions[7].y)
    --party:SetManyAttributes("showParty", true, "xOffset", 10, "point", "RIGHT", "showPlayer", false)
    party:SetManyAttributes("showParty", true, "xOffset", 80, "point", "LEFT")
  end
  
  -------------------------------------------------------
  -- TOGGLE PARTY IN RAID (CURRENTLY NO)
  -------------------------------------------------------
  
  if orbsonly ~= 1 then
    partyToggle = CreateFrame("Frame")
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
          --activate this to hide party in raid
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
  end

  -----------------------------
  -- CREATING D3 ART FRAMES
  -----------------------------

  local d3f = CreateFrame("Frame",nil,UIParent)
  d3f:SetFrameStrata("TOOLTIP")
  d3f:SetWidth(155)
  d3f:SetHeight(155)
  d3f:SetPoint(colors2.frame_positions[8].a1, colors2.frame_positions[8].af, colors2.frame_positions[8].a2, colors2.frame_positions[8].x, colors2.frame_positions[8].y)
  d3f:Show()
  d3f:SetScale(myscale)
  local d3t = d3f:CreateTexture(nil,"BACKGROUND")
  d3t:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\d3_angel")
  d3t:SetAllPoints(d3f)

  local d3f2 = CreateFrame("Frame",nil,UIParent)
  d3f2:SetFrameStrata("TOOLTIP")
  d3f2:SetWidth(155)
  d3f2:SetHeight(155)
  d3f2:SetPoint(colors2.frame_positions[9].a1, colors2.frame_positions[9].af, colors2.frame_positions[9].a2, colors2.frame_positions[9].x, colors2.frame_positions[9].y)
  d3f2:Show()
  d3f2:SetScale(myscale)
  local d3t2 = d3f2:CreateTexture(nil,"BACKGROUND")
  d3t2:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\d3_demon")
  d3t2:SetAllPoints(d3f2)
  
  local d3f3 = CreateFrame("Frame",nil,UIParent)
  d3f3:SetFrameStrata("TOOLTIP")
  d3f3:SetWidth(500)
  d3f3:SetHeight(112)
  d3f3:SetPoint(colors2.frame_positions[10].a1, colors2.frame_positions[10].af, colors2.frame_positions[10].a2, colors2.frame_positions[10].x, colors2.frame_positions[10].y)
  d3f3:Show()
  d3f3:SetScale(myscale)
  local d3t3 = d3f3:CreateTexture(nil,"BACKGROUND")
  d3t3:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\d3_bottom")
  d3t3:SetAllPoints(d3f3)
  
  local d3f4 = CreateFrame("Frame",nil,UIParent)
  d3f4:SetFrameStrata("BACKGROUND")
  d3f4:SetWidth(512)
  d3f4:SetHeight(256)
  d3f4:SetPoint(colors2.frame_positions[11].a1, colors2.frame_positions[11].af, colors2.frame_positions[11].a2, colors2.frame_positions[11].x, colors2.frame_positions[11].y)
  d3f4:Show()
  d3f4:SetScale(myscale)
  local d3t4 = d3f4:CreateTexture(nil,"BACKGROUND")
  d3t4:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\d3_bar6")
  d3t4:SetAllPoints(d3f4)
  
  if usebar ~= 1 then
    if MultiBarBottomRight:IsShown() then
      d3t4:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\d3_bar5")
    end
    MultiBarBottomRight:HookScript("OnShow", function() d3t4:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\d3_bar5") end)
    MultiBarBottomRight:HookScript("OnHide", function() d3t4:SetTexture("Interface\\AddOns\\oUF_D3Orbs\\textures\\d3_bar6") end)
  end