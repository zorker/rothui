
-- rFilter: core/timer
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

local numBuffs, numDebuffs, numCooldowns = 0,0,0

-----------------------------
-- CreateTimer
-----------------------------

--optional function to change the tick
function rFilter:SetTick(tick)
  if type(tick) == "number" then
    L.tick = tick
  end
end

--Update function
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
  C_Timer.After(L.tick, Update)
end

--OnLogin function
local function OnLogin()
  numBuffs, numDebuffs, numCooldowns = #L.buffs, #L.debuffs, #L.cooldowns
  if (numBuffs + numDebuffs + numCooldowns) == 0 then return end
  Update()
end

--RegisterCallback PLAYER_LOGIN
rLib:RegisterCallback("PLAYER_LOGIN", OnLogin)