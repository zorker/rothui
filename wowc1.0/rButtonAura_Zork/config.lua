
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
    spellid         = 2565,
    filter          = "HELPFUL|PLAYER",
    form            = 2,
    useBar          = true,
    barColor        = {1,1,0,0.8},
    barBlendMode    = "ADD",
    barPoint        = {"TOPLEFT"},
    barHeight       = 3,
    useBorder       = true,
    borderColor     = {0,1,1,0.8},
  }
  rButtonAura:AddAura(aura)

  --battle shout
  local aura = {
    button          = MultiBarBottomLeftButton8,
    unit            = "player",
    --caster          = "player",
    spellid         = 5242,
    filter          = "HELPFUL",
    useBar          = true,
    barColor        = {1,1,0,0.8},
    barBlendMode    = "ADD",
    barPoint        = {"TOPLEFT"},
    barHeight       = 3,
    useBorder       = true,
    borderColor     = {0,1,1,0.8},
  }
  rButtonAura:AddAura(aura)

  --rend
  local aura = {
    button          = MultiBarBottomLeftButton3,
    unit            = "target",
    caster          = "player",
    spellid         = 6547,
    filter          = "HARMFUL|PLAYER",
    useBar          = false,
    barColor        = {1,1,0,1},
    barPoint        = {"TOPLEFT"},
    barHeight       = 5,
    useBorder       = true,
    borderColor     = {1,0,0,0.8},
  }
  rButtonAura:AddAura(aura)

  --demo shout
  local aura = {
    button          = ActionButton10,
    unit            = "target",
    caster          = "player",
    spellid         = 1160,
    filter          = "HARMFUL|PLAYER",
    useBar          = false,
    barColor        = {1,1,0,1},
    barPoint        = {"TOPLEFT"},
    barHeight       = 5,
    useBorder       = true,
    borderColor     = {1,0,0,0.8},
  }
  rButtonAura:AddAura(aura)

  --sunder armor
  local aura = {
    button          = ActionButton3,
    unit            = "target",
    caster          = "player",
    spellid         = 7386,
    filter          = "HARMFUL|PLAYER",
    useBar          = false,
    barColor        = {1,1,0,1},
    barPoint        = {"TOPLEFT"},
    barHeight       = 5,
    useBorder       = true,
    borderColor     = {1,0,0,0.8},
  }
  rButtonAura:AddAura(aura)

end
