local A, L = ...

---------------------------------------------------------------------
-- vars
---------------------------------------------------------------------

local borderColor       = { 0.60, 0.55, 0.50, 1 }
local backgroundColor   = { 0.15, 0.14, 0.08, 1 }
local textColor         = { 0.60, 0.55, 0.50, 1.00 }
local guildColor        = { 0.90, 0.20, 0.90, 1.00 }
local deadColor         = { 0.40, 0.40, 0.40, 1.00 }

local GameTooltip = GameTooltip

---------------------------------------------------------------------
-- GetClassOrReactionColor(unit)
---------------------------------------------------------------------

local function GetClassOrReactionColor(unit, fallbackColor)
  local r, g, b = unpack(fallbackColor)
  if UnitIsPlayer(unit) then
    local _, className = UnitClass(unit)
    local classColor = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[className]
    if classColor then
      r, g, b = classColor.r, classColor.g, classColor.b
    end
  else
    local reaction = UnitReaction(unit, "player")
    if reaction and FACTION_BAR_COLORS[reaction] then
      local factionColor = FACTION_BAR_COLORS[reaction]
      if factionColor.GetRGB then
        r, g, b = factionColor:GetRGB()
      else
        r, g, b = factionColor.r, factionColor.g, factionColor.b
      end
    end
  end
  return r, g, b
end

---------------------------------------------------------------------
-- ForceCustomBorder(tooltip)
---------------------------------------------------------------------

local function ForceCustomBorder(tooltip)
  if not tooltip or not tooltip.NineSlice then return end
  -- no GetUnit
  if not tooltip.GetUnit then
    tooltip.NineSlice:SetVertexColor(unpack(borderColor))
    tooltip.NineSlice.Center:SetVertexColor(unpack(backgroundColor))
    return
  end
  local _, unit = tooltip:GetUnit()
  -- secret unit
  if issecretvalue(unit) then
    tooltip.NineSlice:SetVertexColor(GameTooltipTextLeft1:GetTextColor())
    tooltip.NineSlice.Center:SetVertexColor(unpack(backgroundColor))
    return
  end
  -- no unit
  if not unit then
    tooltip.NineSlice:SetVertexColor(unpack(borderColor))
    tooltip.NineSlice.Center:SetVertexColor(unpack(backgroundColor))
    return
  end
  tooltip.NineSlice:SetVertexColor(GetClassOrReactionColor(unit, borderColor))
  tooltip.NineSlice.Center:SetVertexColor(unpack(backgroundColor))
end

---------------------------------------------------------------------
-- LoadModuleTooltip()
---------------------------------------------------------------------

local function LoadModuleTooltip()

  ---------------------------------------------------------------------
  -- GameTooltip.StatusBar
  ---------------------------------------------------------------------

  GameTooltip.StatusBar:UnregisterAllEvents()
  GameTooltip.StatusBar:SetAlpha(0)

  ---------------------------------------------------------------------
  -- ForceCustomBorder hooks
  ---------------------------------------------------------------------

  hooksecurefunc("SharedTooltip_SetBackdropStyle", function(self, style)
    ForceCustomBorder(self)
  end)
  GameTooltip:HookScript("OnSizeChanged", function(self)
    ForceCustomBorder(self)
  end)
  GameTooltip:HookScript("OnShow", function(self)
    ForceCustomBorder(self)
  end)

  ---------------------------------------------------------------------
  -- AddTooltipPostCall(Enum.TooltipDataType.Unit, function)
  ---------------------------------------------------------------------

  TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, function(tooltip)
    if tooltip ~= GameTooltip then return end
    if not tooltip.GetUnit then return end
    local _, unit = tooltip:GetUnit()
    -- secret unit
    if issecretvalue(unit) then
      if GameTooltipTextLeft2 then
        local difficultyColor = GetCreatureDifficultyColor(UnitLevel("player"))
        GameTooltipTextLeft2:SetFont(STANDARD_TEXT_FONT, 12, "SLUG")
        GameTooltipTextLeft2:SetTextColor(difficultyColor.r,difficultyColor.g,difficultyColor.b)
      end
      local numLines = tooltip:NumLines()
      for i = 3, numLines do
        local leftLine = _G["GameTooltipTextLeft" .. i]
        if leftLine then
          leftLine:SetFont(STANDARD_TEXT_FONT, 12, "SLUG")
          leftLine:SetTextColor(unpack(textColor))
        end
      end
      return
    end
    if not unit then return end
    -- headLine
    local headLine = GameTooltipTextLeft1
    if UnitIsPlayer(unit) then
      local _, className = UnitClass(unit)
      if UnitIsAFK(unit) then
        tooltip:AppendText((" |cff%s<afk>|r"):format("00ffff"))
      end
      headLine:SetText("|A:groupfinder-icon-class-"..className:lower()..":15:15:0:0|a "..headLine:GetText())
    else
      local classification = UnitClassification(unit)
      if classification == "worldboss" or UnitLevel(unit) == -1 then
        headLine:SetText("|A:worldquest-icon-boss:15:15:0:0|a "..headLine:GetText())
      elseif classification == "rare" then
        headLine:SetText("|A:nameplates-icon-elite-silver:15:15:0:0|a "..headLine:GetText())
      elseif classification == "rareelite" then
        headLine:SetText("|A:worldquest-icon-boss:15:15:0:0|a "..headLine:GetText())
      elseif classification == "elite" then
        headLine:SetText("|A:nameplates-icon-elite-gold:15:15:0:0|a "..headLine:GetText())
      end
    end
    headLine:SetFont(STANDARD_TEXT_FONT, 15, "SLUG")
    if UnitIsDeadOrGhost(unit) then
      headLine:SetTextColor(unpack(deadColor))
    else
      headLine:SetTextColor(GetClassOrReactionColor(unit, textColor))
    end

    -- other lines
    local numLines = tooltip:NumLines()
    if not numLines or numLines < 2 then return end
    local level = UnitLevel(unit)
    local difficultyColor = GetCreatureDifficultyColor((level > 0) and level or 999)
    local levelLine = string.find(GameTooltipTextLeft3:GetText() or "empty", "%a%s%?%?") and 3 or
                      string.find(GameTooltipTextLeft3:GetText() or "empty", "%a%s%d") and 3 or 2
    for i = 2, numLines do
      local leftLine = _G["GameTooltipTextLeft" .. i]
      if leftLine and i == levelLine then
        leftLine:SetFont(STANDARD_TEXT_FONT, 12, "SLUG")
        leftLine:SetTextColor(difficultyColor.r,difficultyColor.g,difficultyColor.b)
      --mark second line as guild line
      elseif leftLine and i == 2 and levelLine == 3 then
        leftLine:SetText("<"..leftLine:GetText()..">")
        leftLine:SetFont(STANDARD_TEXT_FONT, 12, "SLUG")
        leftLine:SetTextColor(unpack(guildColor))
      elseif leftLine then
        leftLine:SetFont(STANDARD_TEXT_FONT, 12, "SLUG")
        leftLine:SetTextColor(unpack(textColor))
      end
    end
  end)

end

L.F.LoadModuleTooltip = LoadModuleTooltip