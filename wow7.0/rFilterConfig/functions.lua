
-- rFilterConfig: functions
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

--functions container
L.F = {}

-----------------------------
-- Functions
-----------------------------

--AddBuff
local function AddBuff(spellid,unit,size,point,visibility,alpha,desaturate,caster)
  table.insert(L.C.buffs,{spellid,unit,size,point,visibility,alpha,desaturate,caster})
end
L.F.AddBuff = AddBuff

--AddDebuff
local function AddDebuff(spellid,unit,size,point,visibility,alpha,desaturate,caster)
  table.insert(L.C.debuffs,{spellid,unit,size,point,visibility,alpha,desaturate,caster})
end
L.F.AddDebuff = AddDebuff

--AddCooldown
local function AddCooldown(spellid,size,point,visibility,alpha,desaturate)
  table.insert(L.C.cooldowns,{spellid,size,point,visibility,alpha,desaturate})
end
L.F.AddCooldown = AddCooldown