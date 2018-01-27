
-- oUF_Orbs: core/init
-- zork, 2018

-----------------------------
-- Variables
-----------------------------

local A, L = ...

L.addonName       = A
L.dragFrames      = {}
L.addonColor      = "00FF3300"
L.addonShortcut   = "ouf_orbs"

--get the config
L.C = oUF_OrbsConfig

--mediapath
L.C.mediapath = "interface\\addons\\"..A.."\\media\\"
--size
if not L.C.size then
  L.C.size = 256
end

-----------------------------
-- rLib slash command
-----------------------------

--create slash commands
rLib:CreateSlashCmd(L.addonName, L.addonShortcut, L.dragFrames, L.addonColor)