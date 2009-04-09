
  -- oUF_D3Orbs2 layout by roth - 2009
  
  local function am(text)
    DEFAULT_CHAT_FRAME:AddMessage(text)
  end
  
  local colors2 = {
    frame_positions = {
      [1] =   { f = "PlayerPowerOrb",   a1 = "BOTTOM",  a2 = "BOTTOM",  af = "UIParent",          x = 260,    y = -9      },
      [2] =   { f = "PlayerHealthOrb",  a1 = "BOTTOM",  a2 = "BOTTOM",  af = "UIParent",          x = -260,   y = -9      },
    },
  }
  
  local function updateHealth(self, event, unit, bar, min, max)
    self.Health.Filling:SetHeight((min / max) * self.Power:GetWidth())
    self.Health.Filling:SetTexCoord(0,1,  math.abs(min / max - 1),1)
    self.Health.Filling:SetVertexColor(0.5,1,0)
  end
  
  local function updatePower(self, event, unit, bar, min, max)
    self.Power.Filling:SetHeight((min / max) * self.Power:GetWidth())
    self.Power.Filling:SetTexCoord(0,1,  math.abs(min / max - 1),1)
    self.Power.Filling:SetVertexColor(0,0.5,1)
  end
    
    
  local function CreatePlayerStyle(self, unit)
    --do stuff
    
    --am("ping")  
    
    self:SetFrameStrata("BACKGROUND")
    local orbsize = 150
    self:SetHeight(orbsize)
    self:SetWidth(orbsize)
    self.Health = CreateFrame("StatusBar", nil, self)
    self.Health:SetStatusBarTexture("Interface\\AddOns\\rTextures\\orb_transparent.tga")
    self.Health:SetHeight(orbsize)
    self.Health:SetWidth(orbsize)
    self.Health:SetPoint("TOPLEFT", 0, 0)
    self.Health.Smooth = true
    self.Health.bg = self.Health:CreateTexture(nil, "BACKGROUND")
    self.Health.bg:SetTexture("Interface\\AddOns\\rTextures\\orb_back2.tga")
    self.Health.bg:SetAllPoints(self.Health)
    self.Health.Filling = self.Health:CreateTexture(nil, "ARTWORK")
    self.Health.Filling:SetTexture("Interface\\AddOns\\rTextures\\orb_filling4.tga")
    self.Health.Filling:SetPoint("BOTTOMLEFT",0,0)
    self.Health.Filling:SetWidth(orbsize)
    self.Health.Filling:SetHeight(orbsize)
    self.HealthGlossHolder = CreateFrame("Frame", nil, self.Health)
    self.HealthGlossHolder:SetAllPoints(self.Health)
    self.HealthGlossHolder:SetFrameStrata("LOW")
    self.HealthOrbGloss = self.HealthGlossHolder:CreateTexture(nil, "OVERLAY")
    self.HealthOrbGloss:SetTexture("Interface\\AddOns\\rTextures\\orb_gloss.tga")
    self.HealthOrbGloss:SetAllPoints(self.HealthGlossHolder)
    
    self.Power = CreateFrame("StatusBar", nil, self)
    self.Power:SetStatusBarTexture("Interface\\AddOns\\rTextures\\orb_transparent.tga")
    self.Power:SetHeight(orbsize)
    self.Power:SetWidth(orbsize)
    self.Power:SetPoint(colors2.frame_positions[1].a1, colors2.frame_positions[1].af, colors2.frame_positions[1].a2, colors2.frame_positions[1].x, colors2.frame_positions[1].y)
    self.Power.frequentUpdates = true
    self.Power.Smooth = true
    self.Power.bg = self.Power:CreateTexture(nil, "BACKGROUND")
    self.Power.bg:SetTexture("Interface\\AddOns\\rTextures\\orb_back2.tga")
    self.Power.bg:SetAllPoints(self.Power)
    self.Power.Filling = self.Power:CreateTexture(nil, "ARTWORK")
    self.Power.Filling:SetTexture("Interface\\AddOns\\rTextures\\orb_filling4.tga")
    self.Power.Filling:SetPoint("BOTTOMLEFT",0,0)
    self.Power.Filling:SetWidth(orbsize)
    self.Power.Filling:SetHeight(orbsize)
    self.PowerGlossHolder = CreateFrame("Frame", nil, self.Power)
    self.PowerGlossHolder:SetAllPoints(self.Power)
    self.PowerGlossHolder:SetFrameStrata("LOW")
    self.PowerOrbGloss = self.PowerGlossHolder:CreateTexture(nil, "OVERLAY")
    self.PowerOrbGloss:SetTexture("Interface\\AddOns\\rTextures\\orb_gloss.tga")
    self.PowerOrbGloss:SetAllPoints(self.PowerGlossHolder)
    
    self.PostUpdateHealth = updateHealth
    self.PostUpdatePower = updatePower
    
    self.disallowVehicleSwap = true
    
    
  end

  
  oUF:RegisterStyle("oUF_D3Orbs2_player", CreatePlayerStyle)

  
  oUF:SetActiveStyle("oUF_D3Orbs2_player")
  oUF:Spawn("player", "oUF_D3Orbs2_player"):SetPoint(colors2.frame_positions[2].a1, colors2.frame_positions[2].af, colors2.frame_positions[2].a2, colors2.frame_positions[2].x, colors2.frame_positions[2].y)
  
