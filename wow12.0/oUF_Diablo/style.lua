local A, L = ...

---------------------------------------------------------------------
-- vars
---------------------------------------------------------------------

L.playerFrame = nil
L.movePlayerFrame = nil
L.movePlayerPowerFrame = nil

local curveLowHealth = C_CurveUtil.CreateColorCurve()
curveLowHealth:SetType(Enum.LuaCurveType.Step)
curveLowHealth:AddPoint(0.0, CreateColor(1, 0, 0, 0.85))
curveLowHealth:AddPoint(0.31, CreateColor(1, 0, 0, 0))

---------------------------------------------------------------------
-- UpdateOrbTemplate(orb, templateKeyName)
---------------------------------------------------------------------

local function UpdateOrbTemplate(orb, templateKeyName)

  local templateName = L.S.orbModelTemplateDropdowns[templateKeyName]:GetValue()

  local template = L.DB_ORB_CONFIG.presetTemplates[templateName] or L.DB_ORB_CONFIG.userTemplates[templateName] or L.DB_ORB_CONFIG.presetTemplates["_OTHER"] or nil
  if not template then return end

  local color = CreateColorFromHexString(template.fillColor)
  local r,g,b = color:GetRGB()

  -- load model into scene WITHOUT mouse enabled
  orb:LoadModelDataByID(template.modelID, false)
  orb.FillingStatusBar:SetStatusBarTexture(L.DB_ORB_CONFIG.mediaFolder..template.fillTexture)
  orb.FillingStatusBar:SetStatusBarColor(r,g,b)
  orb.OverlayFrame.SparkTexture:SetVertexColor(r,g,b,template.splitAlpha)
  orb.ClipFrame:SetAlpha(template.modelAlpha)

end

---------------------------------------------------------------------
-- StylePlayer(self)
---------------------------------------------------------------------

