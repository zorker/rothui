  
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
    func.applyDragFunctionality(self)
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
  local createAngelFrame = function(self)
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
  local createDemonFrame = function(self)
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
  local createBottomLine = function(self)
    local cfg = self.cfg.art.bottomline
    if not cfg.show then return end
    local f = CreateFrame("Frame","oUF_DiabloBottomLine",self)
    f:SetFrameStrata("LOW")
    f:SetFrameLevel(6)
    f:SetSize(500,112)
    f:SetPoint(cfg.pos.a1, cfg.pos.af, cfg.pos.a2, cfg.pos.x, cfg.pos.y)
    f:SetScale(cfg.scale)
    func.applyDragFunctionality(f)
    local t = f:CreateTexture(nil,"LOW",nil,5)
    t:SetAllPoints(f)
    t:SetTexture("Interface\\AddOns\\rTextures\\d3_bottom")
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
    f:SetStatusBarColor(0.7,0,0.8)
    
    local r = CreateFrame("StatusBar",nil,f)
    r:SetAllPoints(f)
    r:SetStatusBarTexture(cfg.texture)
    r:SetStatusBarColor(0.9,0.7,0)
    
    func.applyDragFunctionality(f)
    
    local t = r:CreateTexture(nil,"BACKGROUND",nil,-8)
    t:SetAllPoints(r)
    t:SetTexture(cfg.texture)
    t:SetVertexColor(0.7,0,0.8,0.3)
    f.bg = t

    f:SetScript("OnEnter", function(s)
      mxp = UnitXPMax("player")
      xp = UnitXP("player")
      rxp = GetXPExhaustion()    
      GameTooltip:SetOwner(s, "ANCHOR_TOP")
      GameTooltip:AddLine("Experience / Rested", 0, 1, 0.5, 1, 1, 1)
      if UnitLevel("player") ~= MAX_PLAYER_LEVEL then
        GameTooltip:AddDoubleLine(COMBAT_XP_GAIN, xp.."/"..mxp.." ("..floor((xp/mxp)*1000)/10 .."%)",0.7,0,0.8,1,1,1)
        if rxp then
          GameTooltip:AddDoubleLine(TUTORIAL_TITLE26, rxp .." (".. floor((rxp/mxp)*1000)/10 .."%)", 0.9,0.7,0,1,1,1)
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
  
  --create buffs
  local createBuffs = function(self)
    
    --hide blizzard stuff
    ConsolidatedBuffs:UnregisterAllEvents()
    ConsolidatedBuffs:Hide()
    BuffFrame:UnregisterAllEvents()
    BuffFrame:Hide()      
    TemporaryEnchantFrame:UnregisterAllEvents()
    TemporaryEnchantFrame:Hide()
    
    local f = CreateFrame("Frame", nil, self)
    f.size = self.cfg.auras.size
    f.num = 40
    f.spacing = 10
    f:SetHeight((f.size+f.spacing)*4)
    f:SetWidth((f.size+f.spacing)*10)
    f:SetPoint("TOPRIGHT", Minimap, "TOPLEFT", -40, 2)
    f.initialAnchor = "TOPRIGHT"
    f["growth-x"] = "LEFT"
    f["growth-y"] = "DOWN"
    f.filter = "HELPFUL"
    --f.showBuffType = true
    f.disableCooldown = true
    f.onlyShowPlayer = self.cfg.auras.onlyShowPlayerBuffs

    self.Buffs = f

  end
  
  --create debuff func
  local createDebuffs = function(self)
    local f = CreateFrame("Frame", nil, self)
    f.size = self.cfg.auras.size
    f.num = 40
    f.spacing = 10
    f:SetHeight((f.size+f.spacing)*4)
    f:SetWidth((f.size+f.spacing)*10)
    f:SetPoint("TOP", self.Buffs, "BOTTOM", 0, 0)
    f.initialAnchor = "TOPRIGHT"
    f["growth-x"] = "LEFT"
    f["growth-y"] = "DOWN"
    f.filter = "HARMFUL"
    f.showDebuffType = true
    f.disableCooldown = true
    f.onlyShowPlayer = self.cfg.auras.onlyShowPlayerDebuffs
    
    self.Debuffs = f
    
  end
  
  --create galaxy func
  local createGalaxy = function(f,x,y,size,duration,texture,sublevel)
  
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
  local createOrb = function(self,type)
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
    if type == "power" then
      if cfg.manatexture >= 1 and cfg.manatexture <= 11 then
        orb.Filling:SetTexture("Interface\\AddOns\\rTextures\\orb_filling"..cfg.manatexture)
      else
        orb.Filling:SetTexture("Interface\\AddOns\\rTextures\\orb_filling"..math.random(1,11))
      end
    else
      if cfg.healthtexture >= 1 and cfg.healthtexture <= 11 then
        orb.Filling:SetTexture("Interface\\AddOns\\rTextures\\orb_filling"..cfg.healthtexture)
      else
        orb.Filling:SetTexture("Interface\\AddOns\\rTextures\\orb_filling"..math.random(1,11))
      end
    end
    --IMPORTANT, settexcoord will not work with other settings
    orb.Filling:SetPoint("BOTTOMLEFT",0,0)
    orb.Filling:SetHeight(self.cfg.height)
    orb.Filling:SetWidth(self.cfg.width)
    --orb.Filling:SetBlendMode("ADD")
    
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
      orb.DebuffGlow:SetSize(self.cfg.width+5,self.cfg.width+5)
      orb.DebuffGlow:SetBlendMode("BLEND")
      orb.DebuffGlow:SetVertexColor(0, 1, 1, 0) -- set alpha to 0 to hide the texture
      orb.DebuffGlow:SetTexture("Interface\\AddOns\\rTextures\\orb_debuff_glow")
      self.DebuffHighlight = orb.DebuffGlow
      self.DebuffHighlightAlpha = 1
      self.DebuffHighlightFilter = false
      
      --low hp glow
      orb.LowHP = orb:CreateTexture(nil, "BACKGROUND", nil, -5)
      orb.LowHP:SetPoint("CENTER",0,0)
      orb.LowHP:SetSize(self.cfg.width-5,self.cfg.width-5)
      orb.LowHP:SetTexture("Interface\\AddOns\\rTextures\\orb_lowhp_glow")
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
      --print("ding")
    elseif not status and swapper ~= "n" then
      bar.Filling:SetVertexColor(cfg.galaxytab[cfg.healthcolor].r, cfg.galaxytab[cfg.healthcolor].g, cfg.galaxytab[cfg.healthcolor].b)
      bar.galaxy[1]:SetVertexColor(cfg.galaxytab[cfg.healthcolor].r, cfg.galaxytab[cfg.healthcolor].g, cfg.galaxytab[cfg.healthcolor].b)
      bar.galaxy[2]:SetVertexColor(cfg.galaxytab[cfg.healthcolor].r, cfg.galaxytab[cfg.healthcolor].g, cfg.galaxytab[cfg.healthcolor].b)
      bar.galaxy[3]:SetVertexColor(cfg.galaxytab[cfg.healthcolor].r, cfg.galaxytab[cfg.healthcolor].g, cfg.galaxytab[cfg.healthcolor].b)
      swapper = "n"
      --print("dong")
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
  local createHealthPowerStrings = function(self)
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
  local updateAuraTime = function(self,elapsed)  
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
  local postUpdateAuraIcon = function(icons, unit, icon, index, offset)
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
  local createAuraIcon = function(icons, button)
    local self = icons:GetParent()
    local bw = button:GetWidth()
    if (not button.time) then
      button.time = func.createFontString(button, cfg.font, bw/1.8, "THINOUTLINE")
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
    button.cd:SetPoint("TOPLEFT", 1, -1)
    button.cd:SetPoint("BOTTOMRIGHT", -1, 1)
    button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    
    --cancelaura temp fix
    button:SetScript("OnMouseUp", function(s) 
      if s.filter == "HELPFUL" then
        local buffname = UnitAura("player", s:GetID(), s.filter)
        local eb = LAST_ACTIVE_CHAT_EDIT_BOX
        local str = "/cancelaura "..buffname
        if eb then
          eb:SetText(str)
          eb:SetFocus()
          eb:HighlightText()
        end          
      end
    end)
    
    button.count:ClearAllPoints()
    button.count:SetPoint("TOPRIGHT", 4, 4)
    button.count:SetTextColor(0.75,0.75,0.75)
    --fix the count on aurawatch, make the count fontsize button size dependend
    button.count:SetFont(cfg.font,bw/1.8,"THINOUTLINE")
    button.overlay:SetTexture("Interface\\AddOns\\rTextures\\gloss2")
    button.overlay:SetTexCoord(0,1,0,1)
    button.overlay:SetPoint("TOPLEFT", -1, 1)
    button.overlay:SetPoint("BOTTOMRIGHT", 1, -1)
    button.overlay:SetVertexColor(0.5,0.45,0.45,1)
    button.overlay:Show()
    button.overlay.Hide = function() end
    
    local back = button:CreateTexture(nil, "BACKGROUND")
    back:SetPoint("TOPLEFT",button.icon,"TOPLEFT",-0.18*bw,0.18*bw)
    back:SetPoint("BOTTOMRIGHT",button.icon,"BOTTOMRIGHT",0.18*bw,-0.18*bw)
    back:SetTexture("Interface\\AddOns\\rTextures\\simplesquare_glow")
    back:SetVertexColor(0, 0, 0, 1)
    
  end
  
  --update soul shards
  local updateShards = function(self, event, unit, powerType)
    if(self.unit ~= unit or (powerType and powerType ~= "SOUL_SHARDS")) then return end
    local num = UnitPower(unit, SPELL_POWER_SOUL_SHARDS)
    local bar = self.SoulShardBar
    for i = 1, SHARD_BAR_NUM_SHARDS do
      if(i <= num) then
        bar.filling[i]:Show()
        bar.glow[i]:Show()
      else
        bar.filling[i]:Hide()
        bar.glow[i]:Hide()
      end
    end
  end
  
  --create soul shards
  local createSoulShardBar = function(self)
    
    self.SoulShards = {}
    
    local t
    local bar = CreateFrame("Frame","oUF_DiabloSoulShards",self)
    local w = 64*(SHARD_BAR_NUM_SHARDS+2)
    local h = 64
    bar:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    bar:SetWidth(w)
    bar:SetHeight(h)
    
    t = bar:CreateTexture(nil,"BACKGROUND",nil,-8)
    t:SetSize(64,64)
    t:SetPoint("LEFT",0,0)
    t:SetTexture("Interface\\AddOns\\rTextures\\combo_left")
    bar.leftedge = t

    t = bar:CreateTexture(nil,"BACKGROUND",nil,-8)
    t:SetSize(64,64)
    t:SetPoint("RIGHT",0,0)
    t:SetTexture("Interface\\AddOns\\rTextures\\combo_right")
    bar.rightedge = t

    bar.back = {}
    bar.filling = {}
    bar.glow = {}
    bar.gloss = {}
    
    for i = 1, SHARD_BAR_NUM_SHARDS do
      local back = "back"..i
      bar.back[i] = bar:CreateTexture(nil,"BACKGROUND",nil,-8)  
      bar.back[i]:SetSize(64,64)
      bar.back[i]:SetPoint("LEFT",i*64,0)
      bar.back[i]:SetTexture("Interface\\AddOns\\rTextures\\combo_back")

      bar.filling[i] = bar:CreateTexture(nil,"BACKGROUND",nil,-7)  
      bar.filling[i]:SetSize(64,64)
      bar.filling[i]:SetPoint("LEFT",i*64,0)
      bar.filling[i]:SetTexture("Interface\\AddOns\\rTextures\\combo_fill")
      bar.filling[i]:SetVertexColor(self.cfg.soulshards.color.r,self.cfg.soulshards.color.g,self.cfg.soulshards.color.b,1)
      bar.filling[i]:SetBlendMode("ADD")

      bar.glow[i] = bar:CreateTexture(nil,"BACKGROUND",nil,-6)  
      bar.glow[i]:SetSize(64*1.25,64*1.25)
      bar.glow[i]:SetPoint("CENTER", bar.filling[i], "CENTER", 0, 0)
      bar.glow[i]:SetTexture("Interface\\AddOns\\rTextures\\combo_glow")
      bar.glow[i]:SetBlendMode("ADD")
      bar.glow[i]:SetVertexColor(self.cfg.soulshards.color.r,self.cfg.soulshards.color.g,self.cfg.soulshards.color.b,1)

      bar.gloss[i] = bar:CreateTexture(nil,"BACKGROUND",nil,-5)  
      bar.gloss[i]:SetSize(64,64)
      bar.gloss[i]:SetPoint("LEFT",i*64,0)
      bar.gloss[i]:SetTexture("Interface\\AddOns\\rTextures\\combo_highlight")
      bar.gloss[i]:SetBlendMode("ADD")
      
      bar.color = self.cfg.soulshards.color

      self.SoulShards[i] = bar.filling[i]
    end

    bar:SetScale(self.cfg.soulshards.scale)    
    func.applyDragFunctionalityNoRestrict(bar)    
    self.SoulShardBar = bar

  end
  
  --update holy power
  local updateHolyPower = function(self, event, unit, powerType)
    if(self.unit ~= unit or (powerType and powerType ~= "HOLY_POWER")) then return end
    local num = UnitPower(unit, SPELL_POWER_HOLY_POWER)
    local bar = self.HolyPowerBar
    for i = 1, MAX_HOLY_POWER do
      if(i <= num) then
        bar.filling[i]:Show()
        bar.glow[i]:Show()
      else
        bar.filling[i]:Hide()
        bar.glow[i]:Hide()
      end
    end
  end

  --create holy power bar
  local createHolyPowerBar = function(self)
    
    self.HolyPower = {}
    
    local t
    local bar = CreateFrame("Frame","oUF_DiabloHolyPower",self)
    local w = 64*(MAX_HOLY_POWER+2)
    local h = 64
    bar:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    bar:SetWidth(w)
    bar:SetHeight(h)
    
    t = bar:CreateTexture(nil,"BACKGROUND",nil,-8)
    t:SetSize(64,64)
    t:SetPoint("LEFT",0,0)
    t:SetTexture("Interface\\AddOns\\rTextures\\combo_left")
    bar.leftedge = t

    t = bar:CreateTexture(nil,"BACKGROUND",nil,-8)
    t:SetSize(64,64)
    t:SetPoint("RIGHT",0,0)
    t:SetTexture("Interface\\AddOns\\rTextures\\combo_right")
    bar.rightedge = t

    bar.back = {}
    bar.filling = {}
    bar.glow = {}
    bar.gloss = {}
    
    for i = 1, MAX_HOLY_POWER do
      local back = "back"..i
      bar.back[i] = bar:CreateTexture(nil,"BACKGROUND",nil,-8)  
      bar.back[i]:SetSize(64,64)
      bar.back[i]:SetPoint("LEFT",i*64,0)
      bar.back[i]:SetTexture("Interface\\AddOns\\rTextures\\combo_back")

      bar.filling[i] = bar:CreateTexture(nil,"BACKGROUND",nil,-7)  
      bar.filling[i]:SetSize(64,64)
      bar.filling[i]:SetPoint("LEFT",i*64,0)
      bar.filling[i]:SetTexture("Interface\\AddOns\\rTextures\\combo_fill")
      bar.filling[i]:SetVertexColor(self.cfg.holypower.color.r,self.cfg.holypower.color.g,self.cfg.holypower.color.b,1)
      bar.filling[i]:SetBlendMode("ADD")

      bar.glow[i] = bar:CreateTexture(nil,"BACKGROUND",nil,-6)  
      bar.glow[i]:SetSize(64*1.25,64*1.25)
      bar.glow[i]:SetPoint("CENTER", bar.filling[i], "CENTER", 0, 0)
      bar.glow[i]:SetTexture("Interface\\AddOns\\rTextures\\combo_glow")
      bar.glow[i]:SetBlendMode("ADD")
      bar.glow[i]:SetVertexColor(self.cfg.holypower.color.r,self.cfg.holypower.color.g,self.cfg.holypower.color.b,1)

      bar.gloss[i] = bar:CreateTexture(nil,"BACKGROUND",nil,-5)  
      bar.gloss[i]:SetSize(64,64)
      bar.gloss[i]:SetPoint("LEFT",i*64,0)
      bar.gloss[i]:SetTexture("Interface\\AddOns\\rTextures\\combo_highlight")
      bar.gloss[i]:SetBlendMode("ADD")
      
      bar.color = self.cfg.holypower.color

      self.HolyPower[i] = bar.filling[i]
    end

    bar:SetScale(self.cfg.holypower.scale)    
    func.applyDragFunctionalityNoRestrict(bar)    
    self.HolyPowerBar = bar

  end

  --create eclipse bar
  local createEclipseBar = function(self)
    local e = _G["EclipseBarFrame"]
    e:SetParent(self)
    e:SetScale(self.cfg.eclipsebar.scale)
    e:ClearAllPoints()
    e:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    e:SetFrameStrata("HIGH")
    func.applyDragFunctionalityNoRestrict(e)
    local t = select(1, e:GetRegions())
    t:SetTexture("Interface\\AddOns\\rTextures\\eclipsebar")
    EclipseBar_OnLoad(e)
  end
  
  --create rune bar
  local createRuneBar = function(self)
    local f = CreateFrame("Frame","oUF_DiabloRuneBar",self)
    f:SetPoint(self.cfg.runes.pos.a1,self.cfg.runes.pos.af,self.cfg.runes.pos.a2,self.cfg.runes.pos.x,self.cfg.runes.pos.y)
    f:SetSize(180,50)
    func.applyDragFunctionalityNoRestrict(f)
    RuneButtonIndividual1:ClearAllPoints()
    RuneButtonIndividual1:SetPoint("LEFT",f,"LEFT",10,0)
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
    self.Power:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
    self.Power:SetScript("OnEvent", function(s,e)
      if e == "UPDATE_SHAPESHIFT_FORM" then
        updatePlayerPower(s,"player",UnitPower("player"),UnitPowerMax("player"))
      end
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

    --auras
    if self.cfg.auras.show then
      createBuffs(self)
      createDebuffs(self)      
      self.Buffs.PostCreateIcon = createAuraIcon
      self.Buffs.PostUpdateIcon = postUpdateAuraIcon      
      self.Debuffs.PostCreateIcon = createAuraIcon
      self.Debuffs.PostUpdateIcon = postUpdateAuraIcon      
    end
    
    --soulshards
    if cfg.playerclass == "WARLOCK" and self.cfg.soulshards.show then
      createSoulShardBar(self)
      self.SoulShards.Override = updateShards
    end
    
    --holypower
    if cfg.playerclass == "PALADIN" and self.cfg.holypower.show then
      createHolyPowerBar(self)
      self.HolyPower.Override = updateHolyPower
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