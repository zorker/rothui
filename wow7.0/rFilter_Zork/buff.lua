
-- rFilter_Zork: buff
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Buff Config
-----------------------------

if L.C.playerName == "Zörk" then
  local button = rFilter:CreateBuff(132404,"player",36,{"CENTER"},"[spec:3,combat]show;hide",{0.2,1},true,nil) --SB
  if button then table.insert(L.buffs,button) end
  local button = rFilter:CreateBuff(190456,"player",36,{"CENTER"},"[spec:3]show;hide",{0.2,1},true,nil) --IP
  if button then table.insert(L.buffs,button) end
  local button = rFilter:CreateBuff(184362,"player",36,{"CENTER"},"[spec:2,combat]show;hide",{0.2,1},true,nil) --enrage
  if button then table.insert(L.buffs,button) end
end

