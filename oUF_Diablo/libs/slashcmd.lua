
  oUF_Diablo_Bars = {
    "oUF_DiabloPlayerCastbar",
    "oUF_DiabloTargetCastbar",
    "oUF_DiabloFocusCastbar",
    "oUF_DiabloExpBar",
    "oUF_DiabloRepBar",
    "oUF_DiabloSoulShards",
    "oUF_DiabloHolyPower",
    "EclipseBarFrame",
    "oUF_DiabloRuneBar",
    "oUF_DiabloComboPoints",
    "oUF_DiabloPowerOrb", --special bar :)
  }

  oUF_Diablo_Units = {
    "oUF_DiabloPlayerFrame",
    "oUF_DiabloTargetFrame",
    "oUF_DiabloTargetTargetFrame",
    "oUF_DiabloPetTargetFrame",
    "oUF_DiabloPetFrame",
    "oUF_DiabloFocusTargetFrame",
    "oUF_DiabloFocusFrame",
    "oUF_DiabloRaid1Group1",
    "oUF_DiabloRaid1Group2",
    "oUF_DiabloRaid1Group3",
    "oUF_DiabloRaid1Group4",
    "oUF_DiabloRaid1Group5",
    "oUF_DiabloRaid1Group6",
    "oUF_DiabloRaid1Group7",
    "oUF_DiabloRaid1Group8",
    "oUF_DiabloRaid2Group1",
    "oUF_DiabloRaid2Group2",
    "oUF_DiabloRaid2Group3",
    "oUF_DiabloRaid2Group4",
    "oUF_DiabloRaid2Group5",
    "oUF_DiabloRaid2Group6",
    "oUF_DiabloRaid2Group7",
    "oUF_DiabloRaid2Group8",
    "oUF_DiabloRaid3Group1",
    "oUF_DiabloRaid3Group2",
    "oUF_DiabloRaid3Group3",
    "oUF_DiabloRaid3Group4",
    "oUF_DiabloRaid3Group5",
    "oUF_DiabloRaid3Group6",
    "oUF_DiabloRaid3Group7",
    "oUF_DiabloRaid3Group8",
    "oUF_DiabloPartyHeader",
    "oUF_DiabloBossFrame1",
    "oUF_DiabloBossFrame2",
    "oUF_DiabloBossFrame3",
    "oUF_DiabloBossFrame4",
    "oUF_DiabloBossFrame5",
  }

  oUF_Diablo_Art = {
    "oUF_DiabloActionBarBackground",
    "oUF_DiabloAngelFrame",
    "oUF_DiabloDemonFrame",
    "oUF_DiabloBottomLine",
    "oUF_DiabloPlayerPortrait",
    "oUF_DiabloTargetPortrait",
  }

  function oUF_DiabloUnlock(c)
    print("oUF_Diablo: "..c.." unlocked")
    local a
    if c == "art" then
      a = oUF_Diablo_Art
    elseif c == "bars" then
      a = oUF_Diablo_Bars
    elseif c == "units" then
      a = oUF_Diablo_Units
    end
    for _, v in pairs(a) do
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

  function oUF_DiabloLock(c)
    print("oUF_Diablo: "..c.." locked")
    local a
    if c == "art" then
      a = oUF_Diablo_Art
    elseif c == "bars" then
      a = oUF_Diablo_Bars
    elseif c == "units" then
      a = oUF_Diablo_Units
    end
    for _, v in pairs(a) do
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

  local function SlashCmd(cmd)
    if (cmd:match"unlockart") then
      oUF_DiabloUnlock("art")
    elseif (cmd:match"lockart") then
      oUF_DiabloLock("art")
    elseif (cmd:match"unlockbars") then
      oUF_DiabloUnlock("bars")
    elseif (cmd:match"lockbars") then
      oUF_DiabloLock("bars")
    elseif (cmd:match"unlockunits") then
      oUF_DiabloUnlock("units")
    elseif (cmd:match"lockunits") then
      oUF_DiabloLock("units")
    else
      print("|c00FF3300oUF_Diablo command list:|r")
      print("|c00FF3300\/diablo lockart|r, to lock the art")
      print("|c00FF3300\/diablo unlockart|r, to unlock the art")
      print("|c00FF3300\/diablo lockbars|r, to lock the bars")
      print("|c00FF3300\/diablo unlockbars|r, to unlock the bars")
      print("|c00FF3300\/diablo lockunits|r, to lock the units")
      print("|c00FF3300\/diablo unlockunits|r, to unlock the units")
    end
  end

  SlashCmdList["diablo"] = SlashCmd;
  SLASH_diablo1 = "/diablo";

  print("|c00FF3300oUF_Diablo loaded.|r")
  print("|c00FF3300\/diablo|r to display the command list")