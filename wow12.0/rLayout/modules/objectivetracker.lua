local A, L = ...

local OTFdisabled = false
local hiddenFrame = CreateFrame("Frame")
hiddenFrame:Hide()
 
--disable frame
local function DisableFrame(frame)
  if not frame then return false end
  --https://warcraft.wiki.gg/wiki/API_pcall
  return pcall(function()
    frame:UnregisterAllEvents()
    frame:SetParent(hiddenFrame)
    frame:Hide()
    frame:SetAlpha(0)
    frame:EnableMouse(false)
    if frame:HasScript("OnShow") then
      frame:HookScript("OnShow", function(self) self:Hide() end)
    end
  end)
end
L.F.DisableFrame = DisableFrame
 
--may return false in combat/protected, try again out of combat/later
local function DisableObjectiveTracker()
  if ObjectiveTrackerFrame and not OTFdisabled then
    OTFdisabled = DisableFrame(ObjectiveTrackerFrame)
  end
end
L.F.DisableObjectiveTracker = DisableObjectiveTracker