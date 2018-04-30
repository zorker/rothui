
-- oUF_SimpleConfig: init
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

--config container
L.C = {}
--tags and events
L.C.tagMethods = {}
L.C.tagEvents = {}
--make the config global
oUF_SimpleConfig = L.C
