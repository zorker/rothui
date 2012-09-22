
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
        f.dragframe:Show()
        f.dragframe:EnableMouse(true)
        f.dragframe:RegisterForDrag("LeftButton")
        f.dragframe:SetScript("OnEnter", function(s)
          GameTooltip:SetOwner(s, "ANCHOR_TOP")
          GameTooltip:AddLine(s:GetParent():GetName(), 0, 1, 0.5, 1, 1, 1)
          GameTooltip:AddLine("Hold down ALT+SHIFT to drag!", 1, 1, 1, 1, 1, 1)
          GameTooltip:Show()
        end)
        f.dragframe:SetScript("OnLeave", function(s) GameTooltip:Hide() end)
      end
    end
  end

  function rBFS_lockFrames()
    print("rBuffFrameStyler: frames locked")
    for _, v in pairs(rBFS_Frames) do
      f = _G[v]
      if f and f:IsUserPlaced() then
        f.dragframe:Hide()
        f.dragframe:EnableMouse(false)
        f.dragframe:RegisterForDrag(nil)
        f.dragframe:SetScript("OnEnter", nil)
        f.dragframe:SetScript("OnLeave", nil)
      end
    end
  end

  function rBFS_resetFrames()
    print("rBuffFrameStyler: frames reset")
    for _, v in pairs(rBFS_Frames) do
      local f = _G[v]
      if f and f.defaultPosition then
        f:ClearAllPoints()
        local pos = f.defaultPosition
        if pos.af and pos.a2 then
          f:SetPoint(pos.a1 or "CENTER", pos.af, pos.a2, pos.x or 0, pos.y or 0)
        elseif pos.af then
          f:SetPoint(pos.a1 or "CENTER", pos.af, pos.x or 0, pos.y or 0)
        else
          f:SetPoint(pos.a1 or "CENTER", pos.x or 0, pos.y or 0)
        end
      end
    end
  end

  local function SlashCmd(cmd)
    if (cmd:match"unlock") then
      rBFS_unlockFrames()
    elseif (cmd:match"lock") then
      rBFS_lockFrames()
    elseif (cmd:match"reset") then
      rBFS_resetFrames()
    else
      print("|c0000FFFFrBuffFrameStyler command list:|r")
      print("|c0000FFFF\/rbuff lock|r, to lock the buff holders")
      print("|c0000FFFF\/rbuff unlock|r, to unlock the buff holders")
      print("|c0000FFFF\/rbuff reset|r, to reset the buff holders")
    end
  end

  SlashCmdList["rbuff"] = SlashCmd;
  SLASH_rbuff1 = "/rbuff";

  print("|c0000FFFFrBuffFrameStyler loaded.|r")
  print("|c0000FFFF\/rbuff|r to display the command list")