
  rABS_Frames = {
    "rABS_MainMenuBar",
    "rABS_MultiBarBottomLeft",
    "rABS_MultiBarBottomRight",
    "rABS_MultiBarLeft",
    "rABS_MultiBarRight",
    "rABS_StanceBar",
    "rABS_PetBar",
    "rABS_VehicleExit",
    "rABS_Bags",
    "rABS_MicroMenu",
    "rABS_TotemBar",
    "rABS_ExtraActionBar",
  }

  function rABS_unlockFrames()
    print("rABS: Frames unlocked")
    for _, v in pairs(rABS_Frames) do
      local f = _G[v]
      if f and f:IsUserPlaced() then
        --print(f:GetName())
        if not f:IsShown() then
          f.state = "hidden"
          f:Show()
        end
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

  function rABS_lockFrames()
    print("rABS: frames locked")
    for _, v in pairs(rABS_Frames) do
      local f = _G[v]
      if f and f:IsUserPlaced() then
        f.dragframe:Hide()
        f.dragframe:EnableMouse(false)
        f.dragframe:RegisterForDrag(nil)
        f.dragframe:SetScript("OnEnter", nil)
        f.dragframe:SetScript("OnLeave", nil)
        if f.state == "hidden" then
          f:Hide()
        end
      end
    end
  end

  function rABS_resetFrames()
    print("rABS: frames reset")
    for _, v in pairs(rABS_Frames) do
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
      rABS_unlockFrames()
    elseif (cmd:match"lock") then
      rABS_lockFrames()
    elseif (cmd:match"reset") then
      rABS_resetFrames()
    else
      print("|c0000FF00rActionBarStyler command list:|r")
      print("|c0000FF00\/rabs lock|r, to lock all bars")
      print("|c0000FF00\/rabs unlock|r, to unlock all bars")
      print("|c0000FF00\/rabs reset|r, to reset all bars")
    end
  end

  SlashCmdList["rabs"] = SlashCmd;
  SLASH_rabs1 = "/rabs";

  print("|c0000FF00rActionBarStyler loaded.|r")
  print("|c0000FF00\/rabs|r to display the command list")