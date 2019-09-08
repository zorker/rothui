
-- rTooltip: core
-- zork, 2019

-----------------------------
-- Variables
-----------------------------

local A, L = ...

local unpack, type, select = unpack, type, select
local RAID_CLASS_COLORS, FACTION_BAR_COLORS, ICON_LIST = RAID_CLASS_COLORS, FACTION_BAR_COLORS, ICON_LIST
local GameTooltip, GameTooltipStatusBar = GameTooltip, GameTooltipStatusBar
local GameTooltipTextRight1, GameTooltipTextRight2, GameTooltipTextRight3, GameTooltipTextRight4, GameTooltipTextRight5, GameTooltipTextRight6, GameTooltipTextRight7, GameTooltipTextRight8 = GameTooltipTextRight1, GameTooltipTextRight2, GameTooltipTextRight3, GameTooltipTextRight4, GameTooltipTextRight5, GameTooltipTextRight6, GameTooltipTextRight7, GameTooltipTextRight8
local GameTooltipTextLeft1, GameTooltipTextLeft2, GameTooltipTextLeft3, GameTooltipTextLeft4, GameTooltipTextLeft5, GameTooltipTextLeft6, GameTooltipTextLeft7, GameTooltipTextLeft8 = GameTooltipTextLeft1, GameTooltipTextLeft2, GameTooltipTextLeft3, GameTooltipTextLeft4, GameTooltipTextLeft5, GameTooltipTextLeft6, GameTooltipTextLeft7, GameTooltipTextLeft8
local classColorHex, factionColorHex, barColor = {}, {}, nil

-----------------------------
-- Functions
-----------------------------

local function GetHexColor(color)
  if color.r then
    return ("%.2x%.2x%.2x"):format(color.r*255, color.g*255, color.b*255)
  else
    local r,g,b,a = unpack(color)
    return ("%.2x%.2x%.2x"):format(r*255, g*255, b*255)
  end
end

local function GetTarget(unit)
  if UnitIsUnit(unit, "player") then
    return ("|cffff0000%s|r"):format("<YOU>")
  elseif UnitIsPlayer(unit, "player") then
    local _, class = UnitClass(unit)
    return ("|cff%s%s|r"):format(classColorHex[class], UnitName(unit))
  elseif UnitReaction(unit, "player") then
    return ("|cff%s%s|r"):format(factionColorHex[UnitReaction(unit, "player")], UnitName(unit))
  else
    return ("|cffffffff%s|r"):format(UnitName(unit))
  end
end

