
-- rLib: core
-- zork, 2019

-----------------------------
-- Variables
-----------------------------

local A, L = ...
L.addonName = A

-----------------------------
-- rLib Global
-----------------------------

rLib = {}
rLib.addonName = A

-----------------------------
-- Functions
-----------------------------

--CopyTable
local function CopyTable(orig)
  local orig_type = type(orig)
  local copy
  if orig_type == 'table' then
    copy = {}
    for orig_key, orig_value in next, orig, nil do
      copy[CopyTable(orig_key)] = CopyTable(orig_value)
    end
    setmetatable(copy, CopyTable(getmetatable(orig)))
  else -- number, string, boolean, etc
    copy = orig
  end
  return copy
end
rLib.CopyTable = CopyTable

--rLib:RegisterCallback
function rLib:RegisterCallback(event, callback, ...)
  if not self.eventFrame then
    self.eventFrame = CreateFrame("Frame")
    function self.eventFrame:OnEvent(event, ...)
      for callback, args in next, self.callbacks[event] do
        callback(args, ...)
      end
    end
    self.eventFrame:SetScript("OnEvent", self.eventFrame.OnEvent)
  end
  if not self.eventFrame.callbacks then self.eventFrame.callbacks = {} end
  if not self.eventFrame.callbacks[event] then self.eventFrame.callbacks[event] = {} end
  self.eventFrame.callbacks[event][callback] = {...}
  self.eventFrame:RegisterEvent(event)
end

--rLib:CallElementFunction
function rLib:CallElementFunction(element, func, ...)
  if element and func and element[func] then
    element[func](element, ...)
  end
end

--L:GetPoint
function L:GetPoint(frame)
  if not frame then return end
  local point = {}
  point.a1, point.af, point.a2, point.x, point.y = frame:GetPoint()
  if point.af and point.af:GetName() then
    point.af = point.af:GetName()
  end
  return point
end

--L:GetSize
function L:GetSize(frame)
  if not frame then return end
  local size = {}
  size.w, size.h = frame:GetWidth(), frame:GetHeight()
  return size
end

--L:ResetPoint
function L:ResetPoint(frame)
  if not frame then return end
  if not frame.defaultPoint then return end
  if InCombatLockdown() then return end
  local point = frame.defaultPoint
  frame:ClearAllPoints()
  if point.af and point.a2 then
    frame:SetPoint(point.a1 or "CENTER", point.af, point.a2, point.x or 0, point.y or 0)
  elseif point.af then
    frame:SetPoint(point.a1 or "CENTER", point.af, point.x or 0, point.y or 0)
  else
    frame:SetPoint(point.a1 or "CENTER", point.x or 0, point.y or 0)
  end
end

--L:ResetSize
function L:ResetSize(frame)
  if not frame then return end
  if not frame.defaultSize then return end
  if InCombatLockdown() then return end
  frame:SetSize(frame.defaultSize.w,frame.defaultSize.h)
end

--L:UnlockFrame
function L:UnlockFrame(frame)
  if not frame then return end
  if not frame:IsUserPlaced() then return end
  if frame.frameVisibility then
    if frame.frameVisibilityFunc then
      UnregisterStateDriver(frame,frame.frameVisibilityFunc)
    end
    RegisterStateDriver(frame, "visibility", "show")
  end
  frame.dragFrame:Show()
end

--L:LockFrame
function L:LockFrame(frame)
  if not frame then return end
  if not frame:IsUserPlaced() then return end
  if frame.frameVisibility then
    if frame.frameVisibilityFunc then
      UnregisterStateDriver(frame, "visibility")
      --hack to make it refresh properly, otherwise if you had state n (no vehicle exit button) it would not update properly because the state n is still in place
      RegisterStateDriver(frame, frame.frameVisibilityFunc, "zorkwashere")
      RegisterStateDriver(frame, frame.frameVisibilityFunc, frame.frameVisibility)
    else
      RegisterStateDriver(frame, "visibility", frame.frameVisibility)
    end
  end
  frame.dragFrame:Hide()
end

--L:UnlockFrames
function L:UnlockFrames(frames,str)
  if not frames then return end
  for idx, frame in next, frames do
    self:UnlockFrame(frame)
  end
  print(str)
end

--L:LockFrames
function L:LockFrames(frames,str)
  if not frames then return end
  for idx, frame in next, frames do
    self:LockFrame(frame)
  end
  print(str)
end

--L:ResetFrames
function L:ResetFrames(frames,str)
  if not frames then return end
  if InCombatLockdown() then
    print("|c00FF0000ERROR:|r "..str.." not allowed while in combat!")
    return
  end
  for idx, frame in next, frames do
    self:ResetPoint(frame)
    self:ResetSize(frame)
  end
  print(str)
end

