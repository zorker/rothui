
  -- // rChat
  -- // zork - 2010
  
  -----------------------------
  -- INIT
  -----------------------------

  local _G = _G
  
  -----------------------------
  -- FUNCTIONS
  -----------------------------
  
  local function init()
  
    local num = FCF_GetNumActiveChatFrames()
    
    local mb = _G['ChatFrameMenuButton']
    if mb then 
      mb:Hide() 
      mb:HookScript("OnShow", function(s) s:Hide(); end)
    end
    
    local fmb = _G['FriendsMicroButton']
    if fmb then 
      fmb:Hide()
      fmb:HookScript("OnShow", function(s) s:Hide(); end)
    end

    ChatFontNormal:SetFont(NAMEPLATE_FONT, 12, "THINOUTLINE") 
    
    local bcq = _G["CombatLogQuickButtonFrame_Custom"];
    if bcq then
      bcq:Hide()
      bcq:HookScript("OnShow", function(s) s:Hide(); end)
      bcq:SetHeight(0)
    end  

    for i=1, num do      
      local bf = _G['ChatFrame'..i..'ButtonFrame']
      if bf then 
        bf:Hide() 
        bf:HookScript("OnShow", function(s) s:Hide(); end)
      end
      local ebtl = _G['ChatFrame'..i..'EditBoxLeft']
      if ebtl then ebtl:Hide() end
      local ebtm = _G['ChatFrame'..i..'EditBoxMid']
      if ebtm then ebtm:Hide() end      
      local ebtr = _G['ChatFrame'..i..'EditBoxRight']
      if ebtr then ebtr:Hide() end
      local cf = _G['ChatFrame'..i]
      if cf then cf:SetFont(NAMEPLATE_FONT, 12, "THINOUTLINE") end
      local eb = _G['ChatFrame'..i..'EditBox']
      if eb and cf then
        eb:ClearAllPoints()
        eb:SetPoint("BOTTOM",cf,"TOP",0,22)
        eb:SetPoint("LEFT",cf,-5,0)
        eb:SetPoint("RIGHT",cf,10,0)
        cf:SetMovable(true)
        cf:SetResizable(true)
        cf:SetUserPlaced(true)
        cf:SetClampRectInsets(0,0,0,0)
      end
    end
    
  end
  
  
  local a = CreateFrame("Frame")

  a:SetScript("OnEvent", function(self, event)
    if(event=="PLAYER_LOGIN") then
      init()
    end
  end)
  
  a:RegisterEvent("PLAYER_LOGIN")