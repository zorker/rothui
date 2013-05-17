
  -- // rActiveSpellAlert
  -- // zork - 2013

  --get the addon namespace
  local addon, ns = ...

  -----------------------------
  -- VARIABLES
  -----------------------------

  local rASA = ns.rASA

  local playerName = UnitName("player")
  local _, playerClass = UnitClass("player")
  local spellConfig

  -----------------------------
  -- CONFIG
  -----------------------------

  rASA.debug = true --enable texture debugging mode



  --zorks buff and debuff list
  if playerName == "Zork" and playerClass == "WARRIOR" then

    -- buffs
    spellConfig = {
      spellid = 12880,    --spell id
      unit    = "player", --unit that spell should be tracked on
      caster  = nil,      --the unit that casted the spell
      useSpellIconAsTexture = false, --will override the texture setting and use the spell icon texture instead
      texture = "TEXTURES\\SPELLACTIVATIONOVERLAYS\\ULTIMATUM", --the texture that you want to display
      anchor  = "TOP",    --texture anchor point
      scale   = 0.8,        --texture scale
      color   = { r=1, g=0, b=0, }, --texture vertex color
      vFLip   = false,    --texture vertical flip
      hFlip   = false,    --texture horizontal flip
    }
    --add the enrage spell to the addon db
    rASA:AddBuff(spellConfig)

    -- debuffs
    spellConfig = {
      spellid = 86346,    --spell id (COLOSSUS SMASH)
      unit    = "target", --unit that spell should be tracked on
      caster  = "player", --the unit that casted the spell
      useSpellIconAsTexture = false, --will override the texture setting and use the spell icon texture instead
      texture = "TEXTURES\\SPELLACTIVATIONOVERLAYS\\ULTIMATUM", --the texture that you want to display
      anchor  = "CENTER",    --texture anchor point
      scale   = 1,        --texture scale
      color   = { r=1, g=0, b=0, }, --texture vertex color
      vFLip   = false,    --texture vertical flip
      hFlip   = false,    --texture horizontal flip
    }
    --add the colossus smash spell to the addon db
    rASA:AddDebuff(spellConfig)

    -- buffs
    spellConfig = {
      spellid = 12880,    --spell id
      unit    = "player", --unit that spell should be tracked on
      caster  = nil,      --the unit that casted the spell
      useSpellIconAsTexture = false, --will override the texture setting and use the spell icon texture instead
      texture = "TEXTURES\\SPELLACTIVATIONOVERLAYS\\ULTIMATUM", --the texture that you want to display
      anchor  = "BOTTOM",    --texture anchor point
      scale   = 0.8,        --texture scale
      color   = { r=1, g=0, b=0, }, --texture vertex color
      vFLip   = true,    --texture vertical flip
      hFlip   = false,    --texture horizontal flip
    }
    --add the enrage spell to the addon db
    rASA:AddBuff(spellConfig)

    -- buffs
    spellConfig = {
      spellid = 12880,    --spell id
      unit    = "player", --unit that spell should be tracked on
      caster  = nil,      --the unit that casted the spell
      useSpellIconAsTexture = false, --will override the texture setting and use the spell icon texture instead
      texture = "TEXTURES\\SPELLACTIVATIONOVERLAYS\\ULTIMATUM", --the texture that you want to display
      anchor  = "LEFT",    --texture anchor point
      scale   = 0.8,        --texture scale
      color   = { r=1, g=0, b=0, }, --texture vertex color
      vFLip   = true,    --texture vertical flip
      hFlip   = true,    --texture horizontal flip
    }
    --add the enrage spell to the addon db
    rASA:AddBuff(spellConfig)

    -- buffs
    spellConfig = {
      spellid = 12880,    --spell id
      unit    = "player", --unit that spell should be tracked on
      caster  = nil,      --the unit that casted the spell
      useSpellIconAsTexture = false, --will override the texture setting and use the spell icon texture instead
      texture = "TEXTURES\\SPELLACTIVATIONOVERLAYS\\ULTIMATUM", --the texture that you want to display
      anchor  = "RIGHT",    --texture anchor point
      scale   = 0.8,        --texture scale
      color   = { r=1, g=0, b=0, }, --texture vertex color
      vFLip   = true,    --texture vertical flip
      hFlip   = true,    --texture horizontal flip
    }
    --add the enrage spell to the addon db
    rASA:AddBuff(spellConfig)

    -- buffs
    spellConfig = {
      spellid = 12880,    --spell id
      unit    = "player", --unit that spell should be tracked on
      caster  = nil,      --the unit that casted the spell
      useSpellIconAsTexture = false, --will override the texture setting and use the spell icon texture instead
      texture = "TEXTURES\\SPELLACTIVATIONOVERLAYS\\ULTIMATUM", --the texture that you want to display
      anchor  = "TOPRIGHT",    --texture anchor point
      scale   = 0.8,        --texture scale
      color   = { r=1, g=0, b=0, }, --texture vertex color
      vFLip   = true,    --texture vertical flip
      hFlip   = true,    --texture horizontal flip
    }
    --add the enrage spell to the addon db
    rASA:AddBuff(spellConfig)

    -- buffs
    spellConfig = {
      spellid = 12880,    --spell id
      unit    = "player", --unit that spell should be tracked on
      caster  = nil,      --the unit that casted the spell
      useSpellIconAsTexture = false, --will override the texture setting and use the spell icon texture instead
      texture = "TEXTURES\\SPELLACTIVATIONOVERLAYS\\ULTIMATUM", --the texture that you want to display
      anchor  = "TOPLEFT",    --texture anchor point
      scale   = 0.8,        --texture scale
      color   = { r=1, g=0, b=0, }, --texture vertex color
      vFLip   = true,    --texture vertical flip
      hFlip   = true,    --texture horizontal flip
    }
    --add the enrage spell to the addon db
    rASA:AddBuff(spellConfig)

    -- buffs
    spellConfig = {
      spellid = 12880,    --spell id
      unit    = "player", --unit that spell should be tracked on
      caster  = nil,      --the unit that casted the spell
      useSpellIconAsTexture = false, --will override the texture setting and use the spell icon texture instead
      texture = "TEXTURES\\SPELLACTIVATIONOVERLAYS\\ULTIMATUM", --the texture that you want to display
      anchor  = "BOTTOMLEFT",    --texture anchor point
      scale   = 0.8,        --texture scale
      color   = { r=1, g=0, b=0, }, --texture vertex color
      vFLip   = true,    --texture vertical flip
      hFlip   = true,    --texture horizontal flip
    }
    --add the enrage spell to the addon db
    rASA:AddBuff(spellConfig)

    -- buffs
    spellConfig = {
      spellid = 12880,    --spell id
      unit    = "player", --unit that spell should be tracked on
      caster  = nil,      --the unit that casted the spell
      useSpellIconAsTexture = false, --will override the texture setting and use the spell icon texture instead
      texture = "TEXTURES\\SPELLACTIVATIONOVERLAYS\\ULTIMATUM", --the texture that you want to display
      anchor  = "BOTTOMRIGHT",    --texture anchor point
      scale   = 0.8,        --texture scale
      color   = { r=1, g=0, b=0, }, --texture vertex color
      vFLip   = true,    --texture vertical flip
      hFlip   = true,    --texture horizontal flip
    }
    --add the enrage spell to the addon db
    rASA:AddBuff(spellConfig)

  end