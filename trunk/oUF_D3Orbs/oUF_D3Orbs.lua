 
  -- Colors
  local colors2 = {
    power = {
      [0] = { r = 48/255, g = 113/255, b = 191/255}, -- Mana
      [1] = { r = 255/255, g = 1/255, b = 1/255}, -- Rage
      [2] = { r = 255/255, g = 178/255, b = 0}, -- Focus
      [3] = { r = 1, g = 1, b = 34/255}, -- Energy
      [4] = { r = 0, g = 1, b = 1} -- Happiness
    },
    health = {
      [0] = {r = 49/255, g = 207/255, b = 37/255}, -- Health
      [1] = {r = .6, g = .6, b = .6}, -- Tapped targets
      [2] = {r = .1, g = .1, b = .1} -- black bar
    },
    happiness = {
      [0] = {r = 1, g = 1, b = 1}, -- bla test
      [1] = {r = 1, g = 0, b = 0}, -- need.... | unhappy
      [2] = {r = 1 ,g = 1, b = 0}, -- new..... | content
      [3] = {r = 0, g = 1, b = 0}, -- colors.. | happy
    },
  }
  
  local function menu(self)
    local unit = self.unit:sub(1, -2)
    local cunit = self.unit:gsub("(.)", string.upper, 1)
    if(unit == "party" or unit == "partypet") then
      ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor", 0, 0)
    elseif(_G[cunit.."FrameDropDown"]) then
      ToggleDropDownMenu(1, nil, _G[cunit.."FrameDropDown"], "cursor", 0, 0)
    end
  end
  
  local function SetFontString(parent, fontName, fontHeight, fontStyle)
    local fs = parent:CreateFontString(nil, "OVERLAY")
    fs:SetFont(NAMEPLATE_FONT, fontHeight, fontStyle)
    --fs:SetJustifyH("CENTER")
    fs:SetShadowColor(0,0,0,1)
    return fs
  end
  
  local function auraIcon(self, button, icons, index, debuff)
    icons.showDebuffType = false
    button.cd:SetReverse()
    button.icon:SetTexCoord(.07, .93, .07, .93)
    button.count:SetPoint("BOTTOMRIGHT", button, 1, 0)
    button.count:SetTextColor(.84,.75,.65)
    button:SetScript("OnMouseUp", function(self, mouseButton)
      if mouseButton == "RightButton" then
        local name, rank = UnitBuff("player", index)
        CancelPlayerBuff(name, rank)
      end
    end)
  
    self.ButtonOverlay = button:CreateTexture(nil, "OVERLAY")
    self.ButtonOverlay:SetTexture("Interface\\AddOns\\oUF_Orbs\\textures\\gloss.tga")
    self.ButtonOverlay:SetParent(button)
    self.ButtonOverlay:SetPoint("TOPLEFT", -1, 1)
    self.ButtonOverlay:SetPoint("BOTTOMRIGHT", 1, -1)
    --self.ButtonOverlay:SetVertexColor(.31,.45,.63,1)
    --self.ButtonOverlay:SetBlendMode("BLEND")
  
  end
  
  -- yyyyyyyyyyyyyyyyyyyyyyy
  
  local function updateHealth(self, event, unit, bar, min, max)
    local lifeact = UnitHealth(unit)
    local lifemax = UnitHealthMax(unit)
    self.Health.Filling:SetHeight((lifeact / lifemax) * self.Health:GetWidth())
    self.Health.Filling:SetTexCoord(0,1,  math.abs(lifeact / lifemax - 1),1)
    self.pm1:SetAlpha((lifeact / lifemax)/2)
    self.pm2:SetAlpha((lifeact / lifemax)/2)
  end
  
  local function updatePower(self, event, unit, bar, min, max)
    local manaact = UnitMana(unit)
    local manamax = UnitManaMax(unit)
    if (manamax == 0) then
      self.Power.Filling:SetHeight(0)
      self.Power.Filling:SetTexCoord(0,1,1,1)
      self.pm3:SetAlpha(0)
      self.pm4:SetAlpha(0)
    else
      self.Power.Filling:SetHeight((manaact / manamax) * self.Power:GetWidth())
      self.Power.Filling:SetTexCoord(0,1,  math.abs(manaact / manamax - 1),1)
      self.pm3:SetAlpha((manaact / manamax)/2)
      self.pm4:SetAlpha((manaact / manamax)/2)
    end
  end
  
 
  local function styleFunc1(self, unit)
    local _, class = UnitClass("player")
    self.menu = menu
    self:RegisterForClicks("AnyUp")
    self:SetAttribute("*type2", "menu")
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)
    
    self:SetFrameStrata("BACKGROUND")
    
    if unit == "player" or unit == "target" then
      orbsize = 130
    else
      orbsize = 70
    end
    
    self:SetHeight(orbsize)
    self:SetWidth(orbsize)
  
    if unit == "player" then
      self.Health = CreateFrame("StatusBar", nil, self)
      self.Health:SetStatusBarTexture("Interface\\AddOns\\oUF_Orbs\\textures\\orb_transparent.tga")
      self.Health:SetHeight(orbsize)
      self.Health:SetWidth(orbsize)
      self.Health:SetPoint("TOPLEFT", 0, 0)
    else
      self.Health = CreateFrame("StatusBar", nil, self)
      --want non-transparent background? comment this in.
      --self.Health:SetBackdrop({bgFile = "Interface\\AddOns\\oUF_Orbs\\textures\\orb_back_flat.tga", insets = {top = 0, left = 0, bottom = 0, right = 0}})
      self.Health:SetStatusBarTexture("Interface\\AddOns\\oUF_Orbs\\textures\\orb_transparent.tga")
      self.Health:SetHeight(orbsize)
      self.Health:SetWidth(orbsize)
      self.Health:SetPoint("TOPLEFT",0,0)
    end
    
    self.Health.bg = self.Health:CreateTexture(nil, "BACKGROUND")
    self.Health.bg:SetTexture("Interface\\AddOns\\oUF_Orbs\\textures\\orb_back.tga")
    self.Health.bg:SetAllPoints(self.Health)
    
    self.Health.Filling = self.Health:CreateTexture(nil, "ARTWORK")
    self.Health.Filling:SetTexture("Interface\\AddOns\\oUF_Orbs\\textures\\orb_filling4.tga")
    self.Health.Filling:SetPoint("BOTTOMLEFT",0,0)
    self.Health.Filling:SetWidth(orbsize)
    self.Health.Filling:SetHeight(orbsize)
    self.Health.Filling:SetVertexColor(0.4,0,0,1)
    
    self.Health.Gloss = self.Health:CreateTexture(nil, "OVERLAY")
    self.Health.Gloss:SetTexture("Interface\\AddOns\\oUF_Orbs\\textures\\orb_gloss.tga")
    self.Health.Gloss:SetAllPoints(self.Health)
  
    self.pm1 = CreateFrame("PlayerModel", nil,self.Health)
    self.pm1:SetFrameStrata("BACKGROUND")
    self.pm1:SetAllPoints(self.Health)
    self.pm1:SetModel("SPELLS\\RedRadiationFog.m2")
    self.pm1:SetModelScale(-.75)
    self.pm1:SetPosition(-12, 1.5, -1) 
    self.pm1:SetRotation(0)    
    --self.pm1:SetAlpha(0.8)
    
    self.pm1:SetScript("OnShow",function() 
      self.pm1:ClearModel()
      self.pm1:SetModel("SPELLS\\RedRadiationFog.m2")
      self.pm1:SetModelScale(.75)
      self.pm1:SetPosition(-12, 1.5, -1) 
      self.pm1:SetRotation(0)    
      --self.pm1:SetAlpha(0.8)
    end)
    
    self.pm2 = CreateFrame("PlayerModel", nil,self.Health)
    self.pm2:SetFrameStrata("BACKGROUND")
    self.pm2:SetAllPoints(self.Health)
    self.pm2:SetModel("SPELLS\\RedRadiationFog.m2")
    self.pm2:SetModelScale(-.75)
    self.pm2:SetPosition(-12, 1.5, 0.5) 
    self.pm2:SetRotation(0)    
    --self.pm2:SetAlpha(0.8)
    
    self.pm2:SetScript("OnShow",function() 
      self.pm2:ClearModel()
      self.pm2:SetModel("SPELLS\\RedRadiationFog.m2")
      self.pm2:SetModelScale(.75)
      self.pm2:SetPosition(-12, 1.5, 0.5) 
      self.pm2:SetRotation(0)    
      --self.pm2:SetAlpha(0.8)
    end)  
  
  
    
    if unit == "player" then
      self.Power = CreateFrame("StatusBar", nil, self)
      --want non-transparent background? comment this in.
      --self.Power:SetBackdrop({bgFile = "Interface\\AddOns\\oUF_Orbs\\textures\\orb_back_flat.tga", insets = {top = 0, left = 0, bottom = 0, right = 0}})
      self.Power:SetStatusBarTexture("Interface\\AddOns\\oUF_Orbs\\textures\\orb_transparent.tga")
      self.Power:SetHeight(orbsize)
      self.Power:SetWidth(orbsize)
      self.Power:SetPoint("BOTTOM", UIParent, "BOTTOM", 224, -8)
    else
      self.Power = CreateFrame("StatusBar", nil, self)
      --want non-transparent background? comment this in.
      --self.Power:SetBackdrop({bgFile = "Interface\\AddOns\\oUF_Orbs\\textures\\orb_back_flat.tga", insets = {top = 0, left = 0, bottom = 0, right = 0}})
      self.Power:SetStatusBarTexture("Interface\\AddOns\\oUF_Orbs\\textures\\orb_transparent.tga")
      self.Power:SetHeight(orbsize/1.5)
      self.Power:SetWidth(orbsize/1.5)
      self.Power:SetPoint("CENTER", self.Health, "CENTER", orbsize/2.5, -orbsize/3)
      self.Power:SetFrameLevel(4)
    end
    
    self.Power.bg = self.Power:CreateTexture(nil, "BACKGROUND")
    self.Power.bg:SetTexture("Interface\\AddOns\\oUF_Orbs\\textures\\orb_back.tga")
    self.Power.bg:SetAllPoints(self.Power)

    if unit == "player" then
      self.Power.Filling = self.Power:CreateTexture(nil, "ARTWORK")
      self.Power.Filling:SetTexture("Interface\\AddOns\\oUF_Orbs\\textures\\orb_filling4.tga")
      self.Power.Filling:SetPoint("BOTTOMLEFT",0,0)
      self.Power.Filling:SetWidth(orbsize)
      self.Power.Filling:SetHeight(orbsize)
      self.Power.Filling:SetVertexColor(0,0,0.4,1)
    else
      self.Power.Filling = self.Power:CreateTexture(nil, "ARTWORK")
      self.Power.Filling:SetTexture("Interface\\AddOns\\oUF_Orbs\\textures\\orb_filling4.tga")
      self.Power.Filling:SetPoint("BOTTOMLEFT",0,0)
      self.Power.Filling:SetWidth(orbsize/1.5)
      self.Power.Filling:SetHeight(orbsize/1.5)
      self.Power.Filling:SetVertexColor(0,0,0.4,1)
    end
    
    self.Power.Gloss = self.Power:CreateTexture(nil, "OVERLAY")
    self.Power.Gloss:SetTexture("Interface\\AddOns\\oUF_Orbs\\textures\\orb_gloss.tga")
    self.Power.Gloss:SetAllPoints(self.Power)
  
    self.pm3 = CreateFrame("PlayerModel", nil,self.Power)
    self.pm3:SetFrameStrata("BACKGROUND")
    self.pm3:SetAllPoints(self.Power)
    self.pm3:SetModel("SPELLS\\BlueRadiationFog.m2")
    self.pm3:SetModelScale(-.75)
    self.pm3:SetPosition(-12, 1.5, -1) 
    self.pm3:SetRotation(0)    
    --self.pm3:SetAlpha(0.8)
    
    self.pm3:SetScript("OnShow",function() 
      self.pm3:ClearModel()
      self.pm3:SetModel("SPELLS\\BlueRadiationFog.m2")
      self.pm3:SetModelScale(.75)
      self.pm3:SetPosition(-12, 1.5, -1) 
      self.pm3:SetRotation(0)    
      --self.pm3:SetAlpha(0.8)
    end)
    
    self.pm4 = CreateFrame("PlayerModel", nil,self.Power)
    self.pm4:SetFrameStrata("BACKGROUND")
    self.pm4:SetAllPoints(self.Power)
    self.pm4:SetModel("SPELLS\\BlueRadiationFog.m2")
    self.pm4:SetModelScale(-.75)
    self.pm4:SetPosition(-12, 1.5, 0.5) 
    self.pm4:SetRotation(0)    
    --self.pm4:SetAlpha(0.8)
    
    self.pm4:SetScript("OnShow",function() 
      self.pm4:ClearModel()
      self.pm4:SetModel("SPELLS\\BlueRadiationFog.m2")
      self.pm4:SetModelScale(.75)
      self.pm4:SetPosition(-12, 1.5, 0.5) 
      self.pm4:SetRotation(0)    
      --self.pm4:SetAlpha(0.8)
    end)  
  
  
    if(unit) then
      self.Castbar = CreateFrame("StatusBar", nil, self.Health)
      self.Castbar:SetWidth(orbsize*1.2)
      self.Castbar:SetHeight(orbsize*1.2)
      self.Castbar:SetBackdrop({bgFile = "Interface\\AddOns\\oUF_Orbs\\textures\\orb_back.tga", insets = {top = 0, left = 0, bottom = 0, right = 0}})
      self.Castbar:SetStatusBarTexture("Interface\\AddOns\\oUF_Orbs\\textures\\orb_filling2.tga")
      self.Castbar:SetStatusBarColor(1,0.8,0,1)
      self.Castbar:SetPoint("CENTER",0,0)
      
      --CASTBAR ABOVE OR BELOW ORB, YOUR CHOICE HERE. 0 = below
      self.Castbar:SetFrameLevel(0)
      
      self.Castbar:Hide()
      Castbar = self.Castbar
    end
    
    self.outsideRangeAlpha = 1
    self.inRangeAlpha = 1
    self.Range = false
      
    self.PostUpdateHealth = updateHealth
    self.PostUpdatePower = updatePower
    self.PostCreateAuraIcon = auraIcon
    self.UNIT_NAME_UPDATE = updateName
    self.UNIT_HAPPINESS = updateName
    self.PLAYER_TARGET_CHANGED = updateTarget
  
    return self
  end
  
  actstyle = "d3orb"
  --oUF:RegisterSubTypeMapping("UNIT_LEVEL")
  oUF:RegisterStyle(actstyle, styleFunc1)
  oUF:SetActiveStyle(actstyle)
  oUF:Spawn("player"):SetPoint("BOTTOM", UIParent, "BOTTOM", -224, -8)
  oUF:Spawn("target"):SetPoint("CENTER", UIParent, 250, -180)
  oUF:Spawn("pet"):SetPoint("CENTER", oUF.units.player, "CENTER",-120, 110)
  oUF:Spawn("focus"):SetPoint("CENTER", oUF.units.player, "CENTER", 0, 120)
  oUF:Spawn("targettarget"):SetPoint("CENTER", oUF.units.target, "CENTER", 0, 120)

  local d3f = CreateFrame("Frame",nil,UIParent)
  d3f:SetFrameStrata("TOOLTIP")
  d3f:SetWidth(155)
  d3f:SetHeight(155)
  d3f:SetPoint("BOTTOM",280,0)
  d3f:Show()
  local d3t = d3f:CreateTexture(nil,"BACKGROUND")
  d3t:SetTexture("Interface\\AddOns\\oUF_Orbs\\textures\\d3_angel")
  d3t:SetAllPoints(d3f)

  local d3f2 = CreateFrame("Frame",nil,UIParent)
  d3f2:SetFrameStrata("TOOLTIP")
  d3f2:SetWidth(155)
  d3f2:SetHeight(155)
  d3f2:SetPoint("BOTTOM",-287,0)
  d3f2:Show()
  local d3t2 = d3f2:CreateTexture(nil,"HIGHLIGHT ")
  d3t2:SetTexture("Interface\\AddOns\\oUF_Orbs\\textures\\d3_demon")
  d3t2:SetAllPoints(d3f2)
  
  local d3f3 = CreateFrame("Frame",nil,UIParent)
  d3f3:SetFrameStrata("TOOLTIP")
  d3f3:SetWidth(450)
  d3f3:SetHeight(112)
  d3f3:SetPoint("BOTTOM",0,-3)
  d3f3:Show()
  local d3t3 = d3f3:CreateTexture(nil,"BACKGROUND")
  d3t3:SetTexture("Interface\\AddOns\\oUF_Orbs\\textures\\d3_bottom")
  d3t3:SetAllPoints(d3f3)
  
  local d3f4 = CreateFrame("Frame",nil,UIParent)
  d3f4:SetFrameStrata("LOW")
  d3f4:SetWidth(512)
  d3f4:SetHeight(256)
  d3f4:SetPoint("BOTTOM",0,11)
  d3f4:Show()
      
  local d3t4 = d3f4:CreateTexture(nil,"BACKGROUND")
  d3t4:SetTexture("Interface\\AddOns\\oUF_Orbs\\textures\\d3_bar4")
  d3t4:SetAllPoints(d3f4)
    
