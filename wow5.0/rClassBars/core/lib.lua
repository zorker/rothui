
  ---------------------------------------------
  -- LIB.lua
  ---------------------------------------------

  --get the addon namespace
  local addonName, ns = ...
  --library frame
  local lib = CreateFrame("Frame")
  --make the library available in the namespace
  ns.lib = lib

  --petbattle hider
  local PetbattleVehicleHider = CreateFrame("Frame", nil, UIParent)
  RegisterStateDriver(PetbattleVehicleHider, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show")  
  ns.PetbattleVehicleHider = PetbattleVehicleHider
  
  ---------------------------------------------
  -- FUNCTIONS
  ---------------------------------------------

