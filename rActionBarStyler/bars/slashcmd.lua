
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
      f = _G[v]
      if f and f:IsUserPlaced() then
        --print(f:GetName())
        if f:IsShown() then
          f.state = "shown"
        else
          f.state = "hidden"
          f:Show()
        end
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

  function rABS_lockFrames()
    print("rABS: frames locked")
    for _, v in pairs(rABS_Frames) do
      f = _G[v]
      if f and f:IsUserPlaced() then
        f.dragtexture:SetAlpha(0)
        f:EnableMouse(nil)
        f:RegisterForDrag(nil)
        f:SetScript("OnEnter", nil)
        f:SetScript("OnLeave", nil)
        if f.state == "hidden" then
          f:Hide()
        end
      end
    end
  end

  local function SlashCmd(cmd)
    if (cmd:match"unlock") then
      rABS_unlockFrames()
    elseif (cmd:match"lock") then
      rABS_lockFrames()
    else
      print("|c0000FF00rActionBarStyler command list:|r")
      print("|c0000FF00\/rabs lock|r, to lock all bars")
      print("|c0000FF00\/rabs unlock|r, to unlock all bars")
    end
  end

  SlashCmdList["rabs"] = SlashCmd;
  SLASH_rabs1 = "/rabs";

  print("|c0000FF00rActionBarStyler loaded.|r")
  print("|c0000FF00\/rabs|r to display the command list")