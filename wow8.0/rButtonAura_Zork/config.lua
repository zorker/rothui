
-- rButtonAura_Zork: config
-- zork, 2018

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Aura config
-----------------------------

--shield block
local aura = {
  button          = MultiBarBottomLeftButton2,
  unit            = "player",
  caster          = "player",
  spellid         = 132404,
  filter          = "HELPFUL|PLAYER",
  useBar          = true,
  barColor        = {1,1,0,1},
  barPoint        = {"TOPLEFT",0,0},
  barHeight       = 4,
  useBorder       = true,
  borderColor     = {0,1,0,1},
}
rButtonAura:AddAura(aura)

--battle shout
local aura = {
  button          = MultiBarLeftButton2,
  unit            = "player",
  caster          = "player",
  spellid         = 6673,
  filter          = "HELPFUL|PLAYER",
  useBar          = false,
  barColor        = {1,1,0,1},
  barPoint        = {"TOPLEFT",0,0},
  barHeight       = 4,
  useBorder       = true,
  borderColor     = {0,1,0,1},
}
rButtonAura:AddAura(aura)

--ignore pain
local aura = {
  button          = MultiBarBottomLeftButton8,
  unit            = "player",
  caster          = "player",
  spellid         = 190456,
  filter          = "HELPFUL|PLAYER",
  useBar          = false,
  barColor        = {1,1,0,1},
  barPoint        = {"TOPLEFT",0,0},
  barHeight       = 4,
  useBorder       = true,
  borderColor     = {0,1,0,1},
}
rButtonAura:AddAura(aura)

--avatar
local aura = {
  button          = MultiBarBottomLeftButton4,
  unit            = "player",
  caster          = "player",
  spellid         = 107574,
  filter          = "HELPFUL|PLAYER",
  useBar          = false,
  barColor        = {1,1,0,1},
  barPoint        = {"TOPLEFT",0,0},
  barHeight       = 4,
  useBorder       = true,
  borderColor     = {0,1,0,1},
}
rButtonAura:AddAura(aura)

--last stand
local aura = {
  button          = MultiBarBottomLeftButton5,
  unit            = "player",
  caster          = "player",
  spellid         = 12975,
  filter          = "HELPFUL|PLAYER",
  useBar          = true,
  barColor        = {1,1,0,1},
  barPoint        = {"TOPLEFT",0,0},
  barHeight       = 4,
  useBorder       = true,
  borderColor     = {0,1,0,1},
}
rButtonAura:AddAura(aura)

--shield wall
local aura = {
  button          = MultiBarBottomLeftButton6,
  unit            = "player",
  caster          = "player",
  spellid         = 871,
  filter          = "HELPFUL|PLAYER",
  useBar          = true,
  barColor        = {1,1,0,1},
  barPoint        = {"TOPLEFT",0,0},
  barHeight       = 4,
  useBorder       = true,
  borderColor     = {0,1,0,1},
}
rButtonAura:AddAura(aura)

