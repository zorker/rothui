
  --get the addon namespace
  local addon, ns = ...

  --get oUF namespace (just in case needed)
  local oUF = ns.oUF or oUF

  --get the config
  local cfg = ns.cfg

  --get the functions
  local func = ns.func

  --get the unit container
  local unit = ns.unit

  ---------------------------------------------
  -- UNIT SPECIFIC FUNCTIONS
  ---------------------------------------------

  --adjust some values depending on animation settings
  if cfg.animClassOverride[cfg.playerclass].enable then
    if cfg.animClassOverride[cfg.playerclass].classcolored then
      cfg.animhealth = 19
      cfg.animtab[19].r = cfg.playercolor.r
      cfg.animtab[19].g = cfg.playercolor.g
      cfg.animtab[19].b = cfg.playercolor.b
    else
      cfg.animhealth = cfg.animClassOverride[cfg.playerclass].animhealth
    end
    if cfg.animClassOverride[cfg.playerclass].powertypecolored then
      cfg.animmana = 19
    else
      cfg.animmana = cfg.animClassOverride[cfg.playerclass].animmana
    end
  end

  --init parameters
  local initUnitParameters = function(self)
    self:SetFrameStrata("BACKGROUND")
    self:SetFrameLevel(1)
    self:SetSize(self.cfg.width, self.cfg.height)
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
    f:SetSize(512,256)
    f:SetPoint(cfg.pos.a1, cfg.pos.af, cfg.pos.a2, cfg.pos.x, cfg.pos.y)
    f:SetScale(cfg.scale)
    func.applyDragFunctionality(f)
    local t = f:CreateTexture(nil,"BACKGROUND",nil,-7)
    t:SetAllPoints(f)

    if cfg.style >= 1 and cfg.style <= 3 then
      t:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\bar"..cfg.style)
    else
      local setupBarTexture = function()
        if UnitHasVehicleUI("player") then
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
    f:SetFrameStrata("LOW")
    f:SetFrameLevel(6)
    f:SetSize(320,160)
    f:SetPoint(self.cfg.art.angel.pos.a1, self.cfg.art.angel.pos.af, self.cfg.art.angel.pos.a2, self.cfg.art.angel.pos.x, self.cfg.art.angel.pos.y)
    f:SetScale(self.cfg.art.angel.scale)
    func.applyDragFunctionality(f)
    local t = f:CreateTexture(nil,"LOW",nil,5)
    t:SetAllPoints(f)
    t:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\d3_angel2")
  end

  --create the demon
  local createDemonFrame = function(self)
    if not self.cfg.art.demon.show then return end
    local f = CreateFrame("Frame","oUF_DiabloDemonFrame",self)
    f:SetFrameStrata("LOW")
    f:SetFrameLevel(6)
    f:SetSize(320,160)
    f:SetPoint(self.cfg.art.demon.pos.a1, self.cfg.art.demon.pos.af, self.cfg.art.demon.pos.a2, self.cfg.art.demon.pos.x, self.cfg.art.demon.pos.y)
    f:SetScale(self.cfg.art.demon.scale)
    func.applyDragFunctionality(f)
    local t = f:CreateTexture(nil,"LOW",nil,5)
    t:SetAllPoints(f)
    t:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\d3_demon2")
  end

  --create the bottomline
  local createBottomLine = function(self)
    local cfg = self.cfg.art.bottomline
    if not cfg.show then return end
    local f = CreateFrame("Frame","oUF_DiabloBottomLine",self)
    f:SetFrameStrata("LOW")
    f:SetFrameLevel(7)
    f:SetSize(500,112)
    f:SetPoint(cfg.pos.a1, cfg.pos.af, cfg.pos.a2, cfg.pos.x, cfg.pos.y)
    f:SetScale(cfg.scale)
    func.applyDragFunctionality(f,"bottomline")
    local t = f:CreateTexture(nil,"LOW",nil,5)
    t:SetAllPoints(f)
    t:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\d3_bottom")
  end

  --create the exp bar
  local createExpBar = function(self)
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
  local createRepBar = function(self)
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


  --create galaxy func
  local createGalaxy = function(f,x,y,size,duration,texture,sublevel)

    local t = f:CreateTexture(nil, "BACKGROUND", nil, sublevel)
    t:SetSize(size,size)
    t:SetPoint("CENTER",x,y)
    t:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\"..texture)
    if f.type == "power" then
      t:SetVertexColor(cfg.galaxytab[cfg.manacolor].r, cfg.galaxytab[cfg.manacolor].g, cfg.galaxytab[cfg.manacolor].b)
    else
      t:SetVertexColor(cfg.galaxytab[cfg.healthcolor].r, cfg.galaxytab[cfg.healthcolor].g, cfg.galaxytab[cfg.healthcolor].b)
    end
    t:SetBlendMode("ADD")

    local ag = t:CreateAnimationGroup()
    local anim = ag:CreateAnimation("Rotation")
    anim:SetDegrees(360)
    anim:SetDuration(duration)
    ag:Play()
    ag:SetLooping("REPEAT")

    return t

  end

  local function setModelValues(self)
    self:ClearFog()
    self:ClearModel()
    --self:SetModel("interface\\buttons\\talktomequestionmark.m2") --in case setdisplayinfo fails
    self:SetDisplayInfo(self.cfg.displayid)
    self:SetPortraitZoom(self.cfg.portraitzoom)
    self:SetCamDistanceScale(self.cfg.camdistancescale)
    self:SetPosition(0,self.cfg.x,self.cfg.y)
    self:SetRotation(self.cfg.rotation)
  end

  --create orb func
  local createOrb = function(self,type)
    local orb
    if type == "power" then
      orb = CreateFrame("StatusBar", "oUF_DiabloPowerOrb", self)
    else
      orb = CreateFrame("StatusBar", "oUF_DiabloHealthOrb", self)
    end
    orb.type = type
    --need to be transparent just need it for the math
    orb:SetStatusBarTexture("Interface\\AddOns\\oUF_Diablo\\media\\orb_transparent")
    orb:SetSize(self.cfg.width,self.cfg.height)

    --actionbarbackground is at -7, make it be above that
    orb.back = orb:CreateTexture(nil, "BACKGROUND", nil, -6)
    orb.back:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\orb_back2")
    orb.back:SetAllPoints(orb)
    --orb.back:SetBlendMode("BLEND")

    --orb filling
    orb.Filling = orb:CreateTexture(nil, "BACKGROUND", nil, -4)
    local MAX_ORBTEX_NUM = 16
    if type == "power" then
      if cfg.manatexture >= 1 and cfg.manatexture <= MAX_ORBTEX_NUM then
        orb.Filling:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\orb_filling"..cfg.manatexture)
      else
        orb.Filling:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\orb_filling"..math.random(1,MAX_ORBTEX_NUM))
      end
    else
      if cfg.healthtexture >= 1 and cfg.healthtexture <= MAX_ORBTEX_NUM then
        orb.Filling:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\orb_filling"..cfg.healthtexture)
      else
        orb.Filling:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\orb_filling"..math.random(1,MAX_ORBTEX_NUM))
      end
    end
    --IMPORTANT, settexcoord will not work with other settings
    orb.Filling:SetPoint("BOTTOMLEFT",0,0)
    orb.Filling:SetHeight(self.cfg.height)
    orb.Filling:SetWidth(self.cfg.width)
    --orb.Filling:SetBlendMode("ADD")
    --orb.Filling:SetAlpha(0.8)

    if cfg.useAnimationSystem then
      local m = CreateFrame("PlayerModel", nil,orb)
      m:SetAllPoints(orb)
      if type == "power" then
        m.cfg = cfg.animtab[cfg.animmana]
        m.type = type
        m:SetAlpha(1*cfg.animClassOverride[cfg.playerclass].manamultiplier)
      else
        m.cfg = cfg.animtab[cfg.animhealth]
        m.type = type
        m:SetAlpha(1*cfg.animClassOverride[cfg.playerclass].healthmultiplier)
      end
      orb.Filling:SetVertexColor(m.cfg.r, m.cfg.g, m.cfg.b)
      setModelValues(m)
      m:SetScript("OnShow", setModelValues)
      m:SetScript("OnSizeChanged", setModelValues)

      local helper = CreateFrame("Frame",nil,orb)
      helper:SetFrameLevel(m:GetFrameLevel()+2)
      helper:SetAllPoints(orb)

      orb.Anim = m
      orb.Helper = helper

    else
      --textures can be animated by animationgroups...awesome!
      orb.galaxy = {}
      if type == "power" then
        orb.Filling:SetVertexColor(cfg.galaxytab[cfg.manacolor].r, cfg.galaxytab[cfg.manacolor].g, cfg.galaxytab[cfg.manacolor].b)
        orb.galaxy[1] = createGalaxy(orb,0,-10,self.cfg.width-0,90,"galaxy2",-3)
        orb.galaxy[2] = createGalaxy(orb,-2,-10,self.cfg.width-20,60,"galaxy",-3)
        orb.galaxy[3] = createGalaxy(orb,-4,-10,self.cfg.width-5,45,"galaxy4",-3)
      else
        orb.Filling:SetVertexColor(cfg.galaxytab[cfg.healthcolor].r, cfg.galaxytab[cfg.healthcolor].g, cfg.galaxytab[cfg.healthcolor].b)
        orb.galaxy[1] = createGalaxy(orb,0,-10,self.cfg.width-0,90,"galaxy2",-3)
        orb.galaxy[2] = createGalaxy(orb,2,-10,self.cfg.width-20,60,"galaxy",-3)
        orb.galaxy[3] = createGalaxy(orb,4,-10,self.cfg.width-5,45,"galaxy4",-3)
      end
    end

    --orb gloss
    if cfg.useAnimationSystem then
      orb.Gloss = orb.Helper:CreateTexture(nil, "BACKGROUND", nil, -2)
    else
      orb.Gloss = orb:CreateTexture(nil, "BACKGROUND", nil, -2)
    end
    orb.Gloss:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\orb_gloss")
    orb.Gloss:SetAllPoints(orb)
    --orb.Gloss:SetBlendMode("ADD")

    if type == "power" then
      --reset the power to be on the opposite side of the health orb
      orb:SetPoint(self.cfg.pos.a1,self.cfg.pos.af,self.cfg.pos.a2,self.cfg.pos.x*(-1),self.cfg.pos.y)
      --make the power orb dragable
      func.applyDragFunctionality(orb,"orb")
    else
      --position the health orb ontop of the self object
      orb:SetPoint("CENTER",self,"CENTER",0,0)

      --debuff glow
      orb.DebuffGlow = orb:CreateTexture(nil, "BACKGROUND", nil, -8)
      orb.DebuffGlow:SetPoint("CENTER",0,0)
      orb.DebuffGlow:SetSize(self.cfg.width+5,self.cfg.width+5)
      orb.DebuffGlow:SetBlendMode("BLEND")
      orb.DebuffGlow:SetVertexColor(0, 1, 1, 0) -- set alpha to 0 to hide the texture
      orb.DebuffGlow:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\orb_debuff_glow")
      self.DebuffHighlight = orb.DebuffGlow
      self.DebuffHighlightAlpha = 1
      self.DebuffHighlightFilter = false

      --low hp glow
      if cfg.useAnimationSystem then
        orb.LowHP = orb.Helper:CreateTexture(nil, "BACKGROUND", nil, -5)
      else
        orb.LowHP = orb:CreateTexture(nil, "BACKGROUND", nil, -5)
      end
      orb.LowHP:SetPoint("CENTER",0,0)
      orb.LowHP:SetSize(self.cfg.width-15,self.cfg.width-15)
      orb.LowHP:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\orb_lowhp_glow")
      orb.LowHP:SetBlendMode("ADD")
      orb.LowHP:SetVertexColor(1, 0, 0, 1)
      orb.LowHP:Hide()

    end

    return orb

  end

  --updatePlayerHealth func
  local swapper = "x"
  local updatePlayerHealth = function(bar, unit, min, max)
    local d = floor(min/max*100)
    bar.Filling:SetHeight((min / max) * bar:GetWidth())
    bar.Filling:SetTexCoord(0,1,  math.abs(min / max - 1),1)

    if cfg.useAnimationSystem then
      if cfg.animClassOverride[cfg.playerclass].healthdecreasealpha then
        bar.Anim:SetAlpha((min/max)*cfg.animClassOverride[cfg.playerclass].healthmultiplier or 1)
      end
      if cfg.animClassOverride[cfg.playerclass].classcolored then
        local status = UnitInVehicle("player")
        if status and swapper ~= "v" then
          local color = FACTION_BAR_COLORS[UnitReaction(unit, "player")]
          if color then bar.Filling:SetVertexColor(color.r,color.g,color.b) end
          swapper = "v"
        elseif not status and swapper ~= "n" then
          bar.Filling:SetVertexColor(cfg.playercolor.r,cfg.playercolor.g,cfg.playercolor.b)
          swapper = "n"
        end
      end
    else
      bar.galaxy[1]:SetAlpha(min/max)
      bar.galaxy[2]:SetAlpha(min/max)
      bar.galaxy[3]:SetAlpha(min/max)
      local status = UnitInVehicle("player")
      if status and swapper ~= "v" then
        local color = FACTION_BAR_COLORS[UnitReaction(unit, "player")]
        if color then
          bar.Filling:SetVertexColor(color.r,color.g,color.b)
          bar.galaxy[1]:SetVertexColor(color.r,color.g,color.b)
          bar.galaxy[2]:SetVertexColor(color.r,color.g,color.b)
          bar.galaxy[3]:SetVertexColor(color.r,color.g,color.b)
        end
        swapper = "v"
      elseif not status and swapper ~= "n" then
        bar.Filling:SetVertexColor(cfg.galaxytab[cfg.healthcolor].r, cfg.galaxytab[cfg.healthcolor].g, cfg.galaxytab[cfg.healthcolor].b)
        bar.galaxy[1]:SetVertexColor(cfg.galaxytab[cfg.healthcolor].r, cfg.galaxytab[cfg.healthcolor].g, cfg.galaxytab[cfg.healthcolor].b)
        bar.galaxy[2]:SetVertexColor(cfg.galaxytab[cfg.healthcolor].r, cfg.galaxytab[cfg.healthcolor].g, cfg.galaxytab[cfg.healthcolor].b)
        bar.galaxy[3]:SetVertexColor(cfg.galaxytab[cfg.healthcolor].r, cfg.galaxytab[cfg.healthcolor].g, cfg.galaxytab[cfg.healthcolor].b)
        swapper = "n"
      end
    end

    if d <= 25 and min > 1 then
      bar.LowHP:Show()
    else
      bar.LowHP:Hide()
    end
  end

  --update player power func
  local updatePlayerPower = function(bar, unit, min, max)
    local d, d2
    if max == 0 then
      d = 0
      d2 = 0
    else
     d = min/max
     d2 = floor(min/max*100)
    end
    bar.Filling:SetHeight((d) * bar:GetWidth())
    bar.Filling:SetTexCoord(0,1,  math.abs(d - 1),1)

    local powertype = select(2, UnitPowerType(unit))
    if cfg.useAnimationSystem then
      if cfg.animClassOverride[cfg.playerclass].powertypecolored then
        local color = cfg.powercolors[powertype]
        if color then
          bar.Filling:SetVertexColor(color.r, color.g, color.b)
        else
          bar.Filling:SetVertexColor(1,1,1)
        end
      end
      if cfg.animClassOverride[cfg.playerclass].manadecreasealpha then
        bar.Anim:SetAlpha(d*cfg.animClassOverride[cfg.playerclass].manamultiplier or 1)
      end
    else
      bar.galaxy[1]:SetAlpha(d)
      bar.galaxy[2]:SetAlpha(d)
      bar.galaxy[3]:SetAlpha(d)

      local color = cfg.powercolors[powertype]

      if color and cfg.automana then
        bar.Filling:SetVertexColor(color.r, color.g, color.b)
        bar.galaxy[1]:SetVertexColor(color.r, color.g, color.b)
        bar.galaxy[2]:SetVertexColor(color.r, color.g, color.b)
        bar.galaxy[3]:SetVertexColor(color.r, color.g, color.b)
      else
        bar.Filling:SetVertexColor(cfg.galaxytab[cfg.manacolor].r, cfg.galaxytab[cfg.manacolor].g, cfg.galaxytab[cfg.manacolor].b)
        bar.galaxy[1]:SetVertexColor(cfg.galaxytab[cfg.manacolor].r, cfg.galaxytab[cfg.manacolor].g, cfg.galaxytab[cfg.manacolor].b)
        bar.galaxy[2]:SetVertexColor(cfg.galaxytab[cfg.manacolor].r, cfg.galaxytab[cfg.manacolor].g, cfg.galaxytab[cfg.manacolor].b)
        bar.galaxy[3]:SetVertexColor(cfg.galaxytab[cfg.manacolor].r, cfg.galaxytab[cfg.manacolor].g, cfg.galaxytab[cfg.manacolor].b)
      end
    end

    if powertype ~= "MANA" then
      bar.ppval1:SetText(func.numFormat(min))
      bar.ppval2:SetText(d2)
    else
      bar.ppval1:SetText(d2)
      bar.ppval2:SetText(func.numFormat(min))
    end

  end

  --create strings for health and power orb
  local createHealthPowerStrings = function(self)
    --hp strings
    local hpval1, hpval2, ppval1, ppval2, hpvalf, ppvalf
    hpvalf = CreateFrame("FRAME", nil, self.Health)
    hpvalf:SetAllPoints(self.Health)

    hpval1 = func.createFontString(hpvalf, cfg.font, 28, "THINOUTLINE")
    hpval1:SetPoint("CENTER", 0, 10)
    hpval2 = func.createFontString(hpvalf, cfg.font, 16, "THINOUTLINE")
    hpval2:SetPoint("CENTER", 0, -10)
    hpval2:SetTextColor(0.8,0.8,0.8)

    self:Tag(hpval1, "[perhp]")
    self:Tag(hpval2, "[diablo:shorthpval]")

    self.Health.hpval1 = hpval1
    self.Health.hpval2 = hpval2

    --pp strings
    ppvalf = CreateFrame("FRAME", nil, self.Power)
    ppvalf:SetAllPoints(self.Power)

    ppval1 = func.createFontString(ppvalf, cfg.font, 28, "THINOUTLINE")
    ppval1:SetPoint("CENTER", 0, 10)
    ppval2 = func.createFontString(ppvalf, cfg.font, 16, "THINOUTLINE")
    ppval2:SetPoint("CENTER", 0, -10)
    ppval2:SetTextColor(0.8,0.8,0.8)

    self.Power.ppval1 = ppval1
    self.Power.ppval2 = ppval2

  end

  --create shadow orb power bar
  local createShadowOrbPowerBar = function(self)

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

    self.ShadowOrbPowerBar = bar

  end

  --create harmony power bar
  local createHarmonyPowerBar = function(self)

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

    self.HarmonyPowerBar = bar

  end

  --create holy power bar
  local createHolyPowerBar = function(self)

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

    self.HolyPowerBar = bar

  end

  --create warlock bars
  local createDemonicFuryPowerBar = function(self)
    self.DemonicFury = {}
    local bar = CreateFrame("Frame","oUF_DemonicFuryPower",self)
    bar:SetPoint(self.cfg.demonicfury.pos.a1,self.cfg.demonicfury.pos.af,self.cfg.demonicfury.pos.a2,self.cfg.demonicfury.pos.x,self.cfg.demonicfury.pos.y)
    bar:SetSize(256,32)
    bar:SetScale(self.cfg.demonicfury.scale)

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
    self.DemonicFuryPowerBar = bar
  end

  --create eclipse bar
  local createEclipseBar = function(self)
    local e = _G["EclipseBarFrame"]
    e:SetParent(self)
    e:SetScale(self.cfg.eclipsebar.scale)
    e:ClearAllPoints()
    e:SetPoint(self.cfg.eclipsebar.pos.a1,self.cfg.eclipsebar.pos.af,self.cfg.eclipsebar.pos.a2,self.cfg.eclipsebar.pos.x,self.cfg.eclipsebar.pos.y)
    e:SetFrameStrata("HIGH")
    func.applyDragFunctionality(e)
    local t = select(1, e:GetRegions())
    t:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\eclipsebar")
    EclipseBar_OnLoad(e)
  end

  --create rune bar
  local createRuneBar = function(self)
    local f = CreateFrame("Frame","oUF_DiabloRuneBar",self)
    f:SetPoint(self.cfg.runes.pos.a1,self.cfg.runes.pos.af,self.cfg.runes.pos.a2,self.cfg.runes.pos.x,self.cfg.runes.pos.y)
    f:SetSize(154,32)

    local t
    --left edge
    t = f:CreateTexture(nil,"BACKGROUND",nil,-8)
    t:SetSize(32,32)
    t:SetPoint("RIGHT",f,"LEFT",0,-1)
    t:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_left")
    f.leftEdge = t

    t = f:CreateTexture(nil,"BACKGROUND",nil,-8)
    t:SetSize(154,32)
    t:SetPoint("CENTER",0,-1)
    t:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_bar_bg")

    --right edge
    t = f:CreateTexture(nil,"BACKGROUND",nil,-8)
    t:SetSize(32,32)
    t:SetPoint("LEFT",f,"RIGHT",0,-1)
    t:SetTexture("Interface\\AddOns\\oUF_Diablo\\media\\combo_right")
    f.rightEdge = t

    func.applyDragFunctionality(f)
    RuneButtonIndividual1:ClearAllPoints()
    RuneButtonIndividual1:SetPoint("LEFT",f,"LEFT",2,0)
    for i=1,6 do
      local r = _G["RuneButtonIndividual"..i.."Cooldown"]
      r.noCooldownCount = true
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
    self.Health = createOrb(self,"health")
    --create the power orb
    self.Power = createOrb(self,"power")

    --smoothing
    self.Health.Smooth = true
    self.Power.Smooth = true

    --activate frequent updates for power orb
    if self.cfg.power.frequentUpdates then
      self.Power.frequentUpdates = true
    end

    createHealthPowerStrings(self)

    self.Health.PostUpdate = updatePlayerHealth
    self.Power.PostUpdate = updatePlayerPower

    --fix to update druid power correctly when cat has 100 power
    --update health and power when the player enters a vehicle (sometimes health/pover values do not change und call an automatic update)
    self.Health:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
    self.Health:RegisterEvent("UNIT_ENTERED_VEHICLE")
    self.Health:RegisterEvent("UNIT_EXITED_VEHICLE")
    self.Health:SetScript("OnEvent", function(s,e)
      updatePlayerHealth(s,"player",UnitHealth("player"),UnitHealthMax("player"))
    end)
    self.Power:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
    self.Power:RegisterEvent("UNIT_ENTERED_VEHICLE")
    self.Power:RegisterEvent("UNIT_EXITED_VEHICLE")
    self.Power:SetScript("OnEvent", function(s,e)
      updatePlayerPower(s,"player",UnitPower("player"),UnitPowerMax("player"))
    end)

    --create art textures do this now for correct frame stacking
    createAngelFrame(self)
    createDemonFrame(self)

    --experience bar
    createExpBar(self)

    --reputation bar
    createRepBar(self)

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
      createDemonicFuryPowerBar(self)
    end

    --holypower
    if cfg.playerclass == "PALADIN" and self.cfg.holypower.show then
      createHolyPowerBar(self)
    end

    --harmony
    if cfg.playerclass == "MONK" and self.cfg.harmony.show then
      createHarmonyPowerBar(self)
    end

    --shadoworbs
    if cfg.playerclass == "PRIEST" and self.cfg.shadoworbs.show then
      createShadowOrbPowerBar(self)
    end

    --eclipsebar
    if cfg.playerclass == "DRUID" and self.cfg.eclipsebar.show then
      createEclipseBar(self)
    end

    --runes
    if cfg.playerclass == "DEATHKNIGHT" then
      --position deathknight runes
      createRuneBar(self)
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