local function OnTooltipSetUnit(self)
  local unitName, unit = self:GetUnit()
  if not unit then return end
  --color tooltip textleft2..8
  GameTooltipTextLeft2:SetTextColor(unpack(L.C.textColor))
  GameTooltipTextLeft3:SetTextColor(unpack(L.C.textColor))
  GameTooltipTextLeft4:SetTextColor(unpack(L.C.textColor))
  GameTooltipTextLeft5:SetTextColor(unpack(L.C.textColor))
  GameTooltipTextLeft6:SetTextColor(unpack(L.C.textColor))
  GameTooltipTextLeft7:SetTextColor(unpack(L.C.textColor))
  GameTooltipTextLeft8:SetTextColor(unpack(L.C.textColor))
  --position raidicon
  --local raidIconIndex = GetRaidTargetIndex(unit)
  --if raidIconIndex then
  --  GameTooltipTextLeft1:SetText(("%s %s"):format(ICON_LIST[raidIconIndex].."14|t", unitName))
  --end
  if not UnitIsPlayer(unit) then
    --unit is not a player
    --color textleft1 and statusbar by faction color
    local reaction = UnitReaction(unit, "player")
    if reaction then
      local color = FACTION_BAR_COLORS[reaction]
      if color then
        barColor = color
        GameTooltipStatusBar:SetStatusBarColor(color.r,color.g,color.b)
        GameTooltipTextLeft1:SetTextColor(color.r,color.g,color.b)
      end
    end
    --color textleft2 by classificationcolor
    local unitClassification = UnitClassification(unit)
    local levelLine
    if string.find(GameTooltipTextLeft2:GetText() or "empty", "%a%s%d") then
      levelLine = GameTooltipTextLeft2
    elseif string.find(GameTooltipTextLeft3:GetText() or "empty", "%a%s%d") then
      GameTooltipTextLeft2:SetTextColor(unpack(L.C.guildColor)) --seems like the npc has a description, use the guild color for this
      levelLine = GameTooltipTextLeft3
    end
    if levelLine then
      local l = UnitLevel(unit)
      local color = GetCreatureDifficultyColor((l > 0) and l or 999)
      levelLine:SetTextColor(color.r,color.g,color.b)
    end
    if unitClassification == "worldboss" or UnitLevel(unit) == -1 then
      self:AppendText(" |cffff0000{B}|r")
      GameTooltipTextLeft2:SetTextColor(unpack(L.C.bossColor))
    elseif unitClassification == "rare" then
      self:AppendText(" |cffff9900{R}|r")
    elseif unitClassification == "rareelite" then
      self:AppendText(" |cffff0000{R+}|r")
    elseif unitClassification == "elite" then
      self:AppendText(" |cffff6666{E}|r")
    end
  else
    --unit is any player
    local _, unitClass = UnitClass(unit)
    --color textleft1 and statusbar by class color
    local color = RAID_CLASS_COLORS[unitClass]
    barColor = color
    GameTooltipStatusBar:SetStatusBarColor(color.r,color.g,color.b)
    GameTooltipTextLeft1:SetTextColor(color.r,color.g,color.b)
    --color textleft2 by guildcolor
    local unitGuild = GetGuildInfo(unit)
    local l = UnitLevel(unit)
    local color = GetCreatureDifficultyColor((l > 0) and l or 999)
    if unitGuild then
      --move level line to a new one
      GameTooltip:AddLine(GameTooltipTextLeft2:GetText(), color.r,color.g,color.b)
      --add guild info
      GameTooltipTextLeft2:SetText("<"..unitGuild..">")
      GameTooltipTextLeft2:SetTextColor(unpack(L.C.guildColor))
    else
      GameTooltipTextLeft2:SetTextColor(color.r,color.g,color.b)
    end
    --afk?
    if UnitIsAFK(unit) then
      self:AppendText((" |cff%s<AFK>|r"):format(L.C.afkColorHex))
    end
  end
  --dead?
  if UnitIsDeadOrGhost(unit) then
    GameTooltipTextLeft1:SetTextColor(unpack(L.C.deadColor))
  end
  --target line
  if (UnitExists(unit.."target")) then
    GameTooltip:AddDoubleLine(("|cff%s%s|r"):format(L.C.targetColorHex, "Target"),GetTarget(unit.."target") or "Unknown")
  end
end

local function SetBackdropStyle(self,style)
  if self.TopOverlay then self.TopOverlay:Hide() end
  if self.BottomOverlay then self.BottomOverlay:Hide() end
  self:SetBackdrop(L.C.backdrop)
  self:SetBackdropColor(unpack(L.C.backdrop.bgColor))
  local _, itemLink = self:GetItem()
  if itemLink then
    local _, _, itemRarity = GetItemInfo(itemLink)
    local r,g,b = 1,1,1
    if itemRarity then r,g,b = GetItemQualityColor(itemRarity) end
    self:SetBackdropBorderColor(r,g,b,L.C.backdrop.itemBorderColorAlpha)
  else
    --no item, use default border
    self:SetBackdropBorderColor(unpack(L.C.backdrop.borderColor))
  end
end

local function SetStatusBarColor(self,r,g,b)
  if not barColor then return end
  if r == barColor.r and g == barColor.g and b == barColor.b then return end
  self:SetStatusBarColor(barColor.r,barColor.g,barColor.b)
end

local function SetDefaultAnchor(self,parent)
  if not L.C.pos then return end
  if type(L.C.pos) == "string" then
    self:SetOwner(parent, L.C.pos)
  else
    self:SetOwner(parent, "ANCHOR_NONE")
    self:ClearAllPoints()
    self:SetPoint(unpack(L.C.pos))
  end
end

-----------------------------
-- Init
-----------------------------

--hex class colors
for class, color in next, RAID_CLASS_COLORS do
  classColorHex[class] = GetHexColor(color)
end
--hex reaction colors
--for idx, color in next, FACTION_BAR_COLORS do
for i = 1, #FACTION_BAR_COLORS do
  factionColorHex[i] = GetHexColor(FACTION_BAR_COLORS[i])
end

