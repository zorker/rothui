local A, L = ...

local function OnPlayerLogin(...)

  local orb = CreateFrame("Frame", "rModelOrbTest", UIParent, "rModelOrbTemplate")
  orb:SetPoint("CENTER")
  --orb:SetScale(1)

  orb:LoadModelDataByID(394985)

  --/run rModelOrbTest:LoadModelDataByID(5144424)
  --/run rModelOrbTest:SetScale(0.5)
  --/run rModelOrbTest:LoadModelDataByID(394985)

end

local function OnVariablesLoaded(...)
  L.F.LoadDatabase()
end

L.eventFrame:RegisterEvent("PLAYER_LOGIN")
L.eventFrame:SetScript("OnEvent", function(_, event, ...)
  if event == "PLAYER_LOGIN" then
    OnPlayerLogin(...)
  end
end)
