
-- rFilter: core/cooldown
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- CreateCooldown
-----------------------------

if not L.C.cooldowns or #L.C.cooldowns == 0 then return end

local function CreateCooldown(spellid,size,point,visibility,alpha,desaturate)
  local button = L.F.CreateButton("cooldown","CooldownButton",spellid,nil,size,point,visibility,alpha,desaturate,nil) --no unit and no caster
  if not button then return end
  table.insert(L.cooldowns,button)
end

for i, cfg in next, L.C.cooldowns do
  CreateCooldown(unpack(cfg))
end