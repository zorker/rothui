
  -- // rObjectiveTrackerMover
  -- // zork - 2014

  -----------------------------
  -- VARIABLES
  -----------------------------
  
  local an, at = ...
  local unpack = unpack  
  local ObjectiveTrackerFrame = ObjectiveTrackerFrame

  local frame = CreateFrame("Frame")
  
  local cfg = {}
  cfg.y = -75
 
  -----------------------------
  -- FUNCTIONS
  -----------------------------

  local function AdjustSetPoint(self,...)
    local a1,af,a2,x,y = ...
    if a1 and af == "MinimapCluster" then    
      if not InCombatLockdown() then
        self:SetPoint(a1,af,a2,x,cfg.y)
      else
        --print(an,"delaying setpoint because of combat")
        frame.point = {a1,af,a2,x,cfg.y}
        frame:RegisterEvent("PLAYER_REGEN_ENABLED")
      end      
    end
  end 

  frame:SetScript("OnEvent", function(self,event)
    self:UnregisterEvent(event)
    if event == "PLAYER_LOGIN" then
      self.point = {ObjectiveTrackerFrame:GetPoint()}      
      hooksecurefunc(ObjectiveTrackerFrame, "SetPoint", AdjustSetPoint)    
    end
    if not InCombatLockdown() then
      --print(an,"out of combat now, adjusting setpoint now")
      ObjectiveTrackerFrame:SetPoint(unpack(self.point))
    end
  end)
  
  frame:RegisterEvent("PLAYER_LOGIN")

