
  -- // rObjectiveTrackerMover
  -- // zork - 2014

  -----------------------------
  -- FUNCTIONS
  -----------------------------

  local function ShowTooltip(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP")
    GameTooltip:AddLine("Drag me!", 0, 1, 0.5, 1, 1, 1)
    GameTooltip:Show()
  end
  
  local function HideTooltip(self)
    GameTooltip:Hide()
  end
  
  local function OnDragStart(self)
    self:GetParent():GetParent():StartMoving()
  end
  
  local function OnDragStop(self)
    self:GetParent():GetParent():StopMovingOrSizing()
  end

  local f = ObjectiveTrackerFrame
  f:SetClampedToScreen(false)
  f:SetMovable(true)
  f:SetUserPlaced(true)

  local dragFrame = CreateFrame("Frame",nil,ObjectiveTrackerBlocksFrame)
  dragFrame:EnableMouse(true)
  dragFrame:SetClampedToScreen(true)
  dragFrame:RegisterForDrag("LeftButton")
  dragFrame:SetPoint("TOPRIGHT",2,-24)
  dragFrame:SetSize(20,20)
  
  dragFrame.t = dragFrame:CreateTexture(nil,"OVERLAY",nil,-8)
  dragFrame.t:SetTexture("Interface\\Buttons\\LockButton-Border")
  dragFrame.t:SetVertexColor(0.5,0.5,0.5)
  dragFrame.t:SetAllPoints()  
  
  dragFrame.t2 = dragFrame:CreateTexture(nil,"OVERLAY",nil,-7)
  dragFrame.t2:SetTexture("Interface\\Buttons\\LockButton-Unlocked-Up")
  dragFrame.t2:SetAllPoints()
  
  dragFrame:SetScript("OnDragStart", OnDragStart)
  dragFrame:SetScript("OnDragStop", OnDragStop)
  dragFrame:SetScript("OnEnter", ShowTooltip)
  dragFrame:SetScript("OnLeave", HideTooltip)
  
  if not ObjectiveTrackerBlocksFrame.QuestHeader:IsShown() then
    dragFrame:Hide()
  end
  
  ObjectiveTrackerBlocksFrame.QuestHeader:HookScript("OnShow", function() dragFrame:Show() end)
  ObjectiveTrackerBlocksFrame.QuestHeader:HookScript("OnHide", function() dragFrame:Hide() end)
