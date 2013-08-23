
--addon name and addon namespace
local addonName, ns = ...

--create the application object
local APP = CreateFrame("Frame")

--add a reference to your app to the addon namespace (so you can use it any of your lua files)
ns.app = APP

--local functions are private and only known for the lua file they live in
local function PrintHelloWorldLocal()
  print("Hello World Local")
end

--the next function not global and not local, it is part of your application and can be used in any lua file
function APP:PrintHelloWorldApp()
  print("Hello World App")
end

--the last one should be used very rarely since it polutes the global namespace
--this function can be called from any other addon since it is part of the global namespace
function PrintHelloWorldGlobal()
  print("Hello World Global")
end


--------------------------------
-- FUNCTIONS
--------------------------------

--addon load func
function APP:Load()
  self:SetScript("OnEvent", self.OnEvent)
  self:RegisterEvent("PLAYER_REGEN_ENABLED")
  self:RegisterEvent("PLAYER_REGEN_DISABLED")
end

--event handler function
--this may look wierd in first place but is very useful since it directs events automatically to the event functions that are registered to the app
function APP:OnEvent(event, ...)
  local action = self[event]
  if action then
    action(self, event, ...)
  end
end

function APP:PLAYER_REGEN_ENABLED()
  print("PLAYER LEAVES COMBAT")
end


function APP:PLAYER_REGEN_DISABLED()
  print("PLAYER ENTERS COMBAT")
end

--------------------------------
-- INIT
--------------------------------

--load the app
APP:Load()