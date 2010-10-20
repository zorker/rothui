  
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
  -- CONSTANTS
  ---------------------------------------------

  local const = CreateFrame("Frame")
  
  const.buff_flash_time_on = 1
  const.buff_flash_time_off = 1
  const.buff_min_alpha = 0.3
  const.buff_warning_time = 10

  ---------------------------------------------
  -- UNIT SPECIFIC FUNCTIONS
  ---------------------------------------------
  
  --init parameters
  initUnitParameters = function(self)
    self:SetFrameStrata("BACKGROUND")
    self:SetSize(self.cfg.width, self.cfg.height)
    self:SetScale(self.cfg.scale)
    self:SetPoint(self.cfg.pos.a1,self.cfg.pos.af,self.cfg.pos.a2,self.cfg.pos.x,self.cfg.pos.y)
    self.menu = func.menu
    self:RegisterForClicks('AnyDown')
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)
    --func.createBackdrop(self)
    func.applyDragFunctionality(self)
  end
  
  --actionbar background
  createActionBarBackground = function(self)
    local cfg = self.cfg.art.actionbarbackground
    if not cfg.show then return end
    local f = CreateFrame("Frame","oUF_DiabloActionBarBackground",self)
    f:SetSize(512,256)
    f:SetPoint(cfg.pos.a1, cfg.pos.af, cfg.pos.a2, cfg.pos.x, cfg.pos.y)
    f:SetScale(cfg.scale)
    func.applyDragFunctionality(f)
    local t = f:CreateTexture(nil,"BACKGROUND",nil,-7)
    t:SetAllPoints(f)
    if MultiBarBottomRight:IsShown() then
      t:SetTexture("Interface\\AddOns\\rTextures\\bar3")
    elseif MultiBarBottomLeft:IsShown() then
      t:SetTexture("Interface\\AddOns\\rTextures\\bar2")
    else
      t:SetTexture("Interface\\AddOns\\rTextures\\bar1")
    end
    MultiBarBottomRight:HookScript("OnShow", function() t:SetTexture("Interface\\AddOns\\rTextures\\bar3") end)
    MultiBarBottomRight:HookScript("OnHide", function() t:SetTexture("Interface\\AddOns\\rTextures\\bar2") end)
    MultiBarBottomLeft:HookScript("OnShow", function() t:SetTexture("Interface\\AddOns\\rTextures\\bar2") end)
    MultiBarBottomLeft:HookScript("OnHide", function() t:SetTexture("Interface\\AddOns\\rTextures\\bar1") end)
  end
  
  --create the angel
  createAngelFrame = function(self)
    local cfg = self.cfg.art.angel
    if not cfg.show then return end
    local f = CreateFrame("Frame","oUF_DiabloAngelFrame",self)
    f:SetSize(320,160)
    f:SetPoint(cfg.pos.a1, cfg.pos.af, cfg.pos.a2, cfg.pos.x, cfg.pos.y)
    f:SetScale(cfg.scale)
    func.applyDragFunctionality(f)
    local t = f:CreateTexture(nil,"BACKGROUND",nil,-1)
    t:SetAllPoints(f)
    t:SetTexture("Interface\\AddOns\\rTextures\\d3_angel2")
  end

  --create the demon
  createDemonFrame = function(self)
    local cfg = self.cfg.art.demon
    if not cfg.show then return end
    local f = CreateFrame("Frame","oUF_DiabloDemonFrame",self)
    f:SetSize(320,160)
    f:SetPoint(cfg.pos.a1, cfg.pos.af, cfg.pos.a2, cfg.pos.x, cfg.pos.y)
    f:SetScale(cfg.scale)
    func.applyDragFunctionality(f)
    local t = f:CreateTexture(nil,"BACKGROUND",nil,-1)
    t:SetAllPoints(f)
    t:SetTexture("Interface\\AddOns\\rTextures\\d3_demon2")
  end

  --create the bottomline
  createBottomLine = function(self)
    local cfg = self.cfg.art.bottomline
    if not cfg.show then return end
    local f = CreateFrame("Frame","oUF_DiabloBottomLine",self)
    f:SetSize(500,112)
    f:SetPoint(cfg.pos.a1, cfg.pos.af, cfg.pos.a2, cfg.pos.x, cfg.pos.y)
    f:SetScale(cfg.scale)
    func.applyDragFunctionality(f)
    local t = f:CreateTexture(nil,"LOW",nil,5)
    t:SetAllPoints(f)
    t:SetTexture("Interface\\AddOns\\rTextures\\d3_bottom")
  end
  
  --create galaxy func
  createGalaxy = function(f,x,y,size,duration,texture,sublevel)
  
    local t = f:CreateTexture(nil, "BACKGROUND", nil, sublevel)
    t:SetSize(size,size)
    t:SetPoint("CENTER",x,y)
    t:SetTexture("Interface\\AddOns\\rTextures\\"..texture)
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
  
  --create orb func
  createOrb = function(self,type)
    local orb
    if type == "power" then
      orb = CreateFrame("StatusBar", "oUF_DiabloPowerOrb", self)
    else
      orb = CreateFrame("StatusBar", "oUF_DiabloHealthOrb", self)
    end
    orb.type = type
    --need to be transparent just need it for the math
    orb:SetStatusBarTexture("Interface\\AddOns\\rTextures\\orb_transparent")
    orb:SetSize(self.cfg.width,self.cfg.height)
    
    --actionbarbackground is at -7, make it be above that
    orb.back = orb:CreateTexture(nil, "BACKGROUND", nil, -6)
    orb.back:SetTexture("Interface\\AddOns\\rTextures\\orb_back2")
    orb.back:SetAllPoints(orb)
    --orb.back:SetBlendMode("BLEND")
    
    --orb filling
    orb.Filling = orb:CreateTexture(nil, "BACKGROUND", nil, -4)
    orb.Filling:SetTexture("Interface\\AddOns\\rTextures\\orb_filling1")
    --IMPORTANT, settexcoord will not work with other settings
    orb.Filling:SetPoint("BOTTOMLEFT",0,0)
    orb.Filling:SetHeight(self.cfg.height)
    orb.Filling:SetWidth(self.cfg.width)
    --orb.Filling:SetBlendMode("ADD")
    
    --textures can be animated by animationgroups...awesome!
    orb.galaxy = {}
    if type == "power" then
      orb.Filling:SetVertexColor(cfg.galaxytab[cfg.manacolor].r, cfg.galaxytab[cfg.manacolor].g, cfg.galaxytab[cfg.manacolor].b)
      orb.galaxy[1] = createGalaxy(orb,0,-10,self.cfg.width-0,60,"galaxy2",-3)
      orb.galaxy[2] = createGalaxy(orb,-2,-10,self.cfg.width-20,32,"galaxy",-3)
      orb.galaxy[3] = createGalaxy(orb,-4,-10,self.cfg.width-10,20,"galaxy3",-3)
    else
      orb.Filling:SetVertexColor(cfg.galaxytab[cfg.healthcolor].r, cfg.galaxytab[cfg.healthcolor].g, cfg.galaxytab[cfg.healthcolor].b)
      orb.galaxy[1] = createGalaxy(orb,0,-10,self.cfg.width-0,60,"galaxy2",-3)
      orb.galaxy[2] = createGalaxy(orb,2,-10,self.cfg.width-20,30,"galaxy",-3)
      orb.galaxy[3] = createGalaxy(orb,4,-10,self.cfg.width-10,18,"galaxy3",-3)
    end
    
    --orb gloss
    orb.Gloss = orb:CreateTexture(nil, "BACKGROUND", nil, -2)
    orb.Gloss:SetTexture("Interface\\AddOns\\rTextures\\orb_gloss")
    orb.Gloss:SetAllPoints(orb)
    --orb.Gloss:SetBlendMode("ADD")
    
    if type == "power" then
      --reset the power to be on the opposite side of the health orb
      orb:SetPoint(self.cfg.pos.a1,self.cfg.pos.af,self.cfg.pos.a2,self.cfg.pos.x*(-1),self.cfg.pos.y)
      --make the power orb dragable
      func.applyDragFunctionality(orb)
    else
      --position the health orb ontop of the self object
      orb:SetPoint("CENTER",self,"CENTER",0,0)

      --debuff glow
      orb.DebuffGlow = orb:CreateTexture(nil, "BACKGROUND", nil, -8)
      orb.DebuffGlow:SetPoint("CENTER",0,0)
      orb.DebuffGlow:SetSize(self.cfg.width+1,self.cfg.width+1)
      orb.DebuffGlow:SetBlendMode("BLEND")
      orb.DebuffGlow:SetVertexColor(1, 0, 0, 0) -- set alpha to 0 to hide the texture
      orb.DebuffGlow:SetTexture("Interface\\AddOns\\rTextures\\orb_debuff_glow")
      self.DebuffHighlight = orb.DebuffGlow
      self.DebuffHighlightAlpha = 0.7
      self.DebuffHighlightFilter = false
      
      --low hp glow
      orb.LowHP = orb:CreateTexture(nil, "BACKGROUND", nil, -5)
      orb.LowHP:SetPoint("CENTER",0,0)
      orb.LowHP:SetSize(self.cfg.width-10,self.cfg.width-10)
      orb.LowHP:SetTexture("Interface\\AddOns\\rTextures\\orb_lowhp_glow")
      orb.LowHP:SetBlendMode("ADD")
      orb.LowHP:SetVertexColor(1, 0, 0, 1)
      orb.LowHP:Hide()
      
    end
    
    return orb
    
  end
  
  --updatePlayerHealth func
  updatePlayerHealth = function(bar, unit, min, max)
    local d = floor(min/max*100)
    bar.Filling:SetHeight((min / max) * bar:GetWidth())
    bar.Filling:SetTexCoord(0,1,  math.abs(min / max - 1),1)
    bar.galaxy[1]:SetAlpha(min/max)
    bar.galaxy[2]:SetAlpha(min/max)
    bar.galaxy[3]:SetAlpha(min/max)
    if d <= 25 and min > 1 then
      bar.LowHP:Show()
    else
      bar.LowHP:Hide()
    end
  end
  
  --update player power func
  updatePlayerPower = function(bar, unit, min, max)
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
    bar.galaxy[1]:SetAlpha(d)
    bar.galaxy[2]:SetAlpha(d)
    bar.galaxy[3]:SetAlpha(d)
    
    local powertype = select(2, UnitPowerType(unit))
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
    
    if powertype ~= "MANA" then
      bar.ppval1:SetText(func.numFormat(min))
      bar.ppval2:SetText(d2)
    else
      bar.ppval1:SetText(d2)
      bar.ppval2:SetText(func.numFormat(min))
    end
    
  end
  
  --create strings for health and power orb
  createHealthPowerStrings = function(self)
    --hp strings
    local hpval1, hpval2, ppval1, ppval2, hpvalf, ppvalf
    hpvalf = CreateFrame("FRAME", nil, self.Health)
    hpvalf:SetAllPoints(self.Health)
    
    hpval1 = func.createFontString(hpvalf, cfg.font, 28, "THINOUTLINE")
    hpval1:SetPoint("CENTER", 0, 10)
    hpval2 = func.createFontString(hpvalf, cfg.font, 16, "THINOUTLINE")
    hpval2:SetPoint("CENTER", 0, -10)
    hpval2:SetTextColor(0.6,0.6,0.6)
    
    self:Tag(hpval1, "[perhp]")
    self:Tag(hpval2, "[diablo_ShortHP]")

    self.Health.hpval1 = hpval1
    self.Health.hpval2 = hpval2

    --pp strings
    ppvalf = CreateFrame("FRAME", nil, self.Power)
    ppvalf:SetAllPoints(self.Power)
    
    ppval1 = func.createFontString(ppvalf, cfg.font, 28, "THINOUTLINE")
    ppval1:SetPoint("CENTER", 0, 10)
    ppval2 = func.createFontString(ppvalf, cfg.font, 16, "THINOUTLINE")
    ppval2:SetPoint("CENTER", 0, -10)
    ppval2:SetTextColor(0.6,0.6,0.6)

    self.Power.ppval1 = ppval1
    self.Power.ppval2 = ppval2
  
  end
  
  --update aura time
  updateAuraTime = function(self,elapsed)  
    local t = self.updateTimer
    local tl = self.timeLeft-GetTime()
    if tl > 0 then
      --BUFF WARNING
      if (floor(tl+0.5) <= const.buff_warning_time) then
        self.BuffFrameFlashTime = self.BuffFrameFlashTime - elapsed
        if ( self.BuffFrameFlashTime < 0 ) then
          local overtime = -self.BuffFrameFlashTime
          if ( self.BuffFrameFlashState == 0 ) then
            self.BuffFrameFlashState = 1
            self.BuffFrameFlashTime = const.buff_flash_time_on
          else
            self.BuffFrameFlashState = 0
            self.BuffFrameFlashTime = const.buff_flash_time_off
          end
          if ( overtime < self.BuffFrameFlashTime ) then
            self.BuffFrameFlashTime = self.BuffFrameFlashTime - overtime
          end
        end
      
        if ( self.BuffFrameFlashState == 1 ) then
          self.BuffAlphaValue = (const.buff_flash_time_on - self.BuffFrameFlashTime) / const.buff_flash_time_on
        else
          self.BuffAlphaValue = self.BuffFrameFlashTime / const.buff_flash_time_on
        end
        self.BuffAlphaValue = (self.BuffAlphaValue * (1 - const.buff_min_alpha)) + const.buff_min_alpha
        self:SetAlpha(self.BuffAlphaValue)
      else
        self:SetAlpha(1.0)
      end      
      
      if (not t) then
        self.updateTimer = 0
        return
      end
      t = t + elapsed
      if (t<0.33) then
        self.updateTimer = t
        return
      else
        self.updateTimer = 0
        if self.count:GetText() == "0" then
          self.count:SetAlpha(0)
        else
          self.count:SetAlpha(1)
        end
        self.time:SetText(func.GetFormattedTime(tl))
      end  
    else
      self.time:Hide()
    end
  end
  
  --postupdateauraicon
  postUpdateAuraIcon = function(icons, unit, icon, index, offset)
    local filter = icons.filter
    local self = icons:GetParent()
    if self.Buffs.visibleBuffs and self.Buffs then
      self.Buffs:SetHeight((self.Buffs.size+16)*floor((self.Buffs.visibleBuffs/10)+1))
    else
      self.Buffs:SetHeight(self.Buffs.size+16)
    end
    local name, rank, texture, count, dtype, duration, timeLeft, caster, isStealable, shouldConsolidate, spellID = UnitAura(unit, index, filter)
    if duration and duration > 0 then
      icon.time:Show()
      icon.time:SetText(func.GetFormattedTime(timeLeft-GetTime()))
      icon.timeLeft = timeLeft
      icon:SetScript("OnUpdate", updateAuraTime)
    else
      icon.time:Hide()
      icon:SetAlpha(1)
      icon:SetScript("OnUpdate", nil)
    end
  end
  
  --aura icon func
  createAuraIcon = function(icons, button)
    local self = icons:GetParent()
    if (not button.time) then
      button.time = func.createFontString(button, cfg.font, 16, "THINOUTLINE")
      button.time:SetPoint("BOTTOM", 0, -4)
      button.time:SetJustifyH("CENTER")
      button.time:SetTextColor(1, .8, 0)
      button.time:Hide()
    end
    button.BuffFrameFlashTime = 0
    button.BuffFrameFlashState = 1
    button.BuffAlphaValue = 1
    --button.isDebuff = debuff
    --button.cd:SetReverse()
    local bw = button:GetWidth()
    button.cd:SetPoint("TOPLEFT", 1, -1)
    button.cd:SetPoint("BOTTOMRIGHT", -1, 1)
    button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    if self.cfg.style ~= "player" then
      button.count:SetParent(button.cd)
    end
    button.count:ClearAllPoints()
    button.count:SetPoint("TOPRIGHT", 4, 4)
    button.count:SetTextColor(0.75,0.75,0.75)
    --fix the count on aurawatch, make the count fontsize button size dependend
    button.count:SetFont(cfg.font,bw/1.7,"THINOUTLINE")
    button.overlay:SetTexture("Interface\\AddOns\\rTextures\\gloss2")
    button.overlay:SetTexCoord(0,1,0,1)
    button.overlay:SetPoint("TOPLEFT", -1, 1)
    button.overlay:SetPoint("BOTTOMRIGHT", 1, -1)
    button.overlay:SetVertexColor(0.4,0.35,0.35,1)
    button.overlay:Show()
    button.overlay.Hide = function() end
    
    local back = button:CreateTexture(nil, "BACKGROUND")
    back:SetPoint("TOPLEFT",button.icon,"TOPLEFT",-0.18*bw,0.18*bw)
    back:SetPoint("BOTTOMRIGHT",button.icon,"BOTTOMRIGHT",0.18*bw,-0.18*bw)
    back:SetTexture("Interface\\AddOns\\rTextures\\simplesquare_glow")
    back:SetVertexColor(0, 0, 0, 1)
    
  end
  

  ---------------------------------------------
  -- PLAYER STYLE FUNC
  ---------------------------------------------

  local function createStyle(self)
  
    --apply config to self
    self.cfg = cfg.units.player
    
    --init
    initUnitParameters(self)

    --create the actionbarbackground
    createActionBarBackground(self)
    
    --create the health orb
    self.Health = createOrb(self,"health")
    --create the power orb
    self.Power = createOrb(self,"power")
    
    createHealthPowerStrings(self)

    self.Health.PostUpdate = updatePlayerHealth
    self.Power.PostUpdate = updatePlayerPower
    
    --fix to update druid power correctly when cat has 100 power
    self.Power:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
    self.Power:SetScript("OnEvent", function(s,e)
      if e == "UPDATE_SHAPESHIFT_FORM" then
        updatePlayerPower(s,"player",UnitPower("player"),UnitPowerMax("player"))
      end
    end)
    
    --create art textures do this now for correct frame stacking
    createAngelFrame(self)
    createDemonFrame(self)
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
    func.createCastbar(self)

    --auras
    if self.cfg.auras.show then
      func.createBuffs(self)
      func.createDebuffs(self)      
      self.Buffs.PostCreateIcon = createAuraIcon
      self.Buffs.PostUpdateIcon = postUpdateAuraIcon      
      self.Debuffs.PostCreateIcon = createAuraIcon
      self.Debuffs.PostUpdateIcon = postUpdateAuraIcon      
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