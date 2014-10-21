
  -- // rObjectiveTrackerMover
  -- // zork - 2014

  -----------------------------
  -- FUNCTIONS
  -----------------------------
  
  ObjectiveTrackerFrame.ignoreFramePositionManager = true
  ObjectiveTrackerFrame:SetMovable(true)
  ObjectiveTrackerFrame:SetUserPlaced(false)
  
  local function AdjustSetPoint(self,...)
    local a1,af,a2,x,y = ...
    if af == "MinimapCluster" then    
      self:SetPoint(a1,af,a2,x,-75)
    end
  end
  
  hooksecurefunc(ObjectiveTrackerFrame, "SetPoint", AdjustSetPoint)
