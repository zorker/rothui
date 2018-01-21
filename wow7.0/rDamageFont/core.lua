
-- rDamageFont: core
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

local mediapath = "interface\\addons\\"..A.."\\media\\"
local font = mediapath.."damage.ttf"

DAMAGE_TEXT_FONT = font

--Login
local function Login()
  DAMAGE_TEXT_FONT = font
end

--RegisterCallback PLAYER_LOGIN
rLib:RegisterCallback("PLAYER_LOGIN", Login)