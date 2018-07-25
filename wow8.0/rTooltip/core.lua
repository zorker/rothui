
-- rTooltip: core
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

local unpack, type = unpack, type
local RAID_CLASS_COLORS, FACTION_BAR_COLORS, ICON_LIST = RAID_CLASS_COLORS, FACTION_BAR_COLORS, ICON_LIST
local GameTooltip, GameTooltipStatusBar = GameTooltip, GameTooltipStatusBar
local GameTooltipTextRight1, GameTooltipTextRight2, GameTooltipTextRight3, GameTooltipTextRight4, GameTooltipTextRight5, GameTooltipTextRight6, GameTooltipTextRight7, GameTooltipTextRight8 = GameTooltipTextRight1, GameTooltipTextRight2, GameTooltipTextRight3, GameTooltipTextRight4, GameTooltipTextRight5, GameTooltipTextRight6, GameTooltipTextRight7, GameTooltipTextRight8
local GameTooltipTextLeft1, GameTooltipTextLeft2, GameTooltipTextLeft3, GameTooltipTextLeft4, GameTooltipTextLeft5, GameTooltipTextLeft6, GameTooltipTextLeft7, GameTooltipTextLeft8 = GameTooltipTextLeft1, GameTooltipTextLeft2, GameTooltipTextLeft3, GameTooltipTextLeft4, GameTooltipTextLeft5, GameTooltipTextLeft6, GameTooltipTextLeft7, GameTooltipTextLeft8
local backdrop = nil
local classColorHex, factionColorHex = {}, {}

-----------------------------
-- Config
-----------------------------

local cfg = {}
cfg.textColor = {0.4,0.4,0.4}
cfg.bossColor = {1,0,0}
cfg.eliteColor = {1,0,0.5}
cfg.rareeliteColor = {1,0.5,0}
cfg.rareColor = {1,0.5,0}
cfg.levelColor = {0.8,0.8,0.5}
cfg.deadColor = {0.5,0.5,0.5}
cfg.targetColor = {1,0.5,0.5}
cfg.guildColor = {1,0,1}
cfg.afkColor = {0,1,1}
cfg.scale = 0.95
cfg.fontFamily = STANDARD_TEXT_FONT
cfg.backdrop = {
  bgFile = "Interface\\Buttons\\WHITE8x8",
  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
  tile = false,
  tileEdge = false,
  tileSize = 16,
  edgeSize = 16,
  insets = {left=3, right=3, top=3, bottom=3}
}
cfg.backdrop.bgColor = {0.08,0.08,0.1,0.92}
cfg.backdrop.borderColor = {0.3,0.3,0.33,1}

