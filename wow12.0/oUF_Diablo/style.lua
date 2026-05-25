local A, L = ...

local mpi, msin, mcos, floor = math.pi, math.sin, math.cos, floor

local playerFrameScaleFactor = 0.9

local function UpdateOrbTemplate(orb, templateName)

  local template = L.ORB_CONFIG_DB.presetTemplates[templateName] or L.ORB_CONFIG_DB.userTemplates[templateName] or L.ORB_CONFIG_DB.presetTemplates['_OTHER'] or nil
  if not template then return end

  local color = CreateColorFromHexString(template.fillColor)
  local r,g,b = color:GetRGB()

  -- load model into scene WITHOUT mouse enabled
  orb:LoadModelDataByID(template.modelID, false)
  orb.FillingStatusBar:SetStatusBarTexture(template.fillTexture)
  orb.FillingStatusBar:SetStatusBarColor(r,g,b)
  orb.OverlayFrame.SparkTexture:SetVertexColor(r,g,b,template.splitAlpha)
  orb.ClipFrame:SetAlpha(template.modelAlpha)

end

local function StylePlayer(self)

  self:SetSize(256, 256)

  self:SetScale(playerFrameScaleFactor)
  self:SetPoint("BOTTOM", -400/playerFrameScaleFactor, -15/playerFrameScaleFactor)
  self.elementType = "base"

  local healthOrb = CreateFrame("Frame", nil, self, "rModelOrbTemplate")
  healthOrb:SetPoint("CENTER")

  local health = CreateFrame("StatusBar", nil, self)
  self.Health = health
  health.elementType = "health"
  health.orbFrame = healthOrb
  health.colorClass = true
  health.colorReaction = true
  health.colorHealth = true

  local powerOrb = CreateFrame("Frame", nil, self, "rModelOrbTemplate")
  powerOrb:SetPoint("BOTTOM", UIParent, 400/playerFrameScaleFactor, -15/playerFrameScaleFactor)

  local power = CreateFrame("StatusBar", nil, self)
  self.Power = power
  power.elementType = "power"
  power.orbFrame = powerOrb
  power.colorPower = true

  function health:UpdateColor(event, unit)
	  if(not unit or self.unit ~= unit) then return end
	  local element = self.Health
    local templateName = nil
    if(element.colorClass and (UnitIsPlayer(unit) or UnitInPartyIsAI(unit)))
      or (element.colorClassNPC and not (UnitIsPlayer(unit) or UnitInPartyIsAI(unit)))
      or (element.colorClassPet and UnitPlayerControlled(unit) and not UnitIsPlayer(unit)) then
      local _, class = UnitClass(unit)
      templateName = "_CLASS_"..class
    elseif(element.colorReaction and UnitReaction(unit, 'player')) then
      local reaction = UnitReaction(unit, 'player')
      if reaction >= 5 then
        templateName = "_REACTION_FRIENDLY"
      elseif reaction >= 3 then
        templateName = "_REACTION_NEUTRAL"
      else
        templateName = "_REACTION_HOSTILE"
      end
    else
      templateName = "_OTHER"
    end
    UpdateOrbTemplate(element.orbFrame, templateName)
  end

  function health:PostUpdate(unit, cur, max, lossPerc)
    self.orbFrame.FillingStatusBar:SetValue(UnitHealthPercent(unit,true))
  end

  function power:UpdateColor(event, unit)
	  if(not unit or self.unit ~= unit) then return end
	  local element = self.Power
    local powerID, powerType = UnitPowerType(unit)
    local template = nil
    if powerType then
      template = "_POWER_"..powerType
    else
      template = "_OTHER"
    end
    UpdateOrbTemplate(element.orbFrame, template)
  end

  function power:PostUpdate(unit, cur, min, max)
    self.orbFrame.FillingStatusBar:SetValue(UnitPowerPercent(unit, UnitPowerType(unit), true))
  end

  --textures
  local texDemon = health.orbFrame.OverlayFrame:CreateTexture(nil,"BACKGROUND",nil,2)
  texDemon:SetSize(512,256)
  texDemon:SetPoint("BOTTOMRIGHT", health.orbFrame.OverlayFrame, "BOTTOMLEFT", 380, 0)
  texDemon:SetTexture(L.mediaFolder.."d3_demon")

  local texLeftEdge = health.orbFrame.OverlayFrame:CreateTexture(nil,"BACKGROUND",nil,2)
  texLeftEdge:SetSize(128,64)
  texLeftEdge:SetPoint("BOTTOMLEFT", health.orbFrame.OverlayFrame, "BOTTOMRIGHT", -100, 15)
  texLeftEdge:SetTexture(L.mediaFolder.."d3_left")

  local texAngel = power.orbFrame.OverlayFrame:CreateTexture(nil,"BACKGROUND",nil,2)
  texAngel:SetSize(512,256)
  texAngel:SetPoint("BOTTOMLEFT", power.orbFrame.OverlayFrame, "BOTTOMRIGHT", -380, 0)
  texAngel:SetTexture(L.mediaFolder.."d3_angel")

  local texRightEdge = power.orbFrame.OverlayFrame:CreateTexture(nil,"BACKGROUND",nil,2)
  texRightEdge:SetSize(128,64)
  texRightEdge:SetPoint("BOTTOMRIGHT", power.orbFrame.OverlayFrame, "BOTTOMLEFT", 100, 15)
  texRightEdge:SetTexture(L.mediaFolder.."d3_right")


end

local UnitSpecific = {
  player = StylePlayer,
  --[[
  party = function(self)
    -- Party specific layout code.         
  end,
  ]]
}

local Shared = function(self, unit)
	if(UnitSpecific[unit]) then
		return UnitSpecific[unit](self)
	end
end

oUF:RegisterStyle("oUF_Diablo", Shared)

local function SpawnUnits()
  oUF:Factory(function(self)
    self:SetActiveStyle("oUF_Diablo")
    self:Spawn("player")
    --[[
    -- oUF:SpawnHeader(overrideName, overrideTemplate, visibility, attributes ...)
    local party = self:SpawnHeader(nil, nil, 'raid,party,solo',
        -- http://wowprogramming.com/docs/secure_template/Group_Headers
        -- Set header attributes
        'showParty', true, 
        'showPlayer', true, 
        'yOffset', -20
    )
    party:SetPoint("TOPLEFT", 30, -30)
    ]]
  end)
end
L.F.SpawnUnits = SpawnUnits