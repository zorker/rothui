
-- rFilter_Zork: debuff
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Debuff Config
-----------------------------

if L.C.playerName == "Zörk" then
  rFilter:CreateDebuff(115767,"target",36,{"CENTER"},"[spec:3,combat]show;hide",{0.2,1},true,nil) --deep wounds
end