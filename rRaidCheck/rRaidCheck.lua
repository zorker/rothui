  
  function addon:rf_checkraidhealth()
    local n = GetNumRaidMembers()  
    if n > 0 then
      local c = 0
      local d
      local unit
      local i
      local act_hp
      local max_hp
      local per_hp
      local sum_per_hp = 0
      local avg_raid_hp
      for i = 1, n do
        unit = "raid"..i
        if(UnitIsDead(unit)) then
          c = c + 1
        elseif(UnitIsGhost(unit)) then
          c = c + 1
        elseif(not UnitIsConnected(unit)) then
          c = c + 1
        else
          act_hp = UnitHealth(unit);
          max_hp = UnitHealthMax(unit);
          per_hp = floor(act_hp/max_hp*100)
          sum_per_hp = sum_per_hp + per_hp
        end
      end
      d = n - c
      if d == 0 then
        avg_raid_hp = 0
      else    
        avg_raid_hp = floor(sum_per_hp / d)
      end
      -- avg_raid_hp liefert den % HP wert des Raids, offline, tote, oder ghosts werden nicht gewertet
    end
  end
  
  function addon:rf_checkraidmana()
    local n = GetNumRaidMembers()  
    if n > 0 then
      local c = 0
      local d
      local unit
      local i
      local act_mp
      local max_mp
      local per_mp
      local sum_per_mp = 0
      local avg_raid_mp
      for i = 1, n do
        unit = "raid"..i
        if(UnitIsDead(unit)) then
          c = c + 1
        elseif(UnitIsGhost(unit)) then
          c = c + 1
        elseif(not UnitIsConnected(unit)) then
          c = c + 1
        elseif(UnitPowerType(unit) > 0) then
          c = c + 1
        else
          act_mp = UnitMana(unit);
          max_mp = UnitManaMax(unit);
          per_mp = floor(act_mp/max_mp*100)
          sum_per_mp = sum_per_mp + per_mp
        end
      end
      d = n - c
      if d == 0 then
        avg_raid_mp = 0
      else    
        avg_raid_mp = floor(sum_per_mp / d)
      end
      -- avg_raid_mp liefert den % MP wert des Raids, offline, tote, ghosts oder klassen ohne Powertype=0 werden nicht gewertet
    end
  end
  
  function addon:rf_checkdead()
    local n = GetNumRaidMembers()  
    if n > 0 then
      local c = 0
      local unit
      local i
      for i = 1, n do
        unit = "raid"..i
        if(UnitIsDead(unit)) then
          c = c + 1
        end
      end
      -- c liefert Anzahl an toten
    end
  end
  
  function addon:rf_checkghosts()
    local n = GetNumRaidMembers()  
    if n > 0 then
      local c = 0
      local unit
      local i
      for i = 1, n do
        unit = "raid"..i
        if(UnitIsGhost(unit)) then
          c = c + 1
        end
      end
      -- c liefert Anzahl an ghosts
    end
  end
  
  function addon:rf_checkoffline()
    local n = GetNumRaidMembers()  
    if n > 0 then
      local c = 0
      local unit
      local i
      for i = 1, n do
        unit = "raid"..i
        if(not UnitIsConnected(unit)) then
          c = c + 1
        end
      end
      -- c liefert Anzahl an Offline
    end
  end