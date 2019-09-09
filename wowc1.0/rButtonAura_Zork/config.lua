
-- rButtonAura_Zork: config
-- zork, 2018

-----------------------------
-- Variables
-----------------------------

local A, L = ...

local character = UnitName("player")

-----------------------------
-- Aura config for Rothâr
-----------------------------

if character == "Rothâr" then

  --there is no more spec, use form to filter buttons on bars if needed
  --https://wow.gamepedia.com/API_GetShapeshiftForm
  --warrior
  --1 battle stance
  --2 defensive stance
  --3 berserker stance

  --shield block
  local aura = {
    button          = ActionButton8,
    unit            = "player",
    caster          = "player",
    spellid         = 132404,
    filter          = "HELPFUL|PLAYER",
    form            = 2,
    useBar          = true,
    barColor        = {1,1,0,1},
    barPoint        = {"TOPLEFT"},
    barHeight       = 5,
    useBorder       = true,
    borderColor     = {0,1,0,1},
  }
  rButtonAura:AddAura(aura)

  --shield block
  local charge = {
    button          = "ActionButton8",
    spellid         = 2565,
    form            = 2,
    useBar          = true,
    barColor        = {1,0,0,1},
    barBlendMode    = "BLEND",
    barPoint        = {"BOTTOMLEFT"},
    barHeight       = 5,
  }
  rButtonAura:AddCharge(charge)

  --demo shout
  local aura = {
    button          = ActionButton9,
    unit            = "target",
    caster          = "player",
    spellid         = 1160,
    filter          = "HARMFUL|PLAYER",
    useBar          = true,
    barColor        = {1,1,0,1},
    barPoint        = {"TOPLEFT"},
    barHeight       = 5,
    useBorder       = true,
    borderColor     = {0,1,0,1},
  }
  rButtonAura:AddAura(aura)

end
