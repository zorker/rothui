  
  local addon, ns = ...
  local dragFrameList = ns.dragFrameList
  
  --create the frame to hold the buttons
  local frame = CreateFrame("Frame", "rPlayerPowerBarAlt", UIParent, "SecureHandlerStateTemplate")
  frame:SetSize(36,36)
  frame:SetPoint("CENTER")
  frame:SetScale(0.82)
 
  --move the buttons into position and reparent them
  PlayerPowerBarAlt:SetParent(frame)
  PlayerPowerBarAlt:EnableMouse(false)
  PlayerPowerBarAlt:ClearAllPoints()
  PlayerPowerBarAlt:SetPoint("CENTER")
  PlayerPowerBarAlt.ignoreFramePositionManager = true
  
  --simple drag func
  rCreateDragFrame(frame, dragFrameList, -2 , true) --frame, dragFrameList, inset, clamp
