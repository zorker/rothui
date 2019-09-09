
-- rButtonAura_Zork: config
-- zork, 2018

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
    spec            = 3,
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
    spec            = 3,
    useBar          = true,
    barColor        = {1,1,0,1},
    barPoint        = {"TOPLEFT"},
    barHeight       = 5,
    useBorder       = true,
    borderColor     = {0,1,0,1},
  }
  rButtonAura:AddAura(aura)

  --arms sweeping strikes
  local aura = {
    button          = ActionButton7,
    unit            = "player",
    caster          = "player",
    spellid         = 260708,
    filter          = "HELPFUL|PLAYER",
    spec            = 1,
    useBar          = true,
    barColor        = {1,1,0,1},
    barPoint        = {"TOPLEFT"},
    barHeight       = 5,
    useBorder       = true,
    borderColor     = {0,1,0,1},
  }
  rButtonAura:AddAura(aura)

  --arms test of might buff
  local aura = {
    button          = ActionButton9,
    unit            = "player",
    caster          = "player",
    spellid         = 275540,
    filter          = "HELPFUL|PLAYER",
    spec            = 1,
    useBar          = true,
    barColor        = {1,1,0,1},
    barPoint        = {"TOPLEFT"},
    barHeight       = 5,
    useBorder       = true,
    borderColor     = {0,1,0,1},
  }
  rButtonAura:AddAura(aura)

  --arms colossus smash
  local aura = {
    button          = ActionButton8,
    unit            = "target",
    caster          = "player",
    spellid         = 208086,
    filter          = "HARMFUL|PLAYER",
    spec            = 1,
    useBar          = true,
    barColor        = {1,1,0,1},
    barPoint        = {"TOPLEFT"},
    barHeight       = 5,
    useBorder       = true,
    borderColor     = {0,1,0,1},
  }
  rButtonAura:AddAura(aura)

  --spell reflect
  local aura = {
    button          = MultiBarBottomLeftButton3,
    unit            = "player",
    caster          = "player",
    spellid         = 23920,
    filter          = "HELPFUL|PLAYER",
    spec            = 3,
    useBar          = true,
    barColor        = {1,1,0,1},
    barPoint        = {"TOPLEFT"},
    barHeight       = 5,
    useBorder       = true,
    borderColor     = {0,1,0,1},
  }
  rButtonAura:AddAura(aura)

  --battle shout
  local aura = {
    button          = MultiBarBottomLeftButton10,
    unit            = "player",
    caster          = nil, -- do not care about who casted it as long as the buff is there
    spellid         = 6673,
    filter          = "HELPFUL",
    --spec            = 3,
    useBar          = false,
    barColor        = {1,1,0,1},
    barPoint        = {"TOPLEFT"},
    barHeight       = 5,
    useBorder       = true,
    borderColor     = {0,1,0,1},
  }
  rButtonAura:AddAura(aura)

  --rallying cry
  local aura = {
    button          = MultiBarBottomLeftButton9,
    unit            = "player",
    caster          = nil, -- do not care about who casted it as long as the buff is there
    spellid         = 97463,
    filter          = "HELPFUL",
    --spec            = 3,
    useBar          = true,
    barColor        = {1,1,0,1},
    barPoint        = {"TOPLEFT"},
    barHeight       = 5,
    useBorder       = true,
    borderColor     = {0,1,0,1},
  }
  rButtonAura:AddAura(aura)

  --ignore pain
  local aura = {
    button          = MultiBarBottomLeftButton2,
    unit            = "player",
    caster          = "player",
    spellid         = 190456,
    filter          = "HELPFUL|PLAYER",
    spec            = 3,
    useBar          = true,
    barColor        = {1,1,0,1},
    barPoint        = {"TOPLEFT"},
    barHeight       = 5,
    useBorder       = true,
    borderColor     = {0,1,0,1},
  }
  rButtonAura:AddAura(aura)

  --avatar
  local aura = {
    button          = ActionButton10,
    unit            = "player",
    caster          = "player",
    spellid         = 107574,
    filter          = "HELPFUL|PLAYER",
    spec            = 3,
    useBar          = true,
    barColor        = {1,1,0,1},
    barPoint        = {"TOPLEFT"},
    barHeight       = 5,
    useBorder       = true,
    borderColor     = {0,1,0,1},
  }
  rButtonAura:AddAura(aura)

  --last stand
  local aura = {
    button          = ActionButton7,
    unit            = "player",
    caster          = "player",
    spellid         = 12975,
    filter          = "HELPFUL|PLAYER",
    spec            = 3,
    useBar          = true,
    barColor        = {1,1,0,1},
    barPoint        = {"TOPLEFT"},
    barHeight       = 5,
    useBorder       = true,
    borderColor     = {0,1,0,1},
  }
  rButtonAura:AddAura(aura)

  --shield wall
  local aura = {
    button          = MultiBarBottomLeftButton12,
    unit            = "player",
    caster          = "player",
    spellid         = 871,
    filter          = "HELPFUL|PLAYER",
    spec            = 3,
    useBar          = true,
    barColor        = {1,1,0,1},
    barPoint        = {"TOPLEFT"},
    barHeight       = 5,
    useBorder       = true,
    borderColor     = {0,1,0,1},
  }
  rButtonAura:AddAura(aura)

  --fury whirlwind
  local aura = {
    button          = ActionButton4,
    unit            = "player",
    caster          = "player",
    spellid         = 85739,
    filter          = "HELPFUL|PLAYER",
    spec            = 2,
    useBar          = true,
    barColor        = {1,1,0,1},
    barPoint        = {"TOPLEFT"},
    barHeight       = 5,
    useBorder       = true,
    borderColor     = {0,1,0,1},
  }
  rButtonAura:AddAura(aura)

  --fury enrage
  local aura = {
    button          = ActionButton2,
    unit            = "player",
    caster          = "player",
    spellid         = 184362,
    filter          = "HELPFUL|PLAYER",
    spec            = 2,
    useBar          = true,
    barColor        = {1,1,0,1},
    barPoint        = {"TOPLEFT"},
    barHeight       = 5,
    useBorder       = true,
    borderColor     = {0,1,0,1},
  }
  rButtonAura:AddAura(aura)