--pos can be either a point table or a anchor string
--cfg.pos = { "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -10, 180 }
cfg.pos = "ANCHOR_NONE"--"ANCHOR_CURSOR"

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
  GameTooltipTextLeft2:SetTextColor(unpack(cfg.textColor))
  GameTooltipTextLeft3:SetTextColor(unpack(cfg.textColor))
  GameTooltipTextLeft4:SetTextColor(unpack(cfg.textColor))
  GameTooltipTextLeft5:SetTextColor(unpack(cfg.textColor))
  GameTooltipTextLeft6:SetTextColor(unpack(cfg.textColor))
  GameTooltipTextLeft7:SetTextColor(unpack(cfg.textColor))
  GameTooltipTextLeft8:SetTextColor(unpack(cfg.textColor))
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
        cfg.barColor = color
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
      GameTooltipTextLeft2:SetTextColor(unpack(cfg.guildColor)) --seems like the npc has a description, use the guild color for this
      levelLine = GameTooltipTextLeft3
    end
    if levelLine then
      local l = UnitLevel(unit)
      local color = GetCreatureDifficultyColor((l > 0) and l or 999)
      levelLine:SetTextColor(color.r,color.g,color.b)
    end
    if unitClassification == "worldboss" or UnitLevel(unit) == -1 then
      self:AppendText(" |TInterface\\TargetingFrame\\UI-TargetingFrame-Skull:14:14|t")
      --GameTooltipTextLeft1:SetText(("%s%s"):format("|TInterface\\TargetingFrame\\UI-TargetingFrame-Skull:14:14|t", unitName))
      GameTooltipTextLeft2:SetTextColor(unpack(cfg.bossColor))
    elseif unitClassification == "rare" then
      self:AppendText(" |TInterface\\AddOns\\rTooltip\\media\\diablo:14:14:0:0:16:16:0:14:0:14|t")
    elseif unitClassification == "rareelite" then
      self:AppendText(" |TInterface\\AddOns\\rTooltip\\media\\diablo:14:14:0:0:16:16:0:14:0:14|t")
    elseif unitClassification == "elite" then
      self:AppendText(" |TInterface\\HelpFrame\\HotIssueIcon:14:14|t")
    end
  else
    --unit is any player
    local _, unitClass = UnitClass(unit)
    --color textleft1 and statusbar by class color
    local color = RAID_CLASS_COLORS[unitClass]
    cfg.barColor = color
    GameTooltipStatusBar:SetStatusBarColor(color.r,color.g,color.b)
    GameTooltipTextLeft1:SetTextColor(color.r,color.g,color.b)
    --color textleft2 by guildcolor
    local unitGuild = GetGuildInfo(unit)
    if unitGuild then
      GameTooltipTextLeft2:SetText("<"..unitGuild..">")
      GameTooltipTextLeft2:SetTextColor(unpack(cfg.guildColor))
    end
    local levelLine = unitGuild and GameTooltipTextLeft3 or GameTooltipTextLeft2
    local l = UnitLevel(unit)
    local color = GetCreatureDifficultyColor((l > 0) and l or 999)
    levelLine:SetTextColor(color.r,color.g,color.b)
    --afk?
    if UnitIsAFK(unit) then
      self:AppendText((" |cff%s<AFK>|r"):format(cfg.afkColorHex))
    end
  end
  --dead?
  if UnitIsDeadOrGhost(unit) then
    GameTooltipTextLeft1:SetTextColor(unpack(cfg.deadColor))
  end
  --target line
  if (UnitExists(unit.."target")) then
    GameTooltip:AddDoubleLine(("|cff%s%s|r"):format(cfg.targetColorHex, "Target"),GetTarget(unit.."target") or "Unknown")
  end
end

local function ResetBackdropColor()
  backdrop.backdropColor:SetRGBA(unpack(backdrop.bgColor))
  backdrop.backdropBorderColor:SetRGBA(unpack(backdrop.borderColor))
end

local function SetBackdropColor(self)
  self:SetBackdropColor(backdrop.backdropColor:GetRGBA())
  self:SetBackdropBorderColor(backdrop.backdropBorderColor:GetRGBA())
end

--OnShow
local function OnShow(self)
  ResetBackdropColor()
  local itemName, itemLink = self:GetItem()
  if itemLink then
    local _, _, itemRarity = GetItemInfo(itemLink)
    if itemRarity then
      local r,g,b = GetItemQualityColor(itemRarity)
      backdrop.backdropBorderColor:SetRGBA(r,g,b,1)
    end
  end
  SetBackdropColor(self)
end

--OnHide
local function OnHide(self)
  ResetBackdropColor()
end

--OnTooltipCleared
local function OnTooltipCleared(self)
  SetBackdropColor(self)
end

--OnUpdate
local function OnUpdate(self)
  SetBackdropColor(self)
end

local function FixBarColor(self,r,g,b)
  if not cfg.barColor then return end
  if r == cfg.barColor.r and g == cfg.barColor.g and b == cfg.barColor.b then return end
  self:SetStatusBarColor(cfg.barColor.r,cfg.barColor.g,cfg.barColor.b)
end

local function ResetTooltipPosition(self,parent)
  if not cfg.pos then return end
  if type(cfg.pos) == "string" then
    self:SetOwner(parent, cfg.pos)
  else
    self:SetOwner(parent, "ANCHOR_NONE")
    self:ClearAllPoints()
    self:SetPoint(unpack(cfg.pos))
  end
end

-----------------------------
-- Init
-----------------------------

backdrop  = GAME_TOOLTIP_BACKDROP_STYLE_DEFAULT
backdrop.bgFile = cfg.backdrop.bgFile
backdrop.edgeFile = cfg.backdrop.edgeFile
backdrop.tile = cfg.backdrop.tile
backdrop.tileEdge = cfg.backdrop.tileEdge
backdrop.tileSize = cfg.backdrop.tileSize
backdrop.edgeSize = cfg.backdrop.edgeSize
backdrop.insets = cfg.backdrop.insets
backdrop.backdropColor = CreateColor(1,1,1)
backdrop.backdropBorderColor = CreateColor(1,1,1)
backdrop.backdropColor.GetRGB = ColorMixin.GetRGBA
backdrop.backdropBorderColor.GetRGB = ColorMixin.GetRGBA
backdrop.bgColor = cfg.backdrop.bgColor
backdrop.borderColor = cfg.backdrop.borderColor

--hex class colors
for class, color in next, RAID_CLASS_COLORS do
  classColorHex[class] = GetHexColor(color)
end
--hex reaction colors
--for idx, color in next, FACTION_BAR_COLORS do
for i = 1, #FACTION_BAR_COLORS do
  factionColorHex[i] = GetHexColor(FACTION_BAR_COLORS[i])
end

cfg.targetColorHex = GetHexColor(cfg.targetColor)
cfg.afkColorHex = GetHexColor(cfg.afkColor)

GameTooltipHeaderText:SetFont(cfg.fontFamily, 14, "NONE")
GameTooltipHeaderText:SetShadowOffset(1,-1)
GameTooltipHeaderText:SetShadowColor(0,0,0,0.9)
GameTooltipText:SetFont(cfg.fontFamily, 12, "NONE")
GameTooltipText:SetShadowOffset(1,-1)
GameTooltipText:SetShadowColor(0,0,0,0.9)
Tooltip_Small:SetFont(cfg.fontFamily, 11, "NONE")
Tooltip_Small:SetShadowOffset(1,-1)
Tooltip_Small:SetShadowColor(0,0,0,0.9)

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
GameTooltipStatusBar.bg:SetVertexColor(0,0,0,0.7)

--GameTooltipStatusBar:SetStatusBarColor()
hooksecurefunc(GameTooltipStatusBar,"SetStatusBarColor", FixBarColor)
--GameTooltip_SetDefaultAnchor()
hooksecurefunc("GameTooltip_SetDefaultAnchor", ResetTooltipPosition)
--OnTooltipSetUnit
GameTooltip:HookScript("OnTooltipSetUnit", OnTooltipSetUnit)

--loop over tooltips
local tooltips = { GameTooltip,ShoppingTooltip1,ShoppingTooltip2,ItemRefTooltip,ItemRefShoppingTooltip1,ItemRefShoppingTooltip2,WorldMapTooltip,
WorldMapCompareTooltip1,WorldMapCompareTooltip2,SmallTextTooltip }
for i, tooltip in next, tooltips do
  tooltip:SetBackdrop(backdrop)
  tooltip:SetScale(cfg.scale)
  tooltip:HookScript("OnShow", OnShow)
  --tooltip:HookScript("OnHide", OnHide)
  if tooltip:HasScript("OnTooltipCleared") then
    tooltip:HookScript("OnTooltipCleared", OnTooltipCleared)
  end
  --if tooltip:HasScript("OnUpdate") then
    --tooltip:HookScript("OnUpdate", OnUpdate)
  --end
end

--loop over menues
local menues = {
  DropDownList1MenuBackdrop,
  DropDownList2MenuBackdrop,
}
for idx, menu in ipairs(menues) do
  menu:SetScale(cfg.scale)
end

--spellid line

--func TooltipAddSpellID
local function TooltipAddSpellID(self,spellid)
  if not spellid then return end
  self:AddDoubleLine("|cff0099ffSpell ID|r",spellid)
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
  TooltipAddSpellID(self,select(3,self:GetSpell()))
end)