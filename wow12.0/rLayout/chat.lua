local A, L = ...

--config
local chatPosition = { "BOTTOMLEFT", 10, 10 }
local editBoxFocusAlpha = 0.8
local editBoxAlpha = 0
local quickJoinToastButtonAlpha = 0.3
local quickJoinToastButtonClamp = { -10,-10,-10,-10 }

--ApplyClamp
local function ApplyClamp(cf)
  L.eventFrame.SetClampRectInsets(cf,0,0,0,0)
end

--ApplyPoint
local function ApplyPoint(cf)
  L.eventFrame.ClearAllPoints(cf)
  L.eventFrame.SetPoint(cf, unpack(chatPosition))
end

--SkinChat
local function SkinChat(cf)
  local cfn = cf:GetName()
  local cbg   = _G[cfn.."Background"]
  local cbf   = _G[cfn.."ButtonFrame"]
  local ceb   = _G[cfn.."EditBox"]
  local cebfl = _G[cfn.."EditBoxFocusLeft"]
  local cebfm = _G[cfn.."EditBoxFocusMid"]
  local cebfr = _G[cfn.."EditBoxFocusRight"]
  local cebl  = _G[cfn.."EditBoxLeft"]
  local cebm  = _G[cfn.."EditBoxMid"]
  local cebr  = _G[cfn.."EditBoxRight"]
  if cbf then
    cbf:Hide()
  end
  ceb:SetAltArrowKeyMode(false)
  ceb:ClearAllPoints()
  ceb:SetPoint("BOTTOMLEFT",cbg,"TOPLEFT",QuickJoinToastButton:GetWidth(),20)
  ceb:SetPoint("BOTTOMRIGHT",cbg,"TOPRIGHT",0,20)
  cebfl:SetAlpha(editBoxFocusAlpha)
  cebfm:SetAlpha(editBoxFocusAlpha)
  cebfr:SetAlpha(editBoxFocusAlpha)
  cebl:SetAlpha(editBoxAlpha)
  cebm:SetAlpha(editBoxAlpha)
  cebr:SetAlpha(editBoxAlpha)
  cf:SetClampRectInsets(0,0,0,0)
  hooksecurefunc(cf, "SetClampRectInsets", ApplyClamp)
end

--SkinTempChat
local tempChatList = {}

local function SkinTempChat()
  for _, name in next, CHAT_FRAMES do
    local cf = _G[name]
    if cf and cf.isTemporary and not tempChatList[name] then
      SkinChat(cf)
      tempChatList[name] = true
    end
  end
end

hooksecurefunc("FCF_OpenTemporaryWindow", SkinTempChat)

--SkinChats
local function SkinChats()
  for i = 1, NUM_CHAT_WINDOWS do
    local cf = _G["ChatFrame"..i]
    if not cf then return end
    SkinChat(cf)
  end
  TextToSpeechButtonFrame:Hide()
  QuickJoinToastButton:SetClampedToScreen(true)
  QuickJoinToastButton:SetClampRectInsets(unpack(quickJoinToastButtonClamp))
  QuickJoinToastButton:SetAlpha(quickJoinToastButtonAlpha)
  ChatFrame1:ClearAllPoints()
  ChatFrame1:SetPoint(unpack(chatPosition))
  hooksecurefunc(ChatFrame1, "SetPoint", ApplyPoint)
end

L.F.SkinChats = SkinChats
