  
  -- possible styles
  -- d3orb, futureorb1
  
  local actstyle = "futureorb1"
  
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
  	local cunit = self.unit:gsub('(.)', string.upper, 1)
  	if(unit == 'party' or unit == 'partypet') then
  		ToggleDropDownMenu(1, nil, _G['PartyMemberFrame'..self.id..'DropDown'], 'cursor', 0, 0)
  	elseif(_G[cunit..'FrameDropDown']) then
  		ToggleDropDownMenu(1, nil, _G[cunit..'FrameDropDown'], 'cursor', 0, 0)
  	end
  end
  
  local function SetFontString(parent, fontName, fontHeight, fontStyle)
  	local fs = parent:CreateFontString(nil, 'OVERLAY')
  	fs:SetFont(NAMEPLATE_FONT, fontHeight, fontStyle)
  	--fs:SetJustifyH('CENTER')
  	fs:SetShadowColor(0,0,0,1)
  	return fs
  end
  
  -- yyyyyyyyyyyyyyyyyyyyyyy
  
  local function updateHealth(self, event, unit, bar, min, max)
    local lifeact = UnitHealth(unit)
    local lifemax = UnitHealthMax(unit)
    if actstyle == "d3orb" then
      self.Health.Filling:SetHeight((lifeact / lifemax) * self.Health:GetWidth())
      self.Health.Filling:SetTexCoord(0,1,  math.abs(lifeact / lifemax - 1),1)
      self.pm1:SetAlpha(lifeact / lifemax)
      self.pm2:SetAlpha(lifeact / lifemax)
    
    elseif actstyle == "futureorb1" then
      
      local c = max - min
  	  local d = floor(min/max*100)
      
      if d == 0 or d == 100 then
        bar.value:Hide()
      else
        bar.value:Show()
        bar.value:SetText(d)
      end
      
      self.Health.Filling:SetHeight((lifeact / lifemax) * self.Health:GetWidth())
      self.Health.Filling:SetTexCoord(0,1,  math.abs(lifeact / lifemax - 1),1)
      
      if UnitIsPlayer(unit) then
        local color = RAID_CLASS_COLORS[select(2, UnitClass(unit))]
        self.Health.Filling:SetVertexColor(color.r, color.g, color.b,1)
      elseif unit == "pet" and UnitExists("pet") and GetPetHappiness() then
        local happiness, _, _ = GetPetHappiness()
        --DEFAULT_CHAT_FRAME:AddMessage("Pet is " .. happiness)
        local color = colors2.happiness[happiness]
        --DEFAULT_CHAT_FRAME:AddMessage("color "..color.r.." "..color.g.." "..color.b)
        self.Health.Filling:SetVertexColor(color.r, color.g, color.b,1)
      else
        local color = UnitReactionColor[UnitReaction(unit, "player")]
        self.Health.Filling:SetVertexColor(color.r, color.g, color.b,1)
      end
      
      
      
    end
  end
  
  local function updatePower(self, event, unit, bar, min, max)
    if actstyle == "d3orb" then
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
        self.pm3:SetAlpha(manaact / manamax)
        self.pm4:SetAlpha(manaact / manamax)
      end
    
    elseif actstyle == "futureorb1" then
      
      local c, d
      
      if max == 0 then
        d = 0
      else
        c = max - min
  	    d = floor(min/max*100)
      end

      if d == 0 or d == 100 then
        bar.value:Hide()
      else
        bar.value:Show()
        bar.value:SetText(d)
      end

      local color = colors2.power[UnitPowerType(unit)]
      bar:SetStatusBarColor(color.r, color.g, color.b)
      
      bar.value:SetTextColor(.5, .5, .5)
      
    end
  end
  
 
  local function styleFunc1(self, unit)
  	local _, class = UnitClass('player')
  	self.menu = menu
  	self:RegisterForClicks('AnyUp')
  	self:SetAttribute('*type2', 'menu')
  	self:SetScript('OnEnter', UnitFrame_OnEnter)
  	self:SetScript('OnLeave', UnitFrame_OnLeave)
    
    self:SetFrameStrata("BACKGROUND")
    
    if unit == 'player' or unit == 'target' then
      orbsize = 120
    else
      orbsize = 70
    end
    
    self:SetHeight(orbsize)
    self:SetWidth(orbsize)
  
  	self.Health = CreateFrame('StatusBar', nil, self)
    --want non-transparent background? comment this in.
    --self.Health:SetBackdrop({bgFile = "Interface\\AddOns\\oUF_Orbs\\orb_back_flat.tga", insets = {top = 0, left = 0, bottom = 0, right = 0}})
  	self.Health:SetStatusBarTexture("Interface\\AddOns\\oUF_Orbs\\orb_transparent.tga")
    self.Health:SetHeight(orbsize)
    self.Health:SetWidth(orbsize)
    self.Health:SetPoint("TOPLEFT",0,0)
    
  	self.Health.bg = self.Health:CreateTexture(nil, "BACKGROUND")
    self.Health.bg:SetTexture("Interface\\AddOns\\oUF_Orbs\\orb_back.tga")
    self.Health.bg:SetAllPoints(self.Health)
    
  	self.Health.Filling = self.Health:CreateTexture(nil, "ARTWORK")
    self.Health.Filling:SetTexture("Interface\\AddOns\\oUF_Orbs\\orb_filling.tga")
    self.Health.Filling:SetPoint("BOTTOMLEFT",0,0)
    self.Health.Filling:SetWidth(orbsize)
    self.Health.Filling:SetHeight(orbsize)
    self.Health.Filling:SetVertexColor(1,0,0,1)
    
  	self.Health.Gloss = self.Health:CreateTexture(nil, "OVERLAY")
    self.Health.Gloss:SetTexture("Interface\\AddOns\\oUF_Orbs\\orb_gloss.tga")
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
  
  
  	self.Power = CreateFrame('StatusBar', nil, self)
    
    --want non-transparent background? comment this in.
    --self.Power:SetBackdrop({bgFile = "Interface\\AddOns\\oUF_Orbs\\orb_back_flat.tga", insets = {top = 0, left = 0, bottom = 0, right = 0}})
  	self.Power:SetStatusBarTexture("Interface\\AddOns\\oUF_Orbs\\orb_transparent.tga")
    self.Power:SetHeight(orbsize/1.5)
    self.Power:SetWidth(orbsize/1.5)
  	self.Power:SetPoint('CENTER', self.Health, 'CENTER', orbsize/2.5, -orbsize/3)
  	self.Power:SetFrameLevel(4)
    
  	self.Power.bg = self.Power:CreateTexture(nil, "BACKGROUND")
    self.Power.bg:SetTexture("Interface\\AddOns\\oUF_Orbs\\orb_back.tga")
    self.Power.bg:SetAllPoints(self.Power)
    
  	self.Power.Filling = self.Power:CreateTexture(nil, "ARTWORK")
    self.Power.Filling:SetTexture("Interface\\AddOns\\oUF_Orbs\\orb_filling.tga")
    self.Power.Filling:SetPoint("BOTTOMLEFT",0,0)
    self.Power.Filling:SetWidth(orbsize/1.5)
    self.Power.Filling:SetHeight(orbsize/1.5)
    self.Power.Filling:SetVertexColor(0,0,1,1)
    
  	self.Power.Gloss = self.Power:CreateTexture(nil, "OVERLAY")
    self.Power.Gloss:SetTexture("Interface\\AddOns\\oUF_Orbs\\orb_gloss.tga")
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
  		self.Castbar:SetBackdrop({bgFile = "Interface\\AddOns\\oUF_Orbs\\orb_back.tga", insets = {top = 0, left = 0, bottom = 0, right = 0}})
  		self.Castbar:SetStatusBarTexture("Interface\\AddOns\\oUF_Orbs\\orb_filling2.tga")
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
  
  local function styleFunc2(self, unit)
  	local _, class = UnitClass('player')
  	self.menu = menu
  	self:RegisterForClicks('AnyUp')
  	self:SetAttribute('*type2', 'menu')
  	self:SetScript('OnEnter', UnitFrame_OnEnter)
  	self:SetScript('OnLeave', UnitFrame_OnLeave)
    
    self:SetFrameStrata("BACKGROUND")
    
    if unit == 'player' or unit == 'target' then
      orbsize = 140
    else
      orbsize = 80
    end
    
    -- xxxxxxxxxxxxxxxxxxxxxxx
    
    self:SetHeight(orbsize)
    self:SetWidth(orbsize)
    
  	self.bg = self:CreateTexture(nil, "BACKGROUND")
    self.bg:SetTexture("Interface\\AddOns\\oUF_Orbs\\orb_back.tga")
    self.bg:SetAllPoints(self)
    self.bg:SetAlpha(0.7)
  
    self.castbg = self:CreateTexture(nil, "BACKGROUND")
    self.castbg:SetTexture("Interface\\AddOns\\oUF_Orbs\\future_orb_top.tga")
    self.castbg:SetAllPoints(self)
    self.castbg:SetAlpha(0.2)
  
    self.manabg = self:CreateTexture(nil, "BACKGROUND")
    self.manabg:SetTexture("Interface\\AddOns\\oUF_Orbs\\future_orb_bottom.tga")
    self.manabg:SetAllPoints(self)
    self.manabg:SetAlpha(0.3)
  
  	if(unit) then
  		self.Castbar = CreateFrame("StatusBar", nil, self)
  		self.Castbar:SetWidth(orbsize)
  		self.Castbar:SetHeight(orbsize)
  		self.Castbar:SetStatusBarTexture("Interface\\AddOns\\oUF_Orbs\\future_orb_top.tga")
  		self.Castbar:SetStatusBarColor(1,0.8,0,1)
  		self.Castbar:SetPoint("CENTER",0,0)
  		self.Castbar:Hide()
  		Castbar = self.Castbar

      if unit == 'player' or unit == 'target' then
        self.Castbar.Text = SetFontString(self.Castbar, nil, 18, "THINOUTLINE")
  		  self.Castbar.Text:SetPoint('TOP', 0, 20)
      else
        self.Castbar.Text = SetFontString(self.Castbar, nil, 13, "THINOUTLINE")
        self.Castbar.Text:SetPoint('TOP', 0, 17)
      end
  		--self.Castbar.Text:SetWidth(orbsize*1.8)
  		self.Castbar.Text:SetTextColor(.7,.7,.7)
  		Castbar.text = self.Castbar.Text
  
      --cast time
      --[[
      if unit == 'player' or unit == 'target' then
        self.Castbar.Time = SetFontString(self.Castbar, nil, 18, "THINOUTLINE")
  		  self.Castbar.Time:SetPoint("LEFT", self.Castbar.Text, "RIGHT", 0, 0)
      else
        self.Castbar.Time = SetFontString(self.Castbar, nil, 13, "THINOUTLINE")
        self.Castbar.Time:SetPoint("LEFT", self.Castbar.Text, "RIGHT", 0, 0)
      end
  		self.Castbar.Time:SetTextColor(.7,.7,.7)
  		Castbar.casttime = self.Castbar.Time
  		]]--

    end
    

    
  	self.Power = CreateFrame('StatusBar', nil, self)
  	self.Power:SetStatusBarTexture("Interface\\AddOns\\oUF_Orbs\\future_orb_bottom.tga")
    self.Power:SetHeight(orbsize)
    self.Power:SetWidth(orbsize)
  	self.Power:SetPoint("CENTER",0,0)
  	self.Power:SetStatusBarColor(0,0.5,1,1)
  	
    if unit == 'player' or unit == 'target' then
      self.Power.value = SetFontString(self.Power, nil, 18, "THINOUTLINE")
		  self.Power.value:SetPoint('BOTTOM', 0, -15)
    else
      self.Power.value = SetFontString(self.Power, nil, 13, "THINOUTLINE")
      self.Power.value:SetPoint('BOTTOM', 0, -12)
    end
		self.Power.value:SetAlpha(0.9)
  
  	self.Health = CreateFrame('StatusBar', nil, self)
  	self.Health:SetStatusBarTexture("Interface\\AddOns\\oUF_Orbs\\orb_transparent.tga")
    self.Health:SetHeight(orbsize/1.4)
    self.Health:SetWidth(orbsize/1.4)
    self.Health:SetPoint("CENTER",0,0)
    
  	self.Health.bg = self.Health:CreateTexture(nil, "BACKGROUND")
    self.Health.bg:SetTexture("Interface\\AddOns\\oUF_Orbs\\orb_back.tga")
    self.Health.bg:SetAllPoints(self.Health)
    self.Health.bg:SetAlpha(1)
    
  	self.Health.Filling = self.Health:CreateTexture(nil, "ARTWORK")
    self.Health.Filling:SetTexture("Interface\\AddOns\\oUF_Orbs\\orb_filling4.tga")
    self.Health.Filling:SetPoint("BOTTOMLEFT",0,0)
    self.Health.Filling:SetWidth(orbsize/1.4)
    self.Health.Filling:SetHeight(orbsize/1.4)
    --self.Health.Filling:SetVertexColor(1,0,0,1)
    
    if unit == 'player' or unit == 'target' then
      self.Health.value = SetFontString(self.Health, nil, 24, "THINOUTLINE")
      self.Name = SetFontString(self.Health, font, 20, "THINOUTLINE")
	    self.Name:SetPoint('TOP', 0, 60)
    else
      self.Health.value = SetFontString(self.Health, nil, 16, "THINOUTLINE")
      self.Name = SetFontString(self.Health, font, 14, "THINOUTLINE")
	    self.Name:SetPoint('TOP', 0, 44)
    end
		self.Health.value:SetPoint('CENTER', 0, 0)
		self.Health.value:SetAlpha(0.9)
    
  	self.Health.Gloss = self.Health:CreateTexture(nil, "OVERLAY")
    self.Health.Gloss:SetTexture("Interface\\AddOns\\oUF_Orbs\\orb_gloss.tga")
    self.Health.Gloss:SetAllPoints(self.Health)  

  	
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
  
  if actstyle == "d3orb" then
    --oUF:RegisterSubTypeMapping('UNIT_LEVEL')
    oUF:RegisterStyle(actstyle, styleFunc1)
    oUF:SetActiveStyle(actstyle)
    oUF:Spawn('player'):SetPoint('CENTER', UIParent, -250, -180)
    oUF:Spawn('target'):SetPoint('CENTER', UIParent, 250, -180)
    oUF:Spawn('pet'):SetPoint('CENTER', oUF.units.player, 'CENTER',-120, 0)
    oUF:Spawn('focus'):SetPoint('CENTER', oUF.units.player, 'CENTER', 0, 120)
    oUF:Spawn('targettarget'):SetPoint('CENTER', oUF.units.target, 'CENTER', 0, 120)
  end

  if actstyle == "futureorb1" then
    --oUF:RegisterSubTypeMapping('UNIT_LEVEL')
    oUF:RegisterStyle(actstyle, styleFunc2)
    oUF:SetActiveStyle(actstyle)
    oUF:Spawn('player'):SetPoint('CENTER', UIParent, -250, -180)
    oUF:Spawn('target'):SetPoint('CENTER', UIParent, 250, -180)
    oUF:Spawn('pet'):SetPoint('LEFT', oUF.units.player, 'RIGHT',20, -20)
    oUF:Spawn('focus'):SetPoint('RIGHT', oUF.units.player, 'LEFT', -20, -20)
    oUF:Spawn('targettarget'):SetPoint('RIGHT', oUF.units.target, 'LEFT', -20, -20)
  end