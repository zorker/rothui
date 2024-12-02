-- rBlizzardStuff/chat: chat adjustments
-- zork, 2024

-----------------------------
-- Variables
-----------------------------

local A, L = ...

CHAT_TAB_HIDE_DELAY = 0
CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA = 1
CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 0
CHAT_FRAME_TAB_SELECTED_MOUSEOVER_ALPHA = 1
CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 0
CHAT_FRAME_TAB_ALERTING_MOUSEOVER_ALPHA = 1
CHAT_FRAME_TAB_ALERTING_NOMOUSE_ALPHA = 1

local helper = CreateFrame("Frame")

local faderConfig = {
  fadeInAlpha = 1,
  fadeInDuration = 0.3,
  fadeInSmooth = "OUT",
  fadeOutAlpha = 0.2,
  fadeOutDuration = 0.9,
  fadeOutSmooth = "OUT",
  fadeOutDelay = 0,
}

local editBoxFocusAlpha = 0.2
local editBoxAlpha = 0.4

-----------------------------
-- Functions
-----------------------------

local function SetChatFrame1Position()
  ChatFrame1:ClearAllPoints()
  ChatFrame1:SetPoint("BOTTOMLEFT", 10, 10)
end

local function ApplyClamp(chatframe)
  helper.SetClampRectInsets(chatframe,0,0,0,0)
  if chatframe == ChatFrame1 then
    SetChatFrame1Position()
  end
end

local function UpdateToastPosition()
  QuickJoinToastButton:ClearAllPoints()
  QuickJoinToastButton:SetPoint("BOTTOMLEFT",ChatFrame1,"TOPLEFT",0,ChatFrame1Tab:GetHeight()-2)
end

--SkinChat
local function SkinChat()
  for i = 1, NUM_CHAT_WINDOWS do
    local chatframe = _G["ChatFrame"..i]
    if not chatframe then return end
    chatframe:SetClampRectInsets(0,0,0,0)
    hooksecurefunc(chatframe, "SetClampRectInsets", ApplyClamp)
    local name = chatframe:GetName()
    _G[name.."ButtonFrame"]:Hide()
    _G[name.."EditBox"]:SetAltArrowKeyMode(false)
    _G[name.."EditBox"]:ClearAllPoints()
    _G[name.."EditBox"]:SetPoint("BOTTOMLEFT",chatframe,"TOPLEFT",QuickJoinToastButton:GetWidth(),ChatFrame1Tab:GetHeight()-3)
    _G[name.."EditBox"]:SetPoint("BOTTOMRIGHT",chatframe,"TOPRIGHT",20,0)
    _G[name.."EditBoxFocusLeft"]:SetAlpha(editBoxFocusAlpha)
    _G[name.."EditBoxFocusMid"]:SetAlpha(editBoxFocusAlpha)
    _G[name.."EditBoxFocusRight"]:SetAlpha(editBoxFocusAlpha)
    _G[name.."EditBoxLeft"]:SetAlpha(editBoxAlpha)
    _G[name.."EditBoxMid"]:SetAlpha(editBoxAlpha)
    _G[name.."EditBoxRight"]:SetAlpha(editBoxAlpha)
  end
  TextToSpeechButtonFrame:Hide()
  SetChatFrame1Position()
  UpdateToastPosition()
  rLib:CreateFrameFader(QuickJoinToastButton, faderConfig)
end

rLib:RegisterCallback("PLAYER_LOGIN", SkinChat)

hooksecurefunc("FCF_SetButtonSide", UpdateToastPosition)
