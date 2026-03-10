-- rIngameModelViewer - init
-- zork 2024
-----------------------------
-- Variables
-----------------------------
local A, L = ...

L.name = A
L.version = C_AddOns.GetAddOnMetadata(L.name, "Version")
L.versionNumber = tonumber(L.version) or 0
L.locale = GetLocale()

L.F = {} -- local functions
L.C = {} -- config
L.DB = {} -- database
