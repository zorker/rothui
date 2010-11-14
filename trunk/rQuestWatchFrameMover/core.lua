
  -- // rQuestWatchFrameMover
  -- // zork - 2010
  
  -----------------------------
  -- INIT
  -----------------------------

  local _G = _G
  
  -----------------------------
  -- CONFIG
  -----------------------------
  
  local pos = { a1 = "TOPRIGHT", a2 = "TOPRIGHT", af = "UIParent", x = -100, y = -250 }
  local watchframeheight = 450

  -----------------------------
  -- FUNCTIONS
  -----------------------------

  --tooltip for icon func
  local function rQWFM_Tooltip(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP")
    GameTooltip:AddLine("Drag me!", 0, 1, 0.5, 1, 1, 1)
    GameTooltip:Show()
  end

  local function init()
    
    --make the quest watchframe movable
    local wf = _G['WatchFrame']
    wf:SetClampedToScreen(false)
    wf:SetMovable(1)
    wf:SetUserPlaced(true)
    wf:ClearAllPoints()	
    wf.ClearAllPoints = function() end
    wf:SetPoint(pos.a1,pos.af,pos.a2,pos.x,pos.y)
    wf.SetPoint = function() end
    wf:SetHeight(watchframeheight)  
        
    local wfl = _G['WatchFrameLines']
    wfl:HookScript("OnShow", function(s) 
      wf:SetHeight(watchframeheight)  
    end)
    wfl:HookScript("OnHide", function(s) 
      wf:SetHeight(50)  
    end)
    
    local wfh = _G['WatchFrameHeader']
    wfh:EnableMouse(true)
    wfh:RegisterForDrag("LeftButton")
    wfh:SetHitRectInsets(-15, -15, -5, -5)
    wfh:SetScript("OnDragStart", function(s) 
      local f = s:GetParent()
      f:StartMoving()
    end)
    wfh:SetScript("OnDragStop", function(s) 
      local f = s:GetParent()
      f:StopMovingOrSizing()
    end)
    wfh:SetScript("OnEnter", function(s) 
      rQWFM_Tooltip(s) 
    end)
    wfh:SetScript("OnLeave", function(s) 
      GameTooltip:Hide() 
    end)

  end

  local a = CreateFrame("Frame")

  a:SetScript("OnEvent", function(self, event)
    if(event=="PLAYER_LOGIN") then
      init()
    end
  end)
  
  a:RegisterEvent("PLAYER_LOGIN")