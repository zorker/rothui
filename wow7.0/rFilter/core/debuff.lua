
-- rFilter: core/debuff
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- CreateDebuff
-----------------------------

function rFilter:CreateDebuff(spellid,unit,size,point,visibility,alpha,desaturate,caster)
  local button = L.F.CreateButton("debuff","DebuffButton",spellid,unit,size,point,visibility,alpha,desaturate,caster)
  if not button then return end
  table.insert(L.debuffs,button)
  return button
end
