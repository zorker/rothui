
  --get the addon namespace
  local addon, ns = ...

  --object container
  local bars = CreateFrame("Frame")
  ns.bars = bars

  --get the functions
  local func = ns.func

  ---------------------------------------------
  -- FUNCTIONS
  ---------------------------------------------

  --create the exp bar
  bars.createExpBar = function(self)
    local cfg = self.cfg.expbar
    if not cfg.show then return end

    local w, h = 360, 5

    local f = CreateFrame("StatusBar","oUF_DiabloExpBar",self)
    f:SetFrameStrata("LOW")
    f:SetFrameLevel(5)
    f:SetSize(w,h)
    f:SetPoint(cfg.pos.a1, cfg.pos.af, cfg.pos.a2, cfg.pos.x, cfg.pos.y)
    f:SetScale(cfg.scale)
    f:SetStatusBarTexture(cfg.texture)
    f:SetStatusBarColor(cfg.color.r,cfg.color.g,cfg.color.b)

    local r = CreateFrame("StatusBar",nil,f)
    r:SetAllPoints(f)
    r:SetStatusBarTexture(cfg.texture)
    r:SetStatusBarColor(cfg.rested.color.r,cfg.rested.color.g,cfg.rested.color.b)

    func.applyDragFunctionality(f)

    local t = r:CreateTexture(nil,"BACKGROUND",nil,-8)
    t:SetAllPoints(r)
    t:SetTexture(cfg.texture)
    t:SetVertexColor(cfg.color.r,cfg.color.g,cfg.color.b,0.3)
    f.bg = t

    f:SetScript("OnEnter", function(s)
      mxp = UnitXPMax("player")
      xp = UnitXP("player")
      rxp = GetXPExhaustion()
      GameTooltip:SetOwner(s, "ANCHOR_TOP")
      GameTooltip:AddLine("Experience / Rested", 0, 1, 0.5, 1, 1, 1)
      if UnitLevel("player") ~= MAX_PLAYER_LEVEL then
        GameTooltip:AddDoubleLine(COMBAT_XP_GAIN, xp.."/"..mxp.." ("..floor((xp/mxp)*1000)/10 .."%)", cfg.color.r,cfg.color.g,cfg.color.b,1,1,1)
        if rxp then
          GameTooltip:AddDoubleLine(TUTORIAL_TITLE26, rxp .." (".. floor((rxp/mxp)*1000)/10 .."%)", cfg.rested.color.r,cfg.rested.color.g,cfg.rested.color.b,1,1,1)
        end
      end
      GameTooltip:Show()
    end)
    f:SetScript("OnLeave", function(s) GameTooltip:Hide() end)

    self.Experience = f
    self.Experience.Rested = r

  end

  --create the reputation bar
  bars.createRepBar = function(self)
    local cfg = self.cfg.repbar
    if not cfg.show then return end

    local w, h = 360, 5

    local f = CreateFrame("StatusBar","oUF_DiabloRepBar",self)
    f:SetFrameStrata("LOW")
    f:SetFrameLevel(5)
    f:SetSize(w,h)
    f:SetPoint(cfg.pos.a1, cfg.pos.af, cfg.pos.a2, cfg.pos.x, cfg.pos.y)
    f:SetScale(cfg.scale)
    f:SetStatusBarTexture(cfg.texture)
    f:SetStatusBarColor(0,0.7,0)

    func.applyDragFunctionality(f)

    local t = f:CreateTexture(nil,"BACKGROUND",nil,-8)
    t:SetAllPoints(f)
    t:SetTexture(cfg.texture)
    t:SetVertexColor(0,0.7,0)
    t:SetAlpha(0.3)
    f.bg = t

    f:SetScript("OnEnter", function(s)
      name, standing, minrep, maxrep, value = GetWatchedFactionInfo()
      GameTooltip:SetOwner(s, "ANCHOR_TOP")
      GameTooltip:AddLine("Reputation", 0, 1, 0.5, 1, 1, 1)
      if name then
        GameTooltip:AddDoubleLine(FACTION, name, FACTION_BAR_COLORS[standing].r, FACTION_BAR_COLORS[standing].g, FACTION_BAR_COLORS[standing].b,1,1,1)
        GameTooltip:AddDoubleLine(STANDING, _G["FACTION_STANDING_LABEL"..standing], FACTION_BAR_COLORS[standing].r, FACTION_BAR_COLORS[standing].g, FACTION_BAR_COLORS[standing].b,1,1,1)
        GameTooltip:AddDoubleLine(REPUTATION, value-minrep .."/"..maxrep-minrep.." ("..floor((value-minrep)/(maxrep-minrep)*1000)/10 .."%)", FACTION_BAR_COLORS[standing].r, FACTION_BAR_COLORS[standing].g, FACTION_BAR_COLORS[standing].b,1,1,1)
      end
      GameTooltip:Show()
    end)
    f:SetScript("OnLeave", function(s) GameTooltip:Hide() end)

    self.Reputation = f

  end

  --create shadow orb power bar
  bars.createShadowOrbPowerBar = function(self)

    self.ShadowOrbs = {}

    local t
    local bar = CreateFrame("Frame","oUF_DiabloShadowOrbPower",self)
    bar.maxOrbs = 3
    local w = 64*(bar.maxOrbs+2) --create the bar for
    local h = 64
    --bar:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    bar:SetPoint(self.cfg.shadoworbs.pos.a1,self.cfg.shadoworbs.pos.af,self.cfg.shadoworbs.pos.a2,self.cfg.shadoworbs.pos.x,self.cfg.shadoworbs.pos.y)
    bar:SetWidth(w)
    bar:SetHeight(h)

    --color
    bar.color = self.cfg.shadoworbs.color

    --left edge
    t = bar:CreateTexture(nil,"BACKGROUND",nil,-8)
    t:SetSize(64,64)
    t:SetPoint("LEFT",0,0)
    t:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_left")
    bar.leftEdge = t

    --right edge
    t = bar:CreateTexture(nil,"BACKGROUND",nil,-8)
    t:SetSize(64,64)
    t:SetPoint("RIGHT",0,0)
    t:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_right")
    bar.rightEdge = t

    for i = 1, bar.maxOrbs do

      local orb = CreateFrame("Frame",nil,bar)
      self.ShadowOrbs[i] = orb

      orb:SetSize(64,64)
      orb:SetPoint("LEFT",i*64,0)

      local orbSizeMultiplier = 0.85

      --bar background
      orb.barBg = orb:CreateTexture(nil,"BACKGROUND",nil,-8)
      orb.barBg:SetSize(64,64)
      orb.barBg:SetPoint("CENTER")
      orb.barBg:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_bar_bg")

      --orb background
      orb.bg = orb:CreateTexture(nil,"BACKGROUND",nil,-7)
      orb.bg:SetSize(128*orbSizeMultiplier,128*orbSizeMultiplier)
      orb.bg:SetPoint("CENTER")
      orb.bg:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_orb_bg")

      --orb filling
      orb.fill = orb:CreateTexture(nil,"BACKGROUND",nil,-6)
      orb.fill:SetSize(128*orbSizeMultiplier,128*orbSizeMultiplier)
      orb.fill:SetPoint("CENTER")
      orb.fill:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_orb_fill1")
      orb.fill:SetVertexColor(self.cfg.shadoworbs.color.r,self.cfg.shadoworbs.color.g,self.cfg.shadoworbs.color.b)
      --orb.fill:SetBlendMode("ADD")

      --orb border
      orb.border = orb:CreateTexture(nil,"BACKGROUND",nil,-5)
      orb.border:SetSize(128*orbSizeMultiplier,128*orbSizeMultiplier)
      orb.border:SetPoint("CENTER")
      orb.border:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_orb_border")

      --orb glow
      orb.glow = orb:CreateTexture(nil,"BACKGROUND",nil,-4)
      orb.glow:SetSize(128*orbSizeMultiplier,128*orbSizeMultiplier)
      orb.glow:SetPoint("CENTER")
      orb.glow:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_orb_glow")
      orb.glow:SetVertexColor(self.cfg.shadoworbs.color.r,self.cfg.shadoworbs.color.g,self.cfg.shadoworbs.color.b)
      orb.glow:SetBlendMode("BLEND")

      --orb highlight
      orb.highlight = orb:CreateTexture(nil,"BACKGROUND",nil,-3)
      orb.highlight:SetSize(128*orbSizeMultiplier,128*orbSizeMultiplier)
      orb.highlight:SetPoint("CENTER")
      orb.highlight:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_orb_highlight")

    end

    bar:SetScale(self.cfg.shadoworbs.scale)
    func.applyDragFunctionality(bar)
    --combat fading
    if self.cfg.shadoworbs.combat.enable then
      rCombatFrameFader(bar, self.cfg.shadoworbs.combat.fadeIn, self.cfg.shadoworbs.combat.fadeOut) --frame, buttonList, fadeIn, fadeOut
    end

    self.ShadowOrbPowerBar = bar

  end

  --create harmony power bar
  bars.createHarmonyPowerBar = function(self)

    self.Harmony = {}

    local t
    local bar = CreateFrame("Frame","oUF_DiabloHarmonyPower",self)
    bar.maxOrbs = 5
    local w = 64*(bar.maxOrbs+2) --create the bar for
    local h = 64
    --bar:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    bar:SetPoint(self.cfg.harmony.pos.a1,self.cfg.harmony.pos.af,self.cfg.harmony.pos.a2,self.cfg.harmony.pos.x,self.cfg.harmony.pos.y)
    bar:SetWidth(w)
    bar:SetHeight(h)

    --color
    bar.color = self.cfg.harmony.color

    --left edge
    t = bar:CreateTexture(nil,"BACKGROUND",nil,-8)
    t:SetSize(64,64)
    t:SetPoint("LEFT",0,0)
    t:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_left")
    bar.leftEdge = t

    --right edge
    t = bar:CreateTexture(nil,"BACKGROUND",nil,-8)
    t:SetSize(64,64)
    t:SetPoint("RIGHT",0,0)
    t:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_right")
    bar.rightEdge = t

    for i = 1, bar.maxOrbs do

      local orb = CreateFrame("Frame",nil,bar)
      self.Harmony[i] = orb

      orb:SetSize(64,64)
      orb:SetPoint("LEFT",i*64,0)

      local orbSizeMultiplier = 0.85

      --bar background
      orb.barBg = orb:CreateTexture(nil,"BACKGROUND",nil,-8)
      orb.barBg:SetSize(64,64)
      orb.barBg:SetPoint("CENTER")
      orb.barBg:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_bar_bg")

      --orb background
      orb.bg = orb:CreateTexture(nil,"BACKGROUND",nil,-7)
      orb.bg:SetSize(128*orbSizeMultiplier,128*orbSizeMultiplier)
      orb.bg:SetPoint("CENTER")
      orb.bg:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_orb_bg")

      --orb filling
      orb.fill = orb:CreateTexture(nil,"BACKGROUND",nil,-6)
      orb.fill:SetSize(128*orbSizeMultiplier,128*orbSizeMultiplier)
      orb.fill:SetPoint("CENTER")
      orb.fill:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_orb_fill1")
      orb.fill:SetVertexColor(self.cfg.harmony.color.r,self.cfg.harmony.color.g,self.cfg.harmony.color.b)
      --orb.fill:SetBlendMode("ADD")

      --orb border
      orb.border = orb:CreateTexture(nil,"BACKGROUND",nil,-5)
      orb.border:SetSize(128*orbSizeMultiplier,128*orbSizeMultiplier)
      orb.border:SetPoint("CENTER")
      orb.border:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_orb_border")

      --orb glow
      orb.glow = orb:CreateTexture(nil,"BACKGROUND",nil,-4)
      orb.glow:SetSize(128*orbSizeMultiplier,128*orbSizeMultiplier)
      orb.glow:SetPoint("CENTER")
      orb.glow:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_orb_glow")
      orb.glow:SetVertexColor(self.cfg.harmony.color.r,self.cfg.harmony.color.g,self.cfg.harmony.color.b)
      orb.glow:SetBlendMode("BLEND")

      --orb highlight
      orb.highlight = orb:CreateTexture(nil,"BACKGROUND",nil,-3)
      orb.highlight:SetSize(128*orbSizeMultiplier,128*orbSizeMultiplier)
      orb.highlight:SetPoint("CENTER")
      orb.highlight:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_orb_highlight")

    end

    bar:SetScale(self.cfg.harmony.scale)
    func.applyDragFunctionality(bar)
    --combat fading
    if self.cfg.harmony.combat.enable then
      rCombatFrameFader(bar, self.cfg.harmony.combat.fadeIn, self.cfg.harmony.combat.fadeOut) --frame, buttonList, fadeIn, fadeOut
    end

    self.HarmonyPowerBar = bar

  end

  --create holy power bar
  bars.createHolyPowerBar = function(self)

    self.HolyPower = {}

    local t
    local bar = CreateFrame("Frame","oUF_DiabloHolyPower",self)
    bar.maxOrbs = 5
    local w = 64*(bar.maxOrbs+2) --create the bar for
    local h = 64
    --bar:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    bar:SetPoint(self.cfg.holypower.pos.a1,self.cfg.holypower.pos.af,self.cfg.holypower.pos.a2,self.cfg.holypower.pos.x,self.cfg.holypower.pos.y)
    bar:SetWidth(w)
    bar:SetHeight(h)

    --color
    bar.color = self.cfg.holypower.color

    --left edge
    t = bar:CreateTexture(nil,"BACKGROUND",nil,-8)
    t:SetSize(64,64)
    t:SetPoint("LEFT",0,0)
    t:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_left")
    bar.leftEdge = t

    --right edge
    t = bar:CreateTexture(nil,"BACKGROUND",nil,-8)
    t:SetSize(64,64)
    t:SetPoint("RIGHT",0,0)
    t:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_right")
    bar.rightEdge = t

    for i = 1, bar.maxOrbs do

      local orb = CreateFrame("Frame",nil,bar)
      self.HolyPower[i] = orb

      orb:SetSize(64,64)
      orb:SetPoint("LEFT",i*64,0)

      local orbSizeMultiplier = 0.85

      --bar background
      orb.barBg = orb:CreateTexture(nil,"BACKGROUND",nil,-8)
      orb.barBg:SetSize(64,64)
      orb.barBg:SetPoint("CENTER")
      orb.barBg:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_bar_bg")

      --orb background
      orb.bg = orb:CreateTexture(nil,"BACKGROUND",nil,-7)
      orb.bg:SetSize(128*orbSizeMultiplier,128*orbSizeMultiplier)
      orb.bg:SetPoint("CENTER")
      orb.bg:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_orb_bg")

      --orb filling
      orb.fill = orb:CreateTexture(nil,"BACKGROUND",nil,-6)
      orb.fill:SetSize(128*orbSizeMultiplier,128*orbSizeMultiplier)
      orb.fill:SetPoint("CENTER")
      orb.fill:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_orb_fill1")
      orb.fill:SetVertexColor(self.cfg.holypower.color.r,self.cfg.holypower.color.g,self.cfg.holypower.color.b)
      --orb.fill:SetBlendMode("ADD")

      --orb border
      orb.border = orb:CreateTexture(nil,"BACKGROUND",nil,-5)
      orb.border:SetSize(128*orbSizeMultiplier,128*orbSizeMultiplier)
      orb.border:SetPoint("CENTER")
      orb.border:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_orb_border")

      --orb glow
      orb.glow = orb:CreateTexture(nil,"BACKGROUND",nil,-4)
      orb.glow:SetSize(128*orbSizeMultiplier,128*orbSizeMultiplier)
      orb.glow:SetPoint("CENTER")
      orb.glow:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_orb_glow")
      orb.glow:SetVertexColor(self.cfg.holypower.color.r,self.cfg.holypower.color.g,self.cfg.holypower.color.b)
      orb.glow:SetBlendMode("BLEND")

      --orb highlight
      orb.highlight = orb:CreateTexture(nil,"BACKGROUND",nil,-3)
      orb.highlight:SetSize(128*orbSizeMultiplier,128*orbSizeMultiplier)
      orb.highlight:SetPoint("CENTER")
      orb.highlight:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_orb_highlight")

    end

    bar:SetScale(self.cfg.holypower.scale)
    func.applyDragFunctionality(bar)
    --combat fading
    if self.cfg.holypower.combat.enable then
      rCombatFrameFader(bar, self.cfg.holypower.combat.fadeIn, self.cfg.holypower.combat.fadeOut) --frame, buttonList, fadeIn, fadeOut
    end

    self.HolyPowerBar = bar

  end

  --create burningember power bar
  bars.createBurningEmberPowerBar = function(self)

    self.BurningEmbers = {}

    local t
    local bar = CreateFrame("Frame","oUF_DiabloBurningEmberPower",self)
    bar.maxOrbs = 4
    local w = 64*(bar.maxOrbs+2) --create the bar for
    local h = 64
    --bar:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    bar:SetPoint(self.cfg.burningembers.pos.a1,self.cfg.burningembers.pos.af,self.cfg.burningembers.pos.a2,self.cfg.burningembers.pos.x,self.cfg.burningembers.pos.y)
    bar:SetWidth(w)
    bar:SetHeight(h)
    bar:Hide() --hide bar (it will become available if the spec matches)

    --color
    bar.color = self.cfg.burningembers.color

    --left edge
    t = bar:CreateTexture(nil,"BACKGROUND",nil,-8)
    t:SetSize(64,64)
    t:SetPoint("LEFT",0,0)
    t:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_left")
    bar.leftEdge = t

    --right edge
    t = bar:CreateTexture(nil,"BACKGROUND",nil,-8)
    t:SetSize(64,64)
    t:SetPoint("RIGHT",0,0)
    t:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_right")
    bar.rightEdge = t

    local MAX_POWER_PER_EMBER = 10

    for i = 1, bar.maxOrbs do

      local orb = CreateFrame("StatusBar",nil,bar)
      self.BurningEmbers[i] = orb
      orb:SetSize(64,64)
      orb:SetPoint("LEFT",i*64,0)
      orb:SetMinMaxValues(0, MAX_POWER_PER_EMBER)
      orb:SetValue(0)

      local orbSizeMultiplier = 0.74

      --bar background
      orb.barBg = orb:CreateTexture(nil,"BACKGROUND",nil,-8)
      orb.barBg:SetSize(64,64)
      orb.barBg:SetPoint("CENTER")
      orb.barBg:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_bar_bg")

      --orb background
      orb.bg = orb:CreateTexture(nil,"BACKGROUND",nil,-7)
      orb.bg:SetSize(128*orbSizeMultiplier,128*orbSizeMultiplier)
      orb.bg:SetPoint("CENTER")
      orb.bg:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_pot_bg")
      orb.bg:SetAlpha(0.7)

      --orb filling
      local fill = orb:CreateTexture(nil,"BACKGROUND",nil,-6)
      fill:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_pot_fill1")
      --fill:SetVertexColor(self.cfg.burningembers.color.r,self.cfg.burningembers.color.g,self.cfg.burningembers.color.b)
      orb:SetStatusBarTexture(fill)
      orb:SetOrientation("VERTICAL")

      --stack another frame to correct the texture stacking
      local helper = CreateFrame("Frame",nil,orb)
      helper:SetAllPoints(orb)

      --orb border
      orb.border = helper:CreateTexture(nil,"BACKGROUND",nil,-5)
      orb.border:SetSize(128*orbSizeMultiplier,128*orbSizeMultiplier)
      orb.border:SetPoint("CENTER")
      orb.border:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_pot_border")
      orb.border:SetVertexColor(0.75,0.7,0.7)

      --orb glow
      orb.glow = helper:CreateTexture(nil,"BACKGROUND",nil,-4)
      orb.glow:SetSize(128*orbSizeMultiplier,128*orbSizeMultiplier)
      orb.glow:SetPoint("CENTER")
      orb.glow:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_pot_glow")
      orb.glow:SetVertexColor(self.cfg.burningembers.color.r,self.cfg.burningembers.color.g,self.cfg.burningembers.color.b)
      orb.glow:SetBlendMode("BLEND")

      --orb highlight
      orb.highlight = helper:CreateTexture(nil,"BACKGROUND",nil,-3)
      orb.highlight:SetSize(128*orbSizeMultiplier,128*orbSizeMultiplier)
      orb.highlight:SetPoint("CENTER")
      orb.highlight:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_pot_highlight")
      orb.highlight:SetAlpha(0.8)

    end

    bar:SetScale(self.cfg.burningembers.scale)
    func.applyDragFunctionality(bar)
    --combat fading
    if self.cfg.burningembers.combat.enable then
      rCombatFrameFader(bar, self.cfg.burningembers.combat.fadeIn, self.cfg.burningembers.combat.fadeOut) --frame, buttonList, fadeIn, fadeOut
    end
    self.BurningEmberPowerBar = bar

  end

  --create soulshard power bar
  bars.createSoulShardPowerBar = function(self)

    self.SoulShards = {}

    local t
    local bar = CreateFrame("Frame","oUF_DiabloSoulShardPower",self)
    bar.maxOrbs = 4
    local w = 64*(bar.maxOrbs+2) --create the bar for
    local h = 64
    --bar:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    bar:SetPoint(self.cfg.soulshards.pos.a1,self.cfg.soulshards.pos.af,self.cfg.soulshards.pos.a2,self.cfg.soulshards.pos.x,self.cfg.soulshards.pos.y)
    bar:SetWidth(w)
    bar:SetHeight(h)
    bar:Hide() --hide bar (it will become available if the spec matches)

    --color
    bar.color = self.cfg.soulshards.color

    --left edge
    t = bar:CreateTexture(nil,"BACKGROUND",nil,-8)
    t:SetSize(64,64)
    t:SetPoint("LEFT",0,0)
    t:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_left")
    bar.leftEdge = t

    --right edge
    t = bar:CreateTexture(nil,"BACKGROUND",nil,-8)
    t:SetSize(64,64)
    t:SetPoint("RIGHT",0,0)
    t:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_right")
    bar.rightEdge = t

    for i = 1, bar.maxOrbs do

      local orb = CreateFrame("Frame",nil,bar)
      self.SoulShards[i] = orb

      orb:SetSize(64,64)
      orb:SetPoint("LEFT",i*64,0)

      local orbSizeMultiplier = 0.95

      --bar background
      orb.barBg = orb:CreateTexture(nil,"BACKGROUND",nil,-8)
      orb.barBg:SetSize(64,64)
      orb.barBg:SetPoint("CENTER")
      orb.barBg:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_bar_bg")

      --orb background
      orb.bg = orb:CreateTexture(nil,"BACKGROUND",nil,-7)
      orb.bg:SetSize(128*orbSizeMultiplier,128*orbSizeMultiplier)
      orb.bg:SetPoint("CENTER")
      orb.bg:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_gem_bg")

      --orb filling
      orb.fill = orb:CreateTexture(nil,"BACKGROUND",nil,-6)
      orb.fill:SetSize(128*orbSizeMultiplier,128*orbSizeMultiplier)
      orb.fill:SetPoint("CENTER")
      orb.fill:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_gem_fill1")
      orb.fill:SetVertexColor(self.cfg.soulshards.color.r,self.cfg.soulshards.color.g,self.cfg.soulshards.color.b)
      --orb.fill:SetBlendMode("ADD")

      --orb border
      orb.border = orb:CreateTexture(nil,"BACKGROUND",nil,-5)
      orb.border:SetSize(128*orbSizeMultiplier,128*orbSizeMultiplier)
      orb.border:SetPoint("CENTER")
      orb.border:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_gem_border")

      --orb glow
      orb.glow = orb:CreateTexture(nil,"BACKGROUND",nil,-4)
      orb.glow:SetSize(128*orbSizeMultiplier,128*orbSizeMultiplier)
      orb.glow:SetPoint("CENTER")
      orb.glow:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_gem_glow")
      orb.glow:SetVertexColor(self.cfg.soulshards.color.r,self.cfg.soulshards.color.g,self.cfg.soulshards.color.b)
      orb.glow:SetBlendMode("BLEND")

      --orb highlight
      orb.highlight = orb:CreateTexture(nil,"BACKGROUND",nil,-3)
      orb.highlight:SetSize(128*orbSizeMultiplier,128*orbSizeMultiplier)
      orb.highlight:SetPoint("CENTER")
      orb.highlight:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_gem_highlight")

    end

    bar:SetScale(self.cfg.soulshards.scale)
    func.applyDragFunctionality(bar)
    --combat fading
    if self.cfg.soulshards.combat.enable then
      rCombatFrameFader(bar, self.cfg.soulshards.combat.fadeIn, self.cfg.soulshards.combat.fadeOut) --frame, buttonList, fadeIn, fadeOut
    end

    self.SoulShardPowerBar = bar

  end

  --create warlock bars
  bars.createDemonicFuryPowerBar = function(self)
    self.DemonicFury = {}
    local bar = CreateFrame("Frame","oUF_DemonicFuryPower",self)
    bar:SetPoint(self.cfg.demonicfury.pos.a1,self.cfg.demonicfury.pos.af,self.cfg.demonicfury.pos.a2,self.cfg.demonicfury.pos.x,self.cfg.demonicfury.pos.y)
    bar:SetSize(256,32)
    bar:SetScale(self.cfg.demonicfury.scale)
    bar:Hide() --hide bar (it will become available if the spec matches)

    local sb = CreateFrame("StatusBar",nil,bar)
    self.DemonicFury[1] = sb

    sb:SetPoint("TOPLEFT",17,-5)
    sb:SetPoint("BOTTOMRIGHT",-17,5)
    sb:SetStatusBarTexture("Interface\\AddOns\\oUF_Diablo\\media\\demonic_fury_statusbar")
    sb:SetStatusBarColor(self.cfg.demonicfury.color.bar.r,self.cfg.demonicfury.color.bar.g,self.cfg.demonicfury.color.bar.b)

    local t = sb:CreateTexture(nil,"BACKGROUND",nil,-8)
    t:SetAllPoints(sb)
    t:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\demonic_fury_statusbar")
    t:SetVertexColor(self.cfg.demonicfury.color.bg.r,self.cfg.demonicfury.color.bg.g,self.cfg.demonicfury.color.bg.b)
    sb.bg = t

    local border = CreateFrame("Frame",nil,sb)
    border:SetAllPoints(bar)
    local t = border:CreateTexture(nil,"BACKGROUND",nil,-8)
    t:SetAllPoints(bar)
    t:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\demonic_fury_border")
    sb.border = t

    local t = border:CreateTexture(nil,"BACKGROUND",nil,-7)
    t:SetSize(512,64)
    t:SetPoint("CENTER")
    t:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\demonic_fury_glow")
    t:SetVertexColor(self.cfg.demonicfury.color.bar.r,self.cfg.demonicfury.color.bar.g,self.cfg.demonicfury.color.bar.b)
    t:SetBlendMode("BLEND")
    sb.glow = t

    func.applyDragFunctionality(bar)

    --combat fading
    if self.cfg.demonicfury.combat.enable then
      rCombatFrameFader(bar, self.cfg.demonicfury.combat.fadeIn, self.cfg.demonicfury.combat.fadeOut) --frame, buttonList, fadeIn, fadeOut
    end

    self.DemonicFuryPowerBar = bar
  end

  --create rune orbs bar
  bars.createRuneBar = function(self)

    self.RuneOrbs = {}

    local t
    local bar = CreateFrame("Frame","oUF_DiabloRuneBar",self)
    bar.maxOrbs = 6
    local w = 64*(bar.maxOrbs+2) --create the bar for
    local h = 64
    bar:SetPoint(self.cfg.runes.pos.a1,self.cfg.runes.pos.af,self.cfg.runes.pos.a2,self.cfg.runes.pos.x,self.cfg.runes.pos.y)
    bar:SetWidth(w)
    bar:SetHeight(h)
    bar:Hide() --hide bar (it will become available if the spec matches)

    --left edge
    t = bar:CreateTexture(nil,"BACKGROUND",nil,-8)
    t:SetSize(64,64)
    t:SetPoint("LEFT",0,0)
    t:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_left")
    bar.leftEdge = t

    --right edge
    t = bar:CreateTexture(nil,"BACKGROUND",nil,-8)
    t:SetSize(64,64)
    t:SetPoint("RIGHT",0,0)
    t:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_right")
    bar.rightEdge = t

    for i = 1, bar.maxOrbs do

      local orb = CreateFrame("Frame",nil,bar)
      self.RuneOrbs[i] = orb
      orb:SetSize(64,64)
      orb:SetPoint("LEFT",i*64,0)

      local orbSizeMultiplier = 0.85

      --bar background
      orb.barBg = orb:CreateTexture(nil,"BACKGROUND",nil,-8)
      orb.barBg:SetSize(64,64)
      orb.barBg:SetPoint("CENTER")
      orb.barBg:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_bar_bg")

      --orb background
      orb.bg = orb:CreateTexture(nil,"BACKGROUND",nil,-7)
      orb.bg:SetSize(128*orbSizeMultiplier,128*orbSizeMultiplier)
      orb.bg:SetPoint("CENTER")
      orb.bg:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_orb_bg")

      --orb filling
      orb.fill = CreateFrame("StatusBar",nil,orb)
      orb.fill:SetSize(64*orbSizeMultiplier,64*orbSizeMultiplier)
      orb.fill:SetPoint("CENTER")
      local fill = orb.fill:CreateTexture(nil,"BACKGROUND",nil,-6)
      fill:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_orb_fill64_1")
      orb.fill:SetStatusBarTexture(fill)
      orb.fill:SetOrientation("VERTICAL")

      --stack another frame to correct the texture stacking
      local helper = CreateFrame("Frame",nil,orb.fill)
      helper:SetAllPoints(orb)

      --orb border
      orb.border = helper:CreateTexture(nil,"BACKGROUND",nil,-5)
      orb.border:SetSize(128*orbSizeMultiplier,128*orbSizeMultiplier)
      orb.border:SetPoint("CENTER")
      orb.border:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_orb_border")

      --orb glow
      orb.glow = helper:CreateTexture(nil,"BACKGROUND",nil,-4)
      orb.glow:SetSize(128*orbSizeMultiplier,128*orbSizeMultiplier)
      orb.glow:SetPoint("CENTER")
      orb.glow:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_orb_glow")
      orb.glow:SetBlendMode("BLEND")
      orb.glow:Hide()

      --orb highlight
      orb.highlight = helper:CreateTexture(nil,"BACKGROUND",nil,-3)
      orb.highlight:SetSize(128*orbSizeMultiplier,128*orbSizeMultiplier)
      orb.highlight:SetPoint("CENTER")
      orb.highlight:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_orb_highlight")

    end

    bar:SetScale(self.cfg.runes.scale)
    func.applyDragFunctionality(bar)
    --combat fading
    if self.cfg.runes.combat.enable then
      rCombatFrameFader(bar, self.cfg.runes.combat.fadeIn, self.cfg.runes.combat.fadeOut) --frame, buttonList, fadeIn, fadeOut
    end
    self.RuneBar = bar

  end

  --create eclipse power bar
  bars.createEclipseBar = function(self)

    local bar = CreateFrame("Frame","oUF_DiabloEclipsePower",self)
    bar:SetPoint(self.cfg.eclipse.pos.a1,self.cfg.eclipse.pos.af,self.cfg.eclipse.pos.a2,self.cfg.eclipse.pos.x,self.cfg.eclipse.pos.y)
    bar:SetSize(256,32)
    bar:SetScale(self.cfg.eclipse.scale)

    local statusbarHelper = CreateFrame("Frame",nil,bar)
    statusbarHelper:SetPoint("TOPLEFT",17,-5)
    statusbarHelper:SetPoint("BOTTOMRIGHT",-17,5)

    local bg = statusbarHelper:CreateTexture(nil,"BACKGROUND",nil,-8)
    bg:SetAllPoints(statusbarHelper)
    bg:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\demonic_fury_statusbar")
    bg:SetVertexColor(self.cfg.eclipse.color.bg.r,self.cfg.eclipse.color.bg.g,self.cfg.eclipse.color.bg.b)

    --lunar bar
    local lunar = CreateFrame("StatusBar",nil,statusbarHelper)
    lunar:SetAllPoints(statusbarHelper)
    local fill = lunar:CreateTexture(nil,"BACKGROUND",nil,-6)
    fill:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\demonic_fury_statusbar")
    lunar:SetStatusBarTexture(fill)
    lunar:SetStatusBarColor(self.cfg.eclipse.color.lunar.r,self.cfg.eclipse.color.lunar.g,self.cfg.eclipse.color.lunar.b)

    --solar bar
    local solar = CreateFrame("StatusBar",nil,statusbarHelper)
    solar:SetAllPoints(statusbarHelper)
    local fill = solar:CreateTexture(nil,"BACKGROUND",nil,-6)
    fill:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\demonic_fury_statusbar")
    solar:SetStatusBarTexture(fill)
    solar:SetStatusBarColor(self.cfg.eclipse.color.solar.r,self.cfg.eclipse.color.solar.g,self.cfg.eclipse.color.solar.b)

    --border
    local border = CreateFrame("Frame",nil,statusbarHelper)
    border:SetFrameLevel(max(solar:GetFrameLevel()+1,lunar:GetFrameLevel()+1))
    border:SetAllPoints(bar)
    local t = border:CreateTexture(nil,"BACKGROUND",nil,-4)
    t:SetAllPoints(bar)
    t:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\demonic_fury_border")
    bar.border = t

    --tick
    local t = border:CreateTexture(nil,"BACKGROUND",nil,-5)
    t:SetPoint("TOP",0,6)
    t:SetSize(48,48)
    t:SetAlpha(0.6)
    t:SetTexture("Interface\\MainMenuBar\\UI-ExhaustionTickNormal")
    bar.tickTexture = t

    --glow
    local t = border:CreateTexture(nil,"BACKGROUND",nil,-2)
    t:SetSize(512,64)
    t:SetPoint("CENTER")
    t:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\demonic_fury_glow")
    t:SetVertexColor(0,0.5,1)
    t:SetBlendMode("BLEND")
    bar.glow = t
    bar.glow:Hide()

    bar.PostUnitAura = function()
      if bar.hasSolarEclipse then
        bar.glow:SetVertexColor(self.cfg.eclipse.color.solar.r,self.cfg.eclipse.color.solar.g,self.cfg.eclipse.color.solar.b)
        bar.glow:Show()
        return
      end
      if bar.hasLunarEclipse then
        bar.glow:SetVertexColor(self.cfg.eclipse.color.lunar.r,self.cfg.eclipse.color.lunar.g,self.cfg.eclipse.color.lunar.b)
        bar.glow:Show()
        return
      end
      bar.glow:Hide()
    end

    bar.PostDirectionChange = function()
      if GetEclipseDirection() == "sun" then
        bar.LunarBar:SetStatusBarColor(self.cfg.eclipse.color.lunar.r,self.cfg.eclipse.color.lunar.g,self.cfg.eclipse.color.lunar.b)
        bar.LunarBar:Show()
        bar.SolarBar:Hide()
      elseif GetEclipseDirection() == "moon" then
        bar.LunarBar:Hide()
        bar.SolarBar:SetStatusBarColor(self.cfg.eclipse.color.solar.r,self.cfg.eclipse.color.solar.g,self.cfg.eclipse.color.solar.b)
        bar.SolarBar:Show()
      else
        bar.LunarBar:SetStatusBarColor(0.8,0.8,0.8)
        bar.SolarBar:SetStatusBarColor(0.8,0.8,0.8)
        bar.LunarBar:Show()
        bar.SolarBar:Show()
      end
    end

    bar.PostUpdatePower = function()
      local lmin, lmax = bar.LunarBar:GetMinMaxValues()
      local lval = bar.LunarBar:GetValue()
      local smin, smax = bar.SolarBar:GetMinMaxValues()
      local sval = bar.SolarBar:GetValue()
      bar.SolarBar:SetValue(bar.SolarBar:GetValue()*(-1))
      bar.LunarBar:SetValue(bar.LunarBar:GetValue()*(-1))
    end

    bar.PostUpdateVisibility = bar.PostDirectionChange

    func.applyDragFunctionality(bar)
    --combat fading
    if self.cfg.eclipse.combat.enable then
      rCombatFrameFader(bar, self.cfg.eclipse.combat.fadeIn, self.cfg.eclipse.combat.fadeOut) --frame, buttonList, fadeIn, fadeOut
    end

    bar.SolarBar = solar
    bar.LunarBar = lunar
    self.EclipseBar = bar

  end