local A, L = ...

L.name = A
L.version = C_AddOns.GetAddOnMetadata(L.name, "Version")
L.versionNumber = tonumber(L.version) or 0
L.locale = GetLocale()

L.C = {}
L.F = {}
L.eventFrame = CreateFrame("Frame")
