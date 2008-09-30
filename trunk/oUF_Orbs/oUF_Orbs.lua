  
  local function menu(self)
  	local unit = self.unit:sub(1, -2)
  	local cunit = self.unit:gsub('(.)', string.upper, 1)
  	if(unit == 'party' or unit == 'partypet') then
  		ToggleDropDownMenu(1, nil, _G['PartyMemberFrame'..self.id..'DropDown'], 'cursor', 0, 0)
  	elseif(_G[cunit..'FrameDropDown']) then
  		ToggleDropDownMenu(1, nil, _G[cunit..'FrameDropDown'], 'cursor', 0, 0)
  	end
  end
  
  local function updateHealth(self, event, unit, bar, min, max)
    local lifeact = UnitHealth(unit)
    local lifemax = UnitHealthMax(unit)
    self.Health.Filling:SetHeight((lifeact / lifemax) * self.Health:GetWidth())
    self.Health.Filling:SetTexCoord(0,1,  math.abs(lifeact / lifemax - 1),1)
    self.pm1:SetAlpha(lifeact / lifemax)
    self.pm2:SetAlpha(lifeact / lifemax)
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
      self.pm3:SetAlpha(manaact / manamax)
      self.pm4:SetAlpha(manaact / manamax)
    end
  end
  
  local function styleFunc(self, unit)
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
  		
    --self:SetAttribute('initial-height', 120)
    --self:SetAttribute('initial-width', 120)
  	self.PostUpdateHealth = updateHealth
  	self.PostUpdatePower = updatePower
  	self.PostCreateAuraIcon = auraIcon
  	self.UNIT_NAME_UPDATE = updateName
  	self.UNIT_HAPPINESS = updateName
  	self.PLAYER_TARGET_CHANGED = updateTarget
  
  	return self
  end
  
  --oUF:RegisterSubTypeMapping('UNIT_LEVEL')
  oUF:RegisterStyle('Circle', styleFunc)
  oUF:SetActiveStyle('Circle')
  oUF:Spawn('player'):SetPoint('CENTER', UIParent, -250, -180)
  oUF:Spawn('target'):SetPoint('CENTER', UIParent, 250, -180)
  oUF:Spawn('pet'):SetPoint('CENTER', oUF.units.player, 'CENTER',-120, 0)
  oUF:Spawn('focus'):SetPoint('CENTER', oUF.units.player, 'CENTER', 0, 120)
  oUF:Spawn('targettarget'):SetPoint('CENTER', oUF.units.target, 'CENTER', 0, 120)
