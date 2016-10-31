
-- rFilter: core/timer
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

local numBuffs, numDebuffs, numCooldowns = #L.buffs, #L.debuffs, #L.cooldowns

-----------------------------
-- CreateTimer
-----------------------------

if (numBuffs + numDebuffs + numCooldowns) == 0 then return end

local function Update()
  if numBuffs > 0 then
    for i, button in next, L.buffs do
      L.F.UpdateBuff(button)
    end
  end
  if numDebuffs > 0 then
    for i, button in next, L.debuffs do
      L.F.UpdateDebuff(button)
    end
  end
  if numCooldowns > 0 then
    for i, button in next, L.cooldowns do
      L.F.UpdateCooldown(button)
    end
  end
  C_Timer.After(L.C.tick or 0.1, Update)
end
Update()