
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

local function CreateRaidbuff(...)
  print("CreateRaidbuff",...)
end

for i, cfg in next, L.C.raidbuffs do
  CreateRaidbuff(unpack(cfg))
end