
-- rFilter: core/buff
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- CreateBuff
-----------------------------

function rFilter:CreateBuff(spellid,unit,size,point,visibility,alpha,desaturate,caster)
  local button = L.F.CreateButton("buff","BuffButton",spellid,unit,size,point,visibility,alpha,desaturate,caster)
  if not button then return end
  table.insert(L.buffs,button)
  return button
end
