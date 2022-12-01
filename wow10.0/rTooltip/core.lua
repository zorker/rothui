
-- rTooltip: core
-- zork, 2018

-----------------------------
-- Variables
-----------------------------

local A, L = ...

local GameTooltip = GameTooltip

-----------------------------
-- Config
-----------------------------

-----------------------------
-- Functions
-----------------------------

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

