
-- rFilter_Zork: cooldown
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Cooldown Config
-----------------------------

if L.C.playerName == "Zörk" then
  --demo shout
  local button = rFilter:CreateCooldown(1160,36,{"CENTER"},"[spec:3,combat]show;hide",{0.2,1},true)
  if button then table.insert(L.cooldowns,button) end
end