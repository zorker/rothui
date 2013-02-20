
  --get the addon namespace
  local addon, ns = ...

  --get oUF namespace (just in case needed)
  local oUF = ns.oUF or oUF

  --get the config
  local cfg = ns.cfg
  --get the database
  local db = ns.db

  --get the functions
  local func = ns.func

  --get the unit container
  local unit = ns.unit

  --get the bars container
  local bars = ns.bars

  local abs = math.abs
  local sin = math.sin
  local pi = math.pi

  ---------------------------------------------
  -- UNIT SPECIFIC FUNCTIONS
  ---------------------------------------------

  --init parameters
  local initUnitParameters = function(self)
    self:SetFrameStrata("BACKGROUND")
    self:SetFrameLevel(1)
    self:SetSize(self.cfg.size, self.cfg.size)
    self:SetScale(self.cfg.scale)
    self:SetPoint(self.cfg.pos.a1,self.cfg.pos.af,self.cfg.pos.a2,self.cfg.pos.x,self.cfg.pos.y)
    self.menu = func.menu
    self:RegisterForClicks("AnyDown")
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)
    --func.createBackdrop(self)
    func.applyDragFunctionality(self,"orb")
  end

  --actionbar background
  local createActionBarBackground = function(self)
    local cfg = self.cfg.art.actionbarbackground
    if not cfg.show then return end
    local f = CreateFrame("Frame","oUF_DiabloActionBarBackground",self)
    f:SetFrameStrata("BACKGROUND")
    f:SetFrameLevel(0)
    f:SetSize(512,256)
    f:SetPoint(cfg.pos.a1, cfg.pos.af, cfg.pos.a2, cfg.pos.x, cfg.pos.y)
    f:SetScale(cfg.scale)
    func.applyDragFunctionality(f)
    local t = f:CreateTexture(nil,"BACKGROUND",nil,-8)
    t:SetAllPoints(f)
    if cfg.style >= 1 and cfg.style <= 3 then
      t:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\bar"..cfg.style)
    else
      local setupBarTexture = function()
        if ((HasVehicleActionBar() and UnitVehicleSkin("player") and UnitVehicleSkin("player") ~= "")
        or (HasOverrideActionBar() and GetOverrideBarSkin() and GetOverrideBarSkin() ~= ""))
        or UnitHasVehicleUI("player") then
          t:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\bar1")
        elseif MultiBarBottomRight:IsShown() then
          t:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\bar3")
        elseif MultiBarBottomLeft:IsShown() then
          t:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\bar2")
        else
          t:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\bar1")
        end
      end
      setupBarTexture()
      MultiBarBottomRight:HookScript("OnShow", setupBarTexture)
      MultiBarBottomRight:HookScript("OnHide", setupBarTexture)
      MultiBarBottomLeft:HookScript("OnShow", setupBarTexture)
      MultiBarBottomLeft:HookScript("OnHide", setupBarTexture)
      f:RegisterEvent("UNIT_ENTERED_VEHICLE")
      f:RegisterEvent("UNIT_EXITED_VEHICLE")
      f:SetScript("OnEvent", function(...)
        local self, event, unit = ...
        if unit and unit ~= "player" then return end
        setupBarTexture()
      end)
    end
  end

  --create the angel
  local createAngelFrame = function(self)
    if not self.cfg.art.angel.show then return end
    local f = CreateFrame("Frame","oUF_DiabloAngelFrame",self)
    f:SetSize(320,160)
    f:SetFrameStrata("LOW")
    f:SetFrameLevel(0)
    f:SetPoint(self.cfg.art.angel.pos.a1, self.cfg.art.angel.pos.af, self.cfg.art.angel.pos.a2, self.cfg.art.angel.pos.x, self.cfg.art.angel.pos.y)
    f:SetScale(self.cfg.art.angel.scale)
    func.applyDragFunctionality(f)
    local t = f:CreateTexture(nil,"BACKGROUND",nil,2)
    t:SetAllPoints(f)
    t:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\d3_angel2")
  end

  --create the demon
  local createDemonFrame = function(self)
    if not self.cfg.art.demon.show then return end
    local f = CreateFrame("Frame","oUF_DiabloDemonFrame",self)
    f:SetSize(320,160)
    f:SetFrameStrata("LOW")
    f:SetFrameLevel(0)
    f:SetPoint(self.cfg.art.demon.pos.a1, self.cfg.art.demon.pos.af, self.cfg.art.demon.pos.a2, self.cfg.art.demon.pos.x, self.cfg.art.demon.pos.y)
    f:SetScale(self.cfg.art.demon.scale)
    func.applyDragFunctionality(f)
    local t = f:CreateTexture(nil,"BACKGROUND",nil,2)
    t:SetAllPoints(f)
    t:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\d3_demon2")
  end

  --create the bottomline
  local createBottomLine = function(self)
    local cfg = self.cfg.art.bottomline
    if not cfg.show then return end
    local f = CreateFrame("Frame","oUF_DiabloBottomLine",self)
    f:SetFrameStrata("MEDIUM")
    f:SetFrameLevel(0)
    f:SetSize(500,112)
    f:SetPoint(cfg.pos.a1, cfg.pos.af, cfg.pos.a2, cfg.pos.x, cfg.pos.y)
    f:SetScale(cfg.scale)
    func.applyDragFunctionality(f,"bottomline")
    local t = f:CreateTexture(nil,"BACKGROUND",nil,3)
    t:SetAllPoints(f)
    t:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\d3_bottom")
  end

  --initModel func
  local initModel = function(model)
    local orb = model:GetParent():GetParent():GetParent()
    local cfg = db.char[orb.type].animation
    model:SetCamDistanceScale(cfg.camDistanceScale)
    model:SetPosition(0,cfg.pos_x,cfg.pos_y)
    model:SetRotation(cfg.rotation)
    model:SetPortraitZoom(cfg.portraitZoom)
    model:ClearModel()
    --model:SetModel("interface\\buttons\\talktomequestionmark.m2") --in case setdisplayinfo fails
    model:SetDisplayInfo(cfg.displayInfo)
  end

  --post update orb func (used to display lowHp on percentage)
  local updatePlayerHealth = function(bar, unit, min, max)
    local per = floor(min/max*100)
    local orb = bar:GetParent()
    if per <= 25 and not UnitIsDeadOrGhost(unit) then
      orb.lowHP:Show()
    else
      orb.lowHP:Hide()
    end
  end

  --update spark func
  local updateSpark = function(bar, r, g, b)
    local orb = bar:GetParent()
    --print("updatespark "..orb.type)
    orb.spark:SetVertexColor(r,g,b)
  end

  --update orb func
  local updateOrb = function(self,value)
    local orb = self:GetParent()
    local min, max = self:GetMinMaxValues()
    local per = value/max*100
    local offset = orb.size-per*orb.size/100
    orb.scrollFrame:SetPoint("TOP",0,-offset)
    orb.scrollFrame:SetVerticalScroll(offset)
    --print("update orb "..orb.type.." val: "..value.." off: "..offset.." per: "..per.."%")
    --adjust the orb spark in width/height matching the current scrollframe state
    if not orb.spark then return end
    local multiplier = floor(sin(per/100*pi)*1000)/1000
    --print(multiplier)
    if multiplier <= 0.25 then
      orb.spark:Hide()
    else
      orb.spark:SetWidth(256*orb.size/256*multiplier)
      orb.spark:SetHeight(32*orb.size/256*multiplier)
      orb.spark:SetPoint("TOP", orb.scrollFrame, 0, 16*orb.size/256*multiplier)
      orb.spark:Show()
    end
  end

  --create orb func
  local createOrb = function(self,type)
    --get the orb config
    local orbcfg = db.char[type]
    --create the orb baseframe
    local orb = CreateFrame("Frame", "oUF_Diablo"..type.."Orb", self)
    --orb data
    orb.type = type
    orb.size = self.cfg.size
    orb:SetSize(orb.size,orb.size)
    --position the orb
    if orb.type == "POWER" then
      --reset the power to be on the opposite side of the health orb
      orb:SetPoint(self.cfg.pos.a1,self.cfg.pos.af,self.cfg.pos.a2,self.cfg.pos.x*(-1),self.cfg.pos.y)
      --make the power orb dragable
      func.applyDragFunctionality(orb,"orb")
    else
      --position the health orb ontop of the self object
      orb:SetPoint("CENTER")
    end

    if orb.type == "HEALTH" then
      --debuff glow
      local glow = orb:CreateTexture("$parentGlow", "BACKGROUND", nil, -7)
      glow:SetPoint("CENTER",0,0)
      glow:SetSize(self.cfg.size+5,self.cfg.size+5)
      glow:SetBlendMode("BLEND")
      glow:SetVertexColor(0, 1, 1, 0) -- set alpha to 0 to hide the texture
      glow:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\orb_debuff_glow")
      orb.glow = glow
      self.DebuffHighlight = orb.glow
      self.DebuffHighlightAlpha = 1
      self.DebuffHighlightFilter = false
    end

    --background
    local bg = orb:CreateTexture("$parentBG","BACKGROUND",nil,-6)
    bg:SetAllPoints()
    bg:SetTexture("Interface\\AddOns\\DiscoKugel2\\media\\orb_back")
    orb.bg = bg

    --filling statusbar
    local fill = CreateFrame("StatusBar","$parentFill",orb)
    fill:SetAllPoints()
    fill:SetMinMaxValues(0, 100)
    fill:SetStatusBarTexture(orbcfg.filling.texture)
    fill:SetStatusBarColor(orbcfg.filling.color.r,orbcfg.filling.color.g,orbcfg.filling.color.b)
    fill:SetOrientation("VERTICAL")
    fill:SetScript("OnValueChanged", updateOrb)
    orb.fill = fill

    --scrollframe
    local scrollFrame = CreateFrame("ScrollFrame","$parentScrollFrame",orb)
    scrollFrame:SetSize(orb:GetSize())
    scrollFrame:SetPoint("TOP")
    --scrollchild
    local scrollChild = CreateFrame("Frame","$parentScrollChild",scrollFrame)
    scrollChild:SetSize(orb:GetSize())
    scrollFrame:SetScrollChild(scrollChild)
    orb.scrollFrame = scrollFrame

    --orb animation
    local model = CreateFrame("PlayerModel","$parentModel",scrollChild)
    model:SetSize(orb:GetSize())
    model:SetPoint("TOP")
    --model:SetBackdrop(cfg.backdrop)
    model:SetAlpha(orbcfg.animation.alpha or 1)
    orb.model = model
    orb.model:SetScript("OnEvent", initModel)
    orb.model:RegisterEvent("PLAYER_ENTERING_WORLD")
    orb.model:SetScript("OnShow", initModel)
    initModel(orb.model)
    if not orbcfg.animation.enable then
      orb.model:Hide()
    end
    --orb.model:SetScript("OnSizeChanged", initModel)

    --overlay frame
    local overlay = CreateFrame("Frame","$parentOverlay",scrollFrame)
    --overlay:SetFrameLevel(model:GetFrameLevel()+1)
    overlay:SetAllPoints(orb)
    orb.overlay = orb

    --spark frame
    local spark = overlay:CreateTexture(nil,"BACKGROUND",nil,-3)
    spark:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\orb_spark")
    --the spark should fit the filling color otherwise it will stand out too much
    spark:SetVertexColor(orbcfg.filling.color.r,orbcfg.filling.color.g,orbcfg.filling.color.b)
    spark:SetWidth(256*orb.size/256)
    spark:SetHeight(32*orb.size/256)
    spark:SetPoint("TOP", scrollFrame, 0, -16*orb.size/256)
    --texture will be blended by blendmode, http://wowprogramming.com/docs/widgets/Texture/SetBlendMode
    spark:SetAlpha(orbcfg.spark.alpha or 1)
    spark:SetBlendMode("ADD")
    spark:Hide()
    orb.spark = spark

    --lowhp
    if orb.type == "HEALTH" then
      local lowHP = overlay:CreateTexture(nil, "BACKGROUND", nil, -2)
      lowHP:SetPoint("CENTER",0,0)
      lowHP:SetSize(self.cfg.size-15,self.cfg.size-15)
      lowHP:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\orb_lowhp_glow")
      lowHP:SetBlendMode("ADD")
      lowHP:SetVertexColor(1, 0, 0, 1)
      lowHP:Hide()
      orb.lowHP = lowHP
    end

    --highlight
    local highlight = overlay:CreateTexture("$parentHighlight","BACKGROUND",nil,-1)
    highlight:SetAllPoints()
    highlight:SetTexture("Interface\\AddOns\\DiscoKugel2\\media\\orb_gloss")
    highlight:SetAlpha(orbcfg.highlight.alpha or 1)
    orb.highlight = highlight

    if orb.type == "POWER" then
      self.Power = orb.fill
      ns.PowerOrb = orb --save the orb in the namespace
      hooksecurefunc(self.Power, "SetStatusBarColor", updateSpark)
      self.Power.frequentUpdates = self.cfg.power.frequentUpdates or false
      self.Power.Smooth = self.cfg.power.smooth or false
      self.Power.colorPower = orbcfg.filling.colorAuto or false
    else
      self.Health = orb.fill
      ns.HealthOrb = orb --save the orb in the namespace
      hooksecurefunc(self.Health, "SetStatusBarColor", updateSpark)
      self.Health.frequentUpdates = self.cfg.health.frequentUpdates or false
      self.Health.Smooth = self.cfg.health.smooth or false
      self.Health.colorClass = orbcfg.filling.colorAuto or false
      self.Health.colorHealth = orbcfg.filling.colorAuto or false --when player switches into a vehicle it will recolor the orb
      --we need to display the lowhp on a certain threshold without smoothing, so we use the postUpdate for that
      self.Health.PostUpdate = updatePlayerHealth
    end
    --print(addon..": orb created "..orb.type)
  end

  --create strings for health and power orb
  local createHealthPowerStrings = function(self)
    --hp strings
    local hpval1, hpval2, ppval1, ppval2, hpvalf, ppvalf
    hpvalf = CreateFrame("FRAME", nil, self.Health)
    hpvalf:SetFrameStrata("LOW")
    hpvalf:SetFrameLevel(1)
    hpvalf:SetAllPoints(self.Health)

    hpval1 = func.createFontString(hpvalf, cfg.font, 28, "THINOUTLINE")
    hpval1:SetPoint("CENTER", 0, 10)
    hpval2 = func.createFontString(hpvalf, cfg.font, 16, "THINOUTLINE")
    hpval2:SetPoint("CENTER", 0, -10)
    hpval2:SetTextColor(0.8,0.8,0.8)

    self:Tag(hpval1, self.cfg.health.text.tags.top or "[perhp]")
    self:Tag(hpval2, self.cfg.health.text.tags.bottom or "[curhp]")

    self.Health.hpval1 = hpval1
    self.Health.hpval2 = hpval2

    --pp strings
    ppvalf = CreateFrame("FRAME", nil, self.Power)
    ppvalf:SetFrameStrata("LOW")
    ppvalf:SetFrameLevel(1)
    ppvalf:SetAllPoints(self.Power)

    ppval1 = func.createFontString(ppvalf, cfg.font, 28, "THINOUTLINE")
    ppval1:SetPoint("CENTER", 0, 10)
    ppval2 = func.createFontString(ppvalf, cfg.font, 16, "THINOUTLINE")
    ppval2:SetPoint("CENTER", 0, -10)
    ppval2:SetTextColor(0.8,0.8,0.8)

    self:Tag(ppval1, self.cfg.power.text.tags.top or "[perpp]")
    self:Tag(ppval2, self.cfg.power.text.tags.bottom or "[curpp]")

    self.Power.ppval1 = ppval1
    self.Power.ppval2 = ppval2

    --mouseover stuff
    if self.cfg.health.text.mouseover.enable then
      rFrameFaderHook(self,hpvalf,self.cfg.health.text.mouseover.fadeIn,self.cfg.health.text.mouseover.fadeOut)
    end
    if self.cfg.power.text.mouseover.enable then
      rFrameFaderHook(self,ppvalf,self.cfg.power.text.mouseover.fadeIn,self.cfg.power.text.mouseover.fadeOut)
    end

  end

  ---------------------------------------------
  -- PLAYER STYLE FUNC
  ---------------------------------------------

  local createStyle = function(self)

    --apply config to self
    self.cfg = cfg.units.player
    self.cfg.style = "player"

    --init
    initUnitParameters(self)

    --create the actionbarbackground
    createActionBarBackground(self)

    --create the health orb
    createOrb(self,"HEALTH")
    --create the power orb
    createOrb(self,"POWER")

    --create the text strings
    createHealthPowerStrings(self)

    --create art textures do this now for correct frame stacking
    createAngelFrame(self)
    createDemonFrame(self)

    --experience bar
    bars.createExpBar(self)

    --reputation bar
    bars.createRepBar(self)

    --bottomline
    createBottomLine(self)

    --icons
    if self.cfg.icons.resting.show then
      local pos = self.cfg.icons.resting.pos
      self.Resting = func.createIcon(self,"BACKGROUND",32,self,pos.a1,pos.a2,pos.x,pos.y,-1)
    end
    if self.cfg.icons.pvp.show then
      local pos = self.cfg.icons.pvp.pos
      self.PvP = func.createIcon(self,"BACKGROUND",44,self,pos.a1,pos.a2,pos.x,pos.y,-1)
    end
    if self.cfg.icons.combat.show then
      local pos = self.cfg.icons.combat.pos
      self.Combat = func.createIcon(self,"BACKGROUND",32,self,pos.a1,pos.a2,pos.x,pos.y,-1)
    end

    --castbar
    if self.cfg.castbar.show then
      --disable the pet castbar (for vehicles!)
      PetCastingBarFrame:UnregisterAllEvents()
      PetCastingBarFrame:HookScript("OnShow", function(s) s:Hide() end)
      PetCastingBarFrame:Hide()
      --load castingbar
      func.createCastbar(self)
    end

    --warlock bars
    if cfg.playerclass == "WARLOCK" and self.cfg.demonicfury.show then
      bars.createDemonicFuryPowerBar(self)
    end
    if cfg.playerclass == "WARLOCK" and self.cfg.soulshards.show then
      bars.createSoulShardPowerBar(self)
    end
    if cfg.playerclass == "WARLOCK" and self.cfg.burningembers.show then
      bars.createBurningEmberPowerBar(self)
    end

    --holypower
    if cfg.playerclass == "PALADIN" and self.cfg.holypower.show then
      bars.createHolyPowerBar(self)
    end

    --harmony
    if cfg.playerclass == "MONK" and self.cfg.harmony.show then
      bars.createHarmonyPowerBar(self)
    end

    --shadoworbs
    if cfg.playerclass == "PRIEST" and self.cfg.shadoworbs.show then
      bars.createShadowOrbPowerBar(self)
    end

    --eclipsebar
    if cfg.playerclass == "DRUID" and self.cfg.eclipse.show then
      bars.createEclipseBar(self)
    end

    --runes
    if cfg.playerclass == "DEATHKNIGHT" and self.cfg.runes.show then
      --position deathknight runes
      bars.createRuneBar(self)
    end

    --create portrait
    if self.cfg.portrait.show then
      func.createStandAlonePortrait(self)
    end

    --make alternative power bar movable
    if self.cfg.altpower.show then
      func.createAltPowerBar(self,"oUF_AltPowerPlayer")
    end

    --add self to unit container (maybe access to that unit is needed in another style)
    unit.player = self

  end

  ---------------------------------------------
  -- SPAWN PLAYER UNIT
  ---------------------------------------------
  if cfg.units.player.show then
    oUF:RegisterStyle("diablo:player", createStyle)
    oUF:SetActiveStyle("diablo:player")
    oUF:Spawn("player", "oUF_DiabloPlayerFrame")
  end