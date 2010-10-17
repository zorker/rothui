  
  --hide blizzard stuff

  local FramesToHide = {
    MainMenuBar, 
    MainMenuBarArtFrame, 
    BonusActionBarFrame, 
    VehicleMenuBar,
    PossessBarFrame,
  }  
  
  for _, f in pairs(FramesToHide) do
    if f:GetObjectType() == "Frame" then
      f:UnregisterAllEvents()
    end
    f:HookScript("OnShow", function(s) s:Hide(); end)
    f:Hide()
  end
  
  