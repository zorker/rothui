
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
local function AddBuff(spellid,unit,size,position,visibility,alpha,desaturate,playerOnly)
  L.C.buff:insert({spellid=spellid,unit=unit,size=size,position=position,visibility=visibility,alpha=alpha,desaturate=desaturate,playerOnly=playerOnly})
end
L.F.AddBuff = AddBuff

--AddDebuff
local function AddDebuff(spellid,unit,size,position,visibility,alpha,desaturate,playerOnly)
  L.C.debuff:insert({spellid=spellid,unit=unit,size=size,position=position,visibility=visibility,alpha=alpha,desaturate=desaturate,playerOnly=playerOnly})
end
L.F.AddDebuff = AddDebuff

--AddRaidBuff
local function AddRaidBuff(index,size,position,visibility,alpha,desaturate)
  L.C.raidbuff:insert({index=index,size=size,position=position,visibility=visibility,alpha=alpha,desaturate=desaturate})
end
L.F.AddRaidBuff = AddRaidBuff

--AddCooldown
local function AddCooldown(spellid,size,position,visibility,alpha,playerOnly,desaturate)
  L.C.cooldown:insert({spellid=spellid,size=size,position=position,visibility=visibility,alpha=alpha,desaturate=desaturate})
end
L.F.AddCooldown = AddCooldown