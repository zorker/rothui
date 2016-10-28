
-- rFilterConfig: functions
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Functions
-----------------------------

--AddBuff
local function AddBuff(spellid,unit,size,point,visibility,alpha,desaturate,playerOnly)
  table.insert(L.C.buffs,{spellid,unit,size,point,visibility,alpha,desaturate,playerOnly})
end
L.F.AddBuff = AddBuff

--AddDebuff
local function AddDebuff(spellid,unit,size,point,visibility,alpha,desaturate,playerOnly)
  table.insert(L.C.debuffs,{spellid,unit,size,point,visibility,alpha,desaturate,playerOnly})
end
L.F.AddDebuff = AddDebuff

--AddRaidBuff
local function AddRaidBuff(index,size,point,visibility,alpha,desaturate)
  table.insert(L.C.raidbuffs,{index,size,point,visibility,alpha,desaturate})
end
L.F.AddRaidBuff = AddRaidBuff

--AddCooldown
local function AddCooldown(spellid,size,point,visibility,alpha,desaturate)
  table.insert(L.C.cooldowns,{spellid,size,point,visibility,alpha,desaturate})
end
L.F.AddCooldown = AddCooldown