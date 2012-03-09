
  rMMS_Frames = {
    "MinimapCluster",
  }

  function rMMS_unlockFrames()
    print("rMinimap: Frames unlocked")
    for _, v in pairs(rMMS_Frames) do
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

  function rMMS_lockFrames()
    print("rMinimap: frames locked")
    for _, v in pairs(rMMS_Frames) do
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
      rMMS_unlockFrames()
    elseif (cmd:match"lock") then
      rMMS_lockFrames()
    else
      print("|c00AA99FFrMinimap command list:|r")
      print("|c00AA99FF\/rmm lock|r, to lock")
      print("|c00AA99FF\/rmm unlock|r, to unlock")
    end
  end

  SlashCmdList["rmm"] = SlashCmd;
  SLASH_rmm1 = "/rmm";
  SLASH_rmm2 = "/rminimap";

  print("|c00AA99FFrMinimap loaded.|r")
  print("|c00AA99FF\/rmm|r to display the command list")