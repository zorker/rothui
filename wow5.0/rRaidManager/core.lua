
  ---------------------------------------------
  --  rRaidManager
  ---------------------------------------------

  --  A simple raid manager
  --  zork - 2013

  ---------------------------
  -- NAMESPACE
  ---------------------------

  local addon, ns = ...

  ---------------------------
  -- VARIABLES
  ---------------------------

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

  local TEX_WORLD_RAID_MARKERS = {}
  tinsert(TEX_WORLD_RAID_MARKERS, "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_6:14:14|t")
  tinsert(TEX_WORLD_RAID_MARKERS, "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_4:14:14|t")
  tinsert(TEX_WORLD_RAID_MARKERS, "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_3:14:14|t")
  tinsert(TEX_WORLD_RAID_MARKERS, "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7:14:14|t")
  tinsert(TEX_WORLD_RAID_MARKERS, "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:14:14|t")

  local previousButton

  ---------------------------
  -- FUNCTIONS
  ---------------------------

  --basic button func
  local function CreateBasicButton(parent, name, text, tooltipText)
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

  ---------------------------
  -- INIT
  ---------------------------

  --create manager frame
  local manager = CF("Frame", addon, UIP, "SecureHandlerStateTemplate")
  manager:SetFrameStrata("DIALOG")
  manager:SetSize(200,300)
  manager:SetPoint("TOPLEFT", -185, -180)
  manager:SetAlpha(0.4)
  manager:SetBackdrop(backdrop)
  manager:SetBackdropColor(0.1,0.1,0.1,0.9)
  manager:SetBackdropBorderColor(0.7,0.7,0.7)
  manager:RegisterEvent("PLAYER_LOGIN")
  manager:SetScript("OnEvent", BlizzardRaidFrameManagerDisable)
  RegisterStateDriver(manager, "visibility", "[group:party][group:raid] show; hide")

  --create world marker buttons
  for i=1, NUM_WORLD_RAID_MARKERS do
    local text = TEX_WORLD_RAID_MARKERS[i]
    local button = CreateBasicButton(manager, addon.."Button"..i, text, "WorldMarker"..i)
    button:SetAttribute("type", "macro")
    button:SetAttribute("macrotext", format("/wm %d", i))
    if not previousButton then
      button:SetPoint("TOPRIGHT", manager, -25, -10)
    else
      button:SetPoint("TOP", previousButton, "BOTTOM", 0, 0)
    end
    local cancelButton = CreateBasicButton(manager, addon.."Button"..i.."Cancel", "|TInterface\\Buttons\\UI-GroupLoot-Pass-Up:14:14:0:0|t", "Clear WorldMarker"..i)
    cancelButton:SetAttribute("type", "macro")
    cancelButton:SetAttribute("macrotext", format("/cwm %d", i))
    cancelButton:SetPoint("RIGHT", button, "LEFT", 0, 0)
    previousButton = button
  end

  --cancel all world markers button
  local button = CreateBasicButton(manager, addon.."ButtonWMCancel", "|TInterface\\Buttons\\UI-GroupLoot-Pass-Up:14:14:0:0|t", "Clear all world markers")
  button:SetScript("OnClick", ClearRaidMarker)
  button:SetPoint("TOP", previousButton, "BOTTOM", 0, 0)
  previousButton = button

  --rolecheck button
  local button = CreateBasicButton(manager, addon.."ButtonRoleCheck", "|TInterface\\LFGFrame\\LFGRole:14:14:0:0:64:16:32:48:0:16|t", "Role check")
  button:SetScript("OnClick", InitiateRolePoll)
  button:SetPoint("TOP", previousButton, "BOTTOM", 0, -10)
  previousButton = button
  
  --raid to party button
  local buttonLeft = CreateBasicButton(manager, addon.."ButtonRaidToParty", "|TInterface\\GroupFrame\\UI-Group-AssistantIcon:14:14:0:0|t", "Raid to party")
  buttonLeft:SetScript("OnClick", ConvertToParty)
  buttonLeft:SetPoint("RIGHT", button, "LEFT", 0, 0)

  --readycheck button
  local button = CreateBasicButton(manager, addon.."ButtonReady", "|TInterface\\RaidFrame\\ReadyCheck-Ready:14:14:0:0|t", "Ready check")
  button:SetScript("OnClick", DoReadyCheck)
  button:SetPoint("TOP", previousButton, "BOTTOM", 0, 0)
  previousButton = button

  --party to raid button
  local buttonLeft = CreateBasicButton(manager, addon.."ButtonPartyToRaid", "|TInterface\\GroupFrame\\UI-Group-LeaderIcon:14:14:0:0|t", "Party to raid")
  buttonLeft:SetScript("OnClick", ConvertToRaid)
  buttonLeft:SetPoint("RIGHT", button, "LEFT", 0, 0)

  --state frame
  local stateFrame = CF("BUTTON", addon.."stateFrame", manager, "SecureHandlerClickTemplate")
  stateFrame:SetPoint("TOPRIGHT",-3,-3)
  stateFrame:SetPoint("BOTTOMRIGHT",-3,3)
  stateFrame:SetWidth(15)
  
  --pull button
  local pullCounter = 10
  local button = CreateBasicButton(manager, addon.."ButtonPullCounter", "|TInterface\\TargetingFrame\\UI-TargetingFrame-Skull:14:14:0:0|t", "Boss pull in "..pullCounter)
  button:SetPoint("TOP", previousButton, "BOTTOM", 0, 0)  
  button:SetAttribute("type", "macro")  
  button:SetAttribute("macrotext", format("/pull %d", pullCounter))
  previousButton = button
  
  --stopwatch toggle
  local buttonLeft = CreateBasicButton(manager, addon.."ButtonStopWatch", "|TInterface\\ChatFrame\\UI-ChatIcon-ArmoryChat-AwayMobile:14:14:0:0|t", "Toggle stopwatch")
  buttonLeft:SetScript("OnClick", function()
    if Stopwatch_IsPlaying() then
      Stopwatch_Clear()
    else
      Stopwatch_Play()
    end    
    Stopwatch_Toggle()
  end)
  buttonLeft:SetPoint("RIGHT", button, "LEFT", 0, 0)

  --state frame texture
  local bg = stateFrame:CreateTexture(nil, "BACKGROUND", nil, -8)
  bg:SetAllPoints()
  bg:SetTexture(1,1,1)
  bg:SetVertexColor(1,1,1)
  bg:SetAlpha(0.05)
  stateFrame.bg = bg

  --state frame onenter
  stateFrame:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
    GameTooltip:AddLine("Click to toggle the raid manager", 0, 1, 0.5, 1, 1, 1)
    GameTooltip:Show()
  end)

  --state frame onleave
  stateFrame:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
  end)

  --state frame attribute secure onclick
  stateFrame:SetAttribute("_onclick", [=[
    local ref = self:GetFrameRef("manager")
    if not ref:GetAttribute("state") then
      ref:SetAttribute("state","closed")
    end
    local state = ref:GetAttribute("state")
    if state == "closed" then
      ref:SetAlpha(1)
      ref:SetWidth(275)
      ref:SetAttribute("state","open")
    else
      ref:SetAlpha(0.4)
      ref:SetWidth(200)
      ref:SetAttribute("state","closed")
    end
  ]=])

  --frame reference
  stateFrame:SetFrameRef("manager", manager)
