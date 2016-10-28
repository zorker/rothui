
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

local function CreateCooldown(...)
  print("CreateCooldown",...)
end

for i, cfg in next, L.C.cooldowns do
  CreateCooldown(unpack(cfg))
end