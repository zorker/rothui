
  oUF_Diablo_Bars = {
    "oUF_DiabloPlayerCastbar",
    "oUF_DiabloTargetCastbar",
    "oUF_DiabloFocusCastbar",
    "oUF_DiabloExpBar",
    "oUF_DiabloRepBar",
    "oUF_DemonicFuryPower",
    "oUF_DiabloHolyPower",
    "oUF_DiabloHarmonyPower",
    "oUF_DiabloShadowOrbPower",
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
      local f = _G[v]
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
      local f = _G[v]
      if f and f:IsUserPlaced() then
        f.dragframe:Hide()
        f.dragframe:EnableMouse(false)
        f.dragframe:RegisterForDrag(nil)
        f.dragframe:SetScript("OnEnter", nil)
        f.dragframe:SetScript("OnLeave", nil)
      end
    end
  end

  function oUF_DiabloReset(c)
    if InCombatLockdown() then
      print("Reseting frames is not possible in combat.")
      return
    end
    print("oUF_Diablo: "..c.." reset")
    local a
    if c == "art" then
      a = oUF_Diablo_Art
    elseif c == "bars" then
      a = oUF_Diablo_Bars
    elseif c == "units" then
      a = oUF_Diablo_Units
    end
    for _, v in pairs(a) do
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
    elseif (cmd:match"resetart") then
      oUF_DiabloReset("art")
    elseif (cmd:match"resetbars") then
      oUF_DiabloReset("bars")
    elseif (cmd:match"resetunits") then
      oUF_DiabloReset("units")
    else
      print("|c00FF3300oUF_Diablo command list:|r")
      print("|c00FF3300\/diablo lockart|r, to lock the art")
      print("|c00FF3300\/diablo unlockart|r, to unlock the art")
      print("|c00FF3300\/diablo lockbars|r, to lock the bars")
      print("|c00FF3300\/diablo unlockbars|r, to unlock the bars")
      print("|c00FF3300\/diablo lockunits|r, to lock the units")
      print("|c00FF3300\/diablo unlockunits|r, to unlock the units")
      print("|c00FF3300\/diablo resetart|r, to reset the art")
      print("|c00FF3300\/diablo resetbars|r, to reset the bars")
      print("|c00FF3300\/diablo resetunits|r, to reset the units")
    end
  end

  SlashCmdList["diablo"] = SlashCmd;
  SLASH_diablo1 = "/diablo";

  print("|c00FF3300oUF_Diablo loaded.|r")
  print("|c00FF3300\/diablo|r to display the command list")