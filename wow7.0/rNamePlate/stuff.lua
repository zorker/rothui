
for i, group  in next, groups do
  for key, value in next, _G["DefaultCompactNamePlate"..group.."FrameOptions"] do
    print(group, key,value)
  end
end

print("==================")
print("NamePlateDriverFrame")
for key, value in next, NamePlateDriverFrame do
  print(key,value)
end

local function OnNamePlateCreated(args1, frame)
  print("==================")
  print("OnNamePlateCreated", frame)
  for key, value in next, frame do
    print(key,value)
  end
  print("------------------")
  print("printint nameplate.UnitFrame keys:")
  for key, value in next, frame.UnitFrame do
    print(key,value)
  end
  print("------------------")
  print("DefaultCompactNamePlateFrameSetUpOptions:")
  for key, value in next, DefaultCompactNamePlateFrameSetUpOptions do
    print(key,value)
  end

end

local function OnNamePlateUnitRemoved(args1, ...)
  --print("OnNamePlateUnitRemoved", C_NamePlate.GetNamePlateForUnit(...):GetName(), ...)
end

local function OnNamePlateUnitAdded(args1, ...)
  --print("OnNamePlateUnitAdded", C_NamePlate.GetNamePlateForUnit(...):GetName(), ...)
end

rLib:RegisterCallback("NAME_PLATE_CREATED", OnNamePlateCreated)
--rLib:RegisterCallback("NAME_PLATE_UNIT_REMOVED", OnNamePlateUnitRemoved)
--rLib:RegisterCallback("NAME_PLATE_UNIT_ADDED", OnNamePlateUnitAdded)