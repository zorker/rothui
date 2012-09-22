
  rMMS_Frames = {
    "MinimapCluster",
  }

  function rMMS_unlockFrames()
    print("rMinimap: Frames unlocked")
    for _, v in pairs(rMMS_Frames) do
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

  function rMMS_lockFrames()
    print("rMinimap: frames locked")
    for _, v in pairs(rMMS_Frames) do
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

  function rMMS_resetFrames()
    print("rMinimap: frames reset")
    for _, v in pairs(rMMS_Frames) do
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
      rMMS_unlockFrames()
    elseif (cmd:match"lock") then
      rMMS_lockFrames()
    elseif (cmd:match"reset") then
      rMMS_resetFrames()
    else
      print("|c00AA99FFrMinimap command list:|r")
      print("|c00AA99FF\/rmm lock|r, to lock")
      print("|c00AA99FF\/rmm unlock|r, to unlock")
      print("|c00AA99FF\/rmm reset|r, to reset")
    end
  end

  SlashCmdList["rmm"] = SlashCmd;
  SLASH_rmm1 = "/rmm";
  SLASH_rmm2 = "/rminimap";

  print("|c00AA99FFrMinimap loaded.|r")
  print("|c00AA99FF\/rmm|r to display the command list")