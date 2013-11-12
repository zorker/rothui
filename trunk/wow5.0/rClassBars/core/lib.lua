
  ---------------------------------------------
  -- LIB.lua
  ---------------------------------------------

  --get the addon namespace
  local addonName, ns = ...
  --library frame
  local lib = CreateFrame("Frame")
  --make the library available in the namespace
  ns.lib = lib

  ---------------------------------------------
  -- VARIABLES
  ---------------------------------------------

  --petbattle hider
  local PetbattleVehicleHider = CreateFrame("Frame", nil, UIParent)
  RegisterStateDriver(PetbattleVehicleHider, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show")
  ns.PetbattleVehicleHider = PetbattleVehicleHider

  local mediaPath = "Interface\\AddOns\\"..addonName.."\\media\\"

  ---------------------------------------------
  -- FUNCTIONS
  ---------------------------------------------

  --update orb type bar func
  local function UpdateOrbBar(bar, event, unit, powerType)

    if not bar:IsShown() then return end
    if not unit or (unit and unit ~= bar.unit) then return end
    if powerType and powerType ~= bar.POWER_TYPE_TOKEN then return end

    local up = UnitPower(unit, bar.POWER_TYPE_INDEX)
    local upm = UnitPowerMax(unit, bar.POWER_TYPE_INDEX)
    local up2 = UnitPower(unit, bar.POWER_TYPE_INDEX, true)
    local upm2 = UnitPowerMax(unit, bar.POWER_TYPE_INDEX, true)
    local maxPerOrb = upm2/upm
    local val = up2-up*maxPerOrb
    
    --adjust the width of the bar frame
    local w = 64*(upm+2)
    bar:SetWidth(w)
    for i = 1, bar.MAX_ORBS do
      local orb = bar.orbs[i]
      if i > upm then
         if orb:IsShown() then orb:Hide() end
      else
        if not orb:IsShown() then orb:Show() end
      end
    end
    local valueApplied = false
    for i = 1, upm do
      local orb = bar.orbs[i]
      orb.fill:SetMinMaxValues(0, maxPerOrb)
      if(i <= up) then
        if up == upm then
          orb.fill:SetStatusBarColor(1,0,0)
          orb.glow:SetVertexColor(1,0,0)
        else
          orb.fill:SetStatusBarColor(bar.color.r,bar.color.g,bar.color.b)
          orb.glow:SetVertexColor(bar.color.r,bar.color.g,bar.color.b)
        end
        orb.fill:SetValue(maxPerOrb)
        orb.fill:Show()
        orb.glow:Show()
        orb.highlight:Show()
      else
        if not valueApplied then
          orb.fill:SetStatusBarColor(bar.color.r,bar.color.g,bar.color.b)
          orb.fill:SetValue(val)
          orb.fill:Show()
          valueApplied = true
        else
          orb.fill:Hide()        
        end
        orb.glow:Hide()
        orb.highlight:Hide()
      end
    end

  end

  --onevent orb type bar func
  local function OnEventOrbBar(...)
    local bar, event = ...
    if event == "UNIT_POWER_FREQUENT" then
      UpdateOrbBar(...)
    else
      --spell check
      if bar.REQ_SPELL then
        if IsPlayerSpell(bar.REQ_SPELL) then
          bar:Show()
        else
          bar:Hide()
        end
      --spec check
      elseif bar.REQ_SPEC then
        if GetSpecialization() ==  bar.REQ_SPEC then
          bar:Show()
        else
          bar:Hide()
        end
      end
      UpdateOrbBar(bar,event,bar.unit,bar.POWER_TYPE_TOKEN)
    end
  end

  --create orb type bar func
  function lib.CreateOrbBar(name, cfg)
    if not cfg then return end

    --create bar
    local bar = CreateFrame("Frame", name, ns.PetbattleVehicleHider)

    --variables
    bar.MAX_ORBS              = cfg.MAX_ORBS or 5
    bar.ORB_TEXTURE           = cfg.ORB_TEXTURE or "orb"
    bar.ORB_SIZE_FACTOR       = cfg.ORB_SIZE_FACTOR or 0.9
    bar.ORB_FILL_SIZE_FACTOR  = cfg.ORB_FILL_SIZE_FACTOR or 0.9
    bar.MAX_ORB_POWER         = cfg.MAX_ORB_POWER or 1
    bar.POWER_TYPE_INDEX      = cfg.POWER_TYPE_INDEX
    bar.POWER_TYPE_TOKEN      = cfg.POWER_TYPE_TOKEN
    bar.REQ_SPEC              = cfg.REQ_SPEC
    bar.REQ_SPELL             = cfg.REQ_SPELL
    bar.color                 = cfg.color
    bar.orbs                  = {}

    --bar settings
    local w = 64*(bar.MAX_ORBS+2) --create the bar for
    local h = 64
    bar:SetPoint("CENTER", UIParent, "CENTER", 0,0)
    bar:SetWidth(w)
    bar:SetHeight(h)
    bar:SetScale(cfg.scale or 1)

    --left edge
    local t = bar:CreateTexture(nil,"BACKGROUND",nil,-8)
    t:SetSize(64,64)
    t:SetPoint("LEFT")
    t:SetTexture(mediaPath.."combo_bar_left")
    bar.leftEdge = t

    --right edge
    t = bar:CreateTexture(nil,"BACKGROUND",nil,-8)
    t:SetSize(64,64)
    t:SetPoint("RIGHT")
    t:SetTexture(mediaPath.."combo_bar_right")
    bar.rightEdge = t

    for i = 1, bar.MAX_ORBS do

      local orb = CreateFrame("Frame",nil,bar)
      orb:SetSize(64,64)
      orb:SetPoint("LEFT",i*64,0)

      --bar background
      orb.barBg = orb:CreateTexture(nil,"BACKGROUND",nil,-8)
      orb.barBg:SetSize(64,64)
      orb.barBg:SetPoint("CENTER")
      orb.barBg:SetTexture(mediaPath.."combo_bar_bg")

      --orb background
      orb.bg = orb:CreateTexture(nil,"BACKGROUND",nil,-7)
      orb.bg:SetSize(128*bar.ORB_SIZE_FACTOR,128*bar.ORB_SIZE_FACTOR)
      orb.bg:SetPoint("CENTER")
      orb.bg:SetTexture(mediaPath.."combo_"..bar.ORB_TEXTURE.."_bg")

      --orb border
      orb.border = orb:CreateTexture(nil,"BACKGROUND",nil,-5)
      orb.border:SetSize(128*bar.ORB_SIZE_FACTOR,128*bar.ORB_SIZE_FACTOR)
      orb.border:SetPoint("CENTER")
      orb.border:SetTexture(mediaPath.."combo_"..bar.ORB_TEXTURE.."_border")
      
      --orb filling statusbar
      orb.fill = CreateFrame("StatusBar",nil,orb)
      orb.fill:SetStatusBarTexture(mediaPath.."combo_"..bar.ORB_TEXTURE.."_fill")
      orb.fill:SetOrientation("VERTICAL")
      orb.fill:SetMinMaxValues(0, bar.MAX_ORB_POWER)
      orb.fill:SetValue(bar.MAX_ORB_POWER)
      orb.fill:SetSize(64*bar.ORB_FILL_SIZE_FACTOR,64*bar.ORB_FILL_SIZE_FACTOR)
      orb.fill:SetPoint("CENTER")
      orb.fill:SetStatusBarColor(bar.color.r,bar.color.g,bar.color.b)

      --frame stacking helper
      orb.overlay = CreateFrame("Frame",nil,orb.fill)
      orb.overlay:SetAllPoints(orb)

      --orb glow
      orb.glow = orb.overlay:CreateTexture(nil,"BACKGROUND",nil,-4)
      orb.glow:SetSize(128*bar.ORB_SIZE_FACTOR,128*bar.ORB_SIZE_FACTOR)
      orb.glow:SetPoint("CENTER")
      orb.glow:SetTexture(mediaPath.."combo_"..bar.ORB_TEXTURE.."_glow")
      orb.glow:SetVertexColor(bar.color.r,bar.color.g,bar.color.b)
      orb.glow:SetBlendMode("BLEND")

      --orb highlight
      orb.highlight = orb.overlay:CreateTexture(nil,"BACKGROUND",nil,-3)
      orb.highlight:SetSize(128*bar.ORB_SIZE_FACTOR,128*bar.ORB_SIZE_FACTOR)
      orb.highlight:SetPoint("CENTER")
      orb.highlight:SetTexture(mediaPath.."combo_"..bar.ORB_TEXTURE.."_highlight")

      bar.orbs[i] = orb

    end

    bar.unit = "player"
    bar:RegisterUnitEvent("UNIT_POWER_FREQUENT", bar.unit)
    bar:RegisterUnitEvent("UNIT_DISPLAYPOWER", bar.unit)
    bar:RegisterEvent("SPELLS_CHANGED")
    bar:SetScript("OnEvent", OnEventOrbBar)

    --rlib drag func
    rCreateDragFrame(bar, ns.dragFrameList, -2 , true) --frame, dragFrameList, inset, clamp
    --rlib combat fader
    if cfg.combat and cfg.combat.enable then
      rCombatFrameFader(bar, cfg.combat.fadeIn, cfg.combat.fadeOut) --frame, buttonList, fadeIn, fadeOut
    end

  end
  
  --update statusbar type bar func
  local function UpdateStatusBar(bar, event, unit, powerType)
    if not bar:IsShown() then return end
    if not unit or (unit and unit ~= bar.unit) then return end
    if powerType and powerType ~= bar.POWER_TYPE_TOKEN then return end
    local up = UnitPower(unit, bar.POWER_TYPE_INDEX)
    local upm = UnitPowerMax(unit, bar.POWER_TYPE_INDEX)    
    bar.fill:SetMinMaxValues(0, upm)
    bar.fill:SetValue(up)
    if up == upm then
      bar.glow:Show()
    else
      bar.glow:Hide()
    end
  end
  
  --onevent statusbar type bar func
  local function OnEventStatusBar(...)
    local bar, event = ...
    if event == "UNIT_POWER_FREQUENT" then
      UpdateStatusBar(...)
    else
      --spell check
      if bar.REQ_SPELL then
        if IsPlayerSpell(bar.REQ_SPELL) then
          bar:Show()
        else
          bar:Hide()
        end
      --spec check
      elseif bar.REQ_SPEC then
        if GetSpecialization() ==  bar.REQ_SPEC then
          bar:Show()
        else
          bar:Hide()
        end
      end
      UpdateStatusBar(bar,event,bar.unit,bar.POWER_TYPE_TOKEN)
    end
  end
  
  --create statusbar type bar func
  function lib.CreateStatusBar(name, cfg)
    if not cfg then return end

    --create bar
    local bar = CreateFrame("Frame", name, ns.PetbattleVehicleHider)

    --variables
    bar.BAR_TEXTURE           = cfg.BAR_TEXTURE or "demonicfury"
    bar.BAR_WIDTH             = cfg.BAR_WIDTH or 256
    bar.BAR_HEIGHT            = cfg.BAR_HEIGHT or 32
    bar.BAR_OFFSET_X          = cfg.BAR_OFFSET_X or 17
    bar.BAR_OFFSET_Y          = cfg.BAR_OFFSET_X or 5
    bar.POWER_TYPE_INDEX      = cfg.POWER_TYPE_INDEX
    bar.POWER_TYPE_TOKEN      = cfg.POWER_TYPE_TOKEN
    bar.REQ_SPEC              = cfg.REQ_SPEC
    bar.REQ_SPELL             = cfg.REQ_SPELL
    bar.color                 = cfg.color
    bar.bgColor               = cfg.bgColor or {r=0.2,g=0.2,b=0.2,}

    --bar settings
    bar:SetPoint("CENTER", UIParent, "CENTER", 0,0)
    bar:SetWidth(bar.BAR_WIDTH)
    bar:SetHeight(bar.BAR_HEIGHT)
    bar:SetScale(cfg.scale or 1)

    --bar filling statusbar
    bar.fill = CreateFrame("StatusBar",nil,bar)
    bar.fill:SetStatusBarTexture(mediaPath.."statusbar_fill_"..bar.BAR_TEXTURE)
    bar.fill:SetMinMaxValues(0, 1)
    bar.fill:SetValue(0)
    bar.fill:SetPoint("TOPLEFT",bar.BAR_OFFSET_X,-bar.BAR_OFFSET_Y)
    bar.fill:SetPoint("BOTTOMRIGHT",-bar.BAR_OFFSET_X,bar.BAR_OFFSET_Y)
    bar.fill:SetStatusBarColor(bar.color.r,bar.color.g,bar.color.b)
    
    --bar background
    bar.fill.bg = bar.fill:CreateTexture(nil,"BACKGROUND",nil,-7)
    bar.fill.bg:SetAllPoints()
    bar.fill.bg:SetTexture(mediaPath.."statusbar_fill_"..bar.BAR_TEXTURE)
    bar.fill.bg:SetVertexColor(bar.bgColor.r,bar.bgColor.g,bar.bgColor.b)

    --frame stacking helper
    bar.overlay = CreateFrame("Frame",nil,bar.fill)
    bar.overlay:SetAllPoints(bar)
    
    --bar border
    bar.border = bar.overlay:CreateTexture(nil,"BACKGROUND",nil,-5)
    bar.border:SetAllPoints()
    bar.border:SetTexture(mediaPath.."statusbar_border_"..bar.BAR_TEXTURE)

    --bar glow
    bar.glow = bar.overlay:CreateTexture(nil,"BACKGROUND",nil,-4)
    bar.glow:SetPoint("CENTER")
    bar.glow:SetWidth(bar.BAR_WIDTH*2)
    bar.glow:SetHeight(bar.BAR_HEIGHT*2)
    bar.glow:SetTexture(mediaPath.."statusbar_glow_"..bar.BAR_TEXTURE)
    bar.glow:SetVertexColor(bar.color.r,bar.color.g,bar.color.b)
    bar.glow:SetBlendMode("BLEND")

    bar.unit = "player"
    bar:RegisterUnitEvent("UNIT_POWER_FREQUENT", bar.unit)
    bar:RegisterUnitEvent("UNIT_DISPLAYPOWER", bar.unit)
    bar:RegisterEvent("SPELLS_CHANGED")
    bar:SetScript("OnEvent", OnEventStatusBar)

    --rlib drag func
    rCreateDragFrame(bar, ns.dragFrameList, -2 , true) --frame, dragFrameList, inset, clamp
    --rlib combat fader
    if cfg.combat and cfg.combat.enable then
      rCombatFrameFader(bar, cfg.combat.fadeIn, cfg.combat.fadeOut) --frame, buttonList, fadeIn, fadeOut
    end

  end