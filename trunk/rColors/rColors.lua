  
  rFACTION_BAR_COLORS = {
    [1] = {r = 0.8, g = 0.3, b = 0.22},
    [2] = {r = 0.8, g = 0.3, b = 0.22},
    [3] = {r = 0.75, g = 0.27, b = 0},
    [4] = {r = 0.9, g = 0.7, b = 0},
    [5] = {r = 0, g = 0.6, b = 0.1},
    [6] = {r = 0, g = 0.6, b = 0.1},
    [7] = {r = 0, g = 0.6, b = 0.1},
    [8] = {r = 0, g = 0.6, b = 0.1},
  };
  
  rPowerBarColor = {}  
  rPowerBarColor["MANA"] = { r = 0, g = 0.6, b = 1 };
  rPowerBarColor["RAGE"] = { r = 1.00, g = 0.00, b = 0.00 };
  rPowerBarColor["FOCUS"] = { r = 1.00, g = 0.50, b = 0.25 };
  rPowerBarColor["ENERGY"] = { r = 1.00, g = 1.00, b = 0.00 };
  rPowerBarColor["HAPPINESS"] = { r = 0.00, g = 1.00, b = 1.00 };
  rPowerBarColor["RUNES"] = { r = 0.50, g = 0.50, b = 0.50 };
  rPowerBarColor["RUNIC_POWER"] = { r = 0.00, g = 0.82, b = 1.00 };
  -- vehicle colors
  rPowerBarColor["AMMOSLOT"] = { r = 0.80, g = 0.60, b = 0.00 };
  rPowerBarColor["FUEL"] = { r = 0.0, g = 0.55, b = 0.5 };
  
  rRAID_CLASS_COLORS = {
    ["HUNTER"] = { r = 0.67, g = 0.83, b = 0.45 },
    ["WARLOCK"] = { r = 0.58, g = 0.51, b = 0.79 },
    ["PRIEST"] = { r = 1.0, g = 1.0, b = 1.0 },
    ["PALADIN"] = { r = 0.96, g = 0.55, b = 0.73 },
    ["MAGE"] = { r = 0.41, g = 0.8, b = 0.94 },
    ["ROGUE"] = { r = 1.0, g = 0.96, b = 0.41 },
    ["DRUID"] = { r = 1.0, g = 0.49, b = 0.04 },
    ["SHAMAN"] = { r = 0.14, g = 0.35, b = 1.0 },
    ["WARRIOR"] = { r = 0.78, g = 0.61, b = 0.43 },
    ["DEATHKNIGHT"] = { r = 0.77, g = 0.12 , b = 0.23 },
  };
  
  
  rGameTooltip_UnitColor = function(unit)
    local r, g, b;
    if (UnitIsPlayer(unit)) then
      local _, englishClass = UnitClass(unit)
      r = rRAID_CLASS_COLORS[englishClass].r;
      g = rRAID_CLASS_COLORS[englishClass].g;
      b = rRAID_CLASS_COLORS[englishClass].b;
    elseif ( UnitPlayerControlled(unit) ) then
      if ( UnitCanAttack(unit, "player") ) then
        -- Hostile players are red
        if ( not UnitCanAttack("player", unit) ) then
          r = 1.0;
          g = 0;
          b = 1.0;
        else
          r = rFACTION_BAR_COLORS[2].r;
          g = rFACTION_BAR_COLORS[2].g;
          b = rFACTION_BAR_COLORS[2].b;
        end
      elseif ( UnitCanAttack("player", unit) ) then
        -- Players we can attack but which are not hostile are yellow
        r = rFACTION_BAR_COLORS[4].r;
        g = rFACTION_BAR_COLORS[4].g;
        b = rFACTION_BAR_COLORS[4].b;
      elseif ( UnitIsPVP(unit) ) then
        -- Players we can assist but are PvP flagged are green
        r = rFACTION_BAR_COLORS[6].r;
        g = rFACTION_BAR_COLORS[6].g;
        b = rFACTION_BAR_COLORS[6].b;
      else
        r = 1.0;
        g = 0;
        b = 1.0;
      end
    else
      local reaction = UnitReaction(unit, "player");
      if ( reaction ) then
        r = rFACTION_BAR_COLORS[reaction].r;
        g = rFACTION_BAR_COLORS[reaction].g;
        b = rFACTION_BAR_COLORS[reaction].b;
      else
        r = 1.0;
        g = 0;
        b = 1.0;
      end
    end
    return r, g, b;
  end

  --GameTooltip_UnitColor = rGameTooltip_UnitColor
  --UnitSelectionColor = GameTooltip_UnitColor