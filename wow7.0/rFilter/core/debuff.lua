
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

local function CreateDebuff(...)
  print("CreateDebuff",...)
end

for i, cfg in next, L.C.debuffs do
  CreateDebuff(unpack(cfg))
end