
-- rLib: core
-- zork, 2016

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
rLib.callbacksOnLogin = {}

-----------------------------
-- Functions
-----------------------------

--OnEvent PLAYER_LOGIN trigger all Callbacks
local function OnEvent(self,event)
  if event == "PLAYER_LOGIN" then
    for callback, args in next, rLib.callbacksOnLogin do
      callback(unpack(args))
    end
  end
end
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:SetScript("OnEvent", OnEvent)

--rLib:RegisterCallback
function rLib:RegisterCallbackOnLogin(callback,...)
  self.callbacksOnLogin[callback] = {...}
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
  local point = frame.defaultPoint
  if InCombatLockdown() then return end --sorry not in combat
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
  if InCombatLockdown() then return end --sorry not in combat
  frame:SetSize(frame.defaultSize.w,frame.defaultSize.h)
end

--L:UnlockFrame
function L:UnlockFrame(frame)
  if not frame then return end
  if not frame:IsUserPlaced() then return end
  frame.dragFrame:Show()
end

--L:LockFrame
function L:LockFrame(frame)
  if not frame then return end
  if not frame:IsUserPlaced() then return end
  frame.dragFrame:Hide()
end

--L:UnlockFrames
function L:UnlockFrames(frames)
  if not frames then return end
  for idx, frame in next, frames do
    self:UnlockFrame(frame)
  end
end

--L:LockFrames
function L:LockFrames(frames)
  if not frames then return end
  for idx, frame in next, frames do
    self:LockFrame(frame)
  end
end

--L:ResetFrames
function L:ResetFrames(frames)
  if not frames then return end
  for idx, frame in next, frames do
    self:ResetPoint(frame)
    self:ResetSize(frame)
  end
end

