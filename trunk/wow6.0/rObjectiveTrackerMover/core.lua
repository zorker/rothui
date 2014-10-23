
  -- // rObjectiveTrackerMover
  -- // zork - 2014

  -----------------------------
  -- FUNCTIONS
  -----------------------------
  
  local an, at = ...
  local unpack = unpack  
  local ObjectiveTrackerFrame = ObjectiveTrackerFrame
  
  local frame = CreateFrame("Frame")

  frame:SetScript("OnEvent", function(self,event)
    self:UnregisterEvent(event)
    if not InCombatLockdown() then
      --print(an,"out of combat now, adjusting setpoint now")
      ObjectiveTrackerFrame:SetPoint(unpack(self.point))
    end
  end)

  local function AdjustSetPoint(self,...)
    local a1,af,a2,x,y = ...
    if a1 and af == "MinimapCluster" then    
      if not InCombatLockdown() then
        self:SetPoint(a1,af,a2,x,-75)
      else
        --print(an,"delaying setpoint because of combat")
        frame.point = {a1,af,a2,x,-75}
        frame:RegisterEvent("PLAYER_REGEN_ENABLED")
      end      
    end
  end
  
  hooksecurefunc(ObjectiveTrackerFrame, "SetPoint", AdjustSetPoint)
