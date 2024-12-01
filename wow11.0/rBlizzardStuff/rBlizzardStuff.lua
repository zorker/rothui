-- rBlizzardStuff: core
-- zork, 2024

-----------------------------
-- Variables
-----------------------------

local A, L = ...

local faderConfig = {
  fadeInAlpha = 1,
  fadeInDuration = 0.3,
  fadeInSmooth = "OUT",
  fadeOutAlpha = 0,
  fadeOutDuration = 0.9,
  fadeOutSmooth = "OUT",
  fadeOutDelay = 0,
}

local faderConfigToast = {
  fadeInAlpha = 1,
  fadeInDuration = 0.3,
  fadeInSmooth = "OUT",
  fadeOutAlpha = 0.2,
  fadeOutDuration = 0.9,
  fadeOutSmooth = "OUT",
  fadeOutDelay = 0,
}

CHAT_TAB_HIDE_DELAY = 0
CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA = 1
CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 0
CHAT_FRAME_TAB_SELECTED_MOUSEOVER_ALPHA = 1
CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 0
CHAT_FRAME_TAB_ALERTING_MOUSEOVER_ALPHA = 1
CHAT_FRAME_TAB_ALERTING_NOMOUSE_ALPHA = 1

--gradient nameplate colors horizontally
local nameplateBorderColors = {
  tankwarning = {
    color = CreateColor(1, 1, 0, 1),
    alphaLeft = .9,
    alphaRight = .5
  },
  default = {
    color = CreateColor(0, 0, 0, 1),
    alphaLeft = .9,
    alphaRight = .3
  },
  selected = {
    color = CreateColor(1, 1, 1, 1),
    alphaLeft = .6,
    alphaRight = .2
  }
}
local nameplateBackgroundColor = CreateColor(0, 0, 0, .5)

local iconTexCoord = {0.12,0.92,0.12,0.92}

local vignettesDB = {}

-----------------------------
-- Functions
-----------------------------

--GetButtonList
local function GetButtonList(buttonName,numButtons)
  local buttonList = {}
  for i=1, numButtons do
    local button = _G[buttonName..i]
    if not button then break end
    table.insert(buttonList, button)
  end
  return buttonList
end

--AddActionButtonFader
local function AddActionButtonFader()
  local buttonName = "MultiBarRightButton"
  local buttonList = GetButtonList(buttonName, NUM_ACTIONBAR_BUTTONS)
  rLib:CreateButtonFrameFader(MultiBarRight, buttonList, faderConfig)
  local buttonName = "MultiBarLeftButton"
  local buttonList = GetButtonList(buttonName, NUM_ACTIONBAR_BUTTONS)
  rLib:CreateButtonFrameFader(MultiBarLeft, buttonList, faderConfig)
end

--SkinChat
local function SkinChat()
  for i = 1, NUM_CHAT_WINDOWS do
    local chatframe = _G["ChatFrame"..i]
    if not chatframe then return end
    chatframe:SetClampRectInsets(0, 0, 0, 0)
    local name = chatframe:GetName()
    --RegisterStateDriver(_G[name.."ButtonFrame"], "visibility", "[mod:ctrl] show; hide")
    _G[name.."ButtonFrame"]:Hide()
    _G[name.."EditBox"]:SetAltArrowKeyMode(false)
    _G[name.."EditBox"]:ClearAllPoints()
    _G[name.."EditBox"]:SetPoint("BOTTOMLEFT",chatframe,"TOPLEFT",QuickJoinToastButton:GetWidth(),ChatFrame1Tab:GetHeight()-3)
    _G[name.."EditBox"]:SetPoint("BOTTOMRIGHT",chatframe,"TOPRIGHT",20,0)
    _G[name.."EditBoxFocusLeft"]:SetAlpha(0.2)
    _G[name.."EditBoxFocusMid"]:SetAlpha(0.2)
    _G[name.."EditBoxFocusRight"]:SetAlpha(0.2)
    _G[name.."EditBoxLeft"]:SetAlpha(0.4)
    _G[name.."EditBoxMid"]:SetAlpha(0.4)
    _G[name.."EditBoxRight"]:SetAlpha(0.4)
  end
  --RegisterStateDriver(TextToSpeechButtonFrame, "visibility", "hide")
  TextToSpeechButtonFrame:Hide()
  ChatFrame1:ClearAllPoints()
  ChatFrame1:SetPoint("BOTTOMLEFT", 10, 10)
  QuickJoinToastButton:ClearAllPoints()
  QuickJoinToastButton:SetPoint("BOTTOMLEFT",ChatFrame1,"TOPLEFT",0,ChatFrame1Tab:GetHeight()-2)
  rLib:CreateFrameFader(QuickJoinToastButton, faderConfigToast)
