
  -- Hello world function
  local function am(text)
    DEFAULT_CHAT_FRAME:AddMessage(text)
  end
  
  -- Create a local variable of the type Frame
  local a = CreateFrame("Frame")
  
  -- Register a Event on that Frame
  a:RegisterEvent("PLAYER_LOGIN")
  
  -- Set a script that will be run on a given Event
  a:SetScript("OnEvent", function(self,event)
    
    -- Unregister the Event, so that I will only be called once
    self:UnregisterEvent(event)
    
    -- Unset the Script
    self:SetScript("OnEvent", nil)    
    
    -- Call the Hello World function
    am("core3.lua: Hello World!")
    
  end)