end

-----------------------------
-- Aura config for Xia (Drood)
-----------------------------

if character == "Xia" then

  --regrowth
  local aura = {
    button          = ActionButton1,
    unit            = "player",
    caster          = "player",
    spellid         = 8936,
    filter          = "HELPFUL|PLAYER",
    spec            = 2,
    form            = 0,
    --requireSpell    = 5221, --only make the buff visible if this spell is available
    useBar          = true,
    barColor        = {1,1,0,1},
    barPoint        = {"TOPLEFT"},
    barHeight       = 5,
    useBorder       = true,
    borderColor     = {0,1,0,1},
  }
  rButtonAura:AddAura(aura)

end

-----------------------------
-- Aura config for Astone (WL)
-----------------------------

if character == "Astone" then

  --Corruption
  local aura = {
    button          = "BT4Button63",
    unit            = "target",
    caster          = "player",
    spellid         = 146739,
    filter          = "HARMFUL|PLAYER",
    spec            = 1,
    useBar          = true,
    barColor        = {1,1,0,1},
    barPoint        = {"TOPLEFT"},
    barHeight       = 5,
    useBorder       = true,
    borderColor     = {0,1,0,1},
  }
  rButtonAura:AddAura(aura)

end

-----------------------------
-- Aura config for Ziza (Rogue)
-----------------------------