local function StylePlayer(self)

  self:SetSize(256, 256)
  L.playerFrame = self
  self:SetScale(L.S.playerScaleSetting:GetValue())
  self.elementType = "base"

  ---------------------------------------------------------------------
  -- healthOrb + self.Health
  ---------------------------------------------------------------------

  local healthOrb = CreateFrame("Frame", nil, self, "rModelOrbTemplate")
  healthOrb:SetPoint("CENTER")
  healthOrb.FillingStatusBar:SetFrameLevel(healthOrb:GetFrameLevel()+1)
  healthOrb.ClipFrame:SetFrameLevel(healthOrb:GetFrameLevel()+2)
  healthOrb.OverlayFrame:SetFrameLevel(healthOrb:GetFrameLevel()+3)

  local health = CreateFrame("StatusBar", nil, self)
  self.Health = health
  health.elementType = "health"
  health.orbFrame = healthOrb
  health.colorClass = true
  health.colorReaction = true
  health.colorHealth = true

  ---------------------------------------------------------------------
  -- powerOrb + self.Power
  ---------------------------------------------------------------------

  local powerOrb = CreateFrame("Frame", self:GetName().."PowerOrb", self, "rModelOrbTemplate")
  powerOrb.FillingStatusBar:SetFrameLevel(powerOrb:GetFrameLevel()+1)
  powerOrb.ClipFrame:SetFrameLevel(powerOrb:GetFrameLevel()+2)
  powerOrb.OverlayFrame:SetFrameLevel(powerOrb:GetFrameLevel()+3)

  local power = CreateFrame("StatusBar", nil, self)
  self.Power = power
  power.elementType = "power"
  power.orbFrame = powerOrb
  power.colorPower = true

  ---------------------------------------------------------------------
  -- health:UpdateColor(event, unit)
  ---------------------------------------------------------------------

  function health:UpdateColor(event, unit)
	  if(not unit or self.unit ~= unit) then return end
	  local element = self.Health
    local templateKeyName = nil
    if(element.colorClass and (UnitIsPlayer(unit) or UnitInPartyIsAI(unit)))
      or (element.colorClassNPC and not (UnitIsPlayer(unit) or UnitInPartyIsAI(unit)))
      or (element.colorClassPet and UnitPlayerControlled(unit) and not UnitIsPlayer(unit)) then
      local _, class = UnitClass(unit)
      templateKeyName = "CLASS_"..class
    elseif(element.colorReaction and UnitReaction(unit, "player")) then
      local reaction = UnitReaction(unit, "player")
      if reaction >= 5 then
        templateKeyName = "REACTION_FRIENDLY"
      elseif reaction >= 3 then
        templateKeyName = "REACTION_NEUTRAL"
      else
        templateKeyName = "REACTION_HOSTILE"
      end
    else
      templateKeyName = "OTHER"
    end
    UpdateOrbTemplate(element.orbFrame, templateKeyName)
  end

  ---------------------------------------------------------------------
  -- health:PostUpdate(unit, cur, max, lossPerc)
  ---------------------------------------------------------------------

  function health:PostUpdate(unit, cur, max, lossPerc)
    self.orbFrame.FillingStatusBar:SetValue(UnitHealthPercent(unit, true), Enum.StatusBarInterpolation.ExponentialEaseOut)
    local color = UnitHealthPercent(unit, true, curveLowHealth)
    self.orbFrame.OverlayFrame.LowHealthTexture:SetVertexColor(color:GetRGBA())
  end

  ---------------------------------------------------------------------
  -- power:UpdateColor(event, unit)
  ---------------------------------------------------------------------

  function power:UpdateColor(event, unit)
	  if(not unit or self.unit ~= unit) then return end
	  local element = self.Power
    local powerID, powerType = UnitPowerType(unit)
    local templateKeyName = nil
    if powerType then
      templateKeyName = "POWER_"..powerType
    else
      templateKeyName = "OTHER"
    end
    UpdateOrbTemplate(element.orbFrame, templateKeyName)
  end

  ---------------------------------------------------------------------
  -- power:PostUpdate(unit, cur, min, max)
  ---------------------------------------------------------------------

  function power:PostUpdate(unit, cur, min, max)
    self.orbFrame.FillingStatusBar:SetValue(UnitPowerPercent(unit, UnitPowerType(unit), true), Enum.StatusBarInterpolation.ExponentialEaseOut)
  end

  ---------------------------------------------------------------------
  -- Debuff Type Coloring for orbFrame.OverlayFrame.GlowTexture
  ---------------------------------------------------------------------

  local function GetDebuffTypeColor(element, unit, data, position)
    if data and data.dispelName then
      return C_UnitAuras.GetAuraDispelTypeColor(unit, data.auraInstanceID, element.dispelColorCurve)
    else
      return nil
    end
  end

  local function PostUpdateDebuffs(debuffs, unit)
    local color = nil
    for i = 1, math.min(40, #debuffs.sorted) do
      color = GetDebuffTypeColor(debuffs, unit, debuffs.sorted[i], i)
      if color then
        debuffs.orbFrame.OverlayFrame.GlowTexture:SetVertexColor(color:GetRGBA())
        break
      end
    end
    if not color then
      debuffs.orbFrame.OverlayFrame.GlowTexture:SetVertexColor(0.8, 0, 0, 0)
    end
  end

  local debuffs = CreateFrame("Frame", nil, self)
  debuffs.orbFrame = healthOrb
  debuffs.PostUpdate = PostUpdateDebuffs
  self.Debuffs = debuffs

  ---------------------------------------------------------------------
  -- CustomAbsorb - orb texture filling top to bottom
  ---------------------------------------------------------------------

  local absorbBar = CreateFrame("StatusBar", nil, healthOrb.OverlayFrame)
  absorbBar:SetSize(256, 256)
  absorbBar:SetPoint("CENTER")
  absorbBar:SetStatusBarTexture([[Interface\Buttons\WHITE8X8]])
  absorbBar:SetStatusBarColor(1, 1, 1, 0)
  absorbBar:SetOrientation("VERTICAL")
  absorbBar:SetFillStyle(3)
  absorbBar:SetRotatesTexture(true)

  absorbBar.clipFrame = CreateFrame("Frame", nil, absorbBar)
  absorbBar.clipFrame:SetClipsChildren(true)
  absorbBar.clipFrame:SetPoint("TOPLEFT", absorbBar)
  absorbBar.clipFrame:SetPoint("BOTTOMRIGHT", absorbBar:GetStatusBarTexture())

  absorbBar.clipFrame.fill = absorbBar.clipFrame:CreateTexture(nil, "ARTWORK")
  absorbBar.clipFrame.fill:SetSize(256, 256)
  absorbBar.clipFrame.fill:SetPoint("TOPLEFT")
  absorbBar.clipFrame.fill:SetTexture(L.mediaFolder.."orb_absorb")
  absorbBar.clipFrame.fill:SetVertexColor(0.5, 0.81, 0.95, 1)
  absorbBar.clipFrame.fill:SetBlendMode("BLEND")

  self.CustomAbsorb = absorbBar

  ---------------------------------------------------------------------
  -- right click menu
  ---------------------------------------------------------------------

  self:RegisterForClicks("AnyUp")
  self.Menu = function(self)
    if OpenContextMenu then
      OpenContextMenu(self, { unit = self.unit, name = self.name, })
    else
      UnitPopup_OpenMenu(self.unit)
    end
  end
  self:SetAttribute("*type2", "togglemenu")

  ---------------------------------------------------------------------
  -- angel + demon
  ---------------------------------------------------------------------

  local healthOrbHighlightFrame = CreateFrame("Frame", nil, healthOrb.OverlayFrame)
  healthOrbHighlightFrame:SetSize(256, 256)
  healthOrbHighlightFrame:SetPoint("CENTER")
  healthOrbHighlightFrame:SetFrameLevel(math.max(absorbBar:GetFrameLevel(), healthOrb.OverlayFrame:GetFrameLevel())+1)

  local texDemon = healthOrbHighlightFrame:CreateTexture(nil,"BACKGROUND",nil,2)
  texDemon:SetSize(512,256)
  texDemon:SetPoint("BOTTOMRIGHT", healthOrb.OverlayFrame, "BOTTOMLEFT", 370, 10)
  texDemon:SetTexture(L.mediaFolder.."d3_demon")

  local texLeftEdge = healthOrbHighlightFrame:CreateTexture(nil,"BACKGROUND",nil,2)
  texLeftEdge:SetSize(128,64)
  texLeftEdge:SetPoint("BOTTOMLEFT", healthOrb.OverlayFrame, "BOTTOMRIGHT", -100, 15)
  texLeftEdge:SetTexture(L.mediaFolder.."d3_left")

  local texAngel = power.orbFrame.OverlayFrame:CreateTexture(nil,"BACKGROUND",nil,2)
  texAngel:SetSize(512,256)
  texAngel:SetPoint("BOTTOMLEFT", power.orbFrame.OverlayFrame, "BOTTOMRIGHT", -370, 10)
  texAngel:SetTexture(L.mediaFolder.."d3_angel")

  local texRightEdge = power.orbFrame.OverlayFrame:CreateTexture(nil,"BACKGROUND",nil,2)
  texRightEdge:SetSize(128,64)
  texRightEdge:SetPoint("BOTTOMRIGHT", power.orbFrame.OverlayFrame, "BOTTOMLEFT", 100, 15)
  texRightEdge:SetTexture(L.mediaFolder.."d3_right")

  -------------------------------------------
  -- movePlayerFrame
  -------------------------------------------

  local movePlayerFrame = CreateFrame("Frame", nil, UIParent)
  L.movePlayerFrame = movePlayerFrame
  movePlayerFrame:SetFrameLevel(healthOrbHighlightFrame:GetFrameLevel()+1)
  movePlayerFrame:SetSize(256, 256)
  movePlayerFrame:SetScale(L.S.playerScaleSetting:GetValue())
  movePlayerFrame:ClearAllPoints()
  movePlayerFrame:SetPoint(L.DB.playerPosition.point, UIParent, L.DB.playerPosition.relativePoint, L.DB.playerPosition.xOfs, L.DB.playerPosition.yOfs)

  --move the player frame to center of the mover
  self:SetPoint("CENTER", movePlayerFrame, "CENTER", 0, 0)

  movePlayerFrame.bg = movePlayerFrame:CreateTexture(nil, "BACKGROUND")
  movePlayerFrame.bg:SetAllPoints()
  movePlayerFrame.bg:SetColorTexture(0, 1, 1, 0.5)

  if L.S.lockPlayerFrameSetting:GetValue() == true then
    movePlayerFrame:EnableMouse(false)
    movePlayerFrame.bg:Hide()
  else
    movePlayerFrame:EnableMouse(true)
    movePlayerFrame.bg:Show()
  end

  movePlayerFrame:SetMovable(true)
  movePlayerFrame:SetClampedToScreen(true)
  movePlayerFrame:SetClampRectInsets(50, -50, -50, 50)
  movePlayerFrame:RegisterForDrag("LeftButton")
  movePlayerFrame:SetScript("OnDragStart", function(self)
    self:StartMoving()
  end)
  movePlayerFrame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint()
    L.DB.playerPosition = {
      point = point,
      relativePoint  = relativePoint,
      xOfs = xOfs,
      yOfs = yOfs
    }
  end)

  -------------------------------------------
  -- movePlayerPowerFrame
  -------------------------------------------

  local movePlayerPowerFrame = CreateFrame("Frame", nil, UIParent)
  L.movePlayerPowerFrame = movePlayerPowerFrame
  movePlayerPowerFrame:SetFrameLevel(powerOrb.OverlayFrame:GetFrameLevel()+1)
  movePlayerPowerFrame:SetSize(256, 256)
  movePlayerPowerFrame:SetScale(L.S.playerScaleSetting:GetValue())
  movePlayerPowerFrame:ClearAllPoints()
  movePlayerPowerFrame:SetPoint(L.DB.playerPowerPosition.point, UIParent, L.DB.playerPowerPosition.relativePoint, L.DB.playerPowerPosition.xOfs, L.DB.playerPowerPosition.yOfs)

  --move the player frame to center of the mover
  powerOrb:SetPoint("CENTER", movePlayerPowerFrame, "CENTER", 0, 0)

  movePlayerPowerFrame.bg = movePlayerPowerFrame:CreateTexture(nil, "BACKGROUND")
  movePlayerPowerFrame.bg:SetAllPoints()
  movePlayerPowerFrame.bg:SetColorTexture(0, 1, 1, 0.5)

  if L.S.lockPlayerPowerFrameSetting:GetValue() == true then
    movePlayerPowerFrame:EnableMouse(false)
    movePlayerPowerFrame.bg:Hide()
  else
    movePlayerPowerFrame:EnableMouse(true)
    movePlayerPowerFrame.bg:Show()
  end

  movePlayerPowerFrame:SetMovable(true)
  movePlayerPowerFrame:SetClampedToScreen(true)
  movePlayerPowerFrame:SetClampRectInsets(50, -50, -50, 50)
  movePlayerPowerFrame:RegisterForDrag("LeftButton")
  movePlayerPowerFrame:SetScript("OnDragStart", function(self)
    self:StartMoving()
  end)
  movePlayerPowerFrame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint()
    L.DB.playerPowerPosition = {
      point = point,
      relativePoint  = relativePoint,
      xOfs = xOfs,
      yOfs = yOfs
    }
  end)

