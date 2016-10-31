
-- rFilterConfig: cooldown
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Cooldown Config
-----------------------------

if L.C.playerName == "Zörk" then
  L.F.AddCooldown(23922,36,{"CENTER"},"[combat]show;hide",{0.2,1},true)
end