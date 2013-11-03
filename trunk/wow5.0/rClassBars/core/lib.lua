
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

    local cur = UnitPower(unit, bar.POWER_TYPE_INDEX)
    local max = UnitPowerMax(unit, bar.POWER_TYPE_INDEX)

    --adjust the width of the bar frame
    local w = 64*(max+2)
    bar:SetWidth(w)
    for i = 1, bar.MAX_ORBS do
      local orb = bar.orbs[i]
      if i > max then
         if orb:IsShown() then orb:Hide() end
      else
        if not orb:IsShown() then orb:Show() end
      end
    end
    for i = 1, max do
      local orb = bar.orbs[i]
      if(i <= cur) then
        if cur == max then
          orb.fill:SetVertexColor(1,0,0)
          orb.glow:SetVertexColor(1,0,0)
        else
          orb.fill:SetVertexColor(bar.color.r,bar.color.g,bar.color.b)
          orb.glow:SetVertexColor(bar.color.r,bar.color.g,bar.color.b)
        end
        orb.fill:Show()
        orb.glow:Show()
        orb.highlight:Show()
      else
        orb.fill:Hide()
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
    bar.MAX_ORBS          = cfg.MAX_ORBS or 5
    bar.ORB_TEXTURE       = cfg.ORB_TEXTURE or "orb"
    bar.POWER_TYPE_INDEX  = cfg.POWER_TYPE_INDEX
    bar.POWER_TYPE_TOKEN  = cfg.POWER_TYPE_TOKEN
    bar.REQ_SPEC          = cfg.REQ_SPEC
    bar.REQ_SPELL         = cfg.REQ_SPELL
    bar.color             = cfg.color
    
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

    bar.orbs = {}

    for i = 1, bar.MAX_ORBS do

      local orb = CreateFrame("Frame",nil,bar)
      bar.orbs[i] = orb

      orb:SetSize(64,64)
      orb:SetPoint("LEFT",i*64,0)

      local orbSizeMultiplier = 0.95

      --bar background
      orb.barBg = orb:CreateTexture(nil,"BACKGROUND",nil,-8)
      orb.barBg:SetSize(64,64)
      orb.barBg:SetPoint("CENTER")
      orb.barBg:SetTexture(mediaPath.."combo_bar_bg")

      --orb background
      orb.bg = orb:CreateTexture(nil,"BACKGROUND",nil,-7)
      orb.bg:SetSize(128*orbSizeMultiplier,128*orbSizeMultiplier)
      orb.bg:SetPoint("CENTER")
      orb.bg:SetTexture(mediaPath.."combo_"..bar.ORB_TEXTURE.."_bg")

      --orb filling
      orb.fill = orb:CreateTexture(nil,"BACKGROUND",nil,-6)
      orb.fill:SetSize(128*orbSizeMultiplier,128*orbSizeMultiplier)
      orb.fill:SetPoint("CENTER")
      orb.fill:SetTexture(mediaPath.."combo_"..bar.ORB_TEXTURE.."_fill")
      orb.fill:SetVertexColor(bar.color.r,bar.color.g,bar.color.b)
      --orb.fill:SetBlendMode("ADD")

      --orb border
      orb.border = orb:CreateTexture(nil,"BACKGROUND",nil,-5)
      orb.border:SetSize(128*orbSizeMultiplier,128*orbSizeMultiplier)
      orb.border:SetPoint("CENTER")
      orb.border:SetTexture(mediaPath.."combo_"..bar.ORB_TEXTURE.."_border")

      --orb glow
      orb.glow = orb:CreateTexture(nil,"BACKGROUND",nil,-4)
      orb.glow:SetSize(128*orbSizeMultiplier,128*orbSizeMultiplier)
      orb.glow:SetPoint("CENTER")
      orb.glow:SetTexture(mediaPath.."combo_"..bar.ORB_TEXTURE.."_glow")
      orb.glow:SetVertexColor(bar.color.r,bar.color.g,bar.color.b)
      orb.glow:SetBlendMode("BLEND")

      --orb highlight
      orb.highlight = orb:CreateTexture(nil,"BACKGROUND",nil,-3)
      orb.highlight:SetSize(128*orbSizeMultiplier,128*orbSizeMultiplier)
      orb.highlight:SetPoint("CENTER")
      orb.highlight:SetTexture(mediaPath.."combo_"..bar.ORB_TEXTURE.."_highlight")

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