local A, L = ...

---------------------------------------------------------------------
-- vars
---------------------------------------------------------------------

local borderColor       = { 0.60, 0.55, 0.50, 1 }
local backgroundColor   = { 0.15, 0.14, 0.08, 1 }
local textColor         = { 0.60, 0.55, 0.50, 1.00 }
local guildColor        = { 0.90, 0.20, 0.90, 1.00 }
local deadColor         = { 0.40, 0.40, 0.40, 1.00 }

---------------------------------------------------------------------
-- GameTooltip.StatusBar
---------------------------------------------------------------------

GameTooltip.StatusBar:UnregisterAllEvents()
GameTooltip.StatusBar:SetAlpha(0)

---------------------------------------------------------------------
-- GameTooltip color
---------------------------------------------------------------------

local function ForceCustomBorder(tooltip)
  if tooltip and tooltip.NineSlice then
    local r,g,b = unpack(borderColor)
    local _, unit = tooltip:GetUnit()
    if unit then
      local isPlayer = UnitIsPlayer(unit)
      if isPlayer then
        local _, classFilename = UnitClass(unit)
        local classColor = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[classFilename]
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
    end
    tooltip.NineSlice:SetVertexColor(r,g,b)
    tooltip.NineSlice.Center:SetVertexColor(unpack(backgroundColor))
  end
end

hooksecurefunc("SharedTooltip_SetBackdropStyle", function(self, style)
  ForceCustomBorder(self)
end)

GameTooltip:HookScript("OnSizeChanged", function(self)
  ForceCustomBorder(self)
end)

GameTooltip:HookScript("OnShow", function(self)
  ForceCustomBorder(self)
end)

TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, function(tooltip)
  if tooltip ~= GameTooltip then return end
  local _, unit = tooltip:GetUnit()
  if not unit or not UnitExists(unit) then return end
  local headLine = GameTooltipTextLeft1
  if not headLine then return end
  local r, g, b
  local isPlayer = UnitIsPlayer(unit)
  local unitGuild = nil
  if isPlayer then
    local _, classFilename = UnitClass(unit)
    unitGuild = GetGuildInfo(unit)
    if classFilename then
      local classColor = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[classFilename]
      if classColor then
        r, g, b = classColor.r, classColor.g, classColor.b
      end
    end
    if UnitIsAFK(unit) then
      tooltip:AppendText((" |cff%s<afk>|r"):format("00ffff"))
    end
    headLine:SetText("|A:groupfinder-icon-class-"..classFilename:lower()..":15:15:0:0|a "..headLine:GetText())
  else
    local reaction = UnitReaction(unit, "player")
    local classification = UnitClassification(unit)
    if reaction and FACTION_BAR_COLORS[reaction] then
      local factionColor = FACTION_BAR_COLORS[reaction]
      if factionColor.GetRGB then
        r, g, b = factionColor:GetRGB()
      else
        r, g, b = factionColor.r, factionColor.g, factionColor.b
      end
    end
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
  elseif r and g and b then
    headLine:SetTextColor(r, g, b)
  end

  local numLines = tooltip:NumLines()
  if not numLines or numLines < 2 then return end

  local level = UnitLevel(unit)
  local difficultyColor = GetCreatureDifficultyColor((level > 0) and level or 999)

  local levelLine = nil
  local npcGuild = false

  if isPlayer then
    levelLine = unitGuild and 3 or 2
  else
    levelLine = string.find(GameTooltipTextLeft2:GetText() or "empty", "%a%s%?%?") and 2 or
                string.find(GameTooltipTextLeft3:GetText() or "empty", "%a%s%?%?") and 3 or
                string.find(GameTooltipTextLeft2:GetText() or "empty", "%a%s%d") and 2 or
                string.find(GameTooltipTextLeft3:GetText() or "empty", "%a%s%d") and 3 or nil
    if levelLine == 3 then
      npcGuild = true
    end
  end

  for i = 2, numLines do
    local leftLine = _G["GameTooltipTextLeft" .. i]
    if leftLine and i == levelLine then
      leftLine:SetFont(STANDARD_TEXT_FONT, 12, "SLUG")
      leftLine:SetTextColor(difficultyColor.r,difficultyColor.g,difficultyColor.b)
    elseif leftLine and i == 2 and (unitGuild or npcGuild) then
      leftLine:SetText("<"..leftLine:GetText()..">")
      leftLine:SetFont(STANDARD_TEXT_FONT, 12, "SLUG")
      leftLine:SetTextColor(unpack(guildColor))
    elseif leftLine then
      leftLine:SetFont(STANDARD_TEXT_FONT, 12, "SLUG")
      leftLine:SetTextColor(unpack(textColor))
    end
  end

end)