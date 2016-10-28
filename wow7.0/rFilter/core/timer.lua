
-- rFilter: core/timer
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- CreateTimer
-----------------------------

if (#L.buffs + #L.debuffs + #L.raidbuffs + #L.cooldowns) == 0 then return end

local function Update()
  if #L.buffs > 0 then
    for i, button in next, L.buffs do
      L.F.UpdateBuff(button)
    end
  end
  if #L.debuffs > 0 then
    for i, button in next, L.debuffs do
      L.F.UpdateDebuff(button)
    end
  end
  if #L.raidbuffs > 0 then
    for i, button in next, L.raidbuffs do
      L.F.UpdateRaidbuff(button)
    end
  end
  if #L.cooldowns > 0 then
    for i, button in next, L.cooldowns do
      L.F.UpdateCooldown(button)
    end
  end
  C_Timer.After(L.C.tick, Update)
end
C_Timer.After(L.C.tick, Update)