
  ---------------------------------------------
  -- SOULSHARDS.lua
  ---------------------------------------------

  --check class for warlock
  if select(2, UnitClass("player")) ~= "WARLOCK" then return end
  --get the addon namespace
  local addonName, ns = ...
  --check if module is enabled
  if not ns.cfg.modules.soulshards then return end

  ---------------------------------------------
  -- VARIABLES
  ---------------------------------------------

  local POWER_TYPE_INDEX = SPELL_POWER_SOUL_SHARDS -- 7
  local POWER_TYPE_TOKEN = "SOUL_SHARDS"
  local REQ_SPEC         = SPEC_WARLOCK_AFFLICTION -- 1
  local REQ_SPELL        = WARLOCK_SOULBURN

  --textures needed
  --combo_left, combo_right, combo_bar_bg, combo_gem_bg, combo_gem_fill1, combo_gem_border, combo_gem_glow, combo_gem_highlight
  local mediaPath = "Interface\\AddOns\\"..addonName.."\\media\\"
  local barName   = addonName.."SoulShardBar"

  ---------------------------------------------
  -- FUNCTIONS
  ---------------------------------------------

  --update shoulshard bar func
  local function UpdateBar(bar, event, unit, powerType)
    if not bar:IsShown() then return end
    if not unit or (unit and unit ~= bar.unit) then return end
    if powerType and powerType ~= POWER_TYPE_TOKEN then return end

    local cur = UnitPower(unit, POWER_TYPE_INDEX)
    local max = UnitPowerMax(unit, POWER_TYPE_INDEX)
    --[[ --do not hide the bar when the value is empty, keep it visible
    if cur < 1 then
      if bar:IsShown() then bar:Hide() end
      return
    else
      if not bar:IsShown() then bar:Show() end
    end
    ]]
    --adjust the width of the bar frame
    local w = 64*(max+2)
    bar:SetWidth(w)
    for i = 1, bar.maxOrbs do
      local orb = bar.orbs[i]
      if i > max then
         if orb:IsShown() then orb:Hide() end
      else
        if not orb:IsShown() then orb:Show() end
      end
    end
    for i = 1, max do
      local orb = bar.orbs[i]
      local full = cur/max
      if(i <= cur) then
        if full == 1 then
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
  
  local function OnAttributeChanged(self,name,value)
    if name == "switch" then
      if value == "1" then
        self:Show()
      else
        self:Hide()
      end
    end
  end
  
  local function OnEvent(...)
    local self, event = ...
    if event == "SPELLS_CHANGED" then
      if InCombatLockdown() then return end
      if IsPlayerSpell(REQ_SPELL) and GetSpecialization() ==  REQ_SPEC then
        self:SetAttribute("switch","1")
      else
        self:SetAttribute("switch","0")
      end
    else
      UpdateBar(...)
    end
  end
  

  --create bar func
  local function CreateBar()

    local bar = CreateFrame("Frame", barName, ns.PetbattleVehicleHider)
    
    bar.maxOrbs = 4
    local w = 64*(bar.maxOrbs+2) --create the bar for
    local h = 64
    bar:SetPoint("CENTER", UIParent, "CENTER", 0,0)
    bar:SetWidth(w)
    bar:SetHeight(h)
    bar:SetScale(0.4)

    --color
    bar.color = {r = 200/255, g = 0/255, b = 255/255, }

    --left edge
    local t = bar:CreateTexture(nil,"BACKGROUND",nil,-8)
    t:SetSize(64,64)
    t:SetPoint("LEFT")
    t:SetTexture(mediaPath.."combo_left")
    bar.leftEdge = t

    --right edge
    t = bar:CreateTexture(nil,"BACKGROUND",nil,-8)
    t:SetSize(64,64)
    t:SetPoint("RIGHT")
    t:SetTexture(mediaPath.."combo_right")
    bar.rightEdge = t
    
    bar.orbs = {}

    for i = 1, bar.maxOrbs do

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
      orb.bg:SetTexture(mediaPath.."combo_gem_bg")

      --orb filling
      orb.fill = orb:CreateTexture(nil,"BACKGROUND",nil,-6)
      orb.fill:SetSize(128*orbSizeMultiplier,128*orbSizeMultiplier)
      orb.fill:SetPoint("CENTER")
      orb.fill:SetTexture(mediaPath.."combo_gem_fill")
      orb.fill:SetVertexColor(bar.color.r,bar.color.g,bar.color.b)
      --orb.fill:SetBlendMode("ADD")

      --orb border
      orb.border = orb:CreateTexture(nil,"BACKGROUND",nil,-5)
      orb.border:SetSize(128*orbSizeMultiplier,128*orbSizeMultiplier)
      orb.border:SetPoint("CENTER")
      orb.border:SetTexture(mediaPath.."combo_gem_border")

      --orb glow
      orb.glow = orb:CreateTexture(nil,"BACKGROUND",nil,-4)
      orb.glow:SetSize(128*orbSizeMultiplier,128*orbSizeMultiplier)
      orb.glow:SetPoint("CENTER")
      orb.glow:SetTexture(mediaPath.."combo_gem_glow")
      orb.glow:SetVertexColor(bar.color.r,bar.color.g,bar.color.b)
      orb.glow:SetBlendMode("BLEND")

      --orb highlight
      orb.highlight = orb:CreateTexture(nil,"BACKGROUND",nil,-3)
      orb.highlight:SetSize(128*orbSizeMultiplier,128*orbSizeMultiplier)
      orb.highlight:SetPoint("CENTER")
      orb.highlight:SetTexture(mediaPath.."combo_gem_highlight")

    end

    bar.unit = "player"
    bar:RegisterUnitEvent("UNIT_POWER_FREQUENT", bar.unit)
    bar:RegisterUnitEvent("UNIT_DISPLAYPOWER", bar.unit)
    bar:RegisterEvent("SPELLS_CHANGED")
    bar:SetScript("OnEvent", OnEvent)
    bar:SetScript("OnAttributeChanged", OnAttributeChanged)

    ns.lib:AddSimpleDrag(bar)

  end

  ---------------------------------------------
  -- INIT
  ---------------------------------------------

  --init
  CreateBar()
