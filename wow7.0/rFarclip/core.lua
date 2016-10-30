

-- rFarclip: core
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Call
-----------------------------

--get the current set farclip
local farclip = GetCVar("farclip")

--set farclip to min value
SetCVar("farclip",185)

--ResetFarclip
local function ResetFarclip()
  SetCVar("farclip",farclip)
end

--OnLogin
local function OnLogin()
  C_Timer.After(3, ResetFarclip)
end

--callback
rLib:RegisterCallback("PLAYER_LOGIN", OnLogin)