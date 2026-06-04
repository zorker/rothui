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
-- GetLine1Prefix(unit, leftText)
---------------------------------------------------------------------

local function GetLine1Prefix(unit, leftText)
  local prefix = ""
  if UnitIsPlayer(unit) then
    local _, className = UnitClass(unit)
    if className then
      prefix = "|A:groupfinder-icon-class-"..className:lower()..":15:15:0:0|a "
    end
  else
    local classification = UnitClassification(unit)
    if classification == "worldboss" or UnitLevel(unit) == -1 then
      prefix = "|A:worldquest-icon-boss:15:15:0:0|a "
    elseif classification == "rare" then
      prefix = "|A:nameplates-icon-elite-silver:15:15:0:0|a "
    elseif classification == "rareelite" then
      prefix = "|A:worldquest-icon-boss:15:15:0:0|a "
    elseif classification == "elite" then
      prefix = "|A:nameplates-icon-elite-gold:15:15:0:0|a "
    end
  end
  return prefix
end

---------------------------------------------------------------------
-- GetLine1Suffix(unit, leftText)
---------------------------------------------------------------------

local function GetLine1Suffix(unit, leftText)
  local suffix = ""
  if UnitIsPlayer(unit) then
    local instanceName, instanceType = GetInstanceInfo()
    if instanceType == "none" and issecretvalue(leftText) == false and UnitIsAFK(unit) then
      suffix = " |cff00ffff<afk>|r"
    end
  end
  return suffix
end

---------------------------------------------------------------------
-- GetClassOrReactionColor(unit)
---------------------------------------------------------------------

local function GetClassOrReactionColor(unit, fallbackColor)
  local r, g, b = unpack(fallbackColor)
  if UnitIsDeadOrGhost(unit) then
    r, g, b = unpack(deadColor)
  elseif UnitIsPlayer(unit) then
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
  local unit = UnitExists("mouseover") and "mouseover" or nil
  if unit then
    tooltip.NineSlice:SetVertexColor(GetClassOrReactionColor(unit, borderColor))
    tooltip.NineSlice.Center:SetVertexColor(unpack(backgroundColor))
  else
    tooltip.NineSlice:SetVertexColor(unpack(borderColor))
    tooltip.NineSlice.Center:SetVertexColor(unpack(backgroundColor))
  end
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
    local unit = UnitExists("mouseover") and "mouseover" or nil
    if not unit then return end
    local tooltipData = tooltip:GetTooltipData()
    if not tooltipData then return end
    local level = UnitLevel(unit)
    local difficultyColor = GetCreatureDifficultyColor((level > 0) and level or 999)
    local levelLine = nil
    --find the level line
    for i, data in ipairs(tooltipData.lines) do
      if issecretvalue(data.leftText) then
        levelLine = 2
        break
      end
      if data.lineIndex >= 2 then
        levelLine = string.find(data.leftText, "%a%s%?%?") and data.lineIndex or
                    string.find(data.leftText, "%a%s%d") and data.lineIndex or nil
        if levelLine then
          break
        end
      end
    end
    --loop over all lines
    for i, data in ipairs(tooltipData.lines) do
      local line = _G["GameTooltipTextLeft" .. data.lineIndex]
      if data.lineIndex == 1 then
        line:SetText(GetLine1Prefix(unit, data.leftText)..data.leftText..GetLine1Suffix(unit, data.leftText))
        line:SetTextColor(GetClassOrReactionColor(unit, textColor))
        line:SetFont(STANDARD_TEXT_FONT, 15, "SLUG")
      end
      if data.lineIndex >= 2 then
        line:SetFont(STANDARD_TEXT_FONT, 12, "SLUG")
        if data.lineIndex == 2 and levelLine and levelLine > 2 then
          line:SetTextColor(unpack(guildColor))
          line:SetText("<"..data.leftText..">")
        elseif levelLine and data.lineIndex == levelLine then
          line:SetTextColor(difficultyColor.r,difficultyColor.g,difficultyColor.b)
        else
          line:SetTextColor(unpack(textColor))
        end
      end
    end
  end)

end

L.F.LoadModuleTooltip = LoadModuleTooltip