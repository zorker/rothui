
-- rFilter: core/raidbuff
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- CreateRaidbuff
-----------------------------

if not L.C.raidbuffs or #L.C.raidbuffs == 0 then return end

local function CreateRaidbuff(index,size,point,visibility,alpha,desaturate)
  local button = L.F.CreateButton("raidbuff","RaidbuffButton",index,nil,size,point,visibility,alpha,desaturate,nil) --no unit and no caster
  if not button then return end
  table.insert(L.raidbuffs,button)
end

for i, cfg in next, L.C.raidbuffs do
  CreateRaidbuff(unpack(cfg))
end