if character == "Ziza" then

  --Speed Buff
  local aura = {
    button          = "ActionButton4",
    unit            = "player",
    caster          = "player",
    spellid         = 5171,
    filter          = "HELPFUL|PLAYER",
    spec            = 2,
    useBar          = true,
    barColor        = {1,1,0,1},
    barPoint        = {"TOPLEFT"},
    barHeight       = 5,
    useBorder       = true,
    borderColor     = {0,1,0,1},
  }
  rButtonAura:AddAura(aura)

end

-----------------------------
-- Aura config for Needler (Hunter)
-----------------------------

if character == "Needler" then

  --Frenzy
  local aura = {
    button          = "ActionButton1",
    unit            = "pet",
    caster          = "player",
    spellid         = 272790,
    filter          = "HELPFUL|PLAYER",
    spec            = 1,
    useBar          = true,
    barColor        = {1,1,0,1},
    barPoint        = {"TOPLEFT"},
    barHeight       = 5,
    useBorder       = true,
    borderColor     = {0,1,0,1},
  }
  rButtonAura:AddAura(aura)

  --Beast Cleave
  local aura = {
    button          = "ActionButton5",
    unit            = "pet",
    caster          = "player",
    spellid         = 118455,
    filter          = "HELPFUL|PLAYER",
    spec            = 1,
    useBar          = true,
    barColor        = {1,1,0,1},
    barPoint        = {"TOPLEFT"},
    barHeight       = 5,
    useBorder       = true,
    borderColor     = {0,1,0,1},
  }
  rButtonAura:AddAura(aura)

end

-----------------------------
-- Aura config for Amoka (Monk)
-----------------------------

if character == "Amoka" then

  --Ironbrew
  local aura = {
    button          = "ActionButton8",
    unit            = "player",
    caster          = "player",
    spellid         = 215479,
    filter          = "HELPFUL|PLAYER",
    spec            = 1,
    useBar          = true,
    barColor        = {1,1,0,1},
    barPoint        = {"TOPLEFT"},
    barHeight       = 5,
    useBorder       = true,
    borderColor     = {0,1,0,1},
  }
  rButtonAura:AddAura(aura)

end

-----------------------------
-- Aura config for Luavi (Paladin)
-----------------------------

if character == "Luavi" then

  --Shield of the Righteous
  local aura = {
    button          = "ActionButton8",
    unit            = "player",
    caster          = "player",
    spellid         = 132403,
    filter          = "HELPFUL|PLAYER",
    spec            = 2,
    useBar          = true,
    barColor        = {1,1,0,1},
    barPoint        = {"TOPLEFT"},
    barHeight       = 5,
    useBorder       = true,
    borderColor     = {0,1,0,1},
  }
  rButtonAura:AddAura(aura)

  --Shield of the Righteous
  local charge = {
    button          = "ActionButton8",
    spellid         = 53600,
    spec            = 2,
    useBar          = true,
    barColor        = {1,0,0,1},
    barBlendMode    = "BLEND",
    barPoint        = {"BOTTOMLEFT"},
    barHeight       = 5,
  }
  rButtonAura:AddCharge(charge)

  --Avengers Shield
  local aura = {
    button          = "ActionButton2",
    unit            = "player",
    caster          = "player",
    spellid         = 197561,
    filter          = "HELPFUL|PLAYER",
    spec            = 2,
    useBar          = true,
    barColor        = {1,1,0,1},
    barPoint        = {"TOPLEFT"},
    barHeight       = 5,
    useBorder       = true,
    borderColor     = {0,1,0,1},
  }
  rButtonAura:AddAura(aura)

  --Consecration
  local aura = {
    button          = "ActionButton4",
    unit            = "player",
    caster          = "player",
    spellid         = 188370,
    filter          = "HELPFUL|PLAYER",
    spec            = 2,
    useBar          = false,
    barColor        = {1,1,0,1},
    barPoint        = {"TOPLEFT"},
    barHeight       = 5,
    useBorder       = true,
    borderColor     = {0,1,0,1},
  }
  rButtonAura:AddAura(aura)

end