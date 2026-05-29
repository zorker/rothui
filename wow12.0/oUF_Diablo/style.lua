local A, L = ...

---------------------------------------------------------------------
-- UnitSpecific
---------------------------------------------------------------------

local UnitSpecific = {
  player = L.F.StylePlayer,
  --[[
  party = function(self)
    -- Party specific layout code.
  end,
  ]]
}

---------------------------------------------------------------------
-- Shared
---------------------------------------------------------------------

local Shared = function(self, unit)
	if(UnitSpecific[unit]) then
		return UnitSpecific[unit](self)
	end
end

---------------------------------------------------------------------
-- RegisterStyle
---------------------------------------------------------------------

oUF:RegisterStyle("oUF_Diablo", Shared)

---------------------------------------------------------------------
-- SpawnUnits
---------------------------------------------------------------------

local function SpawnUnits()
  oUF:Factory(function(self)
    self:SetActiveStyle("oUF_Diablo")
    self:Spawn("player")
    --[[
    -- oUF:SpawnHeader(overrideName, overrideTemplate, visibility, attributes ...)
    local party = self:SpawnHeader(nil, nil, "raid,party,solo",
        -- http://wowprogramming.com/docs/secure_template/Group_Headers
        -- Set header attributes
        "showParty", true,
        "showPlayer", true,
        "yOffset", -20
    )
    party:SetPoint("TOPLEFT", 30, -30)
    ]]
  end)
end
L.F.SpawnUnits = SpawnUnits