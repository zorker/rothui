
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
  local spell

  -----------------------------
  -- CONFIG
  -----------------------------

  --zorks buff and debuff list
  if playerName == "Zork" and playerClass == "WARRIOR" then

    -- buffs
    spell = {
      spellid = 12880,    --spell id
      unit    = "player", --unit that spell should be tracked on
      caster  = nil,      --the unit that casted the spell
      useSpellIconAsTexture = false, --will override the texture setting and use the spell icon texture instead
      texture = "TEXTURES\\SPELLACTIVATIONOVERLAYS\\molten_core", --the texture that you want to display
      anchor  = "TOP",    --texture anchor point
      scale   = 1,        --texture scale
      color   = { r=1, g=1, b=1, }, --texture vertex color
      vFLip   = false,    --texture vertical flip
      hFlip   = false,    --texture horizontal flip
    }
    --add the enrage spell to the addon db
    rASA:AddAura(spellConfig, "buff")

    -- debuffs
    spell = {
      spellid = 86346,    --spell id (COLOSSUS SMASH)
      unit    = "target", --unit that spell should be tracked on
      caster  = "player", --the unit that casted the spell
      useSpellIconAsTexture = true, --will override the texture setting and use the spell icon texture instead
      texture = "TEXTURES\\SPELLACTIVATIONOVERLAYS\\molten_core", --the texture that you want to display
      anchor  = "BOTTOM",    --texture anchor point
      scale   = 2,        --texture scale
      color   = { r=1, g=1, b=1, }, --texture vertex color
      vFLip   = true,    --texture vertical flip
      hFlip   = false,    --texture horizontal flip
    }
    --add the colossus smash spell to the addon db
    rASA:AddAura(spellConfig, "debuff")

  end