
-- rButtonAura_Zork: config
-- zork, 2022

-----------------------------
-- Variables
-----------------------------

local A, L = ...

local character = UnitName("player")

-----------------------------
-- Aura config for Zörk
-----------------------------

if character == "Zörk" then

  --shield block
  local aura = {
    button          = ActionButton8,
    unit            = "player",
    caster          = "player",
    spellid         = 132404,
    filter          = "HELPFUL|PLAYER",
    spec            = 3,
    useBar          = true,
    barColor        = {0,1,1,1},
    barPoint        = {"TOPLEFT"},
    barHeight       = 5,
    useBorder       = true,
    borderColor     = {0,1,0,1},
  }
  rButtonAura:AddAura(aura)

  --ignore pain
  local aura = {
    button          = ActionButton7,
    unit            = "player",
    caster          = "player",
    spellid         = 190456,
    filter          = "HELPFUL|PLAYER",
    spec            = 3,
    useBar          = true,
    barColor        = {0,1,1,1},
    barPoint        = {"TOPLEFT"},
    barHeight       = 5,
    useBorder       = true,
    borderColor     = {0,1,0,1},
  }
  rButtonAura:AddAura(aura)

  --Battle Shout
  local aura = {
    button          = MultiBarBottomRightButton9,
    unit            = "player",
    caster          = "player",
    spellid         = 6673,
    filter          = "HELPFUL|PLAYER",
    spec            = 3,
    useBar          = false,
    barColor        = {1,1,0,1},
    barPoint        = {"TOPLEFT"},
    barHeight       = 5,
    useBorder       = true,
    borderColor     = {0,1,0,1},
  }
  rButtonAura:AddAura(aura)

end