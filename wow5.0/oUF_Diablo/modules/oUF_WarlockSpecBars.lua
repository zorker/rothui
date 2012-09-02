if select(2, UnitClass("player")) ~= "WARLOCK" then return end

local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, "oUF_WarlockSpecBars was unable to locate oUF install")

local MAX_POWER_PER_EMBER = 10
local SPELL_POWER_DEMONIC_FURY = SPELL_POWER_DEMONIC_FURY
local SPELL_POWER_BURNING_EMBERS = SPELL_POWER_BURNING_EMBERS
local SPELL_POWER_SOUL_SHARDS = SPELL_POWER_SOUL_SHARDS
local SPEC_WARLOCK_DESTRUCTION = SPEC_WARLOCK_DESTRUCTION
local SPEC_WARLOCK_DESTRUCTION_GLYPH_EMBERS = 63304
local SPEC_WARLOCK_AFFLICTION = SPEC_WARLOCK_AFFLICTION
local SPEC_WARLOCK_AFFLICTION_GLYPH_SHARDS = 63302
local SPEC_WARLOCK_DEMONOLOGY = SPEC_WARLOCK_DEMONOLOGY
local LATEST_SPEC = 0

local Colors = {
  [1] = {.61, .30, 1},
  [2] = {.61, .30, 1},
  [3] = {1, .76, .30}
}

local Update = function(self, event, unit, powerType)
  if(self.unit ~= unit or (powerType and powerType ~= "BURNING_EMBERS" and powerType ~= "SOUL_SHARDS" and powerType ~= "DEMONIC_FURY")) then return end
  local wsb = self.WarlockSpecBars

  if(wsb.PreUpdate) then wsb:PreUpdate(self) end

  local spec = GetSpecialization()

  if spec then
    if (spec == SPEC_WARLOCK_DESTRUCTION) then
      local maxPower = UnitPowerMax("player", SPELL_POWER_BURNING_EMBERS, true)
      local power = UnitPower("player", SPELL_POWER_BURNING_EMBERS, true)
      local numEmbers = power / MAX_POWER_PER_EMBER
      local numBars = floor(maxPower / MAX_POWER_PER_EMBER)

      for i = 1, numBars do
        wsb[i]:SetMinMaxValues((MAX_POWER_PER_EMBER * i) - MAX_POWER_PER_EMBER, MAX_POWER_PER_EMBER * i)
        wsb[i]:SetValue(power)
      end
    elseif ( spec == SPEC_WARLOCK_AFFLICTION ) then
      local numShards = UnitPower("player", SPELL_POWER_SOUL_SHARDS)
      local maxShards = UnitPowerMax("player", SPELL_POWER_SOUL_SHARDS)

      for i = 1, maxShards do
        wsb[i]:SetMinMaxValues(0, 1)
        if i <= numShards then
          wsb[i]:SetValue(1)
        else
          wsb[i]:SetValue(0)
        end
      end
    elseif spec == SPEC_WARLOCK_DEMONOLOGY then
      local power = UnitPower("player", SPELL_POWER_DEMONIC_FURY)
      local maxPower = UnitPowerMax("player", SPELL_POWER_DEMONIC_FURY)

      wsb[1]:SetMinMaxValues(0, maxPower)
      wsb[1]:SetValue(power)
    end
  end

  if(wsb.PostUpdate) then
    return wsb:PostUpdate(spec)
  end
end

local function Visibility(self, event, unit)
  local wsb = self.WarlockSpecBars
  local spec = GetSpecialization()

  if spec then
    if not wsb:IsShown() then
      wsb:Show()
    end

    if LATEST_SPEC ~= spec then

      if(wsb.PreUpdateVisibility) then wsb:PreUpdateVisibility(self) end

      for i = 1, 4 do
        local max = select(2, wsb[i]:GetMinMaxValues())
        if spec == SPEC_WARLOCK_AFFLICTION then
          wsb[i]:SetValue(max)
        else
          wsb[i]:SetValue(0)
        end
      end

      if LATEST_SPEC == SPEC_WARLOCK_DEMONOLOGY then
        wsb[1]:SetOrientation("VERTICAL")
      end
    end

    if spec == SPEC_WARLOCK_DESTRUCTION then
      local maxembers = 3
      for i = 1, GetNumGlyphSockets() do
        local glyphID = select(4, GetGlyphSocketInfo(i))
        if glyphID == SPEC_WARLOCK_DESTRUCTION_GLYPH_EMBERS then maxembers = 4 end
      end

      if maxembers == 3 then wsb[4]:Hide() else wsb[4]:Show() end
      for n = 1, maxembers do
        wsb[n]:SetStatusBarColor(unpack(Colors[spec]))
        wsb[n].bg:SetVertexColor(Colors[spec][1] * .3,Colors[spec][2] * .3,Colors[spec][3] * .3)
        wsb[n]:Show()
      end
    elseif spec == SPEC_WARLOCK_AFFLICTION then
      local maxshards = 3
      for i = 1, GetNumGlyphSockets() do
        local glyphID = select(4, GetGlyphSocketInfo(i))
        if glyphID == SPEC_WARLOCK_AFFLICTION_GLYPH_SHARDS then maxshards = 4 end
      end

      for n = 1, maxshards do
        wsb[n]:SetStatusBarColor(unpack(Colors[spec]))
        wsb[n].bg:SetVertexColor(Colors[spec][1] * .3,Colors[spec][2] * .3,Colors[spec][3] * .3)
        wsb[n]:Show()
      end

      if maxshards == 3 then wsb[4]:Hide() else wsb[4]:Show() end
    elseif spec == SPEC_WARLOCK_DEMONOLOGY then
      wsb[2]:Hide()
      wsb[3]:Hide()
      wsb[4]:Hide()
      wsb[1]:SetOrientation("HORIZONTAL")
      wsb[1]:SetStatusBarColor(unpack(Colors[spec]))
      wsb[1].bg:SetVertexColor(Colors[spec][1] * .3,Colors[spec][2] * .3,Colors[spec][3] * .3)
    end
  else
    if wsb:IsShown() then
      wsb:Hide()
    end
  end

  wsb.ForceUpdate(wsb)
  LATEST_SPEC = spec
end

local Path = function(self, ...)
  return (self.WarlockSpecBars.Override or Update) (self, ...)
end

local ForceUpdate = function(element)
  return Path(element.__owner, "ForceUpdate", element.__owner.unit, "SOUL_SHARDS")
end

local function Enable(self)
  local wsb = self.WarlockSpecBars
  if(wsb) then
    wsb.__owner = self
    wsb.ForceUpdate = ForceUpdate

    self:RegisterEvent("UNIT_POWER", Path)
    self:RegisterEvent("UNIT_DISPLAYPOWER", Path)
    self:RegisterEvent("PLAYER_TALENT_UPDATE", Visibility, true)
    self:RegisterEvent("SPELLS_CHANGED", Visibility, true)

    for i = 1, 4 do
      local Point = wsb[i]
      if not Point:GetStatusBarTexture() then
        Point:SetStatusBarTexture([=[Interface\TargetingFrame\UI-StatusBar]=])
      end
    end

    wsb:Hide()

    return true
  end
end

local function Disable(self)
  local wsb = self.WarlockSpecBars
  if(wsb) then
    self:UnregisterEvent("UNIT_POWER", Path)
    self:UnregisterEvent("UNIT_DISPLAYPOWER", Path)
    self:UnregisterEvent("PLAYER_TALENT_UPDATE", Visibility)
  end
end

oUF:AddElement("WarlockSpecBars", Path, Enable, Disable)