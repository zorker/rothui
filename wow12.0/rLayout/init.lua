local A, L = ...

L.DB = {} --local database (filled from default on init then filled from savedVariables)
L.C = {}  --configurations
L.F = {}  --functions
L.S = {}  --settings
L.O = {}  --objects

L.name = A
L.version = C_AddOns.GetAddOnMetadata(L.name, "Version")
L.versionNumber = tonumber(L.version) or 0
L.dbversion = tonumber(C_AddOns.GetAddOnMetadata(L.name, "X-DB-Version")) or 1
L.locale = GetLocale()
L.eventFrame = CreateFrame("Frame")
L.mediaFolder = "Interface\\AddOns\\"..L.name.."\\media\\"
