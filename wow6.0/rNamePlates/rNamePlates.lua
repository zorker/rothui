
  -- // rNamePlates
  -- // zork - 2014

  -----------------------------
  -- VARIABLES
  -----------------------------

  local an, at = ...
  local plates, namePlateIndex, _G, string, WorldFrame, unpack, math, wipe, mod = {}, nil, _G, string, WorldFrame, unpack, math, wipe, mod

  local cfg = {}
  cfg.scale                   = 0.35
  cfg.font                    = STANDARD_TEXT_FONT
  cfg.healthbar_fontsize      = 26
  cfg.castbar_fontsize        = 26
  cfg.aura_stack_fontsize     = 24
  cfg.aura_cooldown_fontsize  = 28
  cfg.point                   = {"CENTER",0,-16}

  -----------------------------
  -- AURAS
  -----------------------------

  local NUM_MAX_AURAS = 40

  local unitDB                = {} --unit table by guid
  local spellDB               = {} --aura table by spellid

  local AuraModule = CreateFrame("Frame")
  AuraModule.playerGUID       = nil
  AuraModule.petGUID          = nil

  function AuraModule:UNIT_PET(...)
    if UnitGUID("pet") and UnitExists("pet") then
      self.petGUID = UnitGUID("pet")
    end
  end

  function AuraModule:PLAYER_LOGIN(...)
    if UnitGUID("player") then
      self.playerGUID = UnitGUID("player")
    end
    if UnitGUID("pet") and UnitExists("pet") then
      self.petGUID = UnitGUID("pet")
    end
  end

  AuraModule.CLEU_FILTER = {
    ["SPELL_AURA_APPLIED"]      = true, --UpdateAura
    ["SPELL_AURA_REFRESH"]      = true, --UpdateAura
    ["SPELL_AURA_APPLIED_DOSE"] = true, --UpdateAura
    ["SPELL_AURA_REMOVED_DOSE"] = true, --UpdateAura
    ["SPELL_AURA_STOLEN"]       = true, --RemoveAura
    ["SPELL_AURA_REMOVED"]      = true, --RemoveAura
    ["SPELL_AURA_BROKEN"]       = true, --RemoveAura
    ["SPELL_AURA_BROKEN_SPELL"] = true, --RemoveAura
  }

  function AuraModule:COMBAT_LOG_EVENT_UNFILTERED(...)
    local _, event, _, srcGUID, _, _, _, destGUID, _, _, _, spellID, spellName, _, _, stackCount = ...
    if self.CLEU_FILTER[event] then
      if not unitDB[destGUID] then return end --no corresponding nameplate found
      if not spellDB[spellID] then return end --no spell info found
      local unitCaster = nil
      if srcGUID == self.playerGUID then
        unitCaster = "player"
      elseif srcGUID == self.petGUID then
        unitCaster = "pet"
      else
        return
      end
      if event == "SPELL_AURA_APPLIED" or event == "SPELL_AURA_REFRESH" or event == "SPELL_AURA_APPLIED_DOSE" or event == "SPELL_AURA_REMOVED_DOSE" then
        unitDB[destGUID]:UpdateAura(GetTime(),nil,unitCaster,spellID,stackCount)
      else
        unitDB[destGUID]:RemoveAura(spellID)
      end
    end
  end

  function AuraModule:UNIT_AURA(unit)
    local guid = UnitGUID(unit)
    if guid and unitDB[guid] then
      unitDB[guid]:ScanAuras(unit,"HELPFUL")
      unitDB[guid]:ScanAuras(unit,"HARMFUL")
    end
  end

  function AuraModule:ADDON_LOADED(name,...)
    if name == an then
      spellDB = rNP_SPELL_DB or spellDB
      local version, build = GetBuildInfo()
      if not spellDB.build then spellDB.build = build end
      if spellDB.build ~= build then
        spellDB = {}
        print(an,"AuraModule","new wow build found, reseting spell db")
      end --reset spell db when a new wow build is out
      rNP_SPELL_DB = spellDB
      print(an,"AuraModule","loading spell db")
    end
  end

  function AuraModule:PLAYER_LOGOUT()
    rNP_SPELL_DB = spellDB
    print(an,"AuraModule","saving spell db")
  end

  AuraModule:RegisterEvent("ADDON_LOADED")
  AuraModule:RegisterEvent("PLAYER_LOGIN")
  AuraModule:RegisterEvent("PLAYER_LOGOUT")
  AuraModule:RegisterUnitEvent("UNIT_AURA","target","mouseover")
  AuraModule:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")  
  AuraModule:RegisterUnitEvent("UNIT_PET", "player")
  AuraModule:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)

  -----------------------------
  -- FUNCTIONS
  -----------------------------

  local trash = CreateFrame("Frame")
  trash:Hide()

  local function GetHexColorFromRGB(r, g, b)
    return string.format("%02x%02x%02x", r*255, g*255, b*255)
  end
  
  local function GetFormattedTime(time)
    local hr, m, s, text
    if time <= 0 then 
      text = ""
    elseif time < 2 then 
      text = math.floor(time*10)/10
    elseif(time < 3600 and time > 60) then
      hr = math.floor(time / 3600)
      m = math.floor(mod(time, 3600) / 60 + 1)
      text = string.format("%dm", m)
    elseif time < 60 then
      m = math.floor(time / 60)
      s = mod(time, 60)
      text = (m == 0 and string.format("%ds", s))
    else
      hr = math.floor(time / 3600 + 1)
      text = string.format("%dh", hr)
    end
    return text
  end

  local function RoundNumber(n)
    return (math.floor(n*100+0.5)/100)
  end

  local function NamePlateSetup(blizzPlate)

    blizzPlate.borderTexture:SetTexture(nil)
    blizzPlate.bossIconTexture:SetTexture(nil)
    blizzPlate.eliteDragonTexture:SetTexture(nil)
    blizzPlate.highlightTexture:SetTexture(nil)

    blizzPlate.threatTexture:ClearAllPoints()
    blizzPlate.threatTexture:SetPoint("TOPLEFT",blizzPlate.healthBar,-2,2)
    blizzPlate.threatTexture:SetPoint("BOTTOMRIGHT",blizzPlate.healthBar,2,-2)

    blizzPlate.healthBar:SetSize(unpack(blizzPlate.healthBar.size))
    blizzPlate.healthBar:ClearAllPoints()
    blizzPlate.healthBar:SetPoint(unpack(blizzPlate.healthBar.point))

    local name = blizzPlate.nameString:GetText() or "Unknown"
    local level = blizzPlate.levelString:GetText() or "-1"
    local hexColor = GetHexColorFromRGB(blizzPlate.levelString:GetTextColor()) or "ffffff"

    if blizzPlate.bossIconTexture:IsShown() then
      level = "??"
      hexColor = "ff6600"
    elseif blizzPlate.eliteDragonTexture:IsShown() then
      level = level.."+"
    end
    blizzPlate.healthBar.name:SetText("|cff"..hexColor..""..level.."|r "..name)
  end

  local function NamePlateOnInit(blizzPlate)

    blizzPlate.barFrame, blizzPlate.nameFrame = blizzPlate:GetChildren()
    blizzPlate.healthBar, blizzPlate.castBar = blizzPlate.barFrame:GetChildren()
    blizzPlate.threatTexture, blizzPlate.borderTexture, blizzPlate.highlightTexture, blizzPlate.levelString, blizzPlate.bossIconTexture, blizzPlate.raidIconTexture, blizzPlate.eliteDragonTexture = blizzPlate.barFrame:GetRegions()
    blizzPlate.nameString = blizzPlate.nameFrame:GetRegions()
    blizzPlate.healthBar.statusbarTexture = blizzPlate.healthBar:GetRegions()
    blizzPlate.castBar.statusbarTexture, blizzPlate.castBar.borderTexture, blizzPlate.castBar.shieldTexture, blizzPlate.castBar.spellIconTexture, blizzPlate.castBar.nameString, blizzPlate.castBar.nameShadow = blizzPlate.castBar:GetRegions()

    blizzPlate.nameFrame:SetParent(trash)
    blizzPlate.levelString:SetParent(trash)
    blizzPlate.healthBar:SetParent(blizzPlate.newPlate)
    blizzPlate.castBar:SetParent(blizzPlate.newPlate)

    blizzPlate.castBar.borderTexture:SetTexture(nil)
    blizzPlate.borderTexture:SetTexture(nil)
    blizzPlate.bossIconTexture:SetTexture(nil)
    blizzPlate.eliteDragonTexture:SetTexture(nil)
    blizzPlate.highlightTexture:SetTexture(nil)

    blizzPlate.raidIconTexture:SetParent(blizzPlate.healthBar)
    blizzPlate.raidIconTexture:SetSize(60,60)
    blizzPlate.raidIconTexture:ClearAllPoints()
    blizzPlate.raidIconTexture:SetPoint("BOTTOM",blizzPlate.healthBar,"TOP",0,40)

    blizzPlate.threatTexture:SetParent(blizzPlate.newPlate)
    blizzPlate.threatTexture:SetTexture("Interface\\AddOns\\"..an.."\\media\\threat")
    blizzPlate.threatTexture:SetTexCoord(0,1,0,1)
    --blizzPlate.threatTexture:SetBlendMode("ADD")

  end

  local function SkinHealthBar(blizzPlate)

    local bar = blizzPlate.healthBar
    bar.size = {256,64}
    bar:SetSize(unpack(bar.size))
    bar:SetStatusBarTexture("Interface\\AddOns\\"..an.."\\media\\statusbar_fill")
    bar:SetScale(cfg.scale)
    bar:ClearAllPoints()
    bar.point = cfg.point
    bar:SetPoint(unpack(bar.point))

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
    name:SetFont(cfg.font, cfg.healthbar_fontsize, "OUTLINE")
    name:SetPoint("BOTTOM",bar,"TOP",0,-24)
    name:SetPoint("LEFT",8,0)
    name:SetPoint("RIGHT",-8,0)
    name:SetText("Ich bin ein Berliner!")
    bar.name = name

  end

  local function SkinCastBar(blizzPlate)

    local bar = blizzPlate.castBar
    bar.size = {256,64}
    bar:SetSize(unpack(bar.size))
    bar:SetStatusBarTexture("Interface\\AddOns\\"..an.."\\media\\statusbar_fill")
    bar:SetScale(cfg.scale)
    bar:ClearAllPoints()
    bar.point = {"TOP",blizzPlate.healthBar,"BOTTOM",0,20}
    bar:SetPoint(unpack(bar.point))

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

    bar.nameShadow:ClearAllPoints()
    bar.nameShadow:SetPoint("TOP",bar,"BOTTOM",0,20)
    bar.nameShadow:SetSize(256,32)

    bar.nameString:SetFont(cfg.font, cfg.castbar_fontsize, "OUTLINE")
    bar.nameString:ClearAllPoints()
    bar.nameString:SetPoint("TOP",bar,"BOTTOM",0,30)
    bar.nameString:SetPoint("LEFT",8,0)
    bar.nameString:SetPoint("RIGHT",-8,0)

    bar.spellIconTexture:SetDrawLayer("BACKGROUND",-8)
    bar.spellIconTexture:SetTexCoord(0.08,0.92,0.08,0.92)
    bar.spellIconTexture.point = {"RIGHT",bar,"LEFT",-58,22}
    bar.spellIconTexture:ClearAllPoints()
    bar.spellIconTexture:SetPoint(unpack(bar.spellIconTexture.point))
    bar.spellIconTexture:SetSize(60,60)

    local iconBorder = bar:CreateTexture(nil,"BACKGROUND",nil,-7)
    iconBorder:SetTexture("Interface\\AddOns\\"..an.."\\media\\icon_border")
    iconBorder:SetPoint("CENTER",bar.spellIconTexture,"CENTER",0,0)
    iconBorder:SetSize(78,78)
    bar.spellIconBorder = iconBorder

    bar.shieldTexture:SetDrawLayer("BACKGROUND",-6)
    bar.shieldTexture:SetTexture("Interface\\AddOns\\"..an.."\\media\\shield")
    bar.shieldTexture.point = {"BOTTOM",bar.spellIconBorder,0,-5}
    bar.shieldTexture.size = {36,36}
    bar.shieldTexture:ClearAllPoints()
    bar.shieldTexture:SetPoint(unpack(bar.shieldTexture.point))
    bar.shieldTexture:SetSize(unpack(bar.shieldTexture.size))

  end

  local function NamePlatePosition(blizzPlate)
    local sizer = CreateFrame("Frame", nil, blizzPlate.newPlate)
    sizer:SetPoint("BOTTOMLEFT", WorldFrame)
    sizer:SetPoint("TOPRIGHT", blizzPlate, "CENTER")
    sizer:SetScript("OnSizeChanged", function(self, x, y)
      if blizzPlate:IsShown() then
        blizzPlate.newPlate:Hide() -- Important, never move the frame while it"s visible
        blizzPlate.newPlate:SetPoint("CENTER", WorldFrame, "BOTTOMLEFT", x, y) -- Immediately reposition frame
        blizzPlate.newPlate:Show()
      end
    end)
  end

  local function NamePlateSetGUID(blizzPlate,guid)
    if blizzPlate.guid then return end
    blizzPlate.guid = guid
    unitDB[guid] = blizzPlate
  end

  local function NamePlateOnShow(blizzPlate)
    NamePlateSetup(blizzPlate)
    blizzPlate.newPlate:Show()
  end

  local function NamePlateOnHide(blizzPlate)
    blizzPlate.newPlate:Hide()
    blizzPlate.auraScannedOnTargetInit = false
    wipe(blizzPlate.auras)
    if blizzPlate.guid then
      unitDB[blizzPlate.guid] = nil
      blizzPlate.guid = nil
    end
  end

  local function NamePlateCastBarOnShow(castBar)
    castBar:SetSize(unpack(castBar.size))
    castBar:ClearAllPoints()
    castBar:SetPoint(unpack(castBar.point))
    castBar.spellIconTexture:ClearAllPoints()
    castBar.spellIconTexture:SetPoint(unpack(castBar.spellIconTexture.point))
    if castBar.shieldTexture:IsShown() then
      castBar:SetStatusBarColor(0.8,0.8,0.8)
      castBar.shieldTexture:ClearAllPoints()
      castBar.shieldTexture:SetPoint(unpack(castBar.shieldTexture.point))
      castBar.shieldTexture:SetSize(unpack(castBar.shieldTexture.size))
      castBar.spellIconBorder:SetDesaturated(1)
    else
      castBar.spellIconBorder:SetDesaturated(0)
    end
  end

  local function NamePlateCastBarOnValueChanged(castBar)
    castBar:SetSize(unpack(castBar.size))
    castBar:ClearAllPoints()
    castBar:SetPoint(unpack(castBar.point))
    castBar.spellIconTexture:ClearAllPoints()
    castBar.spellIconTexture:SetPoint(unpack(castBar.spellIconTexture.point))
    if castBar.shieldTexture:IsShown() then
      castBar.shieldTexture:ClearAllPoints()
      castBar.shieldTexture:SetPoint(unpack(castBar.shieldTexture.point))
      castBar.shieldTexture:SetSize(unpack(castBar.shieldTexture.size))
    end
  end

  local function CreateNewPlate(blizzPlate)
    blizzPlate.newPlate = CreateFrame("Frame", nil, WorldFrame)
    blizzPlate.newPlate.id = namePlateIndex
    blizzPlate.newPlate:SetSize(36,36)
    plates[blizzPlate] = blizzPlate.newPlate
  end

  local function SkinPlate(blizzPlate)
    if plates[blizzPlate] then return end
    CreateNewPlate(blizzPlate)
    NamePlateOnInit(blizzPlate)
    SkinHealthBar(blizzPlate)
    SkinCastBar(blizzPlate)
    NamePlateSetup(blizzPlate)
    NamePlatePosition(blizzPlate)
    if not blizzPlate:IsShown() then
      blizzPlate.newPlate:Hide()
    end
    blizzPlate.auras = {}
    blizzPlate.auraButtons = {}
    blizzPlate.auraScannedOnTargetInit = false
    function blizzPlate:CreateAuraHeader()
      local auraHeader = CreateFrame("Frame",nil,self.newPlate)
      auraHeader:SetScale(cfg.scale)
      auraHeader:SetPoint("BOTTOMLEFT",self.healthBar,"TOPLEFT",0,15)
      auraHeader:SetSize(60,45)
      blizzPlate.auraHeader = auraHeader
    end
    function blizzPlate:UpdateAura(startTime,expirationTime,unitCaster,spellID,stackCount)
      if not spellDB[spellID] then return end
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
    function blizzPlate:RemoveAura(spellID)
      if self.auras[spellID] then
        self.auras[spellID] = nil
      end
    end
    function blizzPlate:ScanAuras(unit,filter)
      for index = 1, NUM_MAX_AURAS do
        local name, _, texture, stackCount, _, duration, expirationTime, unitCaster, _, _, spellID = UnitAura(unit, index, filter)
        if not name then break end
        if spellID and (unitCaster == "player" or unitCaster == "pet") and not spellDB[spellID] then
          spellDB[spellID] = {
            name        = name,
            texture     = texture,
            duration    = duration,
          }
          print(an,"AuraModule","adding new spell to db",spellID,name)
        end
        if spellID and (unitCaster == "player" or unitCaster == "pet") then
          self:UpdateAura(nil,expirationTime,unitCaster,spellID,stackCount)
        end
      end
    end
    function blizzPlate:CreateAuraButton(index)
      if not self.auraHeader then
        self:CreateAuraHeader()
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
      button.cooldown:SetFont(cfg.font, cfg.aura_cooldown_fontsize, "OUTLINE")
      button.cooldown:SetPoint("BOTTOM",button,0,-5)
      button.cooldown:SetJustifyH("CENTER")
      button.stack = button:CreateFontString(nil, "BORDER")
      button.stack:SetFont(cfg.font, cfg.aura_stack_fontsize, "OUTLINE")
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
    function blizzPlate:UpdateAllAuras()
      local buttonIndex = 1
      for index, button in next, self.auraButtons do
        button:Hide()
      end
      for spellID, data in next, self.auras do
        local cooldown = data.expirationTime-GetTime()
        if cooldown < 0 then
          self:RemoveAura(spellID)
        else
          local button = self.auraButtons[buttonIndex] or self:CreateAuraButton(buttonIndex)
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
    blizzPlate:HookScript("OnShow", NamePlateOnShow)
    blizzPlate:HookScript("OnHide", NamePlateOnHide)
    blizzPlate.castBar:HookScript("OnShow", NamePlateCastBarOnShow)
    blizzPlate.castBar:HookScript("OnValueChanged", NamePlateCastBarOnValueChanged)
    namePlateIndex = namePlateIndex+1
  end

  -----------------------------
  -- ONUPDATE
  -----------------------------

  local countFramesWithFullAlpha = 0
  local targetPlate = nil

  local timer = 0.0
  local interval = 0.1

  WorldFrame:HookScript("OnUpdate", function(self, elapsed)
    timer = timer+elapsed
    countFramesWithFullAlpha = 0
    for blizzPlate, newPlate in next, plates do
      if blizzPlate:IsShown() then
        newPlate:SetAlpha(blizzPlate:GetAlpha())
        if blizzPlate:GetAlpha() == 1 then
          countFramesWithFullAlpha = countFramesWithFullAlpha + 1
          targetPlate = blizzPlate
        end
        if blizzPlate.highlightTexture:IsShown() and UnitGUID("mouseover") and UnitExists("mouseover") then
          NamePlateSetGUID(blizzPlate,UnitGUID("mouseover"))
          if timer > interval then
            blizzPlate:ScanAuras("mouseover","HELPFUL")
            blizzPlate:ScanAuras("mouseover","HARMFUL")
          end
        end
        if timer > interval then
          blizzPlate:UpdateAllAuras()
        end
      end
    end
    if timer > interval then
      timer = 0
    end
    if countFramesWithFullAlpha == 1 and UnitGUID("target") and UnitExists("target") and not UnitIsDead("target") then    
      NamePlateSetGUID(targetPlate,UnitGUID("target"))
      --when the target is triggered auras may be running already, thus allow scanning for auras 1 time
      if not targetPlate.auraScannedOnTargetInit then
        targetPlate:ScanAuras("target","HELPFUL")
        targetPlate:ScanAuras("target","HARMFUL")
        targetPlate.auraScannedOnTargetInit = true
      end      
      targetPlate = nil
    end
    if not namePlateIndex then
      for _, blizzPlate in next, {self:GetChildren()} do
        local name = blizzPlate:GetName()
        if name and string.match(name, "^NamePlate%d+$") then
          namePlateIndex = string.gsub(name,"NamePlate","")
          break
        end
      end
    else
      local blizzPlate = _G["NamePlate"..namePlateIndex]
      if not blizzPlate then return end
      SkinPlate(blizzPlate)
    end
  end)

  --reset some outdated (yet still active) bloat variables if people run old config.wtf files
  --setvar
  SetCVar("bloatnameplates",0)
  SetCVar("bloatthreat",0)
  SetCVar("bloattest",0)