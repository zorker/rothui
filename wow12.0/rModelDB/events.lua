local A, L = ...

local function OnPlayerLogin(...)
  L.F.CreateBuildDBButton()
end

local function OnVariablesLoaded(...)
  L.F.LoadDatabase()
end

L.eventFrame:RegisterEvent("PLAYER_LOGIN")
L.eventFrame:RegisterEvent("VARIABLES_LOADED")
L.eventFrame:SetScript("OnEvent", function(_, event, ...)
  if event == "PLAYER_LOGIN" then
    OnPlayerLogin(...)
  elseif event == "VARIABLES_LOADED" then
    OnVariablesLoaded(...)
  end
end)
