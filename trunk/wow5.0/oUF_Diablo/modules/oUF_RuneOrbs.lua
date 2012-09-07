if select(2, UnitClass("player")) ~= "DEATHKNIGHT" then return end

local parent, ns = ...
local oUF = ns.oUF or oUF

oUF.colors.runes = {
  {1,0,0}, --blood
  {0,1,0}, --unholy
  {0,1,1}, --frost
  {1,0,1}, --death
}

local runemap = { 1, 2, 5, 6, 3, 4 }

local OnUpdate = function(self, elapsed)
  local duration = self.duration + elapsed
  if(duration >= self.max) then
    return self:SetScript("OnUpdate", nil)
  else
    self.duration = duration
    return self.fill:SetValue(duration)
  end
end

local UpdateType = function(self, event, rid, alt)
  local rune = self.RuneOrbs[runemap[rid]]
  local colors = self.colors.runes[GetRuneType(rid) or alt]
  local r, g, b = colors[1], colors[2], colors[3]
  rune.fill:SetStatusBarColor(r, g, b)
  rune.glow:SetVertexColor(r, g, b)
end

local UpdateRune = function(self, event, rid)
  local rune = self.RuneOrbs[runemap[rid]]
  if(rune) then
    local start, duration, runeReady = GetRuneCooldown(rid)
    if(runeReady) then
      rune.fill:SetMinMaxValues(0, 1)
      rune.fill:SetValue(1)
      rune.glow:Show()
      rune:SetScript("OnUpdate", nil)
    else
      rune.duration = GetTime() - start
      rune.max = duration
      rune.glow:Hide()
      rune.fill:SetMinMaxValues(1, duration)
      rune:SetScript("OnUpdate", OnUpdate)
    end
  end
end

local Update = function(self, event)
  for i=1, 6 do
    UpdateRune(self, event, i)
  end
end

local Visibility = function(self, event, unit)
  local element = self.RuneOrbs
  local bar = self.RuneBar
  if UnitHasVehicleUI("player")
    or ((HasVehicleActionBar() and UnitVehicleSkin("player") and UnitVehicleSkin("player") ~= "")
    or (HasOverrideActionBar() and GetOverrideBarSkin() and GetOverrideBarSkin() ~= ""))
  then
    bar:Hide()
  else
    bar:Show()
  end
end

local ForceUpdate = function(element)
  return Update(element.__owner, 'ForceUpdate')
end

local Enable = function(self, unit)
  local element = self.RuneOrbs
  if(element) then
    element.__owner = self
    element.ForceUpdate = ForceUpdate

    for i=1, 6 do
      UpdateType(self, nil, i, floor((i+1)/2))
    end

    self:RegisterEvent("RUNE_POWER_UPDATE", UpdateRune, true)
    self:RegisterEvent("RUNE_TYPE_UPDATE", UpdateType, true)
		self:RegisterEvent("UPDATE_OVERRIDE_ACTIONBAR", Visibility, true)

    local helper = CreateFrame("Frame") --this is needed...adding player_login to the visivility events doesn't do anything
    helper:RegisterEvent("PLAYER_LOGIN")
    helper:SetScript("OnEvent", function() Visibility(self) end)

    RuneFrame.Show = RuneFrame.Hide
    RuneFrame:Hide()

    return true
  end
end

local Disable = function(self)
  local element = self.RuneOrbs
  if(element) then
	  RuneFrame.Show = nil
	  RuneFrame:Show()
	  self:UnregisterEvent("RUNE_POWER_UPDATE", UpdateRune)
	  self:UnregisterEvent("RUNE_TYPE_UPDATE", UpdateType)
	  self:UnregisterEvent('UPDATE_OVERRIDE_ACTIONBAR', Visibility)
	end
end

oUF:AddElement("RuneOrbs", Update, Enable, Disable)
