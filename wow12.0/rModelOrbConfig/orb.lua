-------------------------------------------------
-- Variables
-------------------------------------------------
local A, L = ...

-------------------------------------------------
-- CreateOrbPreview
-------------------------------------------------

local function CreateOrbPreview()

  local orb = CreateFrame("Frame", "rModelOrbPreview", UIParent, "rModelOrbTemplate")
  orb:SetPoint("CENTER")
  orb:LoadModelDataByID(2030216)
  orb.FillingStatusBar:SetValue(1)

  orb:EnableMouse(true)
  orb:SetClampedToScreen(true)

  orb:SetScript("OnMouseUp", function(self, button)
    if button == "RightButton" then
      return
    end
    if not L.canvas.isCanvas then
      L.canvas:Init()
    end
    L.canvas:Enable()
  end)

  for id, data in pairs(orb:GetAllModelData()) do
      data.id = id
      table.insert(L.sortedModels, data)
  end

  table.sort(L.sortedModels, function(a, b)
      return a.name:lower() < b.name:lower() -- :lower() ensures it handles any unexpected casing gracefully
  end)

  print(#L.sortedModels)

  for id, data in pairs(L.sortedModels) do
    print(id,data.id,data.name)
  end

end

L.eventFrame:RegisterEvent("PLAYER_LOGIN")
L.eventFrame:SetScript("OnEvent", function(_, event, ...)
  if event == "PLAYER_LOGIN" then
    CreateOrbPreview()
  end
end)
