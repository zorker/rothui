
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
  L.F.AddBuff(132404,"player",36,{"CENTER"},"[combat]show;hide",{0.2,1},true,"player")
  L.F.AddBuff(190456,"player",36,{"CENTER"},"[combat]show;hide",{0.2,1},true,nil)
end

