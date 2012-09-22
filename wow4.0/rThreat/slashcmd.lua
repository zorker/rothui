 
  rThreat_Frames = {
    "rThreatDragFrame", 
  }
  
  local _, v
  
  function rThreat_unlockFrames()
    print("rThreat: Frames unlocked")
    for _, v in pairs(rThreat_Frames) do
      local f = _G[v]
      if f and f:IsUserPlaced() then
        --print(f:GetName())
        if f:IsShown() then
          f.visiblestatus = true
        else
          f.visiblestatus = false
        end
        f:Show()
        f.dragtexture:SetAlpha(0.4)
        f:EnableMouse(true)
        f:RegisterForDrag("LeftButton")
        f:SetScript("OnEnter", function(s) 
          GameTooltip:SetOwner(s, "ANCHOR_TOP")
          GameTooltip:AddLine(s:GetName(), 0, 1, 0.5, 1, 1, 1)
          GameTooltip:AddLine("Hold down ALT+SHIFT to drag!", 1, 1, 1, 1, 1, 1)
          GameTooltip:Show()
        end)
        f:SetScript("OnLeave", function(s) GameTooltip:Hide() end)
      end
    end
  end  
  
  function rThreat_lockFrames()
    print("rThreat: frames locked")
    for _, v in pairs(rThreat_Frames) do
      local f = _G[v]
      if f and f:IsUserPlaced() then
        if f.visiblestatus then
          f:Show()
        else
          f:Hide()
        end        
        f.dragtexture:SetAlpha(0)
        f:EnableMouse(nil)
        f:RegisterForDrag(nil)
        f:SetScript("OnEnter", nil)
        f:SetScript("OnLeave", nil)
      end
    end
  end
  
  local function SlashCmd(cmd)    
    if (cmd:match"unlock") then
      rThreat_unlockFrames()
    elseif (cmd:match"lock") then
      rThreat_lockFrames()
    else
      print("|c00FFAA00rThreat command list:|r")
      print("|c00FFAA00\/rthreat lock|r, to lock")
      print("|c00FFAA00\/rthreat unlock|r, to unlock")
    end
  end

  SlashCmdList["rthreat"] = SlashCmd;
  SLASH_rthreat1 = "/rthreat";
  
  print("|c00FFAA00rThreat loaded.|r")
  print("|c00FFAA00\/rthreat|r to display the command list")