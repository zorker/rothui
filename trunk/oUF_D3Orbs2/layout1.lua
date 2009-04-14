
  -- oUF_D3Orbs2 layout by roth - 2009
  
  -----------------------------
  -- VARIABLES
  -----------------------------
  
  local orbsize = 150
  
  local tabvalues = {
    frame_positions = {
      [1] =   { a1 = "BOTTOM",  a2 = "BOTTOM",  af = "UIParent",  x = 260,    y = -9      }, --player mana orb
      [2] =   { a1 = "BOTTOM",  a2 = "BOTTOM",  af = "UIParent",  x = -260,   y = -9      }, --player health orb
      [3] =   { a1 = "CENTER",  a2 = "CENTER",  af = "UIParent",  x = 0,      y = -200    }, --target frame
    },
  }
  
  -----------------------------
  -- FUNCTIONS
  -----------------------------

  --chat output func
  local function am(text)
    DEFAULT_CHAT_FRAME:AddMessage(text)
  end
  
  --update player health func
  local function d3o2_updatePlayerHealth(self, event, unit, bar, min, max)
    self.Health.Filling:SetHeight((min / max) * self.Power:GetWidth())
    self.Health.Filling:SetTexCoord(0,1,  math.abs(min / max - 1),1)
    self.Health.Filling:SetVertexColor(0.5,1,0)
  end
  
  --update player power func
  local function d3o2_updatePlayerPower(self, event, unit, bar, min, max)
    self.Power.Filling:SetHeight((min / max) * self.Power:GetWidth())
    self.Power.Filling:SetTexCoord(0,1,  math.abs(min / max - 1),1)
    self.Power.Filling:SetVertexColor(0,0.5,1)
  end
  
  --setup frame width, height, strata
  local function d3o2_setupFrame(self,w,h,strata)
    self:SetFrameStrata(strata)
    self:SetWidth(w)
    self:SetHeight(h)
  end
  
  --create orb func
  local function d3o2_createOrb(self,type)
    self.Orb = CreateFrame("StatusBar", nil, self)    
    self.Orb:SetStatusBarTexture("Interface\\AddOns\\rTextures\\orb_transparent.tga")
    self.Orb:SetHeight(orbsize)
    self.Orb:SetWidth(orbsize)
    if type == "power" then
      self.Orb:SetPoint(tabvalues.frame_positions[1].a1, tabvalues.frame_positions[1].af, tabvalues.frame_positions[1].a2, tabvalues.frame_positions[1].x, tabvalues.frame_positions[1].y)
      self.Orb.frequentUpdates = true
    else
      self.Orb:SetPoint("TOPLEFT", 0, 0)
    end
    self.Orb.Smooth = true
    self.Orb.bg = self.Orb:CreateTexture(nil, "BACKGROUND")
    self.Orb.bg:SetTexture("Interface\\AddOns\\rTextures\\orb_back2.tga")
    self.Orb.bg:SetAllPoints(self.Orb)
    self.Orb.Filling = self.Orb:CreateTexture(nil, "ARTWORK")
    self.Orb.Filling:SetTexture("Interface\\AddOns\\rTextures\\orb_filling4.tga")
    self.Orb.Filling:SetPoint("BOTTOMLEFT",0,0)
    self.Orb.Filling:SetWidth(orbsize)
    self.Orb.Filling:SetHeight(orbsize)
    self.OrbGlossHolder = CreateFrame("Frame", nil, self.Orb)
    self.OrbGlossHolder:SetAllPoints(self.Orb)
    self.OrbGlossHolder:SetFrameStrata("LOW")
    self.OrbOrbGloss = self.OrbGlossHolder:CreateTexture(nil, "OVERLAY")
    self.OrbOrbGloss:SetTexture("Interface\\AddOns\\rTextures\\orb_gloss.tga")
    self.OrbOrbGloss:SetAllPoints(self.OrbGlossHolder)
    return self.Orb, self.Orb.Filling
  end
  
  --create health and power bar func for every frame but not player
  local function d3o2_createHealthPowerFrames(self,type)
    self.Health = CreateFrame("StatusBar", nil, self)
    self.Health:SetStatusBarTexture("Interface\\AddOns\\rTextures\\statusbar.tga")
    self.Health:SetHeight(16)
    self.Health:SetWidth(self:GetWidth())
    self.Health:SetPoint("TOPLEFT",0,-1)
    self.bg = self:CreateTexture(nil, "BACKGROUND")
    self.bg:SetTexture("Interface\\AddOns\\rTextures\\d3_targetframe.tga")
    self.bg:SetWidth(512)
    self.bg:SetHeight(128)
    self.bg:SetPoint("CENTER",-3,0)
    self.Health.bg = self.Health:CreateTexture(nil, "BACKGROUND")
    self.Health.bg:SetTexture("Interface\\AddOns\\rTextures\\statusbar.tga")
    self.Health.bg:SetAllPoints(self.Health)    
    self.Power = CreateFrame("StatusBar", nil, self.Health)
    self.Power:SetStatusBarTexture("Interface\\AddOns\\rTextures\\statusbar.tga")
    self.Power:SetHeight(4)
    self.Power:SetWidth(self:GetWidth())
    self.Power:SetPoint("TOP", self.Health, "BOTTOM", 0, 0)
    self.Power.bg = self.Power:CreateTexture(nil, "BACKGROUND")
    self.Power.bg:SetTexture("Interface\\AddOns\\rTextures\\statusbar.tga")
    self.Power.bg:SetAllPoints(self.Power)
    return self.Health, self.Power
  end
  
  --aura icon func
  local function d3o2_createAuraIcon(self, button, icons, index, debuff)
    button.cd:SetReverse()
    button.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    button.count:SetPoint("BOTTOMRIGHT", button, 1, 0)
    button.count:SetTextColor(0.7,0.7,0.7)
    self.ButtonOverlay = button:CreateTexture(nil, "OVERLAY")
    self.ButtonOverlay:SetTexture("Interface\\AddOns\\rTextures\\gloss2.tga")
    self.ButtonOverlay:SetVertexColor(0.37,0.3,0.3,1);
    self.ButtonOverlay:SetParent(button)
    self.ButtonOverlay:SetPoint("TOPLEFT", -1, 1)
    self.ButtonOverlay:SetPoint("BOTTOMRIGHT", 1, -1)  
  end
  
  --buff func
  local function d3o2_createBuffs(self,type)
		self.Buffs = CreateFrame("Frame", nil, self)
		self.Buffs.size = 20
		self.Buffs.num = 40
		self.Buffs:SetHeight((self.Buffs.size+5)*3)
		self.Buffs:SetWidth(self:GetWidth())
		self.Buffs:SetPoint("LEFT", self, "RIGHT", 20, 25)
		self.Buffs.initialAnchor = "TOPLEFT"
		self.Buffs["growth-x"] = "RIGHT"
		self.Buffs["growth-y"] = "UP"
		self.Buffs.spacing = 5
		return self.Buffs
  end
  
  --debuff func
  local function d3o2_createDebuffs(self,type)
		self.Debuffs = CreateFrame("Frame", nil, self)
		self.Debuffs.size = 20
		self.Debuffs.num = 40
		self.Debuffs:SetHeight((self.Debuffs.size+5)*3)
		self.Debuffs:SetWidth(self:GetWidth())
		self.Debuffs:SetPoint("LEFT", self, "RIGHT", 20, -25)
		self.Debuffs.initialAnchor = "TOPLEFT"
		self.Debuffs["growth-x"] = "RIGHT"
		self.Debuffs["growth-y"] = "DOWN"
		self.Debuffs.spacing = 5
		self.Debuffs.onlyShowPlayer = false
		self.Debuffs.showDebuffType = false
		return self.Debuffs
  end
    
  -----------------------------
  -- CREATE STYLES
  -----------------------------
    
  --create the player style
  local function CreatePlayerStyle(self, unit)
    --am("ping")  
    d3o2_setupFrame(self,orbsize,orbsize,"BACKGROUND")    
    self.Health, self.Health.Filling = d3o2_createOrb(self,"health")
    self.Power, self.Power.Filling = d3o2_createOrb(self,"power")
    self.PostUpdateHealth = d3o2_updatePlayerHealth
    self.PostUpdatePower = d3o2_updatePlayerPower
    self.disallowVehicleSwap = true    
  end
  
  --create the target style
  local function CreateTargetStyle(self, unit)
    d3o2_setupFrame(self,224,20,"BACKGROUND")
    self.Health, self.Power = d3o2_createHealthPowerFrames(self,unit)
    self.Buffs = d3o2_createBuffs(self,unit)
    self.Debuffs = d3o2_createDebuffs(self,unit)
    self.PostCreateAuraIcon = d3o2_createAuraIcon
  end

  -----------------------------
  -- REGISTER STYLES
  -----------------------------

  oUF:RegisterStyle("oUF_D3Orbs2_player", CreatePlayerStyle)
  oUF:RegisterStyle("oUF_D3Orbs2_target", CreateTargetStyle)
  
  -----------------------------
  -- SPAWN UNITS
  -----------------------------
  
  oUF:SetActiveStyle("oUF_D3Orbs2_player")
  oUF:Spawn("player", "oUF_D3Orbs2_PlayerFrame"):SetPoint(tabvalues.frame_positions[2].a1, tabvalues.frame_positions[2].af, tabvalues.frame_positions[2].a2, tabvalues.frame_positions[2].x, tabvalues.frame_positions[2].y)  
  oUF:SetActiveStyle("oUF_D3Orbs2_target")
  oUF:Spawn("target","oUF_D3Orbs2_TargetFrame"):SetPoint(tabvalues.frame_positions[3].a1, colors2.frame_positions[3].af, colors2.frame_positions[3].a2, colors2.frame_positions[3].x, colors2.frame_positions[3].y)  
  
