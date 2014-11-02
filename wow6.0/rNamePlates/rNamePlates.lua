
  -- // rNamePlates
  -- // zork - 2014

  -----------------------------
  -- VARIABLES
  -----------------------------

  local an, at = ...
  local plates, namePlateIndex, _G, string, WorldFrame, unpack, math = {}, nil, _G, string, WorldFrame, unpack, math

  local cfg = {}
  cfg.scale = 0.35
  cfg.fontsize = 26
  cfg.point = {"CENTER",0,-16}

  -----------------------------
  -- AURAS
  -----------------------------

  local units           = {} --the units guid table
  local spells          = {} --the aura spellid table

  local AuraModule = CreateFrame("Frame")
  AuraModule.playerGUID      = nil
  AuraModule.petGUID         = nil
  AuraModule.targetGUID      = nil
  AuraModule.mouseoverGUID   = nil
  AuraModule.updateTarget    = false
  AuraModule.updateMouseover = false

  function AuraModule:PLAYER_TARGET_CHANGED(...)
    if UnitGUID("target") and UnitExists("target") and not UnitIsDead("target") then
      self.updateTarget = true
      self.targetGUID = UnitGUID("target")
    else
      self.updateTarget = false
    end
  end

  function AuraModule:CheckForNewSpells(unit,filter)
    for index = 1,40 do
      local name, _, texture, count, debuffType, duration, expirationTime, unitCaster, _, _, spellID = UnitAura(unit, index, filter)
      if not name or not spellID then 
        break 
      end
      if (unitCaster == "player" or unitCaster == "pet") and not spells[spellID] then
        spells[spellID] = {
          name        = name,
          texture     = texture,
          duration    = duration,
        }
        print("Adding new spell to db",name,texture,duration)
      end
    end
  end

  function AuraModule:UNIT_AURA(unit)
    self:CheckForNewSpells(unit,"HARMFUL")
    self:CheckForNewSpells(unit,"HELPFUL")
  end

  function AuraModule:UPDATE_MOUSEOVER_UNIT(...)
    if UnitGUID("mouseover") and UnitExists("mouseover") then
      self.updateMouseover = true
      self.mouseoverGUID = UnitGUID("mouseover")
    else
      self.updateMouseover = false
    end
  end

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

  function AuraModule:HandleCLEUEvent(blizzPlate,event,caster,srcGUID,destGUID,spellID,spellName,auraType,stackCount)
    --print("HandleCLEUEvent",units[destGUID],event,caster,srcGUID,destGUID,spellID,spellName,auraType,stackCount)
    --print("HandleCLEUEvent",GetSpellInfo(spellID))
  end

  AuraModule.CLEU_FILTER = {
    ["SPELL_AURA_APPLIED"]      = true, --AddAura
    ["SPELL_AURA_REFRESH"]      = true, --RefreshAura
    ["SPELL_AURA_APPLIED_DOSE"] = true, --DoseAura
    ["SPELL_AURA_REMOVED_DOSE"] = true, --DoseAura
    ["SPELL_AURA_STOLEN"]       = true, --RemoveAura
    ["SPELL_AURA_REMOVED"]      = true, --RemoveAura
    ["SPELL_AURA_BROKEN"]       = true, --RemoveAura
    ["SPELL_AURA_BROKEN_SPELL"] = true, --RemoveAura
  }

  function AuraModule:COMBAT_LOG_EVENT_UNFILTERED(...)
    local _, event, _, srcGUID, _, _, _, destGUID, _, _, _, spellID, spellName, spellFlag, auraType, stackCount = ...
    if self.CLEU_FILTER[event] then
      if not units[destGUID] then return end
      local caster = nil
      if srcGUID == self.playerGUID then
        caster = "player"
      elseif srcGUID == self.petGUID then
        caster = "pet"
      else
        return
      end
      self:HandleCLEUEvent(units[destGUID],event,caster,srcGUID,destGUID,spellID,spellName,auraType,stackCount)
    end
  end

  function AuraModule:ADDON_LOADED(name,...)
    if name == an then
      spells = rNP_SPELL_DB or spells
      rNP_SPELL_DB = spells
      print(an,"loading spell db")
    end
  end

  function AuraModule:PLAYER_LOGOUT()
    rNP_SPELL_DB = spells
    print(an,"saving spell db")
  end
  
  AuraModule:RegisterEvent("ADDON_LOADED")
  AuraModule:RegisterEvent("PLAYER_LOGOUT")
  AuraModule:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
  AuraModule:RegisterEvent("PLAYER_TARGET_CHANGED")
  AuraModule:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
  AuraModule:RegisterUnitEvent("UNIT_PET", "player")
  AuraModule:RegisterUnitEvent("UNIT_AURA", "target","mouseover")
  AuraModule:RegisterEvent("PLAYER_LOGIN")
  AuraModule:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)

  -----------------------------
  -- FUNCTIONS
  -----------------------------

  local trash = CreateFrame("Frame")
  trash:Hide()

  local function GetHexColorFromRGB(r, g, b)
    return string.format("%02x%02x%02x", r*255, g*255, b*255)
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
    blizzPlate.raidIconTexture:SetPoint("BOTTOM",blizzPlate.healthBar,"TOP",0,10)

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
    name:SetFont(STANDARD_TEXT_FONT, cfg.fontsize, "OUTLINE")
    name:SetPoint("BOTTOM",bar,"TOP",0,-24)
    --name:SetPoint("LEFT",8,0)
    --name:SetPoint("RIGHT",-8,0)
    name:SetText("Ich bin ein Berliner und ein sehr")
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

    bar.nameString:SetFont(STANDARD_TEXT_FONT, cfg.fontsize, "OUTLINE")
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

  local function NamePlateScanAuras(blizzPlate,unit)
    AuraModule:CheckForNewSpells(unit,"HARMFUL")
    AuraModule:CheckForNewSpells(unit,"HELPFUL")
  end

  local function NamePlateSetGUID(blizzPlate,guid)
    if blizzPlate.guid then return end
    blizzPlate.guid = guid
    units[blizzPlate.guid] = blizzPlate
    blizzPlate.healthBar.name:SetText(guid)
    --print(blizzPlate.newPlate.id,guid)
  end

  local function NamePlateOnShow(blizzPlate)
    NamePlateSetup(blizzPlate)
    blizzPlate.newPlate:Show()
  end

  local function NamePlateOnHide(blizzPlate)
    blizzPlate.newPlate:Hide()
    if blizzPlate.guid then
      units[blizzPlate.guid] = nil
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

  local function NamePlateCastBarOnHide(castBar) end

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
    blizzPlate:HookScript("OnShow", NamePlateOnShow)
    blizzPlate:HookScript("OnHide", NamePlateOnHide)
    blizzPlate.castBar:HookScript("OnShow", NamePlateCastBarOnShow)
    --blizzPlate.castBar:HookScript("OnHide", NamePlateCastBarOnHide)
    blizzPlate.castBar:HookScript("OnValueChanged", NamePlateCastBarOnValueChanged)
    namePlateIndex = namePlateIndex+1
  end

  -----------------------------
  -- ONUPDATE
  -----------------------------

  local countFramesWithFullAlpha = 0
  local lastNamePlate

  WorldFrame:HookScript("OnUpdate", function(self, elapsed)
    countFramesWithFullAlpha = 0
    for blizzPlate, newPlate in next, plates do
      if blizzPlate:IsShown() then
        newPlate:SetAlpha(blizzPlate:GetAlpha())
        if AuraModule.updateTarget and blizzPlate:GetAlpha() == 1 then
          countFramesWithFullAlpha = countFramesWithFullAlpha + 1
          lastNamePlate = blizzPlate
        end
        if AuraModule.updateMouseover and blizzPlate.highlightTexture:IsShown() then
          NamePlateSetGUID(blizzPlate,AuraModule.mouseoverGUID)
          NamePlateScanAuras(blizzPlate,"mouseover")
          AuraModule.updateMouseover = false
        end
      end
    end
    if countFramesWithFullAlpha == 1 and AuraModule.updateTarget then
      NamePlateSetGUID(lastNamePlate,AuraModule.targetGUID)
      NamePlateScanAuras(blizzPlate,"target")
      AuraModule.updateTarget = false
      lastNamePlate = nil
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