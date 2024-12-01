-- rLib: core
-- zork, 2024

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

--copyTable
local function copyTable(orig)
  local orig_type = type(orig)
  local copy
  if orig_type == 'table' then
    copy = {}
    for orig_key, orig_value in next, orig, nil do
      copy[copyTable(orig_key)] = copyTable(orig_value)
    end
    setmetatable(copy, copyTable(getmetatable(orig)))
  else -- number, string, boolean, etc
    copy = orig
  end
  return copy
end
rLib.CopyTable = copyTable

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
