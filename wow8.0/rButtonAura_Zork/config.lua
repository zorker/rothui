
-- rButtonAura_Zork: config
-- zork, 2018

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Aura config
-----------------------------

local aura = {
  button          = ActionButton3,
  unit            = "target",
  caster          = "player",
  spellid         = 243016,
  filter          = "HARMFUL|PLAYER",
  useBorder       = true,
  borderColor     = {0,1,1},
}
rButtonAura:AddAura(aura)

local aura = {
  button          = ActionButton8,
  unit            = "player",
  caster          = "player",
  spellid         = 132404,
  filter          = "HELPFUL|PLAYER",
  useBar          = true,
  barColor        = {0,1,0},
  useBorder       = false,
  borderColor     = {0,1,0,0.5},
}
rButtonAura:AddAura(aura)

local aura = {
  button          = ActionButton9,
  unit            = "player",
  caster          = "player",
  spellid         = 190456,
  filter          = "HELPFUL|PLAYER",
  useBar          = true,
  barColor        = {0,1,0},
  useBorder       = false,
  borderColor     = {0,1,0},
}
rButtonAura:AddAura(aura)

local aura = {
  button          = MultiBarBottomLeftButton1,
  unit            = "player",
  caster          = "player",
  spellid         = 12975,
  filter          = "HELPFUL|PLAYER",
  useBorder       = true,
  borderColor     = {0,1,0},
}
rButtonAura:AddAura(aura)

local aura = {
  button          = MultiBarBottomLeftButton2,
  unit            = "player",
  caster          = "player",
  spellid         = 871,
  filter          = "HELPFUL|PLAYER",
  useBorder       = true,
  borderColor     = {0,1,0},
}
rButtonAura:AddAura(aura)

local aura = {
  button          = MultiBarBottomLeftButton3,
  unit            = "player",
  caster          = "player",
  spellid         = 125565,
  filter          = "HELPFUL|PLAYER",
  useBorder       = true,
  borderColor     = {0,1,0},
}
rButtonAura:AddAura(aura)


