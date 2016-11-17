
-- rFilter: core/cooldown
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- CreateCooldown
-----------------------------

function rFilter:CreateCooldown(spellid,size,point,visibility,alpha,desaturate)
  local button = L.F.CreateButton("cooldown","CooldownButton",spellid,nil,size,point,visibility,alpha,desaturate,nil) --no unit and no caster
  if not button then return end
  table.insert(L.cooldowns,button)
  return button
end