L.C.targetColorHex = GetHexColor(L.C.targetColor)
L.C.afkColorHex = GetHexColor(L.C.afkColor)

GameTooltipHeaderText:SetFont(L.C.fontFamily, 14, "NONE")
GameTooltipHeaderText:SetShadowOffset(1,-2)
GameTooltipHeaderText:SetShadowColor(0,0,0,0.75)
GameTooltipText:SetFont(L.C.fontFamily, 12, "NONE")
GameTooltipText:SetShadowOffset(1,-2)
GameTooltipText:SetShadowColor(0,0,0,0.75)
Tooltip_Small:SetFont(L.C.fontFamily, 11, "NONE")
Tooltip_Small:SetShadowOffset(1,-2)
Tooltip_Small:SetShadowColor(0,0,0,0.75)

--gametooltip statusbar
GameTooltipStatusBar:ClearAllPoints()
GameTooltipStatusBar:SetPoint("LEFT",5,0)
GameTooltipStatusBar:SetPoint("RIGHT",-5,0)
GameTooltipStatusBar:SetPoint("TOP",0,-2.5)
GameTooltipStatusBar:SetHeight(4)
--gametooltip statusbar bg
GameTooltipStatusBar.bg = GameTooltipStatusBar:CreateTexture(nil,"BACKGROUND",nil,-8)
GameTooltipStatusBar.bg:SetAllPoints()
GameTooltipStatusBar.bg:SetColorTexture(1,1,1)
GameTooltipStatusBar.bg:SetVertexColor(0,0,0,0.5)

--GameTooltipStatusBar:SetStatusBarColor()
hooksecurefunc(GameTooltipStatusBar,"SetStatusBarColor", SetStatusBarColor)
--GameTooltip_SetDefaultAnchor()
if L.C.pos then hooksecurefunc("GameTooltip_SetDefaultAnchor", SetDefaultAnchor) end
--GameTooltip_SetBackdropStyle
hooksecurefunc("GameTooltip_SetBackdropStyle", SetBackdropStyle)
--OnTooltipSetUnit
GameTooltip:HookScript("OnTooltipSetUnit", OnTooltipSetUnit)

--loop over tooltips
local tooltips = { GameTooltip,ShoppingTooltip1,ShoppingTooltip2,ItemRefTooltip,ItemRefShoppingTooltip1,ItemRefShoppingTooltip2,WorldMapTooltip,
WorldMapCompareTooltip1,WorldMapCompareTooltip2,SmallTextTooltip }
for i, tooltip in next, tooltips do
  tooltip:SetScale(L.C.scale)
  if tooltip:HasScript("OnTooltipCleared") then
    tooltip:HookScript("OnTooltipCleared", SetBackdropStyle)
  end
end

--loop over menues
local menues = {
  DropDownList1MenuBackdrop,
  DropDownList2MenuBackdrop,
}
for i, menu in next, menues do
  menu:SetScale(L.C.scale)
end

--spellid line

--func TooltipAddSpellID
local function TooltipAddSpellID(self,spellid)
  if not spellid then return end
  self:AddDoubleLine("|cff0099ffspellid|r",spellid)
  self:Show()
end

--hooksecurefunc GameTooltip SetUnitBuff
hooksecurefunc(GameTooltip, "SetUnitBuff", function(self,...)
  TooltipAddSpellID(self,select(10,UnitBuff(...)))
end)

--hooksecurefunc GameTooltip SetUnitDebuff
hooksecurefunc(GameTooltip, "SetUnitDebuff", function(self,...)
  TooltipAddSpellID(self,select(10,UnitDebuff(...)))
end)

--hooksecurefunc GameTooltip SetUnitAura
hooksecurefunc(GameTooltip, "SetUnitAura", function(self,...)
  TooltipAddSpellID(self,select(10,UnitAura(...)))
end)

--hooksecurefunc SetItemRef
hooksecurefunc("SetItemRef", function(link)
  local type, value = link:match("(%a+):(.+)")
  if type == "spell" then
    TooltipAddSpellID(ItemRefTooltip,value:match("([^:]+)"))
  end
end)

--HookScript GameTooltip OnTooltipSetSpell
GameTooltip:HookScript("OnTooltipSetSpell", function(self)
  TooltipAddSpellID(self,select(2,self:GetSpell()))
end)
