  
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
  