end

--AddStateDriverToBlizzardFrames
local function AddStateDriverToBlizzardFrames()
  --state driver for PlayerFrame
  RegisterStateDriver(PlayerFrame, "visibility", "[petbattle] hide; [combat][mod:ctrl][@target,exists,nodead][@vehicle,exists][overridebar][shapeshift][vehicleui][possessbar] show; hide")
  --state driver for BagsBar
  RegisterStateDriver(BagsBar, "visibility", "[mod:ctrl] show; hide")
  --state driver for MicroMenuContainer
  RegisterStateDriver(MicroMenuContainer, "visibility", "[mod:ctrl] show; hide")
  --state driver for MicroButtonAndBagsBar
  RegisterStateDriver(MicroButtonAndBagsBar, "visibility", "[mod:ctrl] show; hide")
  --state driver for MainStatusTrackingBarContainer
  RegisterStateDriver(MainStatusTrackingBarContainer, "visibility", "[mod:alt] show; hide")
  --state driver for ObjectiveTrackerFrame
  RegisterStateDriver(ObjectiveTrackerFrame, "visibility", "[mod:alt] show; hide")
  --MultiBarBottomLeft
  RegisterStateDriver(MultiBarBottomLeft, "visibility", "[petbattle][vehicleui] hide; [combat][mod:shift][@target,exists,nodead] show; hide")
end

local function OnLogin()
  --add state drivers
  AddStateDriverToBlizzardFrames()
  --add mouse over fading for multi bars
  AddActionButtonFader()
  --skin chat
  SkinChat()
  --print(A,'hello')
end

rLib:RegisterCallback("PLAYER_LOGIN", OnLogin)

-------------------------------------------------------------
--Nameplate adjustments
-------------------------------------------------------------

local function SetBorderColor(frame, colorConfig)
  frame.HealthBarsContainer.background:SetVertexColor(nameplateBackgroundColor:GetRGBA())
  local r,g,b,a = colorConfig.color:GetRGBA()
  frame.HealthBarsContainer.border.Top:SetGradient("HORIZONTAL", CreateColor(r, g, b, colorConfig.alphaLeft), CreateColor(r, g, b, colorConfig.alphaRight))
  frame.HealthBarsContainer.border.Left:SetVertexColor(r, g, b, colorConfig.alphaLeft)
  frame.HealthBarsContainer.border.Right:SetVertexColor(r, g, b, colorConfig.alphaRight)
  frame.HealthBarsContainer.border.Bottom:SetGradient("HORIZONTAL", CreateColor(r, g, b, colorConfig.alphaLeft), CreateColor(r, g, b, colorConfig.alphaRight))
end

local function SetupNamePlateCastbar(frame)
  frame.castBar:SetHeight(frame.HealthBarsContainer:GetHeight()*1)
  frame.castBar.Icon:SetScale(frame.HealthBarsContainer:GetScale()*1.75)
  frame.castBar.Icon:SetTexCoord(unpack(iconTexCoord))
  frame.castBar.Icon:ClearAllPoints()
  PixelUtil.SetPoint(frame.castBar.Icon, "BOTTOMRIGHT", frame.castBar, "BOTTOMLEFT", -1, -1)
  frame.castBar.Text:ClearAllPoints()
  PixelUtil.SetPoint(frame.castBar.Text, "TOP", frame.castBar, "BOTTOM", 0, 0)
