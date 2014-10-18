
  -- // rNamePlates
  -- // zork - 2014

  -----------------------------
  -- VARIABLES
  -----------------------------

  local an, at = ...
  local plates, namePlateIndex, _G, string, WorldFrame = {}, nil, _G, string, WorldFrame
  local unpack = unpack

  local cfg = {}
  cfg.scale = 0.35

  -----------------------------
  -- FUNCTIONS
  -----------------------------

  local trash = CreateFrame("Frame")
  trash:Hide()

  local function GetHexColorFromRGB(r, g, b)
    return string.format("%02x%02x%02x", r*255, g*255, b*255)
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
    
    blizzPlate.raidIconTexture:SetParent(blizzPlate.newPlate)
    blizzPlate.raidIconTexture:SetSize(25,25)
    blizzPlate.raidIconTexture:ClearAllPoints()
    blizzPlate.raidIconTexture:SetPoint("BOTTOM",blizzPlate.newPlate,"TOP",0,-10)
    
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
    bar.point = {"CENTER",0,-16}
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
    name:SetFont(STANDARD_TEXT_FONT, 9/cfg.scale, "OUTLINE")
    name:SetPoint("BOTTOM",bar,"TOP",0,-24)
    name:SetPoint("LEFT",8,0)
    name:SetPoint("RIGHT",-8,0)
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

    bar.nameString:SetFont(STANDARD_TEXT_FONT, 9/cfg.scale, "OUTLINE")
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

  local function CreateSizer(blizzPlate,newPlate)
    local sizer = CreateFrame("Frame", nil, newPlate)
    sizer:SetPoint("BOTTOMLEFT", WorldFrame)
    sizer:SetPoint("TOPRIGHT", blizzPlate, "CENTER")
    sizer:SetScript("OnSizeChanged", function(self, x, y)
      if blizzPlate:IsShown() then
        newPlate:Hide() -- Important, never move the frame while it"s visible
        newPlate:SetPoint("CENTER", WorldFrame, "BOTTOMLEFT", x, y) -- Immediately reposition frame
        newPlate:Show()
      end
    end)
  end

  local function CreateNewPlate()
    local newPlate = CreateFrame("Frame", nil, WorldFrame)
    newPlate.id = namePlateIndex
    newPlate:SetSize(36,36)
    return newPlate
  end

  local function NamePlateOnShow(blizzPlate)
    NamePlateSetup(blizzPlate)
    blizzPlate.newPlate:Show()
  end

  local function NamePlateOnHide(blizzPlate)
    blizzPlate.newPlate:Hide()
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

  local function NamePlateCastBarOnHide(castBar)

  end

  local function SkinPlate(blizzPlate)
    if plates[blizzPlate] then return end

    local newPlate = CreateNewPlate()
    blizzPlate.newPlate = newPlate

    NamePlateOnInit(blizzPlate)

    SkinHealthBar(blizzPlate)
    SkinCastBar(blizzPlate)

    CreateSizer(blizzPlate,newPlate)

    NamePlateSetup(blizzPlate)

    blizzPlate:HookScript("OnShow", NamePlateOnShow)
    blizzPlate:HookScript("OnHide", NamePlateOnHide)

    blizzPlate.castBar:HookScript("OnShow", NamePlateCastBarOnShow)
    blizzPlate.castBar:HookScript("OnHide", NamePlateCastBarOnHide)
    blizzPlate.castBar:HookScript("OnValueChanged", NamePlateCastBarOnValueChanged)

    namePlateIndex = namePlateIndex+1
    plates[blizzPlate] = newPlate
  end

  -----------------------------
  -- ONUPDATE
  -----------------------------

  WorldFrame:HookScript("OnUpdate", function(self)
    for blizzPlate, newPlate in next, plates do
      if blizzPlate:IsShown() then
        newPlate:SetAlpha(blizzPlate:GetAlpha())
      end
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