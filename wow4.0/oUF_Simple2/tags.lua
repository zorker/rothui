  
  -- // oUF_Simple2, an oUF tutorial layout
  -- // zork - 2011
  
  -----------------------------
  -- TAGS
  -----------------------------
  
  local numFormat = function(v)
    if v > 1E9 then
      return (floor((v/1E9)*10)/10).."b"
    elseif v > 1E6 then
      return (floor((v/1E6)*10)/10).."m"
    elseif v > 1E3 then
      return (floor((v/1E3)*10)/10).."k"
    else
      return v
    end  
  end

oUF.Tags["simple:hpdefault"] = function(unit)
  if not UnitIsConnected(unit) then
    return "|cff999999Off|r"
  end  
  if(UnitIsDead(unit) or UnitIsGhost(unit)) then 
    return "|cff999999Dead|r"
  end
  local min, max = UnitHealth(unit), UnitHealthMax(unit)
  local per = 0
  if max > 0 then
    per = floor(min/max*100)
  end
  local val = numFormat(min)  
  return val.."|cffcccccc / |r"..per.."%"  
end
oUF.TagEvents["simple:hpdefault"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION"

oUF.Tags["simple:hpperc"] = function(unit)
  if not UnitIsConnected(unit) then
    return "|cff999999Off|r"
  end  
  if(UnitIsDead(unit) or UnitIsGhost(unit)) then 
    return "|cff999999Dead|r"
  end
  local min, max = UnitHealth(unit), UnitHealthMax(unit)
  local per = 0
  if max > 0 then
    per = floor(min/max*100)
  end
  return per.."%"  
end

oUF.TagEvents["simple:hpperc"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION"

oUF.Tags["simple:hpraid"] = function(unit)
  if not UnitIsConnected(unit) then
    return "|cff999999Off|r"
  end  
  if(UnitIsDead(unit) or UnitIsGhost(unit)) then 
    return "|cff999999Dead|r"
  end
  local min, max = UnitHealth(unit), UnitHealthMax(unit)
  if min == max and max > 0 then
    return UnitName(unit)
  end
  return "-"..numFormat(max-min)
end

oUF.TagEvents["simple:hpraid"] = "UNIT_NAME_UPDATE UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION"