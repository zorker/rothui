local A, L = ...

local mpi, msin, mcos, floor = math.pi, math.sin, math.cos, floor

local playerFrameScaleFactor = 0.9

--[[
local curveClipFrameHeight = C_CurveUtil.CreateCurve()
local curvesplitTextureMult = C_CurveUtil.CreateCurve()
local curvesplitTextureWidth = C_CurveUtil.CreateCurve()
local curvesplitTextureHeight = C_CurveUtil.CreateCurve()
local curvesplitTexturePoint = C_CurveUtil.CreateCurve()

for i = 0, 100 do 
  local value = i/100
  local cfh = value * 256
  local stm = floor(msin(value * mpi) * 100) / 100
  local stw = 256 * stm
  local sth = 32 * stm
  local stp = 16 * stm
  curveClipFrameHeight:AddPoint(value, cfh)
  curvesplitTextureMult:AddPoint(value, stm)
  curvesplitTextureWidth:AddPoint(value, stw)
  curvesplitTextureHeight:AddPoint(value, sth)
  curvesplitTexturePoint:AddPoint(value, stp)
end
]]

local function UpdateOrbTemplate(orb, templateName)

  local template = L.ORB_CONFIG_DB.presetTemplates[templateName] or L.ORB_CONFIG_DB.userTemplates[templateName] or L.ORB_CONFIG_DB.presetTemplates['_OTHER'] or nil
  if not template then return end

  local color = CreateColorFromHexString(template.fillColor)
  local r,g,b = color:GetRGB()

  orb:LoadModelDataByID(template.modelID)
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

    --secret value
    local uhp = UnitHealthPercent(unit,true)

    --need to do secure texture/frame size manipulation
    self.orbFrame.FillingStatusBar:SetValue(uhp)

    --self.orbFrame.ClipFrame:SetPoint("TOP", self.orbFrame.FillingStatusBar:GetStatusBarTexture(), 0, 0)
    --[[
    local cfh = UnitHealthPercent(unit, true, curveClipFrameHeight)
    local stm = UnitHealthPercent(unit, true, curvesplitTextureMult)
    self.orbFrame.ClipFrame:SetHeight(cfh)
    if stm <= 0.25 then
      self.orbFrame.OverlayFrame.SparkTexture:Hide()
    else
      local stw = UnitHealthPercent(unit, true, curvesplitTextureWidth)
      local sth = UnitHealthPercent(unit, true, curvesplitTextureHeight)
      local stp = UnitHealthPercent(unit, true, curvesplitTexturePoint)
      self.orbFrame.OverlayFrame.SparkTexture:SetWidth(stw)
      self.orbFrame.OverlayFrame.SparkTexture:SetHeight(sth)
      self.orbFrame.OverlayFrame.SparkTexture:SetPoint("TOP", self.orbFrame.FillingStatusBar:GetStatusBarTexture(), 0, stp)
      self.orbFrame.OverlayFrame.SparkTexture:Show()
    end
    ]]
  end

  function power:UpdateColor(event, unit)
	  if(not unit or self.unit ~= unit) then return end
    print(self.elementType)
	  local element = self.Power
    print(element.elementType)
    local powerID, powerType = UnitPowerType(unit)
    local template = element.displayType or powerType or nil
    UpdateOrbTemplate(element.orbFrame, '_POWER_'..template)
  end

  function power:PostUpdate(unit, cur, min, max)

    --secret value
    local upp = UnitPowerPercent(unit, self.displayType, true)

    --need to do secure texture/frame size manipulation
    self.orbFrame.FillingStatusBar:SetValue(upp)

    --self.orbFrame.ClipFrame:SetPoint("TOP", self.orbFrame.FillingStatusBar:GetStatusBarTexture(), 0, 0)
    --[[
    local cfh = UnitPowerPercent(unit, self.displayType, true, curveClipFrameHeight)
    local stm = UnitPowerPercent(unit, self.displayType, true, curvesplitTextureMult)
    self.orbFrame.ClipFrame:SetHeight(cfh)
    if stm <= 0.25 then
      self.orbFrame.OverlayFrame.SparkTexture:Hide()
    else
      local stw = UnitPowerPercent(unit, self.displayType, true, curvesplitTextureWidth)
      local sth = UnitPowerPercent(unit, self.displayType, true, curvesplitTextureHeight)
      local stp = UnitPowerPercent(unit, self.displayType, true, curvesplitTexturePoint)
      self.orbFrame.OverlayFrame.SparkTexture:SetWidth(stw)
      self.orbFrame.OverlayFrame.SparkTexture:SetHeight(sth)
      self.orbFrame.OverlayFrame.SparkTexture:SetPoint("TOP", self.orbFrame.FillingStatusBar:GetStatusBarTexture(), 0, stp)
      self.orbFrame.OverlayFrame.SparkTexture:Show()
    end
    ]]
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