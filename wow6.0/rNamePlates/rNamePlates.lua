
  -- // rNamePlates
  -- // zork - 2014

  -----------------------------
  -- CONFIG
  -----------------------------

  local cfg = {}
  cfg.scale                   = 0.35
  cfg.font                    = STANDARD_TEXT_FONT
  cfg.fontsize_healthbar      = 26
  cfg.fontsize_castbar        = 26
  cfg.fontsize_aurastack      = 24
  cfg.fontsize_auracooldown   = 28
  cfg.setpoint_adjust         = {"CENTER",0,-16}
  cfg.alpha_nofocus           = 0.5

  -----------------------------
  -- VARIABLES
  -----------------------------

  local an, at = ...
  local plates, namePlateIndex, _G, string, WorldFrame, unpack, math, wipe, mod = {}, nil, _G, string, WorldFrame, unpack, math, wipe, mod

  local NUM_MAX_AURAS = 40

  local unitDB                = {}  --unit table by guid
  local spellDB                     --aura table by spellid
  local playerGUID            = nil
  local petGUID               = nil
  local updateTarget          = false
  local hasTarget             = false
  local updateMouseover       = false

  local CLEU_FILTERS = {
    ["SPELL_AURA_APPLIED"]      = 1, --UpdateAura
    ["SPELL_AURA_REFRESH"]      = 1, --UpdateAura
    ["SPELL_AURA_APPLIED_DOSE"] = 1, --UpdateAura
    ["SPELL_AURA_REMOVED_DOSE"] = 1, --UpdateAura
    ["SPELL_AURA_STOLEN"]       = 0, --RemoveAura
    ["SPELL_AURA_REMOVED"]      = 0, --RemoveAura
    ["SPELL_AURA_BROKEN"]       = 0, --RemoveAura
    ["SPELL_AURA_BROKEN_SPELL"] = 0, --RemoveAura
  }

  local targetPlateCounter = 0
  local targetPlate = nil
  local delayCounter = 0
  local worldFrameTimer = 0.0
  local updateInterval = 0.1

  local trash = CreateFrame("Frame")
  trash:Hide()

  local AuraModule = CreateFrame("Frame")

  local RAID_CLASS_COLORS = RAID_CLASS_COLORS
  local FACTION_BAR_COLORS = FACTION_BAR_COLORS

  -----------------------------
  -- FUNCTIONS
  -----------------------------

  local function GetHexColorFromRGB(r, g, b)
    return string.format("%02x%02x%02x", r*255, g*255, b*255)
  end

  local function GetFormattedTime(time)
    if time <= 0 then
      return ""
    elseif time < 2 then
      return (math.floor(time*10)/10)
    elseif time < 60 then
      return string.format("%ds", mod(time, 60))
    elseif time < 3600 then
      return string.format("%dm", math.floor(mod(time, 3600) / 60 + 1))
    else
      return string.format("%dh", math.floor(time / 3600 + 1))
    end
  end

  local function RoundNumber(n)
    return (math.floor(n*100+0.5)/100)
  end

  local function NamePlateSetup(self)

    self.castBar.borderTexture:SetTexture(nil)
    self.borderTexture:SetTexture(nil)
    self.bossIconTexture:SetTexture(nil)
    self.eliteDragonTexture:SetTexture(nil)
    self.highlightTexture:SetTexture(nil)
    self.threatTexture:SetTexture(nil)

    local name = self.nameString:GetText() or "Unknown"
    local level = self.levelString:GetText() or "-1"
    local hexColor = GetHexColorFromRGB(self.levelString:GetTextColor()) or "ffffff"

    if self.bossIconTexture:IsShown() then
      level = "??"
      hexColor = "ff6600"
    elseif self.eliteDragonTexture:IsShown() then
      level = level.."+"
    end
    self.newPlate.healthBar.name:SetText("|cff"..hexColor..""..level.."|r "..name)
  end

  local function NamePlateSetReferences(self)
    self.barFrame, self.nameFrame = self:GetChildren()
    self.healthBar, self.castBar = self.barFrame:GetChildren()
    self.threatTexture, self.borderTexture, self.highlightTexture, self.levelString, self.bossIconTexture, self.raidIconTexture, self.eliteDragonTexture = self.barFrame:GetRegions()
    self.nameString = self.nameFrame:GetRegions()
    self.healthBar.statusbarTexture = self.healthBar:GetRegions()
    self.castBar.statusbarTexture, self.castBar.borderTexture, self.castBar.shieldTexture, self.castBar.spellIconTexture, self.castBar.nameString, self.castBar.nameShadow = self.castBar:GetRegions()
    self.nameFrame:SetParent(trash)
    self.levelString:SetParent(trash)
    self.healthBar.__owner = self
    self.castBar.__owner = self
    self.healthBar:SetParent(trash)
    self.castBar:SetParent(trash)
  end

  local function NamePlateSkinHealthBar(self)

    local bar = CreateFrame("StatusBar",nil,self.newPlate)
    bar:SetSize(256,64)
    bar:SetStatusBarTexture("Interface\\AddOns\\"..an.."\\media\\statusbar_fill")
    bar:SetScale(cfg.scale)
    bar:SetPoint(unpack(cfg.setpoint_adjust))

    local le = bar:CreateTexture(nil,"BACKGROUND",nil,-8)
    le:SetTexture("Interface\\AddOns\\"..an.."\\media\\edge_left")
    le:SetSize(64,64)
    le:SetPoint("RIGHT",bar,"LEFT",0,0)

    local re = bar:CreateTexture(nil,"BACKGROUND",nil,-8)
    re:SetTexture("Interface\\AddOns\\"..an.."\\media\\edge_right")
    re:SetSize(64,64)
    re:SetPoint("LEFT",bar,"RIGHT",0,0)

    local bg = bar:CreateTexture(nil,"BACKGROUND",nil,-8)
    bg:SetTexture("Interface\\AddOns\\"..an.."\\media\\statusbar_bg")
    bg:SetAllPoints()

    local shadow = bar:CreateTexture(nil,"BACKGROUND",nil,-8)
    shadow:SetTexture("Interface\\Common\\NameShadow")
    shadow:SetPoint("BOTTOM",bar,"TOP",0,-20)
    shadow:SetSize(256,32)
    shadow:SetTexCoord(1,1,1,0,0,1,0,0)
    shadow:SetAlpha(0.5)

    local hlf = CreateFrame("Frame",nil,bar)
    hlf:SetAllPoints()
    bar.hlf = hlf

    local hl = hlf:CreateTexture(nil,"BACKGROUND",nil,-8)
    hl:SetTexture("Interface\\AddOns\\"..an.."\\media\\statusbar_highlight")
    hl:SetAllPoints()

    local name = bar.hlf:CreateFontString(nil, "BORDER")
    name:SetFont(cfg.font, cfg.fontsize_healthbar, "OUTLINE")
    name:SetPoint("BOTTOM",bar,"TOP",0,-24)
    name:SetPoint("LEFT",8,0)
    name:SetPoint("RIGHT",-8,0)
    name:SetText("Ich bin ein Berliner!")
    bar.name = name

    self.raidIconTexture:SetParent(bar)
    self.raidIconTexture:SetSize(60,60)
    self.raidIconTexture:ClearAllPoints()
    self.raidIconTexture:SetPoint("BOTTOM",bar,"TOP",0,40)

    self.newPlate.healthBar = bar

  end

  local function NamePlateSkinCastBar(self)

    local bar = CreateFrame("StatusBar",nil,self.newPlate)
    bar:SetSize(256,64)
    bar:SetStatusBarTexture("Interface\\AddOns\\"..an.."\\media\\statusbar_fill")
    bar:SetScale(cfg.scale)
    bar:SetPoint("TOP",self.newPlate.healthBar,"BOTTOM",0,20)

    local le = bar:CreateTexture(nil,"BACKGROUND",nil,-8)
    le:SetTexture("Interface\\AddOns\\"..an.."\\media\\edge_left")
    le:SetSize(64,64)
    le:SetPoint("RIGHT",bar,"LEFT",0,0)

    local re = bar:CreateTexture(nil,"BACKGROUND",nil,-8)
    re:SetTexture("Interface\\AddOns\\"..an.."\\media\\edge_right")
    re:SetSize(64,64)
    re:SetPoint("LEFT",bar,"RIGHT",0,0)

    local bg = bar:CreateTexture(nil,"BACKGROUND",nil,-8)
    bg:SetTexture("Interface\\AddOns\\"..an.."\\media\\statusbar_bg")
    bg:SetAllPoints()

    local shadow = bar:CreateTexture(nil,"BACKGROUND",nil,-8)
    shadow:SetTexture("Interface\\Common\\NameShadow")
    shadow:SetPoint("TOP",bar,"BOTTOM",0,20)
    shadow:SetSize(256,32)

    local hlf = CreateFrame("Frame",nil,bar)
    hlf:SetAllPoints()
    bar.hlf = hlf

    local hl = hlf:CreateTexture(nil,"BACKGROUND",nil,-8)
    hl:SetTexture("Interface\\AddOns\\"..an.."\\media\\statusbar_highlight")
    hl:SetAllPoints()

    local name = bar.hlf:CreateFontString(nil, "BORDER")
    name:SetFont(cfg.font, cfg.fontsize_castbar, "OUTLINE")
    name:SetPoint("TOP",bar,"BOTTOM",0,30)
    name:SetPoint("LEFT",8,0)
    name:SetPoint("RIGHT",-8,0)
    bar.nameString = name

    local icon = bar:CreateTexture(nil,"BACKGROUND",nil,-8)
    icon:SetTexCoord(0.08,0.92,0.08,0.92)
    icon:SetPoint("RIGHT",bar,"LEFT",-58,22)
    icon:SetSize(60,60)
    bar.spellIconTexture = icon

    local iconBorder = bar:CreateTexture(nil,"BACKGROUND",nil,-7)
    iconBorder:SetTexture("Interface\\AddOns\\"..an.."\\media\\icon_border")
    iconBorder:SetPoint("CENTER",bar.spellIconTexture,"CENTER",0,0)
    iconBorder:SetSize(78,78)
    bar.spellIconBorder = iconBorder

    local shield = bar:CreateTexture(nil,"BACKGROUND",nil,-6)
    shield:SetTexture("Interface\\AddOns\\"..an.."\\media\\shield")
    shield:SetPoint("BOTTOM",bar.spellIconBorder,0,-5)
    shield:SetSize(36,36)
    bar.shieldTexture = shield

    if not self.castBar:IsShown() then
      bar:Hide()
    end

    self.newPlate.castBar = bar

  end

  local function NamePlateSizerOnSizeChanged(self,x,y)
    local plate = self.__owner
    if plate:IsShown() then
      plate.newPlate:Hide()
      plate.newPlate:SetPoint("CENTER", WorldFrame, "BOTTOMLEFT", x, y)
      plate.newPlate:Show()
    end
  end

  local function NamePlateCreateSizer(self)
    local sizer = CreateFrame("Frame", nil, self.newPlate)
    sizer.__owner = self
    sizer:SetPoint("BOTTOMLEFT", WorldFrame)
    sizer:SetPoint("TOPRIGHT", self, "CENTER")
    sizer:SetScript("OnSizeChanged", NamePlateSizerOnSizeChanged)
  end

  local function NamePlateOnShow(self)
    NamePlateSetup(self)
    self.newPlate:Show()
  end

  local function NamePlateCastBarOnHide(self)
    local plate = self.__owner
    local castBar = plate.newPlate.castBar
    castBar:Hide()
  end

  local function NamePlateCastBarUpdate(self, value)
    local plate = self.__owner
    local castBar = plate.newPlate.castBar
    if self:IsShown() then
      castBar:Show()
    else
      castBar:Hide()
      return
    end
    if value == 0 then
      castBar:Hide()
      return
    end
    castBar.spellIconTexture:SetTexture(self.spellIconTexture:GetTexture())
    castBar.nameString:SetText(self.nameString:GetText())
    castBar:SetMinMaxValues(self:GetMinMaxValues())
    castBar:SetValue(self:GetValue())
    if self.shieldTexture:IsShown() then
      castBar.shieldTexture:Show()
      castBar:SetStatusBarColor(0.8,0.8,0.8)
      castBar.spellIconBorder:SetDesaturated(1)
    else
      castBar.shieldTexture:Hide()
      castBar:SetStatusBarColor(self:GetStatusBarColor())
      castBar.spellIconBorder:SetDesaturated(0)
    end
  end

  local function NamePlateHealthBarUpdate(self)
    local plate = self.__owner
    local healthBar = plate.newPlate.healthBar
    healthBar:SetMinMaxValues(self:GetMinMaxValues())
    healthBar:SetValue(self:GetValue())
  end

  local function NamePlateHealthBarColor(self)
    if self.threatTexture:IsShown() then
      local r,g,b = self.threatTexture:GetVertexColor()
      if g+b == 0 then
        self.newPlate.healthBar:SetStatusBarColor(0,1,0)--tank mode
      else
        self.newPlate.healthBar:SetStatusBarColor(r,g,b)
      end
      return
    end
    local r,g,b = self.healthBar:GetStatusBarColor()
    r,g,b = RoundNumber(r),RoundNumber(g),RoundNumber(b)
    for class, color in next, RAID_CLASS_COLORS do
      if r == color.r and g == color.g and b == color.b then
        return --no color change needed, bar is in class color
      end
    end
    if g+b == 0 then -- hostile
      r,g,b = FACTION_BAR_COLORS[2].r, FACTION_BAR_COLORS[2].g, FACTION_BAR_COLORS[2].b
    elseif r+b == 0 then -- friendly npc
      r,g,b = FACTION_BAR_COLORS[6].r, FACTION_BAR_COLORS[6].g, FACTION_BAR_COLORS[6].b
    elseif r+g > 1.95 then -- neutral
      r,g,b = FACTION_BAR_COLORS[4].r, FACTION_BAR_COLORS[4].g, FACTION_BAR_COLORS[4].b
    elseif r+g == 0 then -- friendly player, we don't like 0,0,1 so we change it to a more likable color
      r,g,b = 0/255, 100/255, 255/255
    end
    self.newPlate.healthBar:SetStatusBarColor(r,g,b)
  end

  local function NamePlateCreateNewPlate(self)
    self.newPlate = CreateFrame("Frame", nil, WorldFrame)
    self.newPlate.id = namePlateIndex
    namePlateIndex = namePlateIndex+1
    plates[self] = self.newPlate
    self.newPlate:SetSize(36,36)
  end

  local function NamePlateCreateAuraHeader(self)
    local auraHeader = CreateFrame("Frame",nil,self.newPlate)
    auraHeader:SetScale(cfg.scale)
    auraHeader:SetPoint("BOTTOMLEFT",self.newPlate.healthBar,"TOPLEFT",0,15)
    auraHeader:SetSize(60,45)
    self.auraHeader = auraHeader
  end

  local function NamePlateUpdateAura(self,startTime,expirationTime,unitCaster,spellID,stackCount)
    if not spellDB then return end
    if not spellDB[spellID] then return end
    if spellDB[spellID].blacklisted then return end
    if not expirationTime then
      expirationTime = startTime+spellDB[spellID].duration
    elseif not startTime then
      startTime = expirationTime-spellDB[spellID].duration
    end
    self.auras[spellID] = {
      spellId         = spellID,
      name            = spellDB[spellID].name,
      texture         = spellDB[spellID].texture,
      startTime       = startTime,
      expirationTime  = expirationTime,
      duration        = spellDB[spellID].duration,
      unitCaster      = unitCaster,
      stackCount      = stackCount,
    }
  end

  local function NamePlateRemoveAura(self,spellID)
    if self.auras[spellID] then
      self.auras[spellID] = nil
    end
  end

  local function NamePlateScanAuras(self,unit,filter)
    if not spellDB then return end
    if spellDB.disabled then return end
    for index = 1, NUM_MAX_AURAS do
      local name, _, texture, stackCount, _, duration, expirationTime, unitCaster, _, _, spellID = UnitAura(unit, index, filter)
      if not name then break end
      if spellID and (unitCaster == "player" or unitCaster == "pet") and not spellDB[spellID] then
        spellDB[spellID] = {
          name        = name,
          texture     = texture,
          duration    = duration,
          blacklisted = false,
        }
        print(an,"AuraModule","adding new spell to db",spellID,name)
      end
      if spellID and (unitCaster == "player" or unitCaster == "pet") then
        NamePlateUpdateAura(self,nil,expirationTime,unitCaster,spellID,stackCount)
      end
    end
  end

  local function NamePlateCreateAuraButton(self,index)
    if not self.auraHeader then
      NamePlateCreateAuraHeader(self)
    end
    local button = CreateFrame("Frame",nil,self.auraHeader)
    button:SetSize(self.auraHeader:GetSize())
    button.bg = button:CreateTexture(nil,"BACKGROUND",nil,-8)
    button.bg:SetTexture(1,1,1)
    button.bg:SetVertexColor(0,0,0,0.8)
    button.bg:SetAllPoints()
    button.icon = button:CreateTexture(nil,"BACKGROUND",nil,-7)
    button.icon:SetPoint("TOPLEFT",3,-3)
    button.icon:SetPoint("BOTTOMRIGHT",-3,3)
    button.icon:SetTexCoord(0.1,0.9,0.2,0.8)
    button.cooldown = button:CreateFontString(nil, "BORDER")
    button.cooldown:SetFont(cfg.font, cfg.fontsize_auracooldown, "OUTLINE")
    button.cooldown:SetPoint("BOTTOM",button,0,-5)
    button.cooldown:SetJustifyH("CENTER")
    button.stack = button:CreateFontString(nil, "BORDER")
    button.stack:SetFont(cfg.font, cfg.fontsize_aurastack, "OUTLINE")
    button.stack:SetPoint("TOPRIGHT",button,5,5)
    button.stack:SetJustifyH("RIGHT")
    if index == 1 then
      button:SetPoint("CENTER")
    else
      button:SetPoint("LEFT",self.auraButtons[index-1],"RIGHT",10,0)
    end
    button:Hide()
    self.auraButtons[index] = button
    return button
  end

  local function NamePlateUpdateAllAuras(self)
    local buttonIndex = 1
    for index, button in next, self.auraButtons do
      button:Hide()
    end
    for spellID, data in next, self.auras do
      local cooldown = data.expirationTime-GetTime()
      if cooldown < 0 then
        NamePlateRemoveAura(self,spellID)
      else
        local button = self.auraButtons[buttonIndex] or NamePlateCreateAuraButton(self,buttonIndex)
        --set texture
        button.icon:SetTexture(data.texture)
        --set cooldown
        button.cooldown:SetText(GetFormattedTime(cooldown))
        --set stackCount
        if data.stackCount and data.stackCount > 1 then
          button.stack:SetText(data.stackCount)
        else
          button.stack:SetText("")
        end
        button:Show()
        buttonIndex = buttonIndex + 1
      end
    end
  end

  local function NamePlateOnHide(self)
    self.newPlate.castBar:Hide()
    self.newPlate:Hide()
    wipe(self.auras)
    NamePlateUpdateAllAuras() --hide visible buttons
    if self.guid then
      unitDB[self.guid] = nil
      self.guid = nil
    end
  end

  local function NamePlateSetGUID(self,guid)
    if self.guid and guid ~= self.guid then
      unitDB[self.guid] = nil
      wipe(self.auras)
      NamePlateUpdateAllAuras(self) --hide visible buttons
      self.guid = guid
      unitDB[guid] = self
    elseif not self.guid then
      self.guid = guid
      unitDB[guid] = self
    end
  end

  local function NamePlateInitAuras(self)
    self.auras = {}
    self.auraButtons = {}
  end

  local function NamePlateInit(self)
    if not self then return end
    if plates[self] then return end
    NamePlateCreateNewPlate(self)
    NamePlateSetReferences(self)
    NamePlateSkinHealthBar(self)
    NamePlateSkinCastBar(self)
    NamePlateSetup(self)
    NamePlateCreateSizer(self)
    NamePlateHealthBarUpdate(self.healthBar)
    NamePlateHealthBarColor(self)
    NamePlateInitAuras(self)
    self:HookScript("OnShow", NamePlateOnShow)
    self:HookScript("OnHide", NamePlateOnHide)
    self.castBar:HookScript("OnShow", NamePlateCastBarUpdate)
    self.castBar:HookScript("OnHide", NamePlateCastBarOnHide)
    self.castBar:HookScript("OnValueChanged", NamePlateCastBarUpdate)
    self.healthBar:HookScript("OnValueChanged", NamePlateHealthBarUpdate)
    if not self:IsShown() then
      self.newPlate:Hide()
    end
  end

  local function NamePlateScan()
    for _, frame in next, { WorldFrame:GetChildren() } do
      local name = frame:GetName()
      if name and string.match(name, "^NamePlate%d+$") then
        namePlateIndex = string.gsub(name,"NamePlate","")
        break
      end
    end
  end

  local function NamePlateUpdateMouseover(self)
    NamePlateSetGUID(self,UnitGUID("mouseover"))
    NamePlateScanAuras(self,"mouseover","HELPFUL")
    NamePlateScanAuras(self,"mouseover","HARMFUL")
    updateMouseover = false
  end

  local function NamePlateUpdateTarget(self)
    --this may look wierd but is actually needed.
    --when the PLAYER_TARGET_CHANGED event fires the nameplate need one cycle to update the alpha, otherwise the old target would be tagged.
    if not self then return end
    if delayCounter == 1 then
      NamePlateSetGUID(self,UnitGUID("target"))
      NamePlateScanAuras(self,"target","HELPFUL")
      NamePlateScanAuras(self,"target","HARMFUL")
      updateTarget = false
      delayCounter = 0
    else
      delayCounter = delayCounter + 1
    end
  end

  local function NamePlateUpdateAll()
    targetPlateCounter = 0
    targetPlate = nil
    for blizzPlate, newPlate in next, plates do
      if blizzPlate:IsShown() then
        if blizzPlate:GetAlpha() == 1 then
          newPlate:SetAlpha(1)
        else
          newPlate:SetAlpha(cfg.alpha_nofocus)
        end
        if hasTarget and blizzPlate:GetAlpha() == 1 then
          targetPlateCounter = targetPlateCounter + 1
          targetPlate = blizzPlate
        end
        if updateMouseover and blizzPlate.highlightTexture:IsShown() then
          NamePlateUpdateMouseover(blizzPlate)
        end
        if worldFrameTimer > updateInterval then
          NamePlateHealthBarColor(blizzPlate)
          NamePlateUpdateAllAuras(blizzPlate)
        end
      end
    end
    if hasTarget and targetPlateCounter == 1 and (updateTarget or not targetPlate.guid) then
      NamePlateUpdateTarget(targetPlate)
    else
      delayCounter = 0
    end
  end

  -----------------------------
  -- WORLDFRAME FUNCTIONS
  -----------------------------

  local function WorldFrameOnUpdate(self, elapsed)
    worldFrameTimer = worldFrameTimer+elapsed
    if namePlateIndex then
      NamePlateUpdateAll()
      NamePlateInit(_G["NamePlate"..namePlateIndex])
    end
    if worldFrameTimer > updateInterval then
      if not namePlateIndex then
        NamePlateScan()
      end
      worldFrameTimer = 0
    end
  end

  -----------------------------
  -- WORLDFRAME
  -----------------------------

  WorldFrame:HookScript("OnUpdate", WorldFrameOnUpdate)

  -----------------------------
  -- AURAMODULE FUNCTIONS
  -----------------------------

  local function AuraModulePlayerTargetChanged()
    if not spellDB then return end
    if spellDB.disabled then return end
    if UnitGUID("target") and UnitExists("target") and not UnitIsUnit("target","player") and not UnitIsDead("target") then
      updateTarget = true
      hasTarget = true
    else
      updateTarget = false
      hasTarget = false
    end
  end

  local function AuraModuleUpdateMouseoverUnit()
    if not spellDB then return end
    if spellDB.disabled then return end
    if UnitGUID("mouseover") and UnitExists("mouseover") and not UnitIsUnit("mouseover","player") and not UnitIsDead("mouseover") then
      updateMouseover = true
    else
      updateMouseover = false
    end
  end

  local function AuraModuleUnitPet()
    if UnitGUID("pet") and UnitExists("pet") then
      petGUID = UnitGUID("pet")
    end
  end

  local function AuraModulePlayerLogin()
    if UnitGUID("player") then
      playerGUID = UnitGUID("player")
    end
    if UnitGUID("pet") and UnitExists("pet") then
      petGUID = UnitGUID("pet")
    end
  end

  local function AuraModuleCombatLogEventUnfiltered(...)
    if not spellDB then return end
    if spellDB.disabled then return end
    local _, event, _, srcGUID, _, _, _, destGUID, _, _, _, spellID, spellName, _, _, stackCount = ...
    if CLEU_FILTERS[event] then
      if not unitDB[destGUID] then return end --no corresponding nameplate found
      if not spellDB[spellID] then return end --no spell info found
      local unitCaster = nil
      if srcGUID == playerGUID then
        unitCaster = "player"
      elseif srcGUID == petGUID then
        unitCaster = "pet"
      else
        return
      end
      if CLEU_FILTERS[event] > 0 then
        NamePlateUpdateAura(unitDB[destGUID],GetTime(),nil,unitCaster,spellID,stackCount)
      else
        NamePlateRemoveAura(unitDB[destGUID],spellID)
      end
    end
  end

  local function AuraModuleUnitAura(unit)
    if not spellDB then return end
    if spellDB.disabled then return end
    local guid = UnitGUID(unit)
    if guid and unitDB[guid] and not UnitIsUnit(unit,"player") then
      --print("ScanAuras", "UNIT_AURA", unitDB[guid].newPlate.id)
      NamePlateScanAuras(unitDB[guid],unit,"HELPFUL")
      NamePlateScanAuras(unitDB[guid],unit,"HARMFUL")
    end
  end

  local function AuraModuleAddonLoaded(name)
    if name == an then
      self:UnregisterEvent("ADDON_LOADED")
      if not rNP_SPELL_DB then
        rNP_SPELL_DB = {}
      end
      spellDB = rNP_SPELL_DB --getting the saved variables data
      print(an,"AuraModule","loading spell db")
      if spellDB.disabled then
        print(an,"AuraModule","spell db is currently disabled on this character")
      end
    end
  end

  local function AuraModuleOnEvent(self,event,...)
    if event == "ADDON_LOADED" then
      AuraModuleAddonLoaded(...)
    elseif event == "PLAYER_LOGIN" then
      AuraModulePlayerLogin(...)
    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
      AuraModuleCombatLogEventUnfiltered(...)
    elseif event == "PLAYER_TARGET_CHANGED" then
      AuraModulePlayerTargetChanged(...)
    elseif event == "UPDATE_MOUSEOVER_UNIT" then
      AuraModuleUpdateMouseoverUnit(...)
    elseif event == "UNIT_AURA" then
      AuraModuleUnitAura(...)
    elseif event == "UNIT_PET" then
      AuraModuleUnitPet(...)
    end

  end

  -----------------------------
  -- AURAMODULE
  -----------------------------

  AuraModule:RegisterEvent("ADDON_LOADED")
  AuraModule:RegisterEvent("PLAYER_LOGIN")
  AuraModule:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
  AuraModule:RegisterEvent("PLAYER_TARGET_CHANGED")
  AuraModule:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
  AuraModule:RegisterUnitEvent("UNIT_AURA","target","mouseover")
  AuraModule:RegisterUnitEvent("UNIT_PET", "player")
  AuraModule:SetScript("OnEvent", AuraModuleOnEvent)

  -----------------------------
  -- SLASH COMMAND FUNCTIONS
  -----------------------------

  local function SlashCommandOnEvent(cmd)
    if not spellDB then return end
    local spellID = tonumber(strsub(cmd, (strfind(cmd, " ") or 0)+1))
    if (cmd:match"blacklist") then
      print("|c"..color..an.." blacklist|r")
      if spellID and spellDB[spellID] then
        spellDB[spellID].blacklisted = true
        print(spellID,spellDB[spellID].name,"is now blacklisted")
      else
        print("no matching spellid found")
      end
    elseif (cmd:match"whitelist") then
      print("|c"..color..an.." whitelist|r")
      if spellID and spellDB[spellID] then
        spellDB[spellID].blacklisted = false
        print(spellID,spellDB[spellID].name,"is now whitelisted")
      else
        print("no matching spellid found")
      end
    elseif (cmd:match"list") then
      print("|c"..color..an.." list|r")
      print("spellID","|","name","|","blacklisted")
      print("------------------------------------")
      local count = 0
      for key, data in next, spellDB do
        if type(key) == "number" then
          print(key,"|",data.name,"|",data.blacklisted)
          count = count+1
        end
      end
      if count == 0 then
        print("list has no entries")
      end
    elseif (cmd:match"remove") then
      print("|c"..color..an.." remove|r")
      if spellID and spellDB[spellID] then
        print(spellID,spellDB[spellID].name,"removed")
        spellDB[spellID] = nil
      else
        print("no matching spellid found")
      end
    elseif (cmd:match"resetspelldb") then
      print("|c"..color..an.." resetspelldb|r")
      wipe(spellDB)
      print("spell db has been reset")
    elseif (cmd:match"disable") then
      print("|c"..color..an.." disable|r")
      spellDB.disabled = true
      print("spell db has been disabled")
    elseif (cmd:match"enable") then
      print("|c"..color..an.." enable|r")
      spellDB.disabled = false
      print("spell db has been enabled")
    else
      print("|c"..color..an.." command list|r")
      print("|c"..color.."\/"..shortcut.." list|r to list all entries in spellDB")
      print("|c"..color.."\/"..shortcut.." blacklist SPELLID|r to blacklist a spellid in spellDB")
      print("|c"..color.."\/"..shortcut.." whitelist SPELLID|r to whitelist a spellid in spellDB")
      print("|c"..color.."\/"..shortcut.." remove SPELLID|r to remove a spellid from spellDB")
      print("|c"..color.."\/"..shortcut.." disable|r to disable the spellDB for this character")
      print("|c"..color.."\/"..shortcut.." enable|r to enable the spellDB for this character")
      print("|c"..color.."\/"..shortcut.." resetspelldb|r to reset the spellDB for this character")
    end
  end

  -----------------------------
  -- SLASH COMMAND
  -----------------------------

  local color         = "FFFFAA00"
  local shortcut      = "rnp"

  --slash commands
  SlashCmdList[shortcut] = SlashCommandOnEvent
  SLASH_rnp1 = "/"..shortcut;

  print("|c"..color..an.." loaded.|r")
  print("|c"..color.."\/"..shortcut.."|r to display the command list")

  -----------------------------
  -- SET CVAR
  -----------------------------

  --reset some outdated (yet still active) bloat variables if people run old config.wtf files
  --setvar
  SetCVar("bloatnameplates",0)
  SetCVar("bloatthreat",0)
  SetCVar("bloattest",0)