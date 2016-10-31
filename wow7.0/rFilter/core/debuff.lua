
-- rFilter: core/debuff
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- CreateDebuff
-----------------------------

if not L.C.debuffs or #L.C.debuffs == 0 then return end

local function CreateDebuff(spellid,unit,size,point,visibility,alpha,desaturate,caster)
  local button = L.F.CreateButton("debuff","DebuffButton",spellid,unit,size,point,visibility,alpha,desaturate,caster)
  if not button then return end
  table.insert(L.debuffs,button)
end

for i, cfg in next, L.C.debuffs do
  CreateDebuff(unpack(cfg))
end