end

local function IsPlayerEffectivelyTank()
  local assignedRole = UnitGroupRolesAssigned("player")
  if ( assignedRole == "NONE" ) then
    local spec = GetSpecialization();
    return spec and GetSpecializationRole(spec) == "TANK"
  end
  return assignedRole == "TANK";
end

local function IsOnThreatList(threatStatus)
  return threatStatus ~= nil
end

local function UpdateNamePlateBorder(frame)
  local nameplate = C_NamePlate.GetNamePlateForUnit(frame.displayedUnit)
  if not nameplate then return end
  if IsInGroup() and IsPlayerEffectivelyTank() then
    local isTanking, threatStatus = UnitDetailedThreatSituation("player", frame.displayedUnit)
    if not isTanking and IsOnThreatList(threatStatus) then
      SetBorderColor(frame, nameplateBorderColors.tankwarning)
      return
    end
  end
  if UnitIsUnit(frame.displayedUnit, "target") then
    SetBorderColor(frame, nameplateBorderColors.selected)
    return
  end
  SetBorderColor(frame, nameplateBorderColors.default)
end

local function UpdateNamePlateClassificationIndicator(frame)
  local nameplate = C_NamePlate.GetNamePlateForUnit(frame.displayedUnit)
  if not nameplate then return end
  frame.classificationIndicator:Hide()
end

local function UpdateNamePlateSelectionHighlight(frame)
  local nameplate = C_NamePlate.GetNamePlateForUnit(frame.displayedUnit)
  if not nameplate then return end
  frame.selectionHighlight:Hide()
end

hooksecurefunc("CompactUnitFrame_UpdateHealthBorder", UpdateNamePlateBorder)
hooksecurefunc("CompactUnitFrame_UpdateClassificationIndicator", UpdateNamePlateClassificationIndicator)
hooksecurefunc("CompactUnitFrame_UpdateSelectionHighlight", UpdateNamePlateSelectionHighlight)
hooksecurefunc("DefaultCompactNamePlateFrameAnchorInternal", SetupNamePlateCastbar)

-------------------------------------------------------------
--Sell Junk
-------------------------------------------------------------

local function SellJunk()
  if C_MerchantFrame.GetNumJunkItems() > 0 then
    C_MerchantFrame.SellAllJunkItems()
  end
end

local function MerchantShow()
  SellJunk()
end

rLib:RegisterCallback("MERCHANT_SHOW", MerchantShow)

-------------------------------------------------------------
--Vignettes (rare chest and mob spawns)
-------------------------------------------------------------

local function VignetteAdded(event,id)
  if not id then return end
  if vignettesDB[id] then return end
  local vignetteInfo = C_VignetteInfo.GetVignetteInfo(id)
  if not vignetteInfo then return end
  if not vignetteInfo.onMinimap then return end
  local atlasInfo = C_Texture.GetAtlasInfo(vignetteInfo.atlasName)
  local left = atlasInfo.leftTexCoord * 256
  local right = atlasInfo.rightTexCoord * 256
  local top = atlasInfo.topTexCoord * 256
  local bottom = atlasInfo.bottomTexCoord * 256
  local str = "|TInterface\\MINIMAP\\ObjectIconsAtlas:0:0:0:0:256:256:"..(left)..":"..(right)..":"..(top)..":"..(bottom).."|t"
  PlaySoundFile(567397)
  if vignetteInfo.name ~= "Garrison Cache" and vignetteInfo.name ~= "Full Garrison Cache" then
    RaidNotice_AddMessage(RaidWarningFrame, str.." "..vignetteInfo.name.." spotted!", ChatTypeInfo["RAID_WARNING"])
    print(str.." "..vignetteInfo.name,"spotted!")
    vignettesDB[id] = true
  end
end

rLib:RegisterCallback("VIGNETTE_MINIMAP_UPDATED", VignetteAdded)
