--[[
  Project.: oUF_Vengeance
  File....: oUF_Vengeance.lua
  Version.: 40200.2
  Rev Date: 06/28/2011
  Authors.: Shandrela [EU-Baelgun] <Bloodmoon>, changes by zork
]]

----------------------------------
-- VARIABLES
----------------------------------

local _, ns = ...
local oUF = oUF or ns.oUF
local _, class = UnitClass("player")
local vengeance = GetSpellInfo(93098)
local tooltip = CreateFrame("GameTooltip", "VengeanceTooltip", UIParent, "GameTooltipTemplate")
tooltip:SetOwner(UIParent, "ANCHOR_NONE")

----------------------------------
-- FUNCTIONS
----------------------------------

--get tooltip text func
local function getTooltipText(...)
  local text = ""
  for i=1,select("#",...) do
    local rgn = select(i,...)
    if rgn and rgn:GetObjectType() == "FontString" then
      text = text .. (rgn:GetText() or "")
    end
  end
  return text
end

--check aura func
local function checkAura(self, event, unit)
  if not unit or (unit and unit ~= "player") then return end
  local bar = self.Vengeance
  bar:Hide() --hide bar by default
  if not bar.isTank or not bar.max or bar.max == 0 then return end
  --print("checkAura: "..event) --debug
  local name = UnitBuff("player", vengeance)
  if not name then return end
  tooltip:ClearLines()
  tooltip:SetUnitBuff("player", name)
  local text = getTooltipText(tooltip:GetRegions())
  --print(text) --debug
  if not bar.value then bar.value = 0 end
  local value = floor(tonumber(string.match(text,"%d+")) or 0)
  if value > 0 then
    bar:Show() --show bar, all conditions are met
    if value > bar.max then value = bar.max end
    if value == bar.value then return end --no need to set already given values
    --print(value) --debug
    bar:SetValue(value)
    bar.value = value
    if bar.Text then
      if bar.OverrideText then
        bar:OverrideText(value)
      else
        bar.Text:SetText(value)
      end
    end
  end
end

--check health func
local function checkHealth(self,event)
  local bar = self.Vengeance
  if not bar.isTank then return end
  --print("checkHealth: "..event) --debug
  bar.max = 0 --disable max health by default
  local health = UnitHealthMax("player")
  local _, stamina = UnitStat("player", 3)
  if not health or not stamina then return end
  bar.max = floor(0.1 * (health - 15 * stamina) + stamina)
  bar:SetMinMaxValues(0, bar.max)
  checkAura(self, event, "player") --aura check for player on health check, hand over self and event
end

--check tank func
local function checkTank(self,event)
  --print("checkTank: "..event) --debug
  local bar = self.Vengeance
  bar.isTank = false  --by default no tank
  bar:Hide()          --hide bar by default
  local masteryIndex = GetPrimaryTalentTree()
  if masteryIndex then
    if class == "DRUID" and masteryIndex == 2 then
      local form = GetShapeshiftFormID()
      if form and form == BEAR_FORM then
        bar.isTank = true
      end
    elseif class == "DEATHKNIGHT" and masteryIndex == 1 then
      bar.isTank = true
    elseif class == "PALADIN" and masteryIndex == 2 then
      bar.isTank = true
    elseif class == "WARRIOR" and masteryIndex == 3 then
      bar.isTank = true
    end
  end
  checkHealth(self,event) --health check on tank check, hand over self and event
end

--enable func
local function Enable(self, unit)
  local bar = self.Vengeance
  if bar and unit == "player" then
    self:RegisterEvent("UNIT_AURA", checkAura)
    self:RegisterEvent("UNIT_MAXHEALTH", checkHealth)
    self:RegisterEvent("UNIT_LEVEL", checkHealth)
    self:RegisterEvent("PLAYER_REGEN_DISABLED", checkTank)
    bar:Hide()
    return true
  end
end

--disable func
local function Disable(self)
  local bar = self.Vengeance
  if bar then
    self:UnregisterEvent("UNIT_AURA", checkAura)
    self:UnregisterEvent("UNIT_MAXHEALTH", checkHealth)
    self:UnregisterEvent("UNIT_LEVEL", checkHealth)
    self:UnregisterEvent("PLAYER_REGEN_DISABLED", checkTank)
  end
end

----------------------------------
-- ADD ELEMENT
----------------------------------

oUF:AddElement("Vengeance", nil, Enable, Disable)