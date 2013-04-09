
  local addon, ns = ...

  --stuff

  local tinsert = tinsert
  local format = format
  local NUM_WORLD_RAID_MARKERS = NUM_WORLD_RAID_MARKERS
  local UIP = UIParent
  local CF = CreateFrame
  local CRFM = CompactRaidFrameManager
  local CRFC = CompactRaidFrameContainer

  --create the new manager
  local backdrop = {
    --bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    bgFile = "Interface\\Buttons\\WHITE8x8",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = false,
    tileSize = 16,
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 },
  }

  local manager = CF("Frame", addon, UIP)
  manager:SetSize(200,270)
  manager:SetPoint("TOPLEFT", -185, -180)
  manager:SetBackdrop(backdrop)
  manager:SetBackdropColor(0.1,0.1,0.1,0.9)
  manager:SetBackdropBorderColor(0.7,0.7,0.7)
  manager.state = "closed"
  manager.moved = false
  manager.minAlpha = 0.4
  manager.maxAlpha = 1
  manager.moveWidth = 75
  manager:SetAlpha(manager.minAlpha)

  --basic button func
  local createBasicButton = function(parent, name, text, tooltipText)
    local button = CF("Button", name, parent, "SecureActionButtonTemplate, UIPanelButtonTemplate")
    button.text = _G[button:GetName().."Text"]
    button.text:SetText(text)
    button:SetWidth(30)
    button:SetHeight(30)
    button:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_TOP")
      GameTooltip:AddLine(tooltipText, 0, 1, 0.5, 1, 1, 1)
      GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
    return button
  end

  local world_marker_textures = {}
  tinsert(world_marker_textures, "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_6:14:14|t")
  tinsert(world_marker_textures, "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_4:14:14|t")
  tinsert(world_marker_textures, "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_3:14:14|t")
  tinsert(world_marker_textures, "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7:14:14|t")
  tinsert(world_marker_textures, "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:14:14|t")

  local previousButton
  for i=1, NUM_WORLD_RAID_MARKERS do
    local text = world_marker_textures[i]
    local button = createBasicButton(manager, addon.."Button"..i, text, "WorldMarker"..i)
    button:SetAttribute("type", "macro")
    button:SetAttribute("macrotext", format("/wm %d", i))
    if not previousButton then
      button:SetPoint("TOPRIGHT", manager, -25, -10)
    else
      button:SetPoint("TOP", previousButton, "BOTTOM", 0, 0)
    end
    local cancelButton = createBasicButton(manager, addon.."Button"..i.."Cancel", "|TInterface\\Buttons\\UI-GroupLoot-Pass-Up:14:14:0:0|t", "Clear WorldMarker"..i)
    cancelButton:SetAttribute("type", "macro")
    cancelButton:SetAttribute("macrotext", format("/cwm %d", i))
    cancelButton:SetPoint("RIGHT", button, "LEFT", 0, 0)
    previousButton = button
  end

  --cancel button
  local button = createBasicButton(manager, addon.."ButtonCancel", "|TInterface\\Buttons\\UI-GroupLoot-Pass-Up:14:14:0:0|t", "Clear All WorldMarkers")
  button:SetScript("OnClick", ClearRaidMarker)
  button:SetPoint("TOP", previousButton, "BOTTOM", 0, 0)
  previousButton = button

  --ready button
  local button = createBasicButton(manager, addon.."ButtonReady", "|TInterface\\RaidFrame\\ReadyCheck-Ready:14:14:0:0|t", "Ready check")
  button:SetScript("OnClick", DoReadyCheck)
  button:SetPoint("TOP", previousButton, "BOTTOM", 0, -10)
  previousButton = button

  --rolecheck button
  local button = createBasicButton(manager, addon.."ButtonRoleCheck", "|TInterface\\LFGFrame\\LFGRole:14:14:0:0:64:16:32:48:0:16|t", "Role check")
  button:SetScript("OnClick", InitiateRolePoll)
  button:SetPoint("TOP", previousButton, "BOTTOM", 0, 0)
  previousButton = button

  --hover frame
  local hoverFrame = CF("BUTTON", addon.."HoverFrame", manager)
  hoverFrame:SetPoint("TOPRIGHT",-3,-3)
  hoverFrame:SetPoint("BOTTOMRIGHT",-3,3)
  hoverFrame:SetWidth(15)
  local tex = hoverFrame:CreateTexture(nil, "BACKGROUND", nil, -8)
  tex:SetAllPoints()
  tex:SetTexture(1,1,1)
  tex:SetVertexColor(1,1,1)
  tex:SetAlpha(0.05)
  hoverFrame.tex = tex
  manager.hover = hoverFrame

  hoverFrame:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
    if manager.state == "closed" then
      GameTooltip:AddLine("Click here to open the raid manager", 0, 1, 0.5, 1, 1, 1)
    else
      GameTooltip:AddLine("Click here to close the raid manager", 0, 1, 0.5, 1, 1, 1)
    end
    GameTooltip:Show()
  end)
  hoverFrame:SetScript("OnLeave", function(self)
    if manager.state == "closed" then
    end
    GameTooltip:Hide()
  end)

  hoverFrame:SetScript("OnClick", function(self)
    if manager.state == "closed" then
      manager:SetAlpha(manager.maxAlpha)
      manager:SetPoint("TOPLEFT", -185+manager.moveWidth, -180)
      manager.state = "open"
    else
      manager:SetAlpha(manager.minAlpha)
      manager:SetPoint("TOPLEFT", -185, -180)
      manager.state = "closed"
    end

  end)

  --remove the default raidframe manager
  local function BlizzardRaidFrameManagerDisable()
    CRFM:SetScript("OnLoad", nil)
    CRFM:SetScript("OnEvent", nil)
    CRFM:UnregisterAllEvents()
    CRFM:Hide()
    CRFC:SetScript("OnLoad", nil)
    CRFC:SetScript("OnEvent", nil)
    CRFC:SetScript("OnSizeChanged", nil)
    CRFC:UnregisterAllEvents()
  end

  manager:RegisterEvent("PLAYER_LOGIN")
  manager:SetScript("OnEvent", BlizzardRaidFrameManagerDisable)