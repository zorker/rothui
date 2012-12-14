
  --do not load the addon
  if select(2,UnitClass("player")) ~= "WARRIOR" then return end

  ---------------------------------------
  -- INIT
  ---------------------------------------

  local cfg = {
    frame = {
      width = 30,
      height = 18,
      pos = { a1 = "BOTTOM", af = "UIParent", a2 = "BOTTOM", x = 44, y = 190, },
    },
    bg = {
      color = {0,0,0,0},
    },
    value = {
      font = STANDARD_TEXT_FONT,
      size = 15,
      outline = "THINOUTLINE",
      color = {1,0.9,0.5,0.9},
      pos = { a1 = "CENTER", x = 0, y = 0, },
    },
  }

  --petbattle handler
  local visibilityHandler = CreateFrame("Frame", nil, UIParent, "SecureHandlerStateTemplate")
  RegisterStateDriver(visibilityHandler, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show")

  --addon frame
  local f = CreateFrame("FRAME", "rShieldBarrierValue", visibilityHandler, "SecureHandlerStateTemplate")

  local SPELL_POWER_RAGE = SPELL_POWER_RAGE

  -----------------------------
  -- FUNCTIONS
  -----------------------------

  --number format func
  local numFormat = function(v)
    if v > 1E10 then
      return (floor(v/1E9)).."b"
    elseif v > 1E9 then
      return (floor((v/1E9)*10)/10).."b"
    elseif v > 1E7 then
      return (floor(v/1E6)).."m"
    elseif v > 1E6 then
      return (floor((v/1E6)*10)/10).."m"
    elseif v > 1E4 then
      return (floor(v/1E3)).."k"
    elseif v > 1E3 then
      return (floor((v/1E3)*10)/10).."k"
    else
      return v
    end
  end

  local function CalculateEstimatedAbsorbValue(rage)
    local baseAttackPower, positiveBuff, negativeBuff = UnitAttackPower("player")
    local attackPower = baseAttackPower + positiveBuff + negativeBuff
    local _, strength = UnitStat("player", 1)
    local _, stamina = UnitStat("player", 3)
    local rageMultiplier = max(20, min(60, rage)) / 60.0
    local absorb = max(2 * (attackPower - 2 * strength), stamina * 2.5) * rageMultiplier
    return absorb
  end

  local function OnEvent(self, event, unit)
    if unit and unit ~= "player" then return end
    local spec = GetSpecialization() or -1
    if spec ~= 3 then
      f:Hide()
      return
    end
    f:Show()
    local rage = UnitPower("player", SPELL_POWER_RAGE)
    if not InCombatLockdown() or rage < 20 then
      f.bg:Hide()
      f.val:Hide()
      return
    end
    f.bg:Show()
    f.val:Show()
    f.val:SetText(numFormat(CalculateEstimatedAbsorbValue(rage)))

  end

  local function Create()
    f:SetSize(cfg.frame.width,cfg.frame.height)
    f:SetPoint(cfg.frame.pos.a1,cfg.frame.pos.af,cfg.frame.pos.a2,cfg.frame.pos.x,cfg.frame.pos.y)

    local bg = f:CreateTexture(nil, "BACKGROUND", nil, -8)
    bg:SetAllPoints(f)
    bg:SetTexture(unpack(cfg.bg.color))
    f.bg = bg

    local val = f:CreateFontString(nil, "BORDER")
    val:SetPoint(cfg.value.pos.a1,cfg.value.pos.x,cfg.value.pos.y)
    val:SetFont(cfg.value.font, cfg.value.size, cfg.value.outline)
    val:SetTextColor(unpack(cfg.value.color))
    val:SetJustifyH("CENTER")
    f.val = val

  end

  -----------------------------
  -- INIT / CALL
  -----------------------------

  Create()

  f:RegisterEvent("PLAYER_REGEN_ENABLED")
  f:RegisterEvent("PLAYER_REGEN_DISABLED")
  f:RegisterEvent("PLAYER_ENTERING_WORLD")
  f:RegisterEvent("PLAYER_TALENT_UPDATE")
  f:RegisterUnitEvent("UNIT_STATS", "player")
  f:RegisterUnitEvent("UNIT_POWER", "player")
  f:RegisterUnitEvent("UNIT_ATTACK_POWER", "player")

  f:SetScript("OnEvent", OnEvent)