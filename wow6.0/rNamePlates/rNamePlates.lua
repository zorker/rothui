
  -- // rNamePlates
  -- // zork - 2014

  -----------------------------
  -- VARIABLES
  -----------------------------

  local an, at = ...
  local plates, namePlateIndex, _G, string, WorldFrame, unpack = {}, nil, _G, string, WorldFrame, unpack

  -----------------------------
  -- CONFIG
  -----------------------------

  local cfg = {}
  cfg.scale = 0.35
  cfg.fontsize = 9
  cfg.point = {"CENTER",0,-16} --position of the healthbar on newPlate, everything else will relate to that (newPlate is centered on blizzPlate)

  -----------------------------
  -- FUNCTIONS
  -----------------------------

  --pastebin frame
  local trash = CreateFrame("Frame")
  trash:Hide()

  --GetHexColorFromRGB
  local function GetHexColorFromRGB(r, g, b)
    return string.format("%02x%02x%02x", r*255, g*255, b*255)
  end

  --NamePlateSetup func
  local function NamePlateSetup(blizzPlate)
    --make sure the nameplate textures stay hidden
    blizzPlate.borderTexture:SetTexture(nil)
    blizzPlate.bossIconTexture:SetTexture(nil)
    blizzPlate.eliteDragonTexture:SetTexture(nil)
    blizzPlate.highlightTexture:SetTexture(nil)
    --position threat glow
    blizzPlate.threatTexture:ClearAllPoints()
    blizzPlate.threatTexture:SetPoint("TOPLEFT",blizzPlate.healthBar,-2,2)
    blizzPlate.threatTexture:SetPoint("BOTTOMRIGHT",blizzPlate.healthBar,2,-2)
    --position healthbar
    blizzPlate.healthBar:SetSize(unpack(blizzPlate.healthBar.size))
    blizzPlate.healthBar:ClearAllPoints()
    blizzPlate.healthBar:SetPoint(unpack(blizzPlate.healthBar.point))
    --setup name and level strings
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

  --NamePlateOnInit func
  local function NamePlateOnInit(blizzPlate)
    --get all the keys
    blizzPlate.barFrame, blizzPlate.nameFrame = blizzPlate:GetChildren()
    blizzPlate.healthBar, blizzPlate.castBar = blizzPlate.barFrame:GetChildren()
    blizzPlate.threatTexture, blizzPlate.borderTexture, blizzPlate.highlightTexture, blizzPlate.levelString, blizzPlate.bossIconTexture, blizzPlate.raidIconTexture, blizzPlate.eliteDragonTexture = blizzPlate.barFrame:GetRegions()
    blizzPlate.nameString = blizzPlate.nameFrame:GetRegions()
    blizzPlate.healthBar.statusbarTexture = blizzPlate.healthBar:GetRegions()
    blizzPlate.castBar.statusbarTexture, blizzPlate.castBar.borderTexture, blizzPlate.castBar.shieldTexture, blizzPlate.castBar.spellIconTexture, blizzPlate.castBar.nameString, blizzPlate.castBar.nameShadow = blizzPlate.castBar:GetRegions()
    --reparent frames
    blizzPlate.nameFrame:SetParent(trash)
    blizzPlate.levelString:SetParent(trash)
    blizzPlate.healthBar:SetParent(blizzPlate.newPlate)
    blizzPlate.castBar:SetParent(blizzPlate.newPlate)
    --castbar border
    blizzPlate.castBar.borderTexture:SetTexture(nil)
    --nameplate textures
    blizzPlate.borderTexture:SetTexture(nil)
    blizzPlate.bossIconTexture:SetTexture(nil)
    blizzPlate.eliteDragonTexture:SetTexture(nil)
    blizzPlate.highlightTexture:SetTexture(nil)
    --threat glow
    blizzPlate.threatTexture:SetParent(blizzPlate.newPlate)
    blizzPlate.threatTexture:SetTexture("Interface\\AddOns\\"..an.."\\media\\threat")
    blizzPlate.threatTexture:SetTexCoord(0,1,0,1)
    --blizzPlate.threatTexture:SetBlendMode("ADD")
    --raid icon
    blizzPlate.raidIconTexture:SetParent(blizzPlate.newPlate)
    blizzPlate.raidIconTexture:SetSize(25,25)
    blizzPlate.raidIconTexture:ClearAllPoints()
    blizzPlate.raidIconTexture:SetPoint("BOTTOM",blizzPlate.healthBar,"TOP",0,10)
  end

  --SkinHealthBar func
  local function SkinHealthBar(blizzPlate)

    --bar setup
    local bar = blizzPlate.healthBar
    bar.size = {256,64}
    bar.point = cfg.point
    bar:SetSize(unpack(bar.size))
    bar:SetStatusBarTexture("Interface\\AddOns\\"..an.."\\media\\statusbar_fill")
    bar:SetScale(cfg.scale)
    bar:ClearAllPoints()
    bar:SetPoint(unpack(bar.point))

    --new left edge texture
    local le = bar:CreateTexture(nil,"BACKGROUND",nil,-8)
    le:SetTexture("Interface\\AddOns\\"..an.."\\media\\edge_left")
    le:SetSize(64,64)
    le:SetPoint("RIGHT",bar,"LEFT",0,0)

    --new right edge texture
    local re = bar:CreateTexture(nil,"BACKGROUND",nil,-8)
    re:SetTexture("Interface\\AddOns\\"..an.."\\media\\edge_right")
    re:SetSize(64,64)
    re:SetPoint("LEFT",bar,"RIGHT",0,0)

    --new bg texture
    local bg = bar:CreateTexture(nil,"BACKGROUND",nil,-8)
    bg:SetTexture("Interface\\AddOns\\"..an.."\\media\\statusbar_bg")
    bg:SetAllPoints()

    --new name shadow texture
    local shadow = bar:CreateTexture(nil,"BACKGROUND",nil,-8)
    shadow:SetTexture("Interface\\Common\\NameShadow")
    shadow:SetPoint("BOTTOM",bar,"TOP",0,-20)
    shadow:SetSize(256,32)
    shadow:SetTexCoord(1,1,1,0,0,1,0,0)
    shadow:SetAlpha(0.5)

    --new highlight frame
    local hlf = CreateFrame("Frame",nil,bar)
    hlf:SetAllPoints()
    bar.hlf = hlf

    --new highlight texture
    local hl = hlf:CreateTexture(nil,"BACKGROUND",nil,-8)
    hl:SetTexture("Interface\\AddOns\\"..an.."\\media\\statusbar_highlight")
    hl:SetAllPoints()

    --new name string
    local name = bar.hlf:CreateFontString(nil, "BORDER")
    name:SetFont(STANDARD_TEXT_FONT, cfg.fontsize/cfg.scale, "OUTLINE")
    name:SetPoint("BOTTOM",bar,"TOP",0,-24)
    name:SetPoint("LEFT",8,0)
    name:SetPoint("RIGHT",-8,0)
    name:SetText("Ich bin ein Berliner! -JFK")
    bar.name = name

  end

  --SkinCastBar func
  local function SkinCastBar(blizzPlate)

    --bar setup
    local bar = blizzPlate.castBar
    bar.size = {256,64}
    bar.point = {"TOP",blizzPlate.healthBar,"BOTTOM",0,20}
    bar:SetSize(unpack(bar.size))
    bar:SetStatusBarTexture("Interface\\AddOns\\"..an.."\\media\\statusbar_fill")
    bar:SetScale(cfg.scale)
    bar:ClearAllPoints()
    bar:SetPoint(unpack(bar.point))

    --new left edge texture
    local le = bar:CreateTexture(nil,"BACKGROUND",nil,-8)
    le:SetTexture("Interface\\AddOns\\"..an.."\\media\\edge_left")
    le:SetSize(64,64)
    le:SetPoint("RIGHT",bar,"LEFT",0,0)

    --new right edge texture
    local re = bar:CreateTexture(nil,"BACKGROUND",nil,-8)
    re:SetTexture("Interface\\AddOns\\"..an.."\\media\\edge_right")
    re:SetSize(64,64)
    re:SetPoint("LEFT",bar,"RIGHT",0,0)

    --new bg texture
    local bg = bar:CreateTexture(nil,"BACKGROUND",nil,-8)
    bg:SetTexture("Interface\\AddOns\\"..an.."\\media\\statusbar_bg")
    bg:SetAllPoints()

    --reuse name shadow
    bar.nameShadow:ClearAllPoints()
    bar.nameShadow:SetPoint("TOP",bar,"BOTTOM",0,20)
    bar.nameShadow:SetSize(256,32)

    --reuse name string
    bar.nameString:SetFont(STANDARD_TEXT_FONT, cfg.fontsize/cfg.scale, "OUTLINE")
    bar.nameString:ClearAllPoints()
    bar.nameString:SetPoint("TOP",bar,"BOTTOM",0,30)
    bar.nameString:SetPoint("LEFT",8,0)
    bar.nameString:SetPoint("RIGHT",-8,0)

    --reuse icon texture
    bar.spellIconTexture:SetDrawLayer("BACKGROUND",-8)
    bar.spellIconTexture:SetTexCoord(0.08,0.92,0.08,0.92)
    bar.spellIconTexture.point = {"RIGHT",bar,"LEFT",-58,22}
    bar.spellIconTexture:ClearAllPoints()
    bar.spellIconTexture:SetPoint(unpack(bar.spellIconTexture.point))
    bar.spellIconTexture:SetSize(60,60)

    --new icon border texture
    local iconBorder = bar:CreateTexture(nil,"BACKGROUND",nil,-7)
    iconBorder:SetTexture("Interface\\AddOns\\"..an.."\\media\\icon_border")
    iconBorder:SetPoint("CENTER",bar.spellIconTexture)
    iconBorder:SetSize(78,78)
    bar.spellIconBorder = iconBorder

    --reuse shield texture
    bar.shieldTexture:SetDrawLayer("BACKGROUND",-6)
    bar.shieldTexture:SetTexture("Interface\\AddOns\\"..an.."\\media\\shield")
    bar.shieldTexture.point = {"BOTTOM",bar.spellIconBorder,0,-5}
    bar.shieldTexture.size = {36,36}
    bar.shieldTexture:ClearAllPoints()
    bar.shieldTexture:SetPoint(unpack(bar.shieldTexture.point))
    bar.shieldTexture:SetSize(unpack(bar.shieldTexture.size))

  end

  --CreateOnSizeChangedHandler func
  local function CreateOnSizeChangedHandler(blizzPlate)
    local sizer = CreateFrame("Frame", nil, blizzPlate.newPlate)
    sizer:SetPoint("BOTTOMLEFT", WorldFrame)
    sizer:SetPoint("TOPRIGHT", blizzPlate, "CENTER")
    sizer:SetScript("OnSizeChanged", function(self, x, y)
      if blizzPlate:IsShown() then
        blizzPlate.newPlate:Hide() -- Important, never move the frame while it is visible
        blizzPlate.newPlate:SetPoint("CENTER", WorldFrame, "BOTTOMLEFT", x, y)
        blizzPlate.newPlate:Show()
      end
    end)
  end

  --CreateNewPlate func
  local function CreateNewPlate(blizzPlate)
    plates[blizzPlate] = CreateFrame("Frame", nil, WorldFrame)
    plates[blizzPlate].id = namePlateIndex
    plates[blizzPlate]:SetSize(36,36)
    blizzPlate.newPlate = plates[blizzPlate]
    CreateOnSizeChangedHandler(blizzPlate)
    NamePlateOnInit(blizzPlate)
    NamePlateSetup(blizzPlate)
  end

  --NamePlateOnShow func
  local function NamePlateOnShow(blizzPlate)
    NamePlateSetup(blizzPlate)
    blizzPlate.newPlate:Show()
  end

  --NamePlateOnHide func
  local function NamePlateOnHide(blizzPlate)
    blizzPlate.newPlate:Hide()
  end

  --NamePlateCastBarOnShow func
  local function NamePlateCastBarOnShow(castBar)
    --bar
    castBar:SetSize(unpack(castBar.size))
    castBar:ClearAllPoints()
    castBar:SetPoint(unpack(castBar.point))
    --icon
    castBar.spellIconTexture:ClearAllPoints()
    castBar.spellIconTexture:SetPoint(unpack(castBar.spellIconTexture.point))
    --icon border and shield
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

  --NamePlateCastBarOnValueChanged func
  local function NamePlateCastBarOnValueChanged(castBar)
    --bar
    castBar:ClearAllPoints()
    castBar:SetPoint(unpack(castBar.point))
    castBar:SetSize(unpack(castBar.size))
    --icon
    castBar.spellIconTexture:ClearAllPoints()
    castBar.spellIconTexture:SetPoint(unpack(castBar.spellIconTexture.point))
    --shield
    if castBar.shieldTexture:IsShown() then
      castBar.shieldTexture:ClearAllPoints()
      castBar.shieldTexture:SetPoint(unpack(castBar.shieldTexture.point))
      castBar.shieldTexture:SetSize(unpack(castBar.shieldTexture.size))
    end
  end

  --NamePlateCastBarOnHide func
  local function NamePlateCastBarOnHide(castBar)

  end

  --SkinPlate func
  local function SkinPlate(blizzPlate)
    if plates[blizzPlate] then return end
    --create the new plate
    CreateNewPlate(blizzPlate)
    --skin health and castbar
    SkinHealthBar(blizzPlate)
    SkinCastBar(blizzPlate)
    --hook some scripts
    blizzPlate:HookScript("OnShow", NamePlateOnShow)
    blizzPlate:HookScript("OnHide", NamePlateOnHide)
    blizzPlate.castBar:HookScript("OnShow", NamePlateCastBarOnShow)
    --blizzPlate.castBar:HookScript("OnHide", NamePlateCastBarOnHide)
    blizzPlate.castBar:HookScript("OnValueChanged", NamePlateCastBarOnValueChanged)
    --check
    blizzPlate.rnp_skinned = true
  end

  -----------------------------
  -- ONUPDATE
  -----------------------------

  WorldFrame:HookScript("OnUpdate", function(self)
    --set alpha values on nameplates
    for blizzPlate, newPlate in next, plates do
      if blizzPlate:IsShown() then
        newPlate:SetAlpha(blizzPlate:GetAlpha())
      end
    end
    --scan for nameplates
    if not namePlateIndex then
      --if no index is found scan the full worldframe children for NamePlate strig
      for _, blizzPlate in next, {self:GetChildren()} do
        local name = blizzPlate:GetName()
        if name and string.match(name, "^NamePlate%d+$") then
          namePlateIndex = string.gsub(name,"NamePlate","")
          break
        end
      end
    else
      --index is found, just scan for the next nameplate
      local blizzPlate = _G["NamePlate"..namePlateIndex]
      if not blizzPlate then return end
      if blizzPlate.rnp_skinned then return end
      SkinPlate(blizzPlate)
      namePlateIndex = namePlateIndex+1
    end
  end)

  --reset some outdated (yet still active) bloat variables if people run old config.wtf files
  SetCVar("bloatnameplates",0)
  SetCVar("bloatthreat",0)
  SetCVar("bloattest",0)