local A, L = ...

print(A, 'orb.lua file init')

local orb = CreateFrame("Frame", "rOrbPlayerHealth", UIParent, "OrbTemplate")
orb:SetPoint("CENTER",-300,0)
--orb.FillingStatusBar:SetValue(0.5)