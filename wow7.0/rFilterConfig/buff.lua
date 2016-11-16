
-- rFilterConfig: buff
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Buff Config
-----------------------------

if L.C.playerName == "Zörk" then
  --L.F.AddBuff(132404,"player",36,{"CENTER"},"[spec:3,combat]show;hide",{0.2,1},true,nil) --sb
  --L.F.AddBuff(190456,"player",36,{"CENTER"},"[combat]show;hide",{0.2,1},true,nil)
  L.F.AddBuff(184362,"player",36,{"CENTER"},"[spec:2,combat]show;hide",{0.2,1},true,nil) --enrage
end

