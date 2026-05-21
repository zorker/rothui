local A, L = ...

local function StylePlayer(self)

  self:SetSize(256, 256)
  self:SetPoint("CENTER")
  self.elementType = "base"

  local healthOrb = CreateFrame("Frame", nil, self, "rModelOrbTemplate")
  healthOrb:SetPoint("CENTER")

  local health = CreateFrame("StatusBar", nil, self)
  self.Health = health
  self.Health.elementType = "health"

  function health:UpdateColor(event, unit)
	  if(not unit or self.unit ~= unit) then return end
	  local element = self.Health
    print('UpdateColor',self.elementType,event,unit)
    local templateName = nil
    if(element.colorClass and (UnitIsPlayer(unit) or UnitInPartyIsAI(unit)))
      or (element.colorClassNPC and not (UnitIsPlayer(unit) or UnitInPartyIsAI(unit)))
      or (element.colorClassPet and UnitPlayerControlled(unit) and not UnitIsPlayer(unit)) then
      local _, class = UnitClass(unit)
      templateName = "_CLASS_"..class
    elseif(element.colorReaction and UnitReaction(unit, 'player')) then
      local reaction = UnitReaction(unit, 'player')
      if reaction >= 5 then
        templateName = "_REACTION_FRIENDLY"
      elseif reaction >= 3 then
        templateName = "_REACTION_NEUTRAL"
      else
        templateName = "_REACTION_HOSTILE"
      end
    else
      templateName = "_OTHER"
    end
    print(templateName)
  end

  health.colorClass = true
  health.colorReaction = true
  health.colorHealth = true

end

local UnitSpecific = {
  player = StylePlayer,
  --[[
  party = function(self)
    -- Party specific layout code.         
  end,
  ]]
}

local Shared = function(self, unit)
	if(UnitSpecific[unit]) then
		return UnitSpecific[unit](self)
	end
end

oUF:RegisterStyle("oUF_Diablo", Shared)

local function SpawnUnits()
  oUF:Factory(function(self)
    self:SetActiveStyle("oUF_Diablo")
    self:Spawn("player")
    --[[
    -- oUF:SpawnHeader(overrideName, overrideTemplate, visibility, attributes ...)
    local party = self:SpawnHeader(nil, nil, 'raid,party,solo',
        -- http://wowprogramming.com/docs/secure_template/Group_Headers
        -- Set header attributes
        'showParty', true, 
        'showPlayer', true, 
        'yOffset', -20
    )
    party:SetPoint("TOPLEFT", 30, -30)
    ]]
  end)
end
L.F.SpawnUnits = SpawnUnits