end

---------------------------------------------------------------------
-- UnitSpecific
---------------------------------------------------------------------

local UnitSpecific = {
  player = StylePlayer,
  --[[
  party = function(self)
    -- Party specific layout code.
  end,
  ]]
}

---------------------------------------------------------------------
-- Shared
---------------------------------------------------------------------

local Shared = function(self, unit)
	if(UnitSpecific[unit]) then
		return UnitSpecific[unit](self)
	end
end

---------------------------------------------------------------------
-- RegisterStyle
---------------------------------------------------------------------

oUF:RegisterStyle("oUF_Diablo", Shared)

---------------------------------------------------------------------
-- SpawnUnits
---------------------------------------------------------------------

local function SpawnUnits()
  oUF:Factory(function(self)
    self:SetActiveStyle("oUF_Diablo")
    self:Spawn("player")
    --[[
    -- oUF:SpawnHeader(overrideName, overrideTemplate, visibility, attributes ...)
    local party = self:SpawnHeader(nil, nil, "raid,party,solo",
        -- http://wowprogramming.com/docs/secure_template/Group_Headers
        -- Set header attributes
        "showParty", true,
        "showPlayer", true,
        "yOffset", -20
    )
    party:SetPoint("TOPLEFT", 30, -30)
    ]]
  end)
end
L.F.SpawnUnits = SpawnUnits