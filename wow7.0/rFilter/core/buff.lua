
-- rFilter: core/buff
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- CreateBuff
-----------------------------

if not L.C.buffs or #L.C.buffs == 0 then return end

local function CreateBuff(spellid,unit,size,point,visibility,alpha,desaturate,caster)
  local button = L.F.CreateButton("buff","BuffButton",spellid,unit,size,point,visibility,alpha,desaturate,caster)
  if not button then return end
  table.insert(L.buffs,button)
end

for i, cfg in next, L.C.buffs do
  CreateBuff(unpack(cfg))
end