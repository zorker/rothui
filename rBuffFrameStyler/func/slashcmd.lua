 
  rBFS_Frames = {
    "rBFS_BuffFrameHolder", 
    "rBFS_TempEnchantHolder", 
  }  
  
  function rBFS_unlockFrames()
    print("rBuffFrameStyler: Frames unlocked")
    for _, v in pairs(rBFS_Frames) do
      f = _G[v]
      if f and f:IsUserPlaced() then
        --print(f:GetName())
        f.dragtexture:SetAlpha(0.2)
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
  
  function rBFS_lockFrames()
    print("rBuffFrameStyler: frames locked")
    for _, v in pairs(rBFS_Frames) do
      f = _G[v]
      if f and f:IsUserPlaced() then
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
      rBFS_unlockFrames()
    elseif (cmd:match"lock") then
      rBFS_lockFrames()
    else
      print("|c0000FFFFrBuffFrameStyler command list:|r")
      print("|c0000FFFF\/rbuff lock|r, to lock the buff holders")
      print("|c0000FFFF\/rbuff unlock|r, to unlock the buff holders")
    end
  end

  SlashCmdList["rbuff"] = SlashCmd;
  SLASH_rbuff1 = "/rbuff";
  
  print("|c0000FFFFrBuffFrameStyler loaded.|r")
  print("|c0000FFFF\/rbuff|r